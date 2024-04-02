
PnlChooseSkillView = class("PnlChooseSkillView")

PnlChooseSkillView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.content = transform:Find("View/ScrollView/Viewport/Content")

    self.btnQuality = transform:Find("View/BtnQuality").gameObject
    self.btnRace = transform:Find("View/BtnRace").gameObject

    self.qualityBg = transform:Find("View/BgQuality").gameObject
    self.raceBg = transform:Find("View/BgRace").gameObject

    self.txtBtnQuality = transform:Find("View/BtnQuality/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBtnRace = transform:Find("View/BtnRace/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.viewSolider = transform:Find("View/ViewSolider")

    self.bgQuality = transform:Find("ViewBg/Bg/BgQuality"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.viewSkillData = transform:Find("View/ViewSkillData").gameObject
    self.iconRace = self.viewSkillData.transform:Find("IconRace"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.skillBg = self.viewSkillData.transform:Find("BoxSkill/SkillBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconSelSkill = self.skillBg.transform:Find("Mask/IconSelSkill"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtSkillLevel = self.viewSkillData.transform:Find("TxtSkillLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtSkillName = self.viewSkillData.transform:Find("TxtSkillName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDec = self.viewSkillData.transform:Find("TxtDec"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnStudy = self.viewSkillData.transform:Find("BtnStudy").gameObject

end

return PnlChooseSkillView