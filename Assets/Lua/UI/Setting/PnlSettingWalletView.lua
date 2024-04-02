
PnlSettingWalletView = class("PnlSettingWalletView")

PnlSettingWalletView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtAlert = transform:Find("Root/TxtAlert"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUnbind = transform:Find("Root/BgWalletInfo/TxtUnbind"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtWallet = transform:Find("Root/BgWalletInfo/TxtWallet"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnCopy = transform:Find("Root/BgWalletInfo/BtnCopy").gameObject
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject
    self.txtChainId = transform:Find("Root/TxtChainId"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlSettingWalletView