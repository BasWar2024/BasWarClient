PnlHeroHutView = class("PnlHeroHutView")

PnlHeroHutView.ctor = function(self, transform)
    self.transform = transform
    -- self.btnBG = transform:Find("ViewBg").gameObject
    self.btnClose = transform:Find("Root/BtnClose").gameObject

    -- self.bgMsg = transform:Find("Root/BgMsg")
    -- self.txtName = self.bgMsg:Find("ImgNameBg/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    

    -- self.layoutLevel = self.bgMsg:Find("TxtLevel")
    -- self.txtLevel = self.bgMsg:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txtLevelAfter = self.levelArrow:Find("TxtLevelAfter"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.btnInfoClose = self.layoutInfo:Find("BtnInfoClose").gameObject
    self.heroScrollView = self.layoutInfo:Find("HeroScrollView")
    self.txtEmpty = self.layoutInfo:Find("TxtEmpty"):GetComponent(typeof(CS.TextYouYU))

    self.layoutHeroInfo = self.layoutInfo:Find("LayoutHeroInfo")
    self.bgName = self.layoutHeroInfo:Find("BgName")
    self.txtInfoId = self.bgName:Find("TxtInfoId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRecycle = self.bgName:Find("BtnRecycle").gameObject

    self.bgIcon = self.layoutHeroInfo:Find("BgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgIcon = self.bgIcon.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtInfoName = self.bgIcon.transform:Find("TxtInfoName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtInfoLevel = self.layoutHeroInfo:Find("TxtInfoLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtRealLevel = self.txtInfoLevel.transform:Find("TxtRealLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRealLevel = self.txtRealLevel.transform:Find("BtnRealLevel").gameObject
    self.bgExplain = self.btnRealLevel.transform:Find("BgExplain")
    self.btnCloseExplain = transform:Find("BtnCloseExplain").gameObject

    self.attrScrollView = self.layoutHeroInfo:Find("AttrScrollView")

    self.layoutSkills = self.layoutHeroInfo:Find("LayoutSkills")
    self.skillScrollView = self.layoutSkills:Find("SkillScrollView")

    self.layoutInfoBtns = self.layoutHeroInfo:Find("LayoutInfoBtns")
    self.btnUpgrade = self.layoutInfoBtns:Find("BtnUpgrade").gameObject
    self.btnApply = self.layoutInfoBtns:Find("BtnApply").gameObject

    self.layoutUpgrade = transform:Find("Root/LayoutUpgrade")
    self.txtUpgradeId = self.layoutUpgrade:Find("BgName/TxtUpgradeId"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attrUpgradeScrollView = self.layoutUpgrade:Find("AttrUpgradeScrollView")

    self.txtDesc = self.layoutUpgrade:Find("TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.commonUpgradeNewBox = CommonUpgradeNewBox.new(self.layoutUpgrade:Find("CommonUpgradeNewBox"))
    self.imgHero = self.layoutUpgrade:Find("ImgHero/ImgHero"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgHero1 = self.layoutUpgrade:Find("ImgHero/ImgHero1"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnUpgradeReturn = self.layoutUpgrade:Find("BtnUpgradeReturn").gameObject

    self.boxArrowUpgrade = self.layoutUpgrade:Find("BoxArrowUpgrade")

    self.txtUpgradeLevel = self.layoutUpgrade:Find("LayoutUpgradeInfo/TxtUpgradeLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUpgradeName = self.layoutUpgrade:Find("LayoutUpgradeInfo/TxtUpgradeName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.levelMax = self.boxArrowUpgrade:Find("LevelMax").gameObject
    self.txtMaxLevel = self.levelMax.transform:Find("TxtMaxLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.levelUpgrade = self.boxArrowUpgrade:Find("LevelUpgrade")

    self.txtCurLevel = self.levelUpgrade:Find("TxtCurLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNextLevel = self.levelUpgrade:Find("TxtNextLevel/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attentionUpgradeBox = self.layoutUpgrade:Find("AttentionUpgradeBox")
end

return PnlHeroHutView
