PnlInstitute = class("PnlInstitute", ggclass.UIBase)

PnlInstitute.infomationType = ggclass.UIBase.INFOMATION_BASE_RES

function PnlInstitute:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = {"onSoliderChange", "onMineChange", "onRefreshResTxt"}
    self.showingType = 0
    self.forceItemList = {}
    self.mineItemList = {}
    self.args = self.args or {}
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN
    self.needBlurBG = true
end

function PnlInstitute:onAwake()
    self.view = ggclass.PnlInstituteView.new(self.pnlTransform)
    local view = self.view

    self.studyItemList = {}
    self.levelUpScrollView = UILoopScrollView.new(self.view.levelUpScrollView, self.studyItemList)
    self.levelUpScrollView:setRenderHandler(gg.bind(self.onRenderLevelUp, self))

    self.qualityItemList = {}
    self.qualityScrollView = UILoopScrollView.new(self.view.qualityScrollView, self.qualityItemList)
    self.qualityScrollView:setRenderHandler(gg.bind(self.onRenderQuality, self))

    view.leftBtnViewBgBtnsBox:setBtnDataList({
        {icon = "AttributeIcon_Atlas[Ascension_icon_A]", name = "Upgrade", callback = gg.bind(self.onBtnTop, self, PnlInstitute.TYPE_LEVEL)},
        {icon = "AttributeIcon_Atlas[Ascension_icon_F]",name = "Ascending", callback = gg.bind(self.onBtnTop, self, PnlInstitute.TYPE_QUALITY)},
    })

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttrItem, self))

    view.levelCommonUpgradeBox:setInstantCallback(gg.bind(self.onBtnLevelInstant, self))
    view.levelCommonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnLevelUp, self))
    view.levelCommonUpgradeBox:setExchangeInfoFunc(gg.bind(self.exchangeLevelInfoFunc, self))

    view.qualityCommonUpgradeBox:setInstantCallback(gg.bind(self.onBtnQualityInstant, self))
    view.qualityCommonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnQualityUp, self))
    view.qualityCommonUpgradeBox:setExchangeInfoFunc(gg.bind(self.exchangeLevelInfoFunc, self))

    self.levelCommonItemItemD1 = CommonHeroItem.new(view.levelCommonItemItemD1)
    self.qualityCommonItemItemD2 = CommonItemItemD2.new(view.qualityCommonItemItemD2)

    self.commonResBox2 = CommonResBox2.new(self.view.commonResBox2)

    self.attentionUpgradeBox = AttentionUpgradeBox.new(self.view.attentionUpgradeBox)
end

-- args = {index, openWindow = {name, args}}
function PnlInstitute:onShow()
    self:bindEvent()

    -- self.commonResBox2:open()
    -- self.commonResBox2:showResList({constant.RES_STARCOIN, constant.RES_ICE, constant.RES_TITANIUM, constant.RES_GAS})

    local view = self.view
    self.selectData = nil

    -- local index = self.args.index or 1
    view.levelCommonUpgradeBox:open()
    view.qualityCommonUpgradeBox:open()

    self.view.leftBtnViewBgBtnsBox:setBtnStageWithoutNotify(1)
    self:onBtnTop(PnlInstitute.TYPE_LEVEL, true)

    -- if self.args.openWindow then
    --     gg.uiManager:openWindow(self.args.openWindow.name, self.args.openWindow.args)
    -- end
end

function PnlInstitute:onHide()
    local view = self.view

    self:releaseEvent()
    view.levelCommonUpgradeBox:close()
    view.qualityCommonUpgradeBox:close()
end

function PnlInstitute:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(view.btnLevelInfo, gg.bind(self.onBtnLevelInfo, self))
end

function PnlInstitute:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlInstitute:onDestroy()
    local view = self.view
    self.levelUpScrollView:release()
    self.qualityScrollView:release()
    view.levelCommonUpgradeBox:release()
    view.qualityCommonUpgradeBox:release()
    self.attentionUpgradeBox:release()
end

function PnlInstitute:onBtnTop(showType, isForce)
    local view = self.view
    if self.showingType == showType and not isForce then
        return
    end
    self.showingType = showType
    for key, value in pairs(self.view.typeViewList) do
        if key == showType then
            value:SetActiveEx(true)
        else
            value:SetActiveEx(false)
        end
    end

    -- self:selectItem()
    self:refresh(showType)

    if showType == PnlInstitute.TYPE_LEVEL then
        -- self:selectItem(self.levelUpDataList[1].cfg[1], self.levelUpDataList[1].type)
        -- self.levelUpScrollView.component:Jump2DataIndex(1)
    elseif showType == PnlInstitute.TYPE_QUALITY then
        -- self:selectItem(self.qualityDataList[1].cfg[1], self.levelUpDataList[1].type)
        -- self.qualityScrollView.component:Jump2DataIndex(1)
    end
end

function PnlInstitute:getDataList(upgradeType)
    local dataList = {}

    if upgradeType == PnlInstitute.TYPE_QUALITY then
        for key, value in pairs(SoliderUtil.getSoliderQualityCfgMap()) do
            local bool = false
            if value[1][1] then
                bool = SoliderUtil.isInSoldierWhiteList(value[1][1].cfgId)
            else
                bool = true
            end
            if bool then
                table.insert(dataList, {
                    type = constant.INSTITUE_TYPE_SOLDIER,
                    studyId = key,
                    cfg = value
                })
            end

        end
    else
        for key, value in pairs(SoliderUtil.getSoliderStudyCfgMap()) do
            local bool = false
            if value[1][1] then
                bool = SoliderUtil.isInSoldierWhiteList(value[1][1].cfgId)
            else
                bool = true
            end
            if bool then
                table.insert(dataList, {
                    type = constant.INSTITUE_TYPE_SOLDIER,
                    studyId = key,
                    cfg = value
                })
            end
        end
    end

    if upgradeType == constant.INSTITUE_UPGRADE_TYPE_LEVEL then
        for key, value in pairs(MineUtil.getMineCfgMap()) do
            local bool = false
            if value[1][1] then
                bool = SoliderUtil.isInSoldierWhiteList(value[1][1].cfgId)
            end
            if bool then
                table.insert(dataList, {
                    type = constant.INSTITUE_TYPE_MINE,
                    studyId = key,
                    cfg = value
                })
            end
        end
    end

    table.sort(dataList, function(a, b)
        if a.type ~= b.type then
            return a.type == constant.INSTITUE_TYPE_SOLDIER
        end
        return a.studyId < b.studyId
    end)
    return dataList
end

PnlInstitute.TYPE_LEVEL = constant.INSTITUE_UPGRADE_TYPE_LEVEL
PnlInstitute.TYPE_QUALITY = constant.INSTITUE_UPGRADE_TYPE_QUALITY

function PnlInstitute:refresh(showType)
    if self.showingType ~= showType then
        return
    end
    if showType == PnlInstitute.TYPE_LEVEL then
        self:refreshLevel()
    elseif showType == PnlInstitute.TYPE_QUALITY then
        self:refreshQuality()
    end
end

function PnlInstitute:selectItem(selectCfg, institueType)
    local view = self.view

    selectCfg = selectCfg or self.selectData.selectCfg
    institueType = institueType or self.selectData.institueType

    self.selectData = {}
    self.selectData.institueType = institueType
    self.selectData.selectCfg = selectCfg

    if institueType == constant.INSTITUE_TYPE_SOLDIER then
        local cfgId = selectCfg[1].cfgId

        self.selectData.levelData = BuildData.soliderLevelData[cfgId]
        self.selectData.forgeData = BuildData.soliderForgeData[cfgId] or {
            level = 0,
            cfgId = cfgId
        }
        if SoliderUtil.getSoliderForgeCfgMap()[cfgId] then
            self.selectData.forgeCfg = SoliderUtil.getSoliderForgeCfgMap()[cfgId][self.selectData.forgeData.level]
        end
        self.selectData.curCfg = selectCfg[self.selectData.levelData.level]
        -- self.selectData.addCfg = selectCfg[self.selectData.levelData.level + 1]

        local level = self.selectData.levelData.level
        local forgeLevel = self.selectData.forgeData.level

        if self.showingType == PnlInstitute.TYPE_LEVEL then
            self.selectData.attributeCfg = SoliderUtil.getSoldierAttr(cfgId, level, forgeLevel,
                constant.INSTITUE_SOLDIER_SHOW_ATTR)
            if selectCfg[level + 1] == nil then
                self.selectData.compareAttrbuteCfg = self.selectData.attributeCfg
            else
                self.selectData.compareAttrbuteCfg = SoliderUtil.getSoldierAttr(cfgId, level + 1, forgeLevel,
                    constant.INSTITUE_SOLDIER_SHOW_ATTR)
            end

        elseif self.showingType == PnlInstitute.TYPE_QUALITY then
            -- self.selectData.attributeCfg = SoliderUtil.getSoldierAttr(cfgId, level + 1, forgeLevel, constant.INSTITUE_SOLDIER_SHOW_ATTR)
            self.selectData.attributeCfg = SoliderUtil.getSoldierAttr(cfgId, 1, forgeLevel,
                constant.INSTITUE_SOLDIER_SHOW_ATTR)
            local quality = SoliderUtil.getSoldierQuality(cfgId)
            local frontSoldierCfg = SoliderUtil.getSoliderStudyCfgMap()[self.selectData.curCfg.studyId][quality - 1]
            self.selectData.frontSoldierData = BuildData.soliderLevelData[frontSoldierCfg[1].cfgId]
            self.selectData.isCanUpQuality = frontSoldierCfg[self.selectData.frontSoldierData.level + 1] == nil
            self.selectData.isUnlock = self.selectData.levelData.level > 0
        end
    else
        self.selectData.levelData = BuildData.mineLevelData[selectCfg[1].cfgId]
        -- self.selectData.forgeData = BuildData.soliderForgeData[selectCfg[1].cfgId]
        self.selectData.curCfg = selectCfg[self.selectData.levelData.level]
        -- self.selectData.addCfg = selectCfg[self.selectData.levelData.level + 1]
        self.selectData.attributeCfg = selectCfg[self.selectData.levelData.level]
        self.selectData.compareAttrbuteCfg = selectCfg[self.selectData.levelData.level + 1]
    end

    if self.showingType == PnlInstitute.TYPE_LEVEL then
        -- view.txtLevelName.text = self.selectData.curCfg.name
        view.txtLevelName:SetLanguageKey(self.selectData.curCfg.languageNameID)
        if institueType == constant.INSTITUE_TYPE_SOLDIER then
            self.levelCommonItemItemD1:setIcon("Soldier_A_Atlas", self.selectData.curCfg.icon)
            self.levelCommonItemItemD1:setQuality(0)

            local raceIcon = string.format("Skill_A1_Atlas[%s]", constant.RACE_MESSAGE[self.selectData.curCfg.race].iconBig)
            gg.setSpriteAsync(self.view.imgLevelRace, raceIcon)
        else
            local icon = gg.getSpriteAtlasName("Build_B_Atlas", self.selectData.curCfg.icon .. "_B")
            self.levelCommonItemItemD1:setIcon(icon)
            self.levelCommonItemItemD1:setQuality(self.selectData.curCfg.quality)
        end
    elseif self.showingType == PnlInstitute.TYPE_QUALITY then
        view.txtQualityName.text = self.selectData.curCfg.name
        local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", self.selectData.curCfg.icon .. "_A")
        self.qualityCommonItemItemD2:setIcon(icon)
        self.qualityCommonItemItemD2:setQuality(SoliderUtil.getSoldierQuality(self.selectData.curCfg.cfgId))
    end

    view.txtFullLevel.transform:SetActiveEx(false)

    local itemList = nil
    if self.showingType == PnlInstitute.TYPE_LEVEL then
        itemList = self.studyItemList
    elseif self.showingType == PnlInstitute.TYPE_QUALITY then
        itemList = self.qualityItemList
    end

    for key, value in pairs(itemList) do
        value:refreshItemSelect()
    end
    view.txtName.text = self.selectData.curCfg.name
    self:refreshInfo()
end

function PnlInstitute:onBtnLevelInfo()
    if self.selectData.institueType == constant.INSTITUE_TYPE_SOLDIER then
        SoliderUtil.showSoldierInfo(self.selectData.curCfg)
    end
end

function PnlInstitute:refreshInfo()
    if not self.selectData then
        return
    end

    local view = self.view
    self.attrShowType = CommonAttrItem.TYPE_NORMAL

    if self.showingType == PnlInstitute.TYPE_LEVEL then

        self.view.levelCommonUpgradeBox:setMessage(self.selectData.curCfg, self.selectData.levelData.lessTickEnd)

        if self.selectData.curCfg.level == 19 then
            self.view.levelCommonUpgradeBox:setPart2Text(Utils.getText("res_BreakthroughButton"))
            self.view.levelCommonUpgradeBox:setPart2Sprite("Button_Atlas[btn_icon_C]")

        else
            self.view.levelCommonUpgradeBox:setPart2Text(Utils.getText("res_UpgradeButton"))
            self.view.levelCommonUpgradeBox:setPart2Sprite("Button_Atlas[btn_icon_B]")
        end

        local isLevelMax = false
        if self.selectData.institueType == constant.INSTITUE_TYPE_SOLDIER then
            isLevelMax =
                SoliderUtil.getSoliderCfgMap()[self.selectData.levelData.cfgId][self.selectData.levelData.level + 1] ==
                    nil
        elseif self.selectData.institueType == constant.INSTITUE_TYPE_MINE then
            isLevelMax =
                MineUtil.getMineCfgMap()[self.selectData.levelData.cfgId][self.selectData.levelData.level + 1] == nil
        end

        self.attentionUpgradeBox:setActive(false)
        view.layoutLevelUp.transform:SetActiveEx(false)
        view.txtLevelMax.transform:SetActiveEx(false)
        view.levelCommonUpgradeBox:setActive(false)
        view.txtFullLevel.transform:SetActiveEx(false)

        if isLevelMax then
            view.txtLevelMax.transform:SetActiveEx(true)
            view.txtFullLevel.transform:SetActiveEx(true)
            self.attrShowType = CommonAttrItem.TYPE_SINGLE_TEXT
        else
            view.layoutLevelUp.transform:SetActiveEx(true)
            local strLevel = self.selectData.levelData.level
            view.txtLevel.text = strLevel
            view.txtLevelAfter.text = self.selectData.levelData.level + 1

            if self.attentionUpgradeBox:checkSoldier(self.selectData.curCfg) then
                view.levelCommonUpgradeBox:setActive(true)
            else
                self.attentionUpgradeBox:setActive(true)
            end
        end

    elseif self.showingType == PnlInstitute.TYPE_QUALITY then
        if self.selectData.isCanUpQuality and not self.selectData.isUnlock then
            self.view.qualityCommonUpgradeBox:setActive(true)
            self.view.qualityCommonUpgradeBox:setMessage(self.selectData.curCfg, self.selectData.levelData.lessTickEnd,
                {constant.RES_TITANIUM, constant.RES_STARCOIN})
        else
            self.view.qualityCommonUpgradeBox:setActive(false)
        end
        view.txtNextQuality.text = SoliderUtil.getSoldierQuality(self.selectData.levelData.cfgId)

        self.attrShowType = CommonAttrItem.TYPE_SINGLE_TEXT
    end

    self:refreshAttr()
end

function PnlInstitute:refreshAttr()
    if self.selectData.institueType == constant.INSTITUE_TYPE_SOLDIER then
        self.attrCfgList = constant.INSTITUE_SOLDIER_SHOW_ATTR
    elseif self.selectData.institueType == constant.INSTITUE_TYPE_MINE then
        self.attrCfgList = constant.INSTITUE_MINE_SHOW_ATTR
    end

    self.attrScrollView:setItemCount(#self.attrCfgList)
end

function PnlInstitute:onRefreshResTxt()
end

function PnlInstitute:refreshLevelPos(txtLevel, levelArrow, txtLevelAfter, str)
    local levelWidth = txtLevel:GetTextRenderWidth(str)
    local arrowWidth = levelArrow.transform.rect.width
    levelArrow.transform.anchoredPosition = CS.UnityEngine.Vector2(levelWidth, levelArrow.transform.anchoredPosition.y)
    txtLevelAfter.transform.anchoredPosition = CS.UnityEngine.Vector2(levelWidth + arrowWidth,
        txtLevelAfter.transform.anchoredPosition.y)
end

------------------------level
function PnlInstitute:refreshLevel()
    self.levelUpDataList = {}
    for key, value in pairs(BuildData.soliderLevelData) do
        local cfg = SoliderUtil.getSoliderCfgMap()[value.cfgId]
        if cfg[1].belong == 1 and SoliderUtil.isInSoldierWhiteList(value.cfgId) then
            table.insert(self.levelUpDataList,
            {
                data = value,
                cfg = SoliderUtil.getSoliderCfgMap()[value.cfgId],
                upgradeType = constant.INSTITUE_TYPE_SOLDIER,
            })
        end
    end

    table.sort(self.levelUpDataList, function (a, b)
        if a.data.level ~= b.data.level and (a.data.level == 0 or b.data.level == 0) then
            return a.data.level ~= 0
        end
        return a.data.cfgId < b.data.cfgId
    end)

    local itemCount = math.ceil(#self.levelUpDataList / 4)
    self.levelUpScrollView:setDataCount(itemCount)

    if not self.selectData then
        self:selectItem(self.levelUpDataList[1].cfg, self.levelUpDataList[1].upgradeType)
    end
end

function PnlInstitute:onRenderLevelUp(obj, index)
    for i = 1, 4, 1 do
        local subIndex = (index - 1) * 4 + i
        local item = InstituteLevelSubItem:getItem(obj.transform:GetChild(i - 1), self.studyItemList, self, self)
        item:setData(self.levelUpDataList[subIndex])
    end
end

function PnlInstitute:onBtnLevelUp(isOnExchange)
    if not self:checkIsCanLevelUp() then
        return
    end

    if isOnExchange then
        self:instituteLevelUp()
    elseif not Utils.checkIsInstituteBusy(true, constant.INSTITUE_UPGRADE_TYPE_LEVEL, self.selectData.institueType,
        self.selectData.levelData.cfgId) then
        self:instituteLevelUp()
    end
end

function PnlInstitute:instituteLevelUp()
    if self.selectData.institueType == constant.INSTITUE_TYPE_SOLDIER then
        BuildData.C2S_Player_SoliderLevelUp(self.selectData.levelData.cfgId, 0)
    elseif self.selectData.institueType == constant.INSTITUE_TYPE_MINE then
        BuildData.C2S_Player_MineLevelUp(self.selectData.levelData.cfgId, 0)
    end
end

function PnlInstitute:onBtnLevelInstant()
    if not self:checkIsCanLevelUp() then
        return
    end

    if self.selectData.institueType == constant.INSTITUE_TYPE_SOLDIER then
        BuildData.C2S_Player_SoliderLevelUp(self.selectData.levelData.cfgId, 1)

    elseif self.selectData.institueType == constant.INSTITUE_TYPE_MINE then
        BuildData.C2S_Player_MineLevelUp(self.selectData.levelData.cfgId, 1)
    end
end

function PnlInstitute:checkIsCanLevelUp()
    if self.args and self.args.buildData and self.args.buildData.lessTickEnd > os.time() then
        gg.uiManager:showTip("building is upgrading")
        return false
    end

    return true
end

function PnlInstitute:exchangeLevelInfoFunc()
    local exchangeInfo = {}
    local isBusy, upgradeingType, mitCost = Utils.checkIsInstituteBusy(false)
    if isBusy then
        exchangeInfo.extraExchangeCost = mitCost
        if upgradeingType == constant.INSTITUE_TYPE_SOLDIER then
            exchangeInfo.text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        elseif upgradeingType == constant.INSTITUE_TYPE_MINE then
            exchangeInfo.text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        end
    end
    return exchangeInfo
end
-------------quality
function PnlInstitute:refreshQuality()
    self.qualityDataList = self:getDataList(constant.INSTITUE_UPGRADE_TYPE_QUALITY)
    self.qualityScrollView:setDataCount(#self.qualityDataList)
end

function PnlInstitute:onBtnQualityInstant()
    BuildData.C2S_Player_SoliderQualityUpgrade(self.selectData.frontSoldierData.cfgId, 1)
end

function PnlInstitute:onBtnQualityUp()
    if not Utils.checkIsInstituteBusy(true, constant.INSTITUE_UPGRADE_TYPE_QUALITY, self.selectData.institueType,
        self.selectData.frontSoldierData.cfgId) then
        BuildData.C2S_Player_SoliderQualityUpgrade(self.selectData.frontSoldierData.cfgId, 0)
    end
end

function PnlInstitute:onRenderQuality(obj, index)
    local item = InstitueQualityItem:getItem(obj, self.qualityItemList, self)
    item:setData(self.qualityDataList[index], constant.INSTITUE_UPGRADE_TYPE_QUALITY)
end
--------------------------------------------

function PnlInstitute:onSoliderChange()
    self:refresh(self.showingType)
    self:selectItem()
end

function PnlInstitute:onMineChange()
    self:refresh(PnlInstitute.TYPE_LEVEL)
    self:selectItem()
end

function PnlInstitute:onBtnClose()
    self:close()
end

function PnlInstitute:onRenderAttrItem(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, self.attrCfgList, self.selectData.attributeCfg, self.selectData.compareAttrbuteCfg,
        self.attrShowType)
end

return PnlInstitute
