PlanetSoldierItem = PlanetSoldierItem or class("PlanetSoldierItem", ggclass.UIBaseItem)

function PlanetSoldierItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PlanetSoldierItem:onRelease()
    self.commonItemItem:release()
end

function PlanetSoldierItem:onInit()
    self.commonItemItem = CommonItemItem.new(self.transform:Find("CommonItemItem"))

    self.txtCount = self:Find("TxtCount", "Text")
end

function PlanetSoldierItem:setData(data)
    self.data = data
    self.txtCount.text = data.soliderCount
    local soldierData = BuildData.soliderLevelData[data.soliderCfgId]
    local soldierCfg = SoliderUtil.getSoliderCfgMap()[data.soliderCfgId][soldierData.level]

    self.commonItemItem:setQuality(SoliderUtil.getSoldierQuality(data.soliderCfgId))
    local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", soldierCfg.icon .. "_A")
    self.commonItemItem:setIcon(icon)
end
