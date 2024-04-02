print("lua main")
print(string.format("_VERSION=%s", _VERSION))
UnityEngine = CS.UnityEngine
ResMgr = CS.GG.ResMgr.instance
LanguageMgr = CS.LanguageMgr.instance
AudioFmodMgr = CS.AudioFmodMgr.instance
CryptUtil = CS.CryptUtil

-- IsAuditVersion = CS.Appconst.platform == "androidGooglePlay" or CS.Appconst.platform == "iosAppstore"

function IsAuditVersion()
    return false
end

function IsIOSAuditVersion()
    return false
end

-- function IsAuditVersion()
--     if CS.Appconst.platform == "androidGooglePlay" and (CS.Appconst.AppVersion == "1.6.3.100" or CS.Appconst.AppVersion == "1.7.3.100") then
--         return true
--     end

--     if IsIOSAuditVersion() then
--         return true
--     end

--     --return true
--     return false
-- end

-- function IsIOSAuditVersion()
--     if CS.Appconst.platform == "iosAppstore" and (CS.Appconst.AppVersion == "1.6.3.101" or CS.Appconst.AppVersion == "1.7.3.100") then
--         return true
--     end

--     -- return true
--     return false
-- end

require "init"

function Awake()
    logger.init()
    logger.print("package.path", package.path)
    logger.print("package.cpath", package.cpath)
    global = UnityEngine.GameObject.Find("global")

    rootCamera = UnityEngine.GameObject.Find("URPCamera")
    mainCamera = UnityEngine.GameObject.Find("Main Camera")
    -- uiCamera = UnityEngine.GameObject.Find("UIRoot/UICamera")
    gg.showDebugLog = global:GetComponent("ShowDebugLog")
    CS.UnityEngine.GameObject.DontDestroyOnLoad(rootCamera)
    xlua = global:GetComponent("Lua")
    customReflection = global:GetComponent("CustomReflection")

    -- gg.postEffectBasic = uiCamera:GetComponent("PostEffectBasic")

    gg.httpComponent = global:GetComponent("HttpComponent")

    gg.initI18n()
    gg.timer = ggclass.Timer.new()
    gg.event = ggclass.Event.new()
    gg.playerMgr = ggclass.PlayerMgr.new()
    gg.client = ggclass.Client.new()
    gg.client:open()
    gg.gm = ggclass.GM.new()
    gg.sceneManager = ggclass.SceneManager.new()
    gg.buildingManager = ggclass.BuildingManager.new()
    -- gg.resPlanetManager = ggclass.ResPlanetManager.new()
    gg.galaxyManager = ggclass.GalaxyManager.new()
    gg.battleManager = ggclass.BattleManager.new()
    gg.warShip = ggclass.WarShip.new()
    gg.droneManager = ggclass.DroneManager.new()
    gg.areaManager = ggclass.AreaManager.new()
    gg.areaManager:initArea()
    gg.activityManager = ggclass.ActivityManager.new()
    gg.inAppPurchaseManager = ggclass.InAppPurchaseManager.new()

    constant.initChatConstant()

    PvpUtil.init()



    -- if gg.config.debug then
    --     cmap.fReOpenStdOut("debug.log")
    -- end

    if not gg.warCameraCtrl then
        gg.warCameraCtrl = ggclass.WarCameraCtrl.new()
    end
end

function Start()
    gg.startCollectLocalVarsOnError()
    gg.uiManager = ggclass.UIManager.new()

    gg.guideManager = ggclass.GuideManager.new()
    gg.resEffectManager = ggclass.ResEffectManager.new()
    ResMgr:Init()
    AudioFmodMgr:Init()
    gg.audioManager = ggclass.AudioManager.new()
    RedPointManager:init()

    -- AudioFmodMgr:PlaySFX(constant.AUDIO_GAME_START.event)
    AudioFmodMgr:Play2DOneShot(constant.AUDIO_GAME_START.event, constant.AUDIO_GAME_START.bank)
    gg.resourcesManager = ggclass.ResourcesManager.new()

    LanguageMgr.ChangeLanguageAction = LanguageMgr.ChangeLanguageAction + function()
        gg.event:dispatchEvent("onLanguageChange")
    end

    gg.client.loginServer:installApp()

    local function openConnect()
        gg.uiManager:closeWindow("PnlConnect")
    end
    gg.uiManager:openWindow("PnlConnect", nil, openConnect)

    local temp = UnityEngine.PlayerPrefs.GetInt("isHotFixTest", 0)
    if temp == 1 then
        gg.client.loginServer.api.url = CS.Appconst.instance.loginServerTestUrl
    end

    gg.uiManager:openWindow("PnlTipNode")
end

function FixedUpdate()
    local deltaTime = UnityEngine.Time.fixedDeltaTime
    if gg.client.gameServer then
        gg.client.gameServer:onTick(deltaTime)
    end
    if gg.client.sceneServer then
        gg.client.sceneServer:onTick(deltaTime)
    end
    gg.timer:update(deltaTime)
    --[[ 
    if gg.sceneManager.currentScene then
        gg.sceneManager.currentScene:onHeartbeat(deltaTime)
    end 
    ]]

    -- gg.guideManager:FixedUpdate()
end

function Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.F5) then
        if xlua.IsCanGm then
            openGMWindow()
        end
    end
    -- if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.F1) then
    --     gg.unloadUnusedAssets()
    -- end

    gg.event:dispatchEvent("onUpData")

    if gg.guideManager then
        gg.guideManager:Update()
    end
end

function openGMWindow()
    local window = gg.uiManager:getWindow("PnlGMTool")
    if not window then
        gg.uiManager:openWindow("PnlGMTool")
    end
end

function AfterUpdate()
    gg.sceneManager:enterLoginScene()
end

-- ""
function OnDestroy()
    exitGame()
end

function sendToGameServer(cmd, args)
    if not gg.client.gameServer then
        return
    end
    gg.client.gameServer:send(cmd, args)
end

function sendToSceneServer(cmd, args)
    if not gg.client.sceneServer then
        return
    end
    gg.client.sceneServer:send(cmd, args)
end

function doGm(cmdline)
    return gg.gm:doCmd(cmdline)
end

-- -- "" ""
-- function SendGameInput(gameInput)
--     -- print(GameInput)
--     gg.warCameraCtrl:startMoving(gameInput)
-- end

function returnLoginAndTips(tips, callback)
    returnLogin(function()
        local txtTitel = Utils.getText("universal_Ask_Title")
        local txtTips = tips

        local txtYes = Utils.getText("universal_ConfirmButton")

        local args = {
            txtTitel = txtTitel,
            txtTips = txtTips,
            txtYes = txtYes,
            callbackYes = function()
                if callback then
                    callback()
                end
            end
        }
        gg.uiManager:openWindow("PnlAlertNew", args)
    end)
end

-- ""
function returnLogin(callback)
    gg.uiManager:destroyAllWindows()
    exitGame()
    gg.client:stopAllTimer()
    clearAllData()
    gg.timer:startTimer(1, function()
        gg.sceneManager:returnLoginScene(callback)
    end)
end

-- ""
function shutdown()
    UnityEngine.Application.Quit()
    exitGame()
end

function exitGame()
    -- ""
    if gg.client.sceneServer then
        gg.client.sceneServer:close()
    end
    if gg.client.gameServer then
        gg.client.gameServer:close()
    end
end

-- ""
function clearAllData()
    gg.playerMgr:clear()
    PlayerData.clear()
    clearGameData()
    gg.guideManager:clear()
    AutoPushData.clear()
    RedPointManager:clear()
end

function clearGameData()
    if gg.battleManager.isInBattle == false then
        -- gg.uiManager:destroyAllWindows()
        gg.sceneManager:releaseBaseScene()
        gg.buildingManager:releaseGalaxy()
        gg.sceneManager:hideTerrain()
        gg.uiManager:openWindow("PnlLoading")
    end
    UnionData.clearData()
    AchievementData.clear()
    BuildData.clear()
    UnionData.beginGridId = 0
    ShrineData.clear()
    ActivityData.clear()
    MailData.mailBriefData = {}
end

----------------------------------------------""--------------------------------
-- "" ""
function OnTap(pos, go)
    --[[
    if gg.buildingManager.isInBase then
        if gg.afterLongPass then
            gg.afterLongPass = false
        else
            if gg.buildingManager:checkBuilding(pos) then
            else
                gg.buildingManager:moveComplete()
            end
        end
    end 
    ]]
    local curScene = gg.sceneManager.currentScene
    if (curScene ~= nil and curScene.onTap ~= nil) then
        gg.sceneManager.currentScene:onTap(pos, go)
    end
end

-- "" ""
function onPinch(pos, go, delta, gap, phase)
    --[[
     gg.warCameraCtrl:zoomCamera(delta)
    gg.fingerDrag = 0   
    ]]
    local curScene = gg.sceneManager.currentScene
    if (curScene ~= nil and curScene.onPinch ~= nil) then
        gg.sceneManager.currentScene:onPinch(pos, go, delta, gap, phase)
    end
end

-- "" ""
function onFirstFingerDrag(pos, go, deltaMove, phase)
    --[[
    if gg.fingerDrag < 1 then
        gg.fingerDrag = gg.fingerDrag + 1
        return
    end
    if gg.fingerOnBuilding then
        gg.buildingManager:moveBuilding(pos)
        gg.longPass = false
    else
        gg.warCameraCtrl:startMoving(pos, deltaMove)    
    end
    ]]

    local curScene = gg.sceneManager.currentScene
    if (curScene ~= nil and curScene.onFirstFingerDrag ~= nil) then
        gg.sceneManager.currentScene:onFirstFingerDrag(pos, go, deltaMove, phase)
    end
end

-- "" ""
function onFingerDown(pos, go)
    --[[
    if gg.buildingManager.isInBase then
        if gg.buildingManager:checkFingerOnBuilding(pos) then
            gg.fingerOnBuilding = true
        end
    end  
    gg.fingerDrag = 0
    ]]

    local curScene = gg.sceneManager.currentScene
    if (curScene ~= nil and curScene.onFingerDown ~= nil) then
        gg.sceneManager.currentScene:onFingerDown(pos, go)
    end
end

-- "" ""
function onFingerUp(pos, go)
    --TestScreen()
    --[[ 
    if gg.buildingManager.isInBase then
        gg.fingerOnBuilding = false
        gg.buildingManager:releaseFinger()
        if gg.longPass then
            gg.longPass = false
            gg.afterLongPass = true
            gg.buildingManager:moveComplete()
        end
    elseif gg.battleManager.isInBattle and gg.fingerDrag <= 0 then
        gg.battleManager:onFingerUp(pos)
    end
    gg.fingerDrag = 0 
    ]]

    local curScene = gg.sceneManager.currentScene
    if (curScene ~= nil and curScene.onFingerUp ~= nil) then
        gg.sceneManager.currentScene:onFingerUp(pos, go)
    end

    gg.event:dispatchEvent("onFingerUp")
end

-- "" ""
function onLongPress(pos, go)
    --[[ 
    if gg.buildingManager.isInBase then
        if gg.buildingManager:checkBuilding(pos) then
            gg.fingerOnBuilding = true
            gg.longPass = true
        end
    end 
    ]]

    local curScene = gg.sceneManager.currentScene
    if (curScene ~= nil and curScene.onLongPress ~= nil) then
        gg.sceneManager.currentScene:onLongPress(pos, go)
    end
end

function TestScreen()
    print("ddddddddddddddddddddddddd")
    print(CS.UnityEngine.Screen.safeArea.center)
    print(CS.UnityEngine.Screen.safeArea.width)
    print(CS.UnityEngine.SystemInfo.deviceModel)
end

-----------------------------------------------------------------------------------------
