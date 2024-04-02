
PnlItemInfoView = class("PnlItemInfoView")

PnlItemInfoView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(typeof(CS.TextYouYU))
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgIcon = transform:Find("Root/Mask/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.layoutLevel = transform:Find("Root/LayoutLevel")
    self.txtLevel = self.layoutLevel:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attrScrollView = transform:Find("Root/AttrScrollView")

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.txtDesc = transform:Find("Root/LayoutInfo/Viewport/TxtDesc"):GetComponent(typeof(CS.TextYouYU))

    self.layoutUpgrade = transform:Find("Root/LayoutUpgrade")
    self.commonUpgradeNewBox = CommonUpgradeNewBox.new(self.layoutUpgrade:Find("CommonUpgradeNewBox"))
end

return PnlItemInfoView