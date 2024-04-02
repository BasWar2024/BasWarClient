
PnlFix = class("PnlFix", ggclass.UIBase)

function PnlFix:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = {
                    "onItemSort",
                    "onItemRepareChange",
                    "onHeroChange",
                    "onRefreshWarShipData",
                    "onUpdateBuildData",
                }

    self.fixItemDataList = {}
    self.fixItemList = {}
    self.showingItemData = nil

    self.needBlurBG = true
end

function PnlFix:onAwake()
    self.view = ggclass.PnlFixView.new(self.pnlTransform)
    self.scrollView = UIScrollView.new(self.view.scrollViewCanFix, "FixItem", self.fixItemList)
    self.scrollView:setRenderHandler(function (obj, index)
        self:renderHandler(obj, index)
    end)

    self.commonUpgradePartFix = CommonUpgradePart.new(self.view.commonUpgradePartFix)
    self.commonUpgradePartFix:setClickCallback(gg.bind(self.onBtnFix, self))
    self.commonUpgradePartFix:setBtnData({})
    self.commonUpgradePartFix:setInstanceCostActive(false)

    self.commonUpgradePartInstant = CommonUpgradePart.new(self.view.commonUpgradePartInstant)
    self.commonUpgradePartInstant:setBtnData({})
    self.commonUpgradePartInstant:setClickCallback(gg.bind(self.onBtnInstant, self))
    self.commonUpgradePartInstant:setInstanceCostActive(false)
end

function PnlFix:onShow()
    self:bindEvent()
    local view = self.view
    self.showingItemData = nil
    self:refreshFixMessage()
    self:refreshFixScroll()
    
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
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnFixAll):SetOnClick(function()
        self:onBtnFixAll()
    end)
end

function PnlFix:onItemSort()
    self:refreshFixScroll()
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

function PnlFix:onHeroChange()
    self:onItemSort()
end

function PnlFix:onRefreshWarShipData()
    self:onItemSort()
end

function PnlFix:onUpdateBuildData()
    self:onItemSort()
end

function PnlFix:onItemRepareChange()
    self:refreshFixMessage()
    self:refreshFixScroll()
end

-- data = {id , repairLessTickEnd, icon, life, curLife, quality}
function PnlFix:refreshFixScroll()
    self.fixItemDataList = {}

    for key, value in pairs(ItemData.itemBagData) do
        if value.entity.curLife ~= nil and value.entity.life ~= nil and value.entity.curLife < value.entity.life then
            local itemCfg = cfg.item[value.cfgId]
            local entity = value.entity
            table.insert(self.fixItemDataList, FixItem.getNewItemData(value.id, entity.repairLessTickEnd, 
                itemCfg.icon, entity.life, entity.curLife, ItemUtil.getItemQualityByItemData(value), itemCfg.name))
        end
    end

    for key, value in pairs(HeroData.heroDataMap) do
        if value.curLife < value.life then
            local heroCfg = HeroUtil.getHeroCfg(value.cfgId, value.level, value.quality)
            table.insert(self.fixItemDataList, 
                FixItem.getNewItemData(value.id, value.repairLessTickEnd, heroCfg.icon, value.life, value.curLife, value.quality, heroCfg.name))
        end
    end

    for key, value in pairs(WarShipData.warShipData) do
        if value.curLife < value.life then
            local warshipCfg = WarshipUtil.getWarshipCfg(value.cfgId, value.quality, value.level)
            table.insert(self.fixItemDataList, 
                FixItem.getNewItemData(value.id, value.repairLessTickEnd, warshipCfg.icon, value.life, value.curLife, value.quality, warshipCfg.name))
        end
    end

    -- for key, value in pairs(BuildData.buildData) do
    --     if value.curLife < value.life then
    --         local buildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)
    --         table.insert(self.fixItemDataList, 
    --             FixItem.getNewItemData(value.id, value.repairLessTickEnd, buildCfg.icon, value.life, value.curLife, value.quality, buildCfg.name))
    --     end
    -- end

    table.sort(self.fixItemDataList, function (a, b)
        return a.curLife < b.curLife
    end)

    local itemCount = #self.fixItemDataList
    local showItemCount = math.max(math.ceil(itemCount / 5) * 5, 10)
    self.scrollView:setItemCount(showItemCount)

    self:refreshFixAll()
end

function PnlFix:renderHandler(obj, index)
    local item = FixItem:getItem(obj, self.fixItemList, self)
    item:setData(self.fixItemDataList[index])
end

function PnlFix:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnFixAll)
end

function PnlFix:onDestroy()
    self.scrollView:release()
    self.commonUpgradePartFix:release()
    self.commonUpgradePartInstant:release()
end

function PnlFix:onBtnClose()
    self:close()
end

function PnlFix:onBtnInstant()
    if not self.showingItemData then
        return
    end
    local callbackYes = function ()
        
    end
    local args = {
        txt = string.format("Are you sure to consume %s Hydroxyl to complete repairment now?",  Utils.getShowRes(self.quickCost)),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlFix:onBtnFixAll()
    if #self.fixItemDataList <= 0 or self.totalCost <= 0 then
        return
    end
    local callbackYes = function ()
        local fixIdList = {}
        for key, value in pairs(self.fixItemDataList) do
            table.insert(fixIdList, value.id)
        end
        
    end
    local args = {
        txt = string.format("Are you sure to consume %s Hydroxyl to complete All repairment now?", Utils.getShowRes(self.totalCost)),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlFix:onBtnFix()
    if not self.showingItemData or self.showingItemData.repairLessTickEnd > os.time() then
        return
    end

    local callbackYes = function ()
        
    end

    local args = {
        txt = string.format("Are you sure pay %s Hydroxyl to fix?", Utils.getShowRes(self.cost)),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlFix:chooseFixItem(data, itemCfg)
    self.showingItemData = data

    self:refreshFixMessage()
    for key, value in pairs(self.fixItemList) do
        value:refreshSelect()
    end
end

function PnlFix:refreshFixMessage()
    local view = self.view
    if self.showingItemData then
        view.imgBuilding.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(view.imgBuilding, self.showingItemData.icon .. "_C")

        view.txtName.text = self.showingItemData.name
        view.txtName.color = constant.COLOR_QUALITY[self.showingItemData.quality]
        local present = self.showingItemData.curLife / self.showingItemData.life
        view.slider.value = present
        view.textSlider.text = (present - present % 0.001) * 100 .. "%"

        local globalCfg = cfg["global"]
        local repareCfg = globalCfg.RepairCostPerLife

        self.cost = repareCfg.intValue * ( self.showingItemData.life -  self.showingItemData.curLife)

        local fixTime = ( self.showingItemData.life -  self.showingItemData.curLife) * globalCfg.RepairTimePerLife.intValue
        self.quickCost = math.ceil(fixTime / 60) * globalCfg.RepairSpeedCost.intValue

        if self.showingItemData.repairLessTickEnd > os.time() then

            self.commonUpgradePartFix:setActive(false)
            self.commonUpgradePartInstant:setActive(true)

            local totalTime = (self.showingItemData.life - self.showingItemData.curLife) * cfg.global.RepairTimePerLife.intValue
            self.commonUpgradePartInstant:setSliderData(true, self.showingItemData.repairLessTickEnd, totalTime, true, function (time)
                self.quickCost = math.ceil(time / 60) * globalCfg.RepairSpeedCost.intValue
                self.commonUpgradePartInstant:setBtnData({{icon = constant.RES_2_CFG_KEY[constant.RES_CARBOXYL].icon, cost = self.quickCost}})
            end)
        else
            self.commonUpgradePartFix:setActive(true)

            self.commonUpgradePartFix:setBtnData({{icon = constant.RES_2_CFG_KEY[constant.RES_CARBOXYL].icon, cost = self.cost}})
            self.commonUpgradePartFix:setSliderData(true, fixTime + os.time(), fixTime, false)

            self.commonUpgradePartInstant:setActive(true)
            self.commonUpgradePartInstant:setBtnData({{icon = constant.RES_2_CFG_KEY[constant.RES_CARBOXYL].icon, cost = self.quickCost}})
            self.commonUpgradePartInstant:setSliderData(false)
        end

        if self.timer then
            gg.timer:stopTimer(self.timer)
            self.timer = nil
        end

    else
        view.slider.value = 0
        view.textSlider.text = ""
        view.bgItem.gameObject:SetActiveEx(false)
        view.imgBuilding.gameObject:SetActiveEx(false)

        self.commonUpgradePartFix:setActive(true)
        self.commonUpgradePartFix:setSliderData(false)

        self.commonUpgradePartInstant:setActive(true)
        self.commonUpgradePartInstant:setSliderData(false)
    end
end

function PnlFix:refreshFixAll()
    local view = self.view

    local repareCfg = cfg["global"].RepairCostPerLife
    local totalCost = 0

    local totalLife = 0
    local totalCurLife = 0
    local time =  os.time()
    for key, value in pairs(self.fixItemDataList) do
        -- if value.repairLessTickEnd < time then
            totalCost = totalCost + (value.life - value.curLife) * repareCfg.intValue
            totalLife = totalLife + value.life
            totalCurLife = totalCurLife + value.curLife
        -- end
    end

    self.view.txtCostAll.text = Utils.getShowRes(totalCost)
    self.totalCost = totalCost
    view.sliderLifeAll.value = totalCurLife / totalLife
    view.txtSliderLifeAll.text = string.format("<color=#ffffff>%s</color>/%s", totalCurLife, totalLife)
end

return PnlFix