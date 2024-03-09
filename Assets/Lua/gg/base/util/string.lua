--- string
--@script gg.base.util.string
--@author sundream
--@release 2018/12/25 10:30:00

--- str,charsetcharset
--@param[type=string] str 
--@param[type=table,opt] charset ,
--@return[type=string] 
function string.ltrim(str,charset)
    local patten
    if charset then
        patten = string.format("^[%s]+",charset)
    else
        patten = string.format("^[ \t\n\r]+")
    end
    return string.gsub(str,patten,"")
end

--- str,charsetcharset
--@param[type=string] str 
--@param[type=table,opt] charset ,
--@return[type=string] 
function string.rtrim(str,charset)
    local patten
    if charset then
        patten = string.format("[%s]+$",charset)
    else
        patten = string.format("[ \t\n\r]+$")
    end

    return string.gsub(str,patten,"")
end

--- str,charsetcharset
--@param[type=string] str 
--@param[type=table,opt] charset ,
--@return[type=string] 
function string.trim(str,charset)
    str = string.ltrim(str,charset)
    return string.rtrim(str,charset)
end

--- 
function string.isdigit(str)
    local ret = pcall(tonumber,str)
    return ret
end

--- 16
--@param[type=string] str 
--@return[type=string] 16
function string.str2hex(str)
    assert(type(str) == "string")
    local list = {"0x"}
    for i=1,#str do
        list[#list+1] = string.format("%02x",string.byte(str,i,i))
    end
    return table.concat(list)
end

function string.hex2str(hex)
    local chars = {}
    for i=1,#hex,2 do
        chars[#chars+1] = string.char(tonumber(hex:sub(i,i+1),16))
    end
    return table.concat(chars,"")
end

local NON_WHITECHARS_PAT = "%S+"
--- 
--@param[type=string] str 
--@param[type=string,opt] pat ,
--@param[type=int,opt=-1] maxsplit ,-1
--@return[type=table] 
--@usage
--local str = "a.b.c"
--local list = string.split(str,".",1)  -- {"a","b"}
--local list = string.split(str,".")    -- {"a","b","c"}
function string.split(str,pat,maxsplit)
    pat = pat and string.format("[^%s]+",pat) or NON_WHITECHARS_PAT
    maxsplit = maxsplit or -1
    local ret = {}
    local i = 0
    for s in string.gmatch(str,pat) do
        if not (maxsplit == -1 or i <= maxsplit) then
            break
        end
        table.insert(ret,s)
        i = i + 1
    end
    return ret
end

function string.urlencodechar(char)
    return string.format("%%%02X",string.byte(char))
end

function string.urldecodechar(hexchar)
    return string.char(tonumber(hexchar,16))
end

function string.urlencode(str,patten,space2plus)
    patten = patten or "([^%w%.%- ])"
    str = string.gsub(str,patten,string.urlencodechar)
    if space2plus then
        str = string.gsub(str," ","+")
    end
    return str
end

function string.urldecode(str,plus2space)
    if plus2space then
        str = string.gsub(str,"+"," ")
    end
    str = string.gsub(str,"%%(%x%x)",string.urldecodechar)
    return str
end

local UTF8_LEN_ARR  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}

--- utf8
--@param[type=string] input utf8
--@return[type=int] utf8
function string.utf8len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr = UTF8_LEN_ARR
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

--- utf8
--@param[type=string] input utf8
--@return[type=table] utf8
function string.utf8chars(input)
    local len  = string.len(input)
    local left = len
    local chars  = {}
    local arr  = UTF8_LEN_ARR
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                table.insert(chars,string.sub(input,-left,-(left-i+1)))
                left = left - i
                break
            end
            i = i - 1
        end
    end
    return chars
end

--- 
--@param[type=string] str ,:"YYYY-mm-dd HH:MM:SS"
--@return[type=int] 
function string.totime(str)
    local year,mon,day,hour,min,sec = string.match(str,"^(%d+)[/-](%d+)[/-](%d+)%s+(%d+):(%d+):(%d+)$")

    return os.time({
        year = tonumber(year),
        month = tonumber(mon),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec),
    })
end

function string.basename(path)
    local file = string.gsub(path,"^.*[/\\](.+)$","%1")
    local basename = string.gsub(file,"^(.+)%..+$","%1")
    return basename
end

function string.dirname(path)
    local dirname = string.gsub(path,"^(.*)[/\\].*$","%1")
    if dirname == path then
        return "."
    else
        return string.rtrim(dirname,"/\\")
    end
end

function string.extname(path)
    return path:match(".+%.(%w+)$")
end

-- 62
function string.gen62char()
    local map = {}
    for i=0,61 do
        local char
        if 10 <= i and i < 36 then
            char = string.char(65+i-10)
        elseif 36 <= i and i < 62 then
            char = string.char(97+i-36)
        else
            char = tostring(i)
        end
        map[i] = char
        map[char] = i
    end
    return map
end

-- 0-9A-Za-z
string.CHAR_MAP = string.gen62char()


--- 260-9
--@param[type=int] len 
--@return[type=string] 
function string.randomkey(len)
    len = len or 32
    local ret = {}
    local maxlen = 62
    for i=1,len do
        table.insert(ret,string.CHAR_MAP[math.random(0,maxlen-1)])
    end
    return table.concat(ret,"")
end

--- 
--@param[type=string] s 
--@param[type=string] prefix 
--@param[type=int,opt] from 
--@param[type=int,opt] to (),s[from:end]
function string.startswith(s,prefix,from,to)
    from = from or 1
    to = to or #s
    if from ~= 1 or to ~= #s then
        s = string.sub(s,from,to)
    end
    if string.sub(s,1,#prefix) == prefix then
        return true
    end
    return false
end

--- 
--@param[type=string] s 
--@param[type=string] suffix 
--@param[type=int,opt] from 
--@param[type=int,opt] to (),s[from:end]
function string.endswith(s,suffix,from,to)
    from = from or 1
    to = to or #s
    if from ~= 1 or to ~= #s then
        s = string.sub(s,from,to)
    end
    if string.sub(s,#s-#suffix+1,#s) == suffix then
        return true
    end
    return false
end

function string.gen_token(prefix)
    prefix = prefix or "token"
    return string.format("%s_%s_%s",prefix,skynet.hpc(),string.randomkey(8))
end