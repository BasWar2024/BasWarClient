PnlSoldier = class("PnlSoldier", ggclass.UIBase)

PnlSoldier.BTNTYPE_CHANGE = 1
PnlSoldier.BTNTYPE_TRAINING = 2
PnlSoldier.BTNTYPE_INTANT = 3
PnlSoldier.BTNTYPE_SUPPLEMENT = 4

function PnlSoldier:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = {"onUpdateBuildData"}

    self.needBlurBG = true
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlSoldier:onAwake()
    self.view = ggclass.PnlSoldierView.new(self.pnlTransform)

end

function PnlSoldier:onShow()
    self:bindEvent()
    self:setData()
    self:setView()
end

function PnlSoldier:onUpdateBuildData(args, build)
    if build.id == self.buildId then
        self.args.buildData = build
        self.args.buildCfg = BuildUtil.getCurBuildCfg(build.cfgId, build.level, build.quality)

        self:setData()
        self:setView()
    end
end

function PnlSoldier:setData()
    self.buildId = self.args.buildData.id
    self.soliderCount = self.args.buildData.soliderCount
    self.lessTrainTick = self.args.buildData.lessTrainTick
    self.lessTick = self.args.buildData.lessTick
    self.trainCount = self.args.buildData.trainCount

    self.maxTrainSpace = self.args.buildCfg.maxTrainSpace

    self.soliderCfgId = self.args.buildData.soliderCfgId

    if self.soliderCfgId == 0 then
        self.soliderCfgId = self.args.buildData.trainCfgId
    end
    if self.soliderCfgId ~= 0 then
        local soldierLevel = 1
        for k, v in pairs(BuildData.soliderLevelData) do
            if self.soliderCfgId == v.cfgId then
                soldierLevel = v.level
            end
        end
        self.soliderCfg = self:getCfg(self.soliderCfgId, soldierLevel)
        self.soliderCountMax = self.maxTrainSpace / self.soliderCfg.trainSpace
        self.soliderCountMax = math.modf(self.soliderCountMax)
    end
end

function PnlSoldier:setView()
    local soliderCount = self.soliderCount
    local lessTrainTick = self.lessTrainTick
    local view = self.view
    if soliderCount == 0 and lessTrainTick == 0 and self.soliderCfgId == 0 then
        -- ""
        self.btnType = PnlSoldier.BTNTYPE_TRAINING
        self:setViewChange()
    else
        view.viewBg:SetActiveEx(false)
        view.viewChange:SetActive(false)
        view.viewSoldier:SetActive(true)
        local iconC = self.soliderCfg.icon .. "_C"
        local iconSoldier = view.viewSoldier.transform:Find("IconSoldier"):GetComponent(UNITYENGINE_UI_IMAGE)
        gg.setSpriteAsync(iconSoldier, iconC)
        view.txtTitle.text = Utils.getText("landingShip_Title") --"LANDING SHIP"
        view.txtCurNum.text = "x" .. self.soliderCount
        view.curCommonItemItemD1:setQuality(SoliderUtil.getSoldierQuality(self.soliderCfg.cfgId))
        local iconB = gg.getSpriteAtlasName("Soldier_A_Atlas", self.soliderCfg.icon .. "_A")
        view.curCommonItemItemD1:setIcon(iconB)

        if lessTrainTick > 0 then
            -- ""
            self:setBtnToolView(PnlSoldier.BTNTYPE_INTANT)
        else
            local count = self.soliderCountMax - self.soliderCount
            if count == 0 then
                -- ""
                view.boxTool:SetActive(false)
                view.layoutTool:SetActiveEx(false)
            else
                -- ""
                self:setBtnToolView(PnlSoldier.BTNTYPE_SUPPLEMENT)
            end
        end
    end
end

function PnlSoldier:setBtnToolView(type)
    local view = self.view
    view.boxTool:SetActive(true)
    view.layoutTool:SetActiveEx(true)
    local count = 0
    local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", self.soliderCfg.icon .. "_A")
    self.view.toolCommonItemItemD1:setQuality(SoliderUtil.getSoldierQuality(self.soliderCfg.cfgId))
    self.view.toolCommonItemItemD1:setIcon(icon)

    local iconCostName = ""
    local txtName = ""
    local costNum = 0
    local tick = 0
    self.btnType = type
    if type == PnlSoldier.BTNTYPE_INTANT then
        self.view.txtTime.transform:SetActiveEx(false)
        self.view.slider.transform:SetActiveEx(true)

        iconCostName = constant.RES_2_CFG_KEY[constant.RES_CARBOXYL].icon
        txtName = Utils.getText("res_FinishNow")
        count = self.trainCount
        local time = self.args.buildData.lessTrainTickEnd -- self.lessTrainTick + os.time()
        costNum = math.ceil((self.lessTrainTick / 60)) * cfg.global.SpeedUpPerMinute.intValue

        local totalTime = self.soliderCfg.trainNeedTick * count
        self:startLoopTick(time, totalTime)
    elseif type == PnlSoldier.BTNTYPE_SUPPLEMENT then
        self.view.txtTime.transform:SetActiveEx(true)
        self.view.slider.transform:SetActiveEx(false)

        iconCostName = constant.RES_2_CFG_KEY[constant.RES_STARCOIN].icon
        txtName = Utils.getText("landingShip_Supplement")
        count = self.soliderCountMax - self.soliderCount
        local cost = self.soliderCfg.trainNeedStarCoin * count
        local time = self.soliderCfg.trainNeedTick * count
        costNum = cost
        tick = time
    end
    view.txtToolNum.text = "x" .. count
    view.btnTool.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = txtName
    view.txtCost.text = Utils.getShowRes(costNum)
    tick = gg.time:dhms_string(tick)
    view.txtTime.text = tick

    gg.setSpriteAsync(view.iconCost, iconCostName)

end

function PnlSoldier:stopLessTick()
    if self.lessTickTimer then
        gg.timer:stopTimer(self.lessTickTimer)
        self.lessTickTimer = nil
    end
end

function PnlSoldier:startLoopTick(tick, totalTime)
    self:stopLessTick()
    self.lessTickTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = tick - os.time()
        if time <= 0 then
            self:stopLessTick()
        end

        self.view.txtSlider.text = gg.time:dhms_string(time)
        self.view.slider.value = time / totalTime
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
    view.curCommonItemItemD1:release()
    view.toolCommonItemItemD1:release()
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
        -- ""
    elseif self.btnType == PnlSoldier.BTNTYPE_SUPPLEMENT then
        -- ""
        local soliderCfgId = self.soliderCfg.cfgId
        local maxTrainSpace = self.maxTrainSpace
        local trainSpace = self.soliderCfg.trainSpace
        local soliderCountMax = maxTrainSpace / trainSpace
        soliderCountMax = math.modf(soliderCountMax)

        local count = soliderCountMax - self.soliderCount
        BuildData.C2S_Player_SoliderTrain(id, soliderCfgId, count)
    end
    self:close()
end

function PnlSoldier:onBtnSoldier(temp, isInstance)
    local lessTick = self.lessTick
    if lessTick > 0 then
        local text = "Upgrading the landing ship"
        gg.uiManager:showTip(text)
        return
    end
    local level = self.soldierTable[temp].cfg.level
    if level <= 0 then
        local text = "Research to unlock"
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
            BuildData.C2S_Player_SoliderTrain(id, soliderCfgId, soliderCount, isInstance)
        end
    end
    self:close()
end

function PnlSoldier:onBtnMsg(temp)
    local data = self.soldierTable[temp]
    SoliderUtil.showSoldierInfo(data.cfg)
end

function PnlSoldier:setViewChange()
    local view = self.view
    view.viewSoldier:SetActive(false)
    view.viewChange:SetActive(true)
    view.viewBg:SetActiveEx(true)

    view.txtTitle.text = Utils.getText("landingShip_Change_Title")

    self.soldierTable = {}
    local startX = 104
    local startY = -127
    local nextPosX = 180
    local nextPosY = -180
    local index = 0
    local viewHigh = 0
    local soldierDataTable = self:quickSort()

    for k, v in pairs(soldierDataTable) do
        local myCfg = self:getCfg(v.cfgId, v.level)
        if myCfg then
            -- ""，""
            local isWhiteList = SoliderUtil.isInSoldierWhiteList(myCfg.cfgId)
            if isWhiteList then
                local args = index
                index = index + 1
                ResMgr:LoadGameObjectAsync("BtnSoldier", function(obj)
                    obj.transform:SetParent(self.view.viewContent, false)
                    local name = myCfg.name
                    local level = myCfg.level
                    local maxTrainSpace = self.maxTrainSpace
                    local trainSpace = myCfg.trainSpace
                    local count = math.modf(maxTrainSpace / trainSpace)
                    local trainNeedStarCoin = myCfg.trainNeedStarCoin * count
                    local trainNeedTick = myCfg.trainNeedTick * count

                    local objTransfrom = obj.transform
                    local soldierCommonItemItem = CommonItemItemD1.new(objTransfrom:Find("CommonItemItemD1"))
                    soldierCommonItemItem:open()
                    local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", myCfg.icon .. "_A")
                    soldierCommonItemItem:setIcon(icon)

                    local txtCount = obj.transform:Find("TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)

                    obj.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = name
                    soldierCommonItemItem:setQuality(SoliderUtil.getSoldierQuality(v.cfgId))
                    if level > 0 then

                        -- -- soldierCommonItemItem:setLevel("Lv." .. level)
                        -- soldierCommonItemItem:setLevel(count .. "X")
                        txtCount.gameObject:SetActiveEx(true)
                        txtCount.text = count
                        obj.transform:Find("ViewCost").gameObject:SetActive(true)
                        obj.transform:Find("ImgGray").gameObject:SetActive(false)
                        local hms = gg.time:dhms_string(trainNeedTick)
                        obj.transform:Find("ViewCost/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = hms
                        obj.transform:Find("ViewCost/TxtStarCoin"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getShowRes(trainNeedStarCoin)
                    else
                        txtCount.gameObject:SetActiveEx(false)
                        obj.transform:Find("ViewCost").gameObject:SetActive(false)
                        obj.transform:Find("ImgGray").gameObject:SetActive(true)
                    end

                    args = args + 1
                    local btnMsg = obj.transform:Find("BtnMsg").gameObject
                    if self.soliderCfgId == myCfg.cfgId then
                        obj.transform:Find("Selected").gameObject:SetActive(true)
                    else
                        obj.transform:Find("Selected").gameObject:SetActive(false)
                        CS.UIEventHandler.Get(obj):SetOnClick(function()
                            self:onBtnSoldier(args)
                        end)
                    end
                    CS.UIEventHandler.Get(btnMsg):SetOnClick(function()
                        self:onBtnMsg(args)
                    end)
                    local data = {
                        args = args,
                        obj = obj,
                        cfg = myCfg,
                        btnMsg = btnMsg,
                        soldierCommonItemItem = soldierCommonItemItem
                    }
                    self.soldierTable[args] = data
                    return true
                end, true)
            end
        end
    end
end

function PnlSoldier:releaseResources()
    if self.soldierTable then
        for k, v in pairs(self.soldierTable) do
            CS.UIEventHandler.Clear(v.obj)
            CS.UIEventHandler.Clear(v.btnMsg)
            ResMgr:ReleaseAsset(v.obj)
            v.soldierCommonItemItem:release()
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
    local allCfg = cfg["solider"]
    local myCfg = nil
    for k, v in pairs(allCfg) do
        if v.cfgId == cfgId and v.level == level then
            myCfg = v
        end
    end
    return myCfg
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
        local data = {
            lessTick = lessTick,
            cfgId = cfgId,
            level = level,
            sort = sort
        }
        table.insert(temp, data)
    end
    QuickSort.quickSort(temp, "sort", 1, #temp, "up")
    return temp
end

--override
function PnlSoldier:getGuideRectTransform(guideCfg)
    if guideCfg.gameObjectName == "CreateSoldier" then
        for key, value in pairs(self.soldierTable) do
            if value.cfg.cfgId == guideCfg.otherArgs[1] then
                self.selectItem = value
                return value.obj
            end
        end
    end
    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

--override
function PnlSoldier:triggerGuideClick(guideCfg)
    if guideCfg.gameObjectName == "CreateSoldier" then

        if self.selectItem then
            self:onBtnSoldier(self.selectItem.args, true)
        end
        return
    end

    ggclass.UIBase.triggerGuideClick(self, guideCfg)
end

return PnlSoldier
