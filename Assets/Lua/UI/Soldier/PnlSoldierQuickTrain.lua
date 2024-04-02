

PnlSoldierQuickTrain = class("PnlSoldierQuickTrain", ggclass.UIBase)

function PnlSoldierQuickTrain:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onSoliderChange", "onShipExistSoldierChange"}
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlSoldierQuickTrain:onAwake()
    self.view = ggclass.PnlSoldierQuickTrainView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "SoldierQuickTrainItem", self.itemList, false, true)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
    self.needBlurBG = true
end

function PnlSoldierQuickTrain:onSoliderChange()
    self:refresh()
end

function PnlSoldierQuickTrain:onShipExistSoldierChange()
    self:refresh()
end

function PnlSoldierQuickTrain:onShow()
    self:bindEvent()
    self:refresh()
end

function PnlSoldierQuickTrain:refresh()
    self.dataList = {}

    for key, buildData in pairs(BuildData.shipExistSoliderData) do
        if buildData.lessTrainTick <= 0 then
            local soldierCfgId = buildData.soliderCfgId
            if buildData.trainCfgId ~= 0 then
                soldierCfgId = buildData.trainCfgId
            end
            if soldierCfgId ~= 0 then
                local buildCfg = BuildUtil.getCurBuildCfg(buildData.cfgId, buildData.level, buildData.quality)
                local soldierCfg = SoliderUtil.getSubSoliderCfg(soldierCfgId)

                local maxCount = math.floor(buildCfg.maxTrainSpace / soldierCfg.trainSpace)
                local canTrainCount = maxCount - buildData.soliderCount
                if canTrainCount > 0 then
                    table.insert(self.dataList, {cfg = buildCfg, data = buildData, soldierCfg = soldierCfg,
                        maxCount = maxCount, canTrainCount = canTrainCount})
                end
            end
        end
    end

    self.scrollView:setItemCount(#self.dataList)

    local itemWidth = 140
    local spancing = 75

    local width = (itemWidth + spancing) * #self.dataList - spancing
    self.scrollView.transform:SetRectSizeX(math.min(width, 950))
    self:stopTimer()
    self:refreshCost()
end

function PnlSoldierQuickTrain:refreshCost()
    local costInstantMit = 0
    local costSupplementStarCoin = 0
    local isTraining = false
    for key, value in pairs(self.dataList) do
        local trainLessTime = value.data.lessTrainTickEnd - os.time()
        if trainLessTime > 0 then
            costInstantMit = costInstantMit + math.ceil((trainLessTime / 60)) * cfg.global.SpeedUpPerMinute.intValue
            isTraining = true
        else
            costInstantMit = costInstantMit + math.ceil((value.soldierCfg.trainNeedTick / 60)) * cfg.global.SpeedUpPerMinute.intValue
            costSupplementStarCoin = costSupplementStarCoin + value.soldierCfg.trainNeedStarCoin * value.canTrainCount
        end
    end
    self.costInstantMit = costInstantMit
    self.costSupplementStarCoin = costSupplementStarCoin
    self.view.txtInstantCostMit.text = Utils.getShowRes(costInstantMit)
    self.view.txtInstantCostStarCoin.text = Utils.getShowRes(costSupplementStarCoin)
    self.view.txtSupplementCost.text = Utils.getShowRes(costSupplementStarCoin)

    self:refreshTxtColor()

    if isTraining then
        self:startTimer()
    else
        self:stopTimer()
    end
end

function PnlSoldierQuickTrain:startTimer()
    if self.timer then
        return
    end

    self.timer = gg.timer:startLoopTimer(0.3, 0.3, -1,function ()
        self:refreshCost()
    end)
end

function PnlSoldierQuickTrain:stopTimer()
    if self.timer then
        gg.timer:stopTimer(self.timer)
        self.timer = nil
    end
end

function PnlSoldierQuickTrain:onRenderItem(obj, index)
    local item = SoldierQuickTrainItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])
end

function PnlSoldierQuickTrain:onHide()
    self:releaseEvent()
    self:stopTimer()
end

function PnlSoldierQuickTrain:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)

    self:setOnClick(view.btnInstant, gg.bind(self.onBtnInstant, self))
    self:setOnClick(view.btnSupplement, gg.bind(self.onBtnSupplememt, self))
end

function PnlSoldierQuickTrain:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlSoldierQuickTrain:onDestroy()
    local view = self.view
    self.scrollView:release()
    self:stopTimer()
end

function PnlSoldierQuickTrain:onBtnInstant()
    local ids = {}
    -- if not Utils.checkAndAlertEnoughtMit(self.costInstantMit, true) then
    --     return
    -- end

    if self.costInstantMit > ResData.getCarboxyl() then
        gg.uiManager:showTip("not enought Hydroxyl")
        return
    end

    for key, value in pairs(self.dataList) do
        table.insert(ids, value.data.id)
    end

    if next(ids) then
        BuildData.C2S_Player_OneKeySpeedAndFullTrainSoldiers(ids)
        self:close()
    end
end

function PnlSoldierQuickTrain:onBtnSupplememt()
    local ids = {}
    for key, value in pairs(self.dataList) do
        if value.data.lessTrainTick <= 0 then
            table.insert(ids, value.data.id)
        end
    end

    if next(ids) then
        BuildData.C2S_Player_OneKeyTrainSoldiers(ids)
        self:close()
    end
end

function PnlSoldierQuickTrain:refreshTxtColor()
    local view = self.view
    if self.costInstantMit > ResData.getCarboxyl() then
        view.txtInstantCostMit.color = constant.COLOR_RED
    else
        view.txtInstantCostMit.color = constant.COLOR_WHITE
    end

    if self.costSupplementStarCoin > ResData.getStarCoin() then
        view.txtSupplementCost.color = constant.COLOR_RED
        view.txtInstantCostStarCoin.color = constant.COLOR_RED
    else
        view.txtSupplementCost.color = constant.COLOR_WHITE
        view.txtInstantCostStarCoin.color = constant.COLOR_WHITE
    end
end

function PnlSoldierQuickTrain:onBtnClose()

end

return PnlSoldierQuickTrain