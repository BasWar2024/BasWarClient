
PnlRuleView = class("PnlRuleView")

PnlRuleView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.scrollView = transform:Find("Root/ScrollView")
    self.content = self.scrollView:Find("Viewport/Content")
    self.txtContent = self.content:Find("TxtContent"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlRuleView