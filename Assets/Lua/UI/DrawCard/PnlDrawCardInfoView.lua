
PnlDrawCardInfoView = class("PnlDrawCardInfoView")

PnlDrawCardInfoView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Bg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("Bg/Bg/BtnClose").gameObject
    self.btnNotice = transform:Find("Bg/Bg/BoxLefrButton/BtnNotice").gameObject
    self.btnRule = transform:Find("Bg/Bg/BoxLefrButton/BtnRule").gameObject
    self.btnRecord = transform:Find("Bg/Bg/BoxLefrButton/BtnRecord").gameObject

    self.viewNotice = transform:Find("Bg/Bg/ViewNotice").gameObject
    self.viewRule = transform:Find("Bg/Bg/ViewRule").gameObject
    self.vIewRecord = transform:Find("Bg/Bg/VIewRecord").gameObject

    self.content = transform:Find("Bg/Bg/VIewRecord/ScrollView/Viewport/Content")
end

return PnlDrawCardInfoView