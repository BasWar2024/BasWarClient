
PnlBattleReportView = class("PnlBattleReportView")

PnlBattleReportView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnOpenFilter = transform:Find("BtnOpenFilter").gameObject
    self.txtFilter = transform:Find("BtnOpenFilter/TxtFilter"):GetComponent(UNITYENGINE_UI_TEXT)
    self.topButtonView = transform:Find("TopButtonView").gameObject

    self.leftBtnViewBgBtnsBox = transform:Find("LeftBtnViewBgBtnsBox").gameObject

    self.content = transform:Find("ScrollView/Viewport/Content").gameObject
end

return PnlBattleReportView