
PnlUpgradeView = class("PnlUpgradeView")

PnlUpgradeView.ctor = function(self, transform)

    self.transform = transform

    self.btnReturn = transform:Find("ViewBg/Bg/BtnReturn").gameObject
    self.txtLevel = transform:Find("BgMsg/TxtLevel"):GetComponent("Text")
    self.txtName = transform:Find("BgMsg/TxtName"):GetComponent("Text")

    self.iconSkill = transform:Find("BgIcon/IconSkill"):GetComponent("Image")
    self.iconLevel = transform:Find("BgIcon/IconLevel"):GetComponent("Image")

    self.attrScrollView = transform:Find("AttrScrollView").gameObject
    self.commonUpgradeBox = ggclass.CommonUpgradeBox.new(transform:Find("CommonUpgradeBox").gameObject)
end

return PnlUpgradeView