PnlWarShip = class("PnlWarShip", ggclass.UIBase)

-- PnlWarShip.VIEW_SKILL = 1

PnlWarShip.VIEW_INFORMATION = 1
PnlWarShip.VIEW_UPGRADE = 2
PnlWarShip.VIEW_FORGE = 3

function PnlWarShip:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onWarShipForgeResult", "onForgeResultAnimateFinish", "onRefreshWarShipData"}
    self.needBlurBG = false
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN

end

function PnlWarShip:onAwake()
    self.view = ggclass.PnlWarShipView.new(self.pnlTransform)
    local view = self.view
    -- view.commonResBox:open()
    self:initBtnSkillTable()
    view.commonUpgradeNewBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeNewBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
    view.commonUpgradeNewBox:setExchangeInfoFunc(gg.bind(self.exchangeInfoFunc, self))

    view.LeftBtnViewBgBtnsBox:setBtnDataList({{
        name = "Infomation",
        callback = gg.bind(self.chooseWindowType, self, PnlWarShip.VIEW_INFORMATION)
    }, {
        name = "Upgrade",
        callback = gg.bind(self.chooseWindowType, self, PnlWarShip.VIEW_UPGRADE)
    }})

    -- view.commonForgeBox:setBtnForgeCallback(gg.bind(self.onBtnForge, self))
    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.chooseViewAttrScrollView = UIScrollView.new(view.chooseViewAttrScrollView, "CommonAttrItem", self.attrItemList)
    self.chooseViewAttrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.attentionUpgradeBox = AttentionUpgradeBox.new(self.view.attentionUpgradeBox)
end

function PnlWarShip:onShow()
    self:bindEvent()

    self.showData = self.args.showingData or WarShipData.useData

    self.showingType = self.args.showingType or PnlWarShip.VIEW_UPGRADE

    self.cfgType = "warShip"

    if self.args.type == PnlHeadquarters.SWICH_TOWER then
        self.cfgType = "build"
        self.view.txtTitle.text = Utils.getText("nftTower_Title")

    else
        self.view.txtTitle.text = Utils.getText("warship_Title")
    end

    self.view.commonUpgradeNewBox:open()
    self.view.LeftBtnViewBgBtnsBox:setBtnStageWithoutNotify(self.showingType)

    self:chooseWindowType(self.showingType)
    self:refreshAttr()
end

function PnlWarShip:refreshAttr()
    local view = self.view
    local data = self.showData

    -- local forgeData = data.forgeData or {
    --     level = 0
    -- }

    if self.args.type == PnlHeadquarters.SWICH_TOWER then
        self.showAttrMap = BuildUtil.getBuildAttr(data.cfgId, data.level, data.quality, 0)
        self.showCompareAttrMap = BuildUtil.getBuildAttr(data.cfgId, data.level + 1, data.quality, 0)
        self.attrDataList = constant.BUILD_SHOW_ATTR
    else
        self.showAttrMap = WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level, 0, data.curLife)
        self.showCompareAttrMap = WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level + 1, 0)
        self.attrDataList = constant.WARSHIP_SHOW_ATTR
    end

    if self.showingType == PnlWarShip.VIEW_UPGRADE and self.showCompareAttrMap then
        self.attrDataList = AttrUtil.getAttrChangeCfgList(self.attrDataList, self.showAttrMap, self.showCompareAttrMap)

        -- elseif self.showingType == PnlWarShip.VIEW_FORGE then
        --     self.showCompareAttrMap = WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level, forgeData.level + 1)
        --     self.attrDataList = AttrUtil.getAttrChangeCfgList(self.attrDataList, self.showAttrMap, self.showCompareAttrMap)
    else
        self.showCompareAttrMap = nil
    end
    local itemCount = #self.attrDataList
    local scrollViewLenth = AttrUtil.getAttrScrollViewLenth(itemCount)

    if self.showingType == PnlWarShip.VIEW_UPGRADE then
        self.attrScrollView:setItemCount(#self.attrDataList)
        self.attrScrollView.transform:SetRectSizeY(scrollViewLenth)

        -- self.attrScrollView.transform.anchoredPosition = UnityEngine.Vector2(
        --     self.attrScrollView.transform.anchoredPosition.x, -309)

    else
        self.chooseViewAttrScrollView.transform:SetRectSizeY(scrollViewLenth)
        self.chooseViewAttrScrollView:setItemCount(#self.attrDataList)

        self.chooseViewAttrScrollView.transform.anchoredPosition = UnityEngine.Vector2(
            self.chooseViewAttrScrollView.transform.anchoredPosition.x, 88)

        view.viewSkill.transform.anchoredPosition = UnityEngine.Vector2(view.viewSkill.transform.anchoredPosition.x,
            self.chooseViewAttrScrollView.transform.anchoredPosition.y - scrollViewLenth)

    end
end

function PnlWarShip:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, self.attrDataList, self.showAttrMap, self.showCompareAttrMap)
end

-- ""
function PnlWarShip:initBtnSkillTable()
    local view = self.view
    self.btnSkillTable = {}

    for i = 1, 5 do
        local btn = view["btnSkill" .. i]
        local t = {
            obj = btn,
            skillCfg = nil
        }
        t.commonItemItem = CommonItemItem.new(btn.transform:Find("CommonItemItem"))
        t.layoutSlider = btn.transform:Find("LayoutSlider")
        t.txtSlider = t.layoutSlider:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)
        t.slider = t.layoutSlider:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
        table.insert(self.btnSkillTable, t)
    end
end

-- ""
function PnlWarShip:getSkillCfg(cfgId, level)
    local allSkillCfg = cfg["skill"]
    local skillCfg = nil
    for k, v in ipairs(allSkillCfg) do
        if v.cfgId == cfgId and v.level == level then
            skillCfg = v
        end
    end
    return skillCfg
end

-- ""
function PnlWarShip:chooseWindowType(showType)
    self.showingType = showType
    local cfgId = self.showData.cfgId
    local level = self.showData.level
    local quality = self.showData.quality
    local myCfg = cfg.getCfg(self.cfgType, cfgId, level, quality)

    local view = self.view
    -- local name = myCfg.name
    local life = self.showData.life
    local curLife = self.showData.curLife
    local durability = curLife .. "/" .. life
    local percent = curLife / life
    view.txtName.text = Utils.getText(myCfg.languageNameID)

    if self.showData.chain > 0 then
        self.view.txtId.text = self.showData.id
    else
        self.view.txtId.text = ""
    end

    view.txtLevel.text = level -- "Lv." .. level
    view.txtDurability.text = durability
    -- view.scrollbarDurability.size = percent
    local icon = myCfg.icon .. "_C"
    if self.lastIconName ~= icon then
        gg.setSpriteAsync(view.iconWarShip, icon)
        gg.setSpriteAsync(view.iconWarShip1, icon)

        self.lastIconName = icon
    end

    -- view.txtForge.text = "+" .. self.showData.forgeData.level

    view.bgWarShip:SetActive(true)

    if showType == PnlWarShip.VIEW_SKILL then
        -- view.viewSkill:SetActiveEx(true)
        view.viewUpgrade:SetActive(false)
        view.viewInformation:SetActive(false)
        view.viewForge:SetActiveEx(false)
        -- view.boxArrowUpgrade:SetActiveEx(false)
        self:setViewSkill()
    elseif showType == PnlWarShip.VIEW_UPGRADE then
        -- view.viewSkill:SetActiveEx(false)
        view.upGradeView:SetActive(true)
        view.chooseView:SetActive(false)

        view.viewUpgrade:SetActive(true)
        view.viewInformation:SetActive(true)
        view.viewForge:SetActiveEx(false)
        -- view.boxArrowUpgrade:SetActiveEx(true)
        self:setViewInforMation()
        self:setViewUpgrade(myCfg)
    elseif showType == PnlWarShip.VIEW_INFORMATION then
        -- view.viewSkill:SetActiveEx(false)
        -- view.viewUpgrade:SetActive(false)
        -- view.viewInformation:SetActive(true)
        -- view.viewForge:SetActiveEx(false)
        -- view.boxArrowUpgrade:SetActiveEx(false)

        self:setChooseView()
        view.upGradeView:SetActive(false)
        view.chooseView:SetActive(true)

    elseif showType == PnlWarShip.VIEW_FORGE then
        -- view.viewSkill:SetActiveEx(false)
        view.viewUpgrade:SetActive(false)
        view.viewInformation:SetActive(false)
        view.viewForge:SetActiveEx(true)
        -- view.boxArrowUpgrade:SetActiveEx(false)
        self:setViewForge()
    end

    self:setViewSkill(showType == PnlWarShip.VIEW_INFORMATION)
    self:refreshAttr()
end

function PnlWarShip:onRefreshWarShipData(args, data, type)
    if data then
        if data.id == self.showData.id then
            self.showData = data
        end
    else
        if type == 1 then
            self.showData = WarShipData.useData
        end
    end

    self:chooseWindowType(self.showingType)
end

function PnlWarShip:setChooseView()
    self:destoryBtnWarship()
    self.btnWarship = {}
    local content = self.view.warshipScrollView:Find("Viewport/Content")
    local startX = 15
    local startY = -15
    local nextX = 200
    local nextY = -200
    local index = 0
    for k, v in pairs(WarShipData.warShipData) do
        local temp = index
        local data = v
        ResMgr:LoadGameObjectAsync("BtnWarShip", function(obj)
            local posX = startX + (temp % 5) * nextX
            local posY = startY + math.floor((temp / 5)) * nextY

            obj.transform:SetParent(content, false)
            obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(posX, posY)
            self:setBtnWarship(data, obj)

            CS.UIEventHandler.Get(obj):SetOnClick(function()
                self:onBtnWarship(data)
                -- self:onBtnWarship(PnlWarShip.VIEW_INFORMATION)
            end)
            table.insert(self.btnWarship, obj)
            return true
        end, true)
        index = index + 1
    end
    local height = math.ceil((index / 5)) * nextY + startY
    content:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, -height)
    self:setChooseViewData()
end

function PnlWarShip:setBtnWarship(data, obj)
    local myCfg = cfg.getCfg(self.cfgType, data.cfgId, data.level, data.quality)
    local icon = gg.getSpriteAtlasName("Icon_E_Atlas", myCfg.icon .. "_E")
    gg.setSpriteAsync(obj.transform:Find("CommonBagItem/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

    if not data.quality then
        icon = "Item_Bg_0"
    else
        icon = "Item_Bg_" .. data.quality
    end
    icon = gg.getSpriteAtlasName("Item_Bg_Atlas", icon)
    gg.setSpriteAsync(obj.transform:Find("CommonBagItem/ImgBg"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

    local life = data.life
    local curLife = data.curLife
    local durability = curLife .. "/" .. life
    local percent = curLife / life

    obj.transform:Find("SliderLife"):GetComponent(UNITYENGINE_UI_SLIDER).value = percent

    if self.showData.id == data.id then
        obj.transform:Find("Choose").gameObject:SetActive(true)
    else
        obj.transform:Find("Choose").gameObject:SetActive(false)
    end
    if gg.warShip.warShipData.id == data.id then
        obj.transform:Find("Selected").gameObject:SetActive(true)
    else
        obj.transform:Find("Selected").gameObject:SetActive(false)
    end

    if data.lessTick > 0 then
        obj.transform:Find("LayoutTime").gameObject:SetActive(true)
        self.upgradeTimer = gg.timer:startLoopTimer(0, 1, -1, function()
            local time = data.lessTickEnd - os.time()
            local hms = gg.time.dhms_time({
                day = false,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            obj.transform:Find("LayoutTime/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("%s:%s:%s",
                hms.hour, hms.min, hms.sec)

            if time == 0 then
                obj.transform:Find("LayoutTime").gameObject:SetActive(false)
            end
        end)
    else
        obj.transform:Find("LayoutTime").gameObject:SetActive(false)
    end
end

function PnlWarShip:stopUpgradeTimer()
    if self.upgradeTimer then
        gg.timer:stopTimer(self.upgradeTimer)
        self.upgradeTimer = nil
    end
end

function PnlWarShip:destoryBtnWarship()
    if self.btnWarship then
        for k, v in pairs(self.btnWarship) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.btnWarship = {}
    end
    self:stopUpgradeTimer()
end

function PnlWarShip:setChooseViewData()
    local view = self.view
    local cfgId = self.showData.cfgId
    local level = self.showData.level
    local quality = self.showData.quality
    local tokenID = self.showData.id
    local myCfg = cfg.getCfg(self.cfgType, cfgId, level, quality)
    local icon = gg.getSpriteAtlasName("Icon_E_Atlas", myCfg.icon .. "_E")

    gg.setSpriteAsync(view.iconSelectedWarship, icon)

    local curlevel = level
    if level > gg.buildingManager:getBuildingBase().buildData.level then
        curlevel = gg.buildingManager:getBuildingBase().buildData.level
    end
    view.txtlevelSelectedWarship.text = curlevel
    view.txtOriLevelSelectedWarship.text = level
    view.txtNameSelectedWarship.text = myCfg.name

    if self.showData.chain > 0 then
        if self.showData.id == WarShipData.useData.id then
            self.view.btnRecycle:SetActive(false)
        else
            self.view.btnRecycle:SetActive(true)
        end
        view.txtHashSelectedWarship.text = "#" .. tokenID
    else
        self.view.btnRecycle:SetActive(false)
        view.txtHashSelectedWarship.text = ""
    end

end

function PnlWarShip:setViewSkill(isShow)
    local view = self.view

    if not isShow then
        view.viewSkill:SetActiveEx(false)
        return
    end
    view.viewSkill:SetActiveEx(true)
    -- local warShipCfg = gg.warShip.warShipCfg
    for i = 1, 5 do
        local skillCfgId = self.showData["skill" .. i]
        if skillCfgId and skillCfgId > 0 then
            local level = self.showData["skillLevel" .. i]
            local skillCfg = SkillUtil.getSkillCfgMap()[skillCfgId][level]
            self:setSkillWindow(i, level, skillCfg)
        else
            self:setSkillWindow(i)
        end
    end
end

function PnlWarShip:setSkillWindow(temp, level, skillCfg)
    local skill = self.btnSkillTable[temp]
    skill.obj:SetActiveEx(true)
    self.btnSkillTable[temp].skillCfg = skillCfg

    if not skillCfg then
        skill.obj.transform:Find("IconQuestion").gameObject:SetActive(true)
        skill.commonItemItem:setActive(false)
        skill.layoutSlider:SetActiveEx(false)
        return
    end

    skill.commonItemItem:setActive(true)
    skill.commonItemItem:initInfo()
    skill.commonItemItem:setLevel(level)
    local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")

    skill.commonItemItem:setIcon(icon)

    if self.showData.skillUp == temp then
        skill.layoutSlider:SetActiveEx(true)
        local time = self.showData.skillUpLessTickEnd - os.time()
        skill.slider.value = time / skillCfg.levelUpNeedTick
        skill.slider:DOValue(0, time):SetEase(CS.DG.Tweening.Ease.Linear)
        gg.timer:stopTimer(skill.sliderTimer)
        skill.sliderTimer = gg.timer:startLoopTimer(0, 1, -1, function()

            time = self.showData.skillUpLessTickEnd - os.time()
            local hms = gg.time.dhms_time({
                day = false,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            skill.txtSlider.text = string.format("%sH%sM%sS", hms.hour, hms.min, hms.sec)
        end)
    else
        skill.layoutSlider:SetActiveEx(false)
        gg.timer:stopTimer(skill.sliderTimer)

        skill.slider:DOKill()
    end

    if self.showingType == PnlWarShip.VIEW_UPGRADE then
        skill.commonItemItem:setImgArrowActive(WarshipUtil.checkIsCanUpgradeWarshipSkill(skillCfg))
    end
end

function PnlWarShip:setViewUpgrade(curCfg)
    local view = self.view
    view.commonUpgradeNewBox:setMessage(curCfg, self.showData.lessTickEnd)

    local nextCfg = WarshipUtil.getWarshipCfg(curCfg.cfgId, curCfg.quality, curCfg.level + 1)
    if self.args.type == PnlHeadquarters.SWICH_TOWER then
        nextCfg = cfg.getCfg("build", curCfg.cfgId, curCfg.level + 1, curCfg.quality)
    end

    -- if self.args.type == PnlHeadquarters.SWICH_TOWER then

    -- end
    self.view.commonUpgradeNewBox.transform:SetActiveEx(false)
    self.attentionUpgradeBox.transform:SetActiveEx(false)
    view.levelMax:SetActiveEx(false)
    view.levelUpgrade:SetActiveEx(false)
    view.viewUpgrade:SetActive(false)

    if nextCfg then
        view.viewUpgrade:SetActive(true)
        if not self.attentionUpgradeBox:checkTowerWarship(curCfg) then
            self.attentionUpgradeBox.transform:SetActiveEx(true)
        else
            self.view.commonUpgradeNewBox.transform:SetActiveEx(true)
            view.levelUpgrade:SetActiveEx(true)
            view.txtCurLevle.text = curCfg.level
            view.txtNextLevel.text = curCfg.level + 1
        end
    else
        view.levelMax:SetActiveEx(true)
        view.txtMaxLevel.text = curCfg.level
    end
end

function PnlWarShip:setViewInforMation()
    local cfgId = self.showData.cfgId
    local level = self.showData.level
    local quality = self.showData.quality
    local myCfg = cfg.getCfg(self.cfgType, cfgId, level, quality)

    self.view.txtInformation.text = Utils.getText(myCfg.desc)
end

function PnlWarShip:setViewForge()
    local view = self.view
    -- view.commonForgeBox:setData(gg.warShip.warshipForgeCfg)
end

function PnlWarShip:onBtnForge()

end

function PnlWarShip:onWarShipForgeResult(result)
    gg.uiManager:openWindow("PnlForgeResult", {
        result = result
    })
end

function PnlWarShip:onForgeResultAnimateFinish(result)
    self:chooseWindowType(self.showingType)
end

function PnlWarShip:onHide()
    self:releaseEvent()
    self.view.commonUpgradeNewBox:close()
end

function PnlWarShip:bindEvent()
    local view = self.view

    for k, v in ipairs(self.btnSkillTable) do
        local temp = k
        CS.UIEventHandler.Get(v.obj):SetOnClick(function()
            self:onBtnSkill(temp)
        end)
    end
    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnCloseChoose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnApply):SetOnClick(function()
        self:onBtnApply()
    end)
    CS.UIEventHandler.Get(view.btnUpgrade):SetOnClick(function()
        self:onBtnChangeUpgrade()
    end)
    CS.UIEventHandler.Get(view.btnOriLevelTips):SetOnClick(function()
        self:onBtnOriLevelTips()
    end)

    CS.UIEventHandler.Get(view.btnRecycle):SetOnClick(function()
        self:onBtnRecycle()
    end)
end

function PnlWarShip:releaseEvent()
    local view = self.view

    for k, v in ipairs(self.btnSkillTable) do
        CS.UIEventHandler.Clear(v.obj)
    end
    CS.UIEventHandler.Clear(view.btnReturn)
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnCloseChoose)
    CS.UIEventHandler.Clear(view.btnApply)
    CS.UIEventHandler.Clear(view.btnUpgrade)
    CS.UIEventHandler.Clear(view.btnOriLevelTips)

    -- CS.UIEventHandler.Clear(view.btnRecycle)
    self:destoryBtnWarship()

end

function PnlWarShip:onDestroy()
    local view = self.view
    view.commonUpgradeNewBox:release()
    -- view.commonForgeBox:release()
    view.LeftBtnViewBgBtnsBox:release()
    -- view.commonResBox:release()

    for key, value in pairs(self.btnSkillTable) do
        value.commonItemItem:release()
    end

    self.attentionUpgradeBox:release()
end

function PnlWarShip:onBtnSkill(temp)
    if self.showingType ~= PnlWarShip.VIEW_INFORMATION then
        return
    end

    if not self.btnSkillTable[temp].skillCfg then
        return
    end

    if self.selectSkillIndex == temp then
        self.selectSkillIndex = nil
        -- self.view.upgradeBox.gameObject:SetActive(false)
        return
    end

    local skillCfg = self.btnSkillTable[temp].skillCfg
    local cfgId = skillCfg.cfgId
    local level = skillCfg.level
    -- local callbackReturn = function()
    --     -- gg.uiManager:openWindow("PnlWarShip", PnlWarShip.VIEW_SKILL)
    -- end
    local callbackInstant = function()
        WarShipData.C2S_Player_WarShipSkillUp(self.showData.id, temp, 1)
    end
    local callbackUpgrade = function(isOnExchange)
        if isOnExchange then
            WarShipData.C2S_Player_WarShipSkillUp(self.showData.id, temp, 0)
        else -- if not WarshipUtil.checkWarshipBusy(true, temp) then
            WarShipData.C2S_Player_WarShipSkillUp(self.showData.id, temp, 0)
        end
    end

    local args = {
        callbackReturn = nil,
        callbackInstant = callbackInstant,
        exchangeInfoFunc = gg.bind(self.exchangeInfoFunc, self),
        callbackUpgrade = callbackUpgrade,
        cfg = SkillUtil.getSkillCfgMap()[cfgId][level],
        nextLevelCfg = SkillUtil.getSkillCfgMap()[cfgId][level + 1],
        lessTickEnd = self.showData.skillUpLessTickEnd
    }

    gg.uiManager:openWindow("PnlUpgrade", args)

    -- self.selectSkillIndex = temp
    -- self.view.upgradeBox.gameObject:SetActive(true)
    -- local pos = self.btnSkillTable[temp].obj.transform.localPosition
    -- self.view.upgradeBox.localPosition = pos
    -- self.skillIndex = temp
end

function PnlWarShip:onBtnSkillUpgrade()
    local skillCfg = self.btnSkillTable[self.skillIndex].skillCfg

    if not skillCfg then
        return
    end

    local cfgId = skillCfg.cfgId
    local level = skillCfg.level

    local callbackReturn = function()
        gg.uiManager:openWindow("PnlWarShip", PnlWarShip.VIEW_SKILL)
    end
    local callbackInstant = function()
        gg.warShip:instantUpgradeWarShipSkill(self.skillIndex)
    end
    local callbackUpgrade = function()
        gg.warShip:upgradeWarShipSkill(self.skillIndex)
    end

    local args = {
        callbackReturn = callbackReturn,
        callbackInstant = callbackInstant,
        callbackUpgrade = callbackUpgrade,
        cfg = HeroUtil.getSkillMap()[cfgId][level],
        nextLevelCfg = HeroUtil.getSkillMap()[cfgId][level + 1],
        lessTickEnd = self.showData.skillUpLessTickEnd
    }

    gg.uiManager:openWindow("PnlUpgrade", args)
    self:close()
end

function PnlWarShip:onBtnInstant()
    if self.args.type == PnlHeadquarters.SWICH_SHIP then
        gg.warShip:instantUpgradeWarShip(self.showData.id)
    else
        BuildData.C2S_Player_BuildLevelUp(self.showData.id, 1)
    end
    -- self:close()
end

function PnlWarShip:onBtnUpgrade(isOnExchange)
    if self.args.type == PnlHeadquarters.SWICH_SHIP then
        if isOnExchange then
            WarShipData.C2S_Player_WarShipLevelUp(self.showData.id, 0)
        elseif not WarshipUtil.checkWarshipBusy(true) then
            WarShipData.C2S_Player_WarShipLevelUp(self.showData.id, 0)
        end
    else
        BuildData.C2S_Player_BuildLevelUp(self.showData.id, 0)
    end
    -- self:close()
end

function PnlWarShip:exchangeInfoFunc()
    local isBusy, cost, busyType = WarshipUtil.checkWarshipBusy(false)
    local exchangeInfo = {}

    if isBusy then
        exchangeInfo.extraExchangeCost = cost
        if busyType == WarshipUtil.BUSY_TYPE_SKILL then
            exchangeInfo.text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        elseif busyType == WarshipUtil.BUSY_TYPE_LEVEL then
            exchangeInfo.text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        end
        return exchangeInfo
    end
end

function PnlWarShip:onBtnClose()
    self:close()
end

function PnlWarShip:onBtnReturn()
    self:chooseWindowType(PnlWarShip.VIEW_INFORMATION)
end

function PnlWarShip:onBtnRecycle()
    self:recycleWarShip()
end

function PnlWarShip:onBtnWarship(data)
    self.showData = data
    self:chooseWindowType(PnlWarShip.VIEW_INFORMATION)
    -- self:chooseWindowType(self.args)
end

function PnlWarShip:onBtnApply()
    if self.showData.id ~= gg.warShip.warShipData.id then
        WarShipData.C2S_Player_SetUseWarShip(self.showData.id)
        self:close()
    end
end

function PnlWarShip:onBtnChangeUpgrade()
    self:chooseWindowType(PnlWarShip.VIEW_UPGRADE)
end

function PnlWarShip:onBtnOriLevelTips()
    local isShow = self.view.bgExplain.activeSelf

    self.view.bgExplain:SetActive(not isShow)
end

function PnlWarShip:recycleWarShip()
    local cfgId = self.showData.cfgId
    local level = self.showData.level
    local quality = self.showData.quality
    local myCfg = cfg.getCfg(self.cfgType, cfgId, level, quality)
    local name = myCfg.name
    local txt = "Are you sure you want to recycle this " .. name
    local callbackYes = function()

    end

    local args = {
        btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
        bgType = PnlAlert.BG_TYPE_RECYCLE,
        txtYes = "CONFIRM",
        txt = txt,
        callbackYes = callbackYes
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

return PnlWarShip
