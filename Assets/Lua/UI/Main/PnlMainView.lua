
PnlMainView = class("PnlMainView")

PnlMainView.ctor = function(self, transform)

    self.transform = transform
    
    self.btnActivity = transform:Find("BtnActivity").gameObject
    self.btnAchievement = transform:Find("BtnAchievement").gameObject
    self.btnRankingList = transform:Find("BtnRankingList").gameObject
    self.btnChat = transform:Find("BtnChat").gameObject
    self.btnSetting = transform:Find("BtnSetting").gameObject
    self.btnBuild = transform:Find("BtnBuild").gameObject
    self.btnShop = transform:Find("BtnShop").gameObject

    self.btnMap = transform:Find("BtnMap").gameObject
    self.btnMatch = transform:Find("BtnMatch").gameObject
    self.btnReplenish = transform:Find("BtnReplenish").gameObject
    self.bulidShop = transform:Find("BuildShop").gameObject
    self.showBar = transform:Find("BuildShop/Scroll/Viewport/ShowBar")
    self.btnBuildShopClose = transform:Find("BuildShop/Bg/BtnBuildShopClose").gameObject
    self.btnEconomic = transform:Find("BuildShop/Scroll/BtnEconomic").gameObject
    self.btnDevelopment = transform:Find("BuildShop/Scroll/BtnDevelopment").gameObject
    self.btnDefense = transform:Find("BuildShop/Scroll/BtnDefense").gameObject
    self.listRes = transform:Find("ListRes")
    self.msgBuilding = transform:Find("MsgBuilding")

    self.bubbleBoatRes = transform:Find("ListRes/BubbleBoatRes")
end

return PnlMainView