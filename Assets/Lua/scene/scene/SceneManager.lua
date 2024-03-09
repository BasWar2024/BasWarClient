local SceneManager = class("SceneManager")
local cjson = require "cjson"

function SceneManager:ctor()
    self.currentScene = nil
    self.sceneName = nil
    self.terrain = nil  --
    self.terrainScenes = nil
    self.worldmapSkyboxScenes = nil
end

function SceneManager:enterLoginScene()
    gg.uiManager:openWindow("PnlLoading")
    gg.uiManager:openWindow("PnlStatement")
    LOAD_PERCENT = 50
    ResMgr:LoadSceneAsync("LoginScene", function()
        LOAD_PERCENT = 80
        ResMgr:LoadSceneAsync("WorldmapSkyboxScenes", function()
            gg.uiManager:openWindow("PnlLogin")
            LOAD_PERCENT = 100
        end, "Additive")
    end, "Single")
end

function SceneManager:enterBaseScene(callback)
    gg.uiManager:openWindow("PnlLoading")
    mainCamera.gameObject:SetActive(true)
    LOAD_PERCENT = 50
    ResMgr:LoadSceneAsync("BaseScene", function()
        LOAD_PERCENT = 70 
        gg.uiManager:openWindow("PnlMain")
        if self.terrain == nil then
            ResMgr:LoadGameObjectAsync("Terrain",function (go)
                self.terrain = go
                CS.UnityEngine.GameObject.DontDestroyOnLoad(go)
                go.transform.rotation = Quaternion.identity
                go.transform.position = Vector3(29, 0, 29)
                go.transform:Find("BattleGround").gameObject:SetActive(false)
                go.transform:Find("BaseGround").gameObject:SetActive(false)
                go.name = string.format("Terrain")
                LOAD_PERCENT = 90
                self:loadBuildingListObj()
                return true
            end, true)
        else
            self:loadBuildingListObj() 
        end
    end, "Single")
end

function SceneManager:loadBuildingListObj(callback)
    self:hideLandPoint()
    gg.buildingManager:loadBuildingListObj(function()
        self:loadTerrainScene(true, function()
            if callback then
                callback()
            end
        end)
    end)
end

function SceneManager:loadTerrainScene(bool, callback)
    ResMgr:LoadSceneAsync("TerrainScenes", function()
        if callback then
            callback()
        end
        if bool then
            self:waitCameraMove(bool)
            self.currentScene = gg.buildingManager.scene
        else
            gg.warCameraCtrl:setCameraPos(Vector3.zero, bool)
        end
        LOAD_PERCENT = 100
        self.terrainScenes = UnityEngine.GameObject.Find("TerrainScenes").gameObject
    end, "Additive")
end

function SceneManager:waitCameraMove(bool)
    self.timer = gg.timer:startLoopTimer(0, 0.01, -1, function()
        local window = gg.uiManager:getWindow("PnlLoading")
        if window:isHide() then
            gg.warCameraCtrl:setCameraPos(Vector3.zero, bool)
            gg.timer:stopTimer(self.timer)
        end
    end)
end

function SceneManager:hideLandPoint()
    self.terrain.transform:Find("LandPoint").gameObject:SetActive(false)
    local deployArea = self.terrain.transform:Find("DeployArea")
    local max = deployArea.childCount
    for k = 1, max do
        deployArea:GetChild(k-1).gameObject:SetActive(false)
    end
end

function SceneManager:enterBattleScene(battleId, battleInfo)
    gg.uiManager:openWindow("PnlLoading")
    LOAD_PERCENT = 50
    self:releaseBaseScene()
    ResMgr:LoadSceneAsync("BattleScene", function()
        self.terrain.transform:Find("BattleGround").gameObject:SetActive(true)
        self.terrain.transform:Find("BaseGround").gameObject:SetActive(true)
        ResMgr:LoadGameObjectAsync("BattleMono",function (go)
            --CS.NewGameData.InitBattleJson = battleInfo
            gg.battleManager:setBattleMono(go.transform:GetComponent("LockStepLogicMonoBehaviour"))
            gg.battleManager:initBattleLogic(battleId, battleInfo)
            print("after gg.battleManager:initBattleLogic")
            self.currentScene = gg.battleManager.scene
            gg.uiManager:openWindow("PnlBattle")
            LOAD_PERCENT = 80
            self:loadTerrainScene(false, self:enterBattleSceneCallBack())
            return true
        end, true)
    end, "Single")
end

function SceneManager:enterBattleSceneCallBack()
    gg.battleManager:readyBattle()
end

function SceneManager:setGridGroungAlpna(alpha)
    local gridGroungMaterial = self.terrain.transform:Find("GridGround"):GetComponent("MeshRenderer").material
    local colorR = 128/255
    local colorG = 128/255
    local colorB = 128/255
    local colorA = alpha/255
    gridGroungMaterial:SetColor("_TintColor", Color.New(colorR, colorG, colorB, colorA))
end 

function SceneManager:releaseBaseScene()
    self.worldmapSkyboxScenes = nil
    self.terrainScenes = nil
    gg.uiManager:closeWindow("PnlMain")
    mainCamera.gameObject:SetActive(false)
    gg.buildingManager:releaseAllResources()
    gg.warShip:releaseAllResources()
    --self.currentScene = nil
end

function SceneManager:enterMapScene()
    gg.uiManager:openWindow("PnlMap")
    gg.buildingManager.ownBase:SetActive(false)
    gg.buildingManager.otherBase:SetActive(false)
    gg.buildingManager.resPlanet:SetActive(true)
    self.terrainScenes:SetActive(false)
    if self.worldmapSkyboxScenes then
        self.worldmapSkyboxScenes:SetActive(true)
        self:setActiveScene("worldmapSkyboxScenes")
        self.worldmapSkyboxScenes.transform:Find("Main Camera").gameObject:SetActive(false)
    else
        ResMgr:LoadSceneAsync("WorldmapSkyboxScenes", function()
            self.worldmapSkyboxScenes = UnityEngine.GameObject.Find("WorldmapSkyboxScenes").gameObject
            self.worldmapSkyboxScenes.transform:Find("Main Camera").gameObject:SetActive(false)
        end, "Additive")
    end
    gg.warCameraCtrl:setCameraPos(Vector3.zero)
    gg.buildingManager.baseOwner = BuildingManager.OWNER_MAP
end

function SceneManager:returnBaseScene()
    gg.uiManager:openWindow("PnlMain")
    gg.buildingManager.ownBase:SetActive(true)
    gg.buildingManager.otherBase:SetActive(false)
    gg.buildingManager.resPlanet:SetActive(false)
    self.worldmapSkyboxScenes:SetActive(false)
    gg.warCameraCtrl:setCameraPos(Vector3.zero)
    self.terrainScenes:SetActive(true)
    self:setActiveScene("terrainScenes")
    gg.buildingManager.baseOwner = BuildingManager.OWNER_OWN
end

function SceneManager:enterPlanetScene()
    gg.uiManager:openWindow("PnlPlanet")
    gg.uiManager:closeWindow("PnlMap")
    gg.buildingManager.ownBase:SetActive(false)
    gg.buildingManager.otherBase:SetActive(true)
    gg.buildingManager.resPlanet:SetActive(false)
    self.worldmapSkyboxScenes:SetActive(false)
    self.terrainScenes:SetActive(true)
    self:setActiveScene("terrainScenes")
    gg.warCameraCtrl:setCameraPos(Vector3.zero)
    gg.buildingManager.baseOwner = BuildingManager.OWNER_OTHER
end

function SceneManager:setActiveScene(sceneName)
    local scene = UnityEngine.SceneManagement.SceneManager.GetSceneByName(sceneName)
    UnityEngine.SceneManagement.SceneManager.SetActiveScene(scene)
end

return SceneManager