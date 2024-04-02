
CommonUpgradeNewBox = CommonUpgradeNewBox or class("CommonUpgradeNewBox", ggclass.UIBaseItem)
function CommonUpgradeNewBox:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

CommonUpgradeNewBox.events = {"onRefreshResTxt"}

function CommonUpgradeNewBox:onInit()
    self.commonUpgradePartList = {}

    for i = 1, 2 do
        self.commonUpgradePartList[i] = CommonUpgradePart.new(self:Find("LayoutBtns/CommonUpgradePart" .. i))
        self.commonUpgradePartList[i]:setClickCallback(gg.bind(self.onBtn, self, i))
    end
    self.commonUpgradePartList[2]:setInstanceCostActive(false)

    self.sliderUpgrade = self:Find("SliderUpgrade", "Slider")
    self.txtSlider = self.sliderUpgrade.transform:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)
end

function CommonUpgradeNewBox:onBtn(index)
    if not Utils.checkAndAlertEnoughtMit(self.levelUpNeedMit, true) then
        return
    end

    if index == 1 then
        if not Utils.checkAndAlertEnoughtRes(constant.RES_TESSERACT , self.instanceCost, true) then
            return
        end

        local callbackYes = function ()
            if self.instantCB then
                self.instantCB()
            end
        end

        local txt = string.format(Utils.getText("res_FinishNow_AskText"), Utils.getShowRes(self.instanceCost))
        local args = {callbackYes = callbackYes, 
                        txt = txt, 
                        -- autoCloseRequirement = self.alertAutoCloseRequirement,
                    }
        if self.levelUpNeedMit and self.levelUpNeedMit > 0 then
            args.yesCostList = {
                {cost = self.instanceCost, resId = constant.INSTANCE_COST_RES},
                {cost = self.levelUpNeedMit, resId = constant.RES_MIT},
            }
        else
            args.yesCostList = {{cost = self.instanceCost, resId = constant.INSTANCE_COST_RES},}
        end

        if self.isUpgradeing then
            args.autoCloseLessTick =  self.lessTickEnd - os.time()
        end

        gg.uiManager:openWindow("PnlAlert", args)

    elseif index == 2 then
        local exchangeInfo = nil
        if self.exchangeInfoFunc then
            exchangeInfo = self.exchangeInfoFunc()
        end

        if not Utils.checkIsEnoughtLevelUpRes(self.curCfg, true, gg.bind(self.upgradeCB, true), exchangeInfo) then
            return
        end

        if self.upgradeCB then
            self.upgradeCB(false)
        end
    end
end

function CommonUpgradeNewBox:onRelease()
    for index, value in ipairs(self.commonUpgradePartList) do
        value:release()
    end
    self.sliderUpgrade:DOKill()
    gg.timer:stopTimer(self.upgradeTimer)
end

function CommonUpgradeNewBox:onRefreshResTxt()
    if self.curCfg then
        self:setMessage(self.curCfg, self.lessTickEnd, self.needShowResList)
    end
end

--""
function CommonUpgradeNewBox:setMessage(curCfg, lessTickEnd, needShowResList, alertAutoCloseRequirement)
    self.needShowResList = needShowResList or {
        constant.RES_MIT,
        constant.RES_STARCOIN,
        constant.RES_GAS,
        constant.RES_TITANIUM,
        constant.RES_CARBOXYL,
        constant.RES_ICE,
        constant.RES_TESSERACT,
    }
    self.lessTickEnd = lessTickEnd
    self.isUpgradeing = lessTickEnd - os.time() > 0
    self.curCfg = curCfg
    self.alertAutoCloseRequirement = alertAutoCloseRequirement
    local upgradeDataList = {}
    local upgradeDataList2 = {}
    -- curCfg.levelUpNeedMit = 500000

    self.levelUpNeedMit = 0

    for index, value in ipairs(self.needShowResList) do
        local cost = curCfg[constant.RES_2_CFG_KEY[value].levelUpKey]
        if cost and cost > 0 then
            local color = nil
            if cost > ResData.getRes(value) then
                color = constant.COLOR_RED
            end
            local costData = {icon = constant.RES_2_CFG_KEY[value].icon, cost = cost, color = color, resId = value}
            table.insert(upgradeDataList, costData)
            if value == constant.RES_MIT and not self.isUpgradeing then
                table.insert(upgradeDataList2, costData)
                self.levelUpNeedMit = cost
            end
        end
    end

    -- local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, curCfg.levelUpNeedTick)
    -- table.insert(upgradeDataList, 1, {icon = "Time_icon_153", text = string.format("%sH%sM%sS", hms.hour, hms.min, hms.sec)})

    self.commonUpgradePartList[1]:setBtnData(upgradeDataList2)
    gg.timer:stopTimer(self.upgradeTimer)

    self.sliderUpgrade.gameObject:SetActiveEx(false)
    self.levelUpNeedResCostHydroxyl = ResUtil.getLevelUpNeedResCostTesseract(curCfg)

    if self.isUpgradeing then
        self.commonUpgradePartList[2]:setActive(false)
        self.commonUpgradePartList[1]:setSliderData(true, lessTickEnd, curCfg.levelUpNeedTick, true, function (time)
            self.instanceCost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue
            self.commonUpgradePartList[1]:setInstanceCost(self.instanceCost)
        end)
    else
        self.instanceCost = math.ceil(curCfg.levelUpNeedTick / 60) * cfg.global.SpeedUpPerMinute.intValue + self.levelUpNeedResCostHydroxyl
        self.commonUpgradePartList[1]:setInstanceCost(self.instanceCost)

        self.commonUpgradePartList[1]:setSliderData(false)

        self.commonUpgradePartList[2]:setActive(true)
        self.commonUpgradePartList[2]:setBtnData(upgradeDataList)
        self.commonUpgradePartList[2]:setSliderData(true, curCfg.levelUpNeedTick + os.time(), curCfg.levelUpNeedTick, false)
    end
end

function CommonUpgradeNewBox:setInstantCallback(callback)
    self.instantCB = callback
end

-- upgradeCB""isOnExchange
function CommonUpgradeNewBox:setUpgradeCallback(callback)
    self.upgradeCB = callback
end

-- ""， ""PnlQuickExchange
-- exchangeInfo = {extraExchangeCost = , text = }
function CommonUpgradeNewBox:setExchangeInfoFunc(exchangeInfoFunc)
    self.exchangeInfoFunc = exchangeInfoFunc
end

function CommonUpgradeNewBox:setPart2Text(text)
    self.commonUpgradePartList[2]:setBtnText(text)
end
function CommonUpgradeNewBox:setPart2Sprite(spriteName)
    self.commonUpgradePartList[2]:setBtnSprite(spriteName)
end

---------------------------------------------------------------------------------------------------

CommonUpgradePart = CommonUpgradePart or class("CommonUpgradePart", ggclass.UIBaseItem)

function CommonUpgradePart:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonUpgradePart:onInit()
    self.layoutCost = self:Find("LayoutCost", UNITYENGINE_UI_HORIZONTALLAYOUTGROUP)
    self.layoutCost2 = self:Find("LayoutCost2", UNITYENGINE_UI_HORIZONTALLAYOUTGROUP)

    self.instanceUpgradeCostItem = self:getCostItem(nil, self:Find("LayoutCost/instanceUpgradeCostItem"))
    gg.setSpriteAsync(self.instanceUpgradeCostItem.imgIcon, constant.RES_2_CFG_KEY[constant.INSTANCE_COST_RES].icon)

    self.layoutSlider = self:Find("LayoutSlider").transform
    self.slider = self.layoutSlider:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtSlider = self.layoutSlider:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)

    self.cost = self:Find("LayoutCost/cost1")
    self.costItemList = {}
    for i = 1, 1 do
        self:getCostItem(i, self:Find("LayoutCost/cost" .. i))
    end

    self.btn = self:Find("Button")
    self:setOnClick(self.btn, gg.bind(self.onBtn, self))

    self.imgBtn = self:Find("Button", UNITYENGINE_UI_IMAGE)

    self.txtBtn = self.btn.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
end

function CommonUpgradePart:onRelease()
    gg.timer:stopTimer(self.sliderTimer)
    self.slider:DOKill()
end

function CommonUpgradePart:onBtn()
    if self.clickCallback then
        self.clickCallback()
    end
end

function CommonUpgradePart:getCostItem(index, go)
    if index and self.costItemList[index] then
        return self.costItemList[index]
    end
    go = go or UnityEngine.GameObject.Instantiate(self.cost)
    local item = {}
    item.gameObject = go.gameObject
    item.transform = go.transform
    item.transform:SetParent(self.layoutCost.transform, false)
    -- item.transform:SetAsFirstSibling()
    item.transform:SetAsLastSibling()

    item.imgIcon = go.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.text = go.transform:Find("Txt"):GetComponent(UNITYENGINE_UI_TEXT)
    if index then
        self.costItemList[index] = item
    end
    return item
end

function CommonUpgradePart:setClickCallback(callback)
    self.clickCallback = callback
end

function CommonUpgradePart:setBtnText(text)
    self.txtBtn.text = text
end

function CommonUpgradePart:setBtnSprite(spriteName)
    gg.setSpriteAsync(self.imgBtn, spriteName)
end

-- data = {{icon = "", cost = , color = , resId = }}
local COLOR_NORMAL = UnityEngine.Color(0xff/0xff, 0xff/0xff, 0xff/0xff, 1)

function CommonUpgradePart:setBtnData(data)
    for index, value in ipairs(data) do
        local item = self:getCostItem(index)
        item.gameObject:SetActiveEx(true)
        if value.icon and item.showingIcon ~= value.icon then
            item.showingIcon = value.icon
            gg.setSpriteAsync(item.imgIcon, value.icon)
        end

        if value.cost then
            item.text.text = Utils.getShowRes(value.cost, Utils.isMainRes(value.resId))
        end
        local color = value.color or COLOR_NORMAL
        item.text.color = color
        item.transform:SetRectSizeX(item.imgIcon.transform.rect.width + item.text.preferredWidth - 5)

        local count = index
        if self.instanceUpgradeCostItem.gameObject.activeSelf then
            count = count + 1
        end

        if count > 3 then
            item.transform:SetParent(self.layoutCost2.transform)
        end
    end

    self.layoutCost.transform:SetActiveEx(false)
    self.layoutCost.transform:SetActiveEx(true)
    self.layoutCost2.transform:SetActiveEx(false)
    self.layoutCost2.transform:SetActiveEx(true)
    -- self.layoutCost.transform:SetRectSizeX(self.layoutCost.preferredWidth)
    -- self.layoutCost2.transform:SetRectSizeX(self.layoutCost2.preferredWidth)
    -- self.layoutCost:SetLayoutHorizontal()
    -- self.layoutCost2:SetLayoutHorizontal()

    local dataCount = #data
    local itemCount = #self.costItemList

    if itemCount > dataCount then
        for i = dataCount + 1, itemCount, 1 do
            self.costItemList[i].gameObject:SetActiveEx(false)
        end
    end
end

function CommonUpgradePart:setSliderData(isActive, lessTickEnd, totalTick, isStartTimer, runCallBack)
    self.layoutSlider.gameObject:SetActiveEx(isActive)
    gg.timer:stopTimer(self.sliderTimer)
    if not isActive then
        return
    end

    local time = lessTickEnd - os.time()
    local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
    self.txtSlider.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    self.slider.value = time / totalTick

    if isStartTimer then
        self.slider:DOKill()
        self.slider.value = time / totalTick
        self.slider:DOValue(0, time):SetEase(CS.DG.Tweening.Ease.Linear)

        self.sliderTimer = gg.timer:startLoopTimer(0, 1, -1, function ()
            time = lessTickEnd - os.time()
            if time > 0 then
                hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
                self.txtSlider.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
            else
                self.txtSlider.text = 0 .. "s"
                gg.timer:stopTimer(self.sliderTimer)
            end

            if runCallBack then
                runCallBack(time)
            end
        end)
    end
end

function CommonUpgradePart:setStaticSliderData(time)
    self.layoutSlider.gameObject:SetActiveEx(true)
    gg.timer:stopTimer(self.sliderTimer)
    local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
    self.txtSlider.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    self.slider.value = 1
end

function CommonUpgradePart:setInstanceCostActive(isActive)
    self.instanceUpgradeCostItem.gameObject:SetActiveEx(isActive)
end

function CommonUpgradePart:setInstanceCost(cost)
    local color
    if ResData.getTesseract() >= cost then
        color = COLOR_NORMAL
    else
        color = constant.COLOR_RED
    end
    self.instanceUpgradeCostItem.text.color = color

    self.instanceUpgradeCostItem.text.text = Utils.getShowRes(cost)
    self.instanceUpgradeCostItem.transform:SetRectSizeX(self.instanceUpgradeCostItem.imgIcon.transform.rect.width + self.instanceUpgradeCostItem.text.preferredWidth)
end
