
PnlRewardView = class("PnlRewardView")

PnlRewardView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("BtnClose").gameObject

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDetermine = transform:Find("Root/BtnDetermine").gameObject

    self.scrollView = transform:Find("Root/ScrollView")

    self.root = transform:Find("Root")
end

return PnlRewardView