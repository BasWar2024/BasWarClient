local SceneManager = class("SceneManager")
local cjson = require "cjson"

SceneManager.SCREENHEIGHT = 1080
SceneManager.SCREENWIDTH = 1920

function SceneManager:ctor()
    self.currentScene = nil
    self.sceneName = nil
    self.terrain = nil -- ""
    self.terrainScenes = nil
    -- self.worldmapSkyboxScenes = nil
    self.needJumpScene = false
    self.isGridGround = true
    self.showingScene = constant.SCENE_BASE
    self.jumpScene = constant.SCENE_BASE
    self.enemyData = {}
    self:calcBias()
    self:bindEvent()

end

function SceneManager:calcBias()
    local newScreenWidth = UnityEngine.Screen.width
    local newScreenHeight = UnityEngine.Screen.height

    local referenceProportion = SceneManager.SCREENWIDTH / SceneManager.SCREENHEIGHT
    local newProportion = newScreenWidth / newScreenHeight

    local referenceHeight = 0
    local referenceWidth = 0
    if newProportion >= referenceProportion then
        referenceHeight = SceneManager.SCREENHEIGHT
        referenceWidth = newProportion * SceneManager.SCREENHEIGHT
    else
        newProportion = newScreenHeight / newScreenWidth
        referenceWidth = SceneManager.SCREENWIDTH
        referenceHeight = newProportion * SceneManager.SCREENWIDTH
    end

    self.biasX = referenceWidth / newScreenWidth
    self.biasY = referenceHeight / newScreenHeight
end

function SceneManager:bindEvent()
    gg.event:addListener("onEnterGalaxyScene", self)
end

function SceneManager:clearEnterSceneOpenWindows(scene)
    self.enterSceneOpenWindowMap = self.enterSceneOpenWindowMap or {}
    self.enterSceneOpenWindowMap[scene] = nil
end

-- ""
function SceneManager:addEnterSceneOpenWindows(scene, window)
    self.enterSceneOpenWindowMap = self.enterSceneOpenWindowMap or {}
    self.enterSceneOpenWindowMap[scene] = self.enterSceneOpenWindowMap[scene] or {}

    table.insert(self.enterSceneOpenWindowMap[scene], window)
end

-- ""playerInScene，""。
function SceneManager:setShowingScene(scene)
    self.showingScene = scene
    if self.enterSceneOpenWindowMap and self.enterSceneOpenWindowMap[scene] then
        for index, value in ipairs(self.enterSceneOpenWindowMap[scene]) do
            gg.uiManager:openWindow(value)
        end
        self:clearEnterSceneOpenWindows(scene)
    end

    gg.event:dispatchEvent("onShowingSceneChange", scene)
end

-- ""
function SceneManager:enterLoginScene()
    self:setShowingScene(constant.SCENE_LOGIN)

    gg.uiManager:openWindow("PnlLoading", nil, function()
        local go = UnityEngine.GameObject.Find("PnlLaunch")
        UnityEngine.GameObject.Destroy(go)
    end)
    EffectUtil.initGrayMat()

    LOAD_PERCENT = 50

    self:setActiveScene("Terrain", function()
        LOAD_PERCENT = 80
        gg.uiManager:openWindow("PnlLogin")
        LOAD_PERCENT = 100
    end)
end

function SceneManager:laodMainTerrainScenes(callback)
    if not self.terrainScenes then
        ResMgr:LoadGameObjectAsync("Terrain_Yellow", function(go)
            go.transform.position = Vector3(0, -0.4, 0)
            self.terrainScenes = go
            self.galaxyBg = UnityEngine.GameObject.Find("GalaxyBg").gameObject
            self:setTerrainScenesActive(false)

            if callback then
                callback()
            end
            return true
        end, true)
    else
        if callback then
            callback()
        end
    end
end

function SceneManager:returnLoginScene(callback)
    self:setShowingScene(constant.SCENE_LOGIN)
    gg.uiManager:openWindow("PnlLoading")
    LOAD_PERCENT = 50

    LOAD_PERCENT = 80
    self:setTerrainScenesActive(false)
    if self.galaxyBg then
        self.galaxyBg:SetActive(false)
    end

    gg.uiManager:openWindow("PnlLogin", nil, callback)
    LOAD_PERCENT = 100
end

function SceneManager:setPostEffectBasic(isEnabled)
    -- gg.postEffectBasic.enabled = isEnabled
    -- gg.postEffectBasic.IsSupported = isEnabled
end

-- ""
function SceneManager:enterBaseScene()
    gg.uiManager:destroyAllWindows()
    gg.unloadUnusedAssets()

    self:setShowingScene(constant.SCENE_BASE)
    self.playerInScene = constant.SCENE_BASE

    gg.uiManager:openWindow("PnlLoading", nil, function()
        LOAD_PERCENT = 5
        gg.uiManager:openWindow("PnlMain")
        UnionData.C2S_Player_StarmapMatchPersonalGrids()

        ActivityData:checkDailyCheckNeedOpen()
        self:laodMainTerrainScenes(function()
            if self.terrain == nil then
                ResMgr:LoadGameObjectAsync("Terrain", function(go)
                    self.terrain = go
                    CS.UnityEngine.GameObject.DontDestroyOnLoad(go)
                    go.transform.rotation = Quaternion.identity
                    go.transform.position = Vector3(29, 0, 29)
                    go.transform:Find("BattleGround").gameObject:SetActive(false)
                    go.transform:Find("BaseGround").gameObject:SetActive(false)
                    go.name = string.format("Terrain")
                    LOAD_PERCENT = 10
                    -- ""
                    gg.buildingManager:loadGalaxyList()
                    self:loadBuildingListObj(constant.SCENE_BASE, function()
                        self:setPostEffectBasic(true)
                    end)
                    return true
                end, true)
            else
                self.terrain.gameObject:SetActive(true)
                gg.buildingManager:loadGalaxyList()
                self:loadBuildingListObj(constant.SCENE_BASE, function()
                end)
            end
        end)
    end)
end

-- ""
function SceneManager:releaseBaseScene()
    gg.uiManager:releaseWindow("PnlMain")
    -- gg.uiManager:releaseWindow("PnlPlanet")

    gg.uiManager:closeWindow("PnlPlayerInformation", 0)
    gg.uiManager:closeWindow("PnlMap", 0)
    -- gg.uiManager:closeWindow("PnlBattleReport", 0)

    gg.galaxyManager:destroyGalaxy()
    gg.warShip:releaseAllResources()
    gg.buildingManager:releaseAllResources()
    -- self.currentScene = nil
end

function SceneManager:releaseAllBuild()
    gg.warShip:releaseAllResources()
    gg.buildingManager:releaseOwnerBuilding()

end

function SceneManager:hideTerrain()
    if self.terrain then
        self.terrain.gameObject:SetActive(false)
    end
    self:releaseTempScene()
end

-- ""BattleMono
function SceneManager:releaseBattleMono()
    local battleMono = gg.battleManager.battleMono.gameObject
    if battleMono then
        local childCount = battleMono.transform.childCount - 1
        for i = childCount, 0, -1 do
            local go = battleMono.transform:GetChild(i).gameObject
            ResMgr:ReleaseAsset(go)
        end
        UnityEngine.GameObject.Destroy(battleMono)
    end
end

-- ""
function SceneManager:returnFormBatter()
    gg.uiManager:openWindow("PnlLoading", nil, function()
        gg.event:dispatchEvent("onPnlLoadingOpen")
        BattleData.setIsBattleEnd(true)
        AudioFmodMgr:ClearBattleBank()
        self:releaseTempScene()
        self:releaseBattleMono()
        self.jumpScene = self.playerInScene
        
        self.needJumpScene = true
        LOAD_PERCENT = 5
        SurfaceUtil.endSueface()
        if self.jumpScene == constant.SCENE_BASE then
            gg.uiManager:openWindow("PnlMain")
            self:setShowingScene(constant.SCENE_BASE)
            
        elseif self.jumpScene == constant.SCENE_GALAXY then
            self:setShowingScene(constant.SCENE_GALAXY)

        end
        self:loadBuildingListObj(self.jumpScene, function()
            LOAD_PERCENT = 10
        end)
        gg.unloadUnusedAssets()

    end)

    -- ResMgr:LoadSceneAsync("BaseScene", function()

    -- end, "Single")
end

function SceneManager:jumpSceneAction()
    if self.jumpScene == constant.SCENE_BASE then
        -- self:setShowingScene(constant.SCENE_BASE)
        self.needJumpScene = false
        self:setPostEffectBasic(true)

        LOAD_PERCENT = 100
    elseif self.jumpScene >= constant.SCENE_GALAXY then
        self.jumpScene = constant.SCENE_BASE
        if self.waitCameraMoveTimer then
            gg.timer:stopTimer(self.waitCameraMoveTimer)
        end
        gg.uiManager:closeWindow("PnlMain")
        local cfgId = gg.galaxyManager.onLookContenCfgId
        local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
        GalaxyData.C2S_Player_EnterStarmap(gg.galaxyManager:getAreaMembers(Vector2.New(curCfg.pos.x, curCfg.pos.y)))
    end
end

-- ""
function SceneManager:loadBuildingListObj(onScene, callback)
    CS.NewGameData:Init()
    gg.battleManager:clearAllBattleGameObj()
    CS.NewGameData._PoolManager:Clear()

    self:hideLandPoint()
    gg.warCameraCtrl:resetMoveAnim()
    gg.buildingManager:loadBuildingListObj(onScene, function()
        if onScene == constant.SCENE_BASE then
            self:waitCameraMove()
        end
        self.currentScene = gg.buildingManager.scene
        self.galaxyBg:SetActive(false)

        if callback then
            callback()
        end
    end)
end

function SceneManager:waitCameraMove()
    self.waitCameraMoveTimer = gg.timer:startLoopTimer(0, 0.01, -1, function()
        local window = gg.uiManager:getWindow("PnlLoading")
        if window and window:isHide() then
            gg.warCameraCtrl:setCameraPos(true, gg.warCameraCtrl.MODEL_BASE)
            gg.timer:stopTimer(self.waitCameraMoveTimer)
        end
    end)
end

function SceneManager:hideLandPoint()
    self.terrain.transform:Find("LandPoint").gameObject:SetActive(false)
    local deployArea = self.terrain.transform:Find("DeployArea")
    local max = deployArea.childCount
    for k = 1, max do
        deployArea:GetChild(k - 1).gameObject:SetActive(false)
    end
end

function SceneManager:getDeployArea()
    local _SigninPosId = CS.NewGameData._SigninPosId
    local deployArea = self.terrain.transform:Find("DeployArea")
    if _SigninPosId == 1 then
        return deployArea:Find("DeployArea1")
    elseif _SigninPosId == 2 then
        return deployArea:Find("DeployArea1")
    elseif _SigninPosId == 3 then
        return deployArea:Find("DeployArea3")
    elseif _SigninPosId == 4 then
        return deployArea:Find("DeployArea3")
    end
end

-- ""
function SceneManager:enterBattleScene(battleId, battleInfo, type, guideNode) -- type 0:""，1"", 2""
    -- print("aaaaaa", table.dump(battleInfo.battleMapInfo))
    self:releaseTempScene()
    gg.battleManager.isInBattle = true
    local pnlMain = gg.uiManager:getWindow("PnlMain")
    if pnlMain then
        pnlMain.destroyTime = 0
    end
    self:setShowingScene(constant.SCENE_BATTLE)
    local newBattleInfo = battleInfo
    -- self:releaseBaseScene()

    gg.uiManager:openWindow("PnlLoading", nil, function()
        if gg.uiManager.battleLoadingPnl ~= nil then
            gg.uiManager.battleLoadingPnl:close()
        end

        self.terrain.gameObject:SetActive(true)
        self.galaxyBg:SetActive(false)
        gg.buildingManager.galaxy:SetActive(false)
        self:releaseBaseScene()

        self.terrain.transform:Find("BattleGround").gameObject:SetActive(true)
        self.terrain.transform:Find("BaseGround").gameObject:SetActive(true)
        self:setPostEffectBasic(false)

        local battleMapInfo = battleInfo.battleMapInfo

        if type == 1 then
            battleMapInfo = newBattleInfo.battleInfo.battleMapInfo
        end
        -- battleMapInfo.sceneId = 3
        self:changeScene(battleMapInfo.sceneId, true)

        gg.warCameraCtrl:setCameraPos(false, gg.warCameraCtrl.MODEL_BATTLE)
        ResMgr:ClearGameObjPool()
        gg.unloadUnusedAssets()
        self:loadBattleMono(battleId, battleInfo, type, guideNode)
    end)

end

function SceneManager:loadBattleMono(battleId, battleInfo, type, guideNode)
    ResMgr:LoadGameObjectAsync("BattleMono", function(go)

        gg.battleManager:setBattleMono(go.transform:GetComponent("LockStepLogicMonoBehaviour"))
        self.terrain.gameObject:SetActive(true)
        local proLoadModels = self:getProLoadModels(battleInfo)
        gg.battleManager:initBattleLogic(battleId, cjson.encode(battleInfo), type)
        if type == 1 then
            battleInfo = {
                enemy = battleInfo.battleInfo.enemy
            }
        end
        self.currentScene = gg.battleManager.scene
        gg.uiManager:openWindow("PnlBattle", {
            battleInfo = battleInfo,
            guideNode = guideNode
        }, function()
            gg.battleManager.proloadHandleList = ResMgr:LoadGameObjectAssetsAsync(proLoadModels, function(go)
                LOAD_BATTLE_PERCENT = 100
                gg.battleManager:readyBattle()
                return true
            end)
        end)
        --gg.unloadUnusedAssets()

        -- self:loadTerrainScene(false, gg.warCameraCtrl.MODEL_BATTLE, function()
        --     LOAD_BATTLE_PERCENT = 100
        --     --""battleloading""

        --     -- self.updateTimer = gg.timer:startLoopTimer(gg.uiManager.uiRoot.passthoughEffect.PassThoughTime + 0.1, 1, 0, function ()
        --     --     gg.battleManager:readyBattle()
        --     -- end)
        -- end)
        return true
    end, true)

end

function SceneManager:getProLoadModels(battleInfo)
    local models = {}
    local i = 1

    local function setModel(model)
        if model == nil or model == "" then
            return
        end

        for k, v in pairs(models) do
            if v == model then
                return
            end
        end

        models[i] = model
        i = i + 1
    end

    if battleInfo["builds"] == nil then
        battleInfo = battleInfo["battleInfo"]
    end

    local builds = battleInfo["builds"]
    for k, v in pairs(builds) do
        setModel(v.model)
        setModel(v.explosionEffect)
        setModel(v.floor)
    end

    local soliders = battleInfo["soliders"]
    for k, v in pairs(soliders) do
        setModel(v.model)
        setModel(v.deadEffect)
    end

    local heros = battleInfo["heros"]
    for k, v in pairs(heros) do
        setModel(v.model)
        setModel(v.deadEffect)
    end

    local mainShip = battleInfo["mainShip"]
    setModel(mainShip.model)

    local skills = battleInfo["skills"]

    for k, v in pairs(skills) do
        setModel(v.stringArg1)
        setModel(v.stringArg2)
        setModel(v.stringArg3)
        setModel(v.stringArg4)
        setModel(v.stringArg5)
        setModel(v.stringArg6)
        setModel(v.stringArg7)
        setModel(v.stringArg8)
        setModel(v.stringArg9)
        setModel(v.stringArg10)
    end

    local heroSkills = battleInfo["heroSkills"]

    for k, v in pairs(heroSkills) do
        setModel(v.stringArg1)
        setModel(v.stringArg2)
        setModel(v.stringArg3)
        setModel(v.stringArg4)
        setModel(v.stringArg5)
        setModel(v.stringArg6)
        setModel(v.stringArg7)
        setModel(v.stringArg8)
        setModel(v.stringArg9)
        setModel(v.stringArg10)
    end

    local buffs = battleInfo["buffs"]
    for k, v in pairs(buffs) do
        setModel(v.model)
        setModel("Eff_CureSingle") --""
    end

    local summonSoliders = battleInfo["summonSoliders"]
    for k, v in pairs(summonSoliders) do
        setModel(v.model)
        setModel(v.deadEffect)
    end

    return models
end

function SceneManager:setBuildGridMax(curCfg)
    local newCfg = curCfg
    if not newCfg then
        newCfg = cfg["battleMap"][1]
    end
    local length = newCfg.length / 1000
    constant.BUILD_GRID_MAX = length + 5
    local gridGroundGo = self.terrain.transform:Find("GridGround")
    local posX = -(46 - length) / 2
    gridGroundGo.transform.localPosition = Vector3(posX, -0.11, posX)
    gridGroundGo.transform.localScale = Vector3(length, 0, length)
end

function SceneManager:changeScene(sceneId, isShowDeployArea)
    local curCfg = cfg["battleMap"][sceneId]
    if not curCfg then
        sceneId = 1
        curCfg = cfg["battleMap"][sceneId]
    end
    if sceneId == 1 then
        self:setTerrainScenesActive(true)
    else
        self:setTerrainScenesActive(false)
        ResMgr:LoadGameObjectAsync(curCfg.name, function(go)
            go.transform.position = Vector3(0, 0, 0)
            self.tempScene = go
            -- customReflection:SetReflection(sceneId - 1)
            return true
        end, true)
        self:setBuildGridMax(curCfg)
    end
    if isShowDeployArea then
        local deployArea = self.terrain.transform:Find("DeployArea")

        for i = 1, 4, 1 do
            local key = "signinPos" .. i
            local goName = "DeployArea" .. i
            if curCfg[key][1] then
                deployArea:Find(goName).gameObject:SetActiveEx(true)
                local x = curCfg[key][1] / 1000
                local y = curCfg[key][2] / 1000
                local z = curCfg[key][3] / 1000
                deployArea:Find(goName).localPosition = Vector3(x, y, z)
                key = "signinScale" .. i
                x = curCfg[key][1] / 1000
                y = curCfg[key][2] / 1000
                z = curCfg[key][3] / 1000
                deployArea:Find(goName).localScale = Vector3(x, y, z)
            else
                deployArea:Find(goName).gameObject:SetActiveEx(false)
            end
        end

        local baseGround = self.terrain.transform:Find("BaseGround")
        local skillAreaPos = curCfg["skillAreaPos"]
        local skillAreaScale = curCfg["skillAreaScale"]
        local x = skillAreaPos[1] / 1000
        local y = skillAreaPos[2] / 1000
        local z = skillAreaPos[3] / 1000
        local sx = skillAreaScale[1] / 1000
        local sy = skillAreaScale[2] / 1000
        local sz = skillAreaScale[3] / 1000
        baseGround.localPosition = Vector3(x, y, z)
        baseGround.localScale = Vector3(sx, sy, sz)
    end
end

function SceneManager:releaseTempScene()
    if self.tempScene then
        ResMgr:ReleaseAsset(self.tempScene)
        self.tempScene = nil
    end
end

function SceneManager:setTerrainScenesActive(bool)
    if not self.terrainScenes then
        return
    end
    self.terrainScenes:SetActive(bool)
    if self.terrain then
        self.terrain.transform:Find("GridBottom").gameObject:SetActive(bool)
    end
    if bool then
        self:setBuildGridMax()
    end
end

function SceneManager:stopGradientTimer()
    if self.gradientTimer then
        gg.timer:stopTimer(self.gradientTimer)
    end
end

function SceneManager:setGridGroundAlpna(isHide)
    if self.isGridGround == isHide then
        return
    end
    self.isGridGround = isHide
    local gridGroungMaterial = self.terrain.transform:Find("GridGround"):GetComponent("MeshRenderer").material
    local colorR = 255 / 255
    local colorG = 255 / 255
    local colorB = 255 / 255
    local minAlpha = 0
    local maxAlpha = 255
    local speed = 10
    local startAlpha
    local endAlpha
    local temp
    if isHide then
        startAlpha = maxAlpha
        endAlpha = minAlpha
        temp = -speed
    else
        startAlpha = minAlpha
        endAlpha = maxAlpha
        temp = speed
    end
    local alpha = startAlpha
    self:stopGradientTimer()
    self.gradientTimer = gg.timer:startLoopTimer(0, 0.03, -1, function()
        alpha = alpha + temp
        if alpha <= minAlpha then
            alpha = minAlpha
            self:stopGradientTimer()
        end
        if alpha >= maxAlpha then
            alpha = maxAlpha
            self:stopGradientTimer()
        end
        local colorA = alpha / 255
        gridGroungMaterial:SetColor("_BaseColor", Color.New(colorR, colorG, colorB, colorA))
    end)
end

-- data = { pos = pos, size = size}
function SceneManager:createFloorTexture(data)

    self.terrain.transform:Find("GridBottom").gameObject:SetActive(true)
    self.terrain.transform:Find("GridBottom"):GetComponent("GridBottom"):CreateFloorTexture(data)
end

function SceneManager:setDefaultFloorTexture()

    self.terrain.transform:Find("GridBottom").gameObject:SetActive(true)
    self.terrain.transform:Find("GridBottom"):GetComponent("GridBottom"):SetDefaultFloorTexture()
end

function SceneManager:onEnterGalaxyScene(args)
    gg.uiManager:closeWindow("PnlMain")
    self:enterGalaxyScene()
end

-- ""
function SceneManager:enterGalaxyScene()
    -- gg.uiManager:openWindow("PnlLoading", nil, function()
    -- end)
    self:releaseAllBuild()
    self:setShowingScene(constant.SCENE_GALAXY)
    self.playerInScene = constant.SCENE_GALAXY
    self.terrain.gameObject:SetActive(false)
    self:releaseTempScene()
    self:setPostEffectBasic(false)

    self.terrainScenes:SetActive(false)
    self.galaxyBg:SetActive(true)

    gg.uiManager:openWindow("PnlPlayerInformation")
    gg.uiManager:openWindow("PnlMap")
    gg.event:dispatchEvent("onShowButtonUi", -1)
    gg.event:dispatchEvent("onClickStellar")
    gg.event:dispatchEvent("onClickPlanet")
    gg.event:dispatchEvent("onShowPlatform", false, BuildingManager.OWNER_OWN)
    gg.event:dispatchEvent("onShowPlatform", true, BuildingManager.OWNER_OTHER)

    gg.buildingManager.ownBase:SetActive(false)
    gg.buildingManager.otherBase:SetActive(false)
    gg.buildingManager.galaxy:SetActive(true)

    gg.galaxyManager:loadGalaxy()

    gg.buildingManager:swichOwner(BuildingManager.OWNER_MAP)
    gg.unloadUnusedAssets()

    LOAD_PERCENT = 100

    -- if self.needJumpScene then
    --     if self.jumpScene == constant.SCENE_GALAXY then
    --         self.needJumpScene = false
    --         LOAD_PERCENT = 100
    --         -- else
    --         --     gg.galaxyManager:returnGalaxy()
    --     end
    -- else
    --     LOAD_PERCENT = 100
    -- end
end

-- ""
function SceneManager:returnBaseScene(callback)
    gg.uiManager:openWindow("PnlLoading", nil, function()
        self:setShowingScene(constant.SCENE_BASE)
        gg.buildingManager:initBase()
        self.playerInScene = constant.SCENE_BASE
        self.terrain.gameObject:SetActive(true)

        self:setPostEffectBasic(true)
        gg.uiManager:openWindow("PnlMain", nil, callback)
        gg.uiManager:closeWindow("PnlPlanet")
        gg.event:dispatchEvent("onShowPlatform", true, BuildingManager.OWNER_OWN)
        gg.event:dispatchEvent("onShowPlatform", false, BuildingManager.OWNER_OTHER)

        gg.buildingManager.ownBase:SetActive(true)
        gg.buildingManager.otherBase:SetActive(false)
        gg.buildingManager.galaxy:SetActive(false)

        gg.warCameraCtrl:setCameraPos(false, gg.warCameraCtrl.MODEL_BASE)

        self:releaseTempScene()
        -- customReflection:SetReflection(0)

        self.galaxyBg:SetActive(false)

        gg.buildingManager:swichOwner(BuildingManager.OWNER_OWN)
        gg.unloadUnusedAssets()

        -- LOAD_PERCENT = 100
    end)

end

-- ""
function SceneManager:enterPlanetScene(args, sceneId)
    gg.galaxyManager:destroyGalaxy()
    self:releaseAllBuild()
    self:setShowingScene(constant.SCENE_PLANET)
    self.terrain.gameObject:SetActive(true)
    self:setPostEffectBasic(true)
    gg.uiManager:openWindow("PnlPlanet", args)
    gg.uiManager:closeWindow("PnlMap")
    gg.uiManager:closeWindow("PnlMain")
    gg.event:dispatchEvent("onShowPlatform", false, BuildingManager.OWNER_OWN)
    gg.event:dispatchEvent("onShowPlatform", true, BuildingManager.OWNER_OTHER)

    gg.buildingManager.ownBase:SetActive(false)
    gg.buildingManager.otherBase:SetActive(true)
    gg.buildingManager.galaxy:SetActive(false)
    self:changeScene(sceneId)
    self.galaxyBg:SetActive(false)

    gg.warCameraCtrl:setCameraPos(false, gg.warCameraCtrl.MODEL_BASE)
    gg.buildingManager:swichOwner(BuildingManager.OWNER_OTHER)
    gg.unloadUnusedAssets()
end

-- ""
function SceneManager:onMove2ResPlanet()
    -- self.needJumpScene = true
    -- self.jumpScene = constant.SCENE_STELLAR
    -- gg.galaxyManager:returnGalaxy()
end

function SceneManager:returnFormPlanet(callback)
    if self.playerInScene == constant.SCENE_BASE then
        self:returnBaseScene(callback)
    elseif self.playerInScene == constant.SCENE_GALAXY then
        -- self:enterGalaxyScene()
        local cfgId = 0
        if gg.galaxyManager.curPlanet and gg.galaxyManager.curPlanet.cfgId then
            cfgId = gg.galaxyManager.curPlanet.cfgId
        else
            cfgId = gg.galaxyManager.onLookContenCfgId
        end
        local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
        gg.uiManager:openWindow("PnlLoading", nil, function()
            GalaxyData.C2S_Player_EnterStarmap(gg.galaxyManager:getAreaMembers(Vector2.New(curCfg.pos.x, curCfg.pos.y)))
        end)
    end
    gg.galaxyManager.curPlanet = nil
end

function SceneManager:setActiveScene(sceneName, cb)
    -- local scene = UnityEngine.SceneManagement.SceneManager.GetSceneByName(sceneName)
    -- UnityEngine.SceneManagement.SceneManager.SetActiveScene(scene)
    ResMgr:LoadSceneAsyncNotBundle(sceneName, cb)
end

return SceneManager
