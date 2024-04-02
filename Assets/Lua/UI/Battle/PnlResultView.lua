
PnlResultView = class("PnlResultView")

PnlResultView.ctor = function(self, transform)
    self.transform = transform
    self.battleResultBox = transform:Find("BattleResultBox")
end

return PnlResultView