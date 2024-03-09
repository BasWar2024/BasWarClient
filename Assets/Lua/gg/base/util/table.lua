--- table
--@script gg.base.util.table
--@author sundream
--@release 2018/12/25 10:30:00

-- comptiable with lua51
unpack = unpack or table.unpack
table.unpack = unpack
if table.pack == nil then
    function table.pack(...)
        return {n=select("#",...),...}
    end
end

--- : 
--@param[type=table] set 
--@param[type=func] func 
--@return[type=bool] 
function table.any(set,func)
    for k,v in pairs(set) do
        if func(k,v) then
            return true,k,v
        end
    end
    return false
end

--- : 
--@param[type=table] set 
--@param[type=func] func 
--@return[type=bool] 
function table.all(set,func)
    for k,v in pairs(set) do
        if not func(k,v) then
            return false,k,v
        end
    end
    return true
end

--- 
--@param[type=table] tbl 
--@param[type=func] func 
--@return[type=table] 
function table.filter_dict(tbl,func)
    local newtbl = {}
    for k,v in pairs(tbl) do
        if func(k,v) then
            newtbl[k] = v
        end
    end
    return newtbl
end

--- 
--@param[type=table] list 
--@param[type=func] func 
--@return[type=table] 
function table.filter(list,func)
    local new_list = {}
    for i,v in ipairs(list) do
        if func(v) then
            table.insert(new_list,v)
        end
    end
    return new_list
end

--- 
function table.max(func,...)
    if type(func) ~= "function" then
        return math.max(...)
    end
    local args = table.pack(...)
    local max
    for i,arg in ipairs(args) do
        local val = func(arg)
        if not max or val > max then
            max = val
        end
    end
    return max
end

--- 
function table.min(func,...)
    if type(func) ~= "function" then
        return math.min(...)
    end
    local args = table.pack(...)
    local min
    for i,arg in ipairs(args) do
        local val = func(arg)
        if not min or val < min then
            min = val
        end
    end
    return min
end

function table.map(func,...)
    local args = table.pack(...)
    assert(#args >= 1)
    func = func or function (...)
        return {...}
    end
    local maxn = table.max(function (tbl)
            return #tbl
        end,...)
    local len = #args
    local newtbl = {}
    for i=1,maxn do
        local list = {}
        for j=1,len do
            table.insert(list,args[j][i])
        end
        local ret = func(table.unpack(list))
        table.insert(newtbl,ret)
    end
    return newtbl
end

--- 
--@param[type=table] tbl 
--@param[type=func] func /
--@return k,v 
function table.find(tbl,func)
    local isfunc = type(func) == "function"
    for k,v in pairs(tbl) do
        if isfunc then
            if func(k,v) then
                return k,v
            end
        else
            if func == v then
                return k,v
            end
        end
    end
end

--- 
--@param[type=table] t 
--@return[type=table] 
function table.keys(t)
    local ret = {}
    for k,v in pairs(t) do
        table.insert(ret,k)
    end
    return ret
end

--- 
--@param[type=table] t 
--@return[type=table] 
function table.values(t)
    local ret = {}
    for k,v in pairs(t) do
        table.insert(ret,v)
    end
    return ret
end

--- dump(,)
--@param[type=table] t 
--@return[type=string] dump
function table.dump(t,space,name)
    if type(t) ~= "table" then
        return tostring(t)
    end
    space = space or ""
    name = name or ""
    local cache = { [t] = "."}
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. string.rep(" ",#key),new_key))
            else
                table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return table.concat(temp,"\n"..space)
    end
    return _dump(t,space,name)
end

--- 
--@param[type=table] tbl 
--@param[type=string] attr 
--@return[type=any] 
--@raise 
--@usage local val = table.getattr(tbl,"key")
--@usage local val = table.getattr(tbl,"k1.k2.k3")
function table.getattr(tbl,attr)
    local attrs = type(attr) == "table" and attr or string.split(attr,".")
    local root = tbl
    for i,attr in ipairs(attrs) do
        root = root[attr]
    end
    return root
end

--- 
--@param[type=table] tbl 
--@param[type=string] attr 
--@return[type=bool] 
--@return[type=any] 
--@usage local exist,val = table.hasattr(tbl,"key")
--@usage local exist,val = table.hasattr(tbl,"k1.k2.k3")
function table.hasattr(tbl,attr)
    local attrs = type(attr) == "table" and attr or string.split(attr,".")
    local root = tbl
    local len = #attrs
    for i,attr in ipairs(attrs) do
        root = root[attr]
        if i ~= len and type(root) ~= "table" then
            return false
        end
    end
    return true,root
end

--- 
--@param[type=table] tbl 
--@param[type=string] attr 
--@param[type=any] val 
--@return[type=any] 
--@usage table.setattr(tbl,"key",1)
--@usage table.setattr(tbl,"k1.k2.k3","hi")
function table.setattr(tbl,attr,val)
    local attrs = type(attr) == "table" and attr or string.split(attr,".")
    local lastkey = table.remove(attrs)
    local root = tbl
    for i,attr in ipairs(attrs) do
        if nil == root[attr] then
            root[attr] = {}
        end
        root = root[attr]
    end
    local oldval = root[lastkey]
    root[lastkey] = val
    return oldval
end

--- 
--@param[type=table] tbl 
--@param[type=string] attr 
--@return[type=any] ,nil
--@usage local val = table.query(tbl,"key")
--@usage local val = table.query(tbl,"k1.k2.k3")
function table.query(tbl,attr)
    local exist,value = table.hasattr(tbl,attr)
    if exist then
        return value
    else
        return nil
    end
end

--- 
--@param[type=table] tbl 
--@return[type=bool] 
function table.isempty(tbl)
    if cjson and cjson.null == tbl then -- int64:0x0
        return true
    end
    if not tbl or not next(tbl) then
        return true
    end
    return false
end

--- (,0/"")
--@param[type=table] tbl 
--@return[type=bool] 
function table.isempty_ex(tbl)
    if table.isempty(tbl) then
        return true
    end
    local isempty = true
    for k,v in pairs(tbl) do
        local typ = type(v)
        if typ == "table" then
            if not table.isempty_ex(v) then
                isempty = false
            end
        elseif typ == "string" then
            if v ~= "" then
                isempty = false
            end
        elseif typ == "number" then
            if v ~= 0 and v ~= 0.0 then
                isempty = false
            end
        else
            isempty = false
        end
    end
    return isempty
end

--- 
--@param[type=table] tbl1 
--@param[type=table] tbl2 
--@return[type=table] 
function table.extend(tbl1,tbl2)
    for i,v in ipairs(tbl2) do
        table.insert(tbl1,v)
    end
    return tbl1
end

--- 
--@param[type=table] tbl1 
--@param[type=table] tbl2 
--@return[type=table] 
function table.update(tbl1,tbl2)
    for k,v in pairs(tbl2) do
        if type(v) == "table" then
            tbl1[k] = tbl1[k] or {}
            table.update(tbl1[k],v)
        else
            tbl1[k] = v
        end
    end
    return tbl1
end

--- 
--@param[type=table] tbl 
--@return[type=int] 
function table.count(tbl)
    local cnt = 0
    for k,v in pairs(tbl) do
        cnt = cnt + 1
    end
    return cnt
end

--- 
--@param[type=table] t 
--@param[type=any] val 
--@param[type=int,opt] maxcnt ,
--@return[type=table] 
function table.del_value(t,val,maxcnt)
    local delkey = {}
    for k,v in pairs(t) do
        if v == val then
            if not maxcnt or #delkey < maxcnt then
                delkey[#delkey+1] = k
            else
                break
            end
        end
    end
    for _,k in ipairs(delkey) do
        t[k] = nil
    end
    return delkey
end

--- 
--@param[type=table] list 
--@param[type=any] val 
--@param[type=int,opt] maxcnt ,
--@return[type=table] 
function table.remove_value(list,val,maxcnt)
    local len = #list
    maxcnt = maxcnt or len
    local delpos = {}
    for pos=len,1,-1 do
        if list[pos] == val then
            table.remove(list,pos)
            table.insert(delpos,pos)
            if #delpos >= maxcnt then
                break
            end
        end
    end
    return delpos
end

--- 
--@param[type=table] t 
--@return[type=table] 
function table.tolist(t)
    local ret = {}
    for k,v in pairs(t) do
        ret[#ret+1] = v
    end
    return ret
end

local function less_than(lhs,rhs)
    return lhs < rhs
end

--- [1,#t+1)>=val
function table.lower_bound(t,val,cmp)
    cmp = cmp or less_than
    local len = #t
    local first,last = 1,len + 1
    while first < last do
        local pos = math.floor((last-first) / 2) + first
        if not cmp(t[pos],val) then
            last = pos
        else
            first = pos + 1
        end
    end
    if last > len then
        return nil
    else
        return last
    end
end

--- [1,#t+1)>val
function table.upper_bound(t,val,cmp)
    cmp = cmp or less_than
    local len = #t
    local first,last = 1,len + 1
    while first < last do
        local pos = math.floor((last-first)/2) + first
        if cmp(val,t[pos]) then
            last = pos
        else
            first = pos + 1
        end
    end
    if last > len then
        return nil
    else
        return last
    end
end

--- 
--@param[type=any] lhs 1
--@param[type=any] rhs 2
--@return[type=bool] true--,false--
function table.equal(lhs,rhs)
    if lhs == rhs then
        return true
    end
    if type(lhs) == "table" and type(rhs) == "table" then
        if table.count(lhs) ~= table.count(rhs) then
            return false
        end
        local issame = true
        for k,v in pairs(lhs) do
            if not table.equal(v,rhs[k]) then
                issame = false
                break
            end
        end
        return issame
    end
    return false
end

--- 
--@param[type=table] list 
--@param[type=int] b 
--@param[type=int opt] e (),nil,b,b1
--@param[type=int opt=1] step 
--@return[type=table] 
--@usage
--local list = {1,2,3,4,5}
--local new_list = table.slice(list,1,3)  -- {1,2,3}
--local new_list = table.slice(list,1,5,2)  -- {1,3,5}
--local new_list = table.slice(list,-1,-5,-1)  -- {5,4,3,2,1}
function table.slice(list,b,e,step)
    step = step or 1
    if not e then
        e = b
        b = 1
    end
    e = math.min(#list,e)
    local new_list = {}
    local len = #list
    local idx
    for i = b,e,step do
        idx = i >= 0 and i or len + i + 1
        table.insert(new_list,list[idx])
    end
    return new_list
end


--- 
--@param[type=table] tbl 
--@return[type=table] 
function table.toset(tbl)
    tbl = tbl or {}
    local set = {}
    for i,v in ipairs(tbl) do
        set[v] = true
    end
    return set
end

--- 2
--@param[type=table] set1 1
--@param[type=table] set2 2
--@return[type=table] 
function table.intersect_set(set1,set2)
    local set = {}
    for k in pairs(set1) do
        if set2[k] then
            set[k] = true
        end
    end
    return set
end

--- 2
--@param[type=table] set1 1
--@param[type=table] set2 2
--@return[type=table] 
function table.union_set(set1,set2)
    local set = {}
    for k in pairs(set1) do
        set[k] = true
    end
    for k in pairs(set2) do
        if not set1[k] then
            set[k] = true
        end
    end
    return set
end

--- 2
--@param[type=table] set1 1
--@param[type=table] set2 2
--@return[type=table] set1-set2
function table.diff_set(set1,set2)
    local ret = {}
    local set = table.intersect_set(set1,set2)
    for k in pairs(set1) do
        if not set[k] then
            ret[k] = true
        end
    end
    return ret
end

--- 
--@param[type=table] tbl 
--@return[type=bool] true--,false--
function table.isarray(tbl)
    if type(tbl) ~= "table" then
        return false
    end
    local k = next(tbl)
    if k == nil then -- empty table
        return true
    end
    if k ~= 1 then
        return false
    else
        k = next(tbl,#tbl)
        return k == nil and true or false
    end
end

function table.simplify(o,seen)
    local typ = type(o)
    if typ ~= "table" then return o end
    seen = seen or {}
    if seen[o] then return seen[o] end
    local newtable = {}
    seen[o] = newtable
    for k,v in pairs(o) do
        --k = tostring(k)
        local tbl = table.simplify(v,seen)
        if type(tbl) ~= "table" then
            newtable[k] = tbl
        else
            for k1,v1 in pairs(tbl) do
                newtable[k.."_"..k1] = v1
            end
        end
    end
    return newtable
end

--- 
--@param[type=table] args 
--@param[type=table] descs 
--@param[type=bool,opt=false] strict ()
--@return[type=table|nil] table--,,nil--
--@return[type=string] nil,
--@usage:
--  local args,err = table.check(args,{
--      sign = {type="string"},
--      appid = {type="string"},
--      roleid = {type="number"},
--      image = {type="string"},
--  })
function table.check(args,descs,strict)
    local cjson = require "cjson"
    local new_args = {}
    for name,value in pairs(args) do
        local desc = descs[name]
        if desc then
            if desc.type == "number" then
                local new_value = tonumber(value)
                if new_value == nil then
                    return nil,string.format("<%s,%s>: ,expect '%s',got '%s'",name,value,desc.type,type(value))
                end
                if desc.min and desc.min > new_value then
                    return nil,string.format("<%s,%s>: (%s)",name,value,desc.min)
                end
                if desc.max and desc.max < new_value then
                    return nil,string.format("<%s,%s>: (%s)",name,value,desc.max)
                end
                new_args[name] = new_value
            elseif desc.type == "boolean" then
                local new_value
                if value == true or value == 1 or value == "true" or value == "on" or value == "yes" then
                    new_value = true
                else
                    new_value = false
                end
                new_args[name] = new_value
            elseif desc.type == "json" then
                local isok,new_value = pcall(cjson.decode,value)
                if not isok then
                    return nil,string.format("<%s,%s>: ,expect '%s',got '%s'",name,value,desc.type,type(value))
                end
                new_args[name] = new_value
            else
                local types = string.split(desc.type,"|")
                if not table.find(types,type(value)) then
                    return nil,string.format("<%s,%s>: ,expect '%s',got '%s'",name,value,desc.type,type(value))
                end
                new_args[name] = value
            end
        else
            if strict then
                return nil,string.format("<%s,%s>: ",name,value)
            else
                new_args[name] = value
            end
        end
        descs[name] = nil
    end
    if next(descs) then
        for name,desc in pairs(descs) do
            if not desc.optional then
                return nil,string.format(": %s",name)
            else
                new_args[name] = desc.default
            end
        end
    end
    return new_args,nil
end

--- 
--@param[type=table] list 
--@param[type=func,opt] rand ,math.random
--@return[type=any] 
--@return[type=int] 
function table.choose(list,rand)
    rand = rand or math.random
    local len = #list
    assert(len > 0,"list length need > 0")
    local pos = rand(1,len)
    return list[pos],pos
end

--- (),
--@param[type=table] dict 
--@param[type=string,opt="&"] join_str 
--@param[type=table,opt={}] exclude_keys 
--@param[type=table,opt={}] exclude_values 
--@return[type=string] +
--@usage
--local dict = {k1 = 1,k2 = 2}
--local str = table.ksort(dict,"&") -- k1=1&k2=2
function table.ksort(dict,join_str,exclude_keys,exclude_values)
    join_str = join_str or "&"
    exclude_keys = exclude_keys or {}
    exclude_values = exclude_values or {[""]=true,}
    local list = {}
    for k,v in pairs(dict) do
        if (not exclude_keys or not exclude_keys[k]) and
            (not exclude_values or not exclude_values[v]) then
            table.insert(list,{k,v})
        end
    end
    table.sort(list,function (lhs,rhs)
        return lhs[1] < rhs[1]
    end)
    local list2 = {}
    for i,item in ipairs(list) do
        table.insert(list2,string.format("%s=%s",item[1],item[2]))
    end
    return table.concat(list2,join_str)
end

--- 
--@param[type=table] tbl 
function table.clear(tbl)
    for k,v in pairs(tbl) do
        rawset(tbl,k,nil)
    end
end

--- 
--@param[type=any] elem 
--@param[type=int] count 
--@return[type=table] 
function table.rep(elem,count)
    local list = {}
    for i=1,count do
        list[#list+1] = elem
    end
    return list
end

--- [from,to]
--@param[type=int] from 
--@param[type=int] to 
--@return[type=table] 
function table.range(from,to)
    local list = {}
    for v = from, to do
        table.insert(list,v)
    end
    return list
end

--- nil
--@param[type=table] array 
--@param[type=mixed] value 
--@param[type=integer] begin ,1
--@return[type=integer|nil] ,nil
function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return nil
end

---  key nil
--@param[type=table] hashtable 
--@param[type=mixed] value 
--@return  key
function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

--- n
--@param[type=int] n n
--@param[type=table] tbl 
--@param[type=func] cmp (table.sort)
--@return[type=table] n
function table.sortN(n,tbl,cmp)
    local ret = {}
    local len = 0
    local function bubble(pos,v)
        while pos > 1 do
            if cmp(v,ret[pos-1]) then
                ret[pos] = ret[pos-1]
                pos = pos - 1
            else
                break
            end
        end
        ret[pos] = v
    end
    for k,v in pairs(tbl) do
        if len < n then
            len = len + 1
            bubble(len,v)
        elseif cmp(v,ret[len]) then
            bubble(len,v)
        end
    end
    return ret
end

function table.new(narr,nrec)
    return {}
end

local ok,lutil = pcall(require,"lutil")
if ok then
table.new = lutil.table_new
table.copy = lutil.table_copy
table.deepcopy = lutil.table_deepcopy
end