LimitTimeGoodsBox = LimitTimeGoodsBox or class("LimitTimeGoodsBox", ggclass.UIBaseItem)

LimitTimeGoodsBox.events = {"onShoppingMailChange"}

function LimitTimeGoodsBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function LimitTimeGoodsBox:onInit()

    self.txtTimes = self:Find("LayoutRefreshTime/TxtRefreshTimes/TxtTimes", UNITYENGINE_UI_TEXT)

    self.btnRefreshTimes = self:Find("LayoutRefreshTime/TxtRefreshTimes/TxtTimes/BtnRefreshTimes")
    self:setOnClick(self.btnRefreshTimes, gg.bind(self.onBtnRefreshTimes, self))

    self.txtRefreshCost = self:Find("LayoutRefreshTime/TxtRefreshTimes/TxtTimes/BtnRefreshTimes/TxtRefreshCost"):GetComponent(UNITYENGINE_UI_TEXT)

    self.itemList = {}
    -- self.scrollView = UILoopScrollView.new(self:Find("ScrollView"), self.itemList)
    -- self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.limitTimeGoodsItems = self:Find("LimitTimeGoodsItems").transform

    -- local childNum = self.limitTimeGoodsItems.childCount
    for i = 1, self.limitTimeGoodsItems.childCount, 1 do
        local item = LimitTimeGoodsItem.new(self.limitTimeGoodsItems:GetChild(i - 1), self)
        table.insert(self.itemList, item)
        -- resTran:GetChild(i).gameObject:SetActive(false)
    end


    self.layoutProduct = self:Find("LayoutProduct").transform
    self.imgIcon = self.layoutProduct:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtTitle = self.layoutProduct:Find("BgTitle/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCount = self.layoutProduct:Find("TxtTitleCount/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDesc = self.layoutProduct:Find("TxtDescScrollView/Viewport/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutBuy = self.layoutProduct:Find("LayoutBuy").transform
    self.btnBuy = self.layoutBuy:Find("BtnBuy").gameObject
    self:setOnClick(self.btnBuy, gg.bind(self.onBtnBuy, self))

    self.txtCost = self.layoutBuy:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCost2 = self.layoutBuy:Find("TxtCost2"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtLessTime = self:Find("LayoutRefreshTime/TxtRefreshTimes/ImgLessTime/TxtLessTime", UNITYENGINE_UI_TEXT)

    self.btnDesc = self:Find("LayoutRefreshTime/BtnDesc")
    self:setOnClick(self.btnDesc.gameObject, gg.bind(self.onClickDesc, self))
end

local itemCountPerLine = 4

function LimitTimeGoodsBox:onOpen(...)
    PlayerData.C2S_Player_PayChannelInfo()
    self:onShoppingMailChange()
end

function LimitTimeGoodsBox:onClickDesc()
    gg.uiManager:openWindow("PnlRule", {title = Utils.getText("activity_RulesTitle"), content = Utils.getText("activity_RulesTxt_LimitedShop")})
end

function LimitTimeGoodsBox:onShoppingMailChange()
    self:startTimer()

    local refreshCount = ActivityData.ShoppingMallData.freshNum - 1
    self.txtTimes.text = refreshCount .. "/" .. cfg.global.flushShoppingMallNum.intValue
    self.dataList = ActivityData.ShoppingMallData.data

    for index, value in ipairs(self.dataList) do
        if self.selectData then
            if self.selectData.index == value.index then
                self:selectItem(value)
                break
            end

        elseif value.num > 0 then
            self:selectItem(value)
            break
        end
    end

    -- table.sort(self.dataList, function (a, b)
    --     -- if (a.num <= 0 or b.num <= 0) and a.num ~= b.num then
    --     --     return a.num > b.num
    --     -- end
    --     return a.index < b.index
    -- end)

    table.sort(self.dataList, function (a, b)
        local shopCfgA = cfg.shoppingMall[a.cfgId]
        local shopCfgB = cfg.shoppingMall[b.cfgId]

        -- group

        local groupA = shopCfgA.group or 0
        local groupB = shopCfgB.group or 0

        if groupA ~= groupB then
            return groupA < groupB
        end

        if shopCfgA.type ~= shopCfgB.type then
            return shopCfgA.type < shopCfgB.type
        end

        local discountA = shopCfgA.discount or 1
        local discountB = shopCfgB.discount or 1

        return discountA < discountB
    end)

    if not self.selectData then
        self:selectItem(self.dataList[1])
    end
    
    -- local itemCount = math.ceil(#self.dataList / itemCountPerLine)
    -- self.scrollView:setDataCount(itemCount)
    for index, value in ipairs(self.itemList) do
        value:setData(self.dataList[index])
    end

    local tableValue = cfg.global.FlushShoppingMallCost.tableValue
    local dataCount = #tableValue

    local costCfg =  tableValue[math.min(ActivityData.ShoppingMallData.freshNum, dataCount)]

    -- local resId = costCfg[1]
    local cost = costCfg[2]
    self.txtRefreshCost.text = Utils.getShowRes(cost)
end

function LimitTimeGoodsBox:startTimer()
    gg.timer:stopTimer(self.timer)
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = ActivityData.ShoppingMallData.overTimes - Utils.getServerSec()
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, time)
        self.txtLessTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)

        if time <= 0 then
            self.txtLessTime.text = string.format("%s:%s:%s", 0, 0, 0)
            gg.timer:stopTimer(self.timer)
        end
    end)
end

function LimitTimeGoodsBox:onRenderItem(obj, index)
    for i = 1, itemCountPerLine, 1 do
        local idx = (index - 1) * itemCountPerLine + i
        local item = LimitTimeGoodsItem:getItem(obj.transform:GetChild(i - 1), self.itemList, self)
        item:setData(self.dataList[idx])
    end
end

function LimitTimeGoodsBox:selectItem(data)
    self.selectData = data

    for key, value in pairs(self.itemList) do
        value:refreshSelect()
    end

    local shopCfg = cfg.shoppingMall[data.cfgId]
    

    -- self.txtTitle.text = shopCfg.name
    self.txtTitle.text = Utils.getText(shopCfg.name)
    -- self.txtCost.text = Utils.getShowRes(shopCfg.price)

    self.txtCost.transform:SetActiveEx(false)
    self.txtCost2.transform:SetActiveEx(false)
    if shopCfg.type == 101 then
        self.txtCost.transform:SetActiveEx(true)
        self.txtCost.text = Utils.getShowRes(shopCfg.price)
    elseif shopCfg.type == 102 then
        self.txtCost2.transform:SetActiveEx(true)
        local product = ShopUtil.getProduct(shopCfg.productId)
        self.txtCost2.text = product.price .. "$"
        -- self.txtCost2.text = shopCfg.price .. "$"
    end

    local itemCfg = cfg.item[shopCfg.item]
    local icon, count, name, quality
    if itemCfg.isShowReadEffect == 1 then
        self.rewardList = ShopUtil.parseItemEffect(shopCfg.item)
        icon, count, name, quality = ShopUtil.parseReward(self.rewardList[1])
    else
        icon = ItemUtil.getItemIcon(shopCfg.item)
        count = 1
        quality = itemCfg.quality
    end

    -- local rewardList = ShopUtil.parseItemEffect(shopCfg.item)
    -- local reward = rewardList[1]
    -- local icon, count, name = ShopUtil.parseReward(reward)

    -- local itemCfg = cfg.item[shopCfg.item]
    -- local icon = ItemUtil.getItemIcon(shopCfg.item)
    -- local count = 1
    -- local quality = itemCfg.quality

    gg.setSpriteAsync(self.imgIcon, icon)
    self.txtCount.text = count

    -- local resInfo =  constant.RES_2_CFG_KEY[reward.resId]

    if shopCfg.desc == "activity_BuyResource_Desc" then
        self.txtDesc.text = string.format(Utils.getText(shopCfg.desc), count, name)
    else
        self.txtDesc.text = Utils.getText(shopCfg.desc)
    end

    self.layoutBuy:SetActiveEx(self.selectData.num > 0)
    -- if self.selectData.num > 0 then
    --     self.btnBuy:SetActiveEx(true)
    --     self.txtCost.transform:SetActiveEx(true)
    --     self.txtCost2.transform:SetActiveEx(true)
    -- else
    --     self.btnBuy:SetActiveEx(false)
    --     self.txtCost.transform:SetActiveEx(false)
    -- end
end

function LimitTimeGoodsBox:onBtnBuy()
    if self.selectData.num > 0 then
        local shopCfg = cfg.shoppingMall[self.selectData.cfgId]
        if shopCfg.type == 101 then
            ActivityData.C2S_Player_BuyGoods(self.selectData.index)
        else
            ShopUtil.buyProduct(shopCfg.productId)
        end

    else
        gg.uiManager:showTip("not enought buy count")
    end
end

function LimitTimeGoodsBox:onBtnRefreshTimes() 
    local tableValue = cfg.global.FlushShoppingMallCost.tableValue
    local dataCount = #tableValue

    local refreshCount = ActivityData.ShoppingMallData.freshNum - 1
    if refreshCount >= cfg.global.flushShoppingMallNum.intValue then
        gg.uiManager:showTip("max refresh time")
        return
    end

    local costCfg = tableValue[math.min(ActivityData.ShoppingMallData.freshNum, dataCount)]

    local resId = costCfg[1]
    local cost = costCfg[2]

    local args = {
        title = Utils.getText("universal_Ask_Title"),
        btnType = PnlAlert.BTN_TYPE_SINGLE,
        txt = string.format(Utils.getText("universal_Ask_RefreshItems"), 
            Utils.getShowRes(costCfg[2]), Utils.getText(constant.RES_2_CFG_KEY[resId].languageKey))    --"refresh goods",
    }
    args.callbackYes = function()
        ActivityData.C2S_Player_FreshShoppingMall()
    end
    args.yesCostList = {{
        cost = cost,
        resId = resId,
    }}

    args.callbackNo = function()
    end
    gg.uiManager:openWindow("PnlAlert", args)
end

function LimitTimeGoodsBox:onClose()
    gg.timer:stopTimer(self.timer)
end

function LimitTimeGoodsBox:onRelease()
    -- self.scrollView:release()
    gg.timer:stopTimer(self.timer)

    for key, value in pairs(self.itemList) do
        value:release()
    end
end

---------------------------------------------------------------

LimitTimeGoodsItem = LimitTimeGoodsItem or class("LimitTimeGoodsItem", ggclass.UIBaseItem)

function LimitTimeGoodsItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function LimitTimeGoodsItem:onInit()
    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)
    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)
    self.imgBg = self:Find("ImgBg", UNITYENGINE_UI_IMAGE)
    self.bg = self:Find("Bg", UNITYENGINE_UI_IMAGE)

    self.imgIcon = self:Find("ImgBg/Mask/ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)

    self.layoutCost = self:Find("LayoutCost").transform
    self.imgLayoutCost = self.layoutCost:GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtCost = self.layoutCost:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgCost = self.layoutCost:Find("TxtCost/ImgCost"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtCost2 = self.layoutCost:Find("TxtCost2"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutDiscount = self:Find("LayoutDiscount").transform
    self.txtDiscount = self.layoutDiscount:Find("TxtDiscount"):GetComponent(UNITYENGINE_UI_TEXT)

    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function LimitTimeGoodsItem:setData(data)
    self.data = data
    if not data then
        self.transform:SetActiveEx(false)
        return
    end

    self.transform:SetActiveEx(true)
    EffectUtil.setGray(self.gameObject, data.num <= 0, true)

    local shopCfg = cfg.shoppingMall[data.cfgId]
    self.txtTitle.text = Utils.getText(shopCfg.name)
    
    self.txtCost.transform:SetActiveEx(false)
    self.txtCost2.transform:SetActiveEx(false)

    -- shopCfg.type = 102
    if shopCfg.type == 101 then
        self.txtCost.transform:SetActiveEx(true)
        self.txtCost.text = Utils.getShowRes(shopCfg.price)
    elseif shopCfg.type == 102 then

        local product = ShopUtil.getProduct(shopCfg.productId)
        self.txtCost2.transform:SetActiveEx(true)
        self.txtCost2.text = product.price .. "$"
    end

    local itemCfg = cfg.item[shopCfg.item]
    local icon, count, name, quality
    if itemCfg.isShowReadEffect == 1 then
        self.rewardList = ShopUtil.parseItemEffect(shopCfg.item)
        icon, count, name, quality = ShopUtil.parseReward(self.rewardList[1])
    else
        icon = ItemUtil.getItemIcon(shopCfg.item)
        count = 1
        quality = itemCfg.quality
    end
    
    -- 
    -- local icon, count, name, quality = ShopUtil.parseReward(self.rewardList[1])

    local discount = shopCfg.discount or 1

    if quality >= 3 or discount <= 0.1 or shopCfg.group then
        gg.setSpriteAsync(self.bg, string.format("ActivityIcon_Atlas[box02_icon]", quality))
        gg.setSpriteAsync(self.imgLayoutCost, string.format("ActivityIcon_Atlas[select03_icon]", quality))
    else
        gg.setSpriteAsync(self.bg, string.format("ActivityIcon_Atlas[box01_icon]", quality))
        gg.setSpriteAsync(self.imgLayoutCost, string.format("ActivityIcon_Atlas[select02_icon]", quality))
    end
    
    if discount < 1 then
        self.layoutDiscount:SetActiveEx(true)
        local discount = (1 - discount) * 100 + 0.5
        self.txtDiscount.text = math.floor(discount)  .. "%"
    else
        self.layoutDiscount:SetActiveEx(false)
    end

    gg.setSpriteAsync(self.imgBg, string.format("Item_Bg_Atlas[Item_Bg_%s]", quality))
    gg.setSpriteAsync(self.imgIcon, icon)
    self.txtCount.text = "X" .. count

    self:refreshSelect()
end

function LimitTimeGoodsItem:refreshSelect()
    self.imgSelect:SetActiveEx(self.data == self.initData.selectData)
end

function LimitTimeGoodsItem:onBtnItem()
    self.initData:selectItem(self.data)
end

function LimitTimeGoodsItem:onRelease()

end
