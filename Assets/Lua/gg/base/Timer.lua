local core = require "timer.core"
local Timer = class("Timer")

function Timer:ctor()
    self.timers = {}
    self.nameTimers = {}
    self.timerpool = {}
    self.id = 0
    self.time = 0 -- ""("")
    self.precision = 1000 -- "": ""
    self.cobj = core.create()
    self.attachers = {} -- ""

    -- cache
    self.ids = {}

    self.gameTime = 0
    self:startLoopTimer(0, 1, -1, function()
        self.gameTime = self.gameTime + 1
    end)
    self.buildLessTick = {}
end

function Timer:__gc()
    local cobj = self.cobj
    self.cobj = nil
    print("Timer:gc", cobj)
    if cobj then
        core.release(cobj)
    end
end

--- ""
-- @param[type=number] interval ""("","":"")
-- @param[type=function] callback ""
-- @return[type=integer] ""id
function Timer:startTimer(interval, callback)
    return self:addTimer(interval, callback)
end

--- ""
-- @param[type=integer] timerId ""id
function Timer:stopTimer(timerId)
    self:delTimer(timerId)
end

--- ""
-- @param[type=string] name ""
function Timer:cancelTimer(name)
    local ids = self.nameTimers[name]
    if not ids then
        return
    end
    for id in pairs(ids) do
        self:delTimer(id)
    end
end

--- ""
-- @param[type=number] delay ""("","":"")
-- @param[type=number] interval ""("","":"")
-- @param[type=number] maxCount ""(-1="",>0="")
-- @return[type=integer] ""id
function Timer:startLoopTimer(delay, interval, maxCount, callback)
    delay = delay < 0 and 0 or delay
    assert(interval > 0)
    local id = self:startTimer(delay, callback)
    local timerObj = self:getTimer(id)
    timerObj.maxCount = maxCount
    timerObj.interval = interval
    return id
end

--- ""crontab""
-- @param[type=string] cronExpr cron""
-- @param[type=function] callback ""
-- @return[type=integer] ""id
-- @usage gg.timer:cron_timeout("*/5 * * * * *",callback) <=> ""5s""callback
function Timer:startCronTimer(cronExpr, callback)
    local now = os.time()
    local nextTime = gg.cronexpr.nexttime(cronExpr, now)
    local timerId
    timerId = self:startTimer(nextTime, function()
        local timer = self:getTimer(timerId)
        timer.maxCount = timer.maxCount + 1
        now = os.time()
        local nextTime = gg.cronexpr.nexttime(cronExpr, now)
        timer.interval = nextTime - now
        callback()
    end)
    return timerId
end

--- ""
-- @param[type=number] elapse ""("","":"")
function Timer:update(elapse)
    local lastTime = math.floor(self.time * self.precision)
    local endTime = self.time + elapse
    local currentTime = math.floor(endTime * self.precision)
    local tick = currentTime - lastTime
    local pp = 1 / self.precision
    repeat
        local n, e = core.update(self.cobj, tick, self.ids)
        self.time = self.time + e * pp
        tick = tick - e
        for i = 1, n do
            local id = self.ids[i]
            local timer = self.timers[id]
            if timer then
                local attacher = self.attachers[id]
                if not attacher or attacher.obj then
                    xpcall(timer.callback, gg.onerror)
                    timer.count = timer.count + 1
                    if timer.maxCount < 0 or timer.count < timer.maxCount then
                        core.add(self.cobj, id, timer.interval * self.precision)
                    else
                        self:delTimer(id)
                    end
                else
                    self:delTimer(id)
                end
            end
        end
    until tick == 0
    self.time = endTime
end

--- ""("","":"")
-- @param[type=number] ""
function Timer:now()
    return self.time
end

--- ""/""
-- @param[type=integer] id ""id
-- @param[type=string,opt] name "","",""
-- @return[type=string|nil] nil="",""=""
function Timer:name(id, name)
    local timerObj = self:getTimer(id)
    if not timerObj then
        return
    end
    if name then
        local oldName = timerObj.name
        if oldName then
            self.timers[oldName][id] = nil
        end
        timerObj.name = name
        local ids = self.nameTimers[name]
        if not ids then
            ids = {}
        end
        ids[id] = true
        return oldName
    else
        return timerObj.name
    end
end

--- ""("")
-- @param[type=integer] id ""id
-- @param[type=table] obj ""
function Timer:attach(id, obj)
    self.attachers[id] = setmetatable({
        id = id,
        obj = obj
    }, {__mode == "v"})
end

-- private method

function Timer:genid()
    repeat
        self.id = self.id + 1
    until self.timers[self.id] == nil
    return self.id
end

function Timer:getTimer(timerId)
    return self.timers[timerId]
end

function Timer:addTimer(interval, callback)
    local id = self:genid()
    local timerObj = table.remove(self.timerpool)
    if not timerObj then
        timerObj = {}
    end
    timerObj.id = id
    timerObj.count = 0
    timerObj.maxCount = 1
    timerObj.startTime = self.time
    timerObj.interval = interval
    timerObj.callback = callback
    self.timers[id] = timerObj
    core.add(self.cobj, id, math.floor(interval * self.precision))
    return id
end

function Timer:delTimer(id)
    local timerObj = self:getTimer(id)
    if not timerObj then
        return
    end
    self.timers[id] = nil
    timerObj.callback = false
    self.timerpool[#self.timerpool + 1] = timerObj
    local name = timerObj.name
    if name then
        local ids = self.nameTimers[name]
        if ids then
            ids[id] = nil
        end
    end
    local attacher = self.attachers[id]
    if attacher then
        self.attachers[id] = nil
    end
end

-- ""gameTime
function Timer:saveLessTick(id, lessTick)
    if self.buildLessTick[id] then
        if lessTick ~= self.buildLessTick[id].lessTick then
            self.buildLessTick[id] = {
                lessTick = lessTick,
                gameTime = self.gameTime
            }
        end
    else
        self.buildLessTick[id] = {
            lessTick = lessTick,
            gameTime = self.gameTime
        }
    end

end

function Timer:getLessTick(id, lessTick)
    local temp = 0
    if self.buildLessTick[id] then
        if lessTick == self.buildLessTick[id].lessTick then
            temp = self.gameTime - self.buildLessTick[id].gameTime
        end
    end
    return temp
end

function Timer:releaseLessTick(id)
    self.buildLessTick[id] = nil
end

return Timer
