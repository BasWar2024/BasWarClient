PnlMyPlanetView = class("PnlMyPlanetView")

PnlMyPlanetView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("ViewBg/BtnClose").gameObject
    self.txtTitle = transform:Find("ViewBg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnNft = transform:Find("BtnNft").gameObject
    self.txtNft = transform:Find("BtnNft/TxtNft"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnConfusion = transform:Find("BtnConfusion").gameObject
    self.txtConfusion = transform:Find("BtnConfusion/TxtConfusion"):GetComponent(UNITYENGINE_UI_TEXT)

    self.nftPlanet = transform:Find("ViewNftPlanet").gameObject
    self.nftPlanetContent = transform:Find("ViewNftPlanet/Viewport/Content")

    self.confusionPlanet = transform:Find("ViewConfusionPlanet").gameObject
    self.confusionPlanetContent = transform:Find("ViewConfusionPlanet/Viewport/Content")

end

return PnlMyPlanetView
