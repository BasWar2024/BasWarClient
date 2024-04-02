
PnlConstructionView = class("PnlConstructionView")

PnlConstructionView.ctor = function(self, transform)

    self.transform = transform

    self.bgBlack = transform:Find("ViewBg/BgBlack").gameObject

    self.txtTitle = transform:Find("ViewBg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUpgradeLevelBefore = transform:Find("View/LayoutLevelChange/TxtUpgradeLevelBefore"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUpgradeLevelAfter = transform:Find("View/LayoutLevelChange/TxtUpgradeLevelAfter"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtConstruction = transform:Find("View/Slider/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.slider = transform:Find("View/Slider/Slider"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.content = transform:Find("View/ScrollView/Viewport/Content")

end

return PnlConstructionView