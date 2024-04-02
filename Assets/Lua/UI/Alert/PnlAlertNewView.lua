
PnlAlertNewView = class("PnlAlertNewView")

PnlAlertNewView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTips = transform:Find("Root/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnNo = transform:Find("Root/LayoutBtns/BtnNo").gameObject
    self.txtBtnNo = transform:Find("Root/LayoutBtns/BtnNo/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.commonUpgradePartYes = transform:Find("Root/LayoutBtns/CommonUpgradePartYes").gameObject

    self.root = transform:Find("Root"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM)



    self.bg = transform:Find("Bg"):GetComponent(UNITYENGINE_UI_IMAGE)

end

return PnlAlertNewView