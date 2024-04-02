

PnlSoldierInstantTrain = class("PnlSoldierInstantTrain", ggclass.UIBase)

function PnlSoldierInstantTrain:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onShipExistSoldierChange" }
    self.needBlurBG = true
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlSoldierInstantTrain:onAwake()
    self.view = ggclass.PnlSoldierInstantTrainView.new(self.pnlTransform)
end

function PnlSoldierInstantTrain:onShow()
    self:bindEvent()
    self:refreshCost()
end

function PnlSoldierInstantTrain:refreshCost()
    local cost = 0
    local isTraining = false
    for key, buildData in pairs(BuildData.shipExistSoliderData) do
        if buildData.cfgId == constant.BUILD_LIBERATORSHIP then
            if buildData.lessTrainTick > 0 then
                isTraining = true
                local trainLessTime = buildData.lessTrainTickEnd - os.time()
                cost = cost + math.ceil((trainLessTime / 60)) * cfg.global.SpeedUpPerMinute.intValue
            end
        end
    end

    if cost == 0 then
        self:close()
        return
    end
    self.view.txtDesc.text = string.format(Utils.getText("supplement_now_AskText"), Utils.getShowRes(cost))

    self.view.txtCostMit.text = Utils.getShowRes(cost)
    self.cost = cost
    self:refreshTxtColor()

    if isTraining then
        self:startTimer()
    else
        self:stopTimer()
    end
end

function PnlSoldierInstantTrain:onShipExistSoldierChange()
    self:refreshCost()
end

function PnlSoldierInstantTrain:startTimer()
    if self.timer then
        return
    end

    self.timer = gg.timer:startLoopTimer(0.3, 0.3, -1,function ()
        self:refreshCost()
    end)
end

function PnlSoldierInstantTrain:stopTimer()
    if self.timer then
        gg.timer:stopTimer(self.timer)
        self.timer = nil
    end
end

function PnlSoldierInstantTrain:onHide()
    self:releaseEvent()
    self:stopTimer()
end

function PnlSoldierInstantTrain:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnInstant):SetOnClick(function()
        self:onBtnInstant()
    end)
    CS.UIEventHandler.Get(view.btnDapp):SetOnClick(function()
        self:onBtnDapp()
    end)
end

function PnlSoldierInstantTrain:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnInstant)
    CS.UIEventHandler.Clear(view.btnDapp)

end

function PnlSoldierInstantTrain:onDestroy()
    local view = self.view
    self:stopTimer()
end

function PnlSoldierInstantTrain:onBtnInstant()
    -- if not Utils.checkAndAlertEnoughtMit(self.cost, true) then
    --     return
    -- end
    if self.cost > ResData.getCarboxyl() then
        gg.uiManager:showTip("not enought Hydroxyl")
        return
    end

    local ids = {}
    for key, buildData in pairs(BuildData.buildData) do
        if buildData.cfgId == constant.BUILD_LIBERATORSHIP then
            if buildData.lessTrainTick > 0 then
                table.insert(ids, buildData.id)
            end
        end
    end
    BuildData.C2S_Player_OneKeySpeedTrainSoldiers(ids)
    self:close()
end

function PnlSoldierInstantTrain:onBtnDapp()
    
end

PnlSoldierInstantTrain.COLOR_WHITE = UnityEngine.Color(0xf3/0xff, 0xf3/0xff, 0xf3/0xff, 1)
PnlSoldierInstantTrain.COLOR_RED = UnityEngine.Color(0xff/0xff, 0x00/0xff, 0x00/0xff, 1)

function PnlSoldierInstantTrain:refreshTxtColor()
    local view = self.view
    if self.cost > ResData.getCarboxyl() then
        view.txtCostMit.color = PnlSoldierInstantTrain.COLOR_RED
    else
        view.txtCostMit.color = PnlSoldierInstantTrain.COLOR_WHITE
    end
end

return PnlSoldierInstantTrain
