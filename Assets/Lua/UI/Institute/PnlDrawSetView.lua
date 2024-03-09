
PnlDrawSetView = class("PnlDrawSetView")

PnlDrawSetView.ctor = function(self, transform)
    self.transform = transform
    self.slider = transform:Find("bg/Slider"):GetComponent("Slider")
    self.txtTimeSet = transform:Find("bg/Slider/txtTimeSet"):GetComponent("Text")
    self.btnYes = transform:Find("bg/layoutBtns/BtnYes").gameObject
    self.btnNo = transform:Find("bg/layoutBtns/BtnNo").gameObject
    self.btnClose = transform:Find("bg/BtnClose").gameObject
end

return PnlDrawSetView