local cjson = require "cjson"
local LoginServer = class("LoginServer")

function LoginServer:ctor()
    self.api = ggclass.LoginServerAPI.new({
        url = CS.Appconst.instance.loginServerUrl,
        appKey = gg.config.appKey,
        appId = gg.config.appId,
        version = CS.Appconst.instance.RemoteVersion, -- gg.config.version,
        platform = CS.Appconst.platform,
        sdk = CS.Appconst.sdk,
        device = {
            -- ""login.sproto#DeviceType
            registerLoginType = 1,
            deviceCode = "deviceCode",
            network = "WIFI",
            wifiName = "wifiName",
            deviceType = 3,
            deviceModel = "deviceModel",
            os = "windows",
            channelId = 0,
            lang = "en_US"
        }
    })

    self.account = nil
    self.passwd = nil
    self.serverList = nil
    self.roleList = nil
    self.token = nil
    self.chooseServerId = nil
    self.isSavePasswd = false

    self.loginTimeOut = 15
    self.kickReason = nil
    self.isPlayerExitGame = false
end

function LoginServer:bind(account, passwd)
    self.account = account
    self.passwd = passwd
end

function LoginServer:installApp()
    if util.getInstallStatus() then
        return
    end
    self.api:installApp(function(...)
        self:onInstallApp(...)
    end)
end

function LoginServer:onInstallApp(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onInstallApp,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        return
    end
    util.setInstallStatus(1)
end

function LoginServer:register(verifyCode, inviteCode)
    --[[
    local callback = function()
        gg.uiManager:showTip(Utils.getText("Float_NetworkError"))
    end
    gg.uiManager:onOpenPnlLink("LoginServer_register", false, true, self.loginTimeOut, callback)
    ]]
    gg.event:dispatchEvent("onConnectChange", "START REGISTER", false)
    self.api:register(self.account, util.cryptPassword(self.passwd), verifyCode, inviteCode, function(...)
        self:onRegister(...)
    end)
end

function LoginServer:onRegister(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onRegister,status=%s,response=%s", responseCode, response)
        gg.event:dispatchEvent("onConnectChange", "REGISTER FAIL,NETWORK ERROR", true)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onRegister,code=%s,message=%s", response.code, response.message)
        gg.event:dispatchEvent("onConnectChange", "REGISTER FAIL," .. response.message, true)
        --[[
        if response.code == gg.Answer.code.ACCT_EXIST then
            return
        end
        ]]
        return
    else
        logger.logf("debug", "op=onRegister,account=%s,passwd=%s", self.account, self.passwd)
    end
    if not gg.config.loginAfterRegister then
        return
    end
    self.isSavePasswd = true
    self:login()
end

function LoginServer:login()
    gg.event:dispatchEvent("onConnectChange", "START LOGIN", false)
    self.api:login(self.account, util.cryptPassword(self.passwd), function(...)
        self:onLogin(...)
    end)
end

function LoginServer:onLogin(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onLogin,status=%s,response=%s", responseCode, response)
        gg.event:dispatchEvent("onConnectChange", "LOGIN FAIL,NETWORK ERROR", true)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onLogin,code=%s,message=%s", response.code, response.message)
        gg.event:dispatchEvent("onConnectChange", "LOGIN FAIL," .. response.message, true)
        return
    end
    self.token = response.data.token
    if self.isSavePasswd then
        util.saveAccountPassword(self.account, self.passwd)
        util.addOneSaveAccount(self.account, self.passwd)
    else
        util.saveAccountPassword(self.account, "")
        util.addOneSaveAccount(self.account, "")
    end

    gg.event:dispatchEvent("onConnectChange", "START SYNCH SERVER", false)
    self.api:getServerList(self.account, function(...)
        self:onGetServerList(...)
    end)
end

function LoginServer:vistorLogin()
    self.api:vistorLogin(self.account, self.passwd, function(...)
        self:onVistorLogin(...)
    end)
end

function LoginServer:onVistorLogin(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onVistorLogin,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onVistorLogin,code=%s,message=%s", response.code, response.message)
        return
    end
    self.account = response.data.account
    self.passwd = response.data.passwd
    self.token = response.data.token
    util.saveAccountPassword(self.account, self.passwd)
    logger.logf("debug", "op=onVistorLogin,account=%s,passwd=%s,token=%s", self.account, self.passwd, self.token)
    self.api:getServerList(self.account, function(...)
        self:onGetServerList(...)
    end)
end

function LoginServer:sendCode(account)
    self.api:sendCode(account, function(...)
        self:onSendCode(...)
    end)
end

function LoginServer:onSendCode(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=sendCode,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=sendCode,code=%s,message=%s", response.code, response.message)
        gg.uiManager:showTip(response.message)
        return
    end
    logger.logf("debug", "op=onSendCode,account=%s", response.data.account)
    gg.uiManager:showTip(constant.TXT_SEND_CODE_SUCCESS)
end

function LoginServer:chooseServer(serverId)
    self.chooseServerId = serverId
    self.api:getRoleList(self.account, serverId, function(...)
        self:onGetRoleList(...)
    end)
end

function LoginServer:onGetServerList(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onGetServerList,status=%s,response=%s", responseCode, response)
        gg.event:dispatchEvent("onConnectChange", "SYNCH SERVER FAIL,NETWORK ERROR", true)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onGetServerList,code=%s,message=%s", response.code, response.message)
        gg.event:dispatchEvent("onConnectChange", "SYNCH SERVER FAIL," .. response.message, true)
        return
    end
    self.serverList = response.data.serverlist
    table.sort(self.serverList, function(server1, server2)
        return server1.index < server2.index
    end)
    logger.logf("debug", "op=onGetServerList,serverList=%s", table.dump(self.serverList))

    gg.event:dispatchEvent("onConnectChange", "START SYNCH GAME", false)
    self.api:getRoleList(self.account, nil, function(...)
        self:onGetRoleList(...)
    end)
end

function LoginServer:onGetRoleList(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onGetRoleList,status=%s,response=%s", responseCode, response)
        gg.event:dispatchEvent("onConnectChange", "SYNCH GAME FAIL,NETWORK ERROR", true)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onGetRoleList,code=%s,message=%s", response.code, response.message)
        gg.event:dispatchEvent("onConnectChange", "SYNCH GAME FAIL," .. response.message, true)
        return
    end
    self.roleList = response.data.rolelist
    logger.logf("debug", "op=onGetRoleList,roleList=%s", table.dump(self.roleList))

    if #self.roleList == 0 then
        -- if not gg.config.autoCreateRole then
        --     return
        -- end
        -- local server = nil
        -- if self.chooseServerId then
        --     server = self:getGameServer(self.chooseServerId)
        -- end
        -- if not server then
        --     server = self:autoChooseGameServer()
        -- end
        -- if not server then
        --     logger.logf("info","op=autoChooseGameServer,fail=true")
        --     return
        -- end
        -- self.roleName = "roleName"
        -- self.heroId = 1001
        -- self:createRole(server,self.roleName,self.heroId)

        gg.uiManager:closeWindow("PnlConnect")
        gg.uiManager:openWindow("PnlSelectRace")

        -- local server = gg.client.loginServer:getServer()
        -- if server then
        --     -- gg.client.loginServer:createRole(server, self.createName, self.selectingRace, self.selectIcon)
        --     gg.client.loginServer:createRole(server, nil, self.selectingRace, self.selectIcon)
        -- end
    else
        if not gg.config.autoEnterGame then
            return
        end
        local role = self:autoChooseRole()
        self:enterGame(role)
    end
end

function LoginServer:getServer()
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
        logger.logf("info", "op=autoChooseGameServer,fail=true")
        return
    end

    return server
end

function LoginServer:resetPassword(account, passwd, verifyCode)
    self.newPasswd = passwd
    self.api:resetPassword(account, util.cryptPassword(passwd), verifyCode, function(...)
        self:onResetPassword(...)
    end)
end

function LoginServer:onResetPassword(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onResetPassword,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onResetPassword,code=%s,message=%s", response.code, response.message)
        gg.uiManager:showTip(response.message)
        return
    else
        local pnlLogin = gg.uiManager:getWindow("PnlLogin")
        if pnlLogin then
            pnlLogin.view.inputPassword.text = self.newPasswd
        end
        logger.logf("debug", "op=onResetPassword,account=%s", response.data.account)
        gg.uiManager:showTip(constant.TXT_RESET_PASSWORD_SUCCESS)
    end

    gg.uiManager:closeWindow("PnlForgetPassword")
end

function LoginServer:deleteAccount(account, passwd)
    self.api:deleteAccount(account, util.cryptPassword(passwd), function(...)
        self:onDeleteAccount(...)
    end)
end

function LoginServer:onDeleteAccount(responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onDeleteAccount,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onDeleteAccount,code=%s,message=%s", response.code, response.message)
        gg.uiManager:showTip(response.message)
        return
    else
        gg.client.loginServer.isPlayerExitGame = true
        returnLoginAndTips("ACCOUNT DELETE SUCCESS")
    end
end

function LoginServer:packToken(forward)
    return {
        token = self.token,
        account = self.account,
        version = self.api.version,
        forward = forward,
        device = self.api.device
    }
end

function LoginServer:createRole(server, name, race, head)
    gg.event:dispatchEvent("onConnectChange", "START CONNECT GAME", false)
    self:connectGameServer(server, function(gameServer)
        gameServer:send("C2S_CreateRole", {
            checktoken = self:packToken("CreateRole"),
            name = name,
            race = race,
            account = self.account,
            head = head
        })
        gg.event:dispatchEvent("onConnectChange", "START CREATE GAME", false)
    end, function(gameServer)
        gg.event:dispatchEvent("onConnectChange", "CONNECT GAME FAIL,NETWORK ERROR", true)
    end)
end

function LoginServer:onCreateRole(role)
    if not gg.config.enterGameAfterCreateRole then
        return
    end
    self:enterGame(role)
end

function LoginServer:enterGame(role)
    -- role.currentServerId = "game1"
    self.currentRole = role
    local server = self:getGameServer(role.currentServerId)
    if not server then
        logger.logf("info", "op=enterGame,currentServerId=%s,reason=serverNotFound", role.currentServerId)
        gg.event:dispatchEvent("onConnectChange", "SYNCH GAME FAIL,NETWORK BUSY", true)
        return
    end

    gg.event:dispatchEvent("onConnectChange", "START CONNECT GAME", false)
    self:connectGameServer(server, function(gameServer)
        gameServer:send("C2S_EnterGame", {
            roleid = role.roleid,
            checktoken = self:packToken("EnterGame")
        })
        gg.event:dispatchEvent("onConnectChange", "START ENTER GAME", false)
    end, function(gameServer)
        gg.event:dispatchEvent("onConnectChange", "CONNECT GAME FAIL,NETWORK ERROR", true)
    end)
end

--- ""
function LoginServer:getGameServer(serverId)
    for i, server in ipairs(self.serverList) do
        if server.id == serverId then
            return server
        end
    end
end

--- ""
function LoginServer:serverIsOpen(server)
    -- return server.is_open == 1 and server.is_down ~= 1
    return server.is_open == 1
end

function LoginServer:autoChooseGameServer()
    local serverList = self.serverList
    local servers = {}
    for i, server in ipairs(serverList) do
        if self:serverIsOpen(server) then
            table.insert(servers, server)
        end
    end
    table.sort(servers, function(server1, server2)
        if server1.busyness == server2.busyness then
            return server1.index < server2.index
        end
        return server1.busyness < server2.busyness
    end)
    return servers[1]
end

--- ""
-- @return ""
function LoginServer:autoChooseRole()
    local role = self.roleList[1]
    return role
end

function LoginServer:connectGameServer(server, onConnect, onConnectFail)
    self.lastServer = server
    gg.client:connectGameServer(server, onConnect, onConnectFail)
end

function LoginServer:onEnterGameSuccess()
    self.everEnterGameSuccess = true
    gg.event:dispatchEvent("onReIapPaySettle")
end

local ReconnectMaxValue = 10
function LoginServer:reconnectGameServer(value)
    if self.isPlayerExitGame then
        self.isPlayerExitGame = false
        logger.logf("info", "Player Auto Exit Game")
        return
    end
    if not self.everEnterGameSuccess then
        return
    end
    if self.checkReconnectTimer then
        return
    end

    print("start reconnectGameServer")

    local window = gg.uiManager:getWindow("PnlConnect")
    if not window or window.status ~= UIState.show then
        gg.uiManager:openWindow("PnlConnect")
    end

    gg.event:dispatchEvent("onConnectChange", "NETWORK DISCONNECT", false)

    value = value or 1

    local checkInterval = 3
    self.checkReconnectTimer = gg.timer:startLoopTimer(checkInterval, checkInterval, -1, function()
        if gg.battleManager.isInBattle then
            logger.logf("info", "Now In Battle")
            return
        end
        gg.timer:stopTimer(self.checkReconnectTimer)
        self.checkReconnectTimer = nil

        if self.kickReason then
            local kickReason = self.kickReason
            self.kickReason = nil
            logger.logf("info", "kick:" .. kickReason)
            returnLoginAndTips(kickReason)
            return
        end

        if value >= ReconnectMaxValue then
            -- "",""
            logger.logf("info", "reconnect overtimes")
            returnLoginAndTips("RECONNECT OVERTIMES,NETWORK ERROR")
            return
        end

        gg.event:dispatchEvent("onConnectChange",
            "START RECONNECT GAME " .. string.format("%s/%s", value, ReconnectMaxValue), false)
        self:connectGameServer(self.lastServer, function(gameServer)
            gameServer:send("C2S_EnterGame", {
                roleid = self.currentRole.roleid,
                checktoken = self:packToken("EnterGame")
            })
            gg.event:dispatchEvent("onConnectChange", "START ENTER GAME", false)
        end, function(gameServer)
            self:reconnectGameServer(value + 1)
            gg.event:dispatchEvent("onConnectChange", "RECONNECT GAME FAIL,NETWORK ERROR " ..
                string.format("%s/%s", value, ReconnectMaxValue), false)
        end)
    end)
end

-- ""
-- ============================================================================
function LoginServer:payReady(payChannel, payCurrency, payType, account, pid, productId, ext)
    local callback = function()
        gg.uiManager:showTip(Utils.getText("Float_NetworkError"))
    end
    gg.uiManager:onOpenPnlLink("LoginServer_payReady", false, true, 60)
    self.api:payReady(payChannel, payCurrency, payType, account, pid, productId, ext, function(...)
        self:onPayReady(...)
    end)
end

function LoginServer:onPayReady(responseCode, response)
    gg.event:dispatchEvent("onClosePnlPay")
    if responseCode ~= 200 then
        gg.uiManager:onClosePnlLink("LoginServer_payReady")

        logger.logf("debug", "op=onPayReady,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    if response.code ~= gg.Answer.code.OK then
        gg.uiManager:onClosePnlLink("LoginServer_payReady")

        logger.logf("debug", "op=onPayReady,status=%s,response=%s", responseCode, response)
        gg.uiManager:showTip(response.message)
        return
    end

    -- "",""payChannel""
    local order = response.data.order
    local payUrl = response.data.payUrl
    if order.payChannel ~= constant.PAYCHANNEL_APPSTORE and order.payChannel ~= constant.PAYCHANNEL_GOOGLEPLAY then
        gg.uiManager:onClosePnlLink("LoginServer_payReady")
    end
    if order.payChannel == constant.PAYCHANNEL_LOCAL then
        gg.client.loginServer:paySettle(order.orderId, PlayerData.enterGameInfo.account, order.productId, nil, nil, nil)
    elseif order.payChannel == constant.PAYCHANNEL_XSOLLA then
        CS.UnityEngine.Application.OpenURL(payUrl)
    elseif order.payChannel == constant.PAYCHANNEL_INTERNATION then
        CS.UnityEngine.Application.OpenURL(payUrl)
    elseif order.payChannel == constant.PAYCHANNEL_APPSTORE or order.payChannel == constant.PAYCHANNEL_GOOGLEPLAY then
        --redord order and pay for appstore
        gg.event:dispatchEvent("onPurchaseClicked", order)
    end
end

function LoginServer:paySettle(orderId, account, productId, receiptData, signtureData, signture)
    gg.event:dispatchEvent("onPaySettle", true)
    -- print("aaaapaySettle", orderId)
    self.api:paySettle(orderId, account, productId, receiptData, signtureData, signture, function(...)
        self:onPaySettle(...)
    end)
end

function LoginServer:onPaySettle(responseCode, response)
    -- print("aaaaonPaySettle", responseCode, response)
    if responseCode ~= 200 then
        logger.logf("debug", "op=onPaySettle,status=%s,response=%s", responseCode, response)
        return
    end
    response = cjson.decode(response)
    print("aaaaonPaySettleResponse", table.dump(response))
    local orderId = response.orderId
    gg.event:dispatchEvent("onIapPaySettle", orderId)
    if response.code ~= gg.Answer.code.OK then
        logger.logf("debug", "op=onPaySettle,status=%s,response=%s", responseCode, response)
        gg.uiManager:showTip(response.message)
        return
    end

    -- "",""

    gg.event:dispatchEvent("onPaySettle", false)

    gg.uiManager:showTip("order success")
end
-- ============================================================================

return LoginServer
