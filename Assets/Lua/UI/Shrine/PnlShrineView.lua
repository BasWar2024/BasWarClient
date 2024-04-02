
PnlShrineView = class("PnlShrineView")

PnlShrineView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtAddAtk = transform:Find("Root/BgInfo/TxtAddAtkTitle/TxtAddAtk"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAddBlood = transform:Find("Root/BgInfo/TxtAddBloodTitle/TxtAddBlood"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtRatio = transform:Find("Root/BgInfo/TxtRatioTitle/TxtRatio"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnDesc = transform:Find("Root/BgInfo/BtnDesc").gameObject
    self.btnDescBuilding = transform:Find("Root/BgInfo/BtnDescBuilding").gameObject

    self.boxDesc = transform:Find("BoxDesc")

    self.boxDescBuilding = transform:Find("BoxDescBuilding")
    self.buildingBoundScrollView = self.boxDescBuilding:Find("BuildingBoundScrollView")

    self.scrollView = transform:Find("Root/ScrollView")

    self.layoutSelect = transform:Find("LayoutSelect")
    self.selectScrollView = self.layoutSelect:Find("SelectScrollView")
    self.btnReturnSelect = self.layoutSelect:Find("BtnReturnSelect").gameObject
end

return PnlShrineView