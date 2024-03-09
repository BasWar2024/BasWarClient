print("lua main")
print(string.format("_VERSION=%s", _VERSION))
UnityEngine = CS.UnityEngine
ResMgr = CS.GG.ResMgr.instance
AudioMgr = CS.AudioMgr.instance

require "init"

function Awake()
    logger.init()
    logger.print("package.path", package.path)
    logger.print("package.cpath", package.cpath)
    global = UnityEngine.GameObject.Find("global")
    mainCamera = UnityEngine.GameObject.Find("Main Camera")
    CS.UnityEngine.GameObject.DontDestroyOnLoad(mainCamera)
    xlua = global:GetComponent("Lua")
    gg.initI18n()
    gg.timer = ggclass.Timer.new()
    gg.event = ggclass.Event.new()
    gg.playerMgr = ggclass.PlayerMgr.new()
    gg.client = ggclass.Client.new()
    gg.client:open()
    gg.gm = ggclass.GM.new()
    gg.sceneManager = ggclass.SceneManager.new()
    gg.buildingManager = ggclass.BuildingManager.new()
    gg.resPlanetManager = ggclass.ResPlanetManager.new()
    gg.battleManager = ggclass.BattleManager.new()
    gg.warShip = ggclass.WarShip.new()
    RedPointManager:init()

    if gg.config.debug then
        cmap.fReOpenStdOut("debug.log")
    end

    if not gg.warCameraCtrl then
        gg.warCameraCtrl = ggclass.WarCameraCtrl.new()
    end
end

function Start()
    gg.startCollectLocalVarsOnError()
    gg.uiManager = ggclass.UIManager.new()
    ResMgr:Init()
    AudioMgr:Init()
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
    
end

 function Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.F5) then
        openGMWindow()
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

-- 
function OnDestroy()
    exitGame()
end

function sendToGameServer(cmd,args)
    if not gg.client.gameServer then
        return
    end
    gg.client.gameServer:send(cmd,args)
end

function sendToSceneServer(cmd,args)
    if not gg.client.sceneServer then
        return
    end
    gg.client.sceneServer:send(cmd,args)
end

function doGm(cmdline)
    return gg.gm:doCmd(cmdline)
end

-- --  
-- function SendGameInput(gameInput)
--     -- print(GameInput)
--     gg.warCameraCtrl:startMoving(gameInput)
-- end

--
function returnLogin()
    exitGame()
    gg.client:stopAllTimer()
    clearData()
    gg.timer:startTimer(1,function ()
        gg.sceneManager:enterLoginScene()
    end)
end

--
function shutdown()
    UnityEngine.Application.Quit()
    exitGame()
end

function exitGame()
    -- 
    if gg.client.sceneServer then
        gg.client.sceneServer:close()
    end
    if gg.client.gameServer then
        gg.client.gameServer:close()
    end

    --clearData()
end

--
function clearData()
    gg.uiManager:destroyAllWindows()
    gg.sceneManager:releaseBaseScene()
    gg.playerMgr:clear()
end

------------------------------------------------------------------------------
--  
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

--  
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

--  
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

--  
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

--  
function onFingerUp(pos, go)
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
end

--  
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

-----------------------------------------------------------------------------------------