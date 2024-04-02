BuildQueueBox = BuildQueueBox or class("BuildQueueBox", ggclass.UIBaseItem)

BuildQueueBox.events = {"onMoreBuilderChange"}

function BuildQueueBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BuildQueueBox:onInit()
    self.txtValidityPeriod = self:Find("TxtValidityPeriod", UNITYENGINE_UI_TEXT)
    self.txtDay = self:Find("TxtValidityPeriod/TxtDay", UNITYENGINE_UI_TEXT)

    self.btnBuyList = {}
    for i = 1, 3, 1 do
        self.btnBuyList[i] = {}
        self.btnBuyList[i].btn = self:Find("BtnBuy" .. i)
        local transform = self.btnBuyList[i].btn.transform
        self.btnBuyList[i].txtCost = transform:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
        self.btnBuyList[i].txtLessTime = transform:Find("TxtLessTime"):GetComponent(UNITYENGINE_UI_TEXT)

        self:setOnClick(self.btnBuyList[i].btn, gg.bind(self.onBtnBuy, self, i))

        self.btnBuyList[i].txtBuyDesc = transform:Find("TxtBuyDesc"):GetComponent(UNITYENGINE_UI_TEXT)
        
    end

    -- self.btnDesc = self:Find("TxtValidityPeriod/TxtDay/Text/BtnDesc")
    -- self:setOnClick(self.btnDesc, gg.bind(self.onBtnDesc, self))
end

function BuildQueueBox:onOpen(...)
    for i = 1, 3, 1 do
        local moreBuilderCfg = cfg.moreBuilderQue[i]
        local duration = 0
        for _, reawrd in pairs(moreBuilderCfg.reward) do
            local item = cfg.item[reawrd[1]]

            for key, value in pairs(item.effect) do
                local itemEffectCfg = cfg.itemEffect[value]
    
                if itemEffectCfg.effectType == constant.GIFT_BUILDER_QUE_TIME then
                    duration = duration + itemEffectCfg.value[1] * reawrd[2]
                end
            end
        end

        local onDaySec = 24 * 60 * 60

        local day = math.floor(duration / onDaySec)
        self.btnBuyList[i].txtCost.text = Utils.getShowRes(moreBuilderCfg.cost[2])
        self.btnBuyList[i].txtLessTime.text = string.format(Utils.getText("shop_ValidFor"), day)
    end

    self:refresh()
end

function BuildQueueBox:onClose()

end

function BuildQueueBox:refresh()
    self.txtDay.text = ShopData.moreBuilderData.day

    local isBought = ShopData.moreBuilderData and ShopData.moreBuilderData.day > 0
    for i = 1, 3, 1 do
        self.btnBuyList[i].txtBuyDesc.transform:SetActiveEx(isBought)
    end
    
    self.txtValidityPeriod.transform:SetActiveEx(isBought)
    -- self.txtLessTime.transform:SetActiveEx(false)
    -- if ShopData.moreBuilderData and ShopData.moreBuilderData.day > 0 then
    --     self.txtLessTime.transform:SetActiveEx(true)
    --     self.txtLessTime.text = string.format(Utils.getText("shop_DaysLeft"), ShopData.moreBuilderData.day)
    -- end
end

function BuildQueueBox:onMoreBuilderChange()
    self:refresh()
end

function BuildQueueBox:onRelease()
end

function BuildQueueBox:onBtnBuy(index)
    local moreBuilderCfg = cfg.moreBuilderQue[index]

    if ResData.getRes(moreBuilderCfg.cost[1]) >= moreBuilderCfg.cost[2] then
        gg.uiManager:openWindow("PnlTaskReward", {reward = {{rewardType = constant.ACTIVITY_OTHER, icon = "ShopIcon_Atlas[plane02_icon]", quality = 0, count = 1,}}})
        ShopData.C2S_Player_BuyMoreBuilder(index)
    else
        gg.uiManager:showTip(string.format(Utils.getText("universal_xxxNotEnough"), Utils.getText(constant.RES_2_CFG_KEY[constant.RES_TESSERACT].languageKey)))
        
    end
end

function BuildQueueBox:onBtnDesc()
    gg.uiManager:openWindow("PnlDesc", {title = "??", desc = "don't buy"})
end
