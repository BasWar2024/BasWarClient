
PnlSettingLanguageView = class("PnlSettingLanguageView")

PnlSettingLanguageView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.languageScrollView = transform:Find("Root/LanguageScrollView")
end

return PnlSettingLanguageView