--  kcp"": ""(1byte) + ""(4byte,"") + ""
--  "": 1=""(SYN),2=""(ACK),3=""(FIN),4=""(MSG,""udp"","")
--  "": ""udp"",""(""1314520,"")
--  "": ""

local socket = require "socket"
local lkcp = require "lkcp"
local cjson = require "cjson"

local KcpProtoType_SYN = 1
local KcpProtoType_ACK = 2
local KcpProtoType_FIN = 3
local KcpProtoType_MSG = 4

local kcpWndSize = gg.config.kcpWndSize or 256
local kcpMtu = gg.config.kcpMtu or 496
local kcpHeadSize = 24

local packSyn
local packMsg
local packPing
local packFin

if _VERSION == "Lua 5.3" or _VERSION == "Lua 5.4" then
    packSyn = function (linkid)
        return string.pack("<BI4I4",KcpProtoType_SYN,gg.kcpEncryptKey,linkid)
    end

    packMsg = function (buffer)
        return string.pack("<BI4",KcpProtoType_MSG,gg.kcpEncryptKey) .. buffer
    end

    packPing = function (linkid)
        return string.pack("<BI4I4",KcpProtoType_MSG,gg.kcpEncryptKey,linkid)
    end

    packFin = function (linkid)
        return string.pack("<BI4I4",KcpProtoType_FIN,gg.kcpEncryptKey,linkid)
    end
else
    local function packI4(i)
        local a = i % 256
        i = math.floor(i / 256)
        local b = i % 256
        i = math.floor(i / 256)
        local c = i % 256
        i = math.floor(i / 256)
        local d = i
        return string.char(a)..string.char(b)..string.char(c)..string.char(d)
    end

    packSyn = function (linkid)
        return string.char(KcpProtoType_SYN)..packI4(gg.kcpEncryptKey)..packI4(linkid)
    end

    packMsg = function (buffer)
        return string.char(KcpProtoType_MSG)..packI4(gg.kcpEncryptKey)..buffer
    end

    packPing = function (linkid)
        return string.char(KcpProtoType_MSG)..packI4(gg.kcpEncryptKey)..packI4(linkid)
    end

    packFin = function (linkid)
        return string.char(KcpProtoType_FIN)..packI4(gg.kcpEncryptKey)..packI4(linkid)
    end
end


local ClientKcpSocket = class("ClientKcpSocket")

function ClientKcpSocket:ctor(params)
    self.id = params.id
    self.type = "kcp"
    self.codec = assert(params.codec)
    self.dispatch = assert(params.dispatch)
    self.ip = assert(params.ip)
    self.port = assert(params.port)
    self.linkid = assert(params.linkid)
    self.messages = {}
    self.socket = CS.GG.Net.ClientUdpSocket(self.id)
    self._onClose = params.onClose
    self.socket.onClose = function () self:onClose() end
    self.socket.onConnect = function () self:onConnect() end
    self.socket.onMessage = function (msg) self:dispatchMessage(msg) end
    self.logCmds = params.logCmds or {}

    self.sessionId = 0
    self.sessions = {}
    self.now = 0
    self.heartbeatNextTime = 0
end

function ClientKcpSocket:isConnected()
    return self.socket ~= nil and self.socket.Connected
end

function ClientKcpSocket:connect(onConnect)
    --local kcp_log = function (log) print(log) end
    local kcp_log = nil
    local kcpobj = lkcp.lkcp_create(self.linkid,function (buffer)
        local msg = packMsg(buffer)
        self.socket:Send(msg)
    end,kcp_log)
    self.kcp = kcpobj
    --kcpobj:lkcp_logmask(0xffffffff)
    kcpobj:lkcp_nodelay(1,10,2,1)
    -- kcp""kcpWndSize*(kcpMtu-kcpHeadSize)/2
    kcpobj:lkcp_wndsize(kcpWndSize,kcpWndSize)
    kcpobj:lkcp_setmtu(kcpMtu)
    self.now = 0

    self._onConnect = onConnect
    self.socket:Connect(self.ip,self.port)
    local buffer = packSyn(self.linkid)
    self.socket:Send(buffer)
end

function ClientKcpSocket:close()
    if not self:isConnected() then
        return
    end
    local buffer = packFin(self.linkid)
    self.socket:Send(buffer)
    self.socket:Close()
end

function ClientKcpSocket:onTick(dt)
    local messages = self.messages
    self.messages = {}
    for _,msg in ipairs(messages) do
        self:onMessage(msg)
    end
    if not self:isConnected() then
        return
    end
    self.now = (self.now + math.floor(dt * 1000)) & 0xffffffff
    if self.now >= self.heartbeatNextTime then
        self:heartbeat()
    end
    local nextTime = self.kcp:lkcp_check(self.now)
    if self.now >= nextTime then
        self.kcp:lkcp_update(self.now)
    end
end

function ClientKcpSocket:packUserData()
    return nil
end

--- ""
--@param[type=string] cmd ""/""
--@param[type=table] args ""
--@param[type=bool,opt] response true="",false="",""false
--@param[type=int,opt] session "",""ID,""0
function ClientKcpSocket:send(cmd,args,response,session)
    if not self:isConnected() then
        return
    end
    response = response == true
    session = session or 0
    local ud = self:packUserData()
    if self.logCmds[cmd] ~= false and (self.logCmds.C2S or self.logCmds[cmd]) then
        logger.logf("debug", "op=send,ip=%s,port=%s,id=%s,cmd=%s,args=%s,response=%s,session=%s,ud=%s",self.ip,self.port,self.id,cmd,cjson.encode(args),response,session,ud)
    end
    local msg = self.codec:pack_message(cmd,args,response,session,ud)
    self:rawSend(msg)
end

function ClientKcpSocket:rawSend(bin)
    self.kcp:lkcp_send(bin)
    self.kcp:lkcp_flush()
end

--- ""
--@param[type=string] cmd ""/""
--@param[type=table] args ""
--@param[type=function,opt] onResponse "","",""RPC""
function ClientKcpSocket:sendRequest(cmd,args,onResponse)
    local session = 0
    if onResponse then
        self.session = self.session + 1
        session = self.session
        self.sessions[session] = onResponse
    end
    self:send(cmd,args,false,session)
end

--- ""
--@param[type=string] cmd ""/""
--@param[type=table] args ""
--@param[type=int] session ""ID,""
function ClientKcpSocket:sendResponse(cmd,args,session)
    self:send(cmd,args,true,session)
end

function ClientKcpSocket:dispatchMessage(msg)
    local len = #msg
    if len < 9 then
        return
    end
    local ctrl = string.byte(msg,1,1)
    if ctrl == KcpProtoType_FIN then
        self:close()
    elseif ctrl == KcpProtoType_ACK then
    elseif ctrl == KcpProtoType_MSG then
        self:recvMessage(msg)
    end
end

function ClientKcpSocket:recvMessage(msg)
    msg = string.sub(msg,6)
    self.kcp:lkcp_input(msg)
    while true do
        local len,msg = self.kcp:lkcp_recv()
        if len > 0 then
            self.messages[#self.messages+1] = msg
        else
            break
        end
    end
end

function ClientKcpSocket:onConnect()
    logger.logf("info", "op=onConnect,ip=%s,port=%s,id=%s",self.ip,self.port,self.id)
    local onConnect = self._onConnect
    self._onConnect = nil
    if onConnect then
        onConnect(self)
    end
end

--- ""
function ClientKcpSocket:onClose()
    logger.logf("info", "op=onClose,ip=%s,port=%s,id=%s",self.ip,self.port,self.id)
    if self._onClose then
        self:_onClose()
    end
end

function ClientKcpSocket:onMessage(msg)
    local cmd,args,response,session,ud = self.codec:unpack_message(msg)
    if self.logCmds[cmd] ~= false and (self.logCmds.S2C or self.logCmds[cmd]) then
        logger.logf("debug", "op=recv,ip=%s,port=%s,id=%s,cmd=%s,args=%s,response=%s,session=%s,ud=%s",self.ip,self.port,self.id,cmd,cjson.encode(args),response,session,ud)
    end
    xpcall(self.dispatch,gg.onerror,cmd,args,response,session,ud)
end

function ClientKcpSocket:heartbeat()
    --print("heartbeat",self.now)
    self.heartbeatNextTime = self.heartbeatNextTime + 5000
    self.socket:Send(packPing(self.linkid))
end

return ClientKcpSocket
