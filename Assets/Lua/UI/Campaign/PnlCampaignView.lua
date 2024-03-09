
PnlCampaignView = class("PnlCampaignView")

PnlCampaignView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("BtnClose").gameObject
end

return PnlCampaignView