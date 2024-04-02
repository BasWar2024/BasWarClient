UnionArmyNewItem = UnionArmyNewItem or class("UnionArmyNewItem", ggclass.UIBaseItem)
function UnionArmyNewItem:ctor(obj, initData)
    self.initData = initData
    UIBaseItem.ctor(self, obj)
end

function UnionArmyNewItem:onInit()

    self.layoutEmpty = self:Find("LayoutEmpty").transform
    self:setOnClick(self.layoutEmpty.gameObject, gg.bind(self.onClickEmpty, self))

    self.layoutArmy = self:Find("LayoutArmy").transform

    self.txtIndex = self.layoutArmy:Find("BgIndex/TxtIndex"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutTeams =  self.layoutArmy:Find("LayoutTeams")

    self.unionArmyNewSubItemList = {}
    for i = 1, self.layoutTeams.childCount, 1 do
        local item = UnionArmyNewSubItem.new(self.layoutTeams:GetChild(i - 1), self, self.initData)
        table.insert(self.unionArmyNewSubItemList, item)
    end

    self.txtCount = self:Find("LayoutArmy/BgCount/TxtCount", UNITYENGINE_UI_TEXT)

    self.btnRemove = self.layoutArmy:Find("BtnRemove").gameObject
    self:setOnClick(self.btnRemove, gg.bind(self.onClickRemove, self))
end

function UnionArmyNewItem:setData(data, index)
    self.data = data

    if not data then
        self.layoutEmpty:SetActiveEx(true)
        self.layoutArmy:SetActiveEx(false)
        return
    end

    self.txtIndex.text = index

    self.layoutEmpty:SetActiveEx(false)
    self.layoutArmy:SetActiveEx(true)

    for index, value in ipairs(self.unionArmyNewSubItemList) do
        value:setData(data, index)
    end

    self:refreshCount()
end

function UnionArmyNewItem:onClickEmpty()
    UnionData.addEmptyArmy()
end

function UnionArmyNewItem:onRelease()
    -- self.commonItemItem:release()

    for key, value in pairs(self.unionArmyNewSubItemList) do
        value:release()
    end
end

function UnionArmyNewItem:refreshCount()
    local space = 0
    for index, value in ipairs(self.data.battleArmy.teams) do
        if value.soliderCfgId and value.soliderCfgId > 0 then
            local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.soliderCfgId][1]
            space = space + value.soliderCount * soldierCfg.trainSpace
        end
    end
    self.txtCount.text = space
end

function UnionArmyNewItem:onClickRemove()
    UnionData.removeUnionArmy(self.data.id)
end

-------------------------------------

UnionArmyNewSubItem = UnionArmyNewSubItem or class("UnionArmyNewSubItem", ggclass.UIBaseItem)
function UnionArmyNewSubItem:ctor(obj, initData, view)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
    self.pnlUnionArmyNew = self.initData.initData
end

function UnionArmyNewSubItem:onInit()
    self.layoutHero = self:Find("LayoutHero").transform
    self:setOnClick(self.layoutHero.gameObject, gg.bind(self.onBtnAddHero, self))
    self.heroItem = CommonHeroItem.new(self.layoutHero:Find("HeroItem"))
    self.txtHeroLevel = self.layoutHero:Find("BgHeroInfo/TxtHeroLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutSoldier = self:Find("LayoutSoldier").transform
    self:setOnClick(self.layoutSoldier.gameObject, gg.bind(self.onBtnAddSoldier, self))
    self.soldierItem = CommonHeroItem.new(self.layoutSoldier:Find("SoldierItem"))
    self.txtSoldierCount = self.layoutSoldier:Find("BgSoldierCount/TxtSoldierCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnAddHero = self:Find("BtnAddHero")
    self:setOnClick(self.btnAddHero, gg.bind(self.onBtnAddHero, self))

    self.btnAddSoldier = self:Find("BtnAddSoldier")
    self:setOnClick(self.btnAddSoldier, gg.bind(self.onBtnAddSoldier, self))
end

function UnionArmyNewSubItem:setData(army, teamIndex)
    self.army = army
    self.teamData = army.battleArmy.teams[teamIndex]
    self:refresh()
end

function UnionArmyNewSubItem:refresh()
    local teamData = self.teamData

    self.layoutHero:SetActiveEx(false)
    self.layoutSoldier:SetActiveEx(false)
    self.btnAddHero:SetActiveEx(false)
    self.btnAddSoldier:SetActiveEx(false)

    if teamData.heroId and teamData.heroId > 0 then
        self.layoutHero:SetActiveEx(true)
        if teamData.soliderCfgId and teamData.soliderCfgId > 0 then
            self.layoutSoldier:SetActiveEx(true)

            local soldierCfg = SoliderUtil.getSoliderCfgMap()[teamData.solider.cfgId][teamData.solider.level]
            self.soldierItem:setQuality(0)
            self.soldierItem:setIcon("Soldier_A_Atlas", soldierCfg.icon)
            self.txtSoldierCount.text = "X" .. teamData.soliderCount
        else
            self.btnAddSoldier:SetActiveEx(true)
        end

        local heroCfg = HeroUtil.getHeroCfg(teamData.hero.cfgId, teamData.hero.level, teamData.hero.quality)

        self.heroItem:setQuality(teamData.hero.quality)
        self.heroItem:setIcon("Hero_A_Atlas", heroCfg.icon)
        self.txtHeroLevel.text = "LV." .. teamData.hero.level
    else
        self.btnAddHero:SetActiveEx(true)
    end

end

function UnionArmyNewSubItem:onBtnAddHero()
    local args = {selectType = PnlUnionArmySelect.TYPE_SELECT_UNION_HERO}
    args.useCallBack = gg.bind(self.onUseHero, self)
    args.removeCallBack = gg.bind(self.onRemoveHero, self)
    args.teamData = self.teamData

    gg.uiManager:openWindow("PnlUnionArmySelect", args)
end

function UnionArmyNewSubItem:onBtnAddSoldier()
    local args = {selectType = PnlUnionArmySelect.TYPE_SELECT_UNION_SOLDIER}
    args.useCallBack = gg.bind(self.onUseSoldier, self)
    args.removeCallBack = gg.bind(self.onRemoveSoldier, self)
    args.teamData = self.teamData

    gg.uiManager:openWindow("PnlUnionArmySelect", args)
end

function UnionArmyNewSubItem:onUseHero(info)
    self.teamData.heroId = info.hero.id
    self.teamData.hero = info.hero
    self:refresh()
end

function UnionArmyNewSubItem:onRemoveHero()
    self.teamData.heroId = 0
    self.teamData.hero = nil

    self.teamData.soliderCfgId = 0
    self.teamData.solider = nil
    self.teamData.soliderCount = 0

    self:refresh()

    self.pnlUnionArmyNew:refreshSoldierCount()
    self.initData:refreshCount()
end

function UnionArmyNewSubItem:onUseSoldier(info)
    self.teamData.soliderCfgId = info.soldier.cfgId
    self.teamData.solider = info.soldier

    local count, isNotEnoughtArmy = UnionArmyUtil.getCanSetSoldierCount(info.soldier.cfgId)
    self.teamData.soliderCount = count

    self:refresh()
    self.pnlUnionArmyNew:refreshSoldierCount()
    self.initData:refreshCount()
end

function UnionArmyNewSubItem:onRemoveSoldier()
    self.teamData.soliderCfgId = 0
    self.teamData.solider = nil
    self.teamData.soliderCount = 0
    self:refresh()

    self.pnlUnionArmyNew:refreshSoldierCount()
    self.initData:refreshCount()
end

function UnionArmyNewSubItem:onRelease()
    self.heroItem:release()
    self.soldierItem:release()
end