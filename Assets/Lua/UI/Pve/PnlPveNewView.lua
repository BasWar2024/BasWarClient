
PnlPveNewView = class("PnlPveNewView")

PnlPveNewView.ctor = function(self, transform)

    self.transform = transform

    self.layoutBg = transform:Find("LayoutBg")

    self.planetScrollView = transform:Find("Root/PlanetScrollView")
    self.planetContent = transform:Find("Root/PlanetScrollView/Viewport/Content")
    self.layoutLines = transform:Find("Root/PlanetScrollView/Viewport/Content/LayoutLines")
    self.layoutPlanets = transform:Find("Root/PlanetScrollView/Viewport/Content/LayoutPlanets")

    self.txtTitle = transform:Find("Root/LayoutTop/BgTitle/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("Root/LayoutTop/BtnClose").gameObject
    self.btnRank = transform:Find("Root/LayoutRightBtns/BtnRank").gameObject
    self.btnRule = transform:Find("Root/LayoutRightBtns/BtnRule").gameObject
    self.btnInfo = transform:Find("Root/LayoutRightBtns/BtnInfo").gameObject

    
    self.txtProgress = transform:Find("Root/LayoutMessage/TxtProgress"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnScout = transform:Find("Root/LayoutMessage/BtnScout").gameObject
    self.btnFight = transform:Find("Root/LayoutMessage/BtnFight").gameObject

    self.commonResBox = transform:Find("Root/LayoutTop/CommonResBox")
    
    self.layoutDaily = transform:Find("Root/LayoutDaily")
    self.bgDalyLess = self.layoutDaily:Find("BgDalyLess").gameObject
    self.bgDailyReward = self.layoutDaily:Find("BgDailyReward")
    
    self.txtDailyLess = transform:Find("Root/LayoutDaily/BgDalyLess/TxtDailyLess"):GetComponent(UNITYENGINE_UI_TEXT)
    self.dailyAllRewardScrollView = self.layoutDaily:Find("BgDailyReward/DailyAllRewardScrollView")

    self.layoutMessage = transform:Find("Root/LayoutMessage")
    self.firstPveSubRewardBox = self.layoutMessage:Find("FirstPveSubRewardBox")
    self.dailyPveSubRewardBox = self.layoutMessage:Find("DailyPveSubRewardBox")

    self.layoutStars = self.layoutMessage:Find("LayoutStars")
    self.starItemList = {}

    for i = 1, 3 do
        local item = {}
        item.transform = self.layoutStars:GetChild(i - 1)
        item.imgLight = item.transform:Find("ImgLight")
        self.starItemList[i] = item
    end

    self.planetSelect = transform:Find("PlanetSelect")
    self.planetSelectSkeletonAnimation = self.planetSelect:GetComponent("SkeletonGraphic")


    self.pveDescLine = transform:Find("PveDescLine")

    self.layoutPlanetDesc = transform:Find("LayoutPlanetDesc")
    self.txtPlayerTitle =  self.layoutPlanetDesc:Find("TxtPlayerTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPlayerContent =  self.layoutPlanetDesc:Find("BgContent/TxtPlayerContent"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlPveNewView