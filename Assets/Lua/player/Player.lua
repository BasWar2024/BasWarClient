local Player = class("Player")

function Player:ctor(pid)
    self.pid = pid
end

function Player:setProperties(properties)
    for k,v in pairs(properties) do
        self[k] = v
    end
end

function Player:getAccount()
    return self.account
end

function Player:getPid()
    return self.pid
end

function Player:getLevel()
    return self.level
end

function Player:getName()
    return self.name
end

return Player