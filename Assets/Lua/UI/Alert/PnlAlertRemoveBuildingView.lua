
PnlAlertRemoveBuildingView = class("PnlAlertRemoveBuildingView")

PnlAlertRemoveBuildingView.ctor = function(self, transform)
    self.transform = transform
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtTips = transform:Find("Root/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnYes = transform:Find("Root/BtnYes").gameObject
    self.btnNo = transform:Find("Root/BtnNo").gameObject
    
    self.txtCost = transform:Find("Root/BtnYes/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.scrollView = transform:Find("Root/ScrollView")
end

return PnlAlertRemoveBuildingView