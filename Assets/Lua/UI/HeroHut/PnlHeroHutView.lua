
PnlHeroHutView = class("PnlHeroHutView")

PnlHeroHutView.ctor = function(self, transform)
    self.transform = transform
    self.btnBG = transform:Find("ViewBg").gameObject
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgHero = transform:Find("Root/LayoutContent/ImgHero"):GetComponent("Image")
    self.txtName = transform:Find("Root/LayoutContent/LayoutTitle/TxtName"):GetComponent("Text")

    self.btnLevel = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel").gameObject
    self.txtLevel = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel/TxtLevel"):GetComponent("Text")
    self.imgEnoughtUpgrade = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel/ImgEnoughtUpgrade"):GetComponent("Image")

    self.attrScrollView = transform:Find("Root/LayoutContent/AttrScrollView").gameObject
    self.layoutSkill = transform:Find("Root/LayoutContent/LayoutSkill").gameObject

    self.sliderLife = self.transform:Find("Root/LayoutContent/SliderLife"):GetComponent("Slider")
    self.txtSliderLife = self.sliderLife.transform:Find("TxtSlider"):GetComponent("Text")

    self.sliderUpgrade = self.transform:Find("Root/LayoutContent/SliderUpgrade"):GetComponent("Slider")
    self.txtSliderUpgrade = self.sliderUpgrade.transform:Find("TxtSlider"):GetComponent("Text")

    self.btnRecycle = transform:Find("Root/LayoutContent/LayoutTitle/BtnRecycle").gameObject

    self.layoutSkill = transform:Find("Root/LayoutContent/LayoutSkill").gameObject
    self.layoutUpgrade = transform:Find("Root/LayoutContent/LayoutUpgrade").gameObject
    self.txtDesc = self.layoutUpgrade.transform:Find("TxtDesc"):GetComponent("Text")

    self.commonUpgradeBox = CommonUpgradeBox.new(transform:Find("Root/LayoutContent/LayoutUpgrade/CommonUpgradeBox").gameObject)
end

return PnlHeroHutView