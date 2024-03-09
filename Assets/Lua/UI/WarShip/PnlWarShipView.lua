
PnlWarShipView = class("PnlWarShipView")

PnlWarShipView.ctor = function(self, transform)

    self.transform = transform

    self.viewSkill = transform:Find("ViewSkill").gameObject
    self.viewUpgrade = transform:Find("ViewUpgrade").gameObject
    self.viewInformation = transform:Find("ViewInformation").gameObject
    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")
    self.txtLevel = transform:Find("BgMsg/TxtLevel"):GetComponent("Text")
    self.txtName = transform:Find("BgMsg/TxtName"):GetComponent("Text")
    self.btnRecycle = transform:Find("BgMsg/BtnRecycle").gameObject
    self.txtEnergyTitle = transform:Find("BgEnergy/TxtEnergyTitle"):GetComponent("Text")
    self.txtEnergy = transform:Find("BgEnergy/TxtEnergy"):GetComponent("Text")
    self.btnSkill1 = transform:Find("ViewSkill/BtnSkill1").gameObject
    self.btnSkill2 = transform:Find("ViewSkill/BtnSkill2").gameObject
    self.btnSkill3 = transform:Find("ViewSkill/BtnSkill3").gameObject
    self.btnSkill4 = transform:Find("ViewSkill/BtnSkill4").gameObject
    self.btnSkill5 = transform:Find("ViewSkill/BtnSkill5").gameObject
    self.upgradeBox = transform:Find("ViewSkill/UpgradeBox")
    self.btnSkillUpgrade = transform:Find("ViewSkill/UpgradeBox/BtnSkillUpgrade").gameObject
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.commonUpgradeBox = ggclass.CommonUpgradeBox.new(transform:Find("ViewUpgrade/CommonUpgradeBox"))

    self.txtInformation = transform:Find("ViewInformation/TxtInformation"):GetComponent("Text")
    self.scrollbarDurability = transform:Find("BgWarShip/ScrollbarDurability"):GetComponent("Scrollbar")
    self.txtDurability = transform:Find("BgWarShip/ScrollbarDurability/TxtDurability"):GetComponent("Text")
    self.bgWarShip = transform:Find("BgWarShip").gameObject
    self.bgSkill = transform:Find("BgSkill").gameObject

end

return PnlWarShipView