PnlRoutesView = class("PnlRoutesView")

PnlRoutesView.ctor = function(self, transform)

    self.transform = transform

    self.viewRoute = transform:Find("ViewRoute").gameObject
    self.viewTransport = transform:Find("ViewRoute/ViewTransport").gameObject
    self.viewRecord = transform:Find("ViewRoute/ViewRecord").gameObject
    self.viewChoose = transform:Find("ViewChoose").gameObject

    self.btnClose = transform:Find("ViewRoute/ViewBg/Bg/BtnClose").gameObject
    self.btnTransportHy = transform:Find("ViewRoute/BtnTransportHy").gameObject
    self.btnTransport = transform:Find("ViewRoute/BtnTransport").gameObject
    self.btnRecord = transform:Find("ViewRoute/BtnRecord").gameObject
    self.btnHelp = transform:Find("ViewRoute/ViewBg/Bg/TxtTitle/BtnHelp").gameObject

    self.txtNoWarship = transform:Find("ViewRoute/ViewTransport/BoxWarship/TxtNoWarship"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnWarship = transform:Find("ViewRoute/ViewTransport/BoxWarship/BtnWarship").gameObject
    self.btnReSet = transform:Find("ViewRoute/ViewTransport/BoxWarship/BtnReSet").gameObject
    self.maskWarship = transform:Find("ViewRoute/ViewTransport/BoxWarship/MaskWarship").gameObject
    self.iconWarship = transform:Find("ViewRoute/ViewTransport/BoxWarship/MaskWarship/IconWarship")
        :GetComponent(UNITYENGINE_UI_IMAGE)

        
    self.btnMaxMit = transform:Find("ViewRoute/ViewTransportHy/BoxMit/BtnMaxMit").gameObject
    self.inputFieldMit = transform:Find("ViewRoute/ViewTransportHy/BoxMit/InputFieldMit"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnMaxHydroxyl = transform:Find("ViewRoute/ViewTransportHy/BoxHydroxyl/BtnMaxHydroxyl").gameObject
    self.inputFieldHydroxyl = transform:Find("ViewRoute/ViewTransportHy/BoxHydroxyl/InputFieldHydroxyl"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtFreight = transform:Find("ViewRoute/ViewTransportHy/BoxFreight/TxtFreight"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTltel = transform:Find("ViewRoute/ViewTransportHy/BoxFreight/TxtTltel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTick = transform:Find("ViewRoute/ViewTransportHy/TxtTick"):GetComponent(UNITYENGINE_UI_TEXT)
    self.tipsNeedWarship2 = transform:Find("ViewRoute/ViewTransportHy/TipsNeedWarship2").gameObject

    self.viewTransportHy = transform:Find("ViewRoute/ViewTransportHy").gameObject

    -- self.TxtWithdrowTime = transform:Find("ViewRoute/ViewTransportHy/BoxFreight/TxtWithdrowTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtNft = transform:Find("ViewRoute/ViewTransport/BoxNft/TxtNft"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAddNft = transform:Find("ViewRoute/ViewTransport/BoxNft/Scroll View/Viewport/Content/BtnAddNft").gameObject

    
    self.tipsNeedWarship = transform:Find("ViewRoute/ViewTransport/TipsNeedWarship").gameObject


    self.btnSetOutHY = transform:Find("ViewRoute/ViewTransportHy/BtnSetOutHY").gameObject
    self.btnSetOut = transform:Find("ViewRoute/ViewTransport/BtnSetOut").gameObject

    self.txtTime = transform:Find("ViewRoute/ViewRecord/BoxRecord/txtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMit = transform:Find("ViewRoute/ViewRecord/BoxRecord/txtMit"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHydoxyL = transform:Find("ViewRoute/ViewRecord/BoxRecord/txtHydoxyL"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNft = transform:Find("ViewRoute/ViewRecord/BoxRecord/txtNft"):GetComponent(UNITYENGINE_UI_TEXT)

    self.bgTips = transform:Find("ViewRoute/BgTips").gameObject
    self.btnCloseTip = transform:Find("ViewRoute/BgTips/ViewBg/Bg/BtnCloseTip").gameObject
    self.txtTips1 = transform:Find("ViewRoute/BgTips/TxtTips1"):GetComponent(UNITYENGINE_UI_TEXT)
    
    self.btnConfirm = transform:Find("ViewRoute/BgTips/BtnConfirm").gameObject

    self.hy = self.bgTips.transform:Find("LayoutTransPort/Hy")
    self.txtTipHydroxyl = self.hy:Find("TxtTipHydroxyl"):GetComponent(UNITYENGINE_UI_TEXT)

    self.mit = self.bgTips.transform:Find("LayoutTransPort/Mit")
    self.txtTipMit = self.mit:Find("TxtTipMit"):GetComponent(UNITYENGINE_UI_TEXT)

    self.nft = self.bgTips.transform:Find("LayoutTransPort/Nft")
    self.txtTipNft = self.nft:Find("TxtTipNft"):GetComponent(UNITYENGINE_UI_TEXT)

    self.nftIconTop = transform:Find("ViewChoose/IcomBg/IconTop"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.nftIcon = transform:Find("ViewChoose/IcomBg/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtTitle = transform:Find("ViewChoose/ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnReturn = transform:Find("ViewChoose/ViewBg/Bg/BtnReturn").gameObject
    self.txtLevel = transform:Find("ViewChoose/BgMsg/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtOriLevel = transform:Find("ViewChoose/BgMsg/TxtOriLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtExplain = transform:Find("ViewChoose/BgMsg/TxtOriLevel/BtnOriLevelTips/BgExplain/TxtExplain"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgNameBg = transform:Find("ViewChoose/BgMsg/ImgNameBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("ViewChoose/BgMsg/ImgNameBg/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHash = transform:Find("ViewChoose/BgMsg/ImgNameBg/TxtHash"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attrScrollView = transform:Find("ViewChoose/AttrScrollView")

    self.viewSkill = transform:Find("ViewChoose/ViewSkill").transform
    self.btnSkill1 = transform:Find("ViewChoose/ViewSkill/BtnSkill1").gameObject
    self.btnSkill2 = transform:Find("ViewChoose/ViewSkill/BtnSkill2").gameObject
    self.btnSkill3 = transform:Find("ViewChoose/ViewSkill/BtnSkill3").gameObject
    self.btnSkill4 = transform:Find("ViewChoose/ViewSkill/BtnSkill4").gameObject
    self.btnSkill5 = transform:Find("ViewChoose/ViewSkill/BtnSkill5").gameObject

    self.btnConfirmWarship = transform:Find("ViewChoose/ViewWarship/BtnConfirmWarship").gameObject

    self.btnConfirmNft = transform:Find("ViewChoose/ViewNft/BtnConfirmNft").gameObject
    self.btnSelelcted = transform:Find("ViewChoose/ViewNft/BtnSelelcted").gameObject
    self.btnDesSelelct = transform:Find("ViewChoose/ViewNft/BtnDesSelelct").gameObject
    self.btnOpenFilter = transform:Find("ViewChoose/ViewNft/BtnOpenFilter").gameObject
    self.txtFilter = transform:Find("ViewChoose/ViewNft/BtnOpenFilter/TxtFilter"):GetComponent(UNITYENGINE_UI_TEXT)

    self.leftBtnViewBgBtnsBox = transform:Find("ViewChoose/ViewNft/LeftBtnViewBgBtnsBox").gameObject
end

return PnlRoutesView
