
PnlFixView = class("PnlFixView")

PnlFixView.ctor = function(self, transform)
    self.transform = transform

    self.btnBG = transform:Find("ViewBg").gameObject
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgBuilding = transform:Find("Root/LayoutContent/ImgBuilding"):GetComponent("Image")

    -- self.layoutProgress = transform:Find("Root/LayoutContent/ImgBuilding/LayoutProgress").gameObject
    
    self.slider = transform:Find("Root/LayoutContent/ImgBuilding/Slider"):GetComponent("Slider")
    self.textSlider = self.slider.transform:Find("TextSlider"):GetComponent("Text")

    self.sliderFix = transform:Find("Root/LayoutContent/ImgBuilding/SliderFix"):GetComponent("Slider")
    self.tmpSliderFix = self.sliderFix.transform:Find("TextSlider"):GetComponent("Text")

    self.btnFix = transform:Find("Root/LayoutContent/Mid/BtnFix").gameObject
    self.imgCost = transform:Find("Root/LayoutContent/Mid/BtnFix/ImgCost"):GetComponent("Image")
    self.txtCost = transform:Find("Root/LayoutContent/Mid/BtnFix/TxtCost"):GetComponent("Text")

    self.btnInstant = transform:Find("Root/LayoutContent/Mid/BtnInstant").gameObject
    self.txtInstantCost = transform:Find("Root/LayoutContent/Mid/BtnInstant/TxtCost"):GetComponent("Text")

    self.btnFixAll = transform:Find("Root/BtnFixAll").gameObject
    self.txtCostAll = transform:Find("Root/BtnFixAll/TxtCostAll"):GetComponent("Text")
    self.scrollContent = transform:Find("Root/LayoutBottom/ScrollViewCanFix/Viewport/Content").gameObject
    self.scrollViewCanFix = transform:Find("Root/LayoutBottom/ScrollViewCanFix").gameObject
end

return PnlFixView