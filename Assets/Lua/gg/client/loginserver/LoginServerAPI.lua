--- ""API

local crypt = require "crypt.core"
local cjson = require "cjson"

local LoginServerAPI = class("LoginServerAPI")

--- ""API""
function LoginServerAPI:ctor(conf)
    self.url = conf.url
    self.appKey = conf.appKey
    self.appId = conf.appId
    self.version = conf.version
    self.platform = conf.platform
    self.sdk = conf.sdk
    self.device = conf.device
    self.jsonDevice = cjson.encode(self.device)
end

function LoginServerAPI:signature(args)
    local str = table.ksort(args,"&")
    return crypt.base64encode(crypt.hmac_sha1(self.appKey,str))
end

function LoginServerAPI:post(callback,url,args)
    args.sign = self:signature(args)
    local data = cjson.encode(args)
    local http = global:GetComponent("HttpComponent")
    local request = http:newHttpRequest(url,"post")
    request.timeout = 8
    request:SetRequestHeader("Content-Type","application/json")
    http:sendHttpRequest(request,data,callback)
end

--- ""
function LoginServerAPI:installApp(callback)
    local url = string.format("%s/api/statistic/installApp",self.url)
    local req = {
        appid = self.appId,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string] account ""
--@param[type=string] passwd ""
--@param[type=string] verifyCode ""
-- @param[type=string] inviteCode ""
--@param[type=function,opt] callback ""
function LoginServerAPI:register(account,passwd,verifyCode,inviteCode,callback)
    local url = string.format("%s/api/account/register",self.url)
    local req = {
        appid = self.appId,
        account = account,
        passwd = passwd,
        verifyCode = verifyCode,
        inviteCode = inviteCode,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string] account ""
--@param[type=string] passwd ""
--@param[type=function,opt] callback ""
function LoginServerAPI:login(account,passwd,callback)
    local url = string.format("%s/api/account/login",self.url)
    local req = {
        appid = self.appId,
        account = account,
        passwd = passwd,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- "",""
--@param[type=string] account ""
--@param[type=string] passwd ""
--@param[type=function,opt] callback ""
function LoginServerAPI:vistorLogin(account,passwd,callback)
    local url = string.format("%s/api/account/vistorLogin",self.url)
    local req = {
        appid = self.appId,
        account = account,
        passwd = passwd,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string,opt] account ""
--@param[type=function,opt] callback ""
function LoginServerAPI:getServerList(account,callback)
    local url = string.format("%s/api/account/server/list",self.url)
    local req = {
        appid = self.appId,
        version = self.version,
        platform = self.platform,
        devicetype = self.device.deviceType,
        account = account,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string] account ""
--@param[type=string,opt] serverid ""ID("")
--@param[type=function,opt] callback ""
function LoginServerAPI:getRoleList(account,serverid,callback)
    local url = string.format("%s/api/account/role/list",self.url)
    local req = {
        appid = self.appId,
        account = account,
        serverid = serverid,
    }
    self:post(callback,url,req)
end

--- rpc""
--@param[type=string] module ""
--@param[type=string] cmd ""
--@param[type=string] args json""
--@param[type=function,opt] callback ""
function LoginServerAPI:rpc(module,cmd,args,callback)
    local url = string.format("%s/api/rpc",self.url)
    local req = {
        module = module,
        cmd = cmd,
        args = args,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string] account ""
--@param[type=function,opt] callback ""
function LoginServerAPI:sendCode(account,callback)
    local url = string.format("%s/api/account/sendCode",self.url)
    local req = {
        appid = self.appId,
        account = account,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string] account ""
--@param[type=string] passwd ""
--@param[type=string] verifyCode ""
--@param[type=function,opt] callback ""
function LoginServerAPI:resetPassword(account,passwd,verifyCode,callback)
    local url = string.format("%s/api/account/resetPassword",self.url)
    local req = {
        appid = self.appId,
        account = account,
        passwd = passwd,
        verifyCode = verifyCode,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- ""
--@param[type=string] account ""
--@param[type=string] passwd ""
--@param[type=function,opt] callback ""
function LoginServerAPI:deleteAccount(account,passwd,callback)
    local url = string.format("%s/api/account/delete",self.url)
    local req = {
        appid = self.appId,
        account = account,
        passwd = passwd,
        sdk = self.sdk,
        platform = self.platform,
        device = self.jsonDevice,
    }
    self:post(callback,url,req)
end

--- ""，""
--@param[type=string] account ""
--@param[type=string] pid ""id
--@param[type=string] productId ""id
--@param[type=string] ext ""
--@param[type=function,opt] callback ""
function LoginServerAPI:payReady(payChannel,payCurrency,payType,account,pid,productId,ext,callback)
    local url = string.format("%s/api/pay/ready",self.url)
    local req = {
        appid = self.appId,
        platform = self.platform,
        sdk = self.sdk,
        payChannel = payChannel,
        payCurrency = payCurrency or "USD",
        payType = payType or "default",
        account = account,
        pid = pid,
        productId = productId,
        ext = ext or "ext",
        language = constant.LAN_TYPE_LIST[UnityEngine.PlayerPrefs.GetInt(CS.Appconst.languageKey, 0)],
    }
    self:post(callback,url,req)
end

--- "",""
--@param[type=string] orderId ""
--@param[type=string] account ""
--@param[type=string] productId ""id
--@param[type=string] receiptData appstore""
--@param[type=string] signtureData googleplay""
--@param[type=string] signture googleplay""
--@param[type=function,opt] callback ""
function LoginServerAPI:paySettle(orderId,account,productId,receiptData,signtureData,signture,callback)
    local url = string.format("%s/api/pay/settle",self.url)
    local req = {
        appid = self.appId,
        orderId = orderId,
        account = account,
        productId = productId,
        receiptData = receiptData or "",
        signtureData = signtureData or "",
        signture = signture or "",
    }
    self:post(callback,url,req)
end

return LoginServerAPI