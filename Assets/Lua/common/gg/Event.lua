local Event = class("Event")

function Event:ctor(owner)
    self.owner =  owner
    self._on = {}
end

function Event:newListener(eventName,listener,isOnce)
    return {
        eventName = eventName,
        listener = listener,
        isOnce = isOnce,
    }
end

function Event:getListeners(eventName)
    if not self._on[eventName] then
        self._on[eventName] = {}
    end
    return self._on[eventName]
end

function Event:hasListener(eventName,listener)
    local listeners = self._on[eventName]
    if not listeners then
        return false
    end
    for i,o in ipairs(listeners) do
        if o.listener == listener then
            return true
        end
    end
    return false
end

function Event:addListener(eventName,listener,isOnce)
    if not isOnce then
        if self:hasListener(eventName,listener) then
            return false
        end
    end
    local listeners = self._on[eventName]
    if not listeners then
        listeners = {}
        self._on[eventName] = listeners
    end
    local obj = self:newListener(eventName,listener,isOnce)
    table.insert(listeners,1,obj)
    return true
end

Event.on = Event.addListener

function Event:once(eventName,listener)
    return self:addListener(eventName,listener,true)
end

function Event:removeListener(eventName,listener)
    local listeners = self._on[eventName]
    if not listeners then
        return
    end
    for pos,o in ipairs(listeners) do
        if o.listener == listener then
            table.remove(listeners,pos)
            return true
        end
    end
end

function Event:removeAllListeners(eventName)
    if eventName == nil then
        self._on = {}
        return
    end
    self._on[eventName] = nil
end

function Event:dispatchEvent(eventName,...)
    local listeners = self._on[eventName]
    if not listeners then
        return
    end
    for pos = #listeners, 1, -1 do
        local o = listeners[pos]
        if type(o.listener) == "function" then
            o.listener(self,...)
        else
            local callback = o.listener[eventName]
            if callback then
                callback(o.listener,self,...)
            end
        end
        if o.isOnce then
            table.remove(listeners,pos)
        end
    end
end

Event.emit = Event.dispatchEvent

return Event