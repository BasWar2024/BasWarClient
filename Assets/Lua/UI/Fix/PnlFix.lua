
PnlFix = class("PnlFix", ggclass.UIBase)

function PnlFix:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.layer = UILayer.normal
    self.events = {
                    "onItemSort",
                    "onItemRepareChange",
                }

    self.fixItemDataList = {}
    self.fixItemList = {}
    self.showingItemData = nil
    self.showingItemCfg = nil
end

function PnlFix:onAwake()
    self.view = ggclass.PnlFixView.new(self.transform)
end

function PnlFix:onShow()
    self:bindEvent()
    local view = self.view
    self.scrollView = UIScrollView.new(view.scrollViewCanFix, "FixItem", self.fixItemList)

    self.scrollView:setRenderHandler(function (obj, index)
        self:renderHandler(obj, index)
    end)

    self:refreshFixScroll()
    self:refreshFixAll()
    self.showingItemData = nil
    self.showingItemCfg = nil
    self:refreshFixMessage()
end

function PnlFix:onHide()
    self:releaseEvent()

    if self.timer then
        gg.timer:stopTimer(self.timer)
        self.timer = nil
    end
end

function PnlFix:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnBG):SetOnClick(function()
        self:onBtnBG()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnFix):SetOnClick(function()
        self:onBtnFix()
    end)
    CS.UIEventHandler.Get(view.btnFixAll):SetOnClick(function()
        self:onBtnFixAll()
    end)

    self:setOnClick(view.btnInstant, function()
        self:onBtnInstant()
    end)
end

function PnlFix:onItemSort()
    self:refreshFixScroll()
    self:refreshFixAll()
    if self.showingItemData then
        local id = self.showingItemData.id
        self.showingItemData = nil
        for key, value in pairs(self.fixItemDataList) do
            if value.id == id then
                self.showingItemData = value
                break
            end
        end
    end
    self:refreshFixMessage()
end

function PnlFix:onItemRepareChange()
    self:refreshFixMessage()
end

function PnlFix:refreshFixScroll()
    self.fixItemDataList = {}
    for key, value in pairs(ItemData.itemBagData) do
        if value.curLife ~= nil and value.life ~= nil and value.curLife < value.life then
            table.insert(self.fixItemDataList, value)
        end
    end

    table.sort(self.fixItemDataList, function (a, b)
        return a.curLife < b.curLife
    end)
    self.scrollView:setItemCount(#self.fixItemDataList)
end

function PnlFix:renderHandler(obj, index)
    local item = FixItem:getItem(obj, self.fixItemList, self)
    item:setData(self.fixItemDataList[index])
end

function PnlFix:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnBG)
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnFix)
    CS.UIEventHandler.Clear(view.btnFixAll)
end

function PnlFix:onDestroy()
    self.scrollView:release()
end

function PnlFix:onBtnBG()
end

function PnlFix:onBtnClose()
    self:close()
end

function PnlFix:onBtnInstant()
    if not self.showingItemData then
        return
    end
    local callbackYes = function ()
        ItemData.C2S_Player_RepairSpeed(self.showingItemData.id)
    end
    local args = {
        txt = string.format("Are you sure Pay %s MIT to Reinforce?", self.quickCost),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlFix:onBtnFixAll()
    if #self.fixItemDataList <= 0 then
        return
    end
    local callbackYes = function ()
        local fixIdList = {}
        for key, value in pairs(self.fixItemDataList) do
            table.insert(fixIdList, value.id)
        end
        ItemData.C2S_Player_Repair(fixIdList)
    end
    local args = {
        txt = string.format("Are you sure Pay %s MIT to Fix All Item?", self.totalCost),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlFix:onBtnFix()
    if not self.showingItemData and ItemData.isFixing(self.showingItemData.id) then
        return
    end

    local callbackYes = function ()
        ItemData.C2S_Player_Repair({self.showingItemData.id})
    end

    local args = {
        txt = string.format("Are you sure pay %s MIT to fix?", self.cost),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlFix:chooseFixItem(data, itemCfg)
    self.showingItemData = data
    self.showingItemCfg = itemCfg
    --if data and itemCfg then
        self:refreshFixMessage()
    --end
end

function PnlFix:refreshFixMessage()
    local view = self.view
    if self.showingItemData then
        -- view.btnFix:SetActiveEx(true)
        view.btnFixAll:SetActiveEx(true)
        view.btnInstant:SetActiveEx(true)
        -- view.btnInstant:SetActiveEx(not ItemUtil:isFixing(self.showingItemData.id))
        view.btnFix:SetActiveEx(not ItemUtil:isFixing(self.showingItemData.id))

        view.imgBuilding.gameObject:SetActiveEx(true)
        view.slider.value = self.showingItemData.curLife / self.showingItemData.life
        view.textSlider.text = string.format("%s/%s", self.showingItemData.curLife, self.showingItemData.life)

        local globalCfg = cfg.get("etc.cfg.global")
        local repareCfg = globalCfg.RepairCostPerLife

        local cost = repareCfg.intValue * (self.showingItemData.life - self.showingItemData.curLife)
        self.cost = cost

        view.txtCost.text = "X" .. cost
        ResMgr:LoadSpriteAsync(self.showingItemCfg.icon, function(sprite)
            view.imgBuilding.sprite = sprite
        end)

        local quickCost = math.ceil((self.showingItemData.life - self.showingItemData.curLife) * 10 / 60) * globalCfg.RepairSpeedCost.intValue
        self.quickCost = quickCost
        view.txtInstantCost.text = quickCost

        local fixData = ItemUtil:getFixingData(self.showingItemData.id)
        if self.timer then
            gg.timer:stopTimer(self.timer)
            self.timer = nil
        end
        if fixData then
            view.sliderFix.transform:SetActiveEx(true)
            self.timer = gg.timer:startLoopTimer(0, 0.3, 999999999, function()
                local time = fixData.endTime - os.time()
                if time > 0 then
                    local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
                    view.tmpSliderFix.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)
                    view.sliderFix.value = (fixData.lessTick - time)  / fixData.lessTick
                end
            end)
        else
            view.sliderFix.transform:SetActiveEx(false)
        end
    else
        view.slider.value = 0
        view.textSlider.text = ""
        view.imgBuilding.sprite = nil
        view.btnFix.gameObject:SetActiveEx(false)
        view.btnFixAll.gameObject:SetActiveEx(false)
        view.btnInstant:SetActiveEx(false)
        view.imgBuilding.gameObject:SetActiveEx(false)
    end
end

function PnlFix:refreshFixAll()
    local repareCfg = cfg.get("etc.cfg.global").RepairCostPerLife
    local totalCost = 0
    for key, value in pairs(self.fixItemDataList) do
        if not ItemUtil:isFixing(value.id) then
            totalCost = totalCost + (value.life - value.curLife) * repareCfg.intValue
        end
    end
    self.view.txtCostAll.text = "X" .. totalCost
    self.totalCost = totalCost
end

return PnlFix