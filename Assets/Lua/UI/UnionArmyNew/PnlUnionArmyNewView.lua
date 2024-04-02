
PnlUnionArmyNewView = class("PnlUnionArmyNewView")

PnlUnionArmyNewView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtSoldierCount = transform:Find("Root/LayoutInfo/TxtSoldierCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAddSoldier = transform:Find("Root/LayoutInfo/BtnAddSoldier").gameObject
    self.txtArmyCount = transform:Find("Root/LayoutInfo/TxtArmyCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnFast = transform:Find("Root/BtnFast").gameObject
    self.btnAttack = transform:Find("Root/BtnAttack").gameObject


    self.scrollView = transform:Find("Root/ScrollView").gameObject

    
end

return PnlUnionArmyNewView