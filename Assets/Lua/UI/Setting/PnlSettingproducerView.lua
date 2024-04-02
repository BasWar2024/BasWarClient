
PnlSettingproducerView = class("PnlSettingproducerView")

PnlSettingproducerView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("btnClose").gameObject
    self.scrollView = transform:Find("ScrollView"):GetComponent("ScrollRect")
end

return PnlSettingproducerView