
PnlSettingCdKeyView = class("PnlSettingCdKeyView")

PnlSettingCdKeyView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAlert = transform:Find("Root/TxtAlert"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputField = transform:Find("Root/InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnCancel = transform:Find("Root/BtnCancel").gameObject
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject

    self.ViewGetGift = transform:Find("Root/ViewGetGift").gameObject
    self.btnConfirmGet = transform:Find("Root/ViewGetGift/Bg/BtnConfirmGet").gameObject

end

return PnlSettingCdKeyView