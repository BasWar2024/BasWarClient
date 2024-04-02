
PnlBattleView = class("PnlBattleView")

PnlBattleView.ctor = function(self, transform)
    self.transform = transform

    -- self.battleHeroItem = transform:Find("Hero/BattleHeroItem").gameObject
    -- self.btnHeroSkill = transform:Find("Hero/BattleHeroSkillItem").gameObject

    self.btnRePlay = transform:Find("RePlay").gameObject
    self.btnServerRePlay = transform:Find("ServerRePlay").gameObject

    self.btnReturn2Main = transform:Find("Return2Main").gameObject
    self.btnEndBattle = transform:Find("BtnEndBattle").gameObject
    self.btnEndReport = transform:Find("BtnEndReport").gameObject

    self.skillPoint = transform:Find("SkillPoint").gameObject
    self.txtSkillPoint = self.skillPoint.transform:Find("SkillPointText"):GetComponent(UNITYENGINE_UI_TEXT)

    self.playerName = transform:Find("PlayerName").gameObject

    self.time = transform:Find("Time").gameObject
    self.txtTime = self.time.transform:Find("Time"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTimeTitle = self.time.transform:Find("TxtTimeTitle"):GetComponent(UNITYENGINE_UI_TEXT_YPU_YU)

    self.txtName = transform:Find("PlayerName/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBadge = transform:Find("PlayerName/TxtBadge"):GetComponent(UNITYENGINE_UI_TEXT)

    self.rePlayTimeRoot = transform:Find("RePlayTimeRoot").gameObject
    self.txtRePlayTime = self.rePlayTimeRoot.transform:Find("Time"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtReplayName = self.rePlayTimeRoot.transform:Find("Name"):GetComponent(UNITYENGINE_UI_TEXT)

    self.rePlayBtnRoot = transform:Find("RePlayBtnRoot").gameObject
    self.btnPause = self.rePlayBtnRoot.transform:Find("PauseBtn").gameObject
    self.btnAddSpeed = self.rePlayBtnRoot.transform:Find("AddSpeedBtn").gameObject
    self.imgPause = self.btnPause.transform:Find("ImgPause").gameObject
    self.imgPlay = self.btnPause.transform:Find("ImgPlay").gameObject
    self.txtSpeed = self.btnAddSpeed.transform:Find("TxtSpeed"):GetComponent(UNITYENGINE_UI_TEXT)

    self.bgTop = transform:Find("BgTop").gameObject
    self.bgBottom = transform:Find("BgBottom").gameObject

    -- self.soliderBtnList = {}
    -- for i = 1, 5 do
    --     self.soliderBtnList[i] = transform:Find("Soliders/Solider" .. i).gameObject
    -- end

    self.layoutHeros = transform:Find("Heros")
    self.layoutHeroSkills = transform:Find("HeroSkills")
    self.layoutSkill = transform:Find("Skill")

    self.heroBtnList = {}
    for i = 1, 5 do
        self.heroBtnList[i] = transform:Find("Heros/Hero" .. i).gameObject
    end

    self.heroSkillBtnList = {}
    for i = 1, 5 do
        self.heroSkillBtnList[i] = transform:Find("HeroSkills/HeroSkill" .. i).gameObject
    end

    self.skillBtnList = {}
    for i = 1, 4, 1 do
        self.skillBtnList[i] = transform:Find("Skill/Skill" .. i).gameObject
    end

    self.heroSkillMaskList = {}
    for i = 1, 5, 1 do
        self.heroSkillMaskList[i] = self.heroSkillBtnList[i].transform:Find("CdMask").gameObject
        self.heroSkillMaskList[i]:SetActive(false) 
    end

    self.heroSkillCdTextList = {}
    for i = 1, 5, 1 do
        self.heroSkillCdTextList[i] = self.heroSkillMaskList[i].transform:Find("Cd"):GetComponent(UNITYENGINE_UI_TEXT)
        self.heroSkillCdTextList[i].gameObject:SetActive(false) 
    end

    -- self.herosBG = transform:Find("HerosBG")
    -- self.herosBG.gameObject:SetActive(false)
    
    self.skillBG = transform:Find("SkillBG")
    self.skillBG.gameObject:SetActive(false) 

    self.defCardItem = transform:Find("DefCardItem")
    self.atkCardItem = transform:Find("AtkCardItem")

    self.layoutBattleDetail = transform:Find("LayoutBattleDetail")
    self.btnAddMaxHp = self.layoutBattleDetail:Find("BtnAddMaxHp").gameObject
    self.btnSkillPoint = self.layoutBattleDetail:Find("BtnSkillPoint").gameObject
    self.btnBattleMessage = self.layoutBattleDetail:Find("BtnBattleMessage").gameObject
    self.btnRefreshBattleMessage = self.layoutBattleDetail:Find("BtnRefreshBattleMessage").gameObject
    self.btnEditBattle = self.layoutBattleDetail:Find("BtnEditBattle").gameObject
    self.btnEditSignalSkill = self.layoutBattleDetail:Find("BtnEditSignalSkill").gameObject
    self.imgSelectSignalSkill = self.btnEditSignalSkill.transform:Find("ImgSelect")

    self.boxSkillTips = transform:Find("BoxSkillTips").gameObject
    self.txtSkillDec = transform:Find("BoxSkillTips/Bg/Image/TxtSkillDec"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtSkillName = transform:Find("BoxSkillTips/Bg/Image/TxtSkillName"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlBattleView