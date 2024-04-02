AccruingTesBox = AccruingTesBox or class("AccruingTesBox", ggclass.UIBaseItem)

AccruingTesBox.events = {"onFirstGetGridRankChange"}

function AccruingTesBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function AccruingTesBox:onInit()
    self.layoutTitle = self:Find("LayoutTitle").transform

    self.optionalTopBtnsBox = OptionalTopBtnsBox.new(self:Find("OptionalTopBtnsBox")) 

    self.itemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "AccruingTesItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.layoutBuy = self:Find("LayoutTitle/LayoutBuy").transform
    self.txtRebate = self.layoutBuy:Find("TxtDesc/TxtRebate"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnBuy = self.layoutBuy:Find("BtnBuy").gameObject
    self:setOnClick(self.btnBuy, gg.bind(self.onBtnBuy, self))

    self.btnDesc = self:Find("LayoutTitle/BtnDesc").transform
    self:setOnClick(self.btnDesc.gameObject, gg.bind(self.onClickDesc, self))
end

AccruingTesBox.REBATE_100 = 100
AccruingTesBox.REBATE_300 = 300

function AccruingTesBox:onOpen(...)
    self.optionalTopBtnsBox:setBtnDataList({
        {
            nameKey = "activity_Fund_3Times", 
            callback = gg.bind(self.onClickRebate, self, AccruingTesBox.REBATE_100),
            redPointName = RedPointAccruing3Times.__name,
        },

        {
            nameKey = "activity_Fund_5Times", 
            callback = gg.bind(self.onClickRebate, self, AccruingTesBox.REBATE_300),
            redPointName = RedPointAccruing5Times.__name,
        },

    }, 1)

    self.optionalTopBtnsBox:open()
end

function AccruingTesBox:onClickDesc()
    gg.uiManager:openWindow("PnlRule", {title = Utils.getText("activity_RulesTitle"), content = Utils.getText("activity_RulesTxt_Fund")})
end

function AccruingTesBox:onFirstGetGridRankChange()
    self:onClickRebate(self.rebateType)
end

function AccruingTesBox:onClickRebate(rebateType)
    -- print(rebateType)

    self.rebateType = rebateType
    self.dataList = {}
    for key, value in pairs(cfg.cumulativeFunds) do
        if value.cost == rebateType then
            table.insert(self.dataList, value)
        end
    end

    table.sort(self.dataList, function (a, b)
        local dataA = ActivityData.CumulativeFundsData.infoMap[a.cfgId] or {status = 0}
        local dataB = ActivityData.CumulativeFundsData.infoMap[b.cfgId] or {status = 0}

        if dataA.status ~= dataB.status then
            return dataA.status < dataB.status
        end

        return a.baseLevel < b.baseLevel
    end
)

    self.scrollView:setItemCount(#self.dataList)
    local isBuy = false

    if rebateType == AccruingTesBox.REBATE_100 then
        
        if ActivityData.CumulativeFundsData.funds100 == 1 then
            isBuy = true
        else
            self.txtRebate.text = 3
        end

    elseif rebateType == AccruingTesBox.REBATE_300 then
        if ActivityData.CumulativeFundsData.funds300 == 1 then
            isBuy = true
        else
            self.txtRebate.text = 7
        end
    end

    self.layoutBuy:SetActiveEx(not isBuy)
end

function AccruingTesBox:onRenderItem(obj, index)
    local item = AccruingTesItem.new(obj, self.itemList)
    item:setData(self.dataList[index])
end

function AccruingTesBox:onBtnBuy()
    local productId = cfg.giftActivities[constant.CUMULATIVE_FUNDS].productTrigger[tostring(self.rebateType)]
    ShopUtil.buyProduct(productId)
end

function AccruingTesBox:onClose()
    self.optionalTopBtnsBox:close()
end

function AccruingTesBox:onRelease()
    self.scrollView:release()
end

---------------------------------------

AccruingTesItem = AccruingTesItem or class("AccruingTesItem", ggclass.UIBaseItem)

function AccruingTesItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function AccruingTesItem:onInit()
    self.txtProgress = self:Find("TxtProgress", UNITYENGINE_UI_TEXT)
    self.sliderProgress = self:Find("SliderProgress", UNITYENGINE_UI_SLIDER)

    self.btnFetch = self:Find("BtnFetch")
    self:setOnClick(self.btnFetch, gg.bind(self.onBtnFetch, self))

    self.txtFetch = self:Find("TxtFetch", UNITYENGINE_UI_TEXT)

    self.btnGo = self:Find("BtnGo")
    self:setOnClick(self.btnGo, gg.bind(self.onBtnGo, self))

    self.layoutReward = self:Find("LayoutReward").transform

    self.rewardItemList = {}
    for i = 1, self.layoutReward.childCount, 1 do
        local item = AccruingTesRewardItem.new(self.layoutReward:GetChild(i - 1))
        table.insert(self.rewardItemList, item)
    end
end

function AccruingTesItem:setData(data)
    self.data = data
    local baseLevel = gg.buildingManager:getBaseLevel()
    self.txtProgress.text = math.min(data.baseLevel, baseLevel) .. "/" .. data.baseLevel
    self.sliderProgress.value = baseLevel / data.baseLevel

    local fundsData = {cfgId = data.cfgId, status = 0}
    for key, value in pairs(ActivityData.CumulativeFundsData.info) do
        if value.cfgId == data.cfgId then
            fundsData = value
        end
    end

    self.btnFetch:SetActiveEx(false)
    self.txtFetch.transform:SetActiveEx(false)

    if fundsData.status == 1 then
        self.txtFetch.transform:SetActiveEx(true)
    else
        if baseLevel >= self.data.baseLevel then
            self.btnFetch:SetActiveEx(true)
        end
    end

    local rewardList = ActivityUtil.getRewardList(cfg.giftReward[data.reward])
    self.rewardList = rewardList
    for index, value in ipairs(self.rewardItemList) do
        if rewardList[index] then
            value.transform:SetActiveEx(true)
            value:setData(rewardList[index])
        else
            value.transform:SetActiveEx(false)
        end
    end

    if data.cost == AccruingTesBox.REBATE_100 then
        self.isBuy = ActivityData.CumulativeFundsData.funds100 == 1
    elseif data.cost == AccruingTesBox.REBATE_300 then
        self.isBuy = ActivityData.CumulativeFundsData.funds300 == 1
    end

    if not self.isBuy then
        EffectUtil.setGray(self.gameObject, true, true)
    else
        EffectUtil.setGray(self.gameObject, false, true)
    end
end

function AccruingTesItem:onBtnFetch()
    if self.isBuy and gg.buildingManager:getBaseLevel() >= self.data.baseLevel then

        gg.uiManager:openWindow("PnlTaskReward", {reward = self.rewardList})

        ActivityData.C2S_Player_GetCumulativeFunds(self.data.cfgId)
    end
end

function AccruingTesItem:onBtnGo()

end

function AccruingTesItem:onRelease()
    for key, value in pairs(self.rewardItemList) do
        value:release()
    end
end

---------------------------------------

AccruingTesRewardItem = AccruingTesRewardItem or class("AccruingTesRewardItem", ggclass.UIBaseItem)

function AccruingTesRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function AccruingTesRewardItem:onInit()
    self.activityRewardItem = ActivityRewardItem.new(self:Find("ActivityRewardItem"))

    self.bgCost = self:Find("bgCost")
    self.txtReward = self:Find("bgCost/TxtReward", UNITYENGINE_UI_TEXT)
end

function AccruingTesRewardItem:setData(reward)
    self.activityRewardItem:setData(reward)

    if reward.count then
        self.bgCost:SetActiveEx(true)
        if reward.rewardType == constant.ACTIVITY_REWARD_RES then
            self.txtReward.text = "X" .. Utils.getShowRes(reward.count)
        else
            self.txtReward.text = "X" .. reward.count
        end
    else
        self.bgCost:SetActiveEx(false)
    end
end
