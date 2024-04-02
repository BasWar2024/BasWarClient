
PnlPvpView = class("PnlPvpView")

PnlPvpView.ctor = function(self, transform)
    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject

    self.layoutPool = transform:Find("Root/LayoutPool")
    self.mitNumbers = self:getNumbersList(transform:Find("Root/LayoutPool/LayoutMitNumbers"))
    self.hydNumbers = self:getNumbersList(transform:Find("Root/LayoutPool/LayoutHydNumbers"))

    self.txtMyReward = transform:Find("Root/LayoutReward/TxtMyReward"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutInfo = transform:Find("Root/LayoutInfo")

    self.imgStage = self.layoutInfo:Find("BgStage/ImgStage"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgProgress = self.layoutInfo:Find("BgStage/ImgProgress"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtStage = self.layoutInfo:Find("BgStage/TxtStage"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtAttackCount1 = transform:Find("Root/LayoutInfo/LayoutFightCount/TxtAttackCount1"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttackCount2 = transform:Find("Root/LayoutInfo/LayoutFightCount/TxtAttackCount2"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtReward = transform:Find("Root/LayoutInfo/LayoutReward/TxtReward"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnPlus = transform:Find("Root/LayoutInfo/LayoutFightCount/BtnPlus").gameObject

    self.pvpStageBox = self.layoutInfo:Find("PvpStageBox")

    self.layoutEnemyInfo = transform:Find("Root/LayoutEnemyInfo")
    self.imgBgEnemyStage = self.layoutEnemyInfo:Find("ImgBgEnemyStage"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgEnemyStage = self.imgBgEnemyStage.transform:Find("ImgEnemyStage"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtEnemyStage = self.imgBgEnemyStage.transform:Find("TxtEnemyStage"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtEnemyStageGradient = self.txtEnemyStage.transform:GetComponent(typeof(CS.TextGradient))

    self.bgDao = self.layoutEnemyInfo:Find("BgDao")
    self.txtDao = self.layoutEnemyInfo:Find("BgDao/TxtDao"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtEnemyName = self.layoutEnemyInfo:Find("TxtEnemyName"):GetComponent(typeof(CS.TextYouYU))

    self.btnFind = transform:Find("Root/btnFind").gameObject
    self.txtCostFind = transform:Find("Root/btnFind/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnRank = transform:Find("Root/LayoutBtns/BtnRank").gameObject
    self.btnInfo = transform:Find("Root/LayoutBtns/BtnInfo").gameObject
    self.btnRewardSys = transform:Find("Root/LayoutBtns/BtnRewardSys").gameObject
    self.btnRewardHist = transform:Find("Root/LayoutBtns/BtnRewardHist").gameObject

    self.layoutPlayers = transform:Find("Root/LayoutPlayers")

    self.txtTime = transform:Find("Root/TxtTime")
    self.txtEndTime = self.txtTime:Find("TxtEndTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutAtk = transform:Find("Root/LayoutAtk")
    self.btnScout = self.layoutAtk:Find("BtnScout").gameObject
    self.txtCostScout = self.layoutAtk:Find("BtnScout/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAttack = self.layoutAtk:Find("BtnAttack").gameObject
    self.txtCostAttack = self.layoutAtk:Find("BtnAttack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgGray = self.layoutAtk:Find("BtnAttack/imgGray"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.layoutBan = transform:Find("Root/LayoutBan")
    self.txtBanTime = self.layoutBan:Find("TxtBanTime"):GetComponent(UNITYENGINE_UI_TEXT)
end

function PnlPvpView:getNumbersList(trans)
    local list = {}
    for i = 1, trans.childCount, 1 do
        local item = {}
        item.transform = trans:GetChild(i - 1)
        item.text = item.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        list[i] = item
    end
    return list
end

return PnlPvpView