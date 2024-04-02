
PnlMapEntranceView = class("PnlMapEntranceView")

PnlMapEntranceView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnBsc = transform:Find("Root/BtnBsc").gameObject
    self.btnCon = transform:Find("Root/BtnCon").gameObject
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject
end

return PnlMapEntranceView