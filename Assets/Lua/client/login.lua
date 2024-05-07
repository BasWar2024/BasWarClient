local net = {}

function net.S2C_CreateRoleSuccess(args)
    local role = args.role
    gg.uiManager:closeWindow("PnlSelectRace")
    gg.client.loginServer:onCreateRole(role)
end

function net.S2C_CreateRoleFail(args)
    local status = args.status
    local code = args.code
    local message = args.message

    gg.client.loginServer.isPlayerExitGame = true
    gg.uiManager:closeWindow("PnlConnect")

    returnLoginAndTips(message)
end

function net.S2C_EnterGameSuccess(args)
    gg.client.loginServer.kickReason = nil
    gg.uiManager:closeWindow("PnlConnect")
    gg.client.loginServer.isPlayerExitGame = false
    clearAllData()

    -- ""
    PlayerData.enterGameInfo = args

    local account = args.account
    local linkid = args.linkid
    local mapId = args.mapId
    gg.client:onEnterGame(mapId)

    logger.logf("debug", "op=onEnterGameSuccess,account=%s", account)
    gg.client.loginServer:onEnterGameSuccess()
end

function net.S2C_EnterGameFinish(args)
    local brief = args.brief

    logger.logf("debug", "op=S2C_EnterGameFinish,account=%s,pid=%s,name=%s", brief.account, brief.pid, brief.name)

    -- ""
    local player = gg.playerMgr:getPlayer(brief.pid)
    if player then
        player:setProperties(brief)
    end
    if gg.battleManager.isInBattle == false then
        gg.sceneManager:enterBaseScene()
    end
end

function net.S2C_EnterGameFail(args)
    local status = args.status
    local code = args.code
    local message = args.message

    gg.client.loginServer.isPlayerExitGame = true
    gg.uiManager:closeWindow("PnlConnect")

    if code == gg.Answer.code.LOW_VERSION then
        local callback = function()
            shutdown()
        end
        returnLoginAndTips(message, callback)
    else
        returnLoginAndTips(message)
    end

    -- if code == gg.Answer.code.LOW_VERSION then
    --     -- "",""
    --     local txt = Utils.getText("login_LowVersionTips")
    --     local callbackYes = function()
    --         xlua:onReDownload()
    --         -- shutdown()
    --     end
    --     local args = {
    --         txt = txt,
    --         callbackYes = callbackYes,
    --         btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
    --         txtYes = "OK"
    --     }
    --     gg.uiManager:openWindow("PnlAlert", args)
    -- else
    --     if code == -20018 then
    --         gg.event:dispatchEvent("onShowBanTips")
    --         gg.uiManager:closeWindow("PnlLink")
    --     else
    --         -- "",""
    --         local txt = Utils.getText("login_BackToLogin")
    --         local callbackYes = function()
    --             returnLogin()
    --         end
    --         local args = {
    --             txt = txt,
    --             callbackYes = callbackYes,
    --             btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
    --             txtYes = "OK"
    --         }
    --         gg.uiManager:openWindow("PnlAlert", args)
    --     end
    -- end
end

function net.S2C_ReEnterGame(args)
    local token = assert(args.token)
    local roleId = assert(args.roleid)
    local goServerId = assert(args.go_serverid)
    gg.client.loginServer.token = token
    gg.client.loginServer:enterGame({
        currentServerId = goServerId,
        roleid = roleId
    })
end

function net.S2C_Kick(args)
    local reason = args.reason
    -- TODO: ""
    gg.client.loginServer.kickReason = reason
end

function net.S2C_Pong(args)
    local str = args.str
    local time = args.time
    local token = args.token
    if token and #token > 0 then
        gg.client.loginServer.token = token
    end
    gg.client.gameServer.time = time -- milliseconds
    gg.client.gameServer.secTime = math.floor(time / 1000) -- seconds
    gg.client.lastPongTime = os.time()

    if str and #str > 0 then
        local clientTime = gg.timer:now()
        local curTick = math.floor(clientTime * 1000)
        local lastTick = math.floor(tonumber(str))
        local delay = math.floor((curTick - lastTick) / 2)
        gg.client.gameServer.delay = delay
        gg.event:dispatchEvent("onDelayChange", delay)
    end
end

function net.S2C_Hello(args)
    gg.randseed = args.randseed
end

function net.S2C_NameIsValid(args)
    local name = args.name
    local ok = args.ok
    local errmsg = args.errmsg
end

function net.S2C_BeReplace(args)
    local ip = args.ip
    -- TODO: ""
    gg.client.loginServer.isPlayerExitGame = true
    returnLoginAndTips("ACCOUNT REPLACE LOGIN")
end

return net
