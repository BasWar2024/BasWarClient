
PnlNFTTowerView = class("PnlNFTTowerView")

PnlNFTTowerView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("Root/Bg/BtnClose").gameObject
    self.txtTitle = transform:Find("Root/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgIcon = transform:Find("Root/LayoutInfo/BgIcon/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtInfoId = transform:Find("Root/LayoutInfo/BgName/TxtInfoId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRecycle = transform:Find("Root/LayoutInfo/BgName/BtnRecycle").gameObject
    self.txtInfoName = transform:Find("Root/LayoutInfo/BgName/TxtInfoName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtInfoLevel = transform:Find("Root/LayoutInfo/TxtInfoLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtRealLevel = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRealLevel = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel/BtnRealLevel").gameObject

    self.bgExplain = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel/BtnRealLevel/BgExplain")
    self.txtExplain = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel/BtnRealLevel/BgExplain/TxtExplain"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.commonUpgradeNewBox = self.layoutInfo:Find("CommonUpgradeNewBox")

    self.towerScrollView = transform:Find("Root/TowerScrollView")

    self.attrScrollView = self.layoutInfo:Find("AttrScrollView")
end

return PnlNFTTowerView