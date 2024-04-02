
PnlTaskRewardView = class("PnlTaskRewardView")

PnlTaskRewardView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("BtnClose").gameObject

    self.scrollView = transform:Find("Root/ScrollView")
end

return PnlTaskRewardView