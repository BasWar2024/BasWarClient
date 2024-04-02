
PnlForgeResultView = class("PnlForgeResultView")

PnlForgeResultView.ctor = function(self, transform)
    self.transform = transform
    self.bg = transform:Find("Bg").gameObject
    self.txtContent = transform:Find("Root/TxtContent"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtResult = transform:Find("Root/TxtResult"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlForgeResultView