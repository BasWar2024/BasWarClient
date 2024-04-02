
PnlBuyCountView = class("PnlBuyCountView")

PnlBuyCountView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTitle2 = transform:Find("Root/TxtTitle2"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnYes = transform:Find("Root/BtnYes").gameObject
    self.btnNo = transform:Find("Root/BtnNo").gameObject

    self.txtCost = transform:Find("Root/BtnYes/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBuyCount = transform:Find("Root/TxtBuyCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.commonAddCountBox = transform:Find("Root/CommonAddCountBox")

    self.iconCost = self.txtCost.transform:Find("IconCost"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.slider = transform:Find("Root/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
end

return PnlBuyCountView