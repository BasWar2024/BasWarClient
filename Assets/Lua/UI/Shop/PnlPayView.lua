
PnlPayView = class("PnlPayView")

PnlPayView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnCommit = transform:Find("Root/BtnCommit").gameObject

    self.txtName = transform:Find("Root/BgItem/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCost = transform:Find("Root/BgItem/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconItem = transform:Find("Root/BgItem/IconItem"):GetComponent(UNITYENGINE_UI_IMAGE)

    -- self.fullViewOptionBtnBox = transform:Find("Root/FullViewOptionBtnBox")
    self.pia = transform:Find("Root/Pia")
    self.currency = transform:Find("Root/Currency")
    self.PayType = transform:Find("Root/PayType")

end

return PnlPayView