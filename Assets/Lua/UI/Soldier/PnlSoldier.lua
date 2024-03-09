

PnlSoldier = class("PnlSoldier", ggclass.UIBase)

PnlSoldier.BTNTYPE_CHANGE = 1
PnlSoldier.BTNTYPE_TRAINING = 2
PnlSoldier.BTNTYPE_INTANT = 3
PnlSoldier.BTNTYPE_SUPPLEMENT = 4

function PnlSoldier:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }

end

function PnlSoldier:onAwake()
    self.view = ggclass.PnlSoldierView.new(self.transform)

end

function PnlSoldier:onShow()
    self:bindEvent()
    self:setData()
    self:setView()
end

function PnlSoldier:setData()
    self.buildId = self.args.buildData.id
    self.soliderCount = self.args.buildData.soliderCount
    self.lessTrainTick = self.args.buildData.lessTrainTick
    self.lessTick = self.args.buildData.lessTick
    self.trainCount = self.args.buildData.trainCount

    self.maxTrainSpace = self.args.buildCfg.maxTrainSpace

    local soliderCfgId = self.args.buildData.soliderCfgId
    if soliderCfgId == 0 then
        soliderCfgId = self.args.buildData.trainCfgId
    end
    if soliderCfgId ~= 0 then
        local soldierLevel = 1
        for k, v in pairs(BuildData.soliderLevelData) do
            if soliderCfgId == v.cfgId then
                soldierLevel = v.level
            end
        end
        self.soliderCfg = self:getCfg(soliderCfgId, soldierLevel)
        self.soliderCountMax = self.maxTrainSpace / self.soliderCfg.trainSpace
        self.soliderCountMax = math.modf(self.soliderCountMax)
    end
end

function PnlSoldier:setView()
    local soliderCount = self.soliderCount
    local lessTrainTick = self.lessTrainTick
    local view = self.view
    if soliderCount == 0 and lessTrainTick == 0 then
        --
        self.btnType = PnlSoldier.BTNTYPE_TRAINING
        self:setViewChange()
    else
        view.viewSoldier:SetActive(true)
        view.viewChange:SetActive(false)
        view.txtCurNum.text = self.soliderCount
        local iconName = self.soliderCfg.icon
        --TODOIcon
        -- ResMgr:LoadSpriteAsync(iconName, function()
        --     view.iconSoldier.sprite = sprite
        -- end)
        if lessTrainTick > 0 then
            --
            self:setBtnToolView(PnlSoldier.BTNTYPE_INTANT)
        else
            local count = self.soliderCountMax - self.soliderCount
            if count == 0 then
                --
                view.boxTool:SetActive(false)
            else
                --
                self:setBtnToolView(PnlSoldier.BTNTYPE_SUPPLEMENT)
            end
        end
    end
end

function PnlSoldier:setBtnToolView(type)
    local view = self.view
    view.boxTool:SetActive(true)
    local count = 0
    local iconName = self.soliderCfg.icon
    --TODOIcon
    -- ResMgr:LoadSpriteAsync(iconName, function()
    --     view.iconToolSoldier.sprite = sprite
    -- end)
    local iconCostName = ""
    local txtName = ""
    local costNum = 0
    local tick = 0
    self.btnType = type
    if type == PnlSoldier.BTNTYPE_INTANT then
        iconCostName = "mit_icon_com"
        txtName = "Intant"
        count = self.trainCount
        local time = self.lessTrainTick + os.time()
        costNum = math.ceil((self.lessTrainTick / 60)) * cfg.global.SpeedUpPerMinute.intValue
        self:startLoopTick(time)
    elseif type == PnlSoldier.BTNTYPE_SUPPLEMENT then
        iconCostName = "star coin_com"
        txtName = "Supplement"
        count = self.soliderCountMax - self.soliderCount
        local cost = self.soliderCfg.trainNeedStarCoin * count
        local time = self.soliderCfg.trainNeedTick * count
        costNum = cost
        tick = time
    end
    view.txtToolNum.text = count
    view.btnTool.transform:Find("TxtTool"):GetComponent("Text").text = txtName
    view.txtCost.text = costNum
    tick = gg.time:hms_string(tick)
    view.txtTime.text = tick
    ResMgr:LoadSpriteAsync(iconCostName, function(sprite)
        view.iconCost.sprite = sprite
    end)
end

function PnlSoldier:stopLessTick()
    if self.lessTickTimer then
        gg.timer:stopTimer(self.lessTickTimer)
        self.lessTickTimer = nil
    end
end

function PnlSoldier:startLoopTick(tick)
    self:stopLessTick()
    self.lessTickTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = tick - os.time()
        if time <= 0 then
            self:stopLessTick()
        end
        time = gg.time:hms_string(time)
        self.view.txtTime.text = time
    end)
end

function PnlSoldier:onHide()
    self:releaseEvent()
    self:releaseResources()
    self:stopLessTick()
end

function PnlSoldier:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnChange):SetOnClick(function()
        self:onBtnChange()
    end)
    CS.UIEventHandler.Get(view.btnTool):SetOnClick(function()
        self:onBtnTool()
    end)
end

function PnlSoldier:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnChange)
    CS.UIEventHandler.Clear(view.btnTool)

end

function PnlSoldier:onDestroy()
    local view = self.view

end

function PnlSoldier:onBtnClose()
    self:close()
end

function PnlSoldier:onBtnChange()
    self.btnType = PnlSoldier.BTNTYPE_CHANGE
    self:setViewChange()
end

function PnlSoldier:onBtnTool()
    local id = self.buildId
    if self.btnType == PnlSoldier.BTNTYPE_INTANT then
        BuildData.C2S_Player_SpeedUp_SoliderTrain(id)
        --
    elseif self.btnType == PnlSoldier.BTNTYPE_SUPPLEMENT then
        --
        local soliderCfgId = self.soliderCfg.cfgId
        local maxTrainSpace = self.maxTrainSpace
        local trainSpace = self.soliderCfg.trainSpace
        local soliderCountMax = maxTrainSpace / trainSpace
        soliderCountMax = math.modf(soliderCountMax)

        local count = soliderCountMax - self.soliderCount
        BuildData.C2S_Player_SoliderTrain(id, soliderCfgId, count)
    end
end

function PnlSoldier:onBtnSoldier(temp)
    local lessTick = self.lessTick
    if lessTick > 0 then
        local text = "Upgrading the landing ship"
        gg.uiManager:showTip(text)
        return
    end
    local level = self.soldierTable[temp].cfg.level
    if level <= 0 then
        local text = "Research and development of drawings unlock"
        gg.uiManager:showTip(text)
        return
    end

    local id = self.buildId
    local soliderCfgId = self.soldierTable[temp].cfg.cfgId
    local maxTrainSpace = self.maxTrainSpace
    local trainSpace = self.soldierTable[temp].cfg.trainSpace
    local soliderCount = maxTrainSpace / trainSpace
    soliderCount = math.modf(soliderCount)

    if self.btnType then
        if self.btnType == PnlSoldier.BTNTYPE_CHANGE then
            BuildData.C2S_Player_SoliderReplace(id, soliderCfgId, soliderCount)
        elseif self.btnType == PnlSoldier.BTNTYPE_TRAINING then
            BuildData.C2S_Player_SoliderTrain(id, soliderCfgId, soliderCount)
        end
    end   
    self:close()
end

function PnlSoldier:onBtnMsg(temp)
    
end

function PnlSoldier:setViewChange()
    local view = self.view
    view.viewSoldier:SetActive(false)
    view.viewChange:SetActive(true)

    self.soldierTable = {}
    local startX = 104 
    local startY = -127 
    local nextPosX = 180
    local nextPosY = -180
    local index = 0
    local viewHigh = 0
    local soldierDataTable = self:quickSort()

    for k, v in pairs(soldierDataTable) do
        local cfg = self:getCfg(v.cfgId, v.level)
        ResMgr:LoadGameObjectAsync("BtnSoldier", function(obj)
            local args = index
            local lineI = args % 5
            local rowI = args / 5
            rowI = math.modf(rowI)
            index = index + 1
            local posX = startX + lineI * nextPosX
            local posY = startY + rowI * nextPosY

            obj.transform:SetParent(self.view.viewContent, false)
            obj.transform.localPosition = Vector3(posX, posY, 0)

            local name = cfg.name
            local level = cfg.level
            local maxTrainSpace = self.maxTrainSpace
            local trainSpace = cfg.trainSpace
            local count = maxTrainSpace / trainSpace
            count = math.modf(count)
            local trainNeedStarCoin = cfg.trainNeedStarCoin * count
            local trainNeedTick = cfg.trainNeedTick * count

            obj.transform:Find("TxtName"):GetComponent("Text").text = name
            if level > 0 then
                obj.transform:Find("HaveSoldier").gameObject:SetActive(true)
                obj.transform:Find("HaveSoldier/TxtLevel"):GetComponent("Text").text = level
                obj.transform:Find("ViewCost").gameObject:SetActive(true)
                obj.transform:Find("TxtUnlock").gameObject:SetActive(false)
                local hms = gg.time:hms_string(trainNeedTick)
                obj.transform:Find("ViewCost/TxtTime"):GetComponent("Text").text = hms
                obj.transform:Find("ViewCost/TxtStarCoin"):GetComponent("Text").text = trainNeedStarCoin
            else
                obj.transform:Find("HaveSoldier").gameObject:SetActive(false)
                obj.transform:Find("ViewCost").gameObject:SetActive(false)
                obj.transform:Find("TxtUnlock").gameObject:SetActive(true)
            end

            args = args + 1
            local btnMsg = obj.transform:Find("BtnMsg").gameObject
            CS.UIEventHandler.Get(obj):SetOnClick(function()
                self:onBtnSoldier(args)
            end)
            CS.UIEventHandler.Get(btnMsg):SetOnClick(function()
                self:onBtnMsg(args)
            end)
            local data = {obj = obj, cfg = cfg, btnMsg = btnMsg} 
            self.soldierTable[args] = data
            return true
        end, true)
    end
    local max = #soldierDataTable
    local rowI = (max - 1) / 5
    rowI = math.modf(rowI)
    local viewHigh = startY + rowI * nextPosY - 100
    self.view.viewContent:GetComponent("RectTransform").sizeDelta =  Vector2.New(0, -viewHigh)
end

function PnlSoldier:releaseResources()
    if self.soldierTable then
        for k, v in pairs(self.soldierTable) do
            CS.UIEventHandler.Clear(v.obj)
            CS.UIEventHandler.Clear(v.btnMsg)
            ResMgr:ReleaseAsset(v.obj)
            v = nil
        end
        self.soldierTable = nil
    end
end

function PnlSoldier:getTableCount(temp)
    local num = 0
    if temp then
        for k, v in pairs(temp) do
            num = num + 1
        end
    end
    return num
end

function PnlSoldier:getCfg(cfgId, level)
    local allCfg = cfg.get("etc.cfg.solider")
    local cfg = nil
    for k, v in ipairs(allCfg) do
        if v.cfgId == cfgId and v.level == level then
            cfg = v
        end
    end
    return cfg
end

function PnlSoldier:quickSort()
    local temp = {}
    for k, v in pairs(BuildData.soliderLevelData) do
        local lessTick = v.lessTick
        local cfgId = v.cfgId
        local level = v.level
        local sort = cfgId
        if level > 0 then
            sort = sort - 10000000
        end
        local data = {lessTick = lessTick, cfgId = cfgId, level = level, sort = sort}
        table.insert(temp, data)
    end
    QuickSort:quickSort(temp, 1, #temp, "up")
    return temp
end

return PnlSoldier