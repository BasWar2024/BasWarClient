PnlGridNftBag = class("PnlGridNftBag", ggclass.UIBase)

PnlGridNftBag.BAGBELONG_UNINON = 1
PnlGridNftBag.BAGBELONG_MYPLANET = 2

PnlGridNftBag.SWICH_All = "all"

function PnlGridNftBag:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlGridNftBag:onAwake()
    self.view = ggclass.PnlGridNftBagView.new(self.pnlTransform)

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.btnSwichTypeList = {
        [1] = self.view.btnTraitB,
        [2] = self.view.btnTraitA,
        [3] = self.view.btnTraitS,
        [4] = self.view.btnTraitSsr,
        [5] = self.view.btnTraitL,
        [PnlGridNftBag.SWICH_All] = self.view.btnTraitAll
    }

    self.btnSwichRaceTypeList = {
        [constant.RACE_HUMAN] = self.view.btnRaceHumanus,
        [constant.RACE_CENTRA] = self.view.btnRaceCentra,
        [constant.RACE_SCOURGE] = self.view.btnRaceScourge,
        [constant.RACE_ENDARI] = self.view.btnRaceEndari,
        [constant.RACE_TALUS] = self.view.btnRaceTalus,
        [PnlGridNftBag.SWICH_All] = self.view.btnRaceAll
    }

end

function PnlGridNftBag:onShow()
    self:bindEvent()

    self.swichTraitType = PnlGridNftBag.SWICH_All
    self.swichRaceType = PnlGridNftBag.SWICH_All

    self:initBuildData()
end

function PnlGridNftBag:initBuildData()
    local bagBelong = self.args.bagBelong
    local curItemBagData = BuildData.buildData

    if bagBelong == PnlGridNftBag.BAGBELONG_UNINON then
        self.view.txtTitle.text = Utils.getText("league_EnterPlot_DaoNftTitle")
        self.notifyKey = "league_EnterPlot_NoDaoNft"
        curItemBagData = UnionData.unionData.items
    elseif bagBelong == PnlGridNftBag.BAGBELONG_MYPLANET then
        self.view.txtTitle.text = Utils.getText("league_EnterPlot_PersonalNftTitle")
        self.notifyKey = "league_EnterPlot_NoPersonalNft"
    end

    self.itemDataList = {}
    self.selItemList = {}

    for key, value in pairs(curItemBagData) do
        if (value.ref == 0 and value.pos.x == 0 and value.pos.z == 0) or
            (bagBelong == PnlGridNftBag.BAGBELONG_UNINON and value.refBy == 0 and value.itemType ==
                constant.ITEM_ITEMTYPE_TURRET) then
            table.insert(self.itemDataList, value)
        end
    end

    self:refreshData()
end

function PnlGridNftBag:onHide()
    self:releaseEvent()
    self:releaseItem()
end

function PnlGridNftBag:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnBuild):SetOnClick(function()
        self:onBtnBuild()
    end)
    CS.UIEventHandler.Get(view.btnSwichRace):SetOnClick(function()
        self:onBtnSwichRace()
    end)
    CS.UIEventHandler.Get(view.btnSwichTrait):SetOnClick(function()
        self:onBtnSwichTrait()
    end)
    CS.UIEventHandler.Get(view.btnRaceAll):SetOnClick(function()
        self:onBtnRaceAll()
    end)
    CS.UIEventHandler.Get(view.btnRaceHumanus):SetOnClick(function()
        self:onBtnRaceHumanus()
    end)
    CS.UIEventHandler.Get(view.btnRaceCentra):SetOnClick(function()
        self:onBtnRaceCentra()
    end)
    CS.UIEventHandler.Get(view.btnRaceScourge):SetOnClick(function()
        self:onBtnRaceScourge()
    end)
    CS.UIEventHandler.Get(view.btnRaceEndari):SetOnClick(function()
        self:onBtnRaceEndari()
    end)
    CS.UIEventHandler.Get(view.btnRaceTalus):SetOnClick(function()
        self:onBtnRaceTalus()
    end)
    CS.UIEventHandler.Get(view.btnTraitAll):SetOnClick(function()
        self:onBtnTraitAll()
    end)
    CS.UIEventHandler.Get(view.btnTraitL):SetOnClick(function()
        self:onBtnTraitL()
    end)
    CS.UIEventHandler.Get(view.btnTraitSsr):SetOnClick(function()
        self:onBtnTraitSsr()
    end)
    CS.UIEventHandler.Get(view.btnTraitS):SetOnClick(function()
        self:onBtnTraitS()
    end)
    CS.UIEventHandler.Get(view.btnTraitA):SetOnClick(function()
        self:onBtnTraitA()
    end)
    CS.UIEventHandler.Get(view.btnTraitB):SetOnClick(function()
        self:onBtnTraitB()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    for k, v in pairs(self.btnSwichTypeList) do
        local temp = k
        CS.UIEventHandler.Get(v):SetOnClick(function()
            self:onBtnTrait(temp)
        end)
    end

    for k, v in pairs(self.btnSwichRaceTypeList) do
        local temp = k
        CS.UIEventHandler.Get(v):SetOnClick(function()
            self:onBtnRace(temp)
        end)
    end

    view.btnAll.onValueChanged:AddListener(gg.bind(self.onBtnAll, self))
end

function PnlGridNftBag:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnBuild)
    CS.UIEventHandler.Clear(view.btnSwichRace)
    CS.UIEventHandler.Clear(view.btnSwichTrait)
    CS.UIEventHandler.Clear(view.btnRaceAll)
    CS.UIEventHandler.Clear(view.btnRaceHumanus)
    CS.UIEventHandler.Clear(view.btnRaceCentra)
    CS.UIEventHandler.Clear(view.btnRaceScourge)
    CS.UIEventHandler.Clear(view.btnRaceEndari)
    CS.UIEventHandler.Clear(view.btnRaceTalus)
    CS.UIEventHandler.Clear(view.btnTraitAll)
    CS.UIEventHandler.Clear(view.btnTraitL)
    CS.UIEventHandler.Clear(view.btnTraitSsr)
    CS.UIEventHandler.Clear(view.btnTraitS)
    CS.UIEventHandler.Clear(view.btnTraitA)
    CS.UIEventHandler.Clear(view.btnTraitB)
    -- CS.UIEventHandler.Clear(view.btnAll)
    CS.UIEventHandler.Clear(view.btnClose)

    for k, v in pairs(self.btnSwichRaceTypeList) do
        CS.UIEventHandler.Clear(v)
    end

    for k, v in pairs(self.btnSwichTypeList) do
        CS.UIEventHandler.Clear(v)
    end

    view.btnAll.onValueChanged:RemoveAllListeners()

end

function PnlGridNftBag:onDestroy()
    local view = self.view

    self.attrScrollView:release()
    self.attrScrollView = nil
end

function PnlGridNftBag:onBtnBuild()
    local selectList = {}
    for k, v in pairs(self.selItemList) do
        table.insert(selectList, v)
    end

    local buildCount = #selectList
    if buildCount == 1 then
        local selectItemData = selectList[1]

        local id = selectItemData.id
        if gg.sceneManager.showingScene == constant.SCENE_PLANET then
            local buildCfg = cfg.getCfg("build", selectItemData.cfgId, selectItemData.level,
                selectItemData.quality)
            local baseOwner = gg.buildingManager.baseOwner
            gg.buildingManager:loadBuilding(buildCfg, nil, id, baseOwner)
            self:close()
        end

    elseif buildCount > 1  then
        local buildList = {}
        local grid = gg.deepcopy(gg.buildingManager.otherGrid)

        local from = 1
        local bagBelong = self.args.bagBelong
        if bagBelong == PnlGridNftBag.BAGBELONG_UNINON then
            from = 2
        end

        for i, v in ipairs(selectList) do
            local buildCfg = BuildUtil.getCurBuildCfg(v.cfgId, v.level, v.quality)

            local pos = gg.buildingManager:getBuildPos(buildCfg, grid)
            table.insert(buildList, {
                id = v.id,
                pos = pos,
            })
        end

        ResPlanetData.C2S_Player_putBuildListOnGrid(self.args.planetData.cfgId, buildList, from)
        self:close()
    end
end

function PnlGridNftBag:onBtnSwichRace()
    local bool = self.view.race.activeSelf
    self.view.race:SetActiveEx(not bool)
    if not bool then
        self:onBtnSwich(self.btnSwichRaceTypeList, self.swichRaceType)
    end
end

function PnlGridNftBag:onBtnSwichTrait()
    local bool = self.view.trait.activeSelf
    self.view.trait:SetActiveEx(not bool)
    if not bool then
        self:onBtnSwich(self.btnSwichTypeList, self.swichTraitType)
    end
end

function PnlGridNftBag:onBtnSwich(list, swichType)
    for k, v in pairs(list) do
        v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
        v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x81 / 0xff, 0x82 / 0xff, 0x83 / 0xff, 1)
    end
    list[swichType].transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
    list[swichType].transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
        Color.New(0xEB / 0xff, 0xF2 / 0xff, 0xFF / 0xff, 1)
end

function PnlGridNftBag:onBtnRace(type)
    self.swichRaceType = type
    self:refreshData()
end

function PnlGridNftBag:onBtnTrait(type)
    self.swichTraitType = type
    self:refreshData()

end

function PnlGridNftBag:onBtnClose()
    self:close()
end

function PnlGridNftBag:onBtnItem(data)
    self.selItemList = self.selItemList or {}
    if self.selItemList[data.id] then
        self:setSelItem(data, false)
    else
        if self:getSelectingCount() >= self:getCanBuildCount() then
            return
        end
        self:setSelItem(data, true)
    end
    local itemNum = 0
    for k, v in pairs(self.itemGridTowerList) do
        itemNum = itemNum + 1
    end
    local selNum = self:getSelectingCount()

    local canBuildCount = self:getCanBuildCount()

    if selNum == canBuildCount then
        self.view.btnAll:SetIsOnWithoutNotify(true)
    else
        self.view.btnAll:SetIsOnWithoutNotify(false)

    end

    self:setViewInfo(data)
end

function PnlGridNftBag:onBtnAll(isOn)
    local canBuildCount = self:getCanBuildCount()

    if not isOn then
        -- gg.printData(self.selItemList, "tttttttttttttttttttttttttttwwww")

        for k, v in pairs(self.selItemList) do
            self:onBtnItem(v)
        end
    else
        local selectCount = self:getSelectingCount()

        local lessCount = canBuildCount - selectCount
        local chooseingIndex = 1
        local dataCount = #self.buildDatas
        while lessCount > 0 and chooseingIndex <= dataCount do
            local data = self.buildDatas[chooseingIndex]
            if data then
                data = data.data
                chooseingIndex = chooseingIndex + 1
                if not self.selItemList[data.id] then
                    self:onBtnItem(data)
                    lessCount = lessCount - 1
                end
            end
        end
    end
end

function PnlGridNftBag:getCanBuildCount()
    -- print("rrrrrrrrrrrrrrrrrrrr")
    -- gg.printData(self.args.planetData.builds)

    -- local planetCfg = gg.galaxyManager:getGalaxyCfg(self.args.planetData.cfgId)
    local maxCount = self:getMaxBuildCount()
    -- local buildCount = 0

    local buildNum = 0
    -- self.towerCount = cueCfg.towerCount
    for k, v in pairs(self.args.planetData.builds) do
        if v.isNormal or v.chain > 0 then
            buildNum = buildNum + 1
        end
    end
    local canBuildCount = maxCount - buildNum
    canBuildCount = math.min(canBuildCount, #self.buildDatas)

    return canBuildCount
end

function PnlGridNftBag:getMaxBuildCount()
    local planetCfg = gg.galaxyManager:getGalaxyCfg(self.args.planetData.cfgId)
    local maxCount = planetCfg.towerCount
    return maxCount
end

function PnlGridNftBag:getBuildingCount()
    local buildNum = 0
    -- self.towerCount = cueCfg.towerCount
    for k, v in pairs(self.args.planetData.builds) do
        if v.isNormal or v.chain > 0 then
            buildNum = buildNum + 1
        end
    end
    return buildNum
end

function PnlGridNftBag:getSelectingCount()
    local selectCount = 0
    self.selItemList = self.selItemList or {}
    for k, v in pairs(self.selItemList) do
        selectCount = selectCount + 1
    end
    return selectCount
end

function PnlGridNftBag:setSelItem(data, isSel)
    if isSel then
        self.selItemList[data.id] = data
    else
        self.selItemList[data.id] = nil
    end

    self:refreshBuildCount()
    self.itemGridTowerList[data.id].transform:Find("ImgSel").gameObject:SetActiveEx(isSel)
end

function PnlGridNftBag:releaseItem()
    if self.itemGridTowerList then
        for k, v in pairs(self.itemGridTowerList) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.itemGridTowerList = {}
    end
end

function PnlGridNftBag:getCfgIdUnits(cfgId)
    local num = tostring(cfgId)
    local x = #num
    local units = 10 ^ x
    return units
end

function PnlGridNftBag:refreshData()
    self.view.race:SetActiveEx(false)
    self.view.trait:SetActiveEx(false)
    -- self.view.btnAll.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
    self.view.btnAll:SetIsOnWithoutNotify(false)

    self:releaseItem()

    local buildDatas = {}
    self.buildDatas = buildDatas

    for k, v in pairs(self.itemDataList) do
        if self:chackRace(v) and self:chackTrait(v) then
            local units = self:getCfgIdUnits(v.cfgId)
            local args = {
                data = v,
                sort = v.quality * units + units - v.cfgId
            }
            table.insert(buildDatas, args)
        end
    end
    if #buildDatas > 0 then
        self:loadNftItem(buildDatas)
    else
        self.view.boxInfo:SetActiveEx(false)
    end

    self:refreshBuildCount()
end

function PnlGridNftBag:refreshBuildCount()
    local count = self:getSelectingCount() + self:getBuildingCount()
    self.view.txtNum.text = "build:" .. count .. "/" .. self:getMaxBuildCount()
end

function PnlGridNftBag:loadNftItem(buildDatas)
    QuickSort.quickSort(buildDatas, "sort", 1, #buildDatas)
    self:setViewInfo(buildDatas[1].data)

    self.itemGridTowerList = {}
    self.selItemList = {}
    for i, v in ipairs(buildDatas) do
        ResMgr:LoadGameObjectAsync("ItemGridTower", function(go)
            local data = v.data
            go.transform:SetParent(self.view.content, false)
            local quality = data.quality
            local level = data.level
            local curCfg = cfg.getCfg("build", data.cfgId, level, quality)

            local iconImg = go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
            local iconName = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
            gg.setSpriteAsync(iconImg, iconName)
            UIUtil.setQualityBg(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)

            go.transform:Find("BgLv/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("LV.%s", level)

            go.transform:Find("ImgSel").gameObject:SetActiveEx(false)

            self.itemGridTowerList[data.id] = go

            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:onBtnItem(data)
            end)

            return true
        end, true)
    end
end

function PnlGridNftBag:chackRace(data)
    local curCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)

    if self.swichRaceType == PnlGridNftBag.SWICH_All then
        return true
    elseif self.swichRaceType == curCfg.race then
        return true
    end
    return false

end

function PnlGridNftBag:chackTrait(data)
    if self.swichTraitType == PnlGridNftBag.SWICH_All then
        return true
    elseif self.swichTraitType == data.quality then
        return true
    end
    return false
end

PnlGridNftBag.QUALITY_ICON = {
    [0] = "quality_icon_1",
    [1] = "quality_icon_1",
    [2] = "quality_icon_2",
    [3] = "quality_icon_3",
    [4] = "quality_icon_4",
    [5] = "quality_icon_5"
}

PnlGridNftBag.QUAILTYBG_NAME = {
    [0] = "color_icon_A",
    [1] = "color_icon_A",
    [2] = "color_icon_B",
    [3] = "color_icon_C",
    [4] = "color_icon_D",
    [5] = "color_icon_E"
}

function PnlGridNftBag:setViewInfo(data)
    if data.id == self.selId then
        return
    end
    self.selId = data.id
    local cfgId = data.cfgId
    local level = data.level
    local quality = data.quality
    local curCfg = cfg.getCfg("build", cfgId, level, quality)

    self.view.txtName.text = Utils.getText(curCfg.languageNameID)
    self.view.txtLv.text = string.format("Lv.<color=#ffae00>%s</color>", level)
    local suffix = ""
    if data.chain == constant.NOTNFTID then
        suffix = "B"
    end
    local iconName = gg.getSpriteAtlasName("PersonalArmyIcon_Atlas", PnlGridNftBag.QUALITY_ICON[quality] .. suffix)
    gg.setSpriteAsync(self.view.iconRare, iconName, function(image, sprite)
        image.sprite = sprite
        self.view.iconRare:SetNativeSize()
    end)

    local curLife = data.curLife
    local life = data.life
    self.view.txtlDurability.text = curLife .. "/" .. life
    local fill = curLife / life
    self.view.sliderDurability.fillAmount = fill

    local iconBg = gg.getSpriteAtlasName("QualityBg_Atlas", PnlGridNftBag.QUAILTYBG_NAME[quality])
    gg.setSpriteAsync(self.view.bgInfo, iconBg)

    self:refreshAttr(data)
    self.view.boxInfo:SetActiveEx(true)
end

function PnlGridNftBag:refreshAttr(data)
    local myCfg = {}
    self.attrDataList = constant.BUILD_SHOW_ATTR
    myCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
    self.showAttrMap = BuildUtil.getBuildAttr(data.cfgId, data.level, data.quality)

    self.showCompareAttrMap = nil

    local itemCount = #self.attrDataList
    local scrollViewLenth = AttrUtil.getAttrScrollViewLenth(itemCount)

    self.attrScrollView:setItemCount(#self.attrDataList)

    -- self.attrScrollView.transform:SetRectSizeY(scrollViewLenth)
end

function PnlGridNftBag:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, self.attrDataList, self.showAttrMap, self.showCompareAttrMap, nil, nil, nil, true)
end


return PnlGridNftBag
