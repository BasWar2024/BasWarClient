
PnlPersonalQuickSelectArmyView = class("PnlPersonalQuickSelectArmyView")

PnlPersonalQuickSelectArmyView.ctor = function(self, transform)

    self.transform = transform

    self.btnClose = transform:Find("BtnClose").gameObject
    self.root = transform:Find("Root")
    self.toggleAutoAddForces = transform:Find("Root/LayoutForces/ToggleAutoAddForces"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.btnAttack = transform:Find("Root/BtnAttack").gameObject

    self.layoutEnemyInfo = transform:Find("Root/LayoutEnemyInfo")
    self.txtName = transform:Find("Root/LayoutEnemyInfo/BgStage/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgStage = transform:Find("Root/LayoutEnemyInfo/BgStage/TxtName/ImgStage"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgBgStage = transform:Find("Root/LayoutEnemyInfo/BgStage/ImgBgStage"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtStage = transform:Find("Root/LayoutEnemyInfo/BgStage/TxtStage"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgHead = transform:Find("Root/LayoutEnemyInfo/LayoutHead/MaskHead/ImgHead"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.layoutArmys = transform:Find("Root/LayoutArmys")
    self.scrollView = self.layoutArmys:Find("ScrollView")

    self.layoutForces = transform:Find("Root/LayoutForces")
    self.textForces = transform:Find("Root/LayoutForces/TextForces"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDraft = transform:Find("Root/LayoutForces/BtnDraft").gameObject

    self.layoutUnionForces = transform:Find("Root/LayoutUnionForces")
    self.textUnionForces = transform:Find("Root/LayoutUnionForces/TextUnionForces"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAddUnionArmy = self.layoutUnionForces:Find("BtnAddUnionArmy").gameObject
    
    self.layoutEmp = transform:Find("Root/LayoutArmys/LayoutEmp")
    self.btnGo = self.layoutEmp:Find("BtnGo").gameObject

    self.toggleUnionMode = transform:Find("Root/ToggleUnionMode"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.toggleUnionModeImgSelect = self.toggleUnionMode.transform:Find("Background/ImgSelect")

    
    self.layoutEdit = transform:Find("Root/Root")
    self.inputLoopAtkTimes = self.layoutEdit:Find("InputLoopAtkTimes"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
end

return PnlPersonalQuickSelectArmyView