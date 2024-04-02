AuditMoonCardBox = AuditMoonCardBox or class("AuditMoonCardBox", ggclass.UIBaseItem)

AuditMoonCardBox.events = {"onStarPackChange"}

function AuditMoonCardBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function AuditMoonCardBox:onInit()
    self.buyRewardItemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "AuditMoonCardItem", self.buyRewardItemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function AuditMoonCardBox:onOpen(...)
    self:refresh()
end

function AuditMoonCardBox:refresh()
    self.dataList = cfg.starPack
    self.scrollView:setItemCount(#self.dataList)
end


function AuditMoonCardBox:onClose()

end

function AuditMoonCardBox:onRenderItem(obj, index)
    local item = AuditMoonCardItem:getItem(obj, self.buyRewardItemList)
    item:setData(self.dataList[index])
end

function AuditMoonCardBox:onStarPackChange()
    self:refresh()
end

function AuditMoonCardBox:onRelease()
    self.scrollView:release()
end

-----------------------------------------------

AuditMoonCardItem = AuditMoonCardItem or class("AuditMoonCardItem", ggclass.UIBaseItem)
function AuditMoonCardItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
    self.initData = initData
end

function AuditMoonCardItem:onInit()
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

    self.txtDay = self:Find("TxtDay", UNITYENGINE_UI_TEXT)
    self.txtLessDay = self:Find("TxtLessDay", UNITYENGINE_UI_TEXT)

    self.imgDiscount = self:Find("ImgDiscount", UNITYENGINE_UI_IMAGE)
end

AuditMoonCardItem.PRICE_2_DISCOUNT = {
    ["gb.tesseract.99"] = nil,
    ["gb.tesseract.499"] = nil,
    ["gb.tesseract.999"] = nil,
    ["gb.tesseract.2999"] = "ShopIcon_Atlas[precent_1]",
    ["gb.tesseract.4999"] = "ShopIcon_Atlas[precent_2]",
    ["gb.tesseract.9999"] = "ShopIcon_Atlas[precent_3]",
}

AuditMoonCardItem.PRODUCT_2_STARCOIN = {
    ["gb.starpack.2000"] = 20000,
    ["gb.starpack.5000"] = 60000,
}

function AuditMoonCardItem:setData(data)
    self.data = data

    local productCfg = ShopUtil.getProduct(data.product)

    self.txtDay.text = data.duration .. " days"

    local starPackData = ShopData.starPackMap[data.cfgId] or {cfgId = data.cfgId, day = 0}

    self.txtLessDay.text = string.format(Utils.getText("shop_ValidFor"), starPackData.day)

    -- btn.txtVipLessTime.text = string.format(Utils.getText("shop_ValidFor"), subSupplyPackCfg.duration)


    local imgDiscount = AuditMoonCardItem.PRICE_2_DISCOUNT[productCfg.productId]
    if imgDiscount then
        gg.setSpriteAsync(self.imgDiscount, imgDiscount)
    else
        self.imgDiscount:SetActiveEx(false)
    end

    self.txtTitle.text = Utils.getText(productCfg.name)
    self.txtBuy.text = "$" .. productCfg.price
    
    

    local rewardList = ActivityUtil.getRewardList(cfg.giftReward[data.rewardCfgId])

    -- print("rrrrrrrrrrrrrrrrr")
    -- gg.printData(rewardList, "tttttttttttttttttttttt")

    self.txtCount.text = "X" .. Utils.getShowRes(rewardList[1].count)

    local isDouble = false

    if ActivityData.DoubelRecharge[productCfg.productId] then
        isDouble = true
    end

    if isDouble then
        self.imgDouble:SetActiveEx(true)
    else
        self.imgDouble:SetActiveEx(false)
    end

    gg.setSpriteAsync(self.imgIcon, string.format("ShopIcon_Atlas[%s]", productCfg.icon))
end

function AuditMoonCardItem:onBtnBuy()
    -- -- print("onBtnBuy")
    -- if CS.Appconst.platform ~= constant.PAYCHANNEL_APPSTORE and platform ~= constant.PAYCHANNEL_GOOGLEPLAY then
    --     local args = {
    --         productId = self.data.productId
    --     }
    --     gg.uiManager:openWindow("PnlPay", args)
    -- else
    --     ShopUtil.buyProduct(self.data.productId)
    -- end
    ShopUtil.buyProduct(self.data.product)
end
