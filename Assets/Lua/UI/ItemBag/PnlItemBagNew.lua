PnlItemBagNew = class("PnlItemBagNew", ggclass.UIBase)

PnlItemBagNew.BAGBELONG_ME = 1
PnlItemBagNew.BAGBELONG_UNINON = 2
PnlItemBagNew.BAGBELONG_MYPLANET = 3

PnlItemBagNew.needFitSafeArea = true
PnlItemBagNew.closeType = ggclass.UIBase.CLOSE_TYPE_NONE


PnlItemBagNew.canvasBgColor = constant.COLOR_BLACK
-- args = {bagBelong}

function PnlItemBagNew:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onRefreshItemBag", "onItemSort", "onRedPointChange"}
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN

    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

PnlItemBagNew.FILTER_TYPE_ALL = -1

PnlItemBagNew.FILTER_TYPE_NFT_ITEM = constant.ITEM_ITEMTYPE_NFT_ITEM
PnlItemBagNew.FILTER_TYPE_DAO_ITEM = constant.ITEM_ITEMTYPE_DAO_ITEM
PnlItemBagNew.FILTER_TYPE_PROP = constant.ITEM_ITEMTYPE_PROP
PnlItemBagNew.FILTER_TYPE_SKILL_PIECES = constant.ITEM_ITEMTYPE_SKILL_PIECES

PnlItemBagNew.FILTER_NAME = {
    [PnlItemBagNew.FILTER_TYPE_ALL] = "bag_All"
}

function PnlItemBagNew:onAwake()
    self.view = ggclass.PnlItemBagNewView.new(self.pnlTransform)
    local view = self.view
    self.itemList = {}
    self.itemScrollView = UILoopScrollView.new(view.itemScrollView, self.itemList)
    self.itemScrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
    self.LeftBtnViewBgBtnsBox = ItemBagOptionBtns.new(view.LeftBtnViewBgBtnsBox)

    self.leftBtnDataList = {{
        languageKey = PnlItemBagNew.FILTER_NAME[PnlItemBagNew.FILTER_TYPE_ALL],
        callback = gg.bind(self.onBtnFilter, self, PnlItemBagNew.FILTER_TYPE_ALL)
    }}
    self.LeftBtnViewBgBtnsBox:setBtnDataList(self.leftBtnDataList)

    self.redPointBtnMap = {
        [RedPointItemBagNft.__name] = view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_NFT_ITEM],
        [RedPointItemBagDao.__name] = view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_DAO_ITEM],
        [RedPointItemBagItem.__name] = view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_PROP],
        [RedPointItemBagSkillCard.__name] = view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_SKILL_PIECES]
    }
end

function PnlItemBagNew:onShow()
    self:bindEvent()
    local view = self.view
    self.sortType = PnlItemBagNew.SORT_TYPE_UP

    self.LeftBtnViewBgBtnsBox:setBtnStageWithoutNotify(1)

    self.view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_NFT_ITEM]:SetActiveEx(false)
    self.view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_DAO_ITEM]:SetActiveEx(false)
    self:onBtnFilter(PnlItemBagNew.FILTER_TYPE_PROP, true)

    -- if IsAuditVersion() then
    --     self.view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_NFT_ITEM]:SetActiveEx(false)
    --     self.view.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_DAO_ITEM]:SetActiveEx(false)
    --     self:onBtnFilter(PnlItemBagNew.FILTER_TYPE_PROP, true)
    -- else
    --     self:onBtnFilter(PnlItemBagNew.FILTER_TYPE_NFT_ITEM, true)
    -- end
    
    self:refreshBagCount()

    self:initRedPoint()
end

function PnlItemBagNew:onRedPointChange(_, name, isRed)
    if self.redPointBtnMap[name] then
        RedPointManager:setRedPoint(self.redPointBtnMap[name], isRed)
    end
end

function PnlItemBagNew:initRedPoint()
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function PnlItemBagNew:refreshBagCount()
    -- local view = self.view
    -- local totalCount = 0
    -- for key, value in pairs(ItemData.itemBagData) do
    --     totalCount = totalCount + 1
    -- end

    -- view.sliderSpace.value = totalCount / (ItemData.maxSpace + ItemData.expandSpace)

    -- if ItemData.maxSpace + ItemData.expandSpace - totalCount <= 5 then
    --     view.imgAlertSpace.gameObject:SetActiveEx(true)
    --     view.txtSpace.text = "<color=#de7463>" .. totalCount .. "</color>" .. " / " .. ItemData.maxSpace + ItemData.expandSpace
    -- else
    --     view.imgAlertSpace.gameObject:SetActiveEx(false)
    --     view.txtSpace.text = totalCount .. " / " .. ItemData.maxSpace + ItemData.expandSpace
    -- end
end

function PnlItemBagNew:onRenderItem(gameObject, index)
    for i = 1, 5 do
        local dataIndex = (index - 1) * 5 + i
        local item = BagItem:getItem(gameObject.transform:GetChild(i - 1), self.itemList, self)
        item:setData(self.itemDataList[dataIndex])
    end
end

PnlItemBagNew.switchType2AutoPushType = {
    [PnlItemBagNew.FILTER_TYPE_NFT_ITEM] = constant.AUTOPUSH_CFGID_NEW_ITEM_13,
    [PnlItemBagNew.FILTER_TYPE_DAO_ITEM] = constant.AUTOPUSH_CFGID_NEW_ITEM_14,
    [PnlItemBagNew.FILTER_TYPE_PROP] = constant.AUTOPUSH_CFGID_NEW_ITEM_15,
    [PnlItemBagNew.FILTER_TYPE_SKILL_PIECES] = constant.AUTOPUSH_CFGID_NEW_ITEM_16
}

function PnlItemBagNew:onBtnFilter(filterType, isForce)
    local autoPushCfgId = PnlItemBagNew.switchType2AutoPushType[filterType]
    if autoPushCfgId then
        local status = AutoPushData.getAutoPushStatus(autoPushCfgId)
        if status and status > 0 then
            AutoPushData.C2S_Player_AutoPushStatus_Del(autoPushCfgId)
        end
    end

    for k, v in pairs(self.view.BtnItemTypeList) do
        if k ~= filterType then
            v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
            v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x3d / 0xff, 0x97 / 0xff, 1, 1)
            -- local iconName = gg.getSpriteAtlasName("Item_Atlas", "warehouse02_icon")
            -- gg.setSpriteAsync(v.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)
        end
    end
    self.view.BtnItemTypeList[filterType].transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
    self.view.BtnItemTypeList[filterType].transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(1,
        1, 1, 1)
    -- local iconName = gg.getSpriteAtlasName("Item_Atlas", "warehouse01_icon")
    -- gg.setSpriteAsync(self.view.BtnItemTypeList[filterType].transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE),
    --     iconName)

    if not isForce and self.filterType == filterType then
        return
    end
    self.view.btnOpenFilter:SetActiveEx(true)

    local curItemBagData = ItemData.itemBagData
    self.view.btnOpenFilter:SetActiveEx(false)

    self.filterType = filterType
    self.view.txtFilter.text = Utils.getText(PnlItemBagNew.FILTER_NAME[filterType])
    self:onSelectItem(nil)
    self.LeftBtnViewBgBtnsBox.gameObject:SetActiveEx(false)

    self.itemDataList = {}

    for key, value in pairs(curItemBagData) do
        local itemCfg = cfg.item[value.cfgId]
        if itemCfg and itemCfg.itemType == filterType then
            table.insert(self.itemDataList, value)
        end
    end

    if #self.itemDataList == 0 then
        local tips = {
            [PnlItemBagNew.FILTER_TYPE_NFT_ITEM] = "bag_NoNftItem",
            [PnlItemBagNew.FILTER_TYPE_DAO_ITEM] = "bag_NoArtifact",
            [PnlItemBagNew.FILTER_TYPE_PROP] = "bag_NoProp",
            [PnlItemBagNew.FILTER_TYPE_SKILL_PIECES] = "bag_NoSkillCard"
        }
        self.view.NoItem:SetActiveEx(true)
        self.view.TxtNoItem.text = Utils.getText(tips[filterType])
    else
        self.view.NoItem:SetActiveEx(false)
    end

    self.sortTable = {}
    for key, value in pairs(self.itemDataList) do
        self.sortTable[value.id] = self.sortTable[value.id] or {}
        if value.id <= 0 then
            self.sortTable[value.id].qualityWeight = -1
        else
            self.sortTable[value.id] = {}

            local itemCfg = cfg.item[value.cfgId]

            local name = string.byte(itemCfg.languageNameID)

            self.sortTable[value.id].qualityWeight = itemCfg.cfgId
        end
    end
    self:sortItems(true)
end

PnlItemBagNew.SORT_TYPE_UP = false
PnlItemBagNew.SORT_TYPE_DOWN = true

function PnlItemBagNew:sortItems(sortType)
    if sortType ~= nil then
        self.sortType = sortType
    end

    if self.sortType then
        self.view.imgSort.transform.localScale = Vector3(1, -1, 1)
    else
        self.view.imgSort.transform.localScale = Vector3(1, 1, 1)
    end

    table.sort(self.itemDataList, function(a, b)
        local weightA = self.sortTable[a.id].qualityWeight
        local weightB = self.sortTable[b.id].qualityWeight
        if weightA ~= weightB then
            if a.id < 0 or b.id < 0 then
                return b.id < 0
            end
            return (weightA < weightB) == self.sortType
        end
        return a.id < b.id
    end)

    self.itemScrollView:setDataCount(math.ceil(#self.itemDataList / 5))
end

function PnlItemBagNew:onRefreshItemBag()
    self:refreshBagCount()
end

function PnlItemBagNew:onItemSort()
    self:refreshBagCount()
    self:onBtnFilter(self.filterType, true)
end

function PnlItemBagNew:onSelectItem(itemData)
    local view = self.view
    self.selectItemData = itemData

    for key, value in pairs(self.itemList) do
        value:refreshSelect()
    end

    if not itemData then
        view.layoutInfo:SetActiveEx(false)
        return
    end

    view.layoutInfo:SetActiveEx(true)
    self.selectItemData = itemData
    self.selectItemCfg = cfg.item[itemData.cfgId]
    -- local icon = gg.getSpriteAtlasName("Long_quality_Bg_Atlas", "Long quality_Bg_1")
    -- gg.setSpriteAsync(view.imgNameQuality, icon)

    view.txtName.text = Utils.getText(self.selectItemCfg.languageNameID)
    view.txtDesc.text = Utils.getText(self.selectItemCfg.languageDescID)
    view.txtNum.text = Utils.getText("bag_Number") .. self.selectItemData.num
    view.subInfoLife.transform:SetActiveEx(false)
    for key, value in pairs(view.subInfoList) do
        value.transform:SetActiveEx(false)
    end

    local icon
    if self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
        icon = gg.getSpriteAtlasName("Item_Atlas", self.selectItemCfg.icon)
    elseif self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_PROP then
        icon = gg.getSpriteAtlasName("Item_Atlas", self.selectItemCfg.icon)
    elseif self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_NFT_ITEM then
        icon = gg.getSpriteAtlasName("Item_Atlas", self.selectItemCfg.icon)
    elseif self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES then
        icon = gg.getSpriteAtlasName("Skill_A1_Atlas", self.selectItemCfg.icon .. "_A1")
    end
    UIUtil.setQualityBg(view.iconBg, self.selectItemCfg.quality)
    gg.setSpriteAsync(view.imgIcon, icon)
    view.txtLevel.gameObject:SetActiveEx(false)

    if self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_HERO or self.selectItemCfg.itemType ==
        constant.ITEM_ITEMTYPE_WARSHIP or self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_TURRET then

        view.layoutSubInfo:SetActiveEx(true)

        view.subInfoLife.transform:SetActiveEx(true)
        view.sliderLife.value = itemData.entity.curLife / itemData.entity.life
        view.txtLife.text = string.format("<color=#ffffff>%s</color>/%s", itemData.entity.curLife, itemData.entity.life)

        view.txtLevel.gameObject:SetActiveEx(true)
        view.txtLevel.text = itemData.entity.level
    elseif self.selectItemCfg.itemType == constant.ITEM_ITEMTYPE_NFT_STAR then
        view.layoutSubInfo:SetActiveEx(true)
        -- local planetCfg = cfg.getCfg("resPlanet", itemData.targetCfgId)
        local planetCfg = ItemUtil.getTargetCfgByItemData(itemData) -- ItemUtil.getItemQualityByItemData(itemData)
        view.txtName.text = itemData.entity.planetName

        -- view.subInfoList[1].transform:SetActiveEx(true)
        -- view.subInfoList[1].txtTitle.text = "name"
        -- view.subInfoList[1].txtInfo.text = itemData.entity.planetName --planetCfg.planetName

        view.subInfoList[2].transform:SetActiveEx(true)
        view.subInfoList[2].txtTitle.text = "positon"
        view.subInfoList[2].txtInfo.text = string.format("x:%s y:%s z:%s", planetCfg.pos.x, planetCfg.pos.y,
            planetCfg.pos.z)
    else
        view.layoutSubInfo:SetActiveEx(false)
    end

    if self.selectItemCfg.canUse == 0 then
        view.btnUse:SetActiveEx(false)
    else
        view.btnUse:SetActiveEx(true)
    end
    if self.selectItemCfg.canResolve == 0 then
        view.btnResolve:SetActiveEx(false)
    else
        view.btnResolve:SetActiveEx(true)
    end
end

function PnlItemBagNew:onHide()
    self:releaseEvent()
    -- gg.event:dispatchEvent("onReturnSpineAni", 2)

end

function PnlItemBagNew:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnSelectSort):SetOnClick(function()
        self:onBtnSelectSort()
    end)
    CS.UIEventHandler.Get(view.btnAddSpace):SetOnClick(function()
        self:onBtnAddSpace()
    end)
    CS.UIEventHandler.Get(view.btnDestroy):SetOnClick(function()
        self:onBtnDestroy()
    end)
    CS.UIEventHandler.Get(view.btnUse):SetOnClick(function()
        self:onBtnUse()
    end)
    CS.UIEventHandler.Get(view.btnResolve):SetOnClick(function()
        self:onBtnResolve()
    end)

    for k, v in pairs(self.view.BtnItemTypeList) do
        CS.UIEventHandler.Get(v):SetOnClick(function()
            self:onBtnFilter(k)
        end)

    end

    self:setOnClick(view.btnOpenFilter, gg.bind(self.onBtnOpenFilter, self))
end

function PnlItemBagNew:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSelectSort)
    CS.UIEventHandler.Clear(view.btnAddSpace)
    CS.UIEventHandler.Clear(view.btnDestroy)
    CS.UIEventHandler.Clear(view.btnUse)
    CS.UIEventHandler.Clear(view.btnResolve)
    for k, v in pairs(self.view.BtnItemTypeList) do
        CS.UIEventHandler.Clear(v)
    end
end

function PnlItemBagNew:onDestroy()
    local view = self.view
    self.itemScrollView:release()
    self.LeftBtnViewBgBtnsBox:release()

    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:releaseRedPoint(value)
    end
end

function PnlItemBagNew:onBtnClose()

end

function PnlItemBagNew:onBtnSelectSort()
    self:sortItems(not self.sortType)
end

function PnlItemBagNew:onBtnAddSpace()
    local count = math.ceil(ItemData.expandSpace / cfg.global.ItemBagExpandSpace.intValue)
    local cost = math.ceil(cfg.global.ItemBagUpCost.intValue *
                               (1 + count * cfg.global.ItemBagUpCostRate.intValue / 10000))
    local callbackYes = function()
        ItemData.C2S_Player_ExpandItemBag()
    end
    local txt = string.format("Are you sure to consume %s MIT to expand %s inventory spaces?", cost,
        cfg.global.ItemBagExpandSpace.intValue)
    gg.uiManager:openWindow("PnlAlert", {
        callbackYes = callbackYes,
        btnType = PnlAlert.BTN_TYPE_SINGLE,
        txt = txt,
        title = "INCREASE CAPACITY"
    })
end

function PnlItemBagNew:onBtnDestroy()
    local txt = "Are you sure you want to delete Item?"
    local callbackYes = function()

    end

    local args = {
        txt = txt,
        callbackYes = callbackYes
    }

    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlItemBagNew:onBtnUse()
    local itemType = self.selectItemCfg.itemType
    local id = self.selectItemData.id

    if itemType == constant.ITEM_ITEMTYPE_WARSHIP then

    elseif itemType == constant.ITEM_ITEMTYPE_HERO then

    elseif itemType == constant.ITEM_ITEMTYPE_TURRET then
        if gg.sceneManager.showingScene == constant.SCENE_PLANET then
            local buildCfg = ItemUtil.getTargetCfgByItemData(self.selectItemData)
            local baseOwner = gg.buildingManager.baseOwner
            gg.buildingManager:loadBuilding(buildCfg, nil, id, baseOwner)
            self:close()
        else

        end
    elseif itemType == constant.ITEM_ITEMTYPE_NFT_STAR then
        ResPlanetData.C2S_Player_PlaceResPlanet(id)
    else
        local args = {
            data = self.selectItemData,
            type = 1
        }

        gg.uiManager:openWindow("PnlItemResolve", args)
    end
end

function PnlItemBagNew:onBtnResolve()
    local args = {
        data = self.selectItemData,
        type = 2
    }
    gg.uiManager:openWindow("PnlItemResolve", args)
end

function PnlItemBagNew:onBtnOpenFilter()
    self.LeftBtnViewBgBtnsBox.gameObject:SetActiveEx(not self.LeftBtnViewBgBtnsBox.gameObject.activeSelf)
end

---------------------------------------------------------------------------------------------------
ItemBagOptionBtns = ItemBagOptionBtns or class("ItemBagOptionBtns", ggclass.CommonBtnsBox)
function ItemBagOptionBtns:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function ItemBagOptionBtns:onGetBtnItem(item)
    item.txtBtn = item.transform:Find("TxtBtn"):GetComponent(UNITYENGINE_UI_TEXT)
    item.imgSelect = item.transform:Find("ImgSelect"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.txtSelect = item.transform:Find("ImgSelect/TxtSelect"):GetComponent(UNITYENGINE_UI_TEXT)
end

function ItemBagOptionBtns:onSetBtnData(item, data)
    if data.languageKey then
        local name = Utils.getText(data.languageKey)
        item.txtBtn.text = name
        item.txtSelect.text = name
    else
        item.txtBtn.text = data.name
        item.txtSelect.text = data.name
    end
end

function ItemBagOptionBtns:onSetBtnStageWithoutNotify(item, isSelect)
    item.txtBtn.transform:SetActiveEx(not isSelect)
    item.imgSelect.transform:SetActiveEx(isSelect)
end

return PnlItemBagNew
