
PnlPledgeView = class("PnlPledgeView")

PnlPledgeView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.pledgeBox = transform:Find("PledgeBox")
end

return PnlPledgeView