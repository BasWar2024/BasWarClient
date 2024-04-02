FirstChargeBox = FirstChargeBox or class("FirstChargeBox", ggclass.UIBaseItem)

FirstChargeBox.events = {"onRechargeChange"}

function FirstChargeBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function FirstChargeBox:onInit()
    self.itemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "FirstChargeRewardItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.btnCharge = self:Find("BtnCharge")
    self:setOnClick(self.btnCharge, gg.bind(self.onBtnCharge, self))

    self.btnGo = self:Find("BtnGo")
    self:setOnClick(self.btnGo, gg.bind(self.onBtnGo, self))

    self.txtChargeCount = self:Find("TxtDesc/TxtChargeCount", UNITYENGINE_UI_TEXT)
end

function FirstChargeBox:onOpen(...)
    self:onRechargeChange()

    local activityCfg = cfg.giftActivities[constant.FIRST_CHARGE]
    self.rewardDataList = ActivityUtil.getRewardList(cfg.giftReward[activityCfg.reward])

    self.scrollView:setItemCount(#self.rewardDataList)

    -- self.txtChargeCount.text = cfg.global.FirstRecharge.floatValue

    self.txtChargeCount.text = Utils.getText("activity_RechargeTxt3")
end

function FirstChargeBox:onRechargeChange()
    self.isFetch = ActivityData.RechargeData.firstRec == 1

    if not self.isFetch then
        if ActivityData.RechargeData.rechargeVal >= cfg.global.FirstRecharge.floatValue then
            self.btnGo.transform:SetActiveEx(false)
            self.btnCharge.transform:SetActiveEx(true)
        else
            self.btnGo.transform:SetActiveEx(true)
            self.btnCharge.transform:SetActiveEx(false)
            
        end
    else
        self.btnGo.transform:SetActiveEx(false)
        self.btnCharge.transform:SetActiveEx(false)
    end
end

function FirstChargeBox:onBtnCharge()
    ActivityData.C2S_Player_GetRechargeReward(constant.FIRST_CHARGE)
    gg.uiManager:openWindow("PnlTaskReward", {reward = self.rewardDataList})


    -- gg.uiManager:openWindow("PnlRewardSmall", 
    -- {
    --     rewardList =  self.rewardDataList, 
    --     yesCallback = function ()
    --         ActivityData.C2S_Player_GetRechargeReward(constant.FIRST_CHARGE)
    --     end
    -- })
end

function FirstChargeBox:onBtnGo()
    gg.uiManager:openWindow("PnlShop", {shopType = PnlShop.TYPE_TESSRACT_BUY})
end

function FirstChargeBox:onRenderItem(obj, index)
    local item = FirstChargeRewardItem:getItem(obj, self.itemList, self)
    item:setData(self.rewardDataList[index])
end

function FirstChargeBox:onClose()
end

function FirstChargeBox:onRelease()
    self.scrollView:release()
end

---------------------------------------------------------------

FirstChargeRewardItem = FirstChargeRewardItem or class("FirstChargeRewardItem", ggclass.UIBaseItem)

function FirstChargeRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function FirstChargeRewardItem:onInit()

    self.activityRewardItem = ActivityRewardItem.new(self:Find("ActivityRewardItem"))

    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)

    self.bg = self:Find("Bg", UNITYENGINE_UI_IMAGE)
end

function FirstChargeRewardItem:setData(reward)
    self.activityRewardItem:setData(reward)

    gg.setSpriteAsync(self.bg, "ActivityIcon_Atlas[box01_icon]")

    local count = reward.count or 1
    if reward.rewardType == constant.ACTIVITY_REWARD_RES then
        count = Utils.getShowRes(count)
    end

    self.txtCount.text = "X" .. count

end

function FirstChargeRewardItem:onRelease()
    self.activityRewardItem:release()
end

-- function FirstChargeRewardItem:onBtnBuy()

-- end