UnionArmyItem = UnionArmyItem or class("UnionArmyItem", ggclass.UIBaseItem)
function UnionArmyItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionArmyItem:onInit()
    self.commonItemWarship = CommonItemItem.new(self:Find("LayoutWarship/CommonItemWarship"))
    self.txtIndex = self:Find("TxtIndex", UNITYENGINE_UI_TEXT)

    self.btnRemove = self:Find("BtnRemove")
    self:setOnClick(self.btnRemove, gg.bind(self.onBtnRemove, self))
    self.btnEdit = self:Find("BtnEdit")
    self:setOnClick(self.btnEdit, gg.bind(self.onBtnEdit, self))

    self.layoutArmyItems = self:Find("LayoutArmyItems").transform

    self.subArmyList = {}
    for i = 1, 5, 1 do
        table.insert(self.subArmyList, UnionSubArmyItem.new(self.layoutArmyItems:GetChild(i - 1)))
    end
end

-- data = message BattleArmy
function UnionArmyItem:setData(data, index)
    self.data = data
    self.txtIndex.text = index

    if data.battleArmy.warShipId and data.battleArmy.warShipId > 0 then
        local warshipCfg = WarshipUtil.getWarshipCfg(data.warship.cfgId, data.warship.quality, data.warship.level)
        self.commonItemWarship:setIcon(string.format("Warship_A_Atlas[%s]", warshipCfg.icon .. "_A") )
        self.commonItemWarship:setQuality(data.warship.quality)
    else
        self.commonItemWarship:setIcon(false)
        self.commonItemWarship:setQuality(0)
    end

    for i = 1, 5, 1 do
        self.subArmyList[i]:setData(data.battleArmy.teams[i], i)
    end
end

function UnionArmyItem:onRelease()
    for index, value in ipairs(self.subArmyList) do
        value:release()
    end
    self.commonItemWarship:release()
end

function UnionArmyItem:onBtnRemove()
    UnionData.removeUnionArmy(self.data.id)
end

function UnionArmyItem:onBtnEdit()
    UnionUtil.startEdit(self.data, self.initData.type)
end
---------------------------------------------------------------------------------

UnionSubArmyItem = UnionSubArmyItem or class("UnionSubArmyItem", ggclass.UIBaseItem)
function UnionSubArmyItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionSubArmyItem:onInit()
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
    self.commonItemHero = CommonHeroItem.new(self:Find("CommonItemHero"))
    self.commonItemSoldier = CommonHeroItem.new(self:Find("CommonItemSoldier"))
    self.txtIndex = self:Find("TxtIndex", UNITYENGINE_UI_TEXT)
end

-- data = message BattleTeamType
function UnionSubArmyItem:setData(data, index)
    self.data = data
    self.txtIndex.text = index

    if not data then
        self.txtCount.gameObject:SetActiveEx(false)
        self.commonItemHero:initInfo()
        self.commonItemSoldier:initInfo()
        return
    end

    if data.soliderCfgId and data.soliderCfgId > 0 then
        self.txtCount.gameObject:SetActiveEx(true)
        self.txtCount.text = data.soliderCount
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[data.solider.cfgId][data.solider.level]

        self.commonItemSoldier:setIcon("Soldier_A_Atlas", soldierCfg.icon)
        self.commonItemSoldier:setQuality(SoliderUtil.getSoldierQuality(data.solider.cfgId))
    else
        self.txtCount.gameObject:SetActiveEx(false)
        self.commonItemSoldier:setIcon(false)
        self.commonItemSoldier:initInfo()
    end

    if data.heroId and data.heroId > 0 then
        local heroCfg = HeroUtil.getHeroCfgMap()[data.hero.cfgId][data.hero.quality][data.hero.level]
        self.commonItemHero:setIcon("Hero_A_Atlas", heroCfg.icon)
        self.commonItemHero:setQuality(data.hero.quality)
    else
        self.commonItemHero:setIcon(false)
        self.commonItemHero:initInfo()
    end
end

function UnionSubArmyItem:onRelease()
    self.commonItemHero:release()
    self.commonItemSoldier:release()
end
