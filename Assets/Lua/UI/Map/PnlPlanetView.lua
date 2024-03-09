
PnlPlanetView = class("PnlPlanetView")

PnlPlanetView.ctor = function(self, transform)

    self.transform = transform

    self.btnReturn = transform:Find("BtnReturn").gameObject
    self.btnBag = transform:Find("BtnBag").gameObject

end

return PnlPlanetView