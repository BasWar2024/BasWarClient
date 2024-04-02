
PnlSoldierInstantTrainView = class("PnlSoldierInstantTrainView")

PnlSoldierInstantTrainView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtDesc = transform:Find("Root/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnInstant = transform:Find("Root/LayoutBtns/BtnInstant").gameObject
    self.txtCostStarCoin = transform:Find("Root/LayoutBtns/BtnInstant/TxtCostStarCoin"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCostMit = transform:Find("Root/LayoutBtns/BtnInstant/TxtCostMit"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDapp = transform:Find("Root/LayoutBtns/BtnDapp").gameObject
end

return PnlSoldierInstantTrainView