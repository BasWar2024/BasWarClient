
PnlMintView = class("PnlMintView")

PnlMintView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject

    self.layoutReward = transform:Find("Root/LayoutContent/LayoutReward")

    self.imgWarshipBox = self.layoutReward:Find("ImgWarshipBox"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgTowerBox = self.layoutReward:Find("ImgTowerBox"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgHeroBox = self.layoutReward:Find("ImgHeroBox"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.layoutStar = self.layoutReward.transform:Find("LayoutStar")

    self.stars = {}

    for i = 1, 3, 1 do
        self.stars[i] = self.layoutStar.transform:GetChild(i - 1)
    end

    self.txtDesc = transform:Find("Root/LayoutContent/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDesc = transform:Find("Root/LayoutContent/TxtDesc/BtnDesc").gameObject
    self.bgDesc = self.btnDesc.transform:Find("BgDesc")

    self.txtProbabilityList = {}
    for i = 1, 3, 1 do
        self.txtProbabilityList[i] = self.bgDesc:Find("LayoutProbabilitys/TxtProbability" .. i):GetComponent(UNITYENGINE_UI_TEXT)
    end

    self.btnMint = transform:Find("Root/BtnMint").gameObject
    self.txtTime = transform:Find("Root/BtnMint/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutCost = self.btnMint.transform:Find("LayoutCost")
    self.txtCost1 = self.layoutCost:Find("TxtCost1"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCost2 = self.layoutCost:Find("TxtCost2"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlMintView