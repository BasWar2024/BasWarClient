
PnlPledgeSetView = class("PnlPledgeSetView")

PnlPledgeSetView.ctor = function(self, transform)

    self.transform = transform
    self.slider = transform:Find("bg/Slider"):GetComponent("Slider")
    self.txtSet = transform:Find("bg/Slider/txtSet"):GetComponent("Text")
    self.btnYes = transform:Find("bg/layoutBtns/BtnYes").gameObject
    self.btnNo = transform:Find("bg/layoutBtns/BtnNo").gameObject
    self.slider = transform:Find("bg/Slider"):GetComponent("Slider")
    self.txtAfter = transform:Find("bg/LayoutProduct/TxtAfter"):GetComponent("Text")
    self.txtBefore = transform:Find("bg/LayoutProduct/TxtBefore"):GetComponent("Text")
end

return PnlPledgeSetView