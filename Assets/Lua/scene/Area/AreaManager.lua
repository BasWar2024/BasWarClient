AreaManager = class("AreaManager")

function AreaManager:ctor()
    self.cloudMap = {}
    self.root = nil
    -- gg.event:addListener("onShowingSceneChange", self)
    -- gg.event:addListener("onRemoveBuilding", self)
    -- gg.event:addListener("onBaseChange", self)
    -- gg.event:addListener("onInitBuildData", self)

    -- gg.event:addListener("onUpdateBuildData", self)
end

function AreaManager:initArea()
    self.unlockArea = nil
    if not self.root then
        self.root = CS.UnityEngine.GameObject("CloudRoot")
        CS.UnityEngine.GameObject.DontDestroyOnLoad(self.root)
        self.cloudMap = {}
    end

    -- self:refresh()
end

function AreaManager:release()
    -- for _, clouds in pairs(self.cloudMap) do
    --     for _, value in pairs(clouds) do
    --         value:release()
    --     end
    -- end

    -- self.cloudMap = {}

    -- if self.root then
    --     CS.UnityEngine.GameObject.Destroy(self.root)
    -- end

    -- self.root = nil
    -- self.cloudMap = nil
end

function AreaManager:onShowingSceneChange()
    if not self.root then
        return
    end

    if gg.sceneManager.showingScene == constant.SCENE_BASE then
        self.root:SetActiveEx(true)
        self:refresh()
    elseif gg.sceneManager.showingScene == constant.SCENE_PLANET then
        self.root:SetActiveEx(true)
        self:refresh()
    elseif gg.sceneManager.showingScene == constant.SCENE_BATTLE then
        self.root:SetActiveEx(true)
    else
        self.root:SetActiveEx(false)
    end
end

function AreaManager:onRemoveBuilding()
    self:refresh()
end

function AreaManager:onBaseChange()
    self:refresh()
end

function AreaManager:onInitBuildData()
    self:initArea()
end

function AreaManager:refresh()
    local buildData = nil
    if gg.sceneManager.showingScene == constant.SCENE_BASE then
        buildData = BuildData.buildData
    elseif gg.sceneManager.showingScene == constant.SCENE_PLANET then
        buildData = gg.buildingManager.otherBuildDatas
    else
        return
    end

    local baseLevel = 0 -- gg.buildingManager:getBaseLevel()
    for key, value in pairs(buildData) do
        if value.cfgId == constant.BUILD_BASE then
            baseLevel = value.level
        end
    end

    local baseUnlockArea = 0
    for key, value in pairs(cfg.area) do
        if value.baseLevel <= baseLevel and value.id > baseUnlockArea then
            baseUnlockArea = value.id
        end
    end

    local unlockArea = 9999999999
    for key, value in pairs(buildData) do
        local buildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)

        if buildCfg and buildCfg.type == constant.BUILD_CLUTTER then
            if buildCfg.level < unlockArea then
                unlockArea = buildCfg.level
            end
        end
    end

    unlockArea = math.min(baseUnlockArea, unlockArea)
    if gg.sceneManager.showingScene == constant.SCENE_BASE then
        if not self.unlockArea then
            self.unlockArea = unlockArea
        else
            if self.unlockArea ~= unlockArea then
                self.unlockArea = self.unlockArea + 1
                unlockArea = self.unlockArea
            end
        end
    end

    unlockArea = 9999999999
    self.unlockArea = 9999999999
    self:setUnlockArea(unlockArea)
end

function AreaManager:setUnlockArea(unlockArea)
    -- local InitBuildLayout = cfg["global"].InitBuildLayout.intValue
    -- local allBuildCfgs = cfg.getCfg("presetBuildLayout", InitBuildLayout)
    -- local index = 1
    -- for k, v in pairs(allBuildCfgs.presetBuilds) do
    --     local pos = Vector3(v.x, 0, v.z)
    --     local buildCfg = cfg.getCfg("build", v.cfgId, v.level, v.quality)
    --     if buildCfg.type == constant.BUILD_CLUTTER and v.level > unlockArea then
    --         gg.buildingManager:setGridTable(pos, buildCfg.length, buildCfg.width, index, BuildingManager.OWNER_OWN)
    --         index = index + 1
    --     end
    -- end

    -- for key, value in pairs(cfg.area) do
    --     self:refreshArea(key, unlockArea)
    -- end
end

function AreaManager:refreshArea(id, unlockArea)
    local isLock = unlockArea < id

    local areaCfg = cfg.area[id]

    if isLock then
        if not self.cloudMap[id] then
            self.cloudMap[id] = {}
            for key, value in pairs(areaCfg.clouds) do
                local cloud = Cloud.new()
                cloud:setData(areaCfg, value)
                table.insert(self.cloudMap[id], cloud)
            end
        end
    else
        if self.cloudMap[id] then
            for key, value in pairs(self.cloudMap[id]) do
                value:release()
            end
            self.cloudMap[id] = nil
        end
    end
end
