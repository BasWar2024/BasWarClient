ShopTessractItem = ShopTessractItem or class("ShopTessractItem", ggclass.UIBaseItem)
function ShopTessractItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
    self.initData = initData
end

function ShopTessractItem:onInit()
    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)

    self.imgDouble = self:Find("ImgDouble", UNITYENGINE_UI_IMAGE)

    self.imgIcon = self:Find("ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)

    self.btnBuy = self:Find("BtnBuy")
    self:setOnClick(self.btnBuy, gg.bind(self.onBtnBuy, self))

    self.txtBuy = self.btnBuy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    -- self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    -- self.txtTrainCount = self:Find("LayoutInfo/TxtTrainCount", "Text")
    -- self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))

    self.imgDiscount = self:Find("ImgDiscount", UNITYENGINE_UI_IMAGE)
end

ShopTessractItem.PRICE_2_DISCOUNT = {
    ["gb.tesseract.99"] = nil,
    ["gb.tesseract.499"] = nil,
    ["gb.tesseract.999"] = nil,
    ["gb.tesseract.2999"] = "ShopIcon_Atlas[precent_1]",
    ["gb.tesseract.4999"] = "ShopIcon_Atlas[precent_2]",
    ["gb.tesseract.9999"] = "ShopIcon_Atlas[precent_3]",
}

function ShopTessractItem:setData(data)
    self.data = data

    local imgDiscount = ShopTessractItem.PRICE_2_DISCOUNT[data.productId]
    if imgDiscount then
        gg.setSpriteAsync(self.imgDiscount, imgDiscount)
    else
        self.imgDiscount:SetActiveEx(false)
    end

    -- gg.printData(data)
    self.txtTitle.text = Utils.getText(data.name)
    self.txtBuy.text = "$" .. data.price
    

    if data.name == "starPack_MonthCard" then
        self.txtCount.text = ""
    else
        self.txtCount.text = "X" .. math.floor(data.value / 1000)
    end

    local isDouble = false

    if ActivityData.DoubelRecharge[data.productId] then
        isDouble = true
    end

    if isDouble then
        self.imgDouble:SetActiveEx(true)
    else
        self.imgDouble:SetActiveEx(false)
    end

    gg.setSpriteAsync(self.imgIcon, string.format("ShopIcon_Atlas[%s]", data.icon))
end

function ShopTessractItem:onBtnBuy()
    -- -- print("onBtnBuy")
    -- if CS.Appconst.platform ~= constant.PAYCHANNEL_APPSTORE and platform ~= constant.PAYCHANNEL_GOOGLEPLAY then
    --     local args = {
    --         productId = self.data.productId
    --     }
    --     gg.uiManager:openWindow("PnlPay", args)
    -- else
    --     ShopUtil.buyProduct(self.data.productId)
    -- end
    ShopUtil.buyProduct(self.data.productId)
end
