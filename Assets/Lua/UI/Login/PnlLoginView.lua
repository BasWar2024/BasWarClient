
PnlLoginView = class("PnlLoginView")

PnlLoginView.ctor = function(self, transform)

    self.transform = transform

    self.inputAccount = transform:Find("InformationBox/InputAccount"):GetComponent("InputField")
    self.txtAccount = transform:Find("InformationBox/InputAccount/TxtAccount"):GetComponent("Text")
    self.inputPassword = transform:Find("InformationBox/InputPassword"):GetComponent("InputField")
    self.txtPassword = transform:Find("InformationBox/InputPassword/TxtPassword"):GetComponent("Text")
    self.btnEnterGame = transform:Find("InformationBox/BtnEnterGame")
    self.btnRegister = transform:Find("InformationBox/BtnRegister")
    self.btnTourist = transform:Find("InformationBox/BtnTourist")
    self.btnFaceBook = transform:Find("InformationBox/BtnFaceBook")
    self.btnTwitter = transform:Find("InformationBox/BtnTwitter")
    self.btnYouTube = transform:Find("InformationBox/BtnYouTube")
    self.toggleEncryption = transform:Find("InformationBox/ToggleEncryption")
    self.version = transform:Find("Version"):GetComponent("Text")

end

return PnlLoginView