
PnlTaskRewardDescView = class("PnlTaskRewardDescView")

PnlTaskRewardDescView.ctor = function(self, transform)

    self.transform = transform

    self.layoutDetailed = transform:Find("LayoutDetailed")
    self.txtType = transform:Find("LayoutDetailed/TxtType"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBoxResDetailedDesc = transform:Find("LayoutDetailed/ScrollViewDesc/Viewport/TxtBoxResDetailedDesc"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlTaskRewardDescView