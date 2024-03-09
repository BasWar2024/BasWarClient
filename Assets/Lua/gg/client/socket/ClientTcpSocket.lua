local cjson = require "cjson"
local crypt = require "crypt.core"
local HandShake = require "gg.client.socket.HandShake"

local ClientTcpSocket = class("ClientTcpSocket")

function ClientTcpSocket:ctor(param)
    self.id = param.id
    self.type = "tcp"
    self.codec = assert(param.codec)
    self.dispatch = assert(param.dispatch)
    self.ip = assert(param.ip)
    self.port = assert(param.port)
    self.messages = {}
    self.socket = CS.GG.Net.ClientTcpSocket(self.id)
    self._onClose = param.onClose
    self.socket.onClose = function () self:onClose() end
    self.socket.onConnect = function () self:onConnect() end
    self.socket.onMessage = function (msg) self.messages[#self.messages+1] = msg end
    self.socket.onConnectFail = function () self:onConnectFail() end

    self.logCmds = param.logCmds or {}

    self.sessionId = 0
    self.sessions = {}
    self.lastRecv = ""

    self.handShake = HandShake.new(self)
    if not param.handshake then
        self.handShake.result = "OK"
    end
end

function ClientTcpSocket:onTick(dt)
    self:doOnConnect()
    self:doOnConnectFail()
    local messages = self.messages
    self.messages = {}
    for _,msg in ipairs(messages) do
        self:onMessage(msg)
    end
end

--- 
function ClientTcpSocket:isConnected()
    return self.socket ~= nil and self.socket.Connected
end

--- 
function ClientTcpSocket:connect(onConnect,onConnectFail)
    if self:isConnected() then
        return
    end
    self._onConnect = onConnect
    self._onConnectFail = onConnectFail
    self.socket:Connect(self.ip,self.port)
end

--- 
function ClientTcpSocket:close()
    if not self:isConnected() then
        return
    end
    self.socket:Close()
end

--- 
--@param[type=string] cmd /
--@param[type=table] args 
--@param[type=bool,opt] response true=,false=,false
--@param[type=int,opt] session ,ID,0
function ClientTcpSocket:send(cmd,args,response,session)
    if not self:isConnected() then
        return
    end

    if cmd ~= "C2S_Ping" then
        print("sendTcp: ", gg.table2Str(args, cmd))
    end

    response = response == true
    session = session or 0
    local ud = self:packUserData()
    if self.logCmds[cmd] ~= false and (self.logCmds.C2S or self.logCmds[cmd]) then
        logger.logf("debug", "op=send,ip=%s,port=%s,id=%s,cmd=%s,args=%s,response=%s,session=%s,ud=%s",self.ip,self.port,self.id,cmd,cjson.encode(args),response,session,ud)
    end
    local bin
    local encryptKey = self.handShake.encryptKey
    if encryptKey then
        bin = self.codec:pack_message(cmd,args,response,session,ud,function (cmd)
            if type(cmd) == "number" then
                return cmd ~ encryptKey
            else
                -- jsoncmdstring
                return crypt.xor_str(cmd,encryptKey)
            end
        end)
    else
        bin = self.codec:pack_message(cmd,args,response,session,ud)
    end
    self.socket:Send(bin)
end

function ClientTcpSocket:rawSend(bin)
    if self.socket == nil then
        return
    end
    self.socket:Send(bin)
end

function ClientTcpSocket:genSessionId()
    repeat
        self.sessionId = self.sessionId + 1
        if self.sessionId == 2 ^ 31 then
            self.sessionId = 1
        end
    until self.sessions[self.sessionId] == nil and self.sessionId ~= 0
    return self.sessionId
end

function ClientTcpSocket:packUserData()
    return nil
end

--- 
--@param[type=string] cmd /
--@param[type=table] args 
--@param[type=function,opt] onResponse ,,RPC
function ClientTcpSocket:sendRequest(cmd,args,onResponse)
    local session = 0
    if onResponse ~= nil then
        session = self:genSessionId()
        self.sessions[session] = onResponse
    end
    self:send(cmd,args,false,session)
end

--- 
--@param[type=string] cmd /
--@param[type=table] args 
--@param[type=int] session ID,
function ClientTcpSocket:sendResponse(cmd,args,session)
    self:send(cmd,args,true,session)
end

-- 
function ClientTcpSocket:onConnect()
    logger.logf("info", "op=onConnect,ip=%s,port=%s,id=%s",self.ip,self.port,self.id)
    if not self.handShake.result then
        return
    end
    self:onHandShake(self.handShake.result)
end

-- 
function ClientTcpSocket:onConnectFail()
    logger.logf("info", "op=onConnectFail,ip=%s,port=%s,id=%s",self.ip,self.port,self.id)
    self.hasOnConnectFail = true
end

function ClientTcpSocket:doOnConnectFail()
    if not self.hasOnConnectFail then
        return
    end
    self.hasOnConnectFail = nil
    local onConnectFail = self._onConnectFail
    self._onConnectFail = nil
    if onConnectFail then
        onConnectFail(self)
    end
end

function ClientTcpSocket:onHandShake(result)
    if result ~= "OK" then
        return
    end
    self.hasOnConnect = true
    --[[
    local onConnect = self._onConnect
    self._onConnect = nil
    if onConnect then
        onConnect(self)
    end
    ]]
end

function ClientTcpSocket:doOnConnect()
    if not self.hasOnConnect then
        return
    end
    self.hasOnConnect = nil
    local onConnect = self._onConnect
    self._onConnect = nil
    if onConnect then
        onConnect(self)
    end
end

--- 
function ClientTcpSocket:onClose()
    logger.logf("info", "op=onClose,ip=%s,port=%s,id=%s",self.ip,self.port,self.id)
    if self._onClose then
        self:_onClose()
    end
end

function ClientTcpSocket:onMessage(msg)
    if not self.handShake.result then
        local ok,err = self.handShake:doHandShake(msg)
        if not ok then
            self:close()
        end
        logger.logf("debug", "op=handShaking,ip=%s,port=%s,id=%s,ok=%s,err=%s,step=%s",self.ip,self.port,self.id,ok,err,self.handShake.step)
        if self.handShake.result then
            logger.logf("debug", "op=handShake,ip=%s,port=%s,id=%s,encryptKey=%s,result=%s",self.ip,self.port,self.id,self.handShake.encryptKey,self.handShake.result)
            self:onHandShake(self.handShake.result)
        end
        return
    end
    local encryptKey = self.handShake.encryptKey
    local cmd,args,response,session,ud
    if encryptKey then
        cmd,args,response,session,ud = self.codec:unpack_message(msg,function (cmd)
            if type(cmd) == "number" then
                return cmd ~ encryptKey
            else
                -- jsoncmdstring
                return crypt.xor_str(cmd,encryptKey)
            end
        end)
    else
        cmd,args,response,session,ud = self.codec:unpack_message(msg)
    end
    if self.logCmds[cmd] ~= false and (self.logCmds.S2C or self.logCmds[cmd]) then
        logger.logf("debug", "op=recv,ip=%s,port=%s,id=%s,cmd=%s,args=%s,response=%s,session=%s,ud=%s",self.ip,self.port,self.id,cmd,cjson.encode(args),response,session,ud)
    end

    if cmd ~= "S2C_Pong" then 
        print("onMessageTcp: " , gg.table2Str(args, cmd))
    end

    xpcall(self.dispatch,gg.onerror,cmd,args,response,session,ud)
end

return ClientTcpSocket