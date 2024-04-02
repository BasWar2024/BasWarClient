
PnlTipNodeView = class("PnlTipNodeView")

PnlTipNodeView.ctor = function(self, transform)

    self.transform = transform

    self.tipsNode = transform:Find("TipsNode")
end

return PnlTipNodeView