
PnlBuildView = class("PnlBuildView")

PnlBuildView.ctor = function(self, transform)

    self.transform = transform
    self.buildScrollView = transform:Find("Root/BuildScrollView")
    self.bottomOptionalBtnsBox = BottomOptionalBtnsBox.new(transform:Find("Root/BottomOptionalBtnsBox"))
end

return PnlBuildView