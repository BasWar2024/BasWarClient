
PnlStarMapPlotView = class("PnlStarMapPlotView")

PnlStarMapPlotView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.plotScrollView = transform:Find("Root/PlotScrollView").gameObject
    self.content = transform:Find("Root/PlotScrollView/Viewport/Content")

    self.btnLevelSort = transform:Find("Root/BgTitles/BtnLevelSort").gameObject
    self.imgLevelSort = self.btnLevelSort.transform:Find("ImgLevelSort")

    self.layoutScore = transform:Find("Root/LayoutScore")
    self.txtLandCount = self.layoutScore:Find("TxtLandCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.textScoreDesc = self.layoutScore:Find("TextScoreDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnDao = transform:Find("Root/LeftButton/BtnDao").gameObject
    self.btnMy = transform:Find("Root/LeftButton/BtnMy").gameObject

    self.toggle = {}

    for i = 1, 8, 1 do
        local name = "Root/BgMyPlotSel/Toggle" .. i
        local temp = transform:Find(name):GetComponent(UNITYENGINE_UI_TOGGLE)
        table.insert(self.toggle, temp)
    end
end

return PnlStarMapPlotView