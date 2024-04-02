PnlUnionNftView = class("PnlUnionNftView")

PnlUnionNftView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnNft = transform:Find("ViewBg/Bg/LeftButton/BtnNft").gameObject
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnAddNft = transform:Find("WarehouseNft/BtnAddNft").gameObject
    self.btnDonateDesc = transform:Find("WarehouseNft/BtnDonateDesc").gameObject
    
    self.leftBtnIcon = {}
    self.leftBtnIcon[1] = self.btnNft.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.leftBtnText = {}
    self.leftBtnText[1] = self.btnNft.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtHashrate = transform:Find("WarehouseNft/BgHashrate/TxtHashrate"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPerHour = transform:Find("WarehouseNft/BgPerHour/TxtPerHour"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNftContribution = transform:Find("WarehouseNft/BgContribution/TxtNftContribution"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.btnCloseAdd = transform:Find("ViewAddNft/Bg/BtnClose").gameObject

    self.warehouseNft = transform:Find("WarehouseNft").gameObject
    self.scrollViewNft = transform:Find("WarehouseNft/ScrollView/Viewport/Content")

    self.viewAddNft = transform:Find("ViewAddNft").gameObject
    self.scrollViewAddNft = transform:Find("ViewAddNft/ScrollView/Viewport/Content")

end

return PnlUnionNftView
