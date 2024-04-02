
PnlInstituteView = class("PnlInstituteView")

PnlInstituteView.ctor = function(self, transform)
    self.transform = transform
    self.btnClose = transform:Find("Root/BtnClose").gameObject
    self.leftBtnViewBgBtnsBox = LeftBtnViewBgBtnsBox.new(transform:Find("Root/LeftBtnViewBgBtnsBox"))
    self.attrScrollView = transform:Find("Root/LayoutInfo/AttrScrollView")

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.txtName = self.layoutInfo:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtFullLevel = self.layoutInfo:Find("TxtFullLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attentionUpgradeBox = self.layoutInfo:Find("AttentionUpgradeBox")

    self.layoutLevel = transform:Find("Root/Level/LayoutLevel")

    self.layoutHead = transform:Find("Root/Level/LayoutHead")
    self.txtLevelName = self.layoutHead:Find("TxtLevelName"):GetComponent(typeof(CS.TextYouYU))
    self.levelCommonItemItemD1 = self.layoutHead:Find("CommonHeroItem")

    self.imgLevelRace = self.layoutHead:Find("ImgLevelRace"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnLevelInfo = self.layoutHead:Find("BtnLevelInfo").gameObject
    
    self.layoutLevelUp = self.layoutLevel:Find("LayoutLevelUp")
    self.txtLevel = self.layoutLevelUp:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.levelArrow = self.layoutLevelUp:Find("LevelArrow")
    self.txtLevelAfter = self.layoutLevelUp:Find("TxtLevelAfter"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLevelMax = self.layoutLevel:Find("TxtLevelMax"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtQualityName = transform:Find("Root/Quality/TxtQualityName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.qualityCommonItemItemD2 = transform:Find("Root/Quality/CommonItemItemD2")
    self.layoutQuality = transform:Find("Root/Quality/LayoutQuality")
    self.txtNextQuality = self.layoutQuality:Find("TxtNextQuality"):GetComponent(UNITYENGINE_UI_TEXT)

    self.typeViewList = {}
    self.typeViewList[ggclass.PnlInstitute.TYPE_LEVEL] = transform:Find("Root/Level").gameObject
    self.typeViewList[ggclass.PnlInstitute.TYPE_QUALITY] = transform:Find("Root/Quality").gameObject

    self.levelUpScrollView = transform:Find("Root/Level/ScrollView")
    self.qualityScrollView = transform:Find("Root/Quality/ScrollView")

    self.levelCommonUpgradeBox = CommonUpgradeNewBox.new(transform:Find("Root/Level/CommonUpgradeNewBox").gameObject)
    self.qualityCommonUpgradeBox = CommonUpgradeNewBox.new(transform:Find("Root/Quality/CommonUpgradeNewBox").gameObject)

    self.commonResBox2 = transform:Find("CommonResBox2")
end

return PnlInstituteView