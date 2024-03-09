
PnlSettingView = class("PnlSettingView")

PnlSettingView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.layoutBtns = transform:Find("Root/LayoutBtns").gameObject

    self.settingMap = {}
    for i = 1, self.layoutBtns.transform.childCount, 1 do
        local item = self.layoutBtns.transform:GetChild(i - 1)
        self.settingMap[item.name] = {}
        self.settingMap[item.name].item = item
        self.settingMap[item.name].btn = item.transform:Find("Button").gameObject
        self.settingMap[item.name].txtBtn = self.settingMap[item.name].btn.transform:Find("Text"):GetComponent("Text")
        self.settingMap[item.name].imgBtn = self.settingMap[item.name].btn.transform:GetComponent("Image")
    end
end

return PnlSettingView