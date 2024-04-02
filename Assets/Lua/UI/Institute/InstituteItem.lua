-- level
InstituteLevelItem = InstituteLevelItem or class("InstituteLevelItem", ggclass.UIBaseItem)

function InstituteLevelItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj, initData)
end

function InstituteLevelItem:onInit(initData)
    self.initData = initData
    self.imgArrow = self:Find("ImgArrow", "Image")
    self.layoutSoldier = self:Find("LayoutSoldier")
    self.layoutMine = self:Find("LayoutMine")

    self.forceItemList = {}
    for i = 1, 5 do
        self.forceItemList[i] = InstituteLevelSubItem.new(
            self.layoutSoldier.transform:Find("InstituteLevelSubItem" .. i), self, self.initData)
    end

    self.mineItem = InstituteLevelSubItem.new(self.layoutMine.transform:Find("InstituteLevelSubItem"), self,
        self.initData)
end

function InstituteLevelItem:onRelease()
    for key, value in pairs(self.forceItemList) do
        value:release()
    end
    self.mineItem:release()
end

function InstituteLevelItem:setData(data, upgradeType)
    self.data = data
    self.upgradeType = upgradeType

    if data.type == constant.INSTITUE_TYPE_SOLDIER then
        self:refreshSolider()
    elseif data.type == constant.INSTITUE_TYPE_MINE then
        self:refreshMine()
    end
    self:refreshItemSelect()
end

function InstituteLevelItem:refreshSolider()
    self.imgArrow.gameObject:SetActiveEx(true)
    self.layoutSoldier.transform:SetActiveEx(true)
    self.layoutMine.transform:SetActiveEx(false)
    for index, value in ipairs(self.forceItemList) do
        value:setData(self.data.cfg[index], constant.INSTITUE_TYPE_SOLDIER)
    end
end

function InstituteLevelItem:refreshMine()
    self.imgArrow.gameObject:SetActiveEx(false)
    self.layoutSoldier.transform:SetActiveEx(false)
    self.layoutMine.transform:SetActiveEx(true)
    self.mineItem:setData(self.data.cfg, constant.INSTITUE_TYPE_MINE)
end

function InstituteLevelItem:selectItem(selectCfg, institueType)
    self.initData:selectItem(selectCfg, institueType)
end

function InstituteLevelItem:refreshItemSelect()
    if not self.data then
        return
    end

    if self.data.type == constant.INSTITUE_TYPE_SOLDIER then
        for key, value in pairs(self.forceItemList) do
            value:refreshSelect()
        end
    else
        self.mineItem:refreshSelect()
    end
end
--------------------------------------------------------
InstituteLevelSubItem = InstituteLevelSubItem or class("InstituteLevelSubItem", ggclass.UIBaseItem)
function InstituteLevelSubItem:ctor(obj, initData, viewUi)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
    self.viewUi = viewUi
end

function InstituteLevelSubItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    self.commonHeroItem = CommonHeroItem.new(self:Find("CommonHeroItem"))

    self.layoutLevel = self:Find("LayoutLevel").transform
    self.txtLevel = self.layoutLevel:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgRace = self:Find("ImgRace", UNITYENGINE_UI_IMAGE)

    self.layoutTime = self:Find("LayoutTime").transform
    self.txtTime = self.layoutTime:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgLock = self:Find("ImgLock", "Image")
    self.txtLock = self:Find("TxtLock", "Text")

    self.imgSelect = self:Find("ImgSelect")
    self.btnInfo = self:Find("BtnInfo").gameObject
    self:setOnClick(self.btnInfo, gg.bind(self.onBtnInfo, self))
end

function InstituteLevelSubItem:onRelease()
    gg.timer:stopTimer(self.timer)
end

function InstituteLevelSubItem:setData(instituteData)
    self.instituteData = instituteData

    self.imgLock.gameObject:SetActiveEx(false)
    self.layoutLevel:SetActiveEx(false)
    self.layoutTime:SetActiveEx(false)
    self.txtLock.transform:SetActiveEx(false)
    self.btnInfo:SetActiveEx(false)

    if not self.instituteData then
        self.data = nil
        self.totalCfg = nil
        self.upgradeType = nil

        self.transform:SetActiveEx(false)
        return
    end
    self.transform:SetActiveEx(true)

    -- self.btnInfo:SetActiveEx(true)

    local upgradeType = instituteData.upgradeType
    local totalCfg = instituteData.cfg

    self.totalCfg = totalCfg
    self.upgradeType = upgradeType
    self.data = instituteData.data
    self.curCfg = totalCfg[self.data.level]

    if upgradeType == constant.INSTITUE_TYPE_SOLDIER then
        self.commonHeroItem:setQuality(SoliderUtil.getSoldierQuality(self.data.cfgId))
        -- local icon = gg.getSpriteAtlasName("Soldier_D_Atlas", self.curCfg.icon .. "_D")
        self.commonHeroItem:setIcon("Soldier_A_Atlas", self.curCfg.icon)

        local raceIcon = string.format("Skill_A1_Atlas[%s]", constant.RACE_MESSAGE[self.curCfg.race].iconSmall)
        gg.setSpriteAsync(self.imgRace, raceIcon)

    elseif upgradeType == constant.INSTITUE_TYPE_MINE then
        self.commonHeroItem:setQuality(self.curCfg.quality)
        local icon = gg.getSpriteAtlasName("Soldier_D_Atlas", self.curCfg.icon .. "_D")
        self.commonHeroItem:setIcon(icon)
    end

    if self.data.level > 0 then
        self.layoutLevel:SetActiveEx(true)
        self.txtLevel.text = self.data.level
    else
        self.imgLock.gameObject:SetActiveEx(true)
    end

    self:refreshUnlock()
    gg.timer:stopTimer(self.timer)
    if self.data.lessTick > 0 then
        self:startTimer()
    end
    self:refreshSelect()
end

function InstituteLevelSubItem:refreshUnlock()
    local isUnlock, lockMap, lockList =  gg.buildingManager:checkNeedBuild(self.curCfg.levelUpNeedBuilds)
    if not isUnlock then
        local buildCfg = BuildUtil.getCurBuildCfg(lockList[1].cfgId, lockList[1].level, lockList[1].quality)
        if buildCfg and self.data.level <= 0 then
            self.txtLock.transform:SetActiveEx(true)
            self.txtLock.text = BuildUtil.getBuildUnlockText(buildCfg, buildCfg.level)
            -- self.txtLock.transform.sizeDelta = Vector2.New(self.txtLock.transform.sizeDelta.x, 98)
        else
            print("wrong build")
        end
    end
end

function InstituteLevelSubItem:startTimer()
    self.layoutTime:SetActiveEx(true)
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = self.data.lessTickEnd - os.time()
        if time < 0 then
            self.layoutTime:SetActiveEx(false)
            return
        end
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, time)
        self.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    end)
end

function InstituteLevelSubItem:onClickItem()
    if not self.data then
        return
    end

    if self.data.level > 0 then
        self.initData:selectItem(self.totalCfg, self.upgradeType)
    end
end

function InstituteLevelSubItem:onBtnInfo()
    if self.upgradeType == constant.INSTITUE_TYPE_SOLDIER then
        SoliderUtil.showSoldierInfo(self.curCfg)
    end
end

function InstituteLevelSubItem:refreshSelect()
    if self.data == nil then
        return
    end

    local selectCfgId = 0
    if self.viewUi.selectData then
        selectCfgId = self.viewUi.selectData.curCfg.cfgId
    end
    self.imgSelect.transform:SetActiveEx(selectCfgId == self.data.cfgId)
end

function InstituteLevelSubItem:refreshItemSelect()
    self:refreshSelect()
end

-----quality
InstitueQualityItem = InstitueQualityItem or class("InstitueQualityItem", ggclass.UIBaseItem)

function InstitueQualityItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj, initData)
end

function InstitueQualityItem:onInit(initData)
    self.initData = initData
    self.layoutSoldier = self:Find("LayoutSoldier")

    self.forceItemList = {}
    for i = 1, 4 do
        self.forceItemList[i] = InstituteQualitySubItem.new(self.layoutSoldier.transform:Find(
            "InstituteQualitySubItem" .. i), self, self.initData)
    end
end

function InstitueQualityItem:onRelease()
    for key, value in pairs(self.forceItemList) do
        value:release()
    end
end

function InstitueQualityItem:setData(data, upgradeType)
    self.data = data
    self.upgradeType = upgradeType
    self:refreshSolider()
    self:refreshItemSelect()
end

function InstitueQualityItem:refreshSolider()
    self.layoutSoldier.transform:SetActiveEx(true)
    for index, value in ipairs(self.forceItemList) do
        value:setData(self.data.cfg[index], constant.INSTITUE_TYPE_SOLDIER)
    end
end

function InstitueQualityItem:selectItem(selectCfg, institueType)
    self.initData:selectItem(selectCfg, institueType)
end

function InstitueQualityItem:refreshItemSelect()
    if not self.data then
        return
    end

    if self.data.type == constant.INSTITUE_TYPE_SOLDIER then
        for key, value in pairs(self.forceItemList) do
            value:refreshSelect()
        end
    else
        self.mineItem:refreshSelect()
    end
end

--------------------------------------------------------
InstituteQualitySubItem = InstituteQualitySubItem or class("InstituteQualitySubItem", ggclass.UIBaseItem)

function InstituteQualitySubItem:ctor(obj, initData, viewUi)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
    self.viewUi = viewUi
end

function InstituteQualitySubItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    self.commonItemItemD2 = CommonItemItemD2.new(self:Find("CommonItemItemD2"))
    self.layoutTime = self:Find("LayoutTime").transform
    self.txtTime = self.layoutTime:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLock = self:Find("ImgLock", "Image")
    self.imgSelect = self:Find("ImgSelect", "Image")
end

function InstituteQualitySubItem:onRelease()
    gg.timer:stopTimer(self.timer)
end

function InstituteQualitySubItem:setData(totalCfg, upgradeType)
    self.totalCfg = totalCfg
    self.upgradeType = upgradeType

    self.data = BuildData.soliderLevelData[totalCfg[1].cfgId]
    self.curCfg = totalCfg[self.data.level]

    local quality = SoliderUtil.getSoldierQuality(self.data.cfgId)

    self.commonItemItemD2:setQuality(quality)
    local icon = gg.getSpriteAtlasName("Soldier_D_Atlas", self.curCfg.icon .. "_D")
    self.commonItemItemD2:setIcon(icon)

    local totalFrontSoldierCfg = SoliderUtil.getSoliderStudyCfgMap()[self.curCfg.studyId][quality - 1]
    self.frontSoldierData = BuildData.soliderLevelData[totalFrontSoldierCfg[1].cfgId]
    self.frontSoldierCurCfg = totalFrontSoldierCfg[self.frontSoldierData.level]

    self.layoutTime:SetActiveEx(false)
    self.imgLock.gameObject:SetActiveEx(false)
    gg.timer:stopTimer(self.timer)

    if SoliderUtil.isLevelMax(self.frontSoldierData.cfgId) then
        if self.data.level <= 0 then
            self.layoutTime:SetActiveEx(true)
            if self.data.lessTick > 0 then
                self:startTimer()
            else
                local hms = gg.time.dhms_time({
                    day = false,
                    hour = 1,
                    min = 1,
                    sec = 1
                }, self.curCfg.levelUpNeedTick)
                self.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
            end
        end
    else
        self.imgLock.gameObject:SetActiveEx(true)
    end
end

function InstituteQualitySubItem:startTimer()
    self.layoutTime:SetActiveEx(true)
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = self.data.lessTickEnd - os.time()
        if time < 0 then
            self.layoutTime:SetActiveEx(false)
            return
        end
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, time)
        self.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    end)
end

function InstituteQualitySubItem:onClickItem()
    self.initData:selectItem(self.totalCfg, constant.INSTITUE_TYPE_SOLDIER)
end

function InstituteQualitySubItem:refreshSelect()
    local selectCfgId = 0
    if self.viewUi.selectData then
        selectCfgId = self.viewUi.selectData.curCfg.cfgId
    end
    self.imgSelect.transform:SetActiveEx(selectCfgId == self.data.cfgId)
end

------------------------------------------------------------------
InstituteDrawItem = InstituteDrawItem or class("InstituteDrawItem", ggclass.UIBaseItem)

function InstituteDrawItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function InstituteDrawItem:onInit()
    self.imgBefore = self:Find("LayoutMessage/ImgBefore", "Image")
    self.imgAfter = self:Find("LayoutMessage/ImgAfter", "Image")
    self.btnCancel = self:Find("LayoutMessage/BtnCancel")
    self:setOnClick(self.btnCancel, gg.bind(self.onBtnCancel, self))
    self.btnInstant = self:Find("LayoutMessage/BtnInstant")
    self.txtInstantCost = self:Find("LayoutMessage/BtnInstant/TxtInstantCost", "Text")
    self:setOnClick(self.btnInstant, gg.bind(self.onBtnInstance, self))
    self.txtTime = self:Find("LayoutMessage/TxtTime", "Text")

    self.btnStart = self:Find("LayoutNone/BtnStart")
    self:setOnClick(self.btnStart, gg.bind(self.onBtnStart, self))

    self.layoutMessage = self:Find("LayoutMessage")
    self.layoutNone = self:Find("LayoutNone")
end

function InstituteDrawItem:setData(data)
    self.data = data
    if not data then
        self.layoutMessage:SetActiveEx(false)
        self.layoutNone:SetActiveEx(true)
        return
    end

    self.layoutMessage:SetActiveEx(true)
    self.layoutNone:SetActiveEx(false)

    self:stopTimer()
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = data.lessTickEnd - os.time()
        if time <= 0 then
            self:stopTimer()
        end
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, time)
        self.txtTime.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)

        self.txtInstantCost.text = math.ceil(time / 60 / 60) * cfg.global.ComposeSpeedCostPerHour.intValue
    end)
end

function InstituteDrawItem:stopTimer()
    if self.timer then
        gg.timer:stopTimer(self.timer)
        self.timer = nil
    end
end

function InstituteDrawItem:onRelease()
    self:stopTimer()
end

function InstituteDrawItem:onBtnCancel()
    if not self.data then
        return
    end
    ItemData.C2S_Player_ItemComposeCancel(self.data.item.id)
end

function InstituteDrawItem:onBtnInstance()
    if not self.data then
        return
    end
    ItemData.C2S_Player_ItemComposeSpeed(self.data.item.id)
end

function InstituteDrawItem:onBtnStart()

end

