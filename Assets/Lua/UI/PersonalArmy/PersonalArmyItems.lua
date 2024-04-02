PersonalArmyItem = PersonalArmyItem or class("PersonalArmyItem", ggclass.UIBaseItem)

function PersonalArmyItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PersonalArmyItem:onInit()
    self.txtIndex = self:Find("BgIndex/TxtIndex", UNITYENGINE_UI_TEXT)

    self.layoutEmp = self:Find("LayoutEmp")
    self:setOnClick(self.layoutEmp.gameObject, gg.bind(self.onBtnSetHero, self))

    self.layoutSelect = self:Find("LayoutSelect")

    self.layoutHero = self:Find("LayoutSelect/LayoutHero").transform
    self.btnSetHero = self.layoutHero:Find("BtnSetHero").gameObject
    self:setOnClick(self.btnSetHero, gg.bind(self.onBtnSetHero, self))

    self.layoutHeroChoose = self.layoutHero:Find("LayoutHeroChoose")

    self.heroSkillItemList = {}
    self.heroSkillScrollView = UIScrollView.new(self.layoutHeroChoose:Find("HeroSkillScrollView"), "PersonalArmySkillItem", self.heroSkillItemList)
    self.heroSkillScrollView:setRenderHandler(gg.bind(self.onRenderSkill, self))

    self.imgHeroIcon = self.layoutHeroChoose:Find("HeroIconMask/ImgHeroIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self:setOnClick(self.imgHeroIcon.gameObject, gg.bind(self.onBtnSetHero, self))

    self.txtLevel = self.layoutHeroChoose:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHeroName = self.layoutHeroChoose:Find("TxtHeroName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgQuality = self.layoutHeroChoose:Find("ImgQuality"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnDeleteHero = self.layoutHeroChoose:Find("BtnDeleteHero").gameObject
    self:setOnClick(self.btnDeleteHero, gg.bind(self.onBtnDeleteHero, self))

    self.layoutSoldier = self:Find("LayoutSelect/LayoutSoldier").transform

    self.btnSetSoldier = self.layoutSoldier:Find("BtnSetSoldier").gameObject
    self:setOnClick(self.btnSetSoldier, gg.bind(self.onBtnSetSoldier, self))
    self.txtSoldierCount = self.layoutSoldier:Find("LayoutSoldierChoose/BgSoldierCount/TxtSoldierCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutSoldierChoose = self.layoutSoldier:Find("LayoutSoldierChoose")

    self.imgSoldierIcon = self.layoutSoldierChoose:Find("SoldierMask/ImgSoldierIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self:setOnClick(self.imgSoldierIcon.gameObject, gg.bind(self.onBtnSetSoldier, self))

    self.btnDeleteSoldier = self.layoutSoldierChoose:Find("BtnDeleteSoldier").gameObject
    self:setOnClick(self.btnDeleteSoldier, gg.bind(self.onBtnDeleteSoldier, self))

    self.layoutLock = self:Find("LayoutLock").transform
    self.txtLock = self.layoutLock:Find("TxtLock"):GetComponent(UNITYENGINE_UI_TEXT)
end

function PersonalArmyItem:setData(index)
    self.index = index
    self.txtIndex.text = index

    self.teamData = self.initData.armyData.teams[index] or {} --{number = self.index}
    self.initData.armyData.teams[index] = self.teamData

    self:refresh()
end

PersonalArmyItem.QUALITY_2_LEVEL_POS = {
    CS.UnityEngine.Vector2(-83.2, -163.1),
    CS.UnityEngine.Vector2(-81.4, -162.5),
    CS.UnityEngine.Vector2(-135.5, -181.8),
    CS.UnityEngine.Vector2(-182.8, -198.6),
    CS.UnityEngine.Vector2(-74.3, -160),
}

PersonalArmyItem.QUALITY_2_Skill_POS = {
    CS.UnityEngine.Vector2(-75.4, -197.6),
    CS.UnityEngine.Vector2(-75.4, -197.6),
    CS.UnityEngine.Vector2(-75.4, -197.6),
    CS.UnityEngine.Vector2(-74.2, -176.8),
    CS.UnityEngine.Vector2(-75.4, -197.6),
}

PersonalArmyItem.QUALITY_NOT_NFT_2_LEVEL_POS = {
    CS.UnityEngine.Vector2(-104.9, -170.8),
    CS.UnityEngine.Vector2(-103.4, -170.4),
    CS.UnityEngine.Vector2(-94.8, -167.1),
}

PersonalArmyItem.normalSoldierPos = CS.UnityEngine.Vector2(9, -9)

PersonalArmyItem.soldierIcon2Pos = {
    [7100001] = CS.UnityEngine.Vector2(25, -44),
    [7200001] = CS.UnityEngine.Vector2(-70, -58),
    [7200006] = CS.UnityEngine.Vector2(-50, 24),
    [7100008] = CS.UnityEngine.Vector2(9, -42),
}

function PersonalArmyItem:refresh()
    self.layoutEmp:SetActiveEx(false)
    self.layoutSelect:SetActiveEx(false)
    self.layoutLock:SetActiveEx(false)

    local baseLevel = gg.buildingManager:getBaseLevel()
    local openLevel = cfg.global.UnlockSquadBaseLevel.tableValue[self.index]
    if openLevel > baseLevel then
        self.layoutLock:SetActiveEx(true)
        self.txtLock.text = string.format(Utils.getText("formation_UnlockCondition"), openLevel)
        return
    end

    if not (self.teamData.heroId and self.teamData.heroId > 0) then
        self.layoutEmp:SetActiveEx(true)
        return
    end

    self.layoutSelect:SetActiveEx(true)

    if self.teamData.heroId and self.teamData.heroId > 0 then
        local heroData = HeroData.heroDataMap[self.teamData.heroId]
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)

        gg.setSpriteAsync(self.imgHeroIcon, heroCfg.icon .. "_C")
        self.txtLevel.text = heroData.level
        self.txtHeroName.text = Utils.getText(heroCfg.languageNameID)
        if heroData.chain and  heroData.chain > 0 then
            gg.setSpriteAsync(self.imgQuality, string.format("PersonalArmyIcon_Atlas[quality_bg_%s]", heroData.quality))
            self.txtLevel.transform.anchoredPosition = PersonalArmyItem.QUALITY_2_LEVEL_POS[heroData.quality]
            self.heroSkillScrollView.transform.anchoredPosition = PersonalArmyItem.QUALITY_2_Skill_POS[heroData.quality]
        else
            gg.setSpriteAsync(self.imgQuality, string.format("PersonalArmyIcon_Atlas[quality_bg2_%s]", heroData.quality))
            self.txtLevel.transform.anchoredPosition = PersonalArmyItem.QUALITY_NOT_NFT_2_LEVEL_POS[heroData.quality]
            self.heroSkillScrollView.transform.anchoredPosition = PersonalArmyItem.QUALITY_2_Skill_POS[heroData.quality]
        end

        EffectUtil.setGray(self.imgHeroIcon, heroData.curLife == 0, false)

        -- EffectUtil.setGray(self.imgHeroIcon, true, false)

        self.skillShowList = {}
        for i = 1, 3, 1 do
            local skillCfgId = heroData["skill" .. i]
            if skillCfgId > 0 then
                local skillCfg = SkillUtil.getSkillCfgMap()[skillCfgId][heroData["skillLevel" .. i]]

                if skillCfg.skillType == 0 then
                    table.insert(self.skillShowList, skillCfg)
                end
            end
        end

        self.heroSkillScrollView:setItemCount(#self.skillShowList)
    end

    if self.teamData.soliderCfgId and self.teamData.soliderCfgId > 0 then
        self:showSoldierEmp(false)

        local soldierLevelData = BuildData.soliderLevelData[self.teamData.soliderCfgId]
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[soldierLevelData.cfgId][soldierLevelData.level]

        local posIcon = PersonalArmyItem.soldierIcon2Pos[soldierCfg.cfgId] or PersonalArmyItem.normalSoldierPos
        self.imgSoldierIcon.transform.anchoredPosition = posIcon

        local soldierIcon = soldierCfg.icon .. "_C"
        gg.setSpriteAsync(self.imgSoldierIcon, soldierIcon)
        self.txtSoldierCount.text = self.teamData.soliderCount
    else
        self:showSoldierEmp(true)
    end

    self:refreshStage()
end

function PersonalArmyItem:onRenderSkill(obj, index)
    local item = PersonalArmySkillItem:getItem(obj, self.heroSkillItemList)
    item:setData(self.skillShowList[index], self.teamData.soliderCfgId)
end

function PersonalArmyItem:showHeroEmp(isEmp)
    self.layoutHeroChoose:SetActiveEx(not isEmp)
    self.btnSetHero:SetActiveEx(isEmp)
end

function PersonalArmyItem:showSoldierEmp(isEmp)
    self.layoutSoldierChoose:SetActiveEx(not isEmp)
    self.btnSetSoldier:SetActiveEx(isEmp)

    if isEmp then
        self.txtSoldierCount.text = 0
    end
end

function PersonalArmyItem:setSelectData(selectData)
    if self.index > 1 then
        if not self:checkTeamExist(self.index - 1) then
            gg.uiManager:showTip("font team empty")
            return
        end
    end

    local teamData = gg.deepcopy(self.teamData)
    if self.initData.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
        teamData.heroId = selectData.hero.id
    elseif self.initData.selectType == PnlPersonalArmy.SELECT_TYPE_Soldier then

        if not teamData.heroId or teamData.heroId <= 0 then
            gg.uiManager:showTip("set hero first")
            return
        end
        teamData.soliderCfgId = selectData.soldierLevelData.cfgId
    end
    if teamData.soliderCfgId and teamData.soliderCfgId > 0 then
        local maxSoldierCount = self:getSoldierMaxCount(teamData.heroId, teamData.soliderCfgId, true)

        if maxSoldierCount <= 0 then
            return
        end
        teamData.soliderCount = maxSoldierCount
    end

    local armyData = self.initData.armyData
    PlayerData.C2S_Player_ArmyFormationUpdate(armyData.armyId, armyData.armyName, self.index, {teamData})
end

function PersonalArmyItem:getSoldierMaxCount(heroId, soliderCfgId, isAlert)

    local maxSpace = PersonalArmyUtils.getSoldierMaxSpace(heroId)

    local soldierSpace = 0
    for key, value in pairs(DraftData.reserveArmys) do
        soldierSpace = soldierSpace + value.count
    end

    if self.teamData.soliderCount and self.teamData.soliderCount > 0 then
        local nowSoldierId = self.teamData.soliderCfgId
        local soliderCfg = SoliderUtil.getSoliderCfgMap()[nowSoldierId][BuildData.soliderLevelData[nowSoldierId].level]
        soldierSpace = soldierSpace + self.teamData.soliderCount * soliderCfg.trainSpace
    end

    local soliderCfg = SoliderUtil.getSoliderCfgMap()[soliderCfgId][BuildData.soliderLevelData[soliderCfgId].level]
    local setCount = math.floor(math.min(soldierSpace, maxSpace) / soliderCfg.trainSpace)

    if isAlert then
        if soldierSpace < soliderCfg.trainSpace then
            gg.uiManager:showTip("not enought soldier")
        elseif setCount <= 0 then
            gg.uiManager:showTip("not enought soldier space")
        end
    end
    return setCount
end

function PersonalArmyItem:checkTeamExist(index)
    local army = self.initData.armyData.teams[index]
    if not army then
        return true
    end
    return (army.heroId and army.heroId > 0) or (army.soliderCfgId and army.soliderCfgId > 0)
end

function PersonalArmyItem:onBtnSetHero()
    self.initData:beginSelect(self, PnlPersonalArmy.SELECT_TYPE_HERO)
end

function PersonalArmyItem:onBtnSetSoldier()
    self.initData:beginSelect(self, PnlPersonalArmy.SELECT_TYPE_Soldier)
end

function PersonalArmyItem:onBtnDeleteSoldier()
    if not (self.teamData.heroId and self.teamData.heroId > 0) then
        if self.index < PlayerData.MAX_ARMY_TEAM and self:checkTeamExist(self.index + 1) then
            gg.uiManager:showTip("next team exist")
            return
        end
    end

    self.teamData.soliderCfgId = 0
    self.teamData.soliderCount = 0

    local armyData = self.initData.armyData
    PlayerData.C2S_Player_ArmyFormationUpdate(armyData.armyId, armyData.armyName, self.index, {self.teamData})
end

function PersonalArmyItem:onBtnDeleteHero()
    local teamData = gg.deepcopy(self.teamData)
    teamData.heroId = 0
    teamData.soliderCfgId = 0
    teamData.soliderCount = 0
    -- if teamData.soliderCfgId and teamData.soliderCfgId > 0 then
    --     local maxSoldierCount = self:getSoldierMaxCount(0, teamData.soliderCfgId)
    --     -- maxSoldierCount = 0
    --     if maxSoldierCount <= 0 then
    --         teamData.soliderCfgId = 0
    --     end
    --     teamData.soliderCount = maxSoldierCount
    -- end

    -- if not (teamData.soliderCfgId and teamData.soliderCfgId > 0) then
    --     if self.index < PlayerData.MAX_ARMY_TEAM and self:checkTeamExist(self.index + 1) then
    --         gg.uiManager:showTip("next team exist")
    --         return
    --     end
    -- end

    local armyData = self.initData.armyData
    PlayerData.C2S_Player_ArmyFormationUpdate(armyData.armyId, armyData.armyName, self.index, {teamData})
end

function PersonalArmyItem:onRelease()
    self.heroSkillScrollView:release()
end

function PersonalArmyItem:refreshStage()
    -- if self.initData.stage == PnlPersonalArmy.STAGE_SET then
    --     self.btnDeleteHero:SetActiveEx(true)
    --     self.btnDeleteSoldier:SetActiveEx(true)
    -- else
    --     self.btnDeleteHero:SetActiveEx(false)
    --     self.btnDeleteSoldier:SetActiveEx(false)
    -- end
end

-----------------------------------------------------------

PersonalArmySkillItem = PersonalArmySkillItem or class("PersonalArmySkillItem", ggclass.UIBaseItem)
function PersonalArmySkillItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PersonalArmySkillItem:onInit()
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    self.imgLight = self:Find("ImgLight")
end

function PersonalArmySkillItem:setData(skillCfg, soldierCfgId)
    self.commonItemItem:setQuality(skillCfg.quality)
    self.commonItemItem:setIcon(string.format("Skill_A1_Atlas[%s_A1]", skillCfg.icon))

    if soldierCfgId > 0 then
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[soldierCfgId][1]
        self.imgLight:SetActiveEx(soldierCfg.race == skillCfg.race)
    else
        self.imgLight:SetActiveEx(false)
    end
end

function PersonalArmySkillItem:onRelease()
    self.commonItemItem:release()
end

-------------------------------------------------------

PersonalArmySelectItem = PersonalArmySelectItem or class("PersonalArmySelectItem", ggclass.UIBaseItem)
function PersonalArmySelectItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PersonalArmySelectItem:onInit()
    self.layoutInfo = self:Find("LayoutInfo").transform

    self.commonHeroItem = CommonHeroItem.new(self.layoutInfo:Find("CommonHeroItem"))
    self.imgSelect = self.layoutInfo:Find("ImgSelect")
    self.txtLevel = self.layoutInfo:Find("BgLevel/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgUsed = self.layoutInfo:Find("ImgUsed")
    self.imgNft = self.layoutInfo:Find("ImgNft")
    self.imgLock = self.layoutInfo:Find("ImgLock")
    self.txtLock = self.imgLock.transform:Find("TxtLock"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgLifeZero = self.layoutInfo:Find("ImgLifeZero")

    self.layoutRemove = self:Find("LayoutRemove")
    self:setOnClick(self.layoutRemove, gg.bind(self.onClickRemove, self))

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function PersonalArmySelectItem:setData(data)
    self.data = data
    self.imgNft:SetActiveEx(false)
    self.imgLock:SetActiveEx(false)
    self.layoutRemove:SetActiveEx(false)
    self.layoutInfo:SetActiveEx(false)

    self.unlock = true

    local settingTeamData = self.initData.settingPersonalArmyItem.teamData
    local isSetting = false

    self.imgLifeZero:SetActiveEx(false)

    if self.initData.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
        local heroData = data.hero
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        self.commonHeroItem:setQuality(heroData.quality)
        self.commonHeroItem:setIcon("Hero_A_Atlas", heroCfg.icon)

        self.txtLevel.text = "LV." .. heroData.level
        self.imgNft:SetActiveEx(data.hero.chain > 0)

        if settingTeamData.heroId and settingTeamData.heroId == heroData.id then
            isSetting = true
        end

        self.imgLifeZero:SetActiveEx(heroData.curLife == 0)

    elseif self.initData.selectType == PnlPersonalArmy.SELECT_TYPE_Soldier then
        local soldierLevelData = data.soldierLevelData
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[soldierLevelData.cfgId][soldierLevelData.level]

        if settingTeamData.soliderCfgId and settingTeamData.soliderCfgId == soldierLevelData.cfgId then
            isSetting = true
        end
        
        self.commonHeroItem:setQuality(0)
        self.commonHeroItem:setIcon("Soldier_A_Atlas", soldierCfg.icon)
        self.txtLevel.text = "LV." .. soldierLevelData.level
        self.unlock = soldierLevelData.level > 0
        -- self.imgLock:SetActiveEx(not self.unlock)

        if self.unlock then
            self.imgLock:SetActiveEx(false)
        else
            self.imgLock:SetActiveEx(true)
            local isUnlock, lockMap, lockList =  gg.buildingManager:checkNeedBuild(soldierCfg.levelUpNeedBuilds)

            local buildCfg = BuildUtil.getCurBuildCfg(lockList[1].cfgId, lockList[1].level, lockList[1].quality)
            self.txtLock.text = BuildUtil.getBuildUnlockText(buildCfg, buildCfg.level)
        end
    end

    if isSetting then
        self.layoutRemove:SetActiveEx(true)
    else
        self.layoutInfo:SetActiveEx(true)
    end

    self:refreshUsed()
end

function PersonalArmySelectItem:refreshUsed()
    -- if self.initData.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
    --     for key, value in pairs(self.initData.armyData.teams) do
    --         if self.data.hero and value.heroId == self.data.hero.id then
    --             self.isUsed = true
    --             self.imgUsed:SetActiveEx(true)
    --             return
    --         end
    --     end
    -- end

    if self.initData.selectType == PnlPersonalArmy.SELECT_TYPE_HERO then
        for _, army in pairs(PlayerData.armyData) do
            for _, team in pairs(army.teams) do
                if self.data.hero and team.heroId == self.data.hero.id then
                    self.isUsed = true
                    self.imgUsed:SetActiveEx(true)
                    return
                end
            end
        end
    end

    self.isUsed = false
    self.imgUsed:SetActiveEx(false)
end

function PersonalArmySelectItem:onClickItem()
    if self.isUsed or not self.unlock then
        return
    end

    self.initData:select(self.data)
end

function PersonalArmySelectItem:onClickRemove()
    self.initData:removeSelect(self.data)
end

function PersonalArmySelectItem:onRelease()
    self.commonHeroItem:release()
end
--------------------------------------------------------
local number2RomaNumber = {
    "Ⅰ",
    "Ⅱ",
    "Ⅲ",
    "Ⅵ",
    "Ⅴ",
}

PersonalTeamSelectItem = PersonalTeamSelectItem or class("PersonalTeamSelectItem", ggclass.UIBaseItem)
PersonalTeamSelectItem.STAGE_SELECT = 1
PersonalTeamSelectItem.STAGE_UNSELECT = 2

function PersonalTeamSelectItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PersonalTeamSelectItem:onInit()
    self.btn = self:Find("Btn")
    self:setOnClick(self.btn, gg.bind(self.onBtn, self))
    self.txtBtn = self.btn.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutName = self:Find("LayoutName").transform
    self.inputName = self.layoutName:Find("InputName"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputName.onEndEdit:AddListener(gg.bind(self.onInputEnd, self))
    self.btnChangeName = self.layoutName:Find("BtnChangeName").gameObject
    self:setOnClick(self.btnChangeName, gg.bind(self.onBtnChangeName, self))

    self.imgSelect = self:Find("LayoutName/ImgSelect")
    self.txtSelect = self.imgSelect.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
end

function PersonalTeamSelectItem:setIndex(index)
    self.index = index

    self.txtBtn.text = number2RomaNumber[index]
    self.txtSelect.text = number2RomaNumber[index]
end

function PersonalTeamSelectItem:refresh()
    if not EditData.isEditMode and self.index > 5 then
        return
    end

    local armyData = PlayerData.armyData[self.index]
    local stage

    if armyData then
        self.inputName.text = armyData.armyName
    end

    if armyData and armyData.armyId == self.initData.armyData.armyId then
        stage = PersonalTeamSelectItem.STAGE_SELECT
    else
        stage = PersonalTeamSelectItem.STAGE_UNSELECT
    end

    if stage ~= self.stage then
        self.stage = stage
        if stage == PersonalTeamSelectItem.STAGE_SELECT then
            self.layoutName:SetActiveEx(true)
            self.btn:SetActiveEx(false)
            self.transform:SetRectSizeX(397)
        else
            self.layoutName:SetActiveEx(false)
            self.btn:SetActiveEx(true)
            self.transform:SetRectSizeX(74)
        end

        self.transform:SetActiveEx(false)
        self.transform:SetActiveEx(true)
    end
end

function PersonalTeamSelectItem:onBtn()
    local armyData = PlayerData.armyData[self.index]

    if armyData then
        self.initData:loadArmy(armyData)
    else
        self.initData:addNewArmy()
    end
end

function PersonalTeamSelectItem:onBtnChangeName()
    self.inputName.interactable = true
    self.inputName:ActivateInputField()
end

function PersonalTeamSelectItem:onInputEnd(text)
    text =  FilterWords.filterWords(text)
    local armyData = PlayerData.armyData[self.index]
    if text ~= armyData.armyName then
        PlayerData.C2S_Player_ArmyFormationUpdate(armyData.armyId, text)
    end
    gg.timer:addTimer(0.1, function ()
        self.inputName.interactable = false
    end)
end

function PersonalTeamSelectItem:onRelease()
    self.inputName.onEndEdit:RemoveAllListeners()
end

-----------------------------------------------------------

BtnPersonArmyFilterType = BtnPersonArmyFilterType or class("BtnPersonArmyFilterType", ggclass.UIBaseItem)

function BtnPersonArmyFilterType:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BtnPersonArmyFilterType:onInit()
    self.image = self.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    self.text = self:Find("Text", UNITYENGINE_UI_TEXT)
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function BtnPersonArmyFilterType:setData(data)
    self.data = data
    if data.nameKey then
        self.text.text = Utils.getText(data.nameKey)
    else
        self.text.text = data.name
    end

    self:refreshSelect()
end

function BtnPersonArmyFilterType:onClickItem()
    self.initData:setFilter(self.data)
end

BtnPersonArmyFilterType.colorTxtSelect = CS.UnityEngine.Color(0xeb/0xff, 0xf2/0xff, 0xff/0xff, 1)
BtnPersonArmyFilterType.colorTxtUnSelect = CS.UnityEngine.Color(0x81/0xff, 0x82/0xff, 0x83/0xff, 1)

function BtnPersonArmyFilterType:refreshSelect()
    if self.initData.filterMap[self.initData.filterType] == self.data then
        self.text.color = BtnPersonArmyFilterType.colorTxtSelect
        self.image.color = CS.UnityEngine.Color(1, 1, 1, 1)
    else
        self.text.color = BtnPersonArmyFilterType.colorTxtUnSelect
        self.image.color = CS.UnityEngine.Color(1, 1, 1, 0)
    end
end