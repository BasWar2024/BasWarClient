
PnlCardDescView = class("PnlCardDescView")

PnlCardDescView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtDesc = transform:Find("Root/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlCardDescView