
PnlLoadingView = class("PnlLoadingView")

PnlLoadingView.ctor = function(self, transform)

    self.transform = transform
    self.bgIcon = transform:Find("Bg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.sliderProgress = transform:Find("SliderProgress"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtProgress = transform:Find("SliderProgress/TxtProgress"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlLoadingView