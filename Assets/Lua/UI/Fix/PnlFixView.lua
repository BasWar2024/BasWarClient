
PnlFixView = class("PnlFixView")

PnlFixView.ctor = function(self, transform)
    self.transform = transform
    self.btnClose = transform:Find("Root/BtnClose").gameObject

    self.bgItem = transform:Find("Root/LayoutContent/BgItem")
    self.imgBuilding = transform:Find("Root/LayoutContent/ImgBuilding"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = self.imgBuilding.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    
    self.slider = transform:Find("Root/LayoutContent/ImgBuilding/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.textSlider = self.slider.transform:Find("TextSlider"):GetComponent(UNITYENGINE_UI_TEXT)

    self.sliderLifeAll = transform:Find("Root/SliderLifeAll"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtSliderLifeAll = self.sliderLifeAll.transform:Find("TxtSliderLifeAll"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutContent = transform:Find("Root/LayoutContent")
    self.commonUpgradePartFix = self.layoutContent:Find("Mid/CommonUpgradePartFix")
    self.commonUpgradePartInstant = self.layoutContent:Find("Mid/CommonUpgradePartInstant")

    self.btnFixAll = transform:Find("Root/BtnFixAll").gameObject
    self.txtCostAll = transform:Find("Root/BtnFixAll/TxtCostAll"):GetComponent(UNITYENGINE_UI_TEXT)
    self.scrollContent = transform:Find("Root/LayoutBottom/ScrollViewCanFix/Viewport/Content").gameObject
    self.scrollViewCanFix = transform:Find("Root/LayoutBottom/ScrollViewCanFix").gameObject
end

return PnlFixView