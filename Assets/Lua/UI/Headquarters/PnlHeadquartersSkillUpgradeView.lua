
PnlHeadquartersSkillUpgradeView = class("PnlHeadquartersSkillUpgradeView")

PnlHeadquartersSkillUpgradeView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtSkillType = transform:Find("View/TxtSkillType"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMaxLevel = transform:Find("View/BoxArrowUpgrade/LevelMax/TxtMaxLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTitel = transform:Find("View/BoxArrowUpgrade/LevelUpgrade/TxtTitel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCurLevel = transform:Find("View/BoxArrowUpgrade/LevelUpgrade/TxtCurLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNextLevel = transform:Find("View/BoxArrowUpgrade/LevelUpgrade/TxtNextLevel/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgAttr = transform:Find("View/AttrUpgradeScrollView/Viewport/Content/CommonAttrItem/ImgAttr"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("View/AttrUpgradeScrollView/Viewport/Content/CommonAttrItem/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttr = transform:Find("View/AttrUpgradeScrollView/Viewport/Content/CommonAttrItem/TxtAttr"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttrAdd = transform:Find("View/AttrUpgradeScrollView/Viewport/Content/CommonAttrItem/TxtAttrAdd"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDesc = transform:Find("View/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconHy = transform:Find("View/ViewUpgrade/LayoutBtns/FinishNow/LayoutCost/costHydroxy/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtHy = transform:Find("View/ViewUpgrade/LayoutBtns/FinishNow/LayoutCost/costHydroxy/Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnFinish = transform:Find("View/ViewUpgrade/LayoutBtns/FinishNow/BtnFinish").gameObject
    self.upgradeCostList = {
        [constant.RES_STARCOIN] = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutCost/costStarCoin"),
        [constant.RES_ICE] = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutCost/costIce"),
        [constant.RES_TITANIUM] = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutCost/costTi"),
        [constant.RES_GAS] = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutCost/costGas"),
        [constant.RES_CARBOXYL] = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutCost/costHydroxy"),
        [constant.RES_TESSERACT] = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutCost/costTes"),
    }
    self.upgrade = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade").gameObject
    self.btnUpgrade = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/BtnUpgrade").gameObject
    self.txtSlider = transform:Find("View/ViewUpgrade/LayoutBtns/Upgrade/LayoutSlider/TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnChange = transform:Find("View/BtnChange").gameObject
    self.txtUpgrading = transform:Find("View/TxtUpgrading"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUpgradeTime = transform:Find("View/TxtUpgrading/TxtUpgradeTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.bgSkill = transform:Find("View/BgSkill"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconSkill = transform:Find("View/BgSkill/Mask/IconSkill"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.levelMax = transform:Find("View/BoxArrowUpgrade/LevelMax").gameObject
    self.levelUpgrade = transform:Find("View/BoxArrowUpgrade/LevelUpgrade").gameObject
    self.layoutBtns = transform:Find("View/ViewUpgrade").gameObject
    self.viewSkillShard = transform:Find("View/ViewUpgrade/ViewSkillShard")
end

return PnlHeadquartersSkillUpgradeView