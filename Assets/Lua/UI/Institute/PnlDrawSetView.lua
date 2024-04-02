
PnlDrawSetView = class("PnlDrawSetView")

PnlDrawSetView.ctor = function(self, transform)
    self.transform = transform
    self.slider = transform:Find("bg/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtTimeSet = transform:Find("bg/Slider/txtTimeSet"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnYes = transform:Find("bg/layoutBtns/BtnYes").gameObject
    self.btnNo = transform:Find("bg/layoutBtns/BtnNo").gameObject
    self.btnClose = transform:Find("bg/BtnClose").gameObject
end

return PnlDrawSetView