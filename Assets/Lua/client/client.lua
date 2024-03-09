local Client = ggclass.Client

function Client:open()
    self:registerModule(require("client.login"))
    self:registerModule(require("client.msg"))
    self:registerModule(require("client.player"))
    self:registerModule(require("client.battle"))
end

function Client:onClose(socket)
    if self.gameServer == socket then
        -- 
    else
        -- 
    end
end

function Client:onEnterGame(mapId)
    self:startHeartbeat()
    local player = ggclass.Player.new(self.loginServer.currentRole.roleid)
    player:setProperties(self.loginServer.currentRole)
    gg.playerMgr:addPlayer(player)
end

return Client