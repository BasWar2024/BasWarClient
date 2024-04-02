
PnlForgetPasswordView = class("PnlForgetPasswordView")

PnlForgetPasswordView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.inputAccount = transform:Find("InputAccount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtAccount = transform:Find("InputAccount/TxtAccount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgMail = transform:Find("InputAccount/ImgMail"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgLine = transform:Find("InputAccount/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.inputPassword = transform:Find("InputPassword"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtPassword = transform:Find("InputPassword/TxtPassword"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLock = transform:Find("InputPassword/ImgLock"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgLine = transform:Find("InputPassword/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.inputConfirmPassword = transform:Find("InputPasswordConfirm"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtConfirmPassword = transform:Find("InputPasswordConfirm/TxtPasswordConfirm"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLock = transform:Find("InputPasswordConfirm/ImgLock"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgLine = transform:Find("InputPasswordConfirm/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.inputEmailCode = transform:Find("InputEmailCode"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtPassword = transform:Find("InputEmailCode/TxtPassword"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnSendCode = transform:Find("InputEmailCode/BtnSendCode").gameObject
    self.imgLine = transform:Find("InputEmailCode/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnReset = transform:Find("BtnReset").gameObject
    self.txtSend = self.btnSendCode.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.toggleEncryption = transform:Find("ToggleEncryption").gameObject
    self.toggleEncryptionConfirm = transform:Find("ToggleEncryptionConfirm").gameObject

end

return PnlForgetPasswordView