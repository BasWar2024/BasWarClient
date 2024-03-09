
PnlAlertView = class("PnlAlertView")

PnlAlertView.ctor = function(self, transform)

    self.transform = transform

    self.btnYes = transform:Find("BtnYes").gameObject
    self.btnNo = transform:Find("BtnNo").gameObject
    self.txtTip = transform:Find("TxtTips"):GetComponent("Text")
    self.txtBtnYes = transform:Find("BtnYes/Text"):GetComponent("Text")
end

return PnlAlertView