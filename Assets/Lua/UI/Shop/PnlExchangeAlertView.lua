
PnlExchangeAlertView = class("PnlExchangeAlertView")

PnlExchangeAlertView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtAlert = transform:Find("Root/TxtAlert"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgFrom = transform:Find("Root/ImgFrom"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtFrom = transform:Find("Root/TxtFrom"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgTo = transform:Find("Root/ImgTo"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtTo = transform:Find("Root/TxtTo"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnNo = transform:Find("Root/BtnNo").gameObject
    self.btnYes = transform:Find("Root/BtnYes").gameObject
end

return PnlExchangeAlertView