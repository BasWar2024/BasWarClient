
PnlMintInfoView = class("PnlMintInfoView")

PnlMintInfoView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject
    self.txtDaoScore = transform:Find("Root/BgDaoScore/TxtDaoScore"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnMint = transform:Find("Root/BtnMint").gameObject

    self.scrollView = transform:Find("Root/ScrollView")

    self.fullViewOptionBtnBox = transform:Find("Root/FullViewOptionBtnBox")

    self.btnDesc = transform:Find("Root/BgDaoScore/BtnDesc").gameObject
end

return PnlMintInfoView