
PnlSoldierQuickTrainView = class("PnlSoldierQuickTrainView")

PnlSoldierQuickTrainView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.scrollView = transform:Find("Root/ScrollView").gameObject

    self.btnInstant = transform:Find("Root/BtnInstant").gameObject
    self.txtInstantCostStarCoin = self.btnInstant.transform:Find("TxtCostStarCoin"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtInstantCostMit = self.btnInstant.transform:Find("TxtCostMit"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnSupplement = transform:Find("Root/BtnSupplement").gameObject
    self.txtSupplementCost = self.btnSupplement.transform:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlSoldierQuickTrainView