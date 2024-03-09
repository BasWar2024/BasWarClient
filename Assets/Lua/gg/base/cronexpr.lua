-- bit2^52,64int
--local bit = require "bit"

-- like linux cron expression
local cronexpr = {}
local LUA_VERSION_LE_502 = _VERSION < "Lua 5.3"

-- sec min hour dom mon dow
function cronexpr.new(expr)
    local fields = string.split(expr)
    local isok,self = pcall(cronexpr._new,fields)
    if not isok then
        error("Invalid cron expr:" .. tostring(expr))
    end
    return self
end

function cronexpr._new(fields)
    assert(#fields == 6)
    local self = setmetatable({},{__index=cronexpr})
    self.sec = cronexpr.parse_field(fields[1],0,59)
    self.min = cronexpr.parse_field(fields[2],0,59)
    self.hour = cronexpr.parse_field(fields[3],0,23)
    self.dom = cronexpr.parse_field(fields[4],1,31)
    self.mon = cronexpr.parse_field(fields[5],1,12)
    self.dow = cronexpr.parse_field(fields[6],0,6)  -- 0: 
    return self
end

-- cron
-- *
-- num              : means num-num/1
-- start-end        : means start-end/1
-- */step           : means min-max/step
-- start/step       : means start-max/step
-- start-end/step
function cronexpr.parse_field(field,min,max)
    --local int64 = 0
    -- fake u64int
    local int64
    if LUA_VERSION_LE_502 then
        int64 = {}
        for i=1,64 do
            table.insert(int64,0)
        end
    else
        int64 = 0
    end
    local fields = string.split(field,",")
    for i,field in ipairs(fields) do
        local startnum,endnum,step
        if field == "*" then
            startnum,endnum = min,max
            step = 1
        else
            local range_step = string.split(field,"/")
            assert(#range_step <= 2)
            if #range_step == 1 then
                step = 1
                local range = string.split(range_step[1],"-")
                assert(#range <= 2)
                startnum,endnum = tonumber(range[1]),tonumber(range[2])
                endnum = endnum or startnum
            else
                local range,step2 = range_step[1],range_step[2]
                step = tonumber(step2)
                if range == "*" then
                    startnum,endnum = min,max
                else
                    range = string.split(range,"-")
                    assert(#range <= 2)
                    startnum,endnum = tonumber(range[1]),tonumber(range[2])
                    endnum = endnum or max
                end
            end
        end
        assert(startnum)
        assert(endnum)
        assert(step)
        assert(startnum <= endnum)
        assert(min <= startnum and startnum <= max)
        assert(min <= endnum and endnum <= max)
        for num=startnum,endnum,step do
            --int64 = bit.bor(int64,bit.lshift(1,num))
            if LUA_VERSION_LE_502 then
                int64[num] = 1
            else
                int64 = int64 | (1 << num)
            end
        end
    end
    return int64
end


function cronexpr.nexttime(self,date)
    if type(self) == "string" then
        self = cronexpr.new(self)
    end
    if not date then
        date = os.date("*t")
    end
    if type(date) == "number" then
        date = os.date("*t",date)
    end
    -- croncron
    date = cronexpr.updatedate(date,{sec=date.sec+1})

    local curyear = date.year
    local binit = false
    ::retry::
    -- year
    if date.year > curyear + 1 then
        error("[fail] cronexpr.nexttime")
    end
    -- month
    while not cronexpr.match(date.month,self.mon) do
        if not binit then
            binit = true
            date = cronexpr.updatedate(date,{day=1,hour=0,min=0,sec=0})
        end
        date = cronexpr.updatedate(date,{month=date.month+1})
        if date.month == 1 then
            goto retry
        end
    end
    -- day
    while not cronexpr.matchday(self,date) do
        if not binit then
            binit = true
            date = cronexpr.updatedate(date,{hour=0,min=0,sec=0})
        end
        date = cronexpr.updatedate(date,{day=date.day+1})
        if date.day == 1 then
            goto retry
        end
    end
    -- hour
    while not cronexpr.match(date.hour,self.hour) do
        if not binit then
            binit = true
            date = cronexpr.updatedate(date,{min=0,sec=0})
        end
        date = cronexpr.updatedate(date,{hour=date.hour+1})
        if date.hour == 0 then
            goto retry
        end
    end
    -- min
    while not cronexpr.match(date.min,self.min) do
        if not binit then
            binit = true
            date = cronexpr.updatedate(date,{sec=0})
        end
        date = cronexpr.updatedate(date,{min=date.min+1})
        if date.min == 0 then
            goto retry
        end
    end
    -- sec
    while not cronexpr.match(date.sec,self.sec) do
        if not binit then
            binit = true
        end
        date = cronexpr.updatedate(date,{sec=date.sec+1})
        if date.sec == 0 then
            goto retry
        end
    end
    return os.time(date),date
end

local dom_0xfffffffe = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local dow_0x7f = {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

-- private method
function cronexpr.matchday(self,date)
    if type(date) == "number" then
        date = os.date("*t",date)
    end

    local weekday = date.wday - 1  -- date.wday: 1-- ,...7--
    -- day-of-month is '*'
    if LUA_VERSION_LE_502 then
        if table.equal(self.dom,dom_0xfffffffe) then
            return cronexpr.match(weekday,self.dow)
        end
    else
        if self.dom == 0xfffffffe then
            return cronexpr.match(weekday,self.dow)
        end
    end
    -- day-of-week is '*'
    if LUA_VERSION_LE_502 then
        if table.equal(self.dow,dow_0x7f) then
            return cronexpr.match(date.day,self.dom)
        end
    else
        if self.dow == 0x7f then
            return cronexpr.match(date.day,self.dom)
        end
    end
    return cronexpr.match(weekday,self.dow) or
        cronexpr.match(date.day,self.dom)
end

function cronexpr.match(num1,num2)
    --local result =  bit.band(bit.lshift(1,num1),num2)
    local result
    if LUA_VERSION_LE_502 then
        result = num2[num1] == 1
    else
        result = (num2 & (1 << num1)) ~= 0
    end
    return result
end

function cronexpr.updatedate(date,tbl)
    for k,v in pairs(tbl) do
        date[k] = v
    end
    -- recompute date
    return os.date("*t",os.time(date))
end

return cronexpr
