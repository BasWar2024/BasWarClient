
PnlServiceView = class("PnlServiceView")

PnlServiceView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("InformationBox/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("InformationBox/BtnClose").gameObject
end

return PnlServiceView