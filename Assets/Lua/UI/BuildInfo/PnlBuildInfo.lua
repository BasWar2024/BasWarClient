PnlBuildInfo = class("PnlBuildInfo", ggclass.UIBase)
PnlBuildInfo.infomationType = ggclass.UIBase.INFOMATION_RES

function PnlBuildInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.needBlurBG = true
    self.layer = UILayer.normal
    self.events = {"onUpdateBuildData", "onRefreshResTxt"}
    -- self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_SCALE
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlBuildInfo:onAwake()
    self.view = ggclass.PnlBuildInfoView.new(self.pnlTransform)
    local view = self.view
    view.techDescBox:SetActiveEx(false)

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.scRectAttr, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))
    self.prepareItemList = {}
    self.prepareScrollView = UIScrollView.new(self.view.prepareScrollView, "BuildInfoPrepareItemSmall",
        self.prepareItemList)
    self.prepareScrollView:setRenderHandler(gg.bind(self.onRenderPrepareItem, self))

    self.commonUpgradeNewBox = ggclass.CommonUpgradeNewBox.new(view.commonUpgradeNewBox)

    self.commonUpgradeNewBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    self.commonUpgradeNewBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
    self.commonUpgradeNewBox:setExchangeInfoFunc(gg.bind(self.exchangeInfoFunc, self))

    self.buildInfoTechnoItemList = {}
    for i = 1, 4 do
        table.insert(self.buildInfoTechnoItemList,
            BuildInfoTechnoItem.new(self.view.LayoutTechnologys:GetChild(i - 1), self))
    end
end

PnlBuildInfo.TYPE_INFO = 1
PnlBuildInfo.TYPE_UPGRADE = 2

-- args = {buildInfo = , type = }
function PnlBuildInfo:onShow()
    self:bindEvent()
    self.commonUpgradeNewBox:open()
    self:refresh(self.args.type)
end

function PnlBuildInfo:refresh(showType)
    local view = self.view
    self.type = showType or 1
    self.buildInfo = self.args.buildInfo
    self.buildCfg = BuildUtil.getCurBuildCfg(self.buildInfo.cfgId, self.buildInfo.level, self.buildInfo.quality)
    local iconName = gg.getSpriteAtlasName("Build_B_Atlas", self.buildCfg.icon .. "_B")
    gg.setSpriteAsync(view.imgBuild, iconName)
    view.txtAlert.transform:SetActiveEx(false)

    if self.type == PnlBuildInfo.TYPE_INFO then
        self:refreshInfo()
    elseif self.type == PnlBuildInfo.TYPE_UPGRADE then
        self:refreshUpgrade()
    end
    self:refreshAttr()
end

function PnlBuildInfo:refreshInfo()
    local view = self.view
    local buildCfg = self.buildCfg

    view.txtInfoLevel.text = buildCfg.level
    view.txtInfoName.text = Utils.getText(buildCfg.languageNameID)
    view.LayoutInfo.transform:SetActiveEx(true)
    view.layoutUpgrade.transform:SetActiveEx(false)
    view.txtDesc.text = Utils.getText(buildCfg.desc)
    view.txtAlertUnlock.transform:SetActiveEx(self.buildCfg.cfgId == constant.BUILD_BASE and
                                                  BuildUtil.getCurBuildCfg(self.buildCfg.cfgId, self.buildCfg.level + 1,
            self.buildCfg.quality))

    if buildCfg.pledgeId and buildCfg.pledgeId > 0 then
        local pledgeId = buildCfg.pledgeId
        local vipCfg = cfg.vip[VipData.vipData.vipLevel]

        -- view.txtAlert.transform:SetActiveEx(false)
        -- view.txtAlert.transform.anchoredPosition = 
        --     CS.UnityEngine.Vector2(view.txtName.transform.anchoredPosition.x + view.txtName.preferredWidth + 5, view.txtAlert.transform.anchoredPosition.y)

        if vipCfg[constant.RES_2_CFG_KEY[pledgeId].vipKey] then
            if vipCfg[constant.RES_2_CFG_KEY[pledgeId].vipKey] > 1 then
                view.txtAlert.transform:SetActiveEx(true)
                view.txtAlert.text = "yield bonus"
            elseif vipCfg[constant.RES_2_CFG_KEY[pledgeId].vipKey] == 0 then
                view.txtAlert.transform:SetActiveEx(true)
                view.txtAlert.text = "Not working: MIT pledge require!"
            end
        end
    end
end

function PnlBuildInfo:refreshUpgrade()
    local view = self.view
    local buildCfg = self.buildCfg
    view.LayoutInfo.transform:SetActiveEx(false)
    view.layoutUpgrade.transform:SetActiveEx(true)
    view.txtUpgradeName.text = Utils.getText(buildCfg.languageNameID)
    view.txtUpgradeLevelBefore.text = buildCfg.level
    view.txtUpgradeLevelAfter.text = buildCfg.level + 1

    local nextBuildCfg = BuildUtil.getCurBuildCfg(buildCfg.cfgId, buildCfg.level + 1, buildCfg.quality)
    local isLevelMax = nextBuildCfg == nil

    if nextBuildCfg and nextBuildCfg.UnlockTechnology and next(nextBuildCfg.UnlockTechnology) then
        view.LayoutUnlockTechnology:SetActiveEx(true)

        for index, value in ipairs(self.buildInfoTechnoItemList) do
            local techInfo = nextBuildCfg.UnlockTechnology[index]
            if techInfo and techInfo[2] and techInfo[2] > 0 and cfg.Technology[techInfo[1]] then
                value:setActive(true)
                -- local technologyCfg = cfg.Technology[techInfo]
                value:setData(cfg.Technology[techInfo[1]], techInfo[2])
            else
                value:setActive(false)
            end
        end
    else
        view.LayoutUnlockTechnology:SetActiveEx(false)
    end

    if isLevelMax then
        view.txtLevelMax.gameObject:SetActiveEx(true)
        view.LayoutLevelChange:SetActiveEx(false)
    else
        view.txtLevelMax.gameObject:SetActiveEx(false)
        view.LayoutLevelChange:SetActiveEx(true)
    end
    self:refreshUpgradeLock()
end

local spancing = 10
function PnlBuildInfo:refreshAttr()
    local view = self.view

    self.showAttrMap = BuildUtil.getBuildAttr(self.buildInfo.cfgId, self.buildInfo.level, self.buildInfo.quality, 0)
    self.attrCfgList = AttrUtil.getAttrList(gg.deepcopy(self.buildCfg.showAttr[1]))

    self.showCompareAttrMap = nil
    if self.type == PnlBuildInfo.TYPE_INFO then
        local totalLenth = self.attrScrollView.transform.anchoredPosition.y - view.txtDesc.transform.anchoredPosition.y
        local txtDescLenth = view.txtDesc.preferredHeight
        local attrLenth = totalLenth - txtDescLenth - spancing
        if view.txtAlert.gameObject.activeSelf then
            attrLenth = attrLenth - spancing - view.txtAlert.transform.rect.height
        end
        self.attrScrollView.transform:SetRectSizeY(attrLenth)

        view.gridLayoutGroupAttrContent.cellSize = CS.UnityEngine.Vector2(view.txtDesc.transform.rect.width,
            view.gridLayoutGroupAttrContent.cellSize.y)
        self.showCompareAttrMap = nil

        local buildCfg = BuildUtil.getCurBuildCfg(self.buildInfo.cfgId, self.buildInfo.level, self.buildInfo.quality)

        -- if buildCfg.type == constant.BUILD_DEFENSE then
        --     table.insert(self.attrCfgList, cfg.attribute.Shrine_AtkAdd)
        --     table.insert(self.attrCfgList, cfg.attribute.Shrine_HpAdd)
        --     -- table.insert(self.attrCfgList, cfg.attribute.atkAir)
        -- end

    elseif self.type == PnlBuildInfo.TYPE_UPGRADE then
        self.showCompareAttrMap = BuildUtil.getBuildAttr(self.buildInfo.cfgId, self.buildInfo.level + 1,
            self.buildInfo.quality, 0) or {}
        view.gridLayoutGroupAttrContent.cellSize = CS.UnityEngine.Vector2(817, 46)

        if view.LayoutUnlockTechnology.gameObject.activeSelf then
            self.attrScrollView.transform:SetRectSizeY(112)
        else
            self.attrScrollView.transform:SetRectSizeY(307)
        end
    end

    if self.type == PnlBuildInfo.TYPE_UPGRADE then
        self.attrCfgList = AttrUtil.getAttrChangeCfgList(self.attrCfgList, self.showAttrMap, self.showCompareAttrMap)
    end

    local itemCount = #self.attrCfgList
    local itemLenth = itemCount *
                          (view.gridLayoutGroupAttrContent.cellSize.y + view.gridLayoutGroupAttrContent.spacing.y) -
                          view.gridLayoutGroupAttrContent.spacing.y
    local lenth = math.min(itemLenth, self.attrScrollView.transform.rect.height)

    if view.txtAlert.gameObject.activeSelf then
        view.txtAlert.transform.anchoredPosition = CS.UnityEngine.Vector2(view.txtAlert.transform.anchoredPosition.x,
            self.attrScrollView.transform.anchoredPosition.y - lenth - spancing)
    end
    self.attrScrollView:setItemCount(itemCount)
end

function PnlBuildInfo:refreshUpgradeLock()
    local view = self.view
    self:setUpgradeStage(BuildUtil.checkIsCanLevelUp(self.buildCfg))
    local isUnlock, lockMap, lockList = gg.buildingManager:checkUpgradeLock(self.buildCfg)
    -- self.lockDataList = lockList
    self.lockDataList = {}
    for key, value in pairs(lockMap) do
        table.insert(self.lockDataList, value)
    end

    table.sort(self.lockDataList, function(a, b)
        if a.isUnlock ~= b.isUnlock then
            return not a.isUnlock
        end
        return a.cfgId < b.cfgId
    end)

    
    local enoughCon, totalCon = BuildUtil.chackLevelUpNeedConstruction(self.buildCfg)

    isUnlock = isUnlock and enoughCon
    view.layoutPrepare:SetActiveEx(not isUnlock)

    if not enoughCon then
        table.insert(self.lockDataList, {isConstruction = true, totalCon = totalCon, buildCfg = self.buildCfg})
    end

    if not isUnlock then
        view.prepareScrollView:SetActiveEx(true)
        view.layoutUpgradeAlert:SetActiveEx(false)
        self.prepareScrollView:setItemCount(#self.lockDataList)
    end

    local isLevelMax = BuildUtil.getCurBuildCfg(self.buildCfg.cfgId, self.buildCfg.level + 1, self.buildCfg.quality) ==
                           nil
    if isUnlock and not isLevelMax and enoughCon then
        self.commonUpgradeNewBox:open()
        self.commonUpgradeNewBox:setMessage(self.buildCfg, self.buildInfo.lessTickEnd, nil,
            {PnlAlert.CLOSE_REQUIREMENT_TYPE_BUILD, self.buildInfo.id})
    else
        self.commonUpgradeNewBox:close()
    end
end

function PnlBuildInfo:onUpdateBuildData(args, data)
    if data.id == self.buildInfo.id then
        self:setArgs({
            buildInfo = data,
            type = self.type
        })
        self:refresh(self.type)
    elseif self.type == PnlBuildInfo.TYPE_UPGRADE then
        self:refreshUpgradeLock()
    end
end

function PnlBuildInfo:onRefreshResTxt()
    local view = self.view
    if self.type == self.TYPE_UPGRADE then
        self:setUpgradeStage(BuildUtil.checkIsCanLevelUp(self.buildCfg))
    end
end

function PnlBuildInfo:setUpgradeStage(isCan)
    local view = self.view
end

function PnlBuildInfo:onHide()
    self:releaseEvent()
    self.commonUpgradeNewBox:close()
end

function PnlBuildInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)

    self:setOnClick(view.techDescBox.gameObject, gg.bind(self.onBtnTextBox, self))
end

function PnlBuildInfo:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlBuildInfo:onBtnTextBox()
    self.view.techDescBox:SetActiveEx(false)
end

function PnlBuildInfo:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    self.commonUpgradeNewBox:release()
    self.prepareScrollView:release()

    for key, value in pairs(self.buildInfoTechnoItemList) do
        value:release()
    end
end

function PnlBuildInfo:onBtnUpgrade(isOnExchange)
    local yesCallBack = function()
        BuildData.C2S_Player_BuildLevelUp(self.buildInfo.id, 0)
    end

    if isOnExchange then
        BuildData.C2S_Player_BuildLevelUp(self.buildInfo.id, 0)
    else
        if gg.buildingManager:checkWorkers(true, yesCallBack) then
            BuildData.C2S_Player_BuildLevelUp(self.buildInfo.id, 0)
        end
    end
end

function PnlBuildInfo:onBtnInstant()
    BuildData.C2S_Player_BuildLevelUp(self.buildInfo.id, 1)
end

function PnlBuildInfo:exchangeInfoFunc()
    if not BuildingManager:checkWorkers() then
        local workingCount, buildId, cost = BuildingManager.getBuildWorkSpeedUpInfo()
        return {
            extraExchangeCost = cost,
            text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        }
    end
end

function PnlBuildInfo:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)

    if self.type == self.TYPE_INFO then
        if self.buildCfg.pledgeId and self.buildCfg.pledgeId > 0 then

            local attrCfg = self.attrCfgList[index]
            if constant.RES_2_CFG_KEY[self.buildCfg.pledgeId].perMakeKey == attrCfg.cfgKey then
                local rate = cfg.vip[VipData.vipData.vipLevel][constant.RES_2_CFG_KEY[self.buildCfg.pledgeId].vipKey]
                local attr = self.showAttrMap[self.attrCfgList[index].cfgKey]
                local curAttr = attr * rate

                if attr ~= curAttr then
                    if curAttr > attr then
                        item:setInfo(attrCfg.icon, attrCfg.name, attr, "+" .. (curAttr - attr),
                            CommonAttrItem.TYPE_SINGLE_TEXT_VIP, nil, nil, index)
                    else
                        item:setInfo(attrCfg.icon, attrCfg.name, attr, (curAttr - attr),
                            CommonAttrItem.TYPE_SINGLE_TEXT_VIP, nil, nil, index)
                    end
                    return
                end
            end
        end
    end

    local showAttrType = CommonAttrItem.TYPE_SINGLE_TEXT
    if self.showCompareAttrMap then
        showAttrType = CommonAttrItem.TYPE_NORMAL
    end
    item:setData(index, self.attrCfgList, self.showAttrMap, self.showCompareAttrMap, showAttrType)
end

function PnlBuildInfo:onRenderPrepareItem(obj, index)
    local item = BuildInfoPrepareItem:getItem(obj, self.prepareItemList, self)
    item:setData(self.lockDataList[index])
end

function PnlBuildInfo:showTescDesc(buildInfoTechnoItem)
    local view = self.view
    view.techDescBox:SetActiveEx(true)
    view.bgTechDesc.transform.position = buildInfoTechnoItem.transform.position
    local pos = view.bgTechDesc.transform.anchoredPosition
    pos.y = pos.y + buildInfoTechnoItem.transform.sizeDelta.y / 2 + 10
    view.bgTechDesc.transform.anchoredPosition = pos
    view.txtTechName.text = Utils.getText(buildInfoTechnoItem.curCfg.languageNameID)
    view.txtTechDesc.text = Utils.getText(buildInfoTechnoItem.curCfg.shortDesc)
    view.bgTechDesc:SetRectSizeY(math.max(view.txtTechDesc.preferredHeight + 100), 130)
end

-- guide
-- ""ui
-- override
function PnlBuildInfo:getGuideRectTransform(guideCfg)
    if guideCfg.gameObjectName == "upgrade" then
        return self.commonUpgradeNewBox.commonUpgradePartList[2].btn

    elseif guideCfg.gameObjectName == "instanceUpgrade" then
        return self.commonUpgradeNewBox.commonUpgradePartList[1].btn
    end

    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlBuildInfo:triggerGuideClick(guideCfg)
    if guideCfg.gameObjectName == "upgrade" then
        self.commonUpgradeNewBox.commonUpgradePartList[2]:setActive(false)
        self.commonUpgradeNewBox.commonUpgradePartList[1]:setStaticSliderData(self.buildCfg.levelUpNeedTick)

    elseif guideCfg.gameObjectName == "instanceUpgrade" then
        return self.commonUpgradeNewBox:onBtn(1)
    end

    ggclass.UIBase.triggerGuideClick(self, guideCfg)
end

return PnlBuildInfo
