local cjson = require "cjson"
local LoginServer = class("LoginServer")

function LoginServer:ctor()
    self.api = ggclass.LoginServerAPI.new({
        url = gg.config.loginServerUrl,
        appKey = gg.config.appKey,
        appId = gg.config.appId,
        version = CS.Appconst.instance.RemoteVersion,--gg.config.version,
        platform = gg.config.platform,
        sdk = gg.config.sdk,
        device = {
            -- login.sproto#DeviceType
            registerLoginType = 1,
            deviceCode = "deviceCode",
            network = "WIFI",
            wifiName = "wifiName",
            deviceType = 3,
            deviceModel = "deviceModel",
            os = "windows",
            channelId = 0,
            lang = "zh_CN",
        }
    })

    self.account = nil
    self.passwd = nil
    self.serverList = nil
    self.roleList = nil
    self.token = nil
    self.chooseServerId = nil
end

function LoginServer:bind(account,passwd)
    self.account = account
    self.passwd = passwd
end

function LoginServer:register()
    self.api:register(self.account,self.passwd,function (...) self:onRegister(...) end)
end

function LoginServer:onRegister(responseCode,response)
    if responseCode ~= 200 then
        logger.logf("debug","op=onRegister,status=%s,response=%s",responseCode,response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug","op=onRegister,code=%s,message=%s",response.code,response.message)
        gg.uiManager:showTip(response.message)
        if response.code == gg.Answer.code.ACCT_EXIST then
            return
        end
    else
        logger.logf("debug","op=onRegister,account=%s,passwd=%s",self.account,self.passwd)
    end
    if not gg.config.loginAfterRegister then
        return
    end
    self:login()
end

function LoginServer:login()
    self.api:login(self.account,self.passwd,function (...) self:onLogin(...) end)
end

function LoginServer:onLogin(responseCode,response)
    if responseCode ~= 200 then
        logger.logf("debug","op=onLogin,status=%s,response=%s",responseCode,response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug","op=onLogin,code=%s,message=%s",response.code,response.message)
        gg.uiManager:showTip(response.message)
        return
    end
    self.token = response.data.token
    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_ACCOUNT, self.account);
    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_PASSWORD, self.passwd);
    logger.logf("debug","op=onLogin,account=%s,passwd=%s,token=%s",self.account,self.passwd,self.token)
    self.api:getServerList(self.account,function (...) self:onGetServerList(...) end)
end

function LoginServer:vistorLogin()
    self.api:vistorLogin(self.account,self.passwd,function (...) self:onVistorLogin(...) end)
end

function LoginServer:onVistorLogin(responseCode,response)
    if responseCode ~= 200 then
        logger.logf("debug","op=onVistorLogin,status=%s,response=%s",responseCode,response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug","op=onVistorLogin,code=%s,message=%s",response.code,response.message)
        return
    end
    self.account = response.data.account
    self.passwd = response.data.passwd
    self.token = response.data.token
    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_ACCOUNT, self.account);
    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_PASSWORD, self.passwd);
    logger.logf("debug","op=onVistorLogin,account=%s,passwd=%s,token=%s",self.account,self.passwd,self.token)
    self.api:getServerList(self.account,function (...) self:onGetServerList(...) end)
end


function LoginServer:chooseServer(serverId)
    self.chooseServerId = serverId
    self.api:getRoleList(self.account,serverId,function (...) self:onGetRoleList(...) end)
end

function LoginServer:onGetServerList(responseCode,response)
    if responseCode ~= 200 then
        logger.logf("debug","op=onGetServerList,status=%s,response=%s",responseCode,response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug","op=onGetServerList,code=%s,message=%s",response.code,response.message)
        return
    end
    self.serverList = response.data.serverlist
    table.sort(self.serverList,function (server1,server2)
        return server1.index < server2.index
    end)
    logger.logf("debug","op=onGetServerList,serverList=%s",table.dump(self.serverList))
    self.api:getRoleList(self.account,nil,function (...) self:onGetRoleList(...) end)
end

function LoginServer:onGetRoleList(responseCode,response)
    if responseCode ~= 200 then
        logger.logf("debug","op=onGetRoleList,status=%s,response=%s",responseCode,response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug","op=onGetRoleList,code=%s,message=%s",response.code,response.message)
        return
    end
    self.roleList = response.data.rolelist
    logger.logf("debug","op=onGetRoleList,roleList=%s",table.dump(self.roleList))

    if #self.roleList == 0 then
        if not gg.config.autoCreateRole then
            return
        end
        local server = nil
        if self.chooseServerId then
            server = self:getGameServer(self.chooseServerId)
        end
        if not server then
            server = self:autoChooseGameServer()
        end
        if not server then
            logger.logf("info","op=autoChooseGameServer,fail=true")
            return
        end
        self.roleName = "roleName"
        self.heroId = 1001
        self:createRole(server,self.roleName,self.heroId)
    else
        if not gg.config.autoEnterGame then
            return
        end
        local role = self:autoChooseRole()
        self:enterGame(role)
    end
end

function LoginServer:packToken(forward)
    return {
        token = self.token,
        account = self.account,
        version = self.api.version,
        forward = forward,
        device = self.api.device,
    }
end

function LoginServer:createRole(server,roleName,heroId)
    self:connectGameServer(server,function (gameServer)
        gameServer:send("C2S_CreateRole",{
            checktoken = self:packToken("CreateRole"),
            name = roleName,
            heroId = heroId,
            account = self.account,
        })
    end,function (gameServer) 
        gg.uiManager:showTip("network error")
    end)
end

function LoginServer:onCreateRole(role)
    if not gg.config.enterGameAfterCreateRole then
        return
    end
    self:enterGame(role)
end

function LoginServer:enterGame(role)
    --role.currentServerId = "game1"
    self.currentRole = role
    local server = self:getGameServer(role.currentServerId)
    if not server then
        logger.logf("info","op=enterGame,currentServerId=%s,reason=serverNotFound",role.currentServerId)
        return
    end
    self:connectGameServer(server,function (gameServer)
        gameServer:send("C2S_EnterGame",{
            roleid = role.roleid,
            checktoken = self:packToken("EnterGame"),
        })
    end,function (gameServer)
        gg.uiManager:showTip("network error")
    end)
end

--- 
function LoginServer:getGameServer(serverId)
    for i,server in ipairs(self.serverList) do
        if server.id == serverId then
            return server
        end
    end
end

--- 
function LoginServer:serverIsOpen(server)
    --return server.is_open == 1 and server.is_down ~= 1
    return server.is_open == 1
end

function LoginServer:autoChooseGameServer()
    local serverList = self.serverList
    local servers = {}
    for i,server in ipairs(serverList) do
        if self:serverIsOpen(server) then
            table.insert(servers,server)
        end
    end
    table.sort(servers,function (server1,server2)
        if server1.busyness == server2.busyness then
            return server1.index < server2.index
        end
        return server1.busyness < server2.busyness
    end)
    return servers[1]
end

--- 
--@return 
function LoginServer:autoChooseRole()
   local role = self.roleList[1]
   return role
end

function LoginServer:connectGameServer(server,onConnect,onConnectFail)
    self.lastServer = server
    gg.client:connectGameServer(server,onConnect,onConnectFail)
end

function LoginServer:onEnterGameSuccess()
    self.everEnterGameSuccess = true
end

function LoginServer:reconnectGameServer()
    if not self.everEnterGameSuccess then
        return
    end
    gg.uiManager:openWindow("PnlConnect")
    self:connectGameServer(self.lastServer,function (gameServer)
        gameServer:send("C2S_EnterGame",{
            roleid = self.currentRole.roleid,
            checktoken = self:packToken("EnterGame"),
        })
        gg.uiManager:closeWindow("PnlConnect")
    end,function (gameServer)
        gg.timer:startTimer(2,function ()
            self:reconnectGameServer()
        end)
    end)
end

return LoginServer