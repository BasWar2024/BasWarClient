
PnlRewardSmallView = class("PnlRewardSmallView")

PnlRewardSmallView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.scrollView = transform:Find("Root/ScrollView").gameObject

    self.btnYes = transform:Find("Root/BtnYes").gameObject
end

return PnlRewardSmallView