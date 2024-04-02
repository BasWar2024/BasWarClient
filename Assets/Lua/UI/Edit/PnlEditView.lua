
PnlEditView = class("PnlEditView")

PnlEditView.ctor = function(self, transform)

    self.transform = transform

    self.imgTest = transform:Find("ImgTest"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.optionalTopBtnsBox = transform:Find("Root/OptionalTopBtnsBox")

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.btnBattle = self.layoutInfo:Find("BtnBattle").gameObject
    self.toggleBattleDetail = self.layoutInfo:Find("ToggleBattleDetail"):GetComponent(UNITYENGINE_UI_TOGGLE)

    self.layoutInfoBuilding = self.layoutInfo:Find("LayoutInfoBuilding")
    self.inputFieldExplorePath = self.layoutInfoBuilding:Find("InputFieldExplorePath"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnExplore = self.layoutInfoBuilding:Find("BtnExplore").gameObject
    self.inputFieldReadBuildingJson = self.layoutInfoBuilding:Find("InputFieldReadBuildingJson"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnReadBuilding = self.layoutInfoBuilding:Find("BtnReadBuilding").gameObject
    self.btnRemoveAllBuild = self.layoutInfoBuilding:Find("BtnRemoveAllBuild").gameObject

    self.layoutInfoBattle = self.layoutInfo:Find("LayoutInfoBattle")
    self.inputFieldBattleId = self.layoutInfoBattle:Find("InputFieldBattleId"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputFieldBattleVersion = self.layoutInfoBattle:Find("InputFieldBattleVersion"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnRecord = self.layoutInfoBattle:Find("BtnRecord").gameObject
    
    self.inputFieldBattleJson = self.layoutInfoBattle:Find("InputFieldBattleJson"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnBattleJson = self.layoutInfoBattle:Find("BtnBattleJson").gameObject
    self.inputBattleType = self.layoutInfoBattle:Find("InputBattleType"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnBattleServerJson = self.layoutInfoBattle:Find("BtnBattleServerJson").gameObject
    self.btnBattleJsonPath = self.layoutInfoBattle:Find("BtnBattleJsonPath").gameObject

    self.btnUnionSetBattleCount = self.layoutInfo:Find("BtnUnionSetBattleCount").gameObject
    self.inputUnionCount = self.layoutInfo:Find("InputUnionCount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    self.layoutBuild = transform:Find("Root/LayoutBuild")
    self.buildLeftBtnViewBgBtnsBox = self.layoutBuild:Find("BuildLeftBtnViewBgBtnsBox")

    self.buildScrollView = self.layoutBuild:Find("BuildScrollView")

    self.layoutBuilding = transform:Find("Root/LayoutBuilding")
    self.buildingScrollView = self.layoutBuilding:Find("BuildingScrollView")

    self.layoutHero = transform:Find("Root/LayoutHero")
    self.heroScrollView = self.layoutHero:Find("HeroScrollView")

    self.layoutWarship = transform:Find("Root/LayoutWarship")
    self.warshipScrollView = self.layoutWarship:Find("WarshipScrollView")

    self.layoutSoldier = transform:Find("Root/LayoutSoldier")
    self.soldierScrollView = self.layoutSoldier:Find("soldierScrollView")
    self.btnSetAllSoldier = self.layoutSoldier:Find("BtnSetAllSoldier").gameObject
    self.inputAllSoldierLevel = self.layoutSoldier:Find("InputAllSoldierLevel"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    self.layoutLandship = transform:Find("Root/LayoutLandship")
    self.landshipScrollView = self.layoutLandship:Find("LandshipScrollView")

    self.layoutArmy = transform:Find("Root/LayoutArmy")
    self.armyScrollView = self.layoutArmy:Find("ArmyScrollView")

    self.layoutBattle = transform:Find("Root/LayoutBattle")
    self.layoutBattleArmy = self.layoutBattle:Find("LayoutBattleArmy")

    self.layoutBattleBuilding = self.layoutBattle:Find("LayoutBattleBuilding")


    -- self.armyScrollView = self.layoutArmy:Find("ArmyScrollView")
    -- LayoutBattle
end

return PnlEditView