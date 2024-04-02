
PnlEditBattleView = class("PnlEditBattleView")

PnlEditBattleView.ctor = function(self, transform)
    self.transform = transform
    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.optionalTopBtnsBox = transform:Find("Root/OptionalTopBtnsBox")

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.inputFieldExplorePath = self.layoutInfo:Find("InputFieldExplorePath"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnExplore = self.layoutInfo:Find("BtnExplore").gameObject

    self.toggleShowSkillRange = self.layoutInfo:Find("ToggleShowSkillRange"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.toggleTowerAtkRange = self.layoutInfo:Find("ToggleTowerAtkRange"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.toggleShowHp = self.layoutInfo:Find("ToggleShowHp"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.toggleShowHpChange = self.layoutInfo:Find("ToggleShowHpChange"):GetComponent(UNITYENGINE_UI_TOGGLE)
    

    -- self.soldierScrollView = self.layoutInfo:Find("soldierScrollView")

    self.layoutSoldier = transform:Find("Root/LayoutSoldier")
    self.soldierScrollView = self.layoutSoldier:Find("soldierScrollView")

    self.layoutHero = transform:Find("Root/LayoutHero")
    self.heroScrollView = self.layoutHero:Find("heroScrollView")

    self.layoutBuilding = transform:Find("Root/LayoutBuilding")
    self.buildingScrollView = self.layoutBuilding:Find("BuildingScrollView")

    self.layoutSommonSoldier = transform:Find("Root/LayoutSommonSoldier")
    self.sommomSoldierScrollView = self.layoutSommonSoldier:Find("SommomSoldierScrollView")

end

return PnlEditBattleView