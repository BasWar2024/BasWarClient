
PnlUnionWarReportInfoView = class("PnlUnionWarReportInfoView")

PnlUnionWarReportInfoView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.scrollViewMy = transform:Find("ScrollViewMy").gameObject
    self.contentMy = transform:Find("ScrollViewMy/Viewport/Content")

end

return PnlUnionWarReportInfoView