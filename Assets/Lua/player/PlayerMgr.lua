local PlayerMgr = class("PlayerMgr")

function PlayerMgr:ctor()
    self.players = {}
    self.localPlayer = nil

    self.sessions = {}
    self.sessionId = 0

    gg.event:addListener("onPlayerInfoChange", self)
end

function PlayerMgr:clear()
    self.players = {}
    self.localPlayer = nil

    self.sessions = {}
    self.sessionId = 0

    gg.event:dispatchEvent("onPlayerInfoChange", self)
end

function PlayerMgr:addPlayer(player)
    local pid = player.pid
    assert(self.players[pid] == nil)
    self.players[pid] = player
    if pid == gg.client.loginServer.currentRole.roleid then
        self.localPlayer = player
    end
end

function PlayerMgr:getPlayer(pid)
    return self.players[pid]
end

function PlayerMgr:lookPlayers(pids, callback)
    local session = 0
    if callback then
        self.sessionId = self.sessionId + 1
        self.sessions[self.sessionId] = {
            pids = pids,
            callback = callback
        }
        session = self.sessionId
    end
    gg.client.gameServer:send("C2S_Player_LookBriefs", {
        session = session,
        pids = pids
    })
end

function PlayerMgr:onLookPlayers(sessionId)
    local session = self.sessions[sessionId]
    if not session then
        return
    end
    local players = {}
    for i, pid in ipairs(session.pids) do
        players[#players + 1] = self:getPlayer(pid)
    end
    session.callback(players)
end

function PlayerMgr:onPlayerInfoChange(args, playerData)
    if playerData.language ~= constant.LAN_TYPE_LIST[LanguageMgr.ShowingTypeId] then
        PlayerData.C2S_Player_ModifyPlayerLanguage(constant.LAN_TYPE_LIST[LanguageMgr.ShowingTypeId])
    end
end

return PlayerMgr
