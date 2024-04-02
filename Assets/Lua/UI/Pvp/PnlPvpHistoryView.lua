
PnlPvpHistoryView = class("PnlPvpHistoryView")

PnlPvpHistoryView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.historyScrollView = transform:Find("Root/HistoryScrollView").gameObject

    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject
end

return PnlPvpHistoryView