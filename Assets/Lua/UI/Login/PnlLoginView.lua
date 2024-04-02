
PnlLoginView = class("PnlLoginView")

PnlLoginView.ctor = function(self, transform)

    self.transform = transform

    self.inputAccount = transform:Find("InformationBox/InputAccount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtAccount = transform:Find("InformationBox/InputAccount/TxtAccount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputPassword = transform:Find("InformationBox/InputPassword"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtPassword = transform:Find("InformationBox/InputPassword/TxtPassword"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnEnterGame = transform:Find("InformationBox/BtnEnterGame")
    self.btnRegister = transform:Find("InformationBox/BtnRegister")
    self.btnTourist = transform:Find("InformationBox/BtnTourist")
    self.btnFaceBook = transform:Find("InformationBox/BtnFaceBook")
    self.btnTwitter = transform:Find("InformationBox/BtnTwitter")
    self.btnYouTube = transform:Find("InformationBox/BtnYouTube")
    self.toggleEncryption = transform:Find("InformationBox/ToggleEncryption")


    self.btnAccount = transform:Find("InformationBox/BtnAccount").gameObject
    self.accountsScrollView = transform:Find("InformationBox/AccountsScrollView")


    self.version = transform:Find("Version"):GetComponent(UNITYENGINE_UI_TEXT)

    self.ToggleConsent = transform:Find("InformationBox/ToggleConsent"):GetComponent(UNITYENGINE_UI_TOGGLE)
    
    self.toggleRemember = transform:Find("InformationBox/ToggleRemeber"):GetComponent(UNITYENGINE_UI_TOGGLE)

    self.btnForgetPassword = transform:Find("InformationBox/BtnForgetPassword")

    self.btnLanguege = transform:Find("BtnLanguege").gameObject

    self.btnLogSwich = transform:Find("Version/BtnLogSwich").gameObject

    self.banTips = transform:Find("BanTips").gameObject
    self.btnConfirm = transform:Find("BanTips/Bg/BtnConfirm").gameObject

    self.txtUrl = transform:Find("TxtUrl"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlLoginView