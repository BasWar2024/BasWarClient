
PnlDrawCardView = class("PnlDrawCardView")

PnlDrawCardView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/BtnClose").gameObject
    self.txtStarCoin = transform:Find("ViewFullBg/BoxRes/SratCoin/TxtStarCoin"):GetComponent(UNITYENGINE_UI_TEXT)
    self.slider = transform:Find("ViewFullBg/BoxRes/SratCoin/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtHy = transform:Find("ViewFullBg/BoxRes/Hy/TxtHy"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAddHy = transform:Find("ViewFullBg/BoxRes/Hy/BtnAddHy").gameObject
    self.txtBlueTicket = transform:Find("ViewFullBg/BoxRes/BlueTicket/TxtBlueTicket"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAddBlueTicket = transform:Find("ViewFullBg/BoxRes/BlueTicket/BtnAddBlueTicket").gameObject
    self.txtYellowTicket = transform:Find("ViewFullBg/BoxRes/YellowTicket/TxtYellowTicket"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnAddYellowTicket = transform:Find("ViewFullBg/BoxRes/YellowTicket/BtnAddYellowTicket").gameObject
    self.btn1Time = transform:Find("ViewDrawCard/BoxDownButton/Btn1Time").gameObject
    self.btn10Time = transform:Find("ViewDrawCard/BoxDownButton/Btn10Time").gameObject
    self.btn100Time = transform:Find("ViewDrawCard/BoxDownButton/Btn100Time").gameObject
    self.btnMissage = transform:Find("ViewDrawCard/BtnMissage").gameObject
    self.btnAgain = transform:Find("ViewResult/BtnAgain").gameObject
    self.txtRes = transform:Find("ViewResult/BtnAgain/BgBlack/TxtRes"):GetComponent(UNITYENGINE_UI_TEXT)
    self.bgBlue = transform:Find("ViewDrawCard/BgBlue").gameObject
    self.txtTips = transform:Find("ViewDrawCard/BgBlue/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLimit = transform:Find("ViewDrawCard/BgBlue/TxtTips/TxtLimit"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNum = transform:Find("ViewDrawCard/BgBlue/TxtTips/TxtLimit/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnMessage = transform:Find("ViewDrawCard/BtnMessage").gameObject

    self.bg1 = transform:Find("ViewFullBg/Bg1").gameObject
    self.bg2 = transform:Find("ViewFullBg/Bg2").gameObject
    self.viewDrawCard = transform:Find("ViewDrawCard").gameObject
    self.viewResult = transform:Find("ViewResult").gameObject

    self.boxLeftButton = transform:Find("ViewDrawCard/BoxLeftButton")
    self.content = transform:Find("ViewResult/ScrollView/Viewport/Content")

    self.scrollView = transform:Find("ViewResult/ScrollView")

    self.layoutVideo = gg.uiManager.uiRoot.informationNode:Find("LayoutVideo1")
    self.btnSkip = self.layoutVideo:Find("BtnSkip").gameObject
    self.videoPlayer = self.layoutVideo:Find("VideoPlayer"):GetComponent(typeof(CS.UnityEngine.Video.VideoPlayer))

    self.drawCardResultBox = transform:Find("ViewResult/DrawCardResultBox")

    self.ImgOff = transform:Find("ViewDrawCard/ViewShowCard/TipsBg/Text/ImgOff")
end

return PnlDrawCardView