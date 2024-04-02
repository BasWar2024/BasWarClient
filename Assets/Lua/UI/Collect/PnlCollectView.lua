
PnlCollectView = class("PnlCollectView")

PnlCollectView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("ViewBg/BtnClose").gameObject
    self.txtTitle = transform:Find("ViewBg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)

    self.content = transform:Find("ViewCollect/Viewport/Content")
end

return PnlCollectView