
PnlBuildInfoView = class("PnlBuildInfoView")

PnlBuildInfoView.ctor = function(self, transform)
    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtAlert = transform:Find("Root/TxtAlert")
    self.imgBuild = transform:Find("Root/bgBuild/ImgBuild"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.scRectAttr = transform:Find("Root/scRectAttr"):GetComponent("ScrollRect")
    self.gridLayoutGroupAttrContent = self.scRectAttr.transform:Find("Viewport/Content"):GetComponent("GridLayoutGroup")
    
    self.LayoutInfo = transform:Find("Root/LayoutInfo").gameObject
    self.txtInfoName = self.LayoutInfo.transform:Find("BgInfoName/TxtInfoName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtInfoLevel = self.LayoutInfo.transform:Find("BgInfoName/TxtInfoLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtDesc = transform:Find("Root/LayoutInfo/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAlertUnlock = transform:Find("Root/LayoutInfo/TxtAlertUnlock"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutUpgrade = transform:Find("Root/LayoutUpgrade")
    self.LayoutLevelChange = self.layoutUpgrade:Find("LayoutLevelChange")
    self.txtUpgradeLevelBefore = self.LayoutLevelChange:Find("TxtUpgradeLevelBefore"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUpgradeLevelAfter = self.LayoutLevelChange:Find("TxtUpgradeLevelAfter"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLevelMax = transform:Find("Root/LayoutUpgrade/TxtLevelMax"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUpgradeName = transform:Find("Root/LayoutUpgrade/TxtUpgradeName"):GetComponent(UNITYENGINE_UI_TEXT)

    -- self.layoutPledge = self.layoutUpgrade.transform:Find("LayoutPledge").gameObject

    self.LayoutUnlockTechnology = self.layoutUpgrade.transform:Find("LayoutUnlockTechnology")
    self.LayoutTechnologys = self.LayoutUnlockTechnology:Find("LayoutTechnologys")
    
    self.commonUpgradeNewBox = transform:Find("Root/LayoutUpgrade/CommonUpgradeNewBox")

    self.layoutPrepare = self.layoutUpgrade.transform:Find("LayoutPrepare")
    self.prepareScrollView = self.layoutPrepare.transform:Find("PrepareScrollView")

    self.layoutUpgradeAlert = self.layoutPrepare.transform:Find("LayoutUpgradeAlert")
    self.txtUpgradeAlert = self.layoutUpgradeAlert:Find("TxtUpgradeAlert"):GetComponent(UNITYENGINE_UI_TEXT)

    self.techDescBox = transform:Find("TechDescBox")
    self.bgTechDesc = self.techDescBox:Find("Bg")
    self.txtTechName = self.techDescBox:Find("Bg/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTechDesc = self.techDescBox:Find("Bg/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlBuildInfoView