

PnlPledgeSet = class("PnlPledgeSet", ggclass.UIBase)

function PnlPledgeSet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onVipPledgeChange" }
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
    self.needBlurBG = true
end

function PnlPledgeSet:onAwake()
    self.view = ggclass.PnlPledgeSetView.new(self.pnlTransform)

    self.descItemList = {}
    self.descScrollView = UIScrollView.new(self.view.descScrollView, "VipDescItem", self.descItemList)
    self.descScrollView:setRenderHandler(gg.bind(self.onRenderDescItem, self))

    self.view.optionalTopBtnsBox:setBtnDataList({
        {name = "Stake", callback = gg.bind(self.onBtnTop, self, 1)},
        {name = "Withdraw", callback = gg.bind(self.onBtnTop, self, 2)},
        {name = "VIP Notes", callback = gg.bind(self.onBtnTop, self, 3)},
    })
end

function PnlPledgeSet:onShow()
    self:bindEvent()
    self:onBtnTop(1, true)
    self.view.optionalTopBtnsBox:setBtnStageWithoutNotify(1)
    self:refreshAddition()
    self.curLevelCfg = Utils.getCurVipCfgByMit(VipData.vipData.mit)
end

function PnlPledgeSet:refreshAddition()
    -- -- local vipCfg = cfg.vip[VipData.vipData.vipLevel]


    -- local vipCfg = Utils.getCurVipCfgByMit(VipData.vipData.mit)
    -- for key, value in pairs(self.view.resAdditionMap) do
    --     if constant.RES_2_CFG_KEY[key] then
    --         local ratio = vipCfg[constant.RES_2_CFG_KEY[key].vipKey]
    --         value.txtAdd.text = self:getRatioStr(ratio) --"+" .. math.max(0, ratio - 1) * 100 .. "%"
    --     end
    -- end

end

function PnlPledgeSet:refreshAdd()
    local view = self.view
    view.layoutPledge:SetActiveEx(true)
    view.layoutDesc:SetActiveEx(false)

    local maxVal = ResData.getMit() -- math.min(cfg.vip[#cfg.vip].minMit - VipData.vipData.mit, ResData.getMit())
    view.slider.minValue = 0
    view.slider.maxValue = maxVal
    view.slider.value = 0
    self:onSliderChange(0)
    view.inputCount.text = 0 --VipData.vipData.mit
    self:refreshVipLevelChange()

    -- view.imgArrow.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 0)
    view.imgArrow.transform:SetActiveEx(true)
    view.imgArrow2.transform:SetActiveEx(false)
    local icon = gg.getSpriteAtlasName("Pledge_Atlas", "Pledge_Box_icon")
    gg.setSpriteAsync(view.imgStake, icon)

    self.view.bgExchangeNeed.transform.anchoredPosition = CS.UnityEngine.Vector2(151, 19.4)
    self.view.imgExchangeNeed.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
end

function PnlPledgeSet:refreshSub()
    local view = self.view
    view.layoutPledge:SetActiveEx(true)
    view.layoutDesc:SetActiveEx(false)
    local maxVal = VipData.vipData.mit
    view.slider.minValue = 0
    view.slider.maxValue = maxVal
    view.slider.value = 0
    self:onSliderChange(0)
    view.inputCount.text = 0--VipData.vipData.mit
    self:refreshVipLevelChange()
    -- view.imgArrow.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 180)

    view.imgArrow.transform:SetActiveEx(false)
    view.imgArrow2.transform:SetActiveEx(true)
    local icon = gg.getSpriteAtlasName("Pledge_Atlas", "Pledge_Opened box_icon")
    gg.setSpriteAsync(view.imgStake, icon)

    self.view.bgExchangeNeed.transform.anchoredPosition = CS.UnityEngine.Vector2(-151, 19.4)
    self.view.imgExchangeNeed.transform.localScale = CS.UnityEngine.Vector3(1, -1, 1)
end

PnlPledgeSet.vipDescItemHeight = 72.4
PnlPledgeSet.vipDescItemSpancing = 0

function PnlPledgeSet:refreshDesc()
    local view = self.view

    self.view.layoutPledge:SetActiveEx(false)
    self.view.layoutDesc:SetActiveEx(true)
    self.descDataList = {}
    for key, value in pairs(cfg.vip) do
        self.descDataList[key + 1] = value
    end

    local dataCount = #self.descDataList
    self.descScrollView:setItemCount(dataCount)
    local vipLenth = (PnlPledgeSet.vipDescItemHeight + PnlPledgeSet.vipDescItemSpancing) * dataCount - PnlPledgeSet.vipDescItemSpancing
    self.descScrollView.transform:SetRectSizeY(vipLenth)
    view.layoutLineInside.transform:SetRectSizeY(vipLenth)
    view.contentOutsideScrollView.transform:SetRectSizeY(vipLenth + view.layoutNotes.transform.rect.height)
    view.layoutNotes.anchoredPosition = CS.UnityEngine.Vector2(0, -vipLenth)
end

function PnlPledgeSet:getRatioStr(ratio)
    -- if ratio <= 0 then
    --     return "+0"
    -- end

    local addRatio = math.max(ratio - 1, 0)
    return "+" .. addRatio * 100 .. "%"
end

function PnlPledgeSet:onVipPledgeChange()
    self.curLevelCfg = Utils.getCurVipCfgByMit(VipData.vipData.mit)
    self:refreshAddition()
    self:onBtnTop(self.showingType, true)
end

function PnlPledgeSet:onSliderChange(value)
    local val = math.floor(value)

    local view = self.view
    view.inputCount.text = val

    -- if self.showingType == PnlPledgeSet.TYPE_ADD then
    --     view.inputCount.text = val

    -- elseif self.showingType == PnlPledgeSet.TYPE_SUB then
    --     view.inputCount.text = -val

    -- end
end

function PnlPledgeSet:onInputCount(text)
    local view = self.view

    local mitChange = tonumber(text)
    if not mitChange then
        view.inputCount.text = 0
        return
    end

    view.inputCount:SetTextWithoutNotify(mitChange)

    if self.showingType == PnlPledgeSet.TYPE_SUB then
        mitChange = -mitChange
    end

    local val = mitChange + VipData.vipData.mit

    -- if val < 0 then
    --     view.inputCount.text = -VipData.vipData.mit
    --     return
    -- end

    if self.showingType == PnlPledgeSet.TYPE_ADD then
        if mitChange < 0 then
            view.inputCount.text = 0
            return
        end

        if mitChange > ResData.getMit() then
            view.inputCount.text = ResData.getMit()
            return
        end
    elseif self.showingType == PnlPledgeSet.TYPE_SUB then
        if mitChange > 0 then
            view.inputCount.text = 0
            return
        end

        if -mitChange > VipData.vipData.mit then
            view.inputCount.text = VipData.vipData.mit
            return
        end
    end

    view.txtBefore.text = Utils.getShowRes(ResData.getMit() - mitChange)
    view.txtAfter.text = Utils.getShowRes(val)
    self:refreshVipLevelChange(val)
end

function PnlPledgeSet:onInputEnd(text)
    local view = self.view
    local num = tonumber(text)
    if not num then
        num = 0
        view.inputCount.text = 0
    end

    if self.showingType == PnlPledgeSet.TYPE_ADD then
        self.view.slider:SetValueWithoutNotify(num)
    elseif self.showingType == PnlPledgeSet.TYPE_SUB then
        self.view.slider:SetValueWithoutNotify(-num)
    end
end

function PnlPledgeSet:refreshVipLevelChange(targetMit)
    local view = self.view
    targetMit = targetMit or tonumber(view.inputCount.text) + VipData.vipData.mit
    local levelCfg = Utils.getCurVipCfgByMit(targetMit)

    if self.showingType == PnlPledgeSet.TYPE_ADD then
        local nextVal = levelCfg.maxMit + 1 - targetMit
        -- view.txtVipLevel.text = "LV." .. levelCfg.cfgId .. "\nnext " .. nextVal
        if levelCfg.cfgId >= #cfg.vip then
            view.bgExchangeNeed.gameObject:SetActiveEx(false)
            view.txtVipAfter.text = levelCfg.cfgId
        else
            view.txtChangeNeed.text = Utils.getShowRes(nextVal)
            view.bgExchangeNeed.gameObject:SetActiveEx(true)
            view.txtVipAfter.text = levelCfg.cfgId + 1
        end

    elseif self.showingType == PnlPledgeSet.TYPE_SUB then
        local frontVal = targetMit - (levelCfg.minMit) + 1
        -- view.txtVipLevel.text = "LV." .. levelCfg.cfgId .. "\nfront " .. frontVal
        if levelCfg.cfgId <= 0 then
            view.bgExchangeNeed.gameObject:SetActiveEx(false)
            view.txtVipAfter.text = levelCfg.cfgId
        else
            view.txtChangeNeed.text = Utils.getShowRes(frontVal)
            view.bgExchangeNeed.gameObject:SetActiveEx(true)
            view.txtVipAfter.text = levelCfg.cfgId - 1
        end
    end

    if levelCfg.carboxylRatio and levelCfg.carboxylRatio > 0 then
        -- gg.setSpriteAsync(self.view.resAdditionMap.CARBOXYL.img, "Yes_icon")
        self.view.resAdditionMap.CARBOXYL.img.transform:SetActiveEx(true)
        self.view.resAdditionMap.CARBOXYL.txtSub.transform:SetActiveEx(false)
        
    else
        -- gg.setSpriteAsync(self.view.resAdditionMap.CARBOXYL.img, "No_icon")
        self.view.resAdditionMap.CARBOXYL.img.transform:SetActiveEx(false)
        self.view.resAdditionMap.CARBOXYL.txtSub.transform:SetActiveEx(true)
    end

    for key, value in pairs(self.view.resAdditionMap) do
        if constant.RES_2_CFG_KEY[key] then
            local ratio = levelCfg[constant.RES_2_CFG_KEY[key].vipKey]
            value.txtAdd.text = self:getRatioStr(ratio)
        end
    end
end

function PnlPledgeSet:onHide()
    self:releaseEvent()
end

function PnlPledgeSet:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)
    view.slider.onValueChanged:AddListener(gg.bind(self.onSliderChange, self))

    self:setOnClick(view.btnAdd, gg.bind(self.onBtnAdd, self, 1))
    self:setOnClick(view.btnSub, gg.bind(self.onBtnAdd, self, -1))

    self:setOnClick(view.btnClose, gg.bind(self.close, self))

    CS.UIEventHandler.Get(view.btnAdd):SetOnPointerDown(gg.bind(self.onAddDown, self, 1))
    CS.UIEventHandler.Get(view.btnAdd):SetOnPointerUp(gg.bind(self.onAddUp, self, 1))

    CS.UIEventHandler.Get(view.btnSub):SetOnPointerDown(gg.bind(self.onAddDown, self, -1))
    CS.UIEventHandler.Get(view.btnSub):SetOnPointerUp(gg.bind(self.onAddUp, self, -1))

    view.inputCount.onValueChanged:AddListener(gg.bind(self.onInputCount, self))
    view.inputCount.onEndEdit:AddListener(gg.bind(self.onInputEnd, self))
end

function PnlPledgeSet:onBtnAdd(value)
    local val = self.view.slider.value + value
    if self.view.slider.value + value < 0 then
        val = 0
    elseif self.view.slider.value + value > self.view.slider.maxValue then
        val = self.view.slider.maxValue
    end
    self.view.slider.value = val
end

function PnlPledgeSet:onAddDown(value)
    local time = 0
    self.addTimer = gg.timer:startLoopTimer(0, 0.05, -1, function ()
        time = time + 0.1
        if time > 0.5 then
            self:onBtnAdd(value)
        end
    end)
end

function PnlPledgeSet:onAddUp(value)
    gg.timer:stopTimer(self.addTimer)
end

PnlPledgeSet.TYPE_ADD = 1
PnlPledgeSet.TYPE_SUB = 2
PnlPledgeSet.TYPE_DESC = 3

function PnlPledgeSet:onBtnTop(index, isForce)
    if self.showingType == index and not isForce then
        return
    end
    self.showingType = index

    if index == 1 then
        self:refreshAdd()
    elseif index == 2 then
        self:refreshSub()
    elseif index == 3 then
        self:refreshDesc()
    end
end

function PnlPledgeSet:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnYes)
    CS.UIEventHandler.Clear(view.btnNo)
    CS.UIEventHandler.Clear(view.btnAdd)
    CS.UIEventHandler.Clear(view.btnSub)
    view.slider.onValueChanged:RemoveAllListeners()
    view.inputCount.onValueChanged:RemoveAllListeners()
    view.inputCount.onEndEdit:RemoveAllListeners()
end

function PnlPledgeSet:onDestroy()
    local view = self.view
    self.descScrollView:release()
    self.view.optionalTopBtnsBox:release()
end

function PnlPledgeSet:onRenderDescItem(obj, index)
    local item = PledgeDescItem:getItem(obj, self.descScrollView)
    item:setData(self.descDataList[index], index)
end

function PnlPledgeSet:onBtnYes()
    -- local args = {
    --     targetObj = self.view.btnYes,
    --     isPlayAnim = true,
    -- }
    -- gg.uiManager:openWindow("PnlGuide", args)

    local alertText = ""
    local mitChange = tonumber(self.view.inputCount.text) --- VipData.vipData.mit
    if mitChange == 0 then
        return
    end

    if self.showingType == PnlPledgeSet.TYPE_SUB then
        mitChange = -mitChange
    end
    local afterLevel = Utils.getCurVipCfgByMit(mitChange + VipData.vipData.mit).cfgId

    if afterLevel ~= self.curLevelCfg.cfgId then
        if afterLevel > self.curLevelCfg.cfgId then
            alertText = string.format("Are you sure to stake %sMIT? You may upgrade to VIP%s tomorrow.", mitChange, afterLevel)
        else
            alertText = string.format("Are you sure to withdraw %sMIT? You may downgrade to VIP%s tomorrow.", -mitChange, afterLevel)
        end
    else
        if mitChange > 0 then
            alertText = string.format("are you sure to stake %s mit?", mitChange)
        else
            alertText = string.format("Are you sure to withdraw %sMIT? Withdrawal of MIT may downgrade your VIP level.", -mitChange)
        end
    end

    local callbackYes = function ()
        
    end
    gg.uiManager:openWindow("PnlAlert", 
        {btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
        txtYes = "confirm",
        callbackYes = callbackYes, 
        txt = alertText})
end

function PnlPledgeSet:onBtnNo()
    self:close()
end

return PnlPledgeSet