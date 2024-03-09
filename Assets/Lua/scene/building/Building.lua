local Building = class("Building")

Building.BUILD_2_view = {
    [1208001] = {
        viewName = "PnlFix",
        cfgId = 1208001,
        eventList = {"onItemRepareChange"}
    },
    [1204001] = {
        viewName = "PnlHeroHut",
        cfgId = 1204001,
        eventList = {"onHeroChange"}
    },
    [1205001] = {
        viewName = "PnlInstitute",
        cfgId = 1205001,
        eventList = {"onSoliderChange", "onMineChange"}
    },
    [1207001] = {
        viewName = "PnlSoldier",
        cfgId = 1207001,
        eventList = {}
    }
}

function Building:ctor(buildCfg, pos, buildData, itemId, owner)
    self.lastPos = Vector3(0, 0, 0)
    self.buildCfg = buildCfg
    self.buildData = buildData
    self.onSpace = true
    self.itemId = itemId
    self.eventList = {}
    self.lessTick = 999
    self.speedUpCallback = nil
    self.owner = owner
    if buildData then
        self.view = ggclass.BuildingView.new(self, self.buildCfg.model, self.buildCfg.length, self.buildCfg.width,
            Vector3(pos.x, pos.y, pos.z), true, self.buildCfg, owner)
        gg.buildingManager:setGridTable(pos, self.buildCfg.length, self.buildCfg.width, 1, self.owner)
    else
        self.view = ggclass.BuildingView.new(self, self.buildCfg.model, self.buildCfg.length, self.buildCfg.width,
            Vector3(pos.x, pos.y, pos.z), false, self.buildCfg, owner)
    end
end

function Building:onShow()
    self:bindEvent()

    if self.buildData then
        self:onUpdateBuildData(self.buildData)
    end

    self:excuteViewEvent()
end

function Building:excuteViewEvent()
    if Building.BUILD_2_view[self.buildCfg.cfgId] then
        local eventList = Building.BUILD_2_view[self.buildCfg.cfgId].eventList
        if next(eventList) then
            self.eventList = eventList
            for key, value in pairs(eventList) do
                self[value](self)
                gg.event:addListener(value, self)
            end
        end
    end
end

function Building:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.topUi:Find("BtnFork").gameObject):SetOnClick(function()
        self:onBtnFork()
    end)
    CS.UIEventHandler.Get(view.topUi:Find("BtnTick").gameObject):SetOnClick(function()
        self:onBtnTick()
    end)
    CS.UIEventHandler.Get(view.buttonUi:Find("BtnUpgrade").gameObject):SetOnClick(function()
        -- self:onBtnUpgrade()
        gg.uiManager:openWindow("PnlBuildInfo", {
            buildInfo = self.buildData,
            type = ggclass.PnlBuildInfo.TYPE_UPGRADE
        })
    end)
    CS.UIEventHandler.Get(view.buttonUi:Find("BtnRecycle").gameObject):SetOnClick(function()
        self:onBtnRecycle()
    end)
    CS.UIEventHandler.Get(view.buttonUi:Find("BtnTool").gameObject):SetOnClick(function()
        self:onBtnTool()
    end)
    CS.UIEventHandler.Get(view.buttonUi:Find("BtnInformation").gameObject):SetOnClick(function()
        gg.uiManager:openWindow("PnlBuildInfo", {
            buildInfo = self.buildData,
            type = ggclass.PnlBuildInfo.TYPE_INFO
        })
    end)

    CS.UIEventHandler.Get(view.btnBuildSpeedUp):SetOnClick(function()
        self:onBtnBuildSpeedUp()
    end)
end

function Building:onHeroChange()
    if not HeroData.ChooseingHero then
        return
    end
    if self.buildCfg.cfgId == constant.BUILD_HERO_HUT then
        local heroCfg = HeroUtil:getChooseHeroCfg()
        local data = HeroData.ChooseingHero

        if data.lessTick > 0 then
            local icon = heroCfg.icon
            -- 
            icon = "Big Roles_img"
            self:setTimeBar(data.lessTickEnd, data.lessTick, icon, constant.BUILD_TIME_PROGRESS_TYPE.HERO)

            self.speedUpCallback = function()
                HeroData.C2S_Player_SpeedUp_HeroLevelUp(data.id)
            end

        elseif data.skillUpLessTick > 0 then
            local skillCfg =
                HeroUtil:getSkillMap()[heroCfg["skill" .. data.skillUp]][data["skillLevel" .. data.skillUp]]
            local icon = skillCfg.icon
            -- 
            icon = "icon_Skill_1"
            self:setTimeBar(data.skillUpLessTickEnd, data.skillUpLessTick, icon,
                constant.BUILD_TIME_PROGRESS_TYPE.HERO_SKILL)

            self.speedUpCallback = function()
                HeroData.C2S_Player_SpeedUp_HeroSkillUp(data.id)
            end
        elseif self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.HERO or self.runningTimeBarType ==
            constant.BUILD_TIME_PROGRESS_TYPE.HERO_SKILL then
            self:setTimeBar(0, 0, nil, nil)
        end
    end
end

function Building:onItemRepareChange()
    local item = nil
    for key, value in pairs(ItemData.repairData) do
        if not item then
            item = value
        elseif value.endTime < item.endTime then
            item = value
        end
    end

    if item then
        self:setTimeBar(item.endTime, item.lessTick, "Durability_icon", constant.BUILD_TIME_PROGRESS_TYPE.FIX)
        self.speedUpCallback = function()
            ItemData.C2S_Player_RepairSpeed(item.id)
        end
    elseif self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.FIX then
        self:setTimeBar(0, 0, nil, nil)
    end
end

function Building:onSoliderChange()
    local isSet = false
    for key, value in pairs(BuildData.soliderLevelData) do
        if value.lessTickEnd > os.time() then
            isSet = true
            local curCfg = SoliderUtil:getSoliderCfgMap()[value.cfgId][value.level]
            self:setTimeBar(value.lessTickEnd, curCfg.levelUpNeedTick, "Big Roles_img",
                constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_SOLIDER)
            self.speedUpCallback = function()
                BuildData.C2S_Player_SpeedUp_SoliderLevelUp(value.cfgId)
            end
            break
        end
    end

    if not isSet and self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_SOLIDER then
        self:setTimeBar(0, 0, nil, nil)
    end
end

function Building:onMineChange()
    local isSet = false
    for key, value in pairs(BuildData.mineLevelData) do
        if value.lessTickEnd > os.time() then
            isSet = true
            local curCfg = MineUtil:getMineCfgMap()[value.cfgId][value.level]
            self:setTimeBar(value.lessTickEnd, curCfg.levelUpNeedTick, "Mayfliesray_icon",
                constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_MINE)
            self.speedUpCallback = function()
                BuildData.C2S_Player_SpeedUp_MineLevelUp(value.cfgId)
            end
            break
        end
    end

    if not isSet and self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_MINE then
        self:setTimeBar(0, 0, nil, nil)
    end
end

function Building:destroy()
    self:stopLessTick()
    gg.buildingManager:releaseBuilding(false)
    if self.buildData then
        gg.buildingManager:setGridTable(self.view.pos, self.view.length, self.view.width, 0, self.owner)
    end
    self:releaseEvent()
    self.view:destroy()
    self.view = nil
end

function Building:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.topUi:Find("BtnFork").gameObject)
    CS.UIEventHandler.Clear(view.topUi:Find("BtnTick").gameObject)
    CS.UIEventHandler.Clear(view.buttonUi:Find("BtnUpgrade").gameObject)
    CS.UIEventHandler.Clear(view.buttonUi:Find("BtnRecycle").gameObject)
    CS.UIEventHandler.Clear(view.buttonUi:Find("BtnInformation").gameObject)
    CS.UIEventHandler.Clear(view.buttonUi:Find("BtnTool").gameObject)
    CS.UIEventHandler.Clear(view.btnBuildSpeedUp)

    for i, eventName in ipairs(self.eventList) do
        gg.event:removeListener(eventName, self)
    end
end

-- 
function Building:onMoveBuilding(pos)
    self:showBuildUi(false)
    self.view:onMoveBuilding(pos)
end

-- 
function Building:onMoveLiberaborShip(pos)
    self.view:onMoveLiberaborShip(pos)
    self:showBuildUi(false)
end

function Building:setLiberaborShipTableKey(key)
    if key then
        self.liberaborShipTableKey = key
    else
        self.liberaborShipTableKey = self.temporaryKey
    end
end

-- 
function Building:backLastPos()
    self.view:setPos(self.lastPos)
    self.onSpace = true
end

-- 
function Building:contrastPos(pos)
    if not pos then
        return
    end
    local locPos = self.view.pos
    local minX = locPos.x
    local maxX = locPos.x + self.view.length
    local minZ = locPos.z
    local maxZ = locPos.z + self.view.width
    if pos.x >= minX and pos.x <= maxX and pos.z >= minZ and pos.z <= maxZ then
        return true
    end
    return false
end

function Building:onBtnFork()
    self:destroy()
end

function Building:onBtnTick()
    if self.itemId then
        local itemId = self.itemId
        local pos = self.view.pos
        if self.owner == BuildingManager.OWNER_OWN then
            ItemData.C2S_Player_MoveOutItemBag(itemId, pos)
        elseif self.owner == BuildingManager.OWNER_OTHER then
            local index = gg.resPlanetManager.curPlanet.index
            ResPlanetData.C2S_Player_ItemBagBuild2ResPlanet(index, itemId, pos)
        end
    else
        if self.onSpace then
            -- 
            local haveResources = gg.buildingManager:checkResources(self.buildCfg)
            local haveWorkers = gg.buildingManager:chenckWorkers()

            if haveResources and haveWorkers then
                gg.buildingManager:requestLoadBuilding(self.buildCfg.cfgId, self.view.pos)
            else
                -- 
                gg.uiManager:showTip("Insufficient resources")
            end
        end
    end
end

function Building:onBtnUpgrade()
    -- 
    local haveResources = gg.buildingManager:checkResources(self.buildCfg)
    local haveWorkers = gg.buildingManager:chenckWorkers()

    if haveResources and haveWorkers then
        BuildData.C2S_Player_BuildLevelUp(self.buildData.id)
    else
        -- 
        gg.uiManager:showTip("Insufficient resources")
    end
end

function Building:onBtnRecycle()
    if self.buildCfg.type == constant.BUILD_CLUTTER then
        BuildData.C2S_Player_RemoveMess(self.buildData.id)
    else
        local txt = "Are you sure you want to recycle this " .. self.buildCfg.name
        local callbackYes = function()
            local id = self.buildData.id
            if self.owner == BuildingManager.OWNER_OWN then
                ItemData.C2S_Player_Move2ItemBag(id, 11)
            elseif self.owner == BuildingManager.OWNER_OTHER then
                local index = gg.resPlanetManager.curPlanet.index
                ResPlanetData.C2S_Player_ResPlanetBuild2ItemBag(index, id)
            end
        end
        local args = {
            txt = txt,
            callbackYes = callbackYes
        }
        gg.uiManager:openWindow("PnlAlert", args)
    end
end

function Building:onBtnTool()
    local buildViewData = Building.BUILD_2_view[self.buildCfg.cfgId]
    local data = {
        buildData = self.buildData,
        buildCfg = self.buildCfg
    }
    if buildViewData then
        gg.uiManager:openWindow(buildViewData.viewName, data)
    end
end

function Building:onBtnBuildSpeedUp()
    if self.speedUpCallback then
        self.speedUpCallback()
    end
end

-- ui
function Building:showBuildUi(bool)
    if self.owner == BuildingManager.OWNER_OWN or gg.resPlanetManager:isMyResPlanet() then
        -- 
        local buttonUi = self.view.buttonUi
        if buttonUi then
            if self.buildData and not gg.warShip:getButtonUiActive() then
                if bool then
                    local point = self.view.buildingObj
                    local name = self.buildCfg.name
                    local level = self.buildData.level
                    gg.event:dispatchEvent("onShowBuildMsg", true, point, name, level)
                else
                    gg.event:dispatchEvent("onShowBuildMsg", false)
                end
                -- if self.lessTick > 0 then
                --     bool = false
                -- end
            else
                bool = false
            end
            buttonUi.gameObject:SetActive(bool)
            if bool then
                self.view:refreshButton()
            end
        end
    else
        -- 
        if gg.warShip:getButtonUiActive() then
            bool = false
        end
        self.view.infoUi.gameObject:SetActive(bool)
        if bool then
            local type = self.buildCfg.type
            local name = self.buildCfg.name
            local level = string.format("level:%s", self.buildCfg.level)
            local hp = string.format("HP:%s", self.buildCfg.maxHp)
            local damge = ""
            if type == constant.BUILD_DEFENSE or type == constant.BUILD_MINAES then
                damge = string.format("damge:%s", self.buildCfg.atk)
            end
            self.view.infoUi:Find("TxtName"):GetComponent("Text").text = name
            self.view.infoUi:Find("TxtLevel"):GetComponent("Text").text = level
            self.view.infoUi:Find("TxtHp"):GetComponent("Text").text = hp
            self.view.infoUi:Find("TxtDamage"):GetComponent("Text").text = damge
        end
    end
end

function Building:onHideRes(bool)
    if self.buildData then
        gg.event:dispatchEvent("onHideRes", self.buildData.id, bool)
    end
end

-- 
function Building:buildSuccessful(buildData)
    self.view.topUi.gameObject:SetActive(false)
    self.buildData = buildDatas
end

-- 
function Building:onUpdateBuildData(buildData)
    -- if self.buildCfg.type == constant.BUILD_CLUTTER then
    --     return
    -- end
    local view = self.view

    if view.buttonOnBuild then
        view.buttonOnBuild:SetActiveEx(false)
    end

    self.buildData = buildData
    self.lastPos = self.buildData.pos
    view:setPos(self.buildData.pos)
    self:showRes(self.buildData)
    self.buildCfg = gg.buildingManager:getCfg(self.buildData.cfgId, self.buildData.level)

    local buildViewData = Building.BUILD_2_view[self.buildCfg.cfgId]

    self.lessTick = buildData.lessTick
    local totalTime = self.buildCfg.levelUpNeedTick
    self.speedUpCallback = function()
        BuildData.C2S_Player_SpeedUp_BuildLevelUp(self.buildData.id)
    end

    local timeBarIcon = ""
    if self.lessTick == 0 then
        self.lessTick = buildData.lessTrainTick
        if self.lessTick > 0 then
            local soldierCfgId = buildData.trainCfgId
            local soldierLevel = 1
            for k, v in pairs(BuildData.soliderLevelData) do
                if soldierCfgId == v.cfgId then
                    soldierLevel = v.level
                end
            end
            local soldierCfg = cfg:getCfg("solider", soldierCfgId, soldierLevel)
            totalTime = buildData.lessTrainTick

            self.speedUpCallback = function()
                BuildData.C2S_Player_SpeedUp_SoliderTrain(self.buildData.id)
            end
            timeBarIcon = "Big Roles_img"
        end
    else
        timeBarIcon = "Upgrade_icon"
    end
    if self.lessTick > 0 then
        if self.buildCfg.level == 0 then
            -- 
        else
            -- 
        end
        self:setTimeBar(self.lessTick + os.time(), totalTime, timeBarIcon, constant.BUILD_TIME_PROGRESS_TYPE.BUILD)
    else
        if view.barTime then
            view.barTime.gameObject:SetActive(false)
        end

        if self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.BUILD then
            self:setTimeBar(0, 0, nil, nil)
        end

        self:excuteViewEvent()
    end
end

-- type = constant.BUILD_TIME_PROGRESS_TYPE.
function Building:setTimeBar(endTime, totalTime, icon, type)
    self.runningTimeBarType = type
    local view = self.view
    self:stopLessTick()
    view.barTime.gameObject:SetActive(true)
    view.buttonOnBuild:SetActiveEx(true)

    self.lessTickTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = endTime - os.time()
        if time <= 0 then
            self:stopLessTick()
            view.barTime.gameObject:SetActive(false)
            view.buttonOnBuild:SetActiveEx(false)
            return
        end
        view:setTimeBar(time / totalTime, time)
        view.txtBuildSpeedUpCost.text = cfg.global.SpeedUpPerMinute.intValue * math.ceil(time / 60)
    end)

    if icon then
        view:setTimeBarIcon(icon)
    else
        view:setTimeBarIcon("Upgrade_icon")
    end
end

function Building:stopLessTick()
    if self.lessTickTimer then
        gg.timer:stopTimer(self.lessTickTimer)
        self.lessTickTimer = nil
    end
end

-- 
function Building:showRes(buildData)
    local type = 0
    if buildData.curStarCoin > 0 then
        type = 1
    end
    if buildData.curIce > 0 then
        type = 2
    end
    if buildData.curCarboxyl > 0 then
        type = 3
    end
    if buildData.curTitanium > 0 then
        type = 4
    end
    if buildData.curGas > 0 then
        type = 5
    end
    if type ~= 0 then
        gg.event:dispatchEvent("onShowRes", buildData.id, self.view.operPoint.gameObject, type)
    else
        gg.event:dispatchEvent("onDestroyRes", buildData.id)
    end
end

-- 
function Building:buildGetResMsg(msg)

end

return Building
