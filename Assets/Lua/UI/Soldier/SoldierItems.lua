SoldierQuickTrainItem = SoldierQuickTrainItem or class("SoldierQuickTrainItem", ggclass.UIBaseItem)
function SoldierQuickTrainItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
    self.initData = initData
end

function SoldierQuickTrainItem:onInit()
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    self.txtTrainCount = self:Find("LayoutInfo/TxtTrainCount", "Text")
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function SoldierQuickTrainItem:setData(data)
    local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", data.soldierCfg.icon .. "_A")

    self.data = data
    self.txtTrainCount.text = data.canTrainCount
    self.commonItemItem:setQuality(SoliderUtil.getSoldierQuality(data.soldierCfg.cfgId))
    self.commonItemItem:setIcon(icon)
end

function SoldierQuickTrainItem:onBtnItem()
    print("onBtnItem")
end