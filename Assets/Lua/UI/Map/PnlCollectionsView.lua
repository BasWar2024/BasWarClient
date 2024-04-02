
PnlCollectionsView = class("PnlCollectionsView")

PnlCollectionsView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCollectionNum = transform:Find("Root/BgCollectionNum/TxtCollectionNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputField = transform:Find("Root/InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnCancel = transform:Find("Root/BtnCancel").gameObject
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject
end

return PnlCollectionsView