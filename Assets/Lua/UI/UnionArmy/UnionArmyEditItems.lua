UnionArmyEditItem = UnionArmyEditItem or class("UnionArmyEditItem", ggclass.UIBaseItem)
function UnionArmyEditItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionArmyEditItem:onInit()
    self.layoutHero = self:Find("LayoutHero")
    self.commonItemHero = CommonHeroItem.new(self:Find("LayoutHero/CommonHeroItem"))
    self.btnSetHero = self.layoutHero.transform:Find("BtnSetHero")

    self:setOnClick(self.layoutHero.gameObject, gg.bind(self.onBtnHero, self))

    self.layoutSoldier = self:Find("LayoutSoldier")
    self.commonItemSoldier = CommonHeroItem.new(self:Find("LayoutSoldier/CommonHeroItem"))
    self.btnSetSoldier = self.layoutSoldier.transform:Find("BtnSetSoldier")
    self.sliderCount = self:Find("LayoutSoldier/SliderCount", UNITYENGINE_UI_SLIDER)
    self.txtCount = self:Find("LayoutSoldier/SliderCount/TxtCount", UNITYENGINE_UI_TEXT)

    self:setOnClick(self.layoutSoldier.gameObject, gg.bind(self.onBtnSoldier, self))

    self.txtIndex = self:Find("BgIndex/TxtIndex", UNITYENGINE_UI_TEXT)

    -- self.commonItemHero:initInfo()
    -- self.commonItemSoldier:initInfo()
end

-- data = message BattleTeamType
function UnionArmyEditItem:setData(data)
    self.data = data

    if not data then
        self.commonItemSoldier.gameObject:SetActiveEx(false)
        self.btnSetSoldier:SetActiveEx(true)

        self.sliderCount.gameObject:SetActiveEx(false)
        self.txtCount.gameObject:SetActiveEx(false)
        self.commonItemHero.gameObject:SetActiveEx(false)
        self.btnSetHero:SetActiveEx(true)
        return
    end

    if data.heroId and data.heroId > 0 then
        self.commonItemHero.gameObject:SetActiveEx(true)
        self.btnSetHero:SetActiveEx(false)

        local heroCfg = HeroUtil.getHeroCfgMap()[data.hero.cfgId][data.hero.quality][data.hero.level]

        self.commonItemHero:setIcon("Hero_A_Atlas", heroCfg.icon)

        self.commonItemHero:setQuality(data.hero.quality)
    else
        self.commonItemHero.gameObject:SetActiveEx(false)
        self.btnSetHero:SetActiveEx(true)

        self.commonItemSoldier.gameObject:SetActiveEx(false)
        self.btnSetSoldier:SetActiveEx(true)
        self.sliderCount.gameObject:SetActiveEx(false)
        self.txtCount.gameObject:SetActiveEx(false)
    end

    if data.soliderCfgId and data.soliderCfgId > 0 then
        self.commonItemSoldier.gameObject:SetActiveEx(true)
        self.btnSetSoldier:SetActiveEx(false)

        local soldierCfg = SoliderUtil.getSoliderCfgMap()[data.solider.cfgId][data.solider.level]
        self.txtCount.gameObject:SetActiveEx(true)
        self.sliderCount.gameObject:SetActiveEx(true)

        local space = UnionUtil.getUnionArmySoldierSpace(data.heroId, self.initData.type)
        local maxCount = math.floor(space /soldierCfg.trainSpace)
        self.sliderCount.value = data.soliderCount / maxCount
        self.txtCount.text = data.soliderCount .. " / " .. maxCount
        -- self.commonItemSoldier:setIcon(string.format("Soldier_A_Atlas[%s]", soldierCfg.icon .. "_A"))
        self.commonItemSoldier:setIcon("Soldier_A_Atlas", soldierCfg.icon)
        self.commonItemSoldier:setQuality(SoliderUtil.getSoldierQuality(data.solider.cfgId))
    else
        self.commonItemSoldier.gameObject:SetActiveEx(false)
        self.btnSetSoldier:SetActiveEx(true)
        self.sliderCount.gameObject:SetActiveEx(false)
        self.txtCount.gameObject:SetActiveEx(false)
    end
end

function UnionArmyEditItem:setIndex(index)
    self.index = index
    self.txtIndex.text = index
end

function UnionArmyEditItem:onBtnHero()
    self.initData:refresh(PnlUnionArmyEdit.TYPE_HERO, self.index)
end

function UnionArmyEditItem:onBtnSoldier()
    self.initData:refresh(PnlUnionArmyEdit.TYPE_SOLDIER, self.index)
end

function UnionArmyEditItem:onRelease()
    self.commonItemHero:release()
    self.commonItemSoldier:release()
end

---------------------------------------------------------------------------------
UnionArmySoldierItem = UnionArmySoldierItem or class("UnionArmySoldierItem", ggclass.UIBaseItem)
function UnionArmySoldierItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionArmySoldierItem:onInit()
    self.commonItemItemD1 = CommonHeroItem.new(self:Find("CommonHeroItem"))

    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)
    self.sliderCount = self:Find("SliderCount", UNITYENGINE_UI_SLIDER)
    self.txtCount = self:Find("SliderCount/TxtCount", UNITYENGINE_UI_TEXT)
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function UnionArmySoldierItem:setData(data)
    self.data = data
    if not data  then
        self.gameObject:SetActiveEx(false)
        return
    end
    self.gameObject:SetActiveEx(true)
    self:refreshSelect()

    local subCfg = SoliderUtil.getSoliderCfgMap()[data.cfgId][data.level]
    self.commonItemItemD1:setIcon("Soldier_A_Atlas", subCfg.icon)
    self.commonItemItemD1:setQuality(SoliderUtil.getSoldierQuality(data.cfgId))

    self.commonItemItemD1.gameObject:SetActiveEx(true)
    self.txtCount.gameObject:SetActiveEx(true)

    if self.initData.type == constant.UNION_TYPE_ARMY_UNION then
        local lessCount = UnionUtil.getUnionSoldierLessCount(data.cfgId, self.initData.data)
        self.sliderCount.value = lessCount / subCfg.unionLimit
        self.txtCount.text = lessCount .. " / " .. subCfg.unionLimit
    else
        local lessCount, isCanUsed = UnionUtil.getSelfSoldierLessCount(data, self.initData.data)

        if not isCanUsed then
            self.txtCount.text = "used"
        else
            self.txtCount.text = lessCount .. " / " .. data.build.soliderCount
        end

        self.sliderCount.value = lessCount / data.build.soliderCount

    end
end

function UnionArmySoldierItem:refreshSelect()
    self.imgSelect.gameObject:SetActiveEx(self.initData.subArmyInfo == self.data)
end

function UnionArmySoldierItem:onRelease()
    self.commonItemItemD1:release()
end

function UnionArmySoldierItem:onBtnItem()
    self.initData:setSubInfo(self.data)
end

---------------------------------------------------------------------------------
UnionArmyHeroItem = UnionArmyHeroItem or class("UnionArmyHeroItem", ggclass.UIBaseItem)
function UnionArmyHeroItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionArmyHeroItem:onInit()
    self.imgUsed = self:Find("ImgUsed", UNITYENGINE_UI_IMAGE)

    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)

    self.commonItemItemD1 = CommonHeroItem.new(self:Find("CommonHeroItem"))
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

-- data = message HeroType
function UnionArmyHeroItem:setData(data)
    self.data = data
    if not data  then
        self.gameObject:SetActiveEx(false)
        return
    end
    self.gameObject:SetActiveEx(true)

    self:refreshSelect()
    self.imgUsed.gameObject:SetActiveEx(UnionUtil.checkHeroUsed(data.id, self.initData.data))
    local heroCfg = HeroUtil.getHeroCfgMap()[data.cfgId][data.quality][data.level]

    self.commonItemItemD1:setIcon("Hero_A_Atlas", heroCfg.icon)
    self.commonItemItemD1:setQuality(data.quality)
end

function UnionArmyHeroItem:refreshSelect()
    self.imgSelect.gameObject:SetActiveEx(self.initData.subArmyInfo == self.data)
end

function UnionArmyHeroItem:onRelease()
    self.commonItemItemD1:release()
end

function UnionArmyHeroItem:onBtnItem()
    self.initData:setSubInfo(self.data)
end

---------------------------------------------------------------------------------
UnionArmyWarshipItem = UnionArmyWarshipItem or class("UnionArmyWarshipItem", ggclass.UIBaseItem)
function UnionArmyWarshipItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionArmyWarshipItem:onInit()
    self.imgUsed = self:Find("ImgUsed", UNITYENGINE_UI_IMAGE)
    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)

    self.commonItemItemD1 = CommonItemItemD1.new(self:Find("CommonItemItemD1"))
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

-- data = message WarShipType
function UnionArmyWarshipItem:setData(data)
    self.data = data
    if not data  then
        self.gameObject:SetActiveEx(false)
        return
    end

    self.gameObject:SetActiveEx(true)
    self:refreshSelect()

    local warshipCfg = WarshipUtil.getWarshipCfg(data.cfgId, data.quality, data.level)

    self.commonItemItemD1:setIcon(string.format("Warship_A_Atlas[%s]", warshipCfg.icon .. "_A"))
    self.commonItemItemD1:setQuality(data.quality)

    self.imgUsed.gameObject:SetActiveEx(UnionUtil.checkWarshipUsed(data.id, self.initData.data))
end

function UnionArmyWarshipItem:refreshSelect()
    self.imgSelect.gameObject:SetActiveEx(self.initData.subArmyInfo == self.data)
end

function UnionArmyWarshipItem:onRelease()
    self.commonItemItemD1:release()
end

function UnionArmyWarshipItem:onBtnItem()
    self.initData:setSubInfo(self.data)
end

---------------------------------------------------------------------------------
EditUnionArmySkillItem = EditUnionArmySkillItem or class("EditUnionArmySkillItem", ggclass.UIBaseItem)
function EditUnionArmySkillItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditUnionArmySkillItem:onInit()
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    self.commonItemItem:initInfo()
    -- self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function EditUnionArmySkillItem:setData(data)
    self.data = data
    local skillCfg = SkillUtil.getSkillCfgMap()[data.cfgId][data.level]
    self.commonItemItem:setIcon(string.format("Skill_A1_Atlas[%s]", skillCfg.icon .. "_A1"))
end

function EditUnionArmySkillItem:onRelease()
    self.commonItemItem:release()
end
