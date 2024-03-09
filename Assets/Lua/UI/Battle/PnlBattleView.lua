
PnlBattleView = class("PnlBattleView")

PnlBattleView.ctor = function(self, transform)

    self.transform = transform

    self.btnSolider1 = transform:Find("Solider/Solider1").gameObject
    self.btnSolider2 = transform:Find("Solider/Solider2").gameObject
    self.btnSolider3 = transform:Find("Solider/Solider3").gameObject
    self.btnSolider4 = transform:Find("Solider/Solider4").gameObject
    self.btnSolider5 = transform:Find("Solider/Solider5").gameObject
    self.btnSolider6 = transform:Find("Solider/Solider6").gameObject

    self.btnHero = transform:Find("Hero/Hero1").gameObject
    self.btnHeroSkill = transform:Find("Hero/HeroSkill").gameObject

    self.btnSkill1 = transform:Find("Skill/Skill1").gameObject
    self.btnSkill2 = transform:Find("Skill/Skill2").gameObject
    self.btnSkill3 = transform:Find("Skill/Skill3").gameObject
    self.btnSkill4 = transform:Find("Skill/Skill4").gameObject
    self.btnSkill5 = transform:Find("Skill/Skill5").gameObject

    self.btnRePlay = transform:Find("RePlay").gameObject
    self.btnServerRePlay = transform:Find("ServerRePlay").gameObject
    self.btnReturn2Main = transform:Find("Return2Main").gameObject

    self.skillPoint = transform:Find("SkillPoint").gameObject
    self.txtSkillPoint = self.skillPoint.transform:Find("SkillPointText"):GetComponent("Text")

    self.txtTime = transform:Find("Time/Time"):GetComponent("Text")
    self.txtWin = transform:Find("Result/Win").gameObject
    self.txtFail = transform:Find("Result/Fail").gameObject

    self.soliderBtnList = {}
    self.soliderBtnList[1] = self.btnSolider1
    self.soliderBtnList[2] = self.btnSolider2
    self.soliderBtnList[3] = self.btnSolider3
    self.soliderBtnList[4] = self.btnSolider4
    self.soliderBtnList[5] = self.btnSolider5
    self.soliderBtnList[6] = self.btnSolider6

    self.skillBtnList = {}
    self.skillBtnList[1] = self.btnHeroSkill
    self.skillBtnList[2] = self.btnSkill1
    self.skillBtnList[3] = self.btnSkill2
    self.skillBtnList[4] = self.btnSkill3
    self.skillBtnList[5] = self.btnSkill4
    self.skillBtnList[6] = self.btnSkill5

end

return PnlBattleView