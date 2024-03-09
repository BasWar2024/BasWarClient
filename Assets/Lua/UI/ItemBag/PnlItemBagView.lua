
PnlItemBagView = class("PnlItemBagView")

PnlItemBagView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnType = transform:Find("BtnType").gameObject
    self.txtType = transform:Find("BtnType/TxtType"):GetComponent("Text")
    self.btnRare = transform:Find("BtnRare").gameObject
    self.txtRare = transform:Find("BtnRare/TxtRare"):GetComponent("Text")
    self.btnQuantity = transform:Find("BtnQuantity").gameObject
    self.txtQuantity = transform:Find("BtnQuantity/TxtQuantity"):GetComponent("Text")
    self.btnFull = transform:Find("BtnFull").gameObject
    self.txtFull = transform:Find("BtnFull/TxtFull"):GetComponent("Text")
    self.btnFastFull = transform:Find("BtnFastFull").gameObject
    self.txtFastFull = transform:Find("BtnFastFull/TxtFastFull"):GetComponent("Text")
    self.txtTips = transform:Find("ViewTips/TxtTips"):GetComponent("Text")
    self.viewContent = transform:Find("ViewItemBag/Viewport/ViewContent")
    self.uiItem = transform:Find("UiItem")
    self.btnDel = transform:Find("UiItem/BtnDel").gameObject
    self.btnUse = transform:Find("UiItem/BtnUse").gameObject

end

return PnlItemBagView