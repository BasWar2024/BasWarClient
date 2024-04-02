
PnlShopView = class("PnlShopView")

PnlShopView.ctor = function(self, transform)

    self.transform = transform

    self.layoutWait = transform:Find("LayoutWait")

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject

    self.commonResBox2 = transform:Find("Root/CommonResBox2")

    self.fullViewOptionBtnBox = transform:Find("Root/FullViewOptionBtnBox")

    self.layoutMoonCard = transform:Find("Root/LayoutMoonCard")
    self.moonCardBox = self.layoutMoonCard:Find("MoonCardBox")

    self.layoutBuyTessract = transform:Find("Root/LayoutBuyTessract")
    self.tessractScrollView = self.layoutBuyTessract:Find("TessractScrollView")

    self.layoutExchange = transform:Find("Root/LayoutExchange")

    self.layoutExchangeBtns = self.layoutExchange:Find("LayoutExchangeBtns")
    self.imgLine = self.layoutExchange:Find("ImgLine")

    self.resMap = {}
    for i = 1, self.layoutExchangeBtns.childCount do
        local item = self.layoutExchangeBtns:GetChild(i - 1)
        self.resMap[constant[item.name]] = {}
        self.resMap[constant[item.name]].btn = item.gameObject
        self.resMap[constant[item.name]].imgNotChoose = item:Find("ImgNotChoose")
        self.resMap[constant[item.name]].imgChoose = item:Find("ImgChoose")
    end

    self.layoutResContent = self.layoutExchange:Find("LayoutResContent")
    self.layoutProduct = self.layoutResContent:Find("LayoutProduct")
    self.imgBefore = self.layoutProduct:Find("imgBefore"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgAfter = self.layoutProduct:Find("imgAfter"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtRate = self.layoutProduct:Find("TxtRate"):GetComponent(UNITYENGINE_UI_TEXT)

    self.slider = self.layoutProduct:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)

    self.inputCost = self.layoutProduct:Find("InputCost"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputGet = self.layoutProduct:Find("InputGet"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    self.commonAddCountBox = self.layoutProduct:Find("CommonAddCountBox")

    self.textCostTitle = self.layoutProduct:Find("TextCostTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.textGetTitle = self.layoutProduct:Find("TextGetTitle"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnExchange = self.layoutResContent:Find("BtnExchange").gameObject
    
    self.layoutBuildQueue = transform:Find("Root/LayoutBuildQueue")
    self.buildQueueBox = self.layoutBuildQueue:Find("BuildQueueBox")

    self.layoutAuditMoonCard = transform:Find("Root/LayoutAuditMoonCard")
    self.auditMoonCardBox = self.layoutAuditMoonCard:Find("AuditMoonCardBox")
end

return PnlShopView