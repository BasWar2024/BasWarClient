OpenAccruingChargeBox = OpenAccruingChargeBox or class("OpenAccruingChargeBox", ggclass.UIBaseItem)

OpenAccruingChargeBox.events = {"onRechargeChange"}

function OpenAccruingChargeBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function OpenAccruingChargeBox:onInit()
    self.itemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "FirstChargeRewardItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.btnCharge = self:Find("BtnCharge")
    self:setOnClick(self.btnCharge, gg.bind(self.onBtnCharge, self))

    self.btnGo = self:Find("BtnGo")
    self:setOnClick(self.btnGo, gg.bind(self.onBtnGo, self))

    self.txtNowCharge = self:Find("TxtCharge/TxtNowCharge", UNITYENGINE_UI_TEXT)
    self.txtNeedCharge = self:Find("TxtCharge/TxtNowCharge/TxtNeedCharge", UNITYENGINE_UI_TEXT)

    self.btnDesc = self:Find("BtnDesc")
    self:setOnClick(self.btnDesc.gameObject, gg.bind(self.onClickDesc, self))

    self.txtChargeCount = self.transform:Find("TxtDesc/TxtChargeCount"):GetComponent(UNITYENGINE_UI_TEXT)
end

function OpenAccruingChargeBox:onOpen(...)
    self:onRechargeChange()

    local activityCfg = cfg.giftActivities[constant.RECHARGE]
    self.rewardDataList = ActivityUtil.getRewardList(cfg.giftReward[activityCfg.reward])

    self.scrollView:setItemCount(#self.rewardDataList)
end

function OpenAccruingChargeBox:onClickDesc()
    gg.uiManager:openWindow("PnlRule", {title = Utils.getText("activity_RulesTitle"), content = Utils.getText("activity_RulesTxt_PayRebate")})
end

-- self.recharge = 100

function OpenAccruingChargeBox:onRechargeChange()
    self.recharge = cfg.global.Recharge.floatValue

    -- Recharge

    self.isFetch = ActivityData.RechargeData.rechargeStat == 1

    self.txtNowCharge.text = ActivityData.RechargeData.rechargeVal
    self.txtNeedCharge.text = "/" .. self.recharge

    self.txtChargeCount.text = self.recharge


    if not self.isFetch then
        if ActivityData.RechargeData.rechargeVal >= self.recharge then
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

function OpenAccruingChargeBox:onBtnCharge()
    gg.uiManager:openWindow("PnlRewardSmall", 
    {
        rewardList =  self.rewardDataList, 
        yesCallback = function ()
            ActivityData.C2S_Player_GetRechargeReward(constant.RECHARGE)
        end
    })
end

function OpenAccruingChargeBox:onBtnGo()
    gg.uiManager:openWindow("PnlShop", {shopType = 2})
end

function OpenAccruingChargeBox:onRenderItem(obj, index)
    local item = FirstChargeRewardItem:getItem(obj, self.itemList, self)
    item:setData(self.rewardDataList[index])
end

function OpenAccruingChargeBox:onClose()
end

function OpenAccruingChargeBox:onRelease()
    self.scrollView:release()
end