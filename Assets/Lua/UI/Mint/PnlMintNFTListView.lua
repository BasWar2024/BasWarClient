
PnlMintNFTListView = class("PnlMintNFTListView")

PnlMintNFTListView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtNumber = transform:Find("Root/BgNumbers/TxtNumber"):GetComponent(UNITYENGINE_UI_TEXT)

    self.scrollView = transform:Find("Root/ScrollView")

    self.commonfilterBox = transform:Find("Root/CommonfilterBox")
end

return PnlMintNFTListView