
PnlPledgeSetView = class("PnlPledgeSetView")

PnlPledgeSetView.ctor = function(self, transform)
    self.transform = transform

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.optionalTopBtnsBox = OptionalTopBtnsBox.new(transform:Find("OptionalTopBtnsBox"))

    self.layoutPledge = transform:Find("LayoutPledge")
    self.slider = transform:Find("LayoutPledge/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.btnYes = transform:Find("LayoutPledge/layoutBtns/BtnYes").gameObject
    self.btnNo = transform:Find("LayoutPledge/layoutBtns/BtnNo").gameObject

    self.btnAdd = self.layoutPledge.transform:Find("BtnAdd").gameObject
    self.btnSub = self.layoutPledge.transform:Find("BtnSub").gameObject

    self.txtAfter = transform:Find("LayoutPledge/LayoutProduct/TxtAfter"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBefore = transform:Find("LayoutPledge/LayoutProduct/TxtBefore"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgArrow = transform:Find("LayoutPledge/LayoutProduct/ImgArrow"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgArrow2 = transform:Find("LayoutPledge/LayoutProduct/ImgArrow2"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtVipLevel = transform:Find("LayoutPledge/LayoutProduct/TxtVipLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputCount = transform:Find("LayoutPledge/LayoutProduct/InputCount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    self.iconAfter = transform:Find("LayoutPledge/LayoutProduct/LayoutChange/IconAfter"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtVipAfter = transform:Find("LayoutPledge/LayoutProduct/LayoutChange/VipAfter/TxtVipAfter"):GetComponent(UNITYENGINE_UI_TEXT)

    self.bgExchangeNeed = transform:Find("LayoutPledge/LayoutProduct/LayoutChange/BgExchangeNeed"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtChangeNeed = transform:Find("LayoutPledge/LayoutProduct/LayoutChange/BgExchangeNeed/TxtChangeNeed"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgExchangeNeed = transform:Find("LayoutPledge/LayoutProduct/LayoutChange/BgExchangeNeed/ImgExchangeNeed"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.imgStake = transform:Find("LayoutPledge/LayoutProduct/ImgStake"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.LayoutResAddition = transform:Find("LayoutPledge/LayoutResAddition")
    self.resAdditionMap = {}
    for i = 1, self.LayoutResAddition.childCount, 1 do
        local trans = self.LayoutResAddition:GetChild(i - 1)
        local item = {}
        item.transform = trans
        item.txtName = trans:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
        item.txtAdd = trans:Find("TxtAdd"):GetComponent(UNITYENGINE_UI_TEXT)
        item.img = trans:Find("Img"):GetComponent(UNITYENGINE_UI_IMAGE)
        item.txtSub = trans:Find("TxtSub"):GetComponent(UNITYENGINE_UI_TEXT)

        if constant[trans.name] then
            self.resAdditionMap[constant[trans.name]] = item
        else
            self.resAdditionMap[trans.name] = item
        end
        -- self.resAdditionList[]
    end

    self.layoutDesc = transform:Find("LayoutDesc")
    self.txtDesc = self.layoutDesc:Find("TxtDesc")

    self.descOutsideScrollView = self.layoutDesc:Find("BgScrollView/ScrollView")
    self.contentOutsideScrollView = self.descOutsideScrollView:Find("Viewport/Content")
    self.layoutLineInside = self.contentOutsideScrollView:Find("LayoutLineInside")
    self.layoutNotes = self.contentOutsideScrollView:Find("LayoutNotes")
    self.descScrollView = self.layoutDesc:Find("BgScrollView/ScrollView/Viewport/Content/DescScrollView")
end

return PnlPledgeSetView