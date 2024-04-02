PnlPlayerInformationView = class("PnlPlayerInformationView")

PnlPlayerInformationView.ctor = function(self, transform)

    self.transform = transform

    self.txtDelay = transform:Find("TxtDelay"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgDelay = self.txtDelay.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.bg = transform:Find("Bg").gameObject

    self.resourceUI = transform:Find("ResourceUI").gameObject

    self.mit = transform:Find("ResourceUI/Mit").gameObject
    self.iconMit = transform:Find("ResourceUI/Mit").gameObject
    self.carboxyl = transform:Find("ResourceUI/Carboxyl").gameObject

    self.btnMit = transform:Find("ResourceUI/Mit/BtnMit").gameObject
    self.txtMit = transform:Find("ResourceUI/Mit/TxtMit"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnCarboxyl = transform:Find("ResourceUI/Carboxyl/BtnCarboxyl").gameObject
    self.txtCarboxyl = transform:Find("ResourceUI/Carboxyl/TxtCarboxyl"):GetComponent(UNITYENGINE_UI_TEXT)

    self.tesseract = transform:Find("ResourceUI/Tesseract").gameObject
    self.iconTesseract = transform:Find("ResourceUI/Tesseract/Icon").gameObject
    self.txtTesseract = transform:Find("ResourceUI/Tesseract/TxtTesseract"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnTesseract = transform:Find("ResourceUI/Tesseract/BtnTesseract").gameObject

    self.btnStartCoin = transform:Find("ResourceUI/StarCoin/Btn").gameObject
    self.btnGas = transform:Find("ResourceUI/Gas/Btn").gameObject
    self.btnTitanium = transform:Find("ResourceUI/Titanium/Btn").gameObject
    self.btnIce = transform:Find("ResourceUI/Ice/Btn").gameObject

    self.btnStartCoinAdd = transform:Find("ResourceUI/StarCoin/BtnAdd").gameObject
    self.btnGasAdd = transform:Find("ResourceUI/Gas/BtnAdd").gameObject
    self.btnTitaniumAdd = transform:Find("ResourceUI/Titanium/BtnAdd").gameObject
    self.btnIceAdd = transform:Find("ResourceUI/Ice/BtnAdd").gameObject

    -- self.btnCarboxyl = transform:Find("ResourceUI/Carboxyl/Btn").gameObject

    self.playerInformation = transform:Find("PlayerInformation")
    -- self.btnLevel = transform:Find("PlayerInformation/BtnLevel").gameObject
    self.btnPlayerName = transform:Find("PlayerInformation/BtnPlayerName").gameObject
    self.txtPlayerName = transform:Find("PlayerInformation/TxtPlayerName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnPvpScore = transform:Find("PlayerInformation/BtnPvpScore").gameObject
    self.txtPvpScore = transform:Find("PlayerInformation/BtnPvpScore/TxtPvpScore"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconHead = transform:Find("PlayerInformation/MaskHead/IconHead"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgChain = transform:Find("PlayerInformation/ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE)


    self.btnVip = transform:Find("PlayerInformation/TxtPlayerName/BtnVip").gameObject
    self.txtVip = self.btnVip.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgVipIcon = self.btnVip.transform:Find("ImgVipIcon"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.resItemMap = {}
    self.resItemMap[constant.RES_STARCOIN] = {
        scrollbar = transform:Find("ResourceUI/StarCoin/ScrollBar"):GetComponent(UNITYENGINE_UI_SCROLLBAR),
        imgUnBind = transform:Find("ResourceUI/StarCoin/ImgUnbind"):GetComponent(UNITYENGINE_UI_IMAGE),
        text = transform:Find("ResourceUI/StarCoin/Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    }

    self.resItemMap[constant.RES_ICE] = {
        scrollbar = transform:Find("ResourceUI/Ice/ScrollBar"):GetComponent(UNITYENGINE_UI_SCROLLBAR),
        imgUnBind = transform:Find("ResourceUI/Ice/ImgUnbind"):GetComponent(UNITYENGINE_UI_IMAGE),
        text = transform:Find("ResourceUI/Ice/Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    }

    -- self.resItemMap[constant.RES_CARBOXYL] = {
    --     scrollbar = transform:Find("ResourceUI/Carboxyl/ScrollBar"):GetComponent(UNITYENGINE_UI_SCROLLBAR),
    --     imgUnBind = transform:Find("ResourceUI/Carboxyl/ImgUnbind"):GetComponent(UNITYENGINE_UI_IMAGE),
    --     text = transform:Find("ResourceUI/Carboxyl/Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    -- }

    self.resItemMap[constant.RES_TITANIUM] = {
        scrollbar = transform:Find("ResourceUI/Titanium/ScrollBar"):GetComponent(UNITYENGINE_UI_SCROLLBAR),
        imgUnBind = transform:Find("ResourceUI/Titanium/ImgUnbind"):GetComponent(UNITYENGINE_UI_IMAGE),
        text = transform:Find("ResourceUI/Titanium/Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    }
    self.resItemMap[constant.RES_GAS] = {
        scrollbar = transform:Find("ResourceUI/Gas/ScrollBar"):GetComponent(UNITYENGINE_UI_SCROLLBAR),
        imgUnBind = transform:Find("ResourceUI/Gas/ImgUnbind"):GetComponent(UNITYENGINE_UI_IMAGE),
        text = transform:Find("ResourceUI/Gas/Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    }

    self.boxResDetailed = transform:Find("BoxResDetailed")
    self.txtType = self.boxResDetailed:Find("TxtType"):GetComponent(UNITYENGINE_UI_TEXT)
    self.scrollViewDesc = self.boxResDetailed:Find("ScrollViewDesc").gameObject
    self.txtBoxResDetailedDesc = self.boxResDetailed:Find("ScrollViewDesc/Viewport/TxtBoxResDetailedDesc"):GetComponent(
        typeof(CS.TextYouYU))

    self.layoutTexts = self.boxResDetailed:Find("LayoutTexts")
    self.boxDetailedTextMap = {}
    local countItem = self.boxResDetailed:Find("count")
    self.boxDetailedTextMap[countItem.name] = {
        transform = countItem,
        txtTitle = countItem:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT),
        text = countItem:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    }

    for i = 1, self.layoutTexts.childCount do
        local item = {}
        item.transform = self.layoutTexts:GetChild(i - 1)
        item.txtTitle = item.transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
        item.text = item.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

        self.boxDetailedTextMap[item.transform.name] = item
    end

    self.otherPlayerInformation = transform:Find("OtherPlayerInformation")
    self.txtOtherName = self.otherPlayerInformation:Find("TxtPlayerName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOtherScore = self.otherPlayerInformation:Find("BtnPvpScore/TxtPvpScore"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgOtherPlayerHead = self.otherPlayerInformation:Find("MaskHead/IconHead"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.resFlyTargetMap = {}
    self.resFlyTargetMap[constant.RES_MIT] = transform:Find("ResourceUI/Mit/IconMit").gameObject
    self.resFlyTargetMap[constant.RES_STARCOIN] = transform:Find("ResourceUI/StarCoin/Icon").gameObject
    self.resFlyTargetMap[constant.RES_ICE] = transform:Find("ResourceUI/Ice/Icon").gameObject
    self.resFlyTargetMap[constant.RES_CARBOXYL] = transform:Find("ResourceUI/Carboxyl/IconCarboxyl").gameObject
    self.resFlyTargetMap[constant.RES_TITANIUM] = transform:Find("ResourceUI/Titanium/Icon").gameObject
    self.resFlyTargetMap[constant.RES_GAS] = transform:Find("ResourceUI/Gas/Icon").gameObject

    self.planetInformation = transform:Find("PlanetInformation")
    self.txtPlanetLv = transform:Find("PlanetInformation/BgLv/TxtPlanetLv"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPlanet = transform:Find("PlanetInformation/BgName/TxtPlanetName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOwner = transform:Find("PlanetInformation/BgOwner/TxtOwner"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtYield = transform:Find("PlanetInformation/Res/BgYield/TxtYield"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPoints = transform:Find("PlanetInformation/Res/BgPoints/TxtPoints"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDefenses = transform:Find("PlanetInformation/Res/BgDefenses/TxtDefenses"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgYield = transform:Find("PlanetInformation/Res/BgYield/Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.bgOwner = transform:Find("PlanetInformation/BgOwner").gameObject
    self.bgYield = transform:Find("PlanetInformation/Res/BgYield").gameObject
    self.bgPoints = transform:Find("PlanetInformation/Res/BgPoints").gameObject
    self.bgDefenses = transform:Find("PlanetInformation/Res/BgDefenses").gameObject

    self.boxBuildButton = transform:Find("BoxBuildButton").gameObject
    self.boxBuildButtonList = transform:Find("BoxBuildButton/ButtonUiBg")
    self.txtBuildName = transform:Find("BoxBuildButton/TxtBuildName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutEditBuild = transform:Find("BoxBuildButton/LayoutEditBuild")
    self.editBuildingItem = self.layoutEditBuild:Find("EditBuildingItem")
end

return PnlPlayerInformationView
