PnlAlertResetSkillView = class("PnlAlertResetSkillView")

PnlAlertResetSkillView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTips = transform:Find("Root/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTips1 = transform:Find("Root/TxtTips1"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtTipsRed = transform:Find("Root/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnNo = transform:Find("Root/LayoutBtns/BtnNo").gameObject
    self.txtBtnNo = transform:Find("Root/LayoutBtns/BtnNo/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnYes = transform:Find("Root/LayoutBtns/BtnYes").gameObject
    self.txtBtnYes = transform:Find("Root/LayoutBtns/BtnYes/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtCound = transform:Find("Root/Res/BoxSkillShard/TxtCound"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconBg = transform:Find("Root/Res/BoxSkillShard"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconSkillBg = transform:Find("Root/Res/BoxSkillShard/BgSkillChip"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconSkill = transform:Find("Root/Res/BoxSkillShard/BgSkillChip/Mask/IconSkillChip"):GetComponent(
        UNITYENGINE_UI_IMAGE)

    self.boxResList = {}
    for i = 1, 7, 1 do
        local boxName = "Root/Res/BoxRes" .. i
        local go = transform:Find(boxName).gameObject
        table.insert(self.boxResList, go)
    end

    self.res = transform:Find("Root/Res").gameObject
    self.skill = transform:Find("Root/Skill").gameObject
    self.content = transform:Find("Root/Skill/ScrollView/Viewport/Content")

    self.boxRes = transform:Find("Root/Skill/ScrollView/Viewport/Content/BoxRes")
    self.txtCoundRes = transform:Find("Root/Skill/ScrollView/Viewport/Content/BoxRes/TxtCound"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlAlertResetSkillView
