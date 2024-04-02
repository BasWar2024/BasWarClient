
PnlGvgResultView = class("PnlGvgResultView")

PnlGvgResultView.ctor = function(self, transform)

    self.transform = transform

    self.txtTips = transform:Find("ViewResult/BgCost/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDefeat = transform:Find("ViewResult/BgCost/TxtDefeat"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnConFirm = transform:Find("ViewResult/BtnConFirm").gameObject
    self.btnReview = transform:Find("ViewResult/BtnReview").gameObject

    self.iconResult = transform:Find("ViewResult/IconResult"):GetComponent(UNITYENGINE_UI_IMAGE)
end

return PnlGvgResultView