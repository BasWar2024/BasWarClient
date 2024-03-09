local net = {}

function net.S2C_CreateRoleSuccess(args)
    local role = args.role
    gg.client.loginServer:onCreateRole(role)
end

function net.S2C_CreateRoleFail(args)
    local status = args.status
    local code = args.code
    local message = args.message
end

function net.S2C_EnterGameSuccess(args)
    local account = args.account
    local linkid = args.linkid
    local mapId = args.mapId
    gg.client:onEnterGame(mapId)

    logger.logf("debug","op=onEnterGameSuccess,account=%s",account)
    gg.client.loginServer:onEnterGameSuccess()

    gg.uiManager:closeWindow("PnlLogin")
    gg.uiManager:closeWindow("PnlRegister")
end

function net.S2C_EnterGameFinish(args)
    local brief = args.brief
    
    logger.logf("debug","op=S2C_EnterGameFinish,account=%s,pid=%s,name=%s",brief.account,brief.pid,brief.name)

    --
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

    if code == gg.Answer.code.LOW_VERSION then
        --,
        local txt = "Version too low click ok to close the game"
        local callbackYes =  function()
            shutdown()
        end
        local args = {txt = txt, callbackYes = callbackYes, type = "OK"}
        gg.uiManager:openWindow("PnlAlert", args)
    else
        --,
        local txt = "Return to the login page "
        local callbackYes =  function()
            returnLogin()
        end
        local args = {txt = txt, callbackYes = callbackYes, type = "OK"}
        gg.uiManager:openWindow("PnlAlert", args)
    end
end

function net.S2C_ReEnterGame(args)
    local token = assert(args.token)
    local roleId = assert(args.roleid)
    local goServerId = assert(args.go_serverid)
    gg.client.loginServer.token = token
    gg.client.loginServer:enterGame({
        currentServerId = goServerId,
        roleid = roleId,
    })
end

function net.S2C_Kick(args)
    local reason = args.reason
    -- TODO: 
    exitGame()
end

function net.S2C_Pong(args)
    local time = args.time
    local token = args.token
    if token and #token > 0 then
        gg.client.loginServer.token = token
    end
    gg.client.gameServer.time = time        -- milliseconds
    gg.client.lastPongTime = os.time()
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
    -- TODO: 
end

return net