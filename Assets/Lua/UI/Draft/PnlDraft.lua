PnlDraft = class("PnlDraft", ggclass.UIBase)

-- args = {id = , }
function PnlDraft:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSetPnlDraftView"}

    self.reserveArmys = {} -- ""
    self.maxTrainSpace = 0 -- ""
    self.maxTrainCount = 0 -- ""
    self.soliderCount = 0 -- ""
    self.isTrainScrollbarValueChange = true -- ""(false)""(true)
    self.boxCost = {}

    -- self.RecruitsTrainRes = cfg["global"].RecruitsTrainRes.tableValue -- ""
    self.RecruitsTrainCD = cfg["global"].RecruitsTrainCD.intValue -- ""
end

function PnlDraft:onAwake()
    self.view = ggclass.PnlDraftView.new(self.pnlTransform)

end

function PnlDraft:onShow()

    self:bindEvent()
    self.resList = {}

    local baseLevel = gg.buildingManager:getBaseLevel()

    local baseLevelCfg = cfg.baseLevel

    local subBaseLevelCfg = baseLevelCfg[baseLevel]
    if not subBaseLevelCfg then
        subBaseLevelCfg = baseLevelCfg[#baseLevelCfg]
    end

    self.RecruitsTrainRes = subBaseLevelCfg.RecruitsTrainRes

    self:onSetPnlDraftView()
    self:onTrainScrollbarValueChange()
    DraftData.C2S_Player_GetReserveArmy(self.args.buildData.id)
end

function PnlDraft:onSetPnlDraftView()
    self.reserveArmys = {}
    if DraftData.reserveArmys[self.args.buildData.id] then
        for k, v in pairs(DraftData.reserveArmys[self.args.buildData.id]) do
            self.reserveArmys[k] = v
        end
    else
        self.reserveArmys = {
            buildId = self.args.buildData.id,
            trainCfgId = 0,
            trainCount = 0,
            trainTick = 0,
            count = 0
        }
    end

    -- self.maxTrainSpace = gg.buildingManager:getBuildingTable()[self.args.buildData.id].buildCfg.maxTrainSpace

    self.maxTrainSpace = self.args.buildCfg.maxTrainSpace

    self.maxTrainCount = self.maxTrainSpace - self.reserveArmys.count - self.reserveArmys.trainCount
    if self.maxTrainCount < 0 then
        self.maxTrainCount = 0
    end

    if self.maxTrainSpace == (self.reserveArmys.count + self.reserveArmys.trainCount) then
        if self.reserveArmys.trainCount > 0 then
            self.view.btnQuickTrain:SetActiveEx(true)
            self.view.btnTrain:SetActiveEx(false)
            self.view.btnQuickTrain.transform.localPosition = Vector3(0, -62, 0)
            self.view.txtWaringFull.text = Utils.getText("conscription_QueueFullTips")
        else
            self.view.btnQuickTrain:SetActiveEx(false)
            self.view.btnTrain:SetActiveEx(false)
            self.view.txtWaringFull.text = Utils.getText("conscription_ReservistsFullTips")

        end
        self.view.bgWaringFull:SetActiveEx(true)
        self.view.trainScrollbarObj:SetActiveEx(false)
        self.view.trainScrollbar.interactable = false
    else
        self.view.btnQuickTrain:SetActiveEx(true)
        self.view.btnTrain:SetActiveEx(true)
        self.view.btnQuickTrain.transform.localPosition = Vector3(-181, -62, 0)
        self.view.btnTrain.transform.localPosition = Vector3(181, -62, 0)

        self.view.bgWaringFull:SetActiveEx(false)
        self.view.trainScrollbarObj:SetActiveEx(true)
        self.view.trainScrollbar.interactable = true
    end
    self.isTrainScrollbarValueChange = true

    self.boxCost[constant.RES_STARCOIN] = self.view.txtCostStar
    self.boxCost[constant.RES_ICE] = self.view.txtCostIce
    self.boxCost[constant.RES_GAS] = self.view.txtCostGas
    self.boxCost[constant.RES_TITANIUM] = self.view.txtCostTi
    self:stopTrainTimer()

    if self.reserveArmys.trainCount > 0 then
        local trainCount = self.reserveArmys.trainCount
        -- self.RecruitsTrainCD * (trainCount):""trainCount""
        -- (Utils.getServerSec() - self.reserveArmys.trainTick)："" - "" = ""
        local trainTick = self.RecruitsTrainCD * (trainCount) - (Utils.getServerSec() - self.reserveArmys.trainTick)
        self.view.txtTrainingCount.gameObject:SetActiveEx(true)
        self.view.txtTrainingCount.text = string.format("(+%s)", trainCount)
        self.view.txtTrainingTime.text = gg.time:getTick(trainTick)
        local endTime = trainTick + Utils.getServerSec()
        self.trainTimer = gg.timer:startLoopTimer(0, 1, -1, function()
            local tick = endTime - Utils.getServerSec()
            self.view.txtTrainingTime.text = gg.time:getTick(tick)
            local count = tick / self.RecruitsTrainCD
            local temp = 0
            if tick % self.RecruitsTrainCD ~= 0 then
                temp = 1
            end
            count = math.floor(count) + temp
            self.view.txtTrainingCount.text = string.format("(+%s)", count)

            self:setSliderNum(trainCount - count)
            if tick <= 0 or count <= 0 then
                self.view.txtTrainingCount.gameObject:SetActiveEx(false)
                self:stopTrainTimer()
            end
        end)
    else
        self.view.txtTrainingCount.gameObject:SetActiveEx(false)
    end
    self.view.txtTrainCount.text = 0

    self.view.trainScrollbar.value = 0

    self.view.txtWaring.gameObject:SetActiveEx(false)

    self.view.txtMaxNum.text = "/" .. self.maxTrainSpace
    self.view.txtQuickCost.text = 0

    if self.reserveArmys.trainCount > 0 then
        self:setTxtQuickCost()
    else
        self.view.txtQuickCost.text = 0
    end

    self:setSliderNum()
end

function PnlDraft:stopTrainTimer()
    if self.trainTimer then
        gg.timer:stopTimer(self.trainTimer)
        self.trainTimer = nil
    end
end

function PnlDraft:onHide()
    self:releaseEvent()
    self:stopTrainTimer()

end

function PnlDraft:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnReduce):SetOnClick(function()
        self:onBtnReduce()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnIncrease):SetOnClick(function()
        self:onBtnIncrease()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnQuickTrain):SetOnClick(function()
        self:onBtnQuickTrain()
    end)
    CS.UIEventHandler.Get(view.btnTrain):SetOnClick(function()
        self:onBtnTrain()
    end)

    self.view.trainScrollbar.onValueChanged:AddListener(gg.bind(self.onTrainScrollbarValueChange, self))
end

function PnlDraft:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnReduce)
    CS.UIEventHandler.Clear(view.btnIncrease)
    CS.UIEventHandler.Clear(view.btnQuickTrain)
    CS.UIEventHandler.Clear(view.btnTrain)

    self.view.trainScrollbar.onValueChanged:RemoveAllListeners()

end

function PnlDraft:onDestroy()
    local view = self.view

end

function PnlDraft:onBtnClose()
    self:close()
end

function PnlDraft:onBtnReduce()
    self:onBtnChangeCount(-1)
end

function PnlDraft:onBtnIncrease()
    self:onBtnChangeCount(1)
end

function PnlDraft:onBtnQuickTrain()
    if self.hyCost <= 0 then
        return
    end
    local txtTitel = Utils.getText("universal_Ask_Title")
    local txtTips = string.format(Utils.getText("res_FinishNow_AskText"), Utils.scientificNotation(self.hyCost / 1000))

    local txtNo = Utils.getText("universal_Ask_BackButton")
    local txtYes = Utils.getText("universal_ConfirmButton")

    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtYes = txtYes,
        callbackYes = function()
            DraftData.C2S_Player_SpeedupReserveArmy(self.args.buildData.id, 0, self.soliderCount)
        end,
        txtNo = txtNo,
        yesCost = {{
            resId = constant.RES_TESSERACT,
            count = self.hyCost
        }}
    }
    gg.uiManager:openWindow("PnlAlertNew", args)
end

function PnlDraft:onBtnChangeCount(temp)
    self.isTrainScrollbarValueChange = false

    self.soliderCount = self.soliderCount + temp
    if self.soliderCount > self.maxTrainCount then
        self.soliderCount = self.maxTrainCount
    end
    if self.soliderCount < 0 then
        self.soliderCount = 0
    end

    self.view.txtTrainCount.text = self.soliderCount
    local percent = self.soliderCount / self.maxTrainCount
    if self.maxTrainCount == 0 then
        percent = 1
    end
    self.view.trainScrollbar.value = percent
end

function PnlDraft:onBtnTrain()
    if self.soliderCount + self.reserveArmys.count + self.reserveArmys.trainCount <= self.maxTrainSpace then
        DraftData.C2S_Player_ReserveArmyTrain(self.args.buildData.id, 0, self.soliderCount)
    end
end

function PnlDraft:onTrainScrollbarValueChange()
    local value = self.view.trainScrollbar.value

    if self.isTrainScrollbarValueChange then
        self.soliderCount = value * self.maxTrainCount
        self.soliderCount = math.floor(self.soliderCount)
        self.view.txtTrainCount.text = self.soliderCount
    end
    self.isTrainScrollbarValueChange = true

    for k, v in pairs(self.boxCost) do
        v.gameObject:SetActiveEx(false)
    end
    self.resList = {}

    local isEnoughRes = true

    for k, v in pairs(self.RecruitsTrainRes) do
        local cost = v[2] * self.soliderCount
        if cost <= ResData.getRes(v[1]) then
            self.boxCost[v[1]].color = Color.New(0xff / 0xff, 0xf4 / 0xff, 0xe5 / 0xff, 0xff / 0xff)
        else
            self.boxCost[v[1]].color = Color.New(0xff / 0xff, 0x7e / 0xff, 0x63 / 0xff, 0xff / 0xff)
            isEnoughRes = false
        end
        self.boxCost[v[1]].text = Utils.scientificNotation(cost / 1000)
        self.boxCost[v[1]].gameObject:SetActiveEx(true)

        table.insert(self.resList, {
            resId = v[1],
            count = v[2] * self.soliderCount
        })
    end
    self.curTrainTime = self.RecruitsTrainCD * self.soliderCount

    self.view.txtTime.text = gg.time:getTick(self.curTrainTime)

    self.view.txtWaring.gameObject:SetActiveEx(not isEnoughRes)

    self:setSliderNum()
end

function PnlDraft:setSliderNum(index)
    local index = index or 0
    local curCount = self.reserveArmys.count + index
    if curCount > self.maxTrainSpace then
        curCount = self.maxTrainSpace
    end
    local curPercent = curCount / self.maxTrainSpace
    self.view.txtNum.text = curCount
    if curPercent > 1 then
        curPercent = 1
    end
    self.view.fillYellow.fillAmount = curPercent
    local fillYellowRect = self.view.fillYellow.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM)
    fillYellowRect:SetRectPosX(7 - (1 - curPercent) * fillYellowRect.rect.width)

    local trainPercnet = (curCount + self.reserveArmys.trainCount) / self.maxTrainSpace
    self.view.fillBlue.fillAmount = trainPercnet

    local curTrainPercnet = (curCount + self.reserveArmys.trainCount + self.soliderCount) / self.maxTrainSpace
    self.view.fillBlueDown.fillAmount = curTrainPercnet

    self:setTxtQuickCost(index)
end

function PnlDraft:setTxtQuickCost(index)

    local trainTime = self.curTrainTime or 0
    local index = index or 0
    local lastTrainTime = self.RecruitsTrainCD * (self.reserveArmys.trainCount - index) -
                              (Utils.getServerSec() - self.reserveArmys.trainTick)
    if lastTrainTime <= 0 then
        lastTrainTime = 0
    end
    local totalTrainTime = trainTime + lastTrainTime
    local hyCost = ResUtil.getExchangeResCostTesseract(self.resList) + ResUtil.getSpeedUpCost(totalTrainTime)
    if hyCost <= ResData.getRes(constant.RES_TESSERACT) then
        self.view.txtQuickCost.color = Color.New(0xff / 0xff, 0xf4 / 0xff, 0xe5 / 0xff, 0xff / 0xff)
    else
        self.view.txtQuickCost.color = Color.New(0xff / 0xff, 0x7e / 0xff, 0x63 / 0xff, 0xff / 0xff)
    end
    self.view.txtQuickCost.text = Utils.scientificNotation(hyCost / 1000)
    self.hyCost = hyCost
end

return PnlDraft
