local RedPointBase = class("RedPointBase")

function RedPointBase:ctor(parentList, events)
    self.parentList = parentList or {}
    events = events or {}
    self:setEventList(events)
    self.isRed = false
    self.redMap = {}
end

function RedPointBase:setEventList(events)
    self.events = events
    for i, eventName in ipairs(self.events) do
        self[eventName] = gg.bind(self.check, self)
        gg.event:addListener(eventName, self)
    end
end

function RedPointBase:check()
    self:setRed(self.__name, self:onCheck())
end

function RedPointBase:setRed(id, isRed)
    if self.redMap[id] == isRed then
        return
    end

    self.redMap[id] = isRed
    if not isRed then
        for key, value in pairs(self.redMap) do
            if value then
                isRed = true
                break
            end
        end
    end

    if isRed ~= self.isRed then
        self.isRed = isRed
        gg.event:dispatchEvent("onRedPointChange", self.__name, self.isRed)
        for key, value in pairs(self.parentList) do
            RedPointManager:setSubRed(value.__name, self.__name, self.isRed)
        end
    end
end

----------------------------------------------overide
function RedPointBase:onCheck()
    return false
end

return RedPointBase