

PnlPersonalArmy = class("PnlPersonalArmy", ggclass.UIBase)

function PnlPersonalArmy:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onPersonalArmyChange", "onSetPnlDraftView" }
end

function PnlPersonalArmy:onAwake()
    self.view = ggclass.PnlPersonalArmyView.new(self.pnlTransform)

    self.itemList = {}
    for i = 1, 5, 1 do
        local trans = self.view.layoutPersonalArmyItems:GetChild(i - 1)
        table.insert(self.itemList, PersonalArmyItem.new(trans, self))
    end

    self.personalTeamSelectItems = {}
    for i = 1, 15, 1 do
        local trans = self.view.layoutTeamSelectItems:Find("PersonalTeamSelectItem" .. i)
        local item = PersonalTeamSelectItem.new(trans, self)
        table.insert(self.personalTeamSelectItems, item)
        item:setIndex(i)
    end

    self.selectItemList = {}
    self.selectScrollView = UIScrollView.new(self.view.selectScrollView, "PersonalArmySelectItem", self.selectItemList)
    self.selectScrollView:setRenderHandler(gg.bind(self.onRenderSelectItem, self))

    self.filterTypeItemList = {}
    self.filterScrollView = UIScrollView.new(self.view.filterScrollView, "BtnPersonArmyFilterType", self.filterTypeItemList)
    self.filterScrollView:setRenderHandler(gg.bind(self.onRenderFilterItem, self))
end

-- args = {fightCB = }
function PnlPersonalArmy:onShow()
    self:bindEvent()
    PlayerData.C2S_Player_ArmyFormationQuery()

    -- PlayerData.armyData = PlayerData.armyData or PlayerData.getDefaultArmyData()
    self.armyData = PlayerData.getDefaultArmyData()
    self:refreshPersonalArmyItems()
    self:setStage(PnlPersonalArmy.STAGE_NORMAL)
    self:refreshSoldierCount()
    self.view.layoutTeamSelectItems:SetActiveEx(false)

    for i = 6, 15, 1 do
        self.personalTeamSelectItems[i].transform:SetActiveEx(EditData.isEditMode)
    end
end

function PnlPersonalArmy:refreshPersonalArmyItems()
    self.view.layoutTeamSelectItems:SetActiveEx(true)
    for index, value in ipairs(self.itemList) do
        value:setData(index)
    end
end

function PnlPersonalArmy:refreshPersonalTeamSelectItems()
    for index, value in ipairs(self.personalTeamSelectItems) do
        value:refresh()
    end
end

function PnlPersonalArmy:onInputEnd(text)
    text =  FilterWords.filterWords(text)

    if text ~= self.armyData.armyName then
        PlayerData.C2S_Player_ArmyFormationUpdate(self.armyData.armyId, text)
    end
    gg.timer:addTimer(0.1, function ()
        self.view.inputName.interactable = false
    end)
end

function PnlPersonalArmy:onBtnChangeArmy(change)
    local idx = 0
    for index, value in ipairs(PlayerData.armyData) do
        if value.armyId == self.armyData.armyId then
            idx = index
        end
    end
    idx = idx + change

    local armyCount = #PlayerData.armyData
    if idx < 1 then
        idx = armyCount
    elseif idx > armyCount then
        idx = 1
    end

    self:setArmyData(PlayerData.armyData[idx])
end

function PnlPersonalArmy:onPersonalArmyChange()
    if PlayerData.armyData then
        if self.armyData then
            local armyData = self.armyData
            self.armyData = nil

            for key, value in pairs(PlayerData.armyData) do
                if armyData.armyId == value.armyId then
                    self.armyData = value
                end
            end
        end

        if not self.armyData then
            self.armyData = PlayerData.armyData[1]
        end
    end

    if not self.armyData then
        self.armyData = PlayerData.getDefaultArmyData()
        PlayerData.C2S_Player_ArmyFormationAdd(self.armyData.armyId, self.armyData.armyName)
        return
    end

    self:setArmyData(self.armyData)

    for key, value in pairs(self.selectItemList) do
        value:refreshUsed()
    end
end

function PnlPersonalArmy:onSetPnlDraftView()
    self:refreshSoldierCount()
end

function PnlPersonalArmy:addNewArmy()
    self.armyData = PlayerData.getDefaultArmyData()
    self:refreshPersonalArmyItems()
    PlayerData.C2S_Player_ArmyFormationAdd(self.armyData.armyId, self.armyData.armyName)
end

function PnlPersonalArmy:setArmyData(armyData)
    self.armyData = gg.deepcopy(armyData)
    self:refreshPersonalArmyItems()
    self.view.inputName.text = self.armyData.armyName

    self:refreshPersonalTeamSelectItems()
end

function PnlPersonalArmy:loadArmy(armyData)
    self:setArmyData(armyData)
    self:setStage(PnlPersonalArmy.STAGE_NORMAL)
end

PnlPersonalArmy.STAGE_NORMAL = 1
PnlPersonalArmy.STAGE_SET = 2
PnlPersonalArmy.STAGE_LOAD = 3

function PnlPersonalArmy:setStage(stage)
    local view = self.view

    if self.stage == stage then
        return
    end

    self.stage = stage

    view.layoutSelect:SetActiveEx(false)

    if stage == PnlPersonalArmy.STAGE_NORMAL then
        -- view.layoutSelect:SetActiveEx(false)
    elseif stage == PnlPersonalArmy.STAGE_SET then
        view.layoutSelect:SetActiveEx(true)

    elseif stage == PnlPersonalArmy.STAGE_LOAD then
        -- view.layoutSelect:SetActiveEx(false)
    end

    view.btnFight:SetActiveEx(false)
    view.btnFast:SetActiveEx(false)

    for key, value in pairs(self.itemList) do
        value:refreshStage()
    end
    self:refreshSoldierCount()
end

function PnlPersonalArmy:onRenderSelectItem(obj, index)
    local item = PersonalArmySelectItem:getItem(obj, self.selectItemList, self)
    item:setData(self.selectDataList[index])
end

PnlPersonalArmy.SELECT_TYPE_HERO = 1
PnlPersonalArmy.SELECT_TYPE_Soldier = 2

function PnlPersonalArmy:beginSelect(personalArmyItem, selectType)
    self.settingPersonalArmyItem = personalArmyItem
    self.selectType = selectType

    self:setStage(PnlPersonalArmy.STAGE_SET)
    self.filterMap = self.filterMap or {}
    self.filterMap[PnlPersonalArmy.FILTER_TYPE_QUALITY] = PnlPersonalArmy.sortQualityInfo[1]
    self.filterMap[PnlPersonalArmy.FILTER_TYPE_RACE] = PnlPersonalArmy.sortRaceInfo[1]

    self:refreshFilterText(PnlPersonalArmy.FILTER_TYPE_QUALITY)
    self:refreshFilterText(PnlPersonalArmy.FILTER_TYPE_RACE)

    self.filterType = nil
    self.view.filterScrollView:SetActiveEx(false)

    if self.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
        self.view.btnFilterQuality:SetActiveEx(true)

        self:refreshSelectHero()
        self.view.txtSelectName.text = Utils.getText("formation_SelectHeroTitle")
    elseif self.selectType == PnlPersonalArmy.SELECT_TYPE_Soldier then
        self.view.btnFilterQuality:SetActiveEx(false)

        self:refreshSelectSoldier()
        self.view.txtSelectName.text = Utils.getText("formation_SelectSoldierTitle")
    end
end

PnlPersonalArmy.sortQualityInfo = {
    {
        nameKey = "bag_All",
        filterAttr = nil,
    },
    {
        name = "L",
        filterAttr = {quality = 5,},
    },
    {
        name = "SSR",
        filterAttr = {quality = 4,},
    },
    {
        name = "SR/S",
        filterAttr = {quality = 3,},
    },
    {
        name = "R/A",
        filterAttr = {quality = 2,},
    },
    {
        name = "N/B",
        filterAttr = {quality = 1,},
    },
}

PnlPersonalArmy.sortRaceInfo = {
    {
        nameKey = "bag_All",
        filterAttr = nil,
    },
    {
        nameKey = constant.RACE_MESSAGE[constant.RACE_HUMAN].languageKey,
        filterAttr = {race = constant.RACE_HUMAN},
    },
    {
        nameKey = constant.RACE_MESSAGE[constant.RACE_CENTRA].languageKey,
        filterAttr = {race = constant.RACE_CENTRA},
    },
    {
        nameKey = constant.RACE_MESSAGE[constant.RACE_SCOURGE].languageKey,
        filterAttr = {race = constant.RACE_SCOURGE},
    },
    {
        nameKey = constant.RACE_MESSAGE[constant.RACE_ENDARI].languageKey,
        filterAttr = {race = constant.RACE_ENDARI},
    },
    {
        nameKey = constant.RACE_MESSAGE[constant.RACE_TALUS].languageKey,
        filterAttr = {race = constant.RACE_TALUS},
    },
}

PnlPersonalArmy.FILTER_TYPE_QUALITY = 1
PnlPersonalArmy.FILTER_TYPE_RACE = 2

function PnlPersonalArmy:onBtnFilter(filterType, btn)
    if self.filterType == filterType then
        self.view.filterScrollView:SetActiveEx(false)
        self.filterType = nil
        return
    end

    self.filterType = filterType
    self.view.filterScrollView:SetActiveEx(true)

    local pos = btn.transform.anchoredPosition
    pos.x = pos.x - btn.transform.rect.width / 2
    pos.y = pos.y - btn.transform.rect.height / 2

    self.view.filterScrollView.anchoredPosition = pos
    self:openSort(filterType)
end

function PnlPersonalArmy:openSort(filterType)
    if filterType == PnlPersonalArmy.FILTER_TYPE_QUALITY then
        self.filterData = PnlPersonalArmy.sortQualityInfo

    elseif filterType == PnlPersonalArmy.FILTER_TYPE_RACE then
        self.filterData = PnlPersonalArmy.sortRaceInfo
    end
    self.filterScrollView:setItemCount(#self.filterData)
end

function PnlPersonalArmy:setFilter(data)
    self.filterMap[self.filterType] = data

    self:refreshFilterText(self.filterType)

    if self.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
        self:refreshSelectHero()
    elseif self.selectType == PnlPersonalArmy.SELECT_TYPE_Soldier then
        self:refreshSelectSoldier()
    end

    for key, value in pairs(self.filterTypeItemList) do
        value:refreshSelect()
    end

    self.filterType = nil
    self.view.filterScrollView:SetActiveEx(false)
end

function PnlPersonalArmy:refreshFilterText(filterType)
    -- for key, value in pairs(self.filterMap) do

    local data = self.filterMap[filterType]

    local textSet

    if filterType == PnlPersonalArmy.FILTER_TYPE_QUALITY then
        textSet = self.view.txtBtnFilterQuality
    elseif filterType == PnlPersonalArmy.FILTER_TYPE_RACE then
        textSet = self.view.txtBtnFilterRace
    end

    if data.nameKey then
        textSet.text = Utils.getText(data.nameKey)
    else
        textSet.text = data.name
    end
    -- end
end

function PnlPersonalArmy:onRenderFilterItem(obj, index)
    local item = BtnPersonArmyFilterType:getItem(obj, self.filterTypeItemList, self)
    item:setData(self.filterData[index])
end

function PnlPersonalArmy:select(data)
    self.settingPersonalArmyItem:setSelectData(data)
    self:setStage(PnlPersonalArmy.STAGE_NORMAL)
    -- for key, value in pairs(self.selectItemList) do
    --     value:refreshUsed()
    -- end
end

function PnlPersonalArmy:removeSelect(data)
    if self.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
        self.settingPersonalArmyItem:onBtnDeleteHero()
        self:setStage(PnlPersonalArmy.STAGE_NORMAL)
    elseif  self.selectType == PnlPersonalArmy.SELECT_TYPE_Soldier then
        self.settingPersonalArmyItem:onBtnDeleteSoldier()
        self:setStage(PnlPersonalArmy.STAGE_NORMAL)
    end
end

function PnlPersonalArmy:checkFilter(cfg)
    local isFilter = false
    for _, filterData in pairs(self.filterMap) do
        if filterData.filterAttr then
            for key, attr in pairs(filterData.filterAttr) do
                if cfg[key] ~= attr then
                    isFilter = true
                    break
                end
            end
        end
    end
    return isFilter
end

function PnlPersonalArmy:refreshSelectHero()
    self.selectDataList = {}

    local selectingHeroId = self.settingPersonalArmyItem.teamData.heroId
    local selectingHero = nil

    for key, value in pairs(HeroData.heroDataMap) do
        if selectingHeroId and selectingHeroId == value.id then
            selectingHero =  {hero = value}
        else
            if value.ref == constant.REF_NONE or value.ref == constant.REF_LEVELUP then
                local heroCfg = HeroUtil.getHeroCfg(value.cfgId, value.level, value.quality)
                if not self:checkFilter(heroCfg) then
                    table.insert( self.selectDataList, {hero = value})
                end
            end
        end
    end

    table.sort( self.selectDataList, function (a, b)
        if a.hero.level ~= b.hero.level then
            return a.hero.level > b.hero.level
        end

        if a.hero.quality ~= b.hero.quality then
            return a.hero.quality > b.hero.quality
        end

        return a.hero.id > b.hero.id
    end)

    if selectingHero then
        table.insert(self.selectDataList, 1, selectingHero)
    end

    -- local selectingHeroId = self.settingPersonalArmyItem.teamData.heroId
    -- if selectingHeroId and selectingHeroId > 0 then
    --     table.insert( self.selectDataList, 1, {hero = HeroData.heroDataMap[selectingHeroId]})
    -- end
    
    self.selectScrollView:setItemCount(#self.selectDataList)
end

function PnlPersonalArmy:refreshSelectSoldier()
    self.selectDataList = {}

    local selectingSoldierData = nil
    local selectingHeroCfgId = self.settingPersonalArmyItem.teamData.soliderCfgId

    for key, value in pairs(BuildData.soliderLevelData) do
        if selectingHeroCfgId and selectingHeroCfgId > 0 and selectingHeroCfgId == value.cfgId then
            selectingSoldierData = {soldierLevelData = value}
        else
            local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][value.level]
            if soldierCfg.belong == 1 and SoliderUtil.isInSoldierWhiteList(value.cfgId) then
                if not self:checkFilter(soldierCfg) then
                    table.insert(self.selectDataList, {soldierLevelData = value})
                end
            end
        end
    end

    -- if settingTeamData.soliderCfgId and settingTeamData.soliderCfgId == soldierLevelData.cfgId then
    --     isSetting = true
    -- end

    table.sort(self.selectDataList, function (a, b)
        local unlockA = a.soldierLevelData.level > 0
        local unlockB = b.soldierLevelData.level > 0
        if unlockA ~= unlockB then
            return unlockA
        end

        if a.soldierLevelData.level ~= b.soldierLevelData.level then
            return a.soldierLevelData.level > b.soldierLevelData.level
        end

        return a.soldierLevelData.cfgId < b.soldierLevelData.cfgId
    end)

    if selectingSoldierData then
        table.insert(self.selectDataList, 1, selectingSoldierData)
    end

    self.selectScrollView:setItemCount(#self.selectDataList)
end

function PnlPersonalArmy:refreshSoldierCount()
    local view = self.view

    local maxSpace = 0
    local totalCount = 0

    for key, value in pairs(BuildData.buildData) do
        if value.cfgId == constant.BUILD_DRAFT then
            local buildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)
            maxSpace = maxSpace + buildCfg.maxTrainSpace

            if DraftData.reserveArmys[value.id] then
                totalCount = totalCount + DraftData.reserveArmys[value.id].count
            end
        end
    end

    view.txtSoldierCount.text = totalCount .. "/" .. maxSpace
end

function PnlPersonalArmy:onHide()
    self:releaseEvent()
end

function PnlPersonalArmy:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    CS.UIEventHandler.Get(view.btnFast):SetOnClick(function()
        self:onBtnFast()
    end)
    
    CS.UIEventHandler.Get(view.btnFight):SetOnClick(function()
        self:onBtnFight()
    end)

    self:setOnClick(view.btnReturnSelect, gg.bind(self.onBtnReturnSelect, self))
    self:setOnClick(view.btnChangeName, gg.bind(self.onBtnChangeName, self))

    self:setOnClick(view.btnFont, gg.bind(self.onBtnChangeArmy, self, -1))
    self:setOnClick(view.btnNext, gg.bind(self.onBtnChangeArmy, self, 1))

    self:setOnClick(view.btnFilterQuality, gg.bind(self.onBtnFilter, self, PnlPersonalArmy.FILTER_TYPE_QUALITY, view.btnFilterQuality))
    self:setOnClick(view.btnFilterRace, gg.bind(self.onBtnFilter, self, PnlPersonalArmy.FILTER_TYPE_RACE, view.btnFilterRace))

    view.inputName.onEndEdit:AddListener(gg.bind(self.onInputEnd, self))
end

function PnlPersonalArmy:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSort)
    CS.UIEventHandler.Clear(view.btnFast)

    view.inputName.onEndEdit:RemoveAllListeners()
end

function PnlPersonalArmy:onDestroy()
    local view = self.view
    self.selectScrollView:release()
    self.filterScrollView:release()

    for key, value in pairs(self.personalTeamSelectItems) do
        value:release()
    end
end

function PnlPersonalArmy:onBtnClose()
    self:close()
end

function PnlPersonalArmy:onBtnReturnSelect()
    self:setStage(PnlPersonalArmy.STAGE_NORMAL)
end

function PnlPersonalArmy:onBtnChangeName()
    self.view.inputName.interactable = true
    self.view.inputName:ActivateInputField()
end

function PnlPersonalArmy:onBtnFast()
end

function PnlPersonalArmy:onBtnFight()
    local team1 = self.armyData.teams[1]
    if (team1.heroId and team1.heroId > 0) or (team1.soliderCfgId and team1.soliderCfgId > 0) then
        if self.args.fightCB then
            self.args.fightCB(self.armyData.armyId)
            self:close()
        end
    else
        gg.uiManager:showTip("empty team")
    end
end

-- guide
-- ""ui
-- override
function PnlPersonalArmy:getGuideRectTransform(guideCfg)

    if guideCfg.otherArgs then
        if guideCfg.otherArgs[1] == "startSelectHero" then
            return self.itemList[1].layoutEmp
    
        elseif guideCfg.otherArgs[1] == "selectHero" then
            local data = self.selectDataList[1]
            for key, value in pairs(self.selectItemList) do
                if value.data == data then
                    self.guidingItem = value
                    return value.transform
                end
            end
            return
    
        elseif guideCfg.otherArgs[1] == "startSelectSoldier" then
            return self.itemList[1].btnSetSoldier
    
        elseif guideCfg.otherArgs[1] == "selectSoldier" then
            local data = self.selectDataList[1]
    
            for key, value in pairs(self.selectItemList) do
                if value.data == data then
                    self.guidingItem = value
                    return value.transform
                end
                -- print(value.data.soldierLevelData.cfgId, guideCfg.otherArgs[2])
                -- if value.data and value.data.soldierLevelData and value.unlock then
                --     self.guidingItem = value
                --     return value.transform
                -- end
            end
            return
        end
    end

    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlPersonalArmy:triggerGuideClick(guideCfg)

    if guideCfg.otherArgs then
        if guideCfg.otherArgs[1] == "startSelectHero" then
            self.itemList[1]:onBtnSetHero()
            return
    
        elseif guideCfg.otherArgs[1] == "selectHero" then
            self.guidingItem:onClickItem()
            return
    
        elseif guideCfg.otherArgs[1] == "startSelectSoldier" then
            self.itemList[1]:onBtnSetSoldier()
            return
        elseif guideCfg.otherArgs[1] == "selectSoldier" then
            self.guidingItem:onClickItem()
            return
        end
    end


    ggclass.UIBase.triggerGuideClick(self, guideCfg)
end

return PnlPersonalArmy