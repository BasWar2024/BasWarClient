
PnlSettingServiceView = class("PnlSettingServiceView")

PnlSettingServiceView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("BtnClose").gameObject
    self.txt = transform:Find("Txt"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlSettingServiceView