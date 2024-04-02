PnlUnionView = class("PnlUnionView")

PnlUnionView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.btnDesc = self.txtTitle.transform:Find("BtnDesc").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnSearchUnionList = transform:Find("ViewUnionList/BoxSearch/BtnSearchUnion").gameObject
    self.inputUnionName = transform:Find("ViewUnionList/BoxSearch/InputUnionName"):GetComponent(
        UNITYENGINE_UI_INPUTFIELD)
    self.btnCreate = transform:Find("ViewUnionList/BtnCreate").gameObject
    self.btnInvite = transform:Find("ViewUnionList/BtnInvite").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.imgChain = transform:Find("ViewCreateUnion/ViewBg/Bg/TxtTitle/Text/ImgChain")
        :GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtCreateTitle = transform:Find("ViewCreateUnion/ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnCloseCreateUnion = transform:Find("ViewCreateUnion/ViewBg/Bg/BtnClose").gameObject
    self.txtFlagName = transform:Find("ViewCreateUnion/FlagBg/TxtFlagName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconFlag = transform:Find("ViewCreateUnion/FlagBg/IconFlag"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnSetFlag = transform:Find("ViewCreateUnion/FlagBg/BtnSetFlag").gameObject
    self.txtJoin = transform:Find("ViewCreateUnion/BgJoin/TitelBg/TxtJoin"):GetComponent(UNITYENGINE_UI_TEXT)
    self.toggleEvery = transform:Find("ViewCreateUnion/BgJoin/ToggleGroup/ToggleEvery"):GetComponent(
        UNITYENGINE_UI_TOGGLE)
    self.toggleNeed = transform:Find("ViewCreateUnion/BgJoin/ToggleGroup/ToggleNeed")
        :GetComponent(UNITYENGINE_UI_TOGGLE)
    self.toggleNot = transform:Find("ViewCreateUnion/BgJoin/ToggleGroup/ToggleNot"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.inputFieldUnionName = transform:Find("ViewCreateUnion/BgUnionName/InputFieldUnionName"):GetComponent(
        UNITYENGINE_UI_INPUTFIELD)
    self.txtUnionName = transform:Find("ViewCreateUnion/BgUnionName/InputFieldUnionName/TxtUnionName"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.inputFieldNotice = transform:Find("ViewCreateUnion/BgNotice/InputFieldNotice"):GetComponent(
        UNITYENGINE_UI_INPUTFIELD)
    self.txtNotice = transform:Find("ViewCreateUnion/BgNotice/InputFieldNotice/TxtNotice"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.inputFieldSharing = transform:Find("ViewCreateUnion/BgSharing/InputFieldSharing"):GetComponent(
        UNITYENGINE_UI_INPUTFIELD)
    self.txtSharing = transform:Find("ViewCreateUnion/BgSharing/InputFieldSharing/TxtSharing"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.btnConfirmCreare = transform:Find("ViewCreateUnion/BtnConfirmCreare").gameObject
    self.txtCreatCost = transform:Find("ViewCreateUnion/TxtCreatCost"):GetComponent(UNITYENGINE_UI_TEXT)
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnCloseInvite = transform:Find("ViewUnionInvite/ViewBg/Bg/BtnClose").gameObject
    self.txtUnionInviteName = transform:Find("ViewUnionInvite/ScrollViewUnionInvite/Image/TxtUnionName"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.btnClearInvite = transform:Find("ViewUnionInvite/BtnClear").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.txtInfoUnionName = transform:Find("ViewUnionMain/BgUnionInfo/BgUnionName/TxtInfoUnionName"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtInfoUnionId = transform:Find("ViewUnionMain/BgUnionInfo/TxtInfoUnionId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconInfoFlag = transform:Find("ViewUnionMain/BgUnionInfo/IconInfoFlag"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgChainMain = transform:Find("ViewUnionMain/BgUnionInfo/ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnCopy = transform:Find("ViewUnionMain/BgUnionInfo/BtnCopy").gameObject
    self.txtPresident = transform:Find("ViewUnionMain/BgUnionInfo/Config/PresidentUnionBar/TxtPresident"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtMember = transform:Find("ViewUnionMain/BgUnionInfo/Config/MemberUnionBar/TxtMember"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtArtifact = transform:Find("ViewUnionMain/BgUnionInfo/Config/ArtifactUnionBar/TxtArtifact"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtPower = transform:Find("ViewUnionMain/BgUnionInfo/Config/PowerUnionBar/TxtPower"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtDistribution = transform:Find("ViewUnionMain/BgUnionInfo/Config/DistributionUnionBar/TxtDistribution")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPlots = transform:Find("ViewUnionMain/BgUnionInfo/Config/PlotsUnionBar/TxtPlots"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtGrade = transform:Find("ViewUnionMain/BgUnionInfo/Config/GradeUnionBar/TxtGrade"):GetComponent(
        UNITYENGINE_UI_TEXT)

    self.expSlider = transform:Find("ViewUnionMain/BgUnionInfo/Exp/ExpSlider"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnEdito = transform:Find("ViewUnionMain/BgUnionInfo/BtnEdito").gameObject
    -- self.txtStarCoin = transform:Find("ViewUnionMain/BgUnionInfo/BgResStorage/StarCoin/TxtStarCoin"):GetComponent(
    --     UNITYENGINE_UI_TEXT)
    -- self.txtTitanium = transform:Find("ViewUnionMain/BgUnionInfo/BgResStorage/Titanium/TxtTitanium"):GetComponent(
    --     UNITYENGINE_UI_TEXT)
    -- self.txtIce = transform:Find("ViewUnionMain/BgUnionInfo/BgResStorage/Ice/TxtIce"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txtGas = transform:Find("ViewUnionMain/BgUnionInfo/BgResStorage/Gas/TxtGas"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtPoints = transform:Find("ViewUnionMain/ViewMyUnion/BgLeague/LeagueInfo/TxtPoints"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtRanking = transform:Find("ViewUnionMain/ViewMyUnion/BgLeague/LeagueInfo/TxtRanking"):GetComponent(
        UNITYENGINE_UI_TEXT)
    
    self.hyOutput = transform:Find("ViewUnionMain/ViewMyUnion/BgLeague/HyOutput")
    self.txtTotelHy = transform:Find("ViewUnionMain/ViewMyUnion/BgLeague/HyOutput/TxtTotelHy"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.btnDaoInfoDesc = transform:Find("ViewUnionMain/ViewMyUnion/BgLeague/TiteLeague/BtnDaoInfoDesc").gameObject

    self.txtHyHour = transform:Find("ViewUnionMain/ViewMyUnion/BgLeague/HyOutput/TxtHyHour"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtNftTower = transform:Find("ViewUnionMain/ViewMyUnion/BgWarehouse/NftTower/TxtNftTower"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtHero = transform:Find("ViewUnionMain/ViewMyUnion/BgWarehouse/Hero/TxtHero")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtWarship = transform:Find("ViewUnionMain/ViewMyUnion/BgWarehouse/NftWarship/TxtNftWarship"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtMainNotice = transform:Find("ViewUnionMain/ViewMyUnion/BgNotice/TxtNotice")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.btnEditoNotice = transform:Find("ViewUnionMain/ViewMyUnion/BgNotice/TitelNotice/BtnEditoNotice").gameObject
    self.btnWarehouse = transform:Find("ViewUnionMain/ViewMyUnion/BtnWarehouse").gameObject
    self.btnPlot = transform:Find("ViewUnionMain/ViewMyUnion/BtnPlot").gameObject
    self.btnMint = transform:Find("ViewUnionMain/ViewMyUnion/BtnMint").gameObject
    self.btnMemberMian = transform:Find("ViewUnionMain/ViewMyUnion/BtnMember").gameObject
    self.btnScience = transform:Find("ViewUnionMain/ViewMyUnion/BtnScience").gameObject
    self.btnFacilities = transform:Find("ViewUnionMain/ViewMyUnion/BtnFacilities").gameObject
    self.btnWarReport = transform:Find("ViewUnionMain/ViewMyUnion/BtnWarReport").gameObject
    self.btnNft = transform:Find("ViewUnionMain/ViewMyUnion/BtnNft").gameObject

    self.noticeInputBg = transform:Find("ViewUnionMain/ViewMyUnion/NoticeInputBg").gameObject
    self.noticeInput = transform:Find("ViewUnionMain/ViewMyUnion/NoticeInputBg/InputField"):GetComponent(
        UNITYENGINE_UI_INPUTFIELD)
    self.txtNoticeTips = transform:Find("ViewUnionMain/ViewMyUnion/NoticeInputBg/Text")
        :GetComponent(UNITYENGINE_UI_TEXT)
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.txtOtherInfoUnionName = transform:Find("ViewUnionOther/Bg/BgUnionInfo/BgUnionName/TxtInfoUnionName")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOtherInfoUnionId = transform:Find("ViewUnionOther/Bg/BgUnionInfo/TxtInfoUnionId"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.iconOtherInfoFlag = transform:Find("ViewUnionOther/Bg/BgUnionInfo/IconInfoFlag"):GetComponent(
        UNITYENGINE_UI_IMAGE)
    self.ImgChainOther = transform:Find("ViewUnionOther/Bg/BgUnionInfo/ImgChain"):GetComponent(
        UNITYENGINE_UI_IMAGE)
    self.btnCopyOther = transform:Find("ViewUnionOther/Bg/BgUnionInfo/BtnCopy").gameObject
    self.txtOtherPresident = transform:Find("ViewUnionOther/Bg/BgUnionInfo/Config/PresidentUnionBar/TxtPresident")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOtherMember = transform:Find("ViewUnionOther/Bg/BgUnionInfo/Config/MemberUnionBar/TxtMember"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtOtherArtifact = transform:Find("ViewUnionOther/Bg/BgUnionInfo/Config/ArtifactUnionBar/TxtArtifact")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOtherPoints = transform:Find("ViewUnionOther/Bg/BgUnionInfo/Config/PointsUnionBar/TxtPoints"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtOtherPower = transform:Find("ViewUnionOther/Bg/BgUnionInfo/Config/PowerUnionBar/TxtPower"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtOtherDistribution = transform:Find(
        "ViewUnionOther/Bg/BgUnionInfo/Config/DistributionUnionBar/TxtDistribution"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtOtherNotice = transform:Find("ViewUnionOther/Bg/BgNotice/TxtNotice"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnOtherJoin = transform:Find("ViewUnionOther/Bg/BtnJoin").gameObject
    self.btnOtherClose = transform:Find("ViewUnionOther/Bg/BtnClose").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnCloseMember = transform:Find("ViewUnionMember/ViewBg/Bg/BtnClose").gameObject
    self.btnApplyList = transform:Find("ViewUnionMember/BtnApplyList").gameObject
    self.btnInviteMember = transform:Find("ViewUnionMember/BtnInvitePlayer").gameObject
    self.btnCycle = transform:Find("ViewUnionMember/BtnCycle").gameObject
    self.btnMember = transform:Find("ViewUnionMember/BtnMember").gameObject
    self.btnSearchMember = transform:Find("ViewUnionMember/BoxSearch/BtnSearchUnion").gameObject
    self.inputMember = transform:Find("ViewUnionMember/BoxSearch/InputUnionName")
        :GetComponent(UNITYENGINE_UI_INPUTFIELD)

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnCloseInvitePlayer = transform:Find("ViewInvitePlayer/Bg/BtnCloseInvitePlayer").gameObject
    self.btnSearchPlayer = transform:Find("ViewInvitePlayer/BoxSearch/BtnSearchUnion").gameObject
    self.inputPlayer = transform:Find("ViewInvitePlayer/BoxSearch/InputUnionName"):GetComponent(
        UNITYENGINE_UI_INPUTFIELD)
    self.btnInvitePlayer = transform:Find("ViewInvitePlayer/BoxApply/BtnInvite").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnCloseUnionApply = transform:Find("ViewUnionApply/ViewBg/Bg/BtnClose").gameObject
    self.btnClearApply = transform:Find("ViewUnionApply/BtnClear").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnCloseFlag = transform:Find("ViewChangeFlags/Bg/BtnCloseFlag").gameObject
    self.btnConfirmFlag = transform:Find("ViewChangeFlags/BtnConfirmFlag").gameObject
    self.boxChoose = transform:Find("ViewChangeFlags/BoxChoose").gameObject
    self.txtSetFlagName = transform:Find("ViewChangeFlags/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.btnCloseAddpoint = transform:Find("ViewUnionAddpoint/ViewBg/Bg/BtnClose").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.txtUnionWarehouseTitle = transform:Find("ViewUnionWarehouse/ViewBg/Bg/TxtTitle"):GetComponent(
        UNITYENGINE_UI_TEXT)

    self.btnWarehouseDesc = transform:Find("ViewUnionWarehouse/ViewBg/Bg/TxtTitle/BtnWarehouseDesc").gameObject

    -- gg.uiManager:openWindow("PnlDesc", {title = Utils.getText(self.WarehouseDescTitle), desc = Utils.getText(self.WarehouseDescContent)} )

    self.btnCloseWarehouse = transform:Find("ViewUnionWarehouse/ViewBg/Bg/BtnClose").gameObject
    self.btnRes = transform:Find("ViewUnionWarehouse/ViewBg/Bg/LeftButton/BtnRes").gameObject
    self.btnSoldier = transform:Find("ViewUnionWarehouse/ViewBg/Bg/LeftButton/BtnSoldier").gameObject
    self.btnTower = transform:Find("ViewUnionWarehouse/ViewBg/Bg/LeftButton/BtnTower").gameObject
    self.btnDao = transform:Find("ViewUnionWarehouse/ViewBg/Bg/LeftButton/BtnDao").gameObject

    self.warehouseBtnIcon = {}
    self.warehouseBtnIcon[1] = self.btnRes.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.warehouseBtnIcon[2] = self.btnSoldier.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.warehouseBtnIcon[3] = self.btnTower.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.warehouseBtnIcon[4] = self.btnDao.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.warehouseBtnText = {}
    self.warehouseBtnText[1] = self.btnRes.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.warehouseBtnText[2] = self.btnSoldier.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.warehouseBtnText[3] = self.btnTower.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.warehouseBtnText[4] = self.btnDao.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.warhouseRes = transform:Find("ViewUnionWarehouse/WarhouseRes").gameObject
    self.btnConfirm = transform:Find("ViewUnionWarehouse/WarhouseRes/BtnConfirm").gameObject
    local bgWarehouse = transform:Find("ViewUnionWarehouse/WarhouseRes/BgWarehouse").transform
    self.txtStarCoinWarrhouse = bgWarehouse:Find("StarCoin/TxtStarCoin"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTitaniumWarrhouse = bgWarehouse:Find("Titanium/TxtTitanium"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtIceWarrhouse = bgWarehouse:Find("Ice/TxtIce"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtGasWarrhouse = bgWarehouse:Find("Gas/TxtGas"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHydroxylWarrhouse = bgWarehouse:Find("Hydroxyl/TxtHydroxyl"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtContribution = transform:Find("ViewUnionWarehouse/WarhouseRes/BgContribution/Titel/TxtContribution")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAdd = transform:Find("ViewUnionWarehouse/WarhouseRes/BgContribution/Titel/TxtContribution/TxtAdd")
        :GetComponent(UNITYENGINE_UI_TEXT)

    self.resScrollbar = {}
    self.resScrollbar[constant.RES_STARCOIN] = transform:Find("ViewUnionWarehouse/WarhouseRes/StarScrollbar").transform
    self.resScrollbar[constant.RES_TITANIUM] = transform:Find("ViewUnionWarehouse/WarhouseRes/TiScrollbar").transform
    self.resScrollbar[constant.RES_ICE] = transform:Find("ViewUnionWarehouse/WarhouseRes/IceScrollbar").transform
    self.resScrollbar[constant.RES_GAS] = transform:Find("ViewUnionWarehouse/WarhouseRes/GasScrollbar").transform
    self.resScrollbar[constant.RES_CARBOXYL] = transform:Find("ViewUnionWarehouse/WarhouseRes/HylScrollbar").transform

    self.warehouseTrain = transform:Find("ViewUnionWarehouse/WarehouseTrain").gameObject
    self.sliderWarehouseResObj = transform:Find("ViewUnionWarehouse/SliderWarehouseRes").gameObject
    local SliderWarehouseRes = transform:Find("ViewUnionWarehouse/SliderWarehouseRes")
    self.sliderWarehouseRes = {}
    self.sliderWarehouseRes[constant.RES_STARCOIN] = SliderWarehouseRes:Find("ResSliderWarehouse1")
    self.sliderWarehouseRes[constant.RES_ICE] = SliderWarehouseRes:Find("ResSliderWarehouse2")
    self.sliderWarehouseRes[constant.RES_TITANIUM] = SliderWarehouseRes:Find("ResSliderWarehouse3")
    self.sliderWarehouseRes[constant.RES_GAS] = SliderWarehouseRes:Find("ResSliderWarehouse4")
    self.sliderWarehouseRes[constant.RES_CARBOXYL] = SliderWarehouseRes:Find("ResSliderWarehouse5")

    self.iconTop = self.warehouseTrain.transform:Find("BgInfo/IconBg/Image/IconTop"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconTrain = self.warehouseTrain.transform:Find("BgInfo/IconBg/Image/Mask/Icon"):GetComponent(
        UNITYENGINE_UI_IMAGE)
    self.txtLv = self.warehouseTrain.transform:Find("BgInfo/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtName = self.warehouseTrain.transform:Find("BgInfo/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTrainTime = self.warehouseTrain.transform:Find("BgInfo/TxtTrainTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTrainCount = self.warehouseTrain.transform:Find("BgInfo/TrainScrollbar/Scrollbar/TxtTrainCount")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.trainScrollbar = self.warehouseTrain.transform:Find("BgInfo/TrainScrollbar/Scrollbar"):GetComponent(
        UNITYENGINE_UI_SCROLLBAR)
    self.btnReduce = self.warehouseTrain.transform:Find("BgInfo/TrainScrollbar/Scrollbar/BtnReduce").gameObject
    self.btnIncrease = self.warehouseTrain.transform:Find("BgInfo/TrainScrollbar/Scrollbar/BtnIncrease").gameObject
    self.btnTrain = self.warehouseTrain.transform:Find("BgInfo/BtnTrain").gameObject
    self.txtWarning = self.warehouseTrain.transform:Find("BgInfo/TxtWarning"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNoPermissions = self.warehouseTrain.transform:Find("BgInfo/TxtNoPermissions"):GetComponent(
        UNITYENGINE_UI_TEXT)

    self.attrScrollViewList = self.warehouseTrain.transform:Find("BgInfo/AttrScrollView")

    self.attrScrollView = {}
    table.insert(self.attrScrollView,
        self.warehouseTrain.transform:Find("BgInfo/AttrScrollView/Viewport/Content/CommonAttrItem1/TxtAttr")
            :GetComponent(UNITYENGINE_UI_TEXT))
    table.insert(self.attrScrollView,
        self.warehouseTrain.transform:Find("BgInfo/AttrScrollView/Viewport/Content/CommonAttrItem2/TxtAttr")
            :GetComponent(UNITYENGINE_UI_TEXT))
    table.insert(self.attrScrollView,
        self.warehouseTrain.transform:Find("BgInfo/AttrScrollView/Viewport/Content/CommonAttrItem3/TxtAttr")
            :GetComponent(UNITYENGINE_UI_TEXT))
    table.insert(self.attrScrollView,
        self.warehouseTrain.transform:Find("BgInfo/AttrScrollView/Viewport/Content/CommonAttrItem4/TxtAttr")
            :GetComponent(UNITYENGINE_UI_TEXT))

    self.warehouseDao = transform:Find("ViewUnionWarehouse/WarehouseDao").gameObject
    self.txtLevel = transform:Find("ViewUnionWarehouse/WarehouseDao/BgLevel/BgLv/Text")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtExp = transform:Find("ViewUnionWarehouse/WarehouseDao/BgLevel/TxtExp"):GetComponent(UNITYENGINE_UI_TEXT)
    self.sliderExp = transform:Find("ViewUnionWarehouse/WarehouseDao/BgLevel/SliderExp"):GetComponent(
        UNITYENGINE_UI_SLIDER)
    self.levelMaxGo = transform:Find("ViewUnionWarehouse/WarehouseDao/BgLevel/LevelMax").gameObject

    self.txtContri = transform:Find("ViewUnionWarehouse/WarehouseDao/BgContribution/Titel/TxtContribution")
        :GetComponent(UNITYENGINE_UI_TEXT)

    self.daoContent = transform:Find("ViewUnionWarehouse/WarehouseDao/ScrollView/Viewport/Content")
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------
    self.btnCloseTech = transform:Find("ViewUnionTech/BtnClose").gameObject

    self.btnEconomy = transform:Find("ViewUnionTech/BtnEconomy").gameObject
    self.btnMilitary = transform:Find("ViewUnionTech/BtnMilitary").gameObject
    self.btnDefence = transform:Find("ViewUnionTech/BtnDefence").gameObject

    self.techBtnIcon = {}
    self.techBtnIcon[1] = self.btnEconomy.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.techBtnIcon[2] = self.btnMilitary.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.techBtnIcon[3] = self.btnDefence.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    -- self.techBtnIcon[3] = self.btnTower.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    -- self.techBtnIcon[4] = self.btnNft.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.techBtnText = {}
    self.techBtnText[1] = self.btnEconomy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.techBtnText[2] = self.btnMilitary.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.techBtnText[3] = self.btnDefence.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    -- self.techBtnText[3] = self.btnTower.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.techBtnText[4] = self.btnNft.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnUpgrading = transform:Find("ViewUnionTech/BtnUpgrading").gameObject
    self.scrollViewtTech = transform:Find("ViewUnionTech/ScrollView"):GetComponent(UNITYENGINE_UI_SCROLLRECT)
    self.scrollViewportTech = transform:Find("ViewUnionTech/ScrollView/Viewport")
    self.viewUpgradingList = transform:Find("ViewUnionTech/BtnUpgrading/ViewUpgradingList")

    self.viewTechInfo = transform:Find("ViewUnionTech/ViewTechInfo")

    self.txtTechTitel = self.viewTechInfo:Find("Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnCloseTechInfo = self.viewTechInfo:Find("Bg/BtnClose").gameObject
    self.techInfoIconTop = self.viewTechInfo:Find("InfoBrief/HardBg/IconBg/IconTop"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.techInfoIcon = self.viewTechInfo:Find("InfoBrief/HardBg/IconBg/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtBrief = self.viewTechInfo:Find("InfoBrief/TxtBrief"):GetComponent(UNITYENGINE_UI_TEXT)
    self.sliderTechLevel = self.viewTechInfo:Find("InfoBrief/Slider/Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtTechLv = self.viewTechInfo:Find("InfoBrief/Slider/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT)

    self.levelMax = self.viewTechInfo:Find("BoxArrowUpgrade/LevelMax").gameObject
    self.levelUpgrade = self.viewTechInfo:Find("BoxArrowUpgrade/LevelUpgrade").gameObject
    self.txtCurLevel = self.viewTechInfo:Find("BoxArrowUpgrade/LevelUpgrade/TxtCurLevel"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtNextLevel = self.viewTechInfo:Find("BoxArrowUpgrade/LevelUpgrade/TxtNextLevel/Text"):GetComponent(
        UNITYENGINE_UI_TEXT)

    self.layoutPrepare = self.viewTechInfo:Find("LayoutPrepare").gameObject
    self.btnUpgrade = self.viewTechInfo:Find("LayoutPrepare/BtnUpgrade").gameObject
    self.txtTrainTime = self.viewTechInfo:Find("LayoutPrepare/TxtTrainTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.trainTime = self.viewTechInfo:Find("TrainTime").gameObject
    self.txtTime = self.viewTechInfo:Find("TrainTime/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.tipsHighestLevel = self.viewTechInfo:Find("TipsHighestLevel").gameObject
    self.tipsUnlock = self.viewTechInfo:Find("TipsUnlock").gameObject

    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------

    self.viewUnionList = transform:Find("ViewUnionList").gameObject
    self.viewCreateUnion = transform:Find("ViewCreateUnion").gameObject
    self.viewUnionInvite = transform:Find("ViewUnionInvite").gameObject
    self.viewUnionOther = transform:Find("ViewUnionOther").gameObject
    self.viewUnionMain = transform:Find("ViewUnionMain").gameObject
    self.viewUnionMember = transform:Find("ViewUnionMember").gameObject
    self.viewInvitePlayer = transform:Find("ViewInvitePlayer").gameObject
    self.viewUnionApply = transform:Find("ViewUnionApply").gameObject
    self.viewChangeFlags = transform:Find("ViewChangeFlags").gameObject
    self.viewUnionAddpoint = transform:Find("ViewUnionAddpoint").gameObject
    self.viewUnionWarehouse = transform:Find("ViewUnionWarehouse").gameObject
    self.ViewUnionTech = transform:Find("ViewUnionTech").gameObject

end

return PnlUnionView
