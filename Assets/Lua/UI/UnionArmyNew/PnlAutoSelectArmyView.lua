
PnlAutoSelectArmyView = class("PnlAutoSelectArmyView")

PnlAutoSelectArmyView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnYes = transform:Find("Root/BtnYes").gameObject
    self.slider = transform:Find("Root/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtCount = transform:Find("Root/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAlert = transform:Find("Root/TxtAlert"):GetComponent(UNITYENGINE_UI_TEXT)

    self.commonAddCountBox = transform:Find("Root/CommonAddCountBox")
end

return PnlAutoSelectArmyView