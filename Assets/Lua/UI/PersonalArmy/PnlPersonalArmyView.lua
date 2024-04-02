
PnlPersonalArmyView = class("PnlPersonalArmyView")

PnlPersonalArmyView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject
    self.btnSort = transform:Find("Root/LayoutSelect/BtnSort").gameObject
    self.txtSort = transform:Find("Root/LayoutSelect/BtnSort/TxtSort"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtSelectName = transform:Find("Root/LayoutSelect/TxtSelectName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnReturnSelect = transform:Find("Root/LayoutSelect/BtnReturnSelect").gameObject
    
    self.layoutSoldierCount = transform:Find("Root/LayoutSoldierCount")
    self.txtSoldierCount = self.layoutSoldierCount:Find("TxtSoldierCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnFast = transform:Find("Root/LayoutBtns/BtnFast").gameObject
    self.btnFight = transform:Find("Root/LayoutBtns/BtnFight").gameObject

    self.layoutPersonalArmyItems = transform:Find("Root/LayoutPersonalArmyItems")

    self.layoutTeamSelectItems = transform:Find("Root/LayoutTeamSelectItems")

    self.selectScrollView = transform:Find("Root/LayoutSelect/SelectScrollView")

    self.layoutSelect = transform:Find("Root/LayoutSelect")

    self.btnFilterQuality = self.layoutSelect:Find("LayoutFilter/BtnFilterQuality").gameObject
    self.txtBtnFilterQuality = self.btnFilterQuality.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnFilterRace = self.layoutSelect:Find("LayoutFilter/BtnFilterRace").gameObject
    self.txtBtnFilterRace = self.btnFilterRace.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.filterScrollView = self.layoutSelect:Find("LayoutFilter/FilterScrollView")

    self.inputName = transform:Find("Root/InputName"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnChangeName = transform:Find("Root/BtnChangeName").gameObject

    self.btnFont = transform:Find("Root/BtnFont").gameObject
    self.btnNext = transform:Find("Root/BtnNext").gameObject
end

return PnlPersonalArmyView