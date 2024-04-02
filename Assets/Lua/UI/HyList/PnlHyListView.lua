PnlHyListView = class("PnlHyListView")

PnlHyListView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRule = transform:Find("ViewBg/Bg/TxtTitle/BtnRule").gameObject
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtRank = transform:Find("ViewList/BoxHyList/TxtRank"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtName = transform:Find("ViewList/BoxHyList/BgHead/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHy = transform:Find("ViewList/BoxHyList/TxtHy"):GetComponent(UNITYENGINE_UI_TEXT)

    self.iconHead = transform:Find("ViewList/BoxHyList/BgHead/Mask/IconHead"):GetComponent(UNITYENGINE_UI_IMAGE)


    self.viewList = transform:Find("ViewList")

    self.contentI = transform:Find("ViewList/ScrollViewI/Viewport/Content")
    self.viewListI = transform:Find("ViewList/ScrollViewI").gameObject

    self.contentG = transform:Find("ViewList/ScrollViewG/Viewport/Content")
    self.viewListG = transform:Find("ViewList/ScrollViewG").gameObject

    self.boxHyList = transform:Find("ViewList/BoxHyList").gameObject

    self.txtTips = transform:Find("ViewList/TxtTips").gameObject
    self.titelName = transform:Find("ViewList/BgTitel/TitelName"):GetComponent(UNITYENGINE_UI_TEXT)

    --------------------------------------------------------------------

    self.leftBtnViewBgBtnsBox = transform:Find("Root/LeftBtnViewBgBtnsBox")
    self.layoutFirstPlot = transform:Find("Root/LayoutFirstPlot")
    self.hyListFirstPlotBox = transform:Find("Root/LayoutFirstPlot/HyListFirstPlotBox")


    self.layoutOpenServerUnionRank = transform:Find("Root/LayoutOpenServerUnionRank")
    self.openServerUnionRankBox = self.layoutOpenServerUnionRank:Find("OpenServerUnionRankBox")

    self.layoutOpenServerPVPRank = transform:Find("Root/LayoutOpenServerPVPRank")
    self.openServerPVPRankBox = self.layoutOpenServerPVPRank:Find("OpenServerPVPRankBox")
end

return PnlHyListView
