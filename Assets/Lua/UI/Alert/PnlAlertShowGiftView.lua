
PnlAlertShowGiftView = class("PnlAlertShowGiftView")

PnlAlertShowGiftView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnReceive = transform:Find("Root/BtnReceive").gameObject

    self.content = transform:Find("Root/ScrollView/Viewport/Content")

end

return PnlAlertShowGiftView