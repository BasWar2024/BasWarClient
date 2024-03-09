--- 
--@script gg.base.util.functions
--@author sundream
--@release 2018/12/25 10:30:00

gg = gg or {}

local callmeta = {}
callmeta.__call = function (func,...)
    local args = table.pack(...)
    if type(func) == "function" then
        return func(...)
    elseif type(func) ~= "table" then
        error("not callable")
    else
        local n = func.__args.n
        local allargs = {}
        for i = 1,n do
            allargs[i] = func.__args[i]
        end
        for i = 1,args.n do
            allargs[n+i] = args[i]
        end
        n = n + args.n
        return func.__fn(table.unpack(allargs,1,n))
    end
end

--- 
--@usage
-- local func = gg.functor(print,1,2,nil,nil)
-- func(4,5)    -- 1,2,nil,nil,4,5
-- func(7,8)    -- 1,2,nil,nil,7,8
-- func(7,nil,9,nil,nil)    -- 1,2,nil,nil,7,nil,9,nil,nil
-- local func2 = gg.functor(func,4,5,nil)
-- func2(5,nil,6,nil)   -- 1,2,nil,nil,4,5,nil,5,nil,6,nil
function gg.functor(func,...)
    assert(func,"cann't wrapper a nil func")
    local args = table.pack(...)
    local wrap = {}
    wrap.__fn = func
    wrap.__args = args
    wrap.__name = "functor"  -- flag
    setmetatable(wrap,callmeta)
    return wrap
end

function gg.is_functor(func)
    if type(func) == "table" and func.__name == "functor" then
        return true
    end
    return false
end

gg.collectVarNames = {
    linkid=true,linktype = true,fd=true,ip=true,pid=true,name=true,method=true,
    uuid=true,state=true,account=true,proto=true,cmd=true,addr=true,level=true,type=true,
    gate_node=true,gate_address=true,tag=true,node=true,id=true,cfgId=true,
    x=true,y=true,z=true,camp=true,
}

function gg.collectLocalVars(value,varname,isarg)
    if type(value) == "table" then
        local meta = getmetatable(value)
        if meta and meta.__tostring then
            return tostring(value)
        elseif value.__tostring then
            return value:__tostring()
        else
            local str = gg.dumptable(value)
            if str == nil and isarg then
                str = tostring(value)
            end
            return str
        end
    else
        if not isarg and not gg.collectVarNames[varname] then
            return nil
        end
        return tostring(value)
    end
end

function gg.dumptable(tbl)
    local list = {}
    for k in pairs(gg.collectVarNames) do
        if tbl[k] ~= nil then
            list[#list + 1] = string.format("%s=%s",k,tbl[k])
        end
    end
    if #list > 0 then
        return string.format("{%s}",table.concat(list,","))
    else
        return nil
    end
end

function gg.table2Str(table, name, tab)
    tab = tab or ""
    name = name or ""
    local str =  tab .. string.format("[%s]=\n", name) .. tab .. "{"
    local oneTab = "    |"
    if type(table) ~= "table" then
        return table
    end
    for key, value in pairs(table) do
        if type(value) ~= "table" then
            local item = string.format("%s=%s", key, value)
            str = str .."\n" .. tab .. oneTab .. item
        else
            local item = gg.table2Str(value, key, tab .. oneTab)
            str = str .. "\n" .. item
        end
    end
    return str .. "\n" .. tab .. "}"
end

--
function gg.printData(table, name)
    print(gg.table2Str(table, name))
end

--
local function unPackArgs(args, count, index, ...)
    if index > count then
        return ...
    end
    return args[index], unPackArgs(args, count, index + 1, ...)
end

function gg.bind(func, ...)
    local args = {...}
    local count = #args
    local f = function(...)
        return func(unPackArgs(args, count, 1, ...))
    end
    return f
end

function gg.setSpriteAsync(image, spriteName)
    ResMgr:LoadSpriteAsync(spriteName, function(sprite)
        if image.gameObject then
            image.sprite = sprite
        end
    end)
end

-- 
function gg.startCollectLocalVarsOnError()
    local traceback = require "traceback"
    traceback.register_collecter(function (value,varname,isarg)
        return gg.collectLocalVars(value,varname,isarg)
    end)
end

function gg.onerror(errmsg)
    if errmsg then
        errmsg = tostring(errmsg)
        local startpos = string.find(errmsg,"stack traceback:")
        if startpos then
            errmsg = string.sub(errmsg,1,startpos-1);
        end
    end
    local traceback = require "traceback"
    errmsg = traceback.traceback(errmsg,2)
    logger.logf("error",errmsg)
    return errmsg
end

--- ()
--@param[type=any] o 
--@return[type=any] 
function gg.copy(o)
    local typ = type(o)
    if typ ~= "table" then return o end
    local newtable = {}
    for k,v in pairs(o) do
        newtable[k] = v
    end
    local meta = getmetatable(o)
    if meta and not rawget(meta,"__nocopy") then
        setmetatable(newtable, meta)
    end
    return newtable
end


--- ()
--@param[type=any] o 
--@return[type=any] 
--@usage
-- deepcopy3:
-- 1. table
-- 2. metatable(metatable)
-- 3. keystable
function gg.deepcopy(o,seen)
    local typ = type(o)
    if typ ~= "table" then return o end
    seen = seen or {}
    if seen[o] then return seen[o] end
    local newtable = {}
    seen[o] = newtable
    for k,v in pairs(o) do
        newtable[gg.deepcopy(k,seen)] = gg.deepcopy(v,seen)
    end
    local meta = getmetatable(o)
    if meta and not rawget(meta,"__nocopy") then
        setmetatable(newtable, meta)
    end
    return newtable
end

--- 
--@param[type=int] num 
--@param[type=int,opt=1000000] limit 
--@param[type=func,opt] rand ,math.random
--@return[type=bool] true--,false--
--@usage local ok = gg.ishit(1,2)   -- 1/2
--@usage local ok = gg.ishit(1) -- 1/1000000
function gg.ishit(num,limit,rand)
    limit = limit or 1000000
    rand = rand or math.random
    assert(limit >= num)
    return rand(1,limit) <= num
end

--- (:list)
--@param[type=table] list 
--@param[type=int] num num,
--@param[type=func,opt] rand ,math.random
--@return[type=table] 
function gg.shuffle(list,num,rand)
    local len = #list
    num = num or len
    rand = rand or math.random
    local cnt = 0
    for i=1,len do
        local idx = rand(i,len)
        local tmp = list[idx]
        list[idx] = list[i]
        list[i] = tmp
        cnt = cnt + 1
        if cnt >= num then
            break
        end
    end
    return list
end

--- 
--@param[type=table] dct ,:{[1]=1,[2]=2,...}
--@param[type=func,opt] func ,
--@param[type=func,opt] rand ,math.random
--@return[type=any] 
--@usage
--  local dct = {[1]="one",[2]="two",[7]="seven"}       -- :1+2+7=10
--  -- one=1/10,two=2/10,seven=7/10
--  local val = gg.choosevalue(dct)
--  -- ,"one"0:2+7=9
--  -- : one=0/9,two=2/9,seven=7/9
--  local val = gg.choosevalue(dct,function (k,v) return v == "one" and 0 or k end)
function gg.choosevalue(dct,func,rand)
    rand = rand or math.random
    local sum = 0
    for ratio,val in pairs(dct) do
        sum = sum + (func and func(ratio,val) or ratio)
    end
    if sum == 0 then
        return nil
    end
    local hit = rand(1,sum)
    local limit = 0
    for ratio,val in pairs(dct) do
        limit = limit + (func and func(ratio,val) or ratio)
        if hit <= limit then
            return val
        end
    end
    return nil
end

--- 
--@param[type=table] dct ,:{[1]=1,[2]=2,...}
--@param[type=func,opt] func ,
--@param[type=func,opt] rand ,math.random
--@return[type=any] 
--@usage
--  local dct = {one=1,two=2,seven=7}       -- :1+2+7=10
--  -- one=1/10,two=2/10,seven=7/10
--  local val = gg.choosekey(dct)
--  -- ,"one"0:2+7=9
--  -- : one=0/9,two=2/9,seven=7/9
--  local val = gg.choosekey(dct,function (k,v) return k == "one" and 0 or v end)
function gg.choosekey(dct,func,rand)
    rand = rand or math.random
    local sum = 0
    for key,ratio in pairs(dct) do
        sum = sum + (func and func(key,ratio) or ratio)
    end
    if sum == 0 then
        return nil
    end
    local hit = rand(1,sum)
    local limit = 0
    for key,ratio in pairs(dct) do
        limit = limit + (func and func(key,ratio) or ratio)
        if hit <= limit then
            return key
        end
    end
    return nil
end

--- 
--@param[type=table] args 
--@param ... 
--@return[type=bool] true--,false--
--@return[type=table|string] (table):,(string):
--@usage
-- -- : string,int/int
-- local isok,args = gg.checkargs(args,"string","int")
-- -- : string,int/int,0/
-- local isok,args = gg.checkargs(args,"string","int","*")
-- -- : string,int/int,[1,5]
-- local isok,args = gg.checkargs(args,"string","int:[1,5]")
-- -- : string,double/double,[3.5,5.5]
-- local isok,args = gg.checkargs(args,"string","double:[3.5,5.5]")
function gg.checkargs(args,...)
    local typs = {...}
    if #typs == 0 then
        return true,args
    end
    local ret = {}
    for i = 1,#typs do
        if typs[i] == "*" then -- ignore check
            for j=i,#args do
                table.insert(ret,args[j])
            end
            return true,ret
        end
        if not args[i] then
            return nil,string.format("argument not enough(%d < %d)",#args,#typs)
        end
        local typ = typs[i]
        local range_begin,range_end
        local val
        local pos = string.find(typ,":")
        if pos then
            local precision = typ:sub(pos+1)
            typ = typ:sub(1,pos-1)
            range_begin,range_end = string.match(precision,"%[([%d.]*),([%d.]*)%]")
            if not range_begin then
                range_begin = math.mininteger
            end
            if not range_end then
                range_end = math.maxinteger
            end
            range_begin,range_end = tonumber(range_begin),tonumber(range_end)
        end
        if typ == "int" or typ == "double" then
            val = tonumber(args[i])
            if not val then
                return false,"invalid number:" .. tostring(args[i])
            end
            if typ == "int" then
                val = math.floor(val)
            end
            if range_begin and range_end then
                if not (range_begin <= val and val <= range_end) then
                    return false,string.format("%s not in range [%s,%s]",val,range_begin,range_end)
                end
            end
            table.insert(ret,val)
        elseif typ == "boolean" then
            typ = string.lower(typ)
            if not (typ == "true" or typ == "false" or typ == "1" or typ == "0") then
                return false,"invalid boolean:" .. tostring(typ)
            end
            val = (typ == "true" or typ == "1") and true or false
            table.insert(ret,val)
        elseif typ == "string" then
            val = tostring(args[i])
            table.insert(ret,val)
        else
            return false,"unknow type:" ..tostring(typ)
        end
    end
    return true,ret
end

--- 
--@usage
--:
--  1. : 0--,0--
--  2. : trueyes--,--
--  3. : true--,false--
--  4. : 
function gg.istrue(val)
    if val then
        if type(val) == "number" then
            return val ~= 0
        elseif type(val) == "string" then
            val = string.lower(val)
            return val == "true" or val == "yes"
        elseif type(val) == "boolean" then
            return val
        end
    end
    return false
end

local function getcmd(t,cmd)
    local _cmd = string.format("return %s",cmd)
    t[cmd] = load(_cmd,"=(load)","bt",_G)
    return t[cmd]
end
local compile_cmd = setmetatable({},{__index=getcmd})


--- 
--@param[type=string] cmd ,"string.len"
--@param ... 
--@return[type=table]
--@usage
--  local pack_data = gg.pack_function("string.len","hello")
--  local func = gg.unpack_function(pack_data)
--  local len = func()  -- string.len("hello") => 5
function gg.pack_function(cmd,...)
    -- nil
    local n = select("#",...)
    local args = {...}
    local pack_data = {
        cmd = cmd,
        args = args,
        n = n,
    }
    return pack_data
end

--- 
--@param[type=table] pack_data gg.pack_function
--@return[type=func] 
--@usage
--  local pack_data = gg.pack_function("string.len","hello")
--  local func = gg.unpack_function(pack_data)
--  local len = func()  -- string.len("hello") => 5
function gg.unpack_function(pack_data)
    local cmd = pack_data.cmd
    local attrname,sep,funcname = string.match(cmd,"^(.*)([.:])(.+)$")
    -- e.g: cmd = print
    if not sep then
        attrname = "_G"
        sep = "."
        funcname = cmd
    end
    local args = pack_data.args
    local n = pack_data.n
    --local loadstr = string.format("return %s",attrname)
    --local chunk = load(loadstr,"(=load)","bt",_G)
    local chunk = compile_cmd[attrname]
    local caller = chunk()
    if sep == "." then
        return function ()
            local method = caller[funcname]
            return method(table.unpack(args,1,n))
        end
    else
        assert(sep == ":")
        return function ()
            local method = caller[funcname]
            return method(caller,table.unpack(args,1,n))
        end
    end
end


--- 
--@param[type=table|string] mod table:,string:
--@param[type=string] method ("."+":")
--@param ... 
--@return 
--@usage
--  local len = gg.exec(_G,"string.len","hello") -- 5
function gg.exec(mod,method,...)
    if type(mod) == "string" then
        mod = require (mod)
    end
    local attrname,sep,funcname = string.match(method,"^(.*)([.:])(.+)$")
    if sep == nil then
        attrname = ""
        sep = "."
        funcname = method
    end
    local caller
    if attrname ~= "" then
        local firstchar = attrname:sub(1,1)
        if firstchar == "." or firstchar == ":" then
            attrname = attrname:sub(2)
        else
            firstchar = "."
        end
        caller = table.getattr(mod,attrname)
        if not caller then
            local cmd = string.format("return _M%s%s",firstchar,attrname)
            local chunk = load(cmd,"=(load)","bt",{_M=mod})
            caller = chunk()
        end
    else
        caller = mod
    end
    local func = caller[funcname]
    if sep == "." then
        if type(func) == "function" then
            return func(...)
        else
            assert(select("#",...)==0,string.format("mod:%s,method:%s",mod,method))
            return func
        end
    else
        assert(sep == ":")
        return func(caller,...)
    end
end

--- 
--@param[type=string] code 
--@param[type=table] env 
--@return 
--@usage
--  local code = "return string.len('hello')"
--  local len = gg.eval(code)   -- 5
function gg.eval(code,env,...)
    local chunk
    if env == nil then
        chunk = load(code,"=(load)","bt")
    else
        chunk = load(code,"=(load)","bt",env)
    end
    return chunk(...)
end

--- 
--@param[type=function] oldfunc 
--@parma[type=string] oldname 
--@param[type=string] newname 
--@return 
--@usage
--local todo_delete_func = function () end
--todo_delete_func = gg.deprecated(todo_delete_func,"todo_delete_func","new_func")
function gg.deprecated(oldfunc,oldname,newname)
    return function (...)
        logger.print(string.format("%s() is deprecated,please use %s()",oldname,newname))
        return oldfunc(...)
    end
end

function gg.tostring(obj,depth)
    depth = depth or 0
    if depth >= 32 then
        error("can't tostring too depth table")
    end
    if type(obj) ~= "table" then
        return tostring(obj)
    end
    if rawget(obj,"__type") then  -- 
        return tostring(obj)
    end
    local cache = {}
    table.insert(cache,"{")
    for k,v in pairs(obj) do
        if type(k) == "number" then
            table.insert(cache,string.format("[%d]=%s,",k,gg.tostring(v,depth+1)))
        else
            local str = string.format("%s=%s,",gg.tostring(k,depth+1),gg.tostring(v,depth+1))
            table.insert(cache,str)
        end
    end
    table.insert(cache,"}")
    return table.concat(cache)
end

function gg.getms()
    local lutil = require "lutil"
    return lutil.getms()
end

function gg.timeit(count,func,...)
    local starttime = gg.getms()
    for i=1,count do
        func(...)
    end
    return gg.getms() - starttime
end

function reload(script)
    local scriptPath = script
    for k,v in pairs(package.loaded) do
        if (string.endswith(k, script)) then
            package.loaded[k] = nil
            scriptPath = k
            break
        end
    end

    return require(scriptPath)
end

if skynet then
-- skynet
if not skynet._getenv then
    skynet._getenv = skynet.getenv
    skynet.config = setmetatable({},{__index=function (self,k)
        local v = skynet._getenv(k)
        self[k] = v
        return v
    end})

    local custom = require "config.custom"
    for k,v in pairs(custom) do
        skynet.config[k] = v
    end
end

function skynet.getenv(key)
    if rawget(skynet.config,key) == nil then
        skynet.config[key] = skynet._getenv(key)
    end
    return skynet.config[key]
end

if not skynet._setenv then
    skynet._setenv = skynet.setenv
end

function skynet.setenv(key,value)
    if skynet.config[key] == nil then
        skynet.config[key] = value
    end
    skynet._setenv(key,value)
end

local skynet_starttime = skynet.starttime() * 1000
-- 
function skynet.timestamp()
    return skynet.now2() + skynet_starttime
end

--()
function skynet.current()
    return skynet.now() * 10
end

function skynet.globaladdress(harbor,address)
    harbor = harbor or skynet.getenv("index")
    address = address or skynet.self()
    harbor = harbor & 0xff
    address = address & 0x00ffffff
    return (harbor << 24) | address
end

function skynet.localaddress(node_address)
    node_address = node_address or skynet.self()
    return node_address & 0x00ffffff
end

function skynet.nodeid(node_address)
    return skynet.harbor(node_address)
end

function skynet.high32(uuid)
    return (uuid >> 32)
end

function skynet.low32(uuid)
    return uuid & 0xffffffff
end

function skynet.compose_uuid(nodeid,address,sequence)
    nodeid = (nodeid & 0xff) << 56
    address = (address & 0x00ffffff) << 32
    return nodeid | address | sequence
end

function skynet.decompose_uuid(uuid)
    local sequence = uuid & 0xffffffff
    uuid = uuid >> 32
    local address = uuid & 0x00ffffff
    local nodeid = uuid >> 24
    return nodeid,address,sequence
end

end -- if skynet