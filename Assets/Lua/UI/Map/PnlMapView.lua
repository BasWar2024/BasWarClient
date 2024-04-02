
PnlMapView = class("PnlMapView")

PnlMapView.ctor = function(self, transform)

    self.transform = transform

    self.btnReturn = transform:Find("BtnReturn").gameObject
    self.btnRank = transform:Find("BtnRank").gameObject
    self.btnReward = transform:Find("BtnReward").gameObject
    self.btnBattleReport = transform:Find("BtnBattleReport").gameObject
    self.btnChat = transform:Find("BtnChat").gameObject
    self.btnChain = transform:Find("BtnChain").gameObject
    self.btnBeginGrid = transform:Find("BtnBeginGrid").gameObject

    self.muneButton = transform:Find("MuneButton").gameObject

    self.txtIntegralMap = transform:Find("BgIntegral/TxtIntegral"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtSeason = transform:Find("BgSeason/TxtSeason"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTime = transform:Find("BgSeason/BgTIme/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtSoliderTitel = transform:Find("BgSoldier/TxtSoliderTitel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.boxSoldierInMap1 = transform:Find("BgSoldier/BoxSoldierInMap1")
    self.boxSoldierInMap2 = transform:Find("BgSoldier/BoxSoldierInMap2")
    self.boxSoldierInMap3 = transform:Find("BgSoldier/BoxSoldierInMap3")
    self.boxSoldierInMap4 = transform:Find("BgSoldier/BoxSoldierInMap4")
    self.boxSoldierInMap5 = transform:Find("BgSoldier/BoxSoldierInMap5")
    self.boxSoldierInMap6 = transform:Find("BgSoldier/BoxSoldierInMap6")
    self.boxSoldierInMap7 = transform:Find("BgSoldier/BoxSoldierInMap7")
    self.boxSoldierInMap8 = transform:Find("BgSoldier/BoxSoldierInMap8")
    self.txtLevel = transform:Find("BgSoldier/BoxHeroInMap/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgLine = transform:Find("BoxInfomation/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconRes = transform:Find("BoxInfomation/BgInfomation/Res/IconRes"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("BoxInfomation/BgInfomation/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPos = transform:Find("BoxInfomation/BgInfomation/TxtPos"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOwner = transform:Find("BoxInfomation/BgInfomation/OwnerName/TxtOwner"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUnion = transform:Find("BoxInfomation/BgInfomation/UnionName/TxtUnion"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtGuildNumber = transform:Find("BoxInfomation/BgInfomation/GuildNumber/TxtGuildNumber"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtHydroxyl = transform:Find("BoxInfomation/BgInfomation/BoxGet/Res/Res/TxtRes"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtIntegral = transform:Find("BoxInfomation/BgInfomation/BoxGet/Res/Integral/TxtIntegral"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnUnionCollection = transform:Find("BoxInfomation/BgInfomation/BtnUnionCollection").gameObject
    self.btnShare = transform:Find("BoxInfomation/BgInfomation/BtnShare").gameObject
    self.btnCollection = transform:Find("BoxInfomation/BgInfomation/BtnCollection").gameObject

    self.btnCheck = transform:Find("BoxInfomation/ViewButton/BtnCheck").gameObject
    self.btnAttack = transform:Find("BoxInfomation/ViewButton/BtnAttack").gameObject
    self.btnAttackUnion = transform:Find("BoxInfomation/ViewButton/BtnAttackUnion").gameObject
    self.btnEnter = transform:Find("BoxInfomation/ViewButton/BtnEnter").gameObject
    self.btnDel = transform:Find("BoxInfomation/ViewButton/BtnDel").gameObject
    self.btnMove = transform:Find("BoxInfomation/ViewButton/BtnMove").gameObject

    self.btnAttackSelfEditAuto = transform:Find("BoxInfomation/ViewButton/BtnAttackSelfEditAuto").gameObject

    -- self.txtCheckCost = transform:Find("BoxInfomation/BgInfomation/ViewButton/BtnCheck/TxtCheckCost"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.btnAttackSelf = transform:Find("BoxInfomation/BgInfomation/ViewButton/BtnAttackSelf").gameObject
    -- self.btnAttackSelfQuick = transform:Find("BoxInfomation/BgInfomation/ViewButton/BtnAttackSelfQuick").gameObject
    -- self.txtAttackCost = transform:Find("BoxInfomation/BgInfomation/ViewButton/BtnAttack/TxtAttackCost"):GetComponent(UNITYENGINE_UI_TEXT)

    self.boxInfomation = transform:Find("BoxInfomation").gameObject
    self.bgInfomation = transform:Find("BoxInfomation/BgInfomation")
    self.viewButton = transform:Find("BoxInfomation/ViewButton").gameObject
    self.boxGet = transform:Find("BoxInfomation/BgInfomation/BoxGet").gameObject
    self.txtAttTips = transform:Find("BoxInfomation/BgInfomation/TxtAttTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCfgId = transform:Find("BoxInfomation/BgInfomation/TxtCfgId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.statusTimeBg = transform:Find("BoxInfomation/StatusTime").gameObject
    self.imgSelfTime = transform:Find("BoxInfomation/StatusTime/ImgSelfTime").gameObject
    self.imgOtherTime = transform:Find("BoxInfomation/StatusTime/ImgOtherTime").gameObject
    self.txtStatusTime = transform:Find("BoxInfomation/StatusTime/TxtStatusTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnPersionPlot = transform:Find("BtnPersionPlot").gameObject
    self.btnSmallMap = transform:Find("BtnSmallMap").gameObject

end

return PnlMapView