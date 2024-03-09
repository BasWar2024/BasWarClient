local RedPointBase = class("RedPointBase")

function RedPointBase:ctor()
-----ctor
    self.parentList = {}
    self.id = nil
    --self:setEventList({event1, event2})
-------
    self.isRed = false
    self.redMap = {}
end

function RedPointBase:setEventList(events)
    self.events = events
    local eventFunc = function ()
        self:check()
    end
    for i, eventName in ipairs(self.events) do
        self[eventName] = eventFunc
        gg.event:addListener(eventName, self)
    end
end

function RedPointBase:check()
    self:setRed(self.id, self:onCheck())
end

function RedPointBase:setRed(id, isRed)
    self.redMap[id] = isRed

    if not isRed then
        for key, value in pairs(self.redMap) do

            if value then
                isRed = true
                break
            end
        end
    end

    print("refresh111111111111111111111", self.id, isRed, self.isRed)
    if isRed ~= self.isRed then
        self.isRed = isRed
        print("refresh22222222222222222222222", isRed, self.isRed)
        gg.event:dispatchEvent("onRedPointChange", self.id, self.isRed)
        for key, value in pairs(self.parentList) do
            RedPointManager:setSubRed(value, self.id, self.isRed)
        end
    end
end

----------------------------------------------overide
function RedPointBase:onCheck()
end

return RedPointBase