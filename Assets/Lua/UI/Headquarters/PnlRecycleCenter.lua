PnlRecycleCenter = class("PnlRecycleCenter", ggclass.UIBase)

PnlRecycleCenter.SWICH_All = "all"

PnlRecycleCenter.TYPE_HERO = 1
PnlRecycleCenter.TYPE_TOWER = 2
PnlRecycleCenter.TYPE_WARSHIP = 3
PnlRecycleCenter.TYPE_SKILL = 4

function PnlRecycleCenter:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onDismantleReward", "onRecycleRefreshData"}
end

function PnlRecycleCenter:onAwake()
    self.view = ggclass.PnlRecycleCenterView.new(self.pnlTransform)

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.btnSwichTypeList = {
        [1] = self.view.btnTraitB,
        [2] = self.view.btnTraitA,
        [3] = self.view.btnTraitS,
        [PnlRecycleCenter.SWICH_All] = self.view.btnTraitAll
    }

    self.btnSwichRaceTypeList = {
        [constant.RACE_HUMAN] = self.view.btnRaceHumanus,
        [constant.RACE_CENTRA] = self.view.btnRaceCentra,
        [constant.RACE_SCOURGE] = self.view.btnRaceScourge,
        [constant.RACE_ENDARI] = self.view.btnRaceEndari,
        [constant.RACE_TALUS] = self.view.btnRaceTalus,
        [PnlRecycleCenter.SWICH_All] = self.view.btnRaceAll
    }

    self.layoutLeftList = {
        [PnlRecycleCenter.TYPE_HERO] = self.view.layoutLeft:Find("BtnItemType1"),
        [PnlRecycleCenter.TYPE_TOWER] = self.view.layoutLeft:Find("BtnItemType2"),
        [PnlRecycleCenter.TYPE_WARSHIP] = self.view.layoutLeft:Find("BtnItemType3"),
        [PnlRecycleCenter.TYPE_SKILL] = self.view.layoutLeft:Find("BtnItemType4")
    }

    self.armyData = {}

    if PlayerData.armyData then
        for armyId, data in pairs(PlayerData.armyData) do
            for k, team in pairs(data.teams) do
                self.armyData[team.heroId] = team.heroId
            end
        end
    end

    self.sellingPrice = cfg.global.SellingPrice.tableValue
end

function PnlRecycleCenter:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, self.attrDataList, self.showAttrMap, self.showCompareAttrMap, nil, nil, nil, true)
end

function PnlRecycleCenter:onShow()
    self:bindEvent()

    self:refreshLeftButton(PnlRecycleCenter.TYPE_HERO)
end

function PnlRecycleCenter:refreshLeftButton(type)
    self.showType = type

    local brightIcon = {
        [PnlRecycleCenter.TYPE_HERO] = "RecycleCenter_Atlas[Hero02_icon]",
        [PnlRecycleCenter.TYPE_TOWER] = "RecycleCenter_Atlas[tower02_icon]",
        [PnlRecycleCenter.TYPE_WARSHIP] = "RecycleCenter_Atlas[ship02_icon]",
        [PnlRecycleCenter.TYPE_SKILL] = "RecycleCenter_Atlas[skill02_icon]"
    }

    local darkIcon = {
        [PnlRecycleCenter.TYPE_HERO] = "RecycleCenter_Atlas[Hero01_icon]",
        [PnlRecycleCenter.TYPE_TOWER] = "RecycleCenter_Atlas[tower01_icon]",
        [PnlRecycleCenter.TYPE_WARSHIP] = "RecycleCenter_Atlas[ship01_icon]",
        [PnlRecycleCenter.TYPE_SKILL] = "RecycleCenter_Atlas[skill01_icon]"
    }

    for k, v in pairs(self.layoutLeftList) do
        local bgColor
        local txtColor
        local iconName
        if k == type then
            bgColor = Color.New(1, 1, 1, 1)
            txtColor = Color.New(1, 1, 1, 1)
            iconName = brightIcon[k]
        else
            bgColor = Color.New(1, 1, 1, 0)
            txtColor = Color.New(0x3d / 0xff, 0x97 / 0xff, 1, 1)
            iconName = darkIcon[k]
        end
        self.layoutLeftList[k]:GetComponent(UNITYENGINE_UI_IMAGE).color = bgColor
        self.layoutLeftList[k]:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = txtColor
        gg.setSpriteAsync(self.layoutLeftList[k]:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)

    end

    self.swichTraitType = PnlRecycleCenter.SWICH_All
    self.swichRaceType = PnlRecycleCenter.SWICH_All

    self:refreshData()
end

function PnlRecycleCenter:onHide()
    self:releaseEvent()

end

function PnlRecycleCenter:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnDismantel):SetOnClick(function()
        self:onBtnDismantel()
    end)
    CS.UIEventHandler.Get(view.btnSell):SetOnClick(function()
        self:onBtnSell()
    end)
    CS.UIEventHandler.Get(view.btnSwichRace):SetOnClick(function()
        self:onBtnSwichRace()
    end)
    CS.UIEventHandler.Get(view.btnSwichTrait):SetOnClick(function()
        self:onBtnSwichTrait()
    end)
    CS.UIEventHandler.Get(view.btnAll):SetOnClick(function()
        self:onBtnAll()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnDismantelSkill):SetOnClick(function()
        self:onBtnDismantel()
    end)
    CS.UIEventHandler.Get(view.btnSellSkill):SetOnClick(function()
        self:onBtnSell()
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

    for k, v in pairs(self.layoutLeftList) do
        local temp = k
        CS.UIEventHandler.Get(v.gameObject):SetOnClick(function()
            self:onRefreshLeftButton(temp)
        end)
    end

end

function PnlRecycleCenter:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnDismantel)
    CS.UIEventHandler.Clear(view.btnSwichRace)
    CS.UIEventHandler.Clear(view.btnSwichTrait)
    CS.UIEventHandler.Clear(view.btnAll)
    CS.UIEventHandler.Clear(view.btnClose)

    for k, v in pairs(self.btnSwichRaceTypeList) do
        CS.UIEventHandler.Clear(v)
    end

    for k, v in pairs(self.btnSwichTypeList) do
        CS.UIEventHandler.Clear(v)
    end
    for k, v in pairs(self.layoutLeftList) do
        CS.UIEventHandler.Clear(v.gameObject)
    end

end

function PnlRecycleCenter:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    self.attrScrollView = nil

end

function PnlRecycleCenter:onRefreshLeftButton(type)
    self:refreshLeftButton(type)
end

function PnlRecycleCenter:onBtnDismantel()
    if self.selItemList then
        local itemIds = {}
        if self.showType == PnlRecycleCenter.TYPE_SKILL then
            for k, v in pairs(self.selItemList) do
                local data = {
                    id = k,
                    num = v
                }
                table.insert(itemIds, data)
            end
        else
            for k, v in pairs(self.selItemList) do
                table.insert(itemIds, k)
            end
        end
        if #itemIds > 0 then
            local skills = {}
            for k, v in pairs(itemIds) do
                local skillId
                local level = 1
                local num = 1
                if self.showType == PnlRecycleCenter.TYPE_HERO then
                    skillId = HeroData.heroDataMap[v].skill1
                elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
                    skillId = WarShipData.warShipData[v].skill1
                elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
                    local data = ItemData.itemBagData[v.id]
                    local itemCfg = cfg.getCfg("item", data.cfgId)
                    skillId = itemCfg.skillCfgID[1]
                    level = itemCfg.skillCfgID[2]
                    num = v.num
                end
                local skill = {
                    skillId = skillId,
                    num = num,
                    level = level
                }
                table.insert(skills, skill)
            end

            local txtTitel = Utils.getText("universal_Ask_Title")
            local txtTips = Utils.getText("recycle_Ask_DismantleOrNot")
            local txtTips1 = Utils.getText("recycle_Ask_DismantleCanGet")
            local txtTipsRed = Utils.getText("recycle_Ask_DismantleWarn")
            local txtNo = Utils.getText("universal_Ask_BackButton")
            local txtYes = Utils.getText("universal_DetermineButton")
            local yesCallback = function()
                if self.showType == PnlRecycleCenter.TYPE_HERO then
                    HeroData.C2S_Player_DismantleHero(itemIds)
                elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
                    WarShipData.C2S_Player_DismantleWarShip(itemIds)
                elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
                    ItemData.C2S_Player_DismantleSkillCard(itemIds)
                end
            end
            local args = {
                txtTitel = txtTitel,
                txtTips = txtTips,
                txtTips1 = txtTips1,
                txtTipsRed = txtTipsRed,
                txtYes = txtYes,
                callbackYes = yesCallback,
                txtNo = txtNo,
                skills = skills,
                isDismantleHero = true
            }
            gg.uiManager:openWindow("PnlAlertResetSkill", args)
        end
    end
end

function PnlRecycleCenter:onBtnSell()
    if self.selItemList and self.mySellPrice > 0 then
        local itemIds = {}
        if self.showType == PnlRecycleCenter.TYPE_SKILL then
            for k, v in pairs(self.selItemList) do
                local data = {
                    id = k,
                    num = v
                }
                table.insert(itemIds, data)
            end
        else
            for k, v in pairs(self.selItemList) do
                table.insert(itemIds, k)
            end
        end

        local txtTitel = Utils.getText("universal_Ask_Title")
        local txtTips = Utils.getText("recycle_Ask_SellOrNot")
        local txtTips1 = Utils.getText("recycle_Ask_SellCanGet")
        local txtTipsRed = Utils.getText("recycle_Ask_SellWarn")
        local txtNo = Utils.getText("universal_Ask_BackButton")
        local txtYes = Utils.getText("universal_DetermineButton")
        local yesCallback = function()
            if self.showType == PnlRecycleCenter.TYPE_SKILL then
                ItemData.C2S_Player_SellItem(itemIds)

            else
                HeroData.C2S_Player_SellEntity(itemIds, self.showType)
            end

        end
        local args = {
            txtTitel = txtTitel,
            txtTips = txtTips,
            txtTips1 = txtTips1,
            txtTipsRed = txtTipsRed,
            txtYes = txtYes,
            callbackYes = yesCallback,
            txtNo = txtNo,
            starCoin = self.mySellPrice,
            isDismantleHero = false
        }
        gg.uiManager:openWindow("PnlAlertResetSkill", args)

    end
end

function PnlRecycleCenter:onBtnSwichRace()
    local bool = self.view.race.activeSelf
    self.view.race:SetActiveEx(not bool)
    if not bool then
        self:onBtnSwich(self.btnSwichRaceTypeList, self.swichRaceType)
    end
end

function PnlRecycleCenter:onBtnSwichTrait()
    local bool = self.view.trait.activeSelf
    self.view.trait:SetActiveEx(not bool)
    if not bool then
        self:onBtnSwich(self.btnSwichTypeList, self.swichTraitType)
    end
end

function PnlRecycleCenter:onBtnSwich(list, swichType)
    for k, v in pairs(list) do
        v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
        v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x81 / 0xff, 0x82 / 0xff, 0x83 / 0xff, 1)
    end
    list[swichType].transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
    list[swichType].transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
        Color.New(0xEB / 0xff, 0xF2 / 0xff, 0xFF / 0xff, 1)
end

function PnlRecycleCenter:onBtnRace(type)
    self.swichRaceType = type
    self:refreshData()
end

function PnlRecycleCenter:onBtnTrait(type)
    self.swichTraitType = type
    self:refreshData()

end

function PnlRecycleCenter:onBtnAll()
    local toggle = self.view.btnAll.transform:GetComponent(UNITYENGINE_UI_TOGGLE)
    for k, v in pairs(self.itemList) do
        local data
        if self.showType == PnlRecycleCenter.TYPE_HERO then
            data = HeroData.heroDataMap[k]
        elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
            data = BuildData.buildData[k]
        elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
            data = WarShipData.warShipData[k]
        elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
            data = ItemData.itemBagData[k]
        end

        self:setSelItem(data, toggle.isOn, true)
    end
    if not toggle.isOn then
        self.selItemList = {}
        self.mySellPrice = 0
        self.view.txtParice.text = "X0"

    end
end

function PnlRecycleCenter:onBtnClose()
    self:close()
end

function PnlRecycleCenter:onRecycleRefreshData()
    self:refreshData()
end

function PnlRecycleCenter:refreshData()
    self.view.race:SetActiveEx(false)
    self.view.trait:SetActiveEx(false)
    self.view.btnAll.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
    self:releaseItemHeroDel()

    local newDatas = {}
    if self.showType == PnlRecycleCenter.TYPE_HERO then
        for k, v in pairs(HeroData.heroDataMap) do
            if self:isAbleDismantle(v) and self:chackRace(v) and self:chackTrait(v) then
                local args = {
                    data = v,
                    sort = v.quality * 10000000 + 10000000 - v.cfgId
                }
                table.insert(newDatas, args)
            end
        end
    elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
        for k, v in pairs(BuildData.buildData) do
            if v.pos.x == 0 and v.pos.z == 0 and v.chain == constant.NOTNFTID and v.ref == 0 then
                if self:chackRace(v) and self:chackTrait(v) then
                    local args = {
                        data = v,
                        sort = v.quality * 10000000 + 10000000 - v.cfgId
                    }
                    table.insert(newDatas, args)
                end
            end
        end
    elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
        for k, v in pairs(WarShipData.warShipData) do
            if self:isAbleDismantle(v) and self:chackRace(v) and self:chackTrait(v) and v.id ~= WarShipData.useData.id then
                local args = {
                    data = v,
                    sort = v.quality * 10000000 + 10000000 - v.cfgId
                }
                table.insert(newDatas, args)
            end
        end
    elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
        for k, v in pairs(ItemData.itemBagData) do
            local itemCfg = cfg.getCfg("item", v.cfgId)
            if itemCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES and itemCfg.skillCfgID then
                if self:chackRace(v) and self:chackTrait(v) then
                    local args = {
                        data = v,
                        sort = itemCfg.quality * 10000000 + 10000000 - v.cfgId
                    }
                    table.insert(newDatas, args)
                end
            end
        end
    end

    if #newDatas > 0 then
        QuickSort.quickSort(newDatas, "sort", 1, #newDatas)
        self:setViewInfo(newDatas[1].data)
        self.itemList = {}
        self.selItemList = {}
        self.mySellPrice = 0
        self.view.txtParice.text = "X0"

        for i, v in ipairs(newDatas) do
            ResMgr:LoadGameObjectAsync("ItemRecycle", function(go)
                local data = v.data
                go.transform:SetParent(self.view.content, false)
                local quality = data.quality
                local level = data.level

                local iconImg = go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

                local curCfg
                local iconName

                if self.showType == PnlRecycleCenter.TYPE_HERO then
                    curCfg = cfg.getCfg("hero", data.cfgId, level, quality)
                    iconName = gg.getSpriteAtlasName("Hero_A_Atlas", curCfg.icon .. "_A")
                    go.transform:Find("BgNum").gameObject:SetActiveEx(false)

                elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
                    curCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
                    iconName = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
                    go.transform:Find("BgNum").gameObject:SetActiveEx(false)

                elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
                    curCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
                    iconName = gg.getSpriteAtlasName("Warship_A_Atlas", curCfg.icon .. "_A")
                    go.transform:Find("BgNum").gameObject:SetActiveEx(false)

                elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
                    curCfg = cfg.getCfg("item", data.cfgId)
                    iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", curCfg.icon .. "_A1")
                    local skillCfg = cfg.getCfg("skill", curCfg.skillCfgID[1], curCfg.skillCfgID[2])
                    quality = skillCfg.quality
                    level = skillCfg.level
                    go.transform:Find("BgNum").gameObject:SetActiveEx(true)
                    go.transform:Find("BgNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = data.num
                end

                gg.setSpriteAsync(iconImg, iconName)
                UIUtil.setQualityBg(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)

                go.transform:Find("BgLv/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("LV.%s", level)

                go.transform:Find("ImgSel").gameObject:SetActiveEx(false)

                self.itemList[data.id] = go

                CS.UIEventHandler.Get(go):SetOnClick(function()
                    self:onBtnItemSel(data)
                end)
                CS.UIEventHandler.Get(go.transform:Find("ImgSel/BtnDel").gameObject):SetOnClick(function()
                    self:onBtnDelItemSel(data)
                end)

                return true
            end, true)
        end
    else
        self.view.boxInfo:SetActiveEx(false)
    end

end

function PnlRecycleCenter:releaseItemHeroDel()
    if self.itemList then
        for k, v in pairs(self.itemList) do
            CS.UIEventHandler.Clear(v)
            CS.UIEventHandler.Clear(v.transform:Find("ImgSel/BtnDel").gameObject)
            ResMgr:ReleaseAsset(v)
        end
        self.itemList = {}
    end
end

function PnlRecycleCenter:onBtnDelItemSel(data)
    if self.showType == PnlRecycleCenter.TYPE_SKILL then
        local id = data.id
        self.selItemList[id] = self.selItemList[id] - 1
        local itemCfg = cfg.getCfg("item", data.cfgId)
        self.mySellPrice = self.mySellPrice - self.sellingPrice[itemCfg.quality]
        if self.mySellPrice < 0 then
            self.mySellPrice = 0
        end
        self.view.txtParice.text = "X" .. Utils.scientificNotation(self.mySellPrice / 1000)
        if self.selItemList[id] <= 0 then
            self.selItemList[id] = nil
            self.itemList[id].transform:Find("ImgSel").gameObject:SetActiveEx(false)
            self.itemList[id].transform:Find("BgNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = data.num
        else
            self.itemList[id].transform:Find("ImgSel").gameObject:SetActiveEx(true)
            if self.selItemList[id] <= data.num then
                self.itemList[id].transform:Find("BgNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format(
                    "%s(<color=#ffb600>-%s</color>)", data.num - self.selItemList[id], self.selItemList[id])
            end
        end
    end
end

function PnlRecycleCenter:onBtnItemSel(data)
    if self.selItemList[data.id] then
        self:setSelItem(data, false)
    else
        self:setSelItem(data, true)
    end
    local itemNum = 0
    for k, v in pairs(self.itemList) do
        itemNum = itemNum + 1
    end
    local selNum = 0
    for k, v in pairs(self.selItemList) do
        selNum = selNum + 1
    end
    if selNum > 0 and selNum == itemNum then
        self.view.btnAll.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = true
    else
        self.view.btnAll.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
    end
    self:setViewInfo(data)
end

function PnlRecycleCenter:setSelItem(data, isSel, isAllClear)
    local id = data.id
    if isSel then
        if self.showType == PnlRecycleCenter.TYPE_SKILL then
            if isAllClear then
                self.selItemList[id] = data.num
            else
                self.selItemList[id] = 1
            end
            local itemCfg = cfg.getCfg("item", data.cfgId)
            self.mySellPrice = self.mySellPrice + self.sellingPrice[itemCfg.quality]
        else
            self.selItemList[id] = id
            self.mySellPrice = self.mySellPrice + self.sellingPrice[data.quality]
        end
    else
        if self.showType == PnlRecycleCenter.TYPE_SKILL then
            local itemCfg = cfg.getCfg("item", data.cfgId)
            if self.selItemList[id] < data.num then
                self.selItemList[id] = self.selItemList[id] + 1
                self.mySellPrice = self.mySellPrice + self.sellingPrice[itemCfg.quality]

            end
        else
            self.selItemList[id] = nil
            self.mySellPrice = self.mySellPrice - self.sellingPrice[data.quality]
        end
    end
    if self.mySellPrice < 0 then
        self.mySellPrice = 0
    end

    self.view.txtParice.text = "X" .. Utils.scientificNotation(self.mySellPrice / 1000)

    if self.showType == PnlRecycleCenter.TYPE_SKILL then
        if self.selItemList[id] <= 0 or (isAllClear and not isSel) then
            self.selItemList[id] = nil
            self.itemList[id].transform:Find("ImgSel").gameObject:SetActiveEx(false)
            self.itemList[id].transform:Find("BgNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = data.num
        else
            self.itemList[id].transform:Find("ImgSel").gameObject:SetActiveEx(true)
            self.itemList[id].transform:Find("BgNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format(
                "%s(<color=#ffb600>-%s</color>)", data.num - self.selItemList[id], self.selItemList[id])
        end
    else
        self.itemList[id].transform:Find("ImgSel").gameObject:SetActiveEx(isSel)
    end

end

function PnlRecycleCenter:isAbleDismantle(data)
    if data.chain == 0 and data.skill2 == 0 and data.skill3 == 0 and data.skillLevel1 == 1 and data.lessTick == 0 and
        not self.armyData[data.id] then
        return true
    end
    return false
end

function PnlRecycleCenter:chackRace(data)
    local curCfg
    if self.showType == PnlRecycleCenter.TYPE_HERO then
        curCfg = cfg.getCfg("hero", data.cfgId, data.level, data.quality)
    elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
        curCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
    elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
        curCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
    elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
        local itemCfg = cfg.getCfg("item", data.cfgId)
        curCfg = cfg.getCfg("skill", itemCfg.skillCfgID[1], itemCfg.skillCfgID[2])

    end

    if self.swichRaceType == PnlRecycleCenter.SWICH_All then
        return true
    elseif self.swichRaceType == curCfg.race then
        return true
    end
    return false
end

function PnlRecycleCenter:chackTrait(data)
    local quality = data.quality
    if not quality then
        local itemCfg = cfg.getCfg("item", data.cfgId)
        local skillCfg = cfg.getCfg("skill", itemCfg.skillCfgID[1], itemCfg.skillCfgID[2])
        quality = skillCfg.quality
    end
    if self.swichTraitType == PnlRecycleCenter.SWICH_All then
        return true
    elseif self.swichTraitType == quality then
        return true
    end
    return false
end

PnlRecycleCenter.QUALITY_ICON = {
    [0] = "quality_icon_1B",
    [1] = "quality_icon_1B",
    [2] = "quality_icon_2B",
    [3] = "quality_icon_3B"
}

PnlRecycleCenter.QUAILTYBG_NAME = {
    [0] = "color_icon_A",
    [1] = "color_icon_A",
    [2] = "color_icon_B",
    [3] = "color_icon_C",
    [4] = "color_icon_D",
    [5] = "color_icon_E"
}

function PnlRecycleCenter:setViewInfo(data)
    if self.showType ~= PnlRecycleCenter.TYPE_SKILL then
        self.view.boxInfo:SetActiveEx(true)
        self.view.layoutInfo:SetActiveEx(false)
    else
        self.view.boxInfo:SetActiveEx(false)
        self.view.layoutInfo:SetActiveEx(true)
    end

    local cfgId = data.cfgId
    local level = data.level
    local quality = data.quality
    local curCfg
    if self.showType == PnlRecycleCenter.TYPE_HERO then
        curCfg = cfg.getCfg("hero", cfgId, level, quality)
        self.view.btnDismantel:SetActiveEx(true)
    elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
        curCfg = cfg.getCfg("build", cfgId, level, quality)
        self.view.btnDismantel:SetActiveEx(false)
    elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
        curCfg = cfg.getCfg("warShip", cfgId, level, quality)
        self.view.btnDismantel:SetActiveEx(true)
    elseif self.showType == PnlRecycleCenter.TYPE_SKILL then
        curCfg = cfg.getCfg("item", cfgId)
        quality = curCfg.quality
    end

    if data.id == self.selId then
        return
    end
    self.selId = data.id

    if self.showType ~= PnlRecycleCenter.TYPE_SKILL then
        self.view.txtName.text = Utils.getText(curCfg.languageNameID)
        self.view.txtLv.text = string.format("Lv.<color=#ffae00>%s</color>", level)

        local iconName = gg.getSpriteAtlasName("PersonalArmyIcon_Atlas", PnlRecycleCenter.QUALITY_ICON[quality])
        gg.setSpriteAsync(self.view.iconRare, iconName, function(image, sprite)
            image.sprite = sprite
            self.view.iconRare:SetNativeSize()
        end)

        local curLife = data.curLife
        local life = data.life
        self.view.txtlDurability.text = curLife .. "/" .. life
        local fill = curLife / life
        self.view.sliderDurability.fillAmount = fill

        local iconBg = gg.getSpriteAtlasName("QualityBg_Atlas", PnlRecycleCenter.QUAILTYBG_NAME[quality])
        gg.setSpriteAsync(self.view.bgInfo, iconBg)

        if self.showType == PnlRecycleCenter.TYPE_HERO then
            self:refreshAttr(data)
            self:refreshSkill(data)

        elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
            self:refreshAttr(data)
            self.view.boxSkill:SetActiveEx(false)
        elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
            self:refreshAttr(data)
            self:refreshSkill(data)

        end
    else
        self.view.txtSkillName.text = Utils.getText(curCfg.languageNameID)
        self.view.txtNum.text = Utils.getText("bag_Number") .. data.num
        self.view.txtDesc.text = Utils.getText(curCfg.languageDescID)
        local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", curCfg.icon .. "_A1")
        gg.setSpriteAsync(self.view.imgIcon, iconName)
        UIUtil.setQualityBg(self.view.iconSkillBg, quality)
    end

end

function PnlRecycleCenter:refreshAttr(data)
    local myCfg = {}

    if self.showType == PnlRecycleCenter.TYPE_HERO then
        self.attrDataList = constant.HERO_SHOW_ATTR
        myCfg = cfg.getCfg("hero", data.cfgId, data.level, data.quality)
        self.showAttrMap = HeroUtil.getHeroAttr(data.cfgId, data.level, data.quality)
    elseif self.showType == PnlRecycleCenter.TYPE_TOWER then
        self.attrDataList = constant.BUILD_SHOW_ATTR
        myCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
        self.showAttrMap = BuildUtil.getBuildAttr(data.cfgId, data.level, data.quality)
    elseif self.showType == PnlRecycleCenter.TYPE_WARSHIP then
        self.attrDataList = constant.WARSHIP_SHOW_ATTR
        myCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
        self.showAttrMap = WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level, 0, data.curLife)
    end

    self.showCompareAttrMap = nil

    local itemCount = #self.attrDataList
    local scrollViewLenth = AttrUtil.getAttrScrollViewLenth(itemCount)

    self.attrScrollView:setItemCount(#self.attrDataList)

    -- self.attrScrollView.transform:SetRectSizeY(scrollViewLenth)
end

function PnlRecycleCenter:refreshSkill(data)
    local setSkillData = function(skillId, skillLv, go)
        go.gameObject:SetActiveEx(true)
        local iconName = ""
        local quality = 0
        local curSkillCfg = cfg.getCfg("skill", skillId, skillLv)
        quality = curSkillCfg.quality
        iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", curSkillCfg.icon .. "_A1")

        local iconBg = go:Find("IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
        UIUtil.setQualityBg(iconBg, quality)

        local icon = go:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

        gg.setSpriteAsync(icon, iconName)
    end

    local skillName = "skill1"
    local skillLv = "skillLevel1"
    setSkillData(data[skillName], data[skillLv], self.view.itemHeadquartersSkill)
    self.view.boxSkill:SetActiveEx(true)

end

function PnlRecycleCenter:onDismantleReward(args, items)
    local txtTitel = Utils.getText("universal_Ask_Title")
    local txtTips = Utils.getText("headquarters_Ask_DismantleCanGet")
    local txtYes = Utils.getText("universal_DetermineButton")
    local callbackYes = function()
        -- gg.uiManager:closeWindow("PnlRecycleCenter")
    end
    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtYes = txtYes,
        isGetSkill = true,
        items = items,
        callbackYes = callbackYes
    }
    gg.uiManager:openWindow("PnlAlertResetSkill", args)
    self:refreshData()
end

return PnlRecycleCenter
