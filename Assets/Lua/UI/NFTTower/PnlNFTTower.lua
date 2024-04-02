

PnlNFTTower = class("PnlNFTTower", ggclass.UIBase)

function PnlNFTTower:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onNFTTowerChange" }
end

function PnlNFTTower:onAwake()
    self.view = ggclass.PnlNFTTowerView.new(self.pnlTransform)

    self.commonUpgradeNewBox = CommonUpgradeNewBox.new(self.view.commonUpgradeNewBox)
    self.commonUpgradeNewBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    self.commonUpgradeNewBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
    -- self.commonUpgradeNewBox:setExchangeInfoFunc(gg.bind(self.exchangeInfoFunc, self))

    self.towerItemList = {}
    self.towerScrollView = UILoopScrollView.new(self.view.towerScrollView, self.towerItemList)
    self.towerScrollView:setRenderHandler(gg.bind(self.onRenderTower, self))

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))
end

function PnlNFTTower:onShow()
    self:bindEvent()
    self.commonUpgradeNewBox:open()

    self:refresh()
    self:setSelect()
end

function PnlNFTTower:refresh()
    self.towerDataList = {}

    for key, value in pairs(BuildData.nftBuildData) do
        table.insert(self.towerDataList, value)
    end
    local itemCount = math.ceil(#self.towerDataList / 5)
    self.towerScrollView:setDataCount(itemCount)
end

function PnlNFTTower:onNFTTowerChange()
    self:refresh()

    if self.selectData then
        for index, value in ipairs(self.towerDataList) do
            if self.selectData.id == value.id then
                local curCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)
                self:setSelect(value, curCfg)
                return
            end
        end
    end

    self:setSelect()
end

function PnlNFTTower:setSelect(selectData, selectCfg)
    local view = self.view
    self.selectData = selectData

    for key, value in pairs(self.towerItemList) do
        value:refreshSelect()
    end

    if not selectData then
        view.layoutInfo:SetActiveEx(false)
        return
    end

    self.selectCfg = selectCfg
    self.nextCfg = BuildUtil.getCurBuildCfg(selectCfg.cfgId, selectCfg.level + 1, selectCfg.quality)

    view.layoutInfo:SetActiveEx(true)

    -- view.txtInfoName.text = Utils.getText(selectCfg.languageNameID)
    view.txtInfoName.text = selectCfg.name
    gg.setSpriteAsync(view.imgIcon, gg.getSpriteAtlasName("Icon_E_Atlas", selectCfg.icon .. "_E"))

    local buildLevel = self.args.buildData.level
    if buildLevel >= selectData.level then
        view.txtRealLevel.gameObject:SetActiveEx(false)
        view.txtInfoLevel.text = selectData.level
    else
        view.txtRealLevel.gameObject:SetActiveEx(true)
        view.txtInfoLevel.text = buildLevel
        view.txtRealLevel.text = selectData.level
    end

    view.txtInfoId.text = selectData.id

    self.attrScrollView:setItemCount(#constant.BUILD_SHOW_ATTR)
    self.commonUpgradeNewBox:setMessage(self.selectCfg, self.selectData.lessTickEnd)
end

function PnlNFTTower:onRenderTower(obj, index)
    for i = 1, 5 do
        local item = NftTowerItem:getItem(obj.transform:GetChild(i - 1), self.towerItemList, self)
        local subIndex = (index - 1) * 5 + i
        item:setData(self.towerDataList[subIndex])
    end
end

function PnlNFTTower:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, constant.BUILD_SHOW_ATTR, self.selectCfg, self.nextCfg)
end

function PnlNFTTower:onHide()
    self:releaseEvent()
    self.commonUpgradeNewBox:close()
end

function PnlNFTTower:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnRecycle):SetOnClick(function()
        self:onBtnRecycle()
    end)
    CS.UIEventHandler.Get(view.btnRealLevel):SetOnClick(function()
        self:onBtnRealLevel()
    end)
end

function PnlNFTTower:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnRecycle)
    CS.UIEventHandler.Clear(view.btnRealLevel)

end

function PnlNFTTower:onDestroy()
    local view = self.view
    self.commonUpgradeNewBox:release()
    self.towerScrollView:release()
end

function PnlNFTTower:onBtnClose()
    self:close()
end

function PnlNFTTower:onBtnRecycle()
    
end

function PnlNFTTower:onBtnRealLevel()
    self.view.bgExplain:SetActiveEx(not self.view.bgExplain.gameObject.activeSelf)
end

function PnlNFTTower:onBtnInstant()
    BuildData.C2S_Player_BuildLevelUp(self.selectData.id, 1)
end

function PnlNFTTower:onBtnUpgrade()

    if isOnExchange then
        BuildData.C2S_Player_BuildLevelUp(self.selectData.id, 0)
    else
        if not Utils.checkNftTowerBusy(true, self.selectData.id) then
            BuildData.C2S_Player_BuildLevelUp(self.selectData.id, 0)
        end
    end
end

function PnlNFTTower:exchangeInfoFunc()
    local isBusy, cost = HeroUtil.checkNftTowerBusy(false)
    if isBusy then
        local text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        return {
            extraExchangeCost = cost,
            text = text
        }
    end
end

---------------------------------------------------

NftTowerItem = NftTowerItem or class("NftTowerItem", ggclass.UIBaseItem)

function NftTowerItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function NftTowerItem:onInit()
    self.commonBagItem = CommonBagItem.new(self:Find("CommonBagItem"))
    self.sliderLife = self:Find("SliderLife", UNITYENGINE_UI_SLIDER)
    self.layoutSelect = self:Find("LayoutSelect")

    self.layoutUpgrade = self:Find("LayoutUpgrade")
    self.txtTime = self:Find("LayoutUpgrade/TxtTime", UNITYENGINE_UI_TEXT)
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function NftTowerItem:setData(data)
    self.data = data
    self:refreshSelect()

    if not data then
        self.gameObject:SetActiveEx(false)
        return
    end
    self.gameObject:SetActiveEx(true)
    local buildCfg = BuildUtil.getCurBuildCfg(data.cfgId, data.level, data.quality)
    self.buildCfg = buildCfg

    self.commonBagItem:setQuality(data.quality)
    self.commonBagItem:setIcon(gg.getSpriteAtlasName("Icon_E_Atlas", buildCfg.icon .. "_E"))
    self.commonBagItem:setLevel(data.level)
    self.sliderLife.value = data.curLife / data.life

    gg.timer:stopTimer(self.timer)
    if self.data.lessTick > 0 then
        self.layoutUpgrade.gameObject:SetActiveEx(true)

        self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
            local time = self.data.lessTickEnd - os.time()
            local hms = gg.time.dhms_time({
                day = false,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            self.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)

            if time <= 0 then
                gg.timer:stopTimer(self.timer)
                -- self.txtTime.gameObject:SetActiveEx(false)
            end
        end)

    else
        self.layoutUpgrade.gameObject:SetActiveEx(false)
    end
end

function NftTowerItem:onBtnItem()
    if self.data then
        self.initData:setSelect(self.data, self.buildCfg)
    end
end

function NftTowerItem:refreshSelect()
    self.layoutSelect:SetActiveEx(self.data and self.data == self.initData.selectData)
end

function NftTowerItem:onRelease()
    self.commonBagItem:release()
    gg.timer:stopTimer(self.timer)
end

return PnlNFTTower