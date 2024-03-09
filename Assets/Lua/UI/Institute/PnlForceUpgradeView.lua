
PnlForceUpgradeView = class("PnlForceUpgradeView")

PnlForceUpgradeView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgHero = transform:Find("Root/LayoutContent/ImgHero"):GetComponent("Image")
    self.txtName = transform:Find("Root/LayoutContent/LayoutTitle/TxtName"):GetComponent("Text")
    self.btnLevel = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel").gameObject
    self.txtLevel = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel/TxtLevel"):GetComponent("Text")
    self.imgEnoughtUpgrade = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel/ImgEnoughtUpgrade"):GetComponent("Image")

    self.commonUpgradeBox = ggclass.CommonUpgradeBox.new(transform:Find("Root/LayoutContent/LayoutUpgrade/CommonUpgradeBox"))
    self.attrScrollView = transform:Find("Root/LayoutContent/AttrScrollView").gameObject
end

return PnlForceUpgradeView