
PnlBattleDrawCardView = class("PnlBattleDrawCardView")

PnlBattleDrawCardView.ctor = function(self, transform)

    self.transform = transform

    self.layoutDef = transform:Find("LayoutDef")
    self.layoutDefCards = self.layoutDef:Find("LayoutDefCards")

    self.layoutAtk = transform:Find("LayoutAtk")
    self.layoutAtkCards = self.layoutAtk:Find("LayoutAtkCards")
end

return PnlBattleDrawCardView