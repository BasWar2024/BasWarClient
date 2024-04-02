
PnlRegisterView = class("PnlRegisterView")

PnlRegisterView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.inputAccount = transform:Find("InputAccount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtAccount = transform:Find("InputAccount/TxtAccount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputPassword = transform:Find("InputPassword"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputConfirmPassword = transform:Find("InputPasswordConfirm"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputEmailCode = transform:Find("InputEmailCode"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputInviteCode = transform:Find("InputInviteCode"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnSendCode = transform:Find("InputEmailCode/BtnSendCode").gameObject
    self.txtSend = self.btnSendCode.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.toggleConsent = transform:Find("ToggleConsent")
    self.btnRegistration = transform:Find("BtnRegistration").gameObject
    self.txtService = transform:Find("ToggleConsent/TxtService"):GetComponent(UNITYENGINE_UI_TEXT)
    self.toggleEncryption = transform:Find("ToggleEncryption").gameObject
    self.toggleEncryptionConfirm = transform:Find("ToggleEncryptionConfirm").gameObject

    self.txtAccountTips = transform:Find("InputAccount/TxtAccountTips").gameObject
    self.txtPasswordTips = transform:Find("InputPassword/TxtPasswordTips").gameObject
    self.txtPasswordAgainTips = transform:Find("InputPasswordConfirm/TxtPasswordAgainTips").gameObject

end

return PnlRegisterView