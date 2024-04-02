
PnlLinkView = class("PnlLinkView")

PnlLinkView.ctor = function(self, transform)

    self.transform = transform
    self.iconConnect = transform:Find("IconConnect")
    self.iconTick = transform:Find("IconTick").gameObject
    self.txtTick = transform:Find("IconTick/TxtTick"):GetComponent(UNITYENGINE_UI_TEXT)

    self.bg = transform:Find("Bg"):GetComponent(UNITYENGINE_UI_IMAGE)


end

return PnlLinkView