--- API

local crypt = require "crypt.core"
local cjson = require "cjson"

local LoginServerAPI = class("LoginServerAPI")

--- API
--@param[type=table,opt] conf 
--@usage
--  self.loginServer = ggclass.LoginServerAPI.new({
--      url = gg.config.loginServerUrl,
--      appKey = gg.config.appKey,
--      appId = gg.config.appId,
--      version = gg.config.version,
--      platform = gg.config.platform,
--      sdk = gg.config.sdk,
--      device = {
--          deviceType = "pc",
--      }
--  })

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
    request:SetRequestHeader("Content-Type","application/json")
    http:sendHttpRequest(request,data,callback)
end

--- 
--@param[type=string] account 
--@param[type=string] passwd 
--@param[type=function,opt] callback 
function LoginServerAPI:register(account,passwd,callback)
    local url = string.format("%s/api/account/register",self.url)
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

--- 
--@param[type=string] account 
--@param[type=string] passwd 
--@param[type=function,opt] callback 
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

--- ,
--@param[type=string] account 
--@param[type=string] passwd 
--@param[type=function,opt] callback 
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

--- 
--@param[type=string,opt] account 
--@param[type=function,opt] callback 
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

--- 
--@param[type=string] account 
--@param[type=string,opt] serverid ID()
--@param[type=function,opt] callback 
function LoginServerAPI:getRoleList(account,serverid,callback)
    local url = string.format("%s/api/account/role/list",self.url)
    local req = {
        appid = self.appId,
        account = account,
        serverid = serverid,
    }
    self:post(callback,url,req)
end

--- rpc
--@param[type=string] module 
--@param[type=string] cmd 
--@param[type=string] args json
--@param[type=function,opt] callback 
function LoginServerAPI:rpc(module,cmd,args,callback)
    local url = string.format("%s/api/rpc",self.url)
    local req = {
        module = module,
        cmd = cmd,
        args = args,
    }
    self:post(callback,url,req)
end

return LoginServerAPI