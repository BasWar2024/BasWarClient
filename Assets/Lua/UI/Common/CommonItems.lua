CommonAttrItem = CommonAttrItem or class("CommonAttrItem", ggclass.UIBaseItem)

function CommonAttrItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function CommonAttrItem:onInit()
    self.bg = self.transform:Find("Bg")

    self.imgAttr = self.transform:Find("ImgAttr"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = self.transform:Find("TxtName"):GetComponent(typeof(CS.TextYouYU))
    self.txtAttr = self.transform:Find("TxtAttr"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttrAdd = self.transform:Find("TxtAttrAdd"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconUpgrade = self.transform:Find("IconUpgrade"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconAdd = self.transform:Find("IconAdd")
    self.iconVip = self.transform:Find("IconVip")
end

-- attrCfgList = {cfg.attribute.maxHp, }
function CommonAttrItem:setData(index, attrCfgList, curCfg, addCfg, showType, colorText, colorTextAdd, bgIsLine)
    local attrCfg = attrCfgList[index]
    local attr = 0
    local addAttr = nil
 
    if attrCfg.cfgKey == "Shrine_AtkAdd" then
        local addAtk, addHp = ShrineUtil.getAddAttr()
        attr =  addAtk * curCfg.attEnableRatio / curCfg.atkSpeed
        -- attr = attr - attr % 0.01

        attr = tonumber(string.format("%.2f", attr))

    elseif attrCfg.cfgKey == "Shrine_HpAdd" then
        local addAtk, addHp = ShrineUtil.getAddAttr()
        attr = addHp * curCfg.hpEnableRatio
        -- attr = attr - attr % 0.01

        attr = tonumber(string.format("%.2f", attr))

    else
        attr = AttrUtil.getAttrByCfg(attrCfg, curCfg)
        if addCfg then
            addAttr = AttrUtil.getAttrByCfg(attrCfg, addCfg)
            addAttr = addAttr - attr
        else
            addAttr = 0
        end

        local startByte, endByte = string.find(attrCfg.cfgKey, "perMake")
        if startByte ~= nil and endByte ~= nil and endByte >= startByte then
            local ratio = 3600 / cfg.global.BaseMakeResCD.intValue
            attr = attr * ratio
            addAttr = addAttr * ratio
        end
    end

    local strAttr = attr
    local strAddAttr = addAttr

    if attrCfg.count2Name then
        for _, value in ipairs(attrCfg.count2Name) do
            if value.count > attr then
                strAttr = Utils.getText(value.name)
                break
            end
        end

    elseif attrCfg.isPercent == 1 then
        strAttr = strAttr / 100 .. "%"
        strAddAttr = addAttr / 100 .. "%"

    elseif attrCfg.isPercent == 2 then
        strAttr = strAttr * 100 .. "%"
        strAddAttr = addAttr * 100 .. "%"

    elseif attrCfg.isTime == 1 then
        strAttr = gg.time:dhms_string(strAttr) -- time:dhms_string(secs, fmt)
        strAddAttr = gg.time:dhms_string(strAddAttr)
    elseif attrCfg.cfgKey == "race" then

        if constant.RACE_MESSAGE[attr] then
            strAttr = Utils.getText(constant.RACE_MESSAGE[attr].languageKey)
        else
            strAttr = "no race"
        end
        strAddAttr = ""
    end

    -- if attrCfg.isScientific == 1 then
    --     strAttr = Utils.scientificNotation(strAttr)
    --     strAddAttr = Utils.scientificNotation(strAddAttr)
    -- end

    if addAttr ~= nil then
        if type(addAttr) == "number" then
            if addAttr > 0 then
                strAddAttr = "+" .. strAddAttr
            elseif addAttr == 0 then
                strAddAttr = ""
            end
        else
            strAddAttr = "+" .. strAddAttr
        end
    end

    showType = showType or CommonAttrItem.TYPE_NORMAL
    self:setInfo(attrCfg.icon, attrCfg.name, strAttr, strAddAttr, showType, colorText, colorTextAdd, index, #attrCfgList, bgIsLine)
end

CommonAttrItem.COLOR_TEXT = UnityEngine.Color(0xff / 0xff, 0xff / 0xff, 0xff / 0xff, 1)
CommonAttrItem.COLOR_TEXT_ADD = UnityEngine.Color(0xFF / 0xff, 0xAA / 0xff, 0x07 / 0xff, 1)
CommonAttrItem.COLOR_PINK = UnityEngine.Color(0xFF / 0xff, 0x6C / 0xff, 0xDE / 0xff, 1)

function CommonAttrItem:setInfo(icon, name, attr, addAttr, showType, colorText, colorTextAdd, index, attrCount, bgIsLine)
    if icon then
        icon = gg.getSpriteAtlasName("AttributeIcon_Atlas", icon)
        gg.setSpriteAsync(self.imgAttr, icon)
    end
    if bgIsLine then
        self.bg:SetActiveEx(index ~= attrCount)
    else
        index = index or 0
        self.bg:SetActiveEx(index % 2 ~= 0)
    end

    colorText = colorText or CommonAttrItem.COLOR_TEXT
    colorTextAdd = colorTextAdd or CommonAttrItem.COLOR_TEXT_ADD

    self.txtAttr.color = colorText
    self.txtAttrAdd.color = colorTextAdd

    attr = attr or ""
    addAttr = addAttr or ""
    -- self.txtName.text = name
    self.txtName:SetLanguageKey(name)
    self.txtAttr.text = attr
    self.txtAttrAdd.text = addAttr

    showType = showType or CommonAttrItem.TYPE_NORMAL
    self:setAttrShowType(showType)
end

function CommonAttrItem:setAddAttrActive(isShow)
    self.txtAttrAdd.transform:SetActiveEx(isShow)
end

CommonAttrItem.TYPE_NORMAL = 1
CommonAttrItem.TYPE_ICON_UPGRADE = 2
CommonAttrItem.TYPE_SINGLE_TEXT = 3
CommonAttrItem.TYPE_SINGLE_TEXT_ADD = 4
CommonAttrItem.TYPE_SINGLE_TEXT_VIP = 5

function CommonAttrItem:setAttrShowType(showType)
    showType = showType or CommonAttrItem.TYPE_NORMAL
    self.txtAttr.gameObject:SetActiveEx(false)
    self.txtAttrAdd.gameObject:SetActiveEx(false)
    self.iconUpgrade.gameObject:SetActiveEx(false)
    self.iconAdd.gameObject:SetActiveEx(false)
    self.iconVip.gameObject:SetActiveEx(false)

    if showType == CommonAttrItem.TYPE_NORMAL then
        self.txtAttr.gameObject:SetActiveEx(true)
        self.txtAttrAdd.gameObject:SetActiveEx(true)
        self.iconAdd.gameObject:SetActiveEx(true)

        self.iconAdd.transform.anchoredPosition = UnityEngine.Vector2(0, self.iconAdd.transform.anchoredPosition.y)

        self.txtAttrAdd.transform.anchoredPosition = UnityEngine.Vector2(
            self.iconAdd.transform.anchoredPosition.x - self.iconAdd.transform.rect.width,
            self.txtAttrAdd.transform.anchoredPosition.y)

        self.txtAttr.transform.anchoredPosition = UnityEngine.Vector2(
            self.txtAttrAdd.transform.anchoredPosition.x - self.txtAttrAdd.preferredWidth - 3,
            self.txtAttr.transform.anchoredPosition.y)

        if self.txtAttrAdd.text == "" then
            self.iconAdd.gameObject:SetActiveEx(false)
        end

    elseif showType == CommonAttrItem.TYPE_ICON_UPGRADE then
        self.txtAttr.gameObject:SetActiveEx(true)
        self.txtAttrAdd.gameObject:SetActiveEx(true)
        self.iconUpgrade.gameObject:SetActiveEx(true)

        self.txtAttrAdd.transform.anchoredPosition = UnityEngine.Vector2(-5,
            self.txtAttrAdd.transform.anchoredPosition.y)

        self.iconUpgrade.transform.anchoredPosition = UnityEngine.Vector2(
            self.txtAttrAdd.transform.anchoredPosition.x - self.txtAttrAdd.preferredWidth - 5,
            self.iconUpgrade.transform.anchoredPosition.y)

        self.txtAttr.transform.anchoredPosition = UnityEngine.Vector2(
            self.iconUpgrade.transform.anchoredPosition.x - self.iconUpgrade.transform.sizeDelta.x - 5,
            self.txtAttr.transform.anchoredPosition.y)
    elseif showType == CommonAttrItem.TYPE_SINGLE_TEXT_VIP then
        self.txtAttr.gameObject:SetActiveEx(true)
        self.txtAttrAdd.gameObject:SetActiveEx(true)
        self.iconVip.gameObject:SetActiveEx(true)

        self.iconVip.transform.anchoredPosition = UnityEngine.Vector2(18, self.iconVip.transform.anchoredPosition.y)

        self.txtAttrAdd.transform.anchoredPosition = UnityEngine.Vector2(
            self.iconVip.transform.anchoredPosition.x - self.iconVip.transform.rect.width,
            self.txtAttrAdd.transform.anchoredPosition.y)

        self.txtAttr.transform.anchoredPosition = UnityEngine.Vector2(
            self.txtAttrAdd.transform.anchoredPosition.x - self.txtAttrAdd.preferredWidth - 3,
            self.txtAttr.transform.anchoredPosition.y)

    elseif showType == CommonAttrItem.TYPE_SINGLE_TEXT then
        self.txtAttr.gameObject:SetActiveEx(true)
        self.txtAttr.transform.anchoredPosition = UnityEngine.Vector2(-5, self.txtAttr.transform.anchoredPosition.y)

    elseif showType == CommonAttrItem.TYPE_SINGLE_TEXT_ADD then
        self.txtAttrAdd.gameObject:SetActiveEx(true)
        self.txtAttrAdd.transform.anchoredPosition = UnityEngine.Vector2(-5,
            self.txtAttrAdd.transform.anchoredPosition.y)
    end
end
--------------------------------------------------------------
CommonUpgradeBox = CommonUpgradeBox or class("CommonUpgradeBox", ggclass.UIBaseItem)
CommonUpgradeBox.events = {"onRefreshResTxt"}
function CommonUpgradeBox:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonUpgradeBox:onInit()
    self.partList = {}
    for i = 1, 2 do
        self.partList[i] = {}
        local part = self.transform:Find("Part" .. i)
        self.partList[i].part = part
        self.partList[i].btn = part:Find("Btn").gameObject
        self.partList[i].txtBtn = self.partList[i].btn.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        self:setOnClick(self.partList[i].btn, gg.bind(self.onBtn, self, i))

        self.partList[i].txtCost = part:Find("CostItem/Text"):GetComponent(UNITYENGINE_UI_TEXT)
        -- self.partList[i].costMap[0] = layoutCost.transform:GetChild(0):Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

        local layoutCost = part:Find("LayoutCost")
        self.partList[i].layoutCost = layoutCost
        self.partList[i].costMap = {}
        self.partList[i].costMap[constant.RES_STARCOIN] = layoutCost.transform:GetChild(0):Find("Text"):GetComponent(
            "Text")
        self.partList[i].costMap[constant.RES_CARBOXYL] = layoutCost.transform:GetChild(1):Find("Text"):GetComponent(
            "Text")
        self.partList[i].costMap[constant.RES_GAS] = layoutCost.transform:GetChild(2):Find("Text"):GetComponent(
            UNITYENGINE_UI_TEXT)
        self.partList[i].costMap[constant.RES_ICE] = layoutCost.transform:GetChild(3):Find("Text"):GetComponent(
            UNITYENGINE_UI_TEXT)
        self.partList[i].costMap[constant.RES_TITANIUM] = layoutCost.transform:GetChild(4):Find("Text"):GetComponent(
            "Text")
    end
    self.txtCostInstant = self.partList[1].part.transform:Find("CostItem/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.isAlertMitCost = true
end

function CommonUpgradeBox:onBtn(index)
    if not self.isUpgradeing then
        if not Utils.checkIsEnoughtLevelUpRes(self.curCfg, true) then
            return
        end
    end

    if index == 1 then
        if not Utils.checkAndAlertEnoughtMit(self.mitCost, true) then
            return
        end

        if self.isAlertMitCost then
            local callbackYes = function()
                if self.instantCB then
                    self.instantCB()
                end
            end
            local txt = string.format("Confirm to consume %s MIT to complete upgrade now?", self.mitCost)
            gg.uiManager:openWindow("PnlAlert", {
                callbackYes = callbackYes,
                txt = txt
            })
            return
        end

        if self.instantCB then
            self.instantCB()
        end
    elseif index == 2 then
        if self.upgradeCB then
            self.upgradeCB()
        end
    end
end

function CommonUpgradeBox:onRelease()
    gg.timer:stopTimer(self.upgradeTimer)
end

function CommonUpgradeBox:onRefreshResTxt()
    self:refreshTxtCostMitColor()
    self:refreshTxtCostColor()
end

function CommonUpgradeBox:refreshTxtCostMitColor()
    if self.mitCost > ResData.getMit() then
        self.partList[1].txtCost.color = constant.COLOR_RED
    else
        self.partList[1].txtCost.color = constant.COLOR_WHITE
    end
end

function CommonUpgradeBox:refreshTxtCostColor()
    local curCfg = self.curCfg
    for i = 1, 2 do
        local part = self.partList[i]
        for key, value in pairs(part.costMap) do
            local cost = 0
            if constant.RES_2_CFG_KEY[key] then
                cost = curCfg[constant.RES_2_CFG_KEY[key].levelUpKey]
            end
            if cost > ResData.getRes(key) then
                value.color = constant.COLOR_RED
            else
                value.color = constant.COLOR_WHITE
            end
        end
    end
end

----""
function CommonUpgradeBox:setMessage(curCfg, lessTickEnd)
    self:addAllListener(true)
    self.curCfg = curCfg
    lessTickEnd = lessTickEnd or 0

    gg.timer:stopTimer(self.upgradeTimer)
    self.isUpgradeing = lessTickEnd - os.time() > 0
    if lessTickEnd - os.time() <= 0 then
        for i = 1, 2 do
            local part = self.partList[i]
            part.part.transform:SetActiveEx(true)
            part.layoutCost:SetActiveEx(true)
            for key, value in pairs(part.costMap) do
                local cost = 0
                if constant.RES_2_CFG_KEY[key] then
                    cost = curCfg[constant.RES_2_CFG_KEY[key].levelUpKey]
                end
                value.text = cost
            end
        end
        self.mitCost = math.ceil(curCfg.levelUpNeedTick / 60) * cfg.global.SpeedUpPerMinute.intValue
        self.partList[1].txtCost.text = self.mitCost
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, curCfg.levelUpNeedTick)
        self.partList[2].txtCost.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)
    else
        self.partList[1].layoutCost.transform:SetActiveEx(false)
        self.partList[2].part.transform:SetActiveEx(false)

        self.upgradeTimer = gg.timer:startLoopTimer(1, 0.3, -1, function()
            local time = lessTickEnd - os.time()
            self.mitCost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue
            self.partList[1].txtCost.text = self.mitCost
            self:refreshTxtCostMitColor()
        end)
    end
    self:refreshTxtCostMitColor()
    self:refreshTxtCostColor()
end

function CommonUpgradeBox:setInstantCallback(callback)
    self.instantCB = callback
end

function CommonUpgradeBox:setUpgradeCallback(callback)
    self.upgradeCB = callback
end

function CommonUpgradeBox:setBtnText(index, text)
    self.partList[index].txtBtn.text = text
end

function CommonUpgradeBox:setIsAlertMitCost(isAlert)
    self.isAlertMitCost = isAlert
end
---------------------------------------------------------------------------------------------------
CommonAddCountBox = CommonAddCountBox or class("CommonAddCountBox", ggclass.UIBaseItem)
function CommonAddCountBox:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
end

function CommonAddCountBox:onInit()
    self.btnAdd = self:Find("BtnAdd")
    self.btnSub = self:Find("BtnSub")

    self:setOnClick(self.btnAdd, gg.bind(self.onChange, self, 1))
    self:setOnClick(self.btnSub, gg.bind(self.onChange, self, -1))
    CS.UIEventHandler.Get(self.btnAdd):SetOnPointerDown(gg.bind(self.onAddDown, self, 1))
    CS.UIEventHandler.Get(self.btnAdd):SetOnPointerUp(gg.bind(self.onAddUp, self, 1))

    CS.UIEventHandler.Get(self.btnSub):SetOnPointerDown(gg.bind(self.onAddDown, self, -1))
    CS.UIEventHandler.Get(self.btnSub):SetOnPointerUp(gg.bind(self.onAddUp, self, -1))
end

function CommonAddCountBox:onChange(count)
    if self.changeCB then
        self.changeCB(count)
    end
end

function CommonAddCountBox:onAddDown(count)
    local time = 0
    self.addTimer = gg.timer:startLoopTimer(0, 0.05, -1, function()
        time = time + 0.1
        if time > 0.5 then
            self:onChange(count)
        end
    end)
end

function CommonAddCountBox:onAddUp(count)
    gg.timer:stopTimer(self.addTimer)
end

function CommonAddCountBox:onRelease()
    gg.timer:stopTimer(self.addTimer)
    CS.UIEventHandler.Clear(self.btnAdd)
    CS.UIEventHandler.Clear(self.btnSub)
end

-- ""

function CommonAddCountBox:setChangeCallback(callback)
    self.changeCB = callback
end

---------------------------------------------------------------------------------------------------
CommonResBox = CommonResBox or class("CommonResBox", ggclass.UIBaseItem)
function CommonResBox:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

CommonResBox.events = {"onRefreshResTxt"}

function CommonResBox:onInit()
    self.resMap = {}

    self.layoutRes = self:Find("LayoutRes").transform
    for i = 1, self.layoutRes.childCount, 1 do
        local child = self.layoutRes:GetChild(i - 1)
        local key = constant[child.name]
        self.resMap[key] = {}
        local item = self.resMap[key]
        item.transform = child
        item.gameObject = child.gameObject
        item.text = child:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        item.slider = child:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
        item.icon = child:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    end

    local resList = {
        constant.RES_TESSERACT,
        constant.RES_MIT,
        constant.RES_TESSERACT,
    }

    self.resMap2 = {}
    for key, value in pairs(resList) do
        self.resMap2[value] = {}
        local resInfo = constant.RES_2_CFG_KEY[value]
        local item = self.transform:Find(resInfo.key)
        self.resMap2[value].text = item:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        self.resMap2[value].btnAdd = item:Find("BtnAdd").gameObject
    end

    self.btnAdd = self:Find("RES_MIT/BtnAdd").gameObject
    self:setOnClick(self.btnAdd, gg.bind(self.onBtnAdd, self))
end

function CommonResBox:onRefreshResTxt(events, resCfgId, count)

    if self.resMap[resCfgId] then
        local res = ResData.getRes(resCfgId)
        self.resMap[resCfgId].text.text = string.upper(Utils.getShowRes(res))
        self.resMap[resCfgId].slider.value = res / gg.buildingManager.resMax[resCfgId]
    elseif self.resMap2[resCfgId] then
        local res = ResData.getRes(resCfgId)
        self.resMap2[resCfgId].text.text = string.upper(Utils.getShowRes(res))
    end
end

function CommonResBox:onOpen()
    for key, value in pairs(self.resMap) do
        local res = ResData.getRes(key)
        value.text.text = string.upper(Utils.getShowRes(res))
        value.slider.value = res / gg.buildingManager.resMax[key]
    end

    for key, value in pairs(self.resMap2) do
        local res = ResData.getRes(key)
        value.text.text = string.upper(Utils.getShowRes(res))
    end
end

function CommonResBox:onBtnAdd()
    ResData.C2S_Player_Exchange_Rate(ResData.TIP_TYPE_EXCHANGE)
end
-----------------------------------------------------------------------------------------------------------
CommonResBox2 = CommonResBox2 or class("CommonResBox2", ggclass.UIBaseItem)
function CommonResBox2:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

CommonResBox2.events = {"onRefreshResTxt"}

function CommonResBox2:onInit()
    self.resMap = {}

    self.layoutRes = self:Find("LayoutRes").transform
    for i = 1, self.layoutRes.childCount, 1 do
        local child = self.layoutRes:GetChild(i - 1)
        local key = constant[child.name]
        self.resMap[key] = {}
        local item = self.resMap[key]
        item.transform = child
        item.gameObject = child.gameObject
        item.text = child:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        item.icon = child:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

        gg.setSpriteAsync(item.icon, constant.RES_2_CFG_KEY[key].icon)
    end
end

function CommonResBox2:onRefreshResTxt(events, resCfgId, count)
    if self.resMap[resCfgId] then
        local res = ResData.getRes(resCfgId)
        self.resMap[resCfgId].text.text = string.upper(Utils.getShowRes(res))
    end
end

function CommonResBox2:onOpen()
    for key, value in pairs(self.resMap) do
        local res = ResData.getRes(key)
        value.text.text = string.upper(Utils.getShowRes(res))
    end
end

function CommonResBox2:showResList(list)
    for key, value in pairs(self.resMap) do
        value.gameObject:SetActiveEx(false)
    end

    for key, value in pairs(list) do
        self.resMap[value].gameObject:SetActiveEx(true)
    end

end

-----------------------------------------------------------------------------------------------------------
CommonLevelUpNeedCost = CommonLevelUpNeedCost or class("CommonLevelUpNeedCost", ggclass.UIBaseItem)
function CommonLevelUpNeedCost:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

CommonLevelUpNeedCost.events = {"onRefreshResTxt"}

function CommonLevelUpNeedCost:onInit()
    self.resMap = {}

    for i = 1, self.transform.childCount do
        local child = self.transform:GetChild(i - 1)
        self.resMap[child.name] = {}
        self.resMap[child.name].transform = child
        self.resMap[child.name].gameObject = child.gameObject
        self.resMap[child.name].txtCost = child:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    end
end

-- ""levelupneed。。。。""
function CommonLevelUpNeedCost:setData(data)
    for key, value in pairs(self.resMap) do
        if data[key] then
            value.txtCost.text = data[key]
        else
            value.txtCost.text = 0
        end
    end
end

-----------------------------------------------------------------------------------------------------------
CommonForgeBox = CommonForgeBox or class("CommonForgeBox", ggclass.UIBaseItem)
function CommonForgeBox:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

-- CommonForgeBox.events = {"onRefreshResTxt"}

function CommonForgeBox:onInit()
    self.commonAddCountBox = CommonAddCountBox.new(self:Find("CommonAddCountBox"))
    self.commonAddCountBox:setChangeCallback(gg.bind(self.onAddCount, self))

    self.commonLevelUpNeedCost = CommonLevelUpNeedCost.new(self:Find("CommonLevelUpNeedCost"))

    self.sliderForge = self:Find("SliderForge", "Slider")
    self.sliderForge.onValueChanged:AddListener(gg.bind(self.onSliderForgeChange, self))

    self.inputForgeRaiot = self:Find("InputForgeRaiot", "InputField")
    self.inputForgeRaiot.onValueChanged:AddListener(gg.bind(self.onInputForgeRatio, self))
    self.inputForgeRaiot.onEndEdit:AddListener(gg.bind(self.onInputForgeRatioEnd, self))

    self.txtForgeMitPer = self:Find("TxtForgeMitPer", "Text")
    self.txtForgeMitCost = self:Find("TxtForgeMitCost"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnForge = self:Find("BtnForge").gameObject

    self:setOnClick(self.btnForge, gg.bind(self.onBtnForge, self))

    self.sliderFillTop = self.sliderForge.transform:Find("SliderFillTop"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.imgFillTop = self.sliderForge.transform:Find("FillTop"):GetComponent(UNITYENGINE_UI_IMAGE)
end

function CommonForgeBox:onRelease()
    self.commonAddCountBox:release()
    self.commonLevelUpNeedCost:release()

    self.sliderForge.onValueChanged:RemoveAllListeners()
    self.inputForgeRaiot.onValueChanged:RemoveAllListeners()
    self.inputForgeRaiot.onEndEdit:RemoveAllListeners()
end

function CommonForgeBox:onAddCount(value)
    self.sliderForge.value = self.sliderForge.value + value
end

function CommonForgeBox:onSliderForgeChange(value)
    if value < self.forgeCfg.startRatio then
        self.sliderForge.value = self.forgeCfg.startRatio
        return
    elseif value > self.forgeCfg.maxRatio then
        self.sliderForge.value = self.forgeCfg.maxRatio
        return
    end
    self.inputForgeRaiot.text = math.ceil(value)
end

function CommonForgeBox:onInputForgeRatio(text)
    self:refreshForgeMitCost()
end

function CommonForgeBox:onInputForgeRatioEnd(text)
    local ratio = tonumber(text)
    if not ratio then
        ratio = 0
        self.inputForgeRaiot.text = 0
    end

    if ratio > tonumber(self.forgeCfg.maxRatio) then
        self.inputForgeRaiot.text = self.forgeCfg.maxRatio
    elseif ratio < self.forgeCfg.startRatio then
        self.inputForgeRaiot.text = self.forgeCfg.startRatio
    end

    self.sliderForge.value = ratio
    self:refreshForgeMitCost()
end

function CommonForgeBox:refreshForgeMitCost()
    local choooseRatio = tonumber(self.inputForgeRaiot.text)
    if not choooseRatio then
        choooseRatio = 0
    end
    choooseRatio = math.min(self.forgeCfg.maxRatio, math.max(self.forgeCfg.startRatio, choooseRatio))
    self.txtForgeMitCost.text = (choooseRatio - self.forgeCfg.startRatio) * self.forgeCfg.mitPerRatio
end

function CommonForgeBox:onBtnForge()
    if self.btnForgeCallback then
        self.btnForgeCallback()
    end
end
-- ""

function CommonForgeBox:setData(forgeCfg)
    self.forgeCfg = forgeCfg
    self.commonLevelUpNeedCost:setData(forgeCfg)
    self.sliderForge.minValue = 0
    self.sliderForge.maxValue = 100
    self.sliderForge.value = forgeCfg.startRatio
    self.txtForgeMitPer.text = forgeCfg.mitPerRatio
    self.inputForgeRaiot.text = forgeCfg.startRatio
    -- self.imgFillTop.fillAmount = forgeCfg.startRatio / 100
    self.sliderFillTop.value = forgeCfg.startRatio / 100
end

function CommonForgeBox:setBtnForgeCallback(callback)
    self.btnForgeCallback = callback
end

function CommonForgeBox:getAddCount()
    return tonumber(self.inputForgeRaiot.text) - self.forgeCfg.startRatio
end

-----------------------------------------------------------------------------------------
AttentionUpgradeBox = AttentionUpgradeBox or class("AttentionUpgradeBox", ggclass.UIBaseItem)
function AttentionUpgradeBox:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function AttentionUpgradeBox:onInit()
    self.txtAttention = self:Find("TxtAttention", UNITYENGINE_UI_TEXT)
end

function AttentionUpgradeBox:checkSoldier(levelUpCfg)
    local isUnlock, lockMap, lockList =  gg.buildingManager:checkNeedBuild(levelUpCfg.levelUpNeedBuilds)

    if not isUnlock then
        local buildCfg = BuildUtil.getCurBuildCfg(lockList[1].cfgId, lockList[1].level, lockList[1].quality)
        if buildCfg then
            -- self.txtAttention.text = string.format(Utils.getText("unlock_UnitUpgradeTips"), Utils.getText(buildCfg.languageNameID), lockList[1].level)
            self.txtAttention.text = string.format(Utils.getText("unlock_ResearchTips"), lockList[1].level)
            
        end
        return false
    end

    return isUnlock
end

function AttentionUpgradeBox:checkHero(levelUpCfg)

    local needBaseLevel = levelUpCfg.level + 1

    if needBaseLevel > gg.buildingManager:getBaseLevel() then
        local buildCfg = BuildUtil.getCurBuildCfg(constant.BUILD_BASE, needBaseLevel, 0)
        self.txtAttention.text = string.format(Utils.getText("unlock_UnitUpgradeTips"), Utils.getText(buildCfg.languageNameID), needBaseLevel)
        return false
    end
    return true
end

function AttentionUpgradeBox:checkTowerWarship(levelUpCfg)

    local needBaseLevel = levelUpCfg.level + 1

    if needBaseLevel > gg.buildingManager:getBaseLevel() then
        local buildCfg = BuildUtil.getCurBuildCfg(constant.BUILD_BASE, needBaseLevel, 0)
        self.txtAttention.text = string.format(Utils.getText("unlock_UnitUpgradeTips"), Utils.getText(buildCfg.languageNameID), needBaseLevel)
        return false
    end
    return true
end