
PnlLoadingView = class("PnlLoadingView")

PnlLoadingView.ctor = function(self, transform)

    self.transform = transform

    self.sliderProgress = transform:Find("SliderProgress"):GetComponent("Slider")
    self.txtProgress = transform:Find("SliderProgress/TxtProgress"):GetComponent("Text")
end

return PnlLoadingView