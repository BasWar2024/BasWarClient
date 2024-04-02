
PnlChangeNameView = class("PnlChangeNameView")

PnlChangeNameView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.inputName = transform:Find("Root/InputName"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnSet = transform:Find("BtnSet").gameObject
    self.txtBtnSet = self.btnSet.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtCost = transform:Find("BtnSet/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgCost = transform:Find("BtnSet/TxtCost/ImgCost"):GetComponent(UNITYENGINE_UI_IMAGE)
end

return PnlChangeNameView