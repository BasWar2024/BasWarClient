PnlGridItemBag = class("PnlGridItemBag", ggclass.UIBase)

PnlGridItemBag.BAGBELONG_UNINON = 1
PnlGridItemBag.BAGBELONG_MYPLANET = 2
PnlGridItemBag.BAGBELONG_UNINONBUILD = 3
PnlGridItemBag.BAGBELONG_MYBUILD = 4

function PnlGridItemBag:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onRefreshItemBag", "onItemSort"}

end

function PnlGridItemBag:onAwake()
    self.view = ggclass.PnlGridItemBagView.new(self.pnlTransform)

end

function PnlGridItemBag:onShow()
    gg.event:dispatchEvent("onShowPlanetInformation", false)
    self:bindEvent()
    self.costList = {}
    self:initBuildData()
end

function PnlGridItemBag:onHide()
    self:releaseEvent()
    gg.event:dispatchEvent("onShowPlanetInformation", true)

end

function PnlGridItemBag:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnUse):SetOnClick(function()
        self:onBtnUse()
    end)
    CS.UIEventHandler.Get(view.btnQuality):SetOnClick(function()
        self:onBtnQuality()
    end)
end

function PnlGridItemBag:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnUse)
    CS.UIEventHandler.Clear(view.btnQuality)

    self:releaseNftItem()
    self:releaseTxtCost()
end

function PnlGridItemBag:onDestroy()
    local view = self.view

end

function PnlGridItemBag:onBtnClose()
    self:close()
end

function PnlGridItemBag:onBtnUse()
    if self.selectItemData then
        local id = self.selectItemData.id
        if gg.sceneManager.showingScene == constant.SCENE_PLANET then
            local buildCfg = cfg.getCfg("build", self.selectItemData.cfgId, self.selectItemData.level,
                self.selectItemData.quality)
            local baseOwner = gg.buildingManager.baseOwner
            gg.buildingManager:loadBuilding(buildCfg, nil, id, baseOwner)
            self:close()
        end
    end

end

function PnlGridItemBag:onBtnQuality()
end

PnlGridItemBag.Belong2NoItemDesc = {
    -- [PnlGridItemBag.BAGBELONG_UNINON] = ""

}

function PnlGridItemBag:initBuildData()
    local bagBelong = self.args.bagBelong
    local curItemBagData = BuildData.buildData

    if bagBelong == PnlGridItemBag.BAGBELONG_UNINON then
        self.view.txtTitle.text = Utils.getText("league_EnterPlot_DaoNftTitle")
        self.notifyKey = "league_EnterPlot_NoDaoNft"
        curItemBagData = UnionData.unionData.items
    elseif bagBelong == PnlGridItemBag.BAGBELONG_MYPLANET then
        self.view.txtTitle.text = Utils.getText("league_EnterPlot_PersonalNftTitle")
        self.notifyKey = "league_EnterPlot_NoPersonalNft"
    elseif bagBelong == PnlGridItemBag.BAGBELONG_MYBUILD or bagBelong == PnlGridItemBag.BAGBELONG_UNINONBUILD then
        self.view.txtTitle.text = Utils.getText("league_EnterPlot_DaoDefenTitle")
        self.notifyKey = "league_EnterPlot_NoDaoDefen"
        curItemBagData = UnionData.unionData.builds
    end

    self.itemDataList = {}
    if bagBelong == PnlGridItemBag.BAGBELONG_UNINON or bagBelong == PnlGridItemBag.BAGBELONG_MYPLANET then
        for key, value in pairs(curItemBagData) do
            if (value.ref == 0 and value.pos.x == 0 and value.pos.z == 0) or
                (bagBelong == PnlGridItemBag.BAGBELONG_UNINON and value.refBy == 0 and value.itemType ==
                    constant.ITEM_ITEMTYPE_TURRET) then
                local units = self:getCfgIdUnits(value.cfgId)
                value.sort = value.quality * units + (units - value.cfgId)
                table.insert(self.itemDataList, value)
            end
        end
    else
        for key, value in pairs(curItemBagData) do
            if value.level > 0 and Utils.checkUnionsloiderDefenseWhiteList(2, value.cfgId) then
                value.quality = 0
                local units = self:getCfgIdUnits(value.cfgId)
                value.sort = value.quality * units + (units - value.cfgId)
                table.insert(self.itemDataList, value)
            end
        end
    end

    QuickSort.quickSort(self.itemDataList, "sort", 1, #self.itemDataList)

    self:loadNftItem()
end

function PnlGridItemBag:getCfgIdUnits(cfgId)
    local num = tostring(cfgId)
    local x = #num
    local units = 10 ^ x
    return units
end

function PnlGridItemBag:loadNftItem()
    self:resetBoxInfo()
    self:releaseNftItem()
    self.nftItemList = {}
    for i, v in ipairs(self.itemDataList) do
        ResMgr:LoadGameObjectAsync("NftItem", function(go)
            local cfgId = v.cfgId
            local level = v.level
            local quality = v.quality
            local tempCfg = cfg.getCfg("build", cfgId, level, quality)
            go.transform:SetParent(self.view.content, false)
            go.transform:Find("LayoutSelect").gameObject:SetActiveEx(false)
            UIUtil.setQualityBg(go.transform:Find("CommonBagItem/ImgBg"):GetComponent(UNITYENGINE_UI_IMAGE), quality)

            local buildIcon = go.transform:Find("CommonBagItem/Mask/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
            local iconName = gg.getSpriteAtlasName("Build_A_Atlas", tempCfg.icon .. "_A")
            gg.setSpriteAsync(buildIcon, iconName)
            go.transform:Find("CommonBagItem/Mask/Image/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = level

            local raceIcon = go.transform:Find("CommonBagItem/ImgRace"):GetComponent(UNITYENGINE_UI_IMAGE)
            if self.args.bagBelong == PnlGridItemBag.BAGBELONG_UNINON or self.args.bagBelong ==
                PnlGridItemBag.BAGBELONG_MYPLANET then
                local raceIconName = string.format("Skill_A1_Atlas[%s]", constant.RACE_MESSAGE[tempCfg.race].iconSmall)
                gg.setSpriteAsync(raceIcon, raceIconName)
            else
                raceIcon.gameObject:SetActiveEx(false)
            end

            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:onBtnNftItem(i)
            end)

            self.nftItemList[i] = go
            return true
        end, true)
    end

    self.view.txtNoNft.transform:SetActiveEx(#self.itemDataList <= 0)
    self.view.txtNoNft.text = Utils.getText(self.notifyKey)
end

function PnlGridItemBag:onBtnNftItem(index)
    for i, go in ipairs(self.nftItemList) do
        if i == index then
            go.transform:Find("LayoutSelect").gameObject:SetActiveEx(true)
        else
            go.transform:Find("LayoutSelect").gameObject:SetActiveEx(false)
        end
    end
    self.selectItemData = self.itemDataList[index]
    local view = self.view
    local data = self.itemDataList[index]
    local cfgId = data.cfgId
    local level = data.level
    local quality = data.quality
    local tempCfg = cfg.getCfg("build", cfgId, level, quality)

    UIUtil.setQualityBg(view.imgBg, quality)
    local iconName = gg.getSpriteAtlasName("Build_A_Atlas", tempCfg.icon .. "_A")
    gg.setSpriteAsync(view.imgBuild, iconName)
    view.txtBuildName.text = Utils.getText(tempCfg.languageNameID)
    view.txtBuildLv.text = level

    view.txtAttr1.text = tempCfg.maxHp
    view.txtAttr2.text = Utils.scientificNotationInt(tempCfg.atk / tempCfg.atkSpeed)
    view.txtAttr3.text = Utils.scientificNotation(tempCfg.atkRange / 1000)

    if self.args.bagBelong == PnlGridItemBag.BAGBELONG_UNINON or self.args.bagBelong ==
        PnlGridItemBag.BAGBELONG_MYPLANET then
        local raceIconName = string.format("Skill_A1_Atlas[%s]", constant.RACE_MESSAGE[tempCfg.race].iconSmall)
        gg.setSpriteAsync(view.imgRace, raceIconName)

        view.boxCost:SetActiveEx(false)
    else
        view.imgRace.gameObject:SetActiveEx(false)
        view.boxCost:SetActiveEx(true)
        self:setCost(tempCfg)
    end

    self.view.boxInfo:SetActiveEx(true)
end

function PnlGridItemBag:setCost(tempCfg)
    local setData = function(go, data)
        go.transform:GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(data[2] / 1000)
        local img = go.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
        local iconName = constant.RES_2_CFG_KEY[data[1]].icon
        gg.setSpriteAsync(img, iconName)
    end

    for k, v in pairs(tempCfg.gridBuildCostRes) do
        if self.costList[k] then
            setData(self.costList[k], v)
        else
            ResMgr:LoadGameObjectAsync("TxtCost", function(go)
                go.transform:SetParent(self.view.boxCost.transform, false)

                setData(go, v)
                self.costList[k] = go
                return true
            end, true)
        end
    end
end

function PnlGridItemBag:releaseTxtCost()
    if self.costList then
        for k, v in pairs(self.costList) do
            ResMgr:ReleaseAsset(v)
        end
        self.costList = {}
    end
end

function PnlGridItemBag:releaseNftItem()
    if self.nftItemList then
        for k, v in pairs(self.nftItemList) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.nftItemList = nil
    end
end

PnlGridItemBag.QUAILTYBG_NAME = {
    [0] = "color_icon_A",
    [1] = "color_icon_A",
    [2] = "color_icon_B",
    [3] = "color_icon_C",
    [4] = "color_icon_D",
    [5] = "color_icon_E"
}

function PnlGridItemBag:resetBoxInfo()
    self.view.boxInfo:SetActiveEx(false)

    local iconBg = gg.getSpriteAtlasName("QualityBg_Atlas", PnlChooseSkill.QUAILTYBG_NAME[2])
    gg.setSpriteAsync(self.view.bgInfo, iconBg)
    self.selectItemData = nil
end

return PnlGridItemBag
