MoonCardBox = MoonCardBox or class("MoonCardBox", ggclass.UIBaseItem)

MoonCardBox.events = {"onMoonCardChange"}

function MoonCardBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function MoonCardBox:onInit()
    self.buyRewardItemList = {}
    self.buyRewardScrollView = UIScrollView.new(self:Find("BuyRewardScrollView"), "MoonCardRewardItem", self.buyRewardItemList)
    self.buyRewardScrollView:setRenderHandler(gg.bind(self.onRenderBuyItem, self))

    self.dailyRewardItemList = {}
    self.dailyRewardScrollView = UIScrollView.new(self:Find("DailyRewardScrollView"), "MoonCardRewardItem", self.dailyRewardItemList)
    self.dailyRewardScrollView:setRenderHandler(gg.bind(self.onRenderDailyItem, self))

    self.btnBuyList = {}
    for i = 1, 3, 1 do
        self.btnBuyList[i] = {}
        self.btnBuyList[i].btn = self:Find("BtnBuy" .. i)
        local transform = self.btnBuyList[i].btn.transform
        self.btnBuyList[i].txtBuyDesc = transform:Find("TxtBuyDesc"):GetComponent(UNITYENGINE_UI_TEXT)
        self.btnBuyList[i].txtBuy = transform:Find("TxtBuy"):GetComponent(UNITYENGINE_UI_TEXT)
        self.btnBuyList[i].txtVipLessTime = transform:Find("TxtVipLessTime"):GetComponent(UNITYENGINE_UI_TEXT)
        self:setOnClick(self.btnBuyList[i].btn, gg.bind(self.onBtnBuy, self, i))
    end

    self.moonCardOptionBtns = MoonCardOptionBtns.new(self:Find("MoonCardOptionBtns"))
    self.btnDataList = {}

    for i = 1, 3, 1 do
        local value = cfg.supplyPack[i]
        table.insert(self.btnDataList, {
            name = value.duration .. "days", --Utils.g-etText("shop_SomeDay"),
            callback = gg.bind(self.onBtnOptions, self, i, value),
        }
    )
    end

    -- for index, value in ipairs(cfg.supplyPack) do
    --     table.insert(self.btnDataList, {
    --             name = value.duration .. "days", --Utils.getText("shop_SomeDay"),
    --             callback = gg.bind(self.onBtnOptions, self, index, value),
    --         }
    --     )
    -- end

    self.moonCardOptionBtns:setBtnDataList(self.btnDataList, 1)

    self.txtValidityPeriod = self:Find("TxtValidityPeriod", UNITYENGINE_UI_TEXT)
    self.txtDay = self:Find("TxtValidityPeriod/TxtDay", UNITYENGINE_UI_TEXT)
    self.btnDesc = self:Find("BtnDesc")
    self:setOnClick(self.btnDesc, gg.bind(self.onBtnDesc, self))
end

function MoonCardBox:onOpen(...)
    self.giftActivityCfg = cfg.giftActivities[constant.MOON_CARD]
    self.dailyRewardDataList = ActivityUtil.getRewardList(cfg.giftReward[self.giftActivityCfg.reward])
    self.dailyRewardScrollView:setItemCount(#self.dailyRewardDataList)

    -- self.productId = self.giftActivityCfg.productTrigger["1999"]

    for i = 1, 3, 1 do
        local subSupplyPackCfg = cfg.supplyPack[i]
        local productCfg = ShopUtil.getProduct(subSupplyPackCfg.product)
        local btn = self.btnBuyList[i]
        btn.txtBuy.text = "$" .. productCfg.price
        btn.txtVipLessTime.text = string.format(Utils.getText("shop_ValidFor"), subSupplyPackCfg.duration)
    end

    self:refresh()
end

function MoonCardBox:onBtnOptions(index, supplyPackCfg)
    for key, value in pairs(self.btnBuyList) do
        value.btn:SetActiveEx(key == index)
    end

    -- local supplyPackCfg = cfg.supplyPack[1]
    self.buyRewardDataList = ShopUtil.parseProductReward(supplyPackCfg.product)
    self.buyRewardScrollView:setItemCount(#self.buyRewardDataList)
end

function MoonCardBox:onClose()

end

function MoonCardBox:refresh()
    self.txtDay.text = ActivityData.MoonCard.day

    local isShowBuyDesc = ActivityData.MoonCard and ActivityData.MoonCard.day > 0
    for i = 1, 3, 1 do
        self.btnBuyList[i].txtBuyDesc.transform:SetActiveEx(isShowBuyDesc)
    end

    self.txtValidityPeriod:SetActiveEx(isShowBuyDesc)
end

function MoonCardBox:onMoonCardChange()
    self:refresh()
end

function MoonCardBox:onRelease()
    self.buyRewardScrollView:release()
    self.dailyRewardScrollView:release()
end

function MoonCardBox:onRenderBuyItem(obj, index)
    local item = MoonCardRewardItem.new(obj, self.buyRewardItemList)
    item:setData(self.buyRewardDataList[index])
end

function MoonCardBox:onRenderDailyItem(obj, index)
    local item = MoonCardRewardItem.new(obj, self.dailyRewardItemList)
    item:setData(self.dailyRewardDataList[index])
end

function MoonCardBox:onBtnBuy(index)
    local supplyPackCfg = cfg.supplyPack[index]

    local product = supplyPackCfg.product
    if IsAuditVersion() then
        product = string.lower(product)
    end

    ShopUtil.buyProduct(product)
end

function MoonCardBox:onBtnDesc()
    gg.uiManager:openWindow("PnlDesc", {title = Utils.getText("shop_MonthCardInfo_Title"), desc = Utils.getText("shop_MonthCard_Txt")})
end

---------------------------------------

MoonCardRewardItem = MoonCardRewardItem or class("MoonCardRewardItem", ggclass.UIBaseItem)

function MoonCardRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function MoonCardRewardItem:onInit()
    self.activityRewardItem = ActivityRewardItem.new(self:Find("ActivityRewardItem"))

    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
end

function MoonCardRewardItem:setData(reward)
    self.activityRewardItem:setData(reward)

    local count = reward.count or 1
    if reward.rewardType == constant.ACTIVITY_REWARD_RES then
        count = Utils.getShowRes(count)
    end

    self.txtCount.text = count
end

function MoonCardRewardItem:onRelease()
    self.activityRewardItem:release()
end

--------------------------------------------

MoonCardOptionBtns = MoonCardOptionBtns or class("MoonCardOptionBtns", ggclass.CommonBtnsBox)

function MoonCardOptionBtns:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function MoonCardOptionBtns:onGetBtnItem(item)
    item.imgNotChoose = item.transform:Find("ImgNotChoose").transform
    item.text1 = item.imgNotChoose:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    item.imgChoose = item.transform:Find("ImgChoose").transform
    item.text2 = item.imgChoose:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
end

-- dataList = {{name = , callback = , redPointName, activityCfgId}}
function MoonCardOptionBtns:onSetBtnData(item, data)
    item.text1.text = data.name
    item.text2.text = data.name
end

function MoonCardOptionBtns:onSetBtnStageWithoutNotify(item, isSelect, index)
    item.imgChoose.transform:SetActiveEx(isSelect)
end