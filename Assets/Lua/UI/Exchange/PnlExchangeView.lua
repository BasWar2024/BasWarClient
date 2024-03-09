
PnlExchangeView = class("PnlExchangeView")

PnlExchangeView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgBefore = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/imgBefore"):GetComponent("Image")
    self.imgAfter = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/imgAfter"):GetComponent("Image")
    self.txtRate = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/TxtRate"):GetComponent("Text")
    self.txtCost = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/TxtCost"):GetComponent("Text")
    self.txtGet = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/TxtGet"):GetComponent("Text")
    self.txtFull = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/TxtFull"):GetComponent("Text")

    self.slider = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/Slider"):GetComponent("Slider")
    self.sliderHandle = self.slider.transform:Find("Handle Slide Area/Handle").gameObject

    self.btnSub = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/BtnSub").gameObject
    self.btnAdd = transform:Find("Root/LayoutRes/LayoutResContent/LayoutProduct/BtnAdd").gameObject
    self.btnYes = transform:Find("Root/LayoutRes/LayoutResContent/BtnYes").gameObject
    self.txtMit = transform:Find("Root/bgMit/txtMit"):GetComponent("Text")

    self.layoutRes = transform:Find("Root/LayoutRes").gameObject
    self.layoutBtns = transform:Find("Root/LayoutRes/LayoutBtns").gameObject

    self.resMap = {}
    for i = 1, self.layoutBtns.transform.childCount do
        local item = self.layoutBtns.transform:GetChild(i - 1)
        self.resMap[constant[item.name]] = {}
        self.resMap[constant[item.name]].btn = item.gameObject
        self.resMap[constant[item.name]].txt = item:Find("TxtCount"):GetComponent("Text")
        self.resMap[constant[item.name]].img = item:GetComponent("Image")
    end
end

return PnlExchangeView