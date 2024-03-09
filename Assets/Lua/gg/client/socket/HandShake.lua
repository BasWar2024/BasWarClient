local crypt = require "crypt.core"

local HandShake = {}
HandShake.__index = HandShake

function HandShake.new(agent,master_linkid)
    local self = {}
    self.agent = agent
    self.step = 0
    self.result = nil
    self.rawEncryptKey = nil
    self.encryptKey = nil
    self.linkid = nil                   -- ID
    self.master_linkid = master_linkid  -- ID()
    return setmetatable(self,HandShake)
end

function HandShake:packRequest(tbl)
    local list = {}
    for k,v in pairs(tbl) do
        k = crypt.base64encode(k)
        v = crypt.base64encode(v)
        -- base64"|","="
        table.insert(list,string.format("%s|%s",k,v))
    end
    return table.concat(list,",")
end

function HandShake:unpackRequest(message)
    local tbl = {}
    for m in message:gmatch("([^,]+)") do
        local k,v = m:match("([^|]+)|([^|]+)")
        k = crypt.base64decode(k)
        v = crypt.base64decode(v)
        tbl[k] = v
    end
    return tbl
end

function HandShake:getInt16EncryptKey(encryptKey)
    local result = 0
    for i=1,#encryptKey,2 do
        result = result ~ ((string.byte(encryptKey,i,i) * 256) + string.byte(encryptKey,i+1,i+1))
    end
    return result
end

function HandShake:_doHandShake(message)
    local request = self:unpackRequest(message)
    local proto = request.proto
    if proto == "S2C_HandShake_Challenge" then
        if self.step ~= 0 then
            return false,"challenge first"
        end
        -- : [S2C]challenge()+serverkey
        self.step = 1
        local challenge = request.challenge
        local serverkey = request.serverkey
        local linkid = request.linkid
        self.linkid = linkid
        if not challenge then
            self.encryptKey = nil
            self.result = "OK"
            return true
        end
        local clientkey = crypt.randomkey()
        self.rawEncryptKey = crypt.dhsecret(clientkey,serverkey)
        self.encryptKey = self:getInt16EncryptKey(self.rawEncryptKey)
        -- : [C2S]clientkey
        self.step = 2
        local msg = self:packRequest({
            proto = "C2S_HandShake_ClientKey",
            clientkey = clientkey,
            master_linkid = self.master_linkid,
        })
        self.agent:rawSend(msg)
        -- : [C2S]clientkey+serverkey,challenge,
        self.step = 3
        local encrypt = crypt.hmac64(challenge,self.rawEncryptKey)
        local msg = self:packRequest({
            proto = "C2S_HandShake_CheckSecret",
            encrypt = encrypt,
        })
        self.agent:rawSend(msg)
    elseif proto == "S2C_HandShake_Result" then
        if self.step ~= 3 then
            return false,"skip handshake step 3?"
        end
        -- : [S2C]
        self.step = 4
        local result = request.result
        self.result = result
        if result == "FAIL" then
            return false,"check encryptKey fail"
        end
    else
        return false,"handshake first!"
    end
    return true
end

--- 
--@param[type=string] message 
--@return[type=bool] ok 
--@return[type=string] err 
function HandShake:doHandShake(message)
    local callOk,ok,err = pcall(self._doHandShake,self,message)
    if not callOk then
        err = ok
        ok = false
    end
    return ok,err
end

return HandShake