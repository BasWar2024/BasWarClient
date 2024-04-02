PnlWarShipView = class("PnlWarShipView")

PnlWarShipView.ctor = function(self, transform)

    self.transform = transform
    self.upGradeView = transform:Find("BgWarShip").gameObject

    self.txtTitle = transform:Find("BgWarShip/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)

    self.LeftBtnViewBgBtnsBox = LeftBtnViewBgBtnsBox.new(transform:Find("BgWarShip/LeftBtnViewBgBtnsBox"))
    -- self.commonResBox = CommonResBox.new(transform:Find("CommonResBox"))

    self.viewUpgrade = transform:Find("BgWarShip/ViewUpgrade").gameObject
    self.viewInformation = transform:Find("BgWarShip/ViewInformation").gameObject
    self.txtLevel = transform:Find("BgWarShip/BgMsg/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtName = transform:Find("BgWarShip/BgMsg/ImgNameBg/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtId = transform:Find("BgWarShip/BgMsg/ImgNameBg/TxtId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRecycle = transform:Find("ChooseView/BtnRecycle").gameObject

    -- self.upgradeBox = self.viewSkill:Find("UpgradeBox")

    self.btnClose = transform:Find("BgWarShip/BtnClose").gameObject
    self.btnReturn = transform:Find("BgWarShip/BtnReturn").gameObject

    self.commonUpgradeNewBox = ggclass.CommonUpgradeNewBox.new(transform:Find(
        "BgWarShip/ViewUpgrade/CommonUpgradeNewBox"))

    self.attentionUpgradeBox = transform:Find("BgWarShip/ViewUpgrade/AttentionUpgradeBox")

    self.txtInformation = transform:Find("BgWarShip/ViewInformation/TxtInformation"):GetComponent(UNITYENGINE_UI_TEXT)

    self.iconWarShip = transform:Find("BgWarShip/IconWarShip/IconWarShip"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconWarShip1 = transform:Find("BgWarShip/IconWarShip/IconWarShip1"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.attrScrollView = transform:Find("BgWarShip/AttrScrollView")
    self.scrollbarDurability = transform:Find("BgWarShip/ScrollbarDurability"):GetComponent(UNITYENGINE_UI_SCROLLBAR)
    self.txtDurability = transform:Find("BgWarShip/ScrollbarDurability/TxtDurability"):GetComponent(UNITYENGINE_UI_TEXT)
    self.bgWarShip = transform:Find("BgWarShip").gameObject
    self.txtForge = transform:Find("BgWarShip/TxtForge"):GetComponent(UNITYENGINE_UI_TEXT)

    self.boxArrowUpgrade = transform:Find("BgWarShip/BoxArrowUpgrade").gameObject
    self.levelMax = transform:Find("BgWarShip/BoxArrowUpgrade/LevelMax").gameObject
    self.levelUpgrade = transform:Find("BgWarShip/BoxArrowUpgrade/LevelUpgrade").gameObject

    self.txtCurLevle = transform:Find("BgWarShip/BoxArrowUpgrade/LevelUpgrade/TxtCurLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNextLevel = transform:Find("BgWarShip/BoxArrowUpgrade/LevelUpgrade/TxtNextLevel/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMaxLevel = transform:Find("BgWarShip/BoxArrowUpgrade/LevelMax/TxtMaxLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.viewForge = transform:Find("BgWarShip/ViewForge")

    ---------------------------------------------------------------------------------------------------------
    self.chooseView = transform:Find("ChooseView").gameObject
    self.warshipScrollView = transform:Find("ChooseView/ScrollView")

    self.iconSelectedWarship = transform:Find("ChooseView/IcomBg/icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtlevelSelectedWarship = transform:Find("ChooseView/BgMsg/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOriLevelSelectedWarship = transform:Find("ChooseView/BgMsg/TxtOriLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNameSelectedWarship = transform:Find("ChooseView/BgMsg/ImgNameBg/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHashSelectedWarship = transform:Find("ChooseView/BgMsg/ImgNameBg/TxtHash"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnOriLevelTips = transform:Find("ChooseView/BgMsg/TxtOriLevel/BtnOriLevelTips").gameObject

    self.chooseViewAttrScrollView = transform:Find("ChooseView/ChooseAttrScrollView")

    self.viewSkill = transform:Find("ChooseView/ViewSkill").transform
    self.btnSkill1 = self.viewSkill:Find("BtnSkill1").gameObject
    self.btnSkill2 = self.viewSkill:Find("BtnSkill2").gameObject
    self.btnSkill3 = self.viewSkill:Find("BtnSkill3").gameObject
    self.btnSkill4 = self.viewSkill:Find("BtnSkill4").gameObject
    self.btnSkill5 = self.viewSkill:Find("BtnSkill5").gameObject

    self.btnUpgrade = transform:Find("ChooseView/BtnUpgrade").gameObject
    self.btnApply = transform:Find("ChooseView/BtnApply").gameObject

    self.btnCloseChoose = transform:Find("ChooseView/ViewBg/Bg/BtnClose").gameObject

    self.btnOriLevelTips = transform:Find("ChooseView/BgMsg/TxtOriLevel/BtnOriLevelTips").gameObject

    self.bgExplain = transform:Find("ChooseView/BgMsg/TxtOriLevel/BtnOriLevelTips/BgExplain").gameObject

end

return PnlWarShipView
