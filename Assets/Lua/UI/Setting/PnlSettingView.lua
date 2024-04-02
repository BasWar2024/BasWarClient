PnlSettingView = class("PnlSettingView")

PnlSettingView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.layoutBtns = transform:Find("Root/LayoutBtns").gameObject

    self.settingMap = {}
    for i = 1, self.layoutBtns.transform.childCount, 1 do
        local item = self.layoutBtns.transform:GetChild(i - 1)
        self.settingMap[item.name] = {}
        self.settingMap[item.name].item = item
        self.settingMap[item.name].btn = item.transform:Find("Button").gameObject
        self.settingMap[item.name].txtBtn = self.settingMap[item.name].btn.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        self.settingMap[item.name].imgBtn = self.settingMap[item.name].btn.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    end

    self.btnVeryLow = transform:Find("Root/BtnVeryLow").gameObject
    self.btnLow = transform:Find("Root/BtnLow").gameObject
    self.btnMid = transform:Find("Root/BtnMid").gameObject
    self.btnHigh = transform:Find("Root/BtnHigh").gameObject
    self.btnVeryHigh = transform:Find("Root/BtnVeryHigh").gameObject
end

return PnlSettingView
