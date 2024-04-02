local codec = require "gg.client.codec.codec"


local Client = class("Client")

function Client:ctor()
    self.cmds = {}
    local protoConfig = gg.config[gg.config.protoType.."Config"]
    self.codec = codec.new(gg.config.protoType,protoConfig)
    self.gameServer = nil
    self.sceneServer = nil
    self.loginServer = ggclass.LoginServer.new()
end

function Client:connectGameServer(server,onConnect,onConnectFail)
    if self.gameServer and self.gameServer.id ~= server.id then
        self.gameServer:close()
        self.gameServer = nil
    end
    if self.gameServer and self.gameServer:isConnected() then
        onConnect(self.gameServer)
    else
        if gg.config.gameServer.gateType == "tcp" then
            self.gameServer = ggclass.ClientTcpSocket.new({
                id = server.id,
                ip = server.ip,
                port = server.port or server.tcp_port,
                codec = self.codec,
                handshake = gg.config.gameServer.handshake,
                dispatch = function (...) self:dispatch(...) end,
                logCmds = gg.logCmds,
                onClose = function (...) self:onGameServerClose(...) end,
            })
        end
        self.gameServer:connect(onConnect,onConnectFail)
    end
end

function Client:connectSceneServer(server,onConnect)
    if self.sceneServer and self.sceneServer.id ~= server.id then
        self.sceneServer:close()
        self.sceneServer = nil
    end
    if self.sceneServer and self.sceneServer:isConnected() then
        onConnect(self.sceneServer)
    else
        if server.gateType == "tcp" then
            self.sceneServer = ggclass.ClientTcpSocket.new({
                id = server.id,
                ip = server.ip,
                port = server.port or server.tcp_port,
                codec = self.codec,
                handshake = server.handshake,
                dispatch = function (...) self:dispatch(...) end,
                logCmds = gg.logCmds,
                onClose = self.onClose,
            })
        elseif server.gateType == "kcp" then
            self.sceneServer = ggclass.ClientKcpSocket.new({
                id = server.id,
                ip = server.ip,
                port = server.port or server.kcp_port,
                linkid = gg.client.loginServer.currentRole.roleid,
                codec = self.codec,
                handshake = false,  -- kcp""
                dispatch = function (...) self:dispatch(...) end,
                logCmds = gg.logCmds,
                onClose = self.onClose,
            })
        end
        self.sceneServer:connect(onConnect)
    end
end

function Client:startHeartbeat(interval)
    interval = interval or 5    -- 5s
    if self.heartbeatTimer then
        gg.timer:stopTimer(self.heartbeatTimer)
        self.heatbeatTimer = nil
    end
    local clientTime = gg.timer:now()
    local str = tostring(math.floor(clientTime * 1000))
    self.gameServer:send("C2S_Ping",{ str = str})
    self.heartbeatTimer = gg.timer:startLoopTimer(interval,interval,-1,function ()
        if self.gameServer then
            local clientTime = gg.timer:now()
            local str = tostring(math.floor(clientTime * 1000))
            self.gameServer:send("C2S_Ping",{ str = str})
        end
        if self.sceneServer and self.sceneServer.type == "tcp" then
            self.sceneServer:send("C2S_Ping",{})
        end
    end)

    --"","",""
    local checkInterval = 2
    self.noPongCount = 0
    if self.checkTimer then
        gg.timer:stopTimer(self.checkTimer)
        self.checkTimer = nil
    end
    self.checkTimer = gg.timer:startLoopTimer(checkInterval, checkInterval, -1, function ()
        local curTime = os.time()
        if (curTime - self.lastPongTime) > 10 then
            self.noPongCount = self.noPongCount + 1
            if self.noPongCount >= 2 then
                self.noPongCount = 0
                --""
                gg.timer:stopTimer(self.checkTimer)
                self.checkTimer = nil
                logger.logf("info", "HeartBeat Close")
                self.gameServer:close()
            end
        else
            self.noPongCount = 0
        end
    end)

    self.lastPongTime = os.time()
end

function Client:dispatch(cmd,args,response,session,ud)
    -- self is a socket object
    local handler
    if response then
        handler = self.sessions[session]
    else
        handler = self.cmds[cmd]
    end
    assert(handler,cmd)
    handler(args,session,ud)
    if not response then
        gg.event:dispatchEvent(cmd,args)
    end
end

function Client:register(cmd,handler)
    self.cmds[cmd] = handler
end

function Client:registerModule(module)
    for cmd,handler in pairs(module) do
        if string.sub(cmd,1,4) == "S2C_" then
            self:register(cmd,handler)
        end
    end
end

function Client:stopAllTimer()
    if self.heartbeatTimer then
        gg.timer:stopTimer(self.heartbeatTimer)
        self.heatbeatTimer = nil
    end
    if self.checkTimer then
        gg.timer:stopTimer(self.checkTimer)
        self.checkTimer = nil
    end
end

function Client:onGameServerClose()
    logger.logf("info", "op=onGameServerClose")
    --""
    self.loginServer:reconnectGameServer()
end

return Client