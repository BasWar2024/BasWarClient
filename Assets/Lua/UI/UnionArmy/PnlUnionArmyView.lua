
PnlUnionArmyView = class("PnlUnionArmyView")

PnlUnionArmyView.ctor = function(self, transform)

    self.transform = transform
    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    -- self.btnUnionLandPoint = transform:Find("Root/LayoutLandPos/BtnUnionLandPoint").gameObject

    self.txtCount = transform:Find("Root/BgCount/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAtk = transform:Find("Root/BtnAtk").gameObject
    self.btnAdd = transform:Find("Root/BtnAdd").gameObject
    self.btnQuickAdd = transform:Find("Root/BtnQuickAdd").gameObject
    self.txtContribution = transform:Find("Root/BgContribution/TxtContribution"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnLandPointList = {}
    for i = 1, 4, 1 do
        local item = {}
        item.transform = transform:Find("Root/LayoutLandPos/UnionLandPoint" .. i)
        item.gameObject = item.transform.gameObject
        item.layoutSelect = item.transform:Find("LayoutSelect")
        item.layoutUnselect = item.transform:Find("LayoutUnselect")
        self.btnLandPointList[i] = item --transform:Find("Root/LayoutLandPos/UnionLandPoint" .. i).gameObject
    end

    self.armyScrollView = transform:Find("Root/ArmyScrollView").gameObject
end

return PnlUnionArmyView
