
PnlForceUpgradeView = class("PnlForceUpgradeView")

PnlForceUpgradeView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgHero = transform:Find("Root/LayoutContent/ImgHero"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("Root/LayoutContent/LayoutTitle/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnLevel = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel").gameObject
    self.txtLevel = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgEnoughtUpgrade = transform:Find("Root/LayoutContent/LayoutTitle/BtnLevel/ImgEnoughtUpgrade"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.layoutUpgrade = transform:Find("Root/LayoutContent/LayoutUpgrade")
    self.commonUpgradeBox = ggclass.CommonUpgradeBox.new(transform:Find("Root/LayoutContent/LayoutUpgrade/CommonUpgradeBox"))
    self.attrScrollView = transform:Find("Root/LayoutContent/AttrScrollView").gameObject

    self.layoutForge = transform:Find("Root/LayoutContent/LayouForge")
    self.sliderForge = self.layoutForge:Find("SliderForge"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtForgeRaiot = self.layoutForge:Find("TxtForgeRaiot"):GetComponent(UNITYENGINE_UI_TEXT)
    self.commonAddCountBox = CommonAddCountBox.new(self.layoutForge:Find("CommonAddCountBox"))
    self.txtForgeMitPer = self.layoutForge:Find("TxtForgeMitPer"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtForgeMitCost = self.layoutForge:Find("TxtForgeMitCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputForgeRaiot = self.layoutForge:Find("InputForgeRaiot"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnForge = self.layoutForge:Find("BtnForge").gameObject

    self.forgeCostMap = {}
    self.layoutForgeCost = self.layoutForge:Find("LayoutForgeCost")
    for i = 1, self.layoutForgeCost.childCount do
        local child = self.layoutForgeCost:GetChild(i - 1)
        local item = {}
        item.item = child
        item.TxtCost = child:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
        self.forgeCostMap[child.name] = item
    end
end

return PnlForceUpgradeView