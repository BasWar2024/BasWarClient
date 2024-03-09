
PnlRegisterView = class("PnlRegisterView")

PnlRegisterView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.inputAccount = transform:Find("InputAccount"):GetComponent("InputField")
    self.txtAccount = transform:Find("InputAccount/TxtAccount"):GetComponent("Text")
    self.inputPassword = transform:Find("InputPassword"):GetComponent("InputField")
    self.txtPassword = transform:Find("InputPassword/TxtPassword"):GetComponent("Text")
    self.inputEmailCode = transform:Find("InputEmailCode"):GetComponent("InputField")
    self.txtPassword = transform:Find("InputEmailCode/TxtPassword"):GetComponent("Text")
    self.btnSendCode = transform:Find("InputEmailCode/BtnSendCode").gameObject
    self.toggleConsent = transform:Find("ToggleConsent")
    self.btnRegistration = transform:Find("BtnRegistration").gameObject
end

return PnlRegisterView