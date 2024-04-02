PnlUnionWarReportView = class("PnlUnionWarReportView")

PnlUnionWarReportView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnGuild = transform:Find("BtnGuild").gameObject
    self.btnMy = transform:Find("BtnMy").gameObject
    self.reportBtnIcon = {}
    self.reportBtnIcon[1] = self.btnGuild.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.reportBtnIcon[2] = self.btnMy.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.reportBtnText = {}
    self.reportBtnText[1] = self.btnGuild.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.reportBtnText[2] = self.btnMy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.contentGuild = transform:Find("ScrollViewGuild/Viewport/Content")
    self.contentMy = transform:Find("ScrollViewMy/Viewport/Content")

    self.scrollViewGuild = transform:Find("ScrollViewGuild").gameObject
    self.scrollViewMy = transform:Find("ScrollViewMy").gameObject

    self.topButtonView = transform:Find("TopButtonView").gameObject
end

return PnlUnionWarReportView
