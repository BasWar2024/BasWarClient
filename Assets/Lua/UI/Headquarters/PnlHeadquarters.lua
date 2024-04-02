PnlHeadquarters = class("PnlHeadquarters", ggclass.UIBase)

PnlHeadquarters.SWICH_SHIP = 1
PnlHeadquarters.SWICH_HERO = 2
PnlHeadquarters.SWICH_TOWER = 3

PnlHeadquarters.SWICH_All = "all"

function PnlHeadquarters:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSetViewInfo", "onSetSelWarship", "onPersonalArmyChange", "onRedPointChange",
                   "onHeroDel", "onAskToJumpGalaxyGrid"}

    self.swichType = PnlHeadquarters.SWICH_HERO
    self.swichTraitType = PnlHeadquarters.SWICH_All
    self.swichRaceType = PnlHeadquarters.SWICH_All

    self.itemHeadquartersNftList = {}
    self.GVGTowerCfgid = 0
end

function PnlHeadquarters:onAwake()
    self.view = ggclass.PnlHeadquartersView.new(self.pnlTransform)

    local view = self.view

    self.btnSwichTypeList = {
        [1] = self.view.btnTraitN,
        [2] = self.view.btnTraitR,
        [3] = self.view.btnTraitSr,
        [4] = self.view.btnTraitSsr,
        [5] = self.view.btnTraitL,
        [PnlHeadquarters.SWICH_All] = self.view.btnTraitAll
    }

    self.btnSwichRaceTypeList = {
        [constant.RACE_HUMAN] = self.view.btnRaceHumanus,
        [constant.RACE_CENTRA] = self.view.btnRaceCentra,
        [constant.RACE_SCOURGE] = self.view.btnRaceScourge,
        [constant.RACE_ENDARI] = self.view.btnRaceEndari,
        [constant.RACE_TALUS] = self.view.btnRaceTalus,
        [PnlHeadquarters.SWICH_All] = self.view.btnRaceAll
    }

    self.showingButtonTypeList = {
        [PnlHeadquarters.SWICH_SHIP] = self.view.btnShip,
        [PnlHeadquarters.SWICH_HERO] = self.view.btnHero,
        [PnlHeadquarters.SWICH_TOWER] = self.view.btnTower
    }

    self.redPointBtnMap = {
        [RedPointHeadquartersSwitch.__name] = view.btnSwich,
        [RedPointHeadquartersWarship.__name] = view.btnShip,
        [RedPointHeadquartersHero.__name] = view.btnHero,
        [RedPointHeadquartersNewBuild.__name] = view.btnTower
    }

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

end

function PnlHeadquarters:onShow()
    self:bindEvent()
    self:startLoopTimer()
    self.view.bgSwich:SetActiveEx(false)
    self.view.boxInfo:SetActiveEx(false)

    if PlayerData.armyData then
        self:setBoxNftScrollView(self.swichType)
    else
        PlayerData.C2S_Player_ArmyFormationQuery()
    end

    self:initRedPoint()
end

function PnlHeadquarters:onRedPointChange(_, name, isRed)
    if self.redPointBtnMap[name] then
        RedPointManager:setRedPoint(self.redPointBtnMap[name], isRed)
    end
end

function PnlHeadquarters:initRedPoint()
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function PnlHeadquarters:onHide()
    self:stopLoopTimer()
    self:releaseEvent()
    self:releaseItemHeadquartersNft()
    self:releaseLastSprite()
    self.GVGTowerCfgid = 0
end

function PnlHeadquarters:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnSwich):SetOnClick(function()
        self:onBtnSwich()
    end)
    CS.UIEventHandler.Get(view.btnShip):SetOnClick(function()
        self:onBtnShip()
    end)
    CS.UIEventHandler.Get(view.btnHero):SetOnClick(function()
        self:onBtnHero()
    end)
    CS.UIEventHandler.Get(view.btnTower):SetOnClick(function()
        self:onBtnTower()
    end)
    CS.UIEventHandler.Get(view.btnUpgrade):SetOnClick(function()
        self:onBtnUpgrade()
    end)
    CS.UIEventHandler.Get(view.btnWrench):SetOnClick(function()
        self:onBtnWrench()
    end)
    CS.UIEventHandler.Get(view.btnSet):SetOnClick(function()
        self:onBtnSet()
    end)
    CS.UIEventHandler.Get(view.btnDismantle):SetOnClick(function()
        self:onBtnDismantle()
    end)

    CS.UIEventHandler.Get(view.txtLocation.gameObject):SetOnClick(function()
        if self.GVGTowerCfgid ~= 0 then
            gg.event:dispatchEvent("onAskToJumpGalaxyGrid", self.GVGTowerCfgid, function()
                self:close()
            end)
        end
    end)

    CS.UIEventHandler.Get(view.btnRecycle):SetOnClick(function()
        local callbackYes = function()
            local data = self.swichData[self.selId]
            if data.ref == 5 and data.refBy > 0 then
                GalaxyData.C2S_Player_storeBuildOnGrid(data.refBy, data.id)
            elseif data.ref == 4 then
                local idList = {}
                idList[1] = data.id
                UnionData.C2S_Player_UnionTakeBackNft(UnionData.unionData.unionId, idList)
            end
        end

        local args = {
            txtTitel = Utils.getText("universal_Ask_Title"),
            txtTips = string.format(Utils.getText("headquarters_DFReclaim"), cost),
            txtYes = Utils.getText("universal_DetermineButton"),
            callbackYes = callbackYes,
            txtNo = Utils.getText("universal_Ask_BackButton")
        }
        
        gg.uiManager:openWindow("PnlAlertNew", args)
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

    for k, v in pairs(self.view.itemSkillList) do
        local temp = k
        CS.UIEventHandler.Get(v.gameObject):SetOnClick(function()
            self:onBtnSkill(temp)
        end)
    end

    self:setOnClick(view.btnFixAll, gg.bind(self.onBtnFixAll, self))
    self:setOnClick(view.btnRefreshInfo, gg.bind(self.onBtnRefreshInfo, self))
end

function PnlHeadquarters:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSwich)
    CS.UIEventHandler.Clear(view.btnShip)
    CS.UIEventHandler.Clear(view.btnHero)
    CS.UIEventHandler.Clear(view.btnTower)
    CS.UIEventHandler.Clear(view.btnUpgrade)
    CS.UIEventHandler.Clear(view.btnWrench)
    CS.UIEventHandler.Clear(view.btnSet)
    CS.UIEventHandler.Clear(view.btnDismantle)
    CS.UIEventHandler.Clear(view.txtLocation.gameObject)
    CS.UIEventHandler.Clear(view.btnRecycle)

    for k, v in pairs(self.btnSwichRaceTypeList) do
        CS.UIEventHandler.Clear(v)
    end

    for k, v in pairs(self.btnSwichTypeList) do
        CS.UIEventHandler.Clear(v)
    end

    for k, v in pairs(self.view.itemSkillList) do
        CS.UIEventHandler.Clear(v.gameObject)
    end

end

function PnlHeadquarters:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    self.attrScrollView = nil
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:releaseRedPoint(value)
    end
end

function PnlHeadquarters:onBtnSkill(index)
    local data = self.swichData[self.selId]
    local skillIndex = index

    local skillName = "skill" .. skillIndex
    local skillLevel = "skillLevel" .. skillIndex

    if data[skillName] == 0 then
        local type = PnlChooseSkill.TYPE_HERO
        if self.swichType == PnlHeadquarters.SWICH_SHIP then
            type = PnlChooseSkill.TYPE_WARSHIP
        end
        local args = {
            roleId = self.selId,
            skillIndex = skillIndex,
            type = type
        }

        gg.uiManager:openWindow("PnlChooseSkill", args)

    else
        local type = 1
        if self.swichType == PnlHeadquarters.SWICH_SHIP then
            type = 2
        end

        local args = {
            skillCfgId = data[skillName],
            skillLevel = data[skillLevel],
            skillIndex = skillIndex,
            upgradeTick = data.skillUpLessTickEnd,
            roleId = self.selId,
            type = type
        }

        gg.uiManager:openWindow("PnlHeadquartersSkillUpgrade", args)
    end

end

function PnlHeadquarters:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, self.attrDataList, self.showAttrMap, self.showCompareAttrMap, nil, nil, nil, true)
end

function PnlHeadquarters:onBtnClose()
    self:close()
end

function PnlHeadquarters:onBtnSwich()
    local view = self.view
    local activeSelf = view.bgSwich.activeSelf
    view.bgSwich:SetActiveEx(not activeSelf)
    local func = function(list, swichType)
        for k, v in pairs(list) do
            v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
            v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0x81 / 0xff, 0x82 / 0xff, 0x83 / 0xff, 1)
        end
        list[swichType].transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
        list[swichType].transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0xEB / 0xff,
            0xF2 / 0xff, 0xFF / 0xff, 1)

    end

    if not activeSelf then
        func(self.btnSwichTypeList, self.swichTraitType)
        func(self.btnSwichRaceTypeList, self.swichRaceType)
    end
end

function PnlHeadquarters:onBtnTrait(type)
    self.swichTraitType = type
    self:setBoxNftScrollView(self.swichType)
end

function PnlHeadquarters:onBtnRace(type)
    self.swichRaceType = type
    self:setBoxNftScrollView(self.swichType)
end

function PnlHeadquarters:onBtnShip()
    self.swichTraitType = PnlHeadquarters.SWICH_All
    self.swichRaceType = PnlHeadquarters.SWICH_All
    self:setBoxNftScrollView(PnlHeadquarters.SWICH_SHIP)
end

function PnlHeadquarters:onBtnHero()
    self.swichTraitType = PnlHeadquarters.SWICH_All
    self.swichRaceType = PnlHeadquarters.SWICH_All
    self:setBoxNftScrollView(PnlHeadquarters.SWICH_HERO)
end

function PnlHeadquarters:onBtnTower()
    self.swichTraitType = PnlHeadquarters.SWICH_All
    self.swichRaceType = PnlHeadquarters.SWICH_All
    self:setBoxNftScrollView(PnlHeadquarters.SWICH_TOWER)
end

function PnlHeadquarters:onBtnUpgrade()
    local data = self.swichData[self.selId]
    local args = {
        showingData = data,
        type = self.swichType
    }

    if self.swichType == PnlHeadquarters.SWICH_SHIP then
        gg.uiManager:openWindow("PnlWarShip", args)
    elseif self.swichType == PnlHeadquarters.SWICH_HERO then
        gg.uiManager:openWindow("PnlHeroHut", args)
    elseif self.swichType == PnlHeadquarters.SWICH_TOWER then
        gg.uiManager:openWindow("PnlWarShip", args)

    end
end

function PnlHeadquarters:onBtnWrench()
    local data = self.swichData[self.selId]
    local repairTick = data.repairLessTickEnd - os.time()
    local repairNum = data.life - data.curLife
    if repairNum <= 0 and repairTick <= 0 then
        return
    end
    local txtTitel = Utils.getText("universal_Ask_Title")
    local txtTips = Utils.getText("headquarters_Ask_Repair")
    local txtNo = Utils.getText("repair_RepairAll")
    local txtYes = Utils.getText("universal_DetermineButton")
    local callbackYes = {}
    local speedUp = 0

    local cost = math.floor(cfg.repairCost[data.level].cost / 1000)
    -- local cost = math.floor(cfg["global"].RepairCostPerTime.intValue / 1000)

    if repairTick > 0 then
        txtTips = Utils.getText("headquarters_Ask_RepairFinishNow")
        speedUp = 1
        cost = math.floor(cfg["global"].RepairSpeedUpPerMinute.intValue / 1000 * math.floor(repairTick / 60))
    end

    txtTips = string.format(txtTips, cost)
    if self.swichType == PnlHeadquarters.SWICH_SHIP then
        callbackYes = function()
            WarShipData.C2S_Player_WarShipRepair(self.selId)
        end
    elseif self.swichType == PnlHeadquarters.SWICH_HERO then
        callbackYes = function()
            HeroData.C2S_Player_HeroRepair(self.selId)
        end
    elseif self.swichType == PnlHeadquarters.SWICH_TOWER then
        callbackYes = function()
            BuildData.C2S_Player_BuildRepair(self.selId)
        end
    end

    local callbackNo = function()
        self:onBtnFixAll()
    end

    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtYes = txtYes,
        callbackYes = callbackYes,
        txtNo = txtNo,
        callbackNo = callbackNo,
        closeType = PnlAlertNew.CLOSE_TYPE_BG,
    }
    gg.uiManager:openWindow("PnlAlertNew", args)
end

function PnlHeadquarters:onBtnFixAll()
    local nftInfoList = {{
        dataMap = HeroData.heroDataMap,
        list = {},
        fixFunc = HeroData.C2S_Player_HeroRepair
    }, {
        dataMap = WarShipData.warShipData,
        list = {},
        fixFunc = WarShipData.C2S_Player_WarShipRepair
    }, {
        dataMap = BuildData.buildData,
        list = {},
        fixFunc = BuildData.C2S_Player_BuildRepair
    }}
    local cost = 0
    for _, nftInfo in ipairs(nftInfoList) do
        for key, value in pairs(nftInfo.dataMap) do
            if value.curLife == 0 then
                if nftInfo.dataMap == BuildData.buildData then
                    if value.quality > 0 then
                        cost = cost + math.floor(cfg.repairCost[value.level].cost / 1000)
                        table.insert(nftInfo.list, value)
                    end
                else
                    cost = cost + math.floor(cfg.repairCost[value.level].cost / 1000)
                    table.insert(nftInfo.list, value)
                end
            end
        end
    end

    if cost > 0 then
        local callbackYes = function()
            if ResData.getTesseract() >= cost then
                for _, nftInfo in pairs(nftInfoList) do
                    for key, value in pairs(nftInfo.list) do
                        nftInfo.fixFunc(value.id)
                    end
                end
            else
                gg.uiManager:showTip(string.format(Utils.getText("universal_xxxNotEnough"), Utils.getText(
                    constant.RES_2_CFG_KEY[constant.RES_STARCOIN].languageKey)))
            end
        end

        local args = {
            txtTitel = Utils.getText("universal_Ask_Title"),
            txtTips = string.format(Utils.getText("headquarters_Ask_Repair"), cost),
            txtYes = Utils.getText("universal_DetermineButton"),
            callbackYes = callbackYes,
            txtNo = Utils.getText("universal_Ask_BackButton")
        }
        gg.uiManager:openWindow("PnlAlertNew", args)
    else
        gg.uiManager:showTip("you don't have nft need to fix")
    end
end

function PnlHeadquarters:onBtnRefreshInfo()
    -- print("tttttttttttttttttt", self.data.id)
    BuildData.C2S_Player_freshBuild(self.data.id)
end

function PnlHeadquarters:onBtnSet()
    -- gg.warShip.warShipData = nil
    if self.selId and (not gg.warShip.warShipData or self.selId ~= gg.warShip.warShipData.id) then
        WarShipData.C2S_Player_SetUseWarShip(self.selId)
    end
end

function PnlHeadquarters:onBtnDismantle()
    gg.uiManager:openWindow("PnlRecycleCenter")
    -- if self.selId then
    --     local selData = HeroData.heroDataMap[self.selId]
    --     if not selData then
    --         return
    --     end
    --     if selData.skillLevel1 ~= 1 or selData.skill2 ~= 0 or selData.skill3 ~= 0 then
    --         --  ""
    --         local args = {
    --             txtTitel = Utils.getText("universal_Ask_Title"),
    --             txtTips = Utils.getText("headquarters_Ask_DismantleNeedForget"),
    --             txtYes = Utils.getText("universal_Ask_BackButton")
    --         }
    --         gg.uiManager:openWindow("PnlAlertNew", args)
    --         return
    --     end

    --     local txtTitel = Utils.getText("universal_Ask_Title")
    --     local txtTips = Utils.getText("headquarters_Ask_DismantleOrNot")
    --     local txtTipsRed = Utils.getText("headquarters_Ask_DismantleWarn")
    --     local txtNo = Utils.getText("universal_Ask_BackButton")
    --     local txtYes = Utils.getText("universal_DetermineButton")
    --     local yesCallback = function()
    --         HeroData.C2S_Player_DismantleHero(self.selId)
    --     end
    --     local args = {
    --         txtTitel = txtTitel,
    --         txtTips = txtTips,
    --         txtTipsRed = txtTipsRed,
    --         txtYes = txtYes,
    --         callbackYes = yesCallback,
    --         txtNo = txtNo,
    --         skillCfgId = selData.skill1,
    --         skillLevel = selData.skillLevel1,
    --         isDismantleHero = true
    --     }
    --     gg.uiManager:openWindow("PnlAlertResetSkill", args)
    -- end
end

function PnlHeadquarters:onBtnItemHeadquartersNft(id)
    for k, v in pairs(self.itemHeadquartersNftList) do
        v.transform:Find("ImageCurSel").gameObject:SetActiveEx(false)
    end
    self.itemHeadquartersNftList[id].transform:Find("ImageCurSel").gameObject:SetActiveEx(true)
    self:setViewInfo(id)
end

PnlHeadquarters.QUALITY_ICON = {
    [0] = "quality_icon_1",
    [1] = "quality_icon_1",
    [2] = "quality_icon_2",
    [3] = "quality_icon_3",
    [4] = "quality_icon_4",
    [5] = "quality_icon_5"
}

function PnlHeadquarters:onSetViewInfo(args, id, data, type)
    if self.swichData[id] then
        self.swichData[id] = data
    end

    if self.selId then
        self:setViewInfo(self.selId)
    end

    self:onRefreshItemHeadquartersNft(id, data)
end

function PnlHeadquarters:setViewInfo(id)
    self.selId = id
    self.view.boxInfo:SetActiveEx(true)

    local data = self.swichData[id]
    self.data = data
    if not data then
        self.selId = nil
        self.view.btnDismantle:SetActiveEx(false)
        self.view.iconBg.gameObject:SetActiveEx(false)
        self.view.boxInfo.gameObject:SetActiveEx(false)
        return
    end
    local cfgType = ""

    self.view.btnRefreshInfo:SetActiveEx(false)
    if self.swichType == PnlHeadquarters.SWICH_SHIP then
        cfgType = "warShip"
        self.view.bgArmy:SetActiveEx(false)
    elseif self.swichType == PnlHeadquarters.SWICH_HERO then
        cfgType = "hero"
        if data.chain == 0 then
            --self.view.btnDismantle:SetActiveEx(true)
        else
            self.view.btnDismantle:SetActiveEx(false)
        end
        if self.armyData and self.armyData[id] then
            local army = self.armyData[id]
            local number2RomaNumber = {"Ⅰ", "Ⅱ", "Ⅲ", "Ⅵ", "Ⅴ"}
            self.view.txtArmyId.text = number2RomaNumber[army.armyId]
            if army.soliderCfgId == 0 then
                self.view.bgArmy.transform:Find("BoxSolider").gameObject:SetActiveEx(false)
            else
                self.view.bgArmy.transform:Find("BoxSolider").gameObject:SetActiveEx(true)
                local soliderCfg = cfg.getCfg("solider", army.soliderCfgId, 1)
                local iconSolider = gg.getSpriteAtlasName("Soldier_A_Atlas", soliderCfg.icon .. "_A")
                gg.setSpriteAsync(self.view.iconArmySolider, iconSolider)
            end

            self.view.bgArmy:SetActiveEx(true)
            self.view.btnDismantle:SetActiveEx(false)
        else
            self.view.bgArmy:SetActiveEx(false)
        end
    elseif self.swichType == PnlHeadquarters.SWICH_TOWER then
        cfgType = "build"
        self.view.bgArmy:SetActiveEx(false)
        self.view.btnRefreshInfo:SetActiveEx(true)
        self:onSetTowerStage(data)
    end

    local cfgId = data.cfgId
    local level = data.level
    local quality = data.quality
    local curCfg = cfg.getCfg(cfgType, cfgId, level, quality)

    self.view.txtName.text = Utils.getText(curCfg.languageNameID) -- , curCfg.name
    self.view.txtLv.text = string.format("Lv.<color=#ffae00>%s</color>", level)
    local qua = ""

    if data.chain > 0 and data.chain ~= constant.NOTNFTID then
        self.view.txtId.gameObject:SetActiveEx(true)
        self.view.txtId.text = "#" .. id
    else
        self.view.txtId.gameObject:SetActiveEx(false)
        qua = "B"
    end
    local iconName = gg.getSpriteAtlasName("PersonalArmyIcon_Atlas", PnlHeadquarters.QUALITY_ICON[quality] .. qua)
    gg.setSpriteAsync(self.view.iconRare, iconName, function(image, sprite)
        image.sprite = sprite
        self.view.iconRare:SetNativeSize()
    end)

    local curLife = data.curLife
    local life = data.life
    self.view.txtlDurability.text = curLife .. "/" .. life
    local fill = curLife / life
    self.view.sliderDurability.fillAmount = fill
    local repairTick = data.repairLessTickEnd - os.time()
    if repairTick <= 0 then
        local repairTime = (life - curLife) * cfg["global"].RepairTimePerLife.intValue
        if repairTime > 0 then
            self.view.txtWrenchTime.gameObject:SetActiveEx(true)
            self.view.txtWrenchTime.text = gg.time:getTick(repairTime)
        else
            self.view.txtWrenchTime.gameObject:SetActiveEx(false)
        end
    else
        self.view.txtWrenchTime.gameObject:SetActiveEx(false)
    end
    local iconBgName = curCfg.icon .. "_C"
    if iconBgName ~= self.lastSpriteName then
        gg.setSpriteAsync(self.view.iconBg, iconBgName, function(image, sprite)
            self.view.iconBg.gameObject:SetActiveEx(true)
            image.sprite = sprite
            self:releaseLastSprite()
            self.lastSpriteName = iconBgName

        end)
    else
        self.view.iconBg.gameObject:SetActiveEx(true)
    end
    self:refreshAttr(id)
    self:refreshSkill(id)
end

function PnlHeadquarters:releaseLastSprite()
    if self.lastSpriteName then
        gg.releaseSprite(self.lastSpriteName)
        self.lastSpriteName = nil
    end
end

function PnlHeadquarters:refreshAttr(id)
    local myCfg = {}
    local data = self.swichData[id]
    if self.swichType == PnlHeadquarters.SWICH_SHIP then
        self.attrDataList = constant.WARSHIP_SHOW_ATTR
        myCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
        self.showAttrMap = WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level, 0, data.curLife)
    elseif self.swichType == PnlHeadquarters.SWICH_HERO then
        self.attrDataList = constant.HERO_SHOW_ATTR
        myCfg = cfg.getCfg("hero", data.cfgId, data.level, data.quality)
        self.showAttrMap = HeroUtil.getHeroAttr(data.cfgId, data.level, data.quality)
    elseif self.swichType == PnlHeadquarters.SWICH_TOWER then
        self.attrDataList = constant.BUILD_SHOW_ATTR
        myCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
        self.showAttrMap = BuildUtil.getBuildAttr(data.cfgId, data.level, data.quality)
    end

    self.showCompareAttrMap = nil

    local itemCount = #self.attrDataList
    local scrollViewLenth = AttrUtil.getAttrScrollViewLenth(itemCount)

    self.attrScrollView:setItemCount(#self.attrDataList)

    -- self.attrScrollView.transform:SetRectSizeY(scrollViewLenth)
end

function PnlHeadquarters:refreshSkill(id)
    if self.swichType == PnlHeadquarters.SWICH_TOWER then
        self.view.boxSkill:SetActiveEx(false)
        return
    else
        self.view.boxSkill:SetActiveEx(true)
    end
    local data = self.swichData[id]

    local setSkillData = function(skillId, skillLv, go)
        go.gameObject:SetActiveEx(true)
        local iconName = ""
        local quality = 0
        if skillId == 0 then
            go:Find("BgLv").gameObject:SetActiveEx(false)
            iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", "emptybox_icon")

        else
            go:Find("BgLv").gameObject:SetActiveEx(true)
            local curSkillCfg = cfg.getCfg("skill", skillId, skillLv)
            quality = curSkillCfg.quality
            iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", curSkillCfg.icon .. "_A1")
            local txtLv = go:Find("BgLv/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT)
            txtLv.text = "LV." .. skillLv
        end
        -- local curSkillCfg = cfg.getCfg("skill", skillId, skillLv)

        local iconBg = go:Find("IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
        UIUtil.setQualityBg(iconBg, quality)

        local icon = go:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

        gg.setSpriteAsync(icon, iconName)
    end
    self.skillIndexList = {}

    for i = 1, 4, 1 do
        local skillName = "skill" .. i
        if data[skillName] and data[skillName] ~= 0 then
            local skillLv = "skillLevel" .. i
            setSkillData(data[skillName], data[skillLv], self.view.itemSkillList[i])
        elseif data[skillName] == 0 then
            setSkillData(data[skillName], 0, self.view.itemSkillList[i])
        else
            self.view.itemSkillList[i].gameObject:SetActiveEx(false)
        end
    end
end

PnlHeadquarters.SWITCHTYPE_LANGUAGE = {
    [PnlHeadquarters.SWICH_SHIP] = "headquarters_WarshipTag",
    [PnlHeadquarters.SWICH_HERO] = "headquarters_HeroTag",
    [PnlHeadquarters.SWICH_TOWER] = "headquarters_DefenseTag"
}

PnlHeadquarters.switchType2AutoPushType = {
    [PnlHeadquarters.SWICH_SHIP] = constant.AUTOPUSH_CFGID_NEW_WARSHIP,
    [PnlHeadquarters.SWICH_HERO] = constant.AUTOPUSH_CFGID_NEW_HERO,
    [PnlHeadquarters.SWICH_TOWER] = constant.AUTOPUSH_CFGID_NEW_BUILD
}

function PnlHeadquarters:setButtonType(swichType)
    for k, v in pairs(self.showingButtonTypeList) do
        if k == swichType then
            v.transform:Find("IconSel").gameObject:SetActiveEx(true)
        else
            v.transform:Find("IconSel").gameObject:SetActiveEx(false)
        end
    end
end

function PnlHeadquarters:chackTrait(curCfg)
    if self.swichTraitType == PnlHeadquarters.SWICH_All then
        return true
    elseif self.swichTraitType == curCfg.quality then
        return true
    end
    return false
end

function PnlHeadquarters:chackRace(curCfg)
    if self.swichRaceType == PnlHeadquarters.SWICH_All then
        return true
    elseif self.swichRaceType == curCfg.race then
        return true
    end
    return false
end

function PnlHeadquarters:setBoxNftScrollView(swichType)

    local autoPushCfgId = PnlHeadquarters.switchType2AutoPushType[swichType]
    if autoPushCfgId then
        local status = AutoPushData.getAutoPushStatus(autoPushCfgId)
        if status and status > 0 then
            AutoPushData.C2S_Player_AutoPushStatus_Del(autoPushCfgId)
        end
    end
    -- AutoPushData.C2S_Player_AutoPushStatus_Del(PnlHeadquarters.switchType2AutoPushType[swichType])
    self:setButtonType(swichType)
    self.view.boxInfo:SetActiveEx(false)
    self.view.bgSwich:SetActiveEx(false)
    self.view.iconBg.gameObject:SetActiveEx(false)
    self.view.bgArmy:SetActiveEx(false)
    self.view.txtType.text = Utils.getText(PnlHeadquarters.SWITCHTYPE_LANGUAGE[swichType])
    -- self.view.txtSwich.text = Utils.getText(PnlHeadquarters.SWITCHTYPE_LANGUAGE[swichType])
    self.swichType = swichType
    self.swichData = {}
    local dataTable = {}
    local cfgType = ""
    local selId = -1

    self.armyData = nil

    local nftCount = 0

    if self.swichType == PnlHeadquarters.SWICH_SHIP then
        nftCount = Utils.getwarshipCount()
        self.swichData = WarShipData.warShipData
        cfgType = "warShip"
        if WarShipData.useData then
            selId = WarShipData.useData.id
        end
        for k, v in pairs(WarShipData.warShipData) do
            local data = v
            local curCfg = cfg.getCfg(cfgType, v.cfgId, v.level, v.quality)
            if curCfg and self:chackTrait(curCfg) and self:chackRace(curCfg) then
                local sel = 0
                if selId == v.id then
                    sel = 1
                end
                data.sort = sel * 10000000000 + v.level * 1000000000 + v.quality * 100000000 + curCfg.race * 10000000 +
                                curCfg.cfgId
                data.curCfg = curCfg
                table.insert(dataTable, data)
            end
        end
        self.view.btnSet:SetActiveEx(true)
        self.view.btnDismantle:SetActiveEx(false)
        self.view.boxLocation:SetActiveEx(false)

    elseif self.swichType == PnlHeadquarters.SWICH_HERO then
        nftCount = Utils.getHeroCount()

        self.armyData = {}

        if PlayerData.armyData then
            for armyId, data in pairs(PlayerData.armyData) do
                local armyId = armyId
                for k, team in pairs(data.teams) do
                    local args = {
                        heroId = team.heroId,
                        soliderCfgId = team.soliderCfgId,
                        armyId = armyId
                    }
                    self.armyData[team.heroId] = args
                end
            end
        end

        self.swichData = HeroData.heroDataMap
        cfgType = "hero"
        if HeroData.ChooseingHero then
            selId = HeroData.ChooseingHero.id
        end
        for k, v in pairs(HeroData.heroDataMap) do
            local data = v
            local curCfg = cfg.getCfg(cfgType, v.cfgId, v.level, v.quality)
            if curCfg and self:chackTrait(curCfg) and self:chackRace(curCfg) then
                local sel = 0
                if self.armyData and self.armyData[data.id] then
                    sel = 6 - self.armyData[data.id].armyId
                end
                data.sort = sel * 10000000000 + v.level * 1000000000 + v.quality * 100000000 + curCfg.race * 10000000 +
                                curCfg.cfgId
                data.curCfg = curCfg
                table.insert(dataTable, data)
            end
        end

        self.view.btnSet:SetActiveEx(false)
        self.view.btnDismantle:SetActiveEx(false)
        self.view.boxLocation:SetActiveEx(false)

    elseif self.swichType == PnlHeadquarters.SWICH_TOWER then
        nftCount = Utils.getNftBuildCount()

        cfgType = "build"
        for k, v in pairs(BuildData.buildData) do
            if v.pos.x == 0 and v.pos.z == 0 then
                self.swichData[v.id] = v
                local data = v
                local curCfg = cfg.getCfg(cfgType, v.cfgId, v.level, v.quality)
                if curCfg and self:chackTrait(curCfg) and self:chackRace(curCfg) then
                    data.sort = v.level * 1000000000 + v.quality * 100000000 + curCfg.race * 10000000 + curCfg.cfgId
                    data.curCfg = curCfg
                    table.insert(dataTable, data)
                end
            end
        end
        self.view.btnSet:SetActiveEx(false)
        self.view.btnDismantle:SetActiveEx(false)
        self.view.boxLocation:SetActiveEx(true)
    end
    self:releaseItemHeadquartersNft()
    local firstData = true

    self.tickTimerFun = {}
    self.view.txtNoDefense:SetActiveEx(true)
    QuickSort.quickSort(dataTable, "sort", 1, #dataTable)

    self.view.txtNftCount.text = nftCount.. "/" .. cfg.global.HQBagMax.intValue

    for k, v in pairs(dataTable) do
        self.view.txtNoDefense:SetActiveEx(false)
        local id = v.id
        local cfgId = v.cfgId
        local level = v.level
        local quality = v.quality
        local curCfg = v.curCfg

        ResMgr:LoadGameObjectAsync("ItemHeadquartersNft", function(go)
            go.transform:SetParent(self.view.nftContent, false)
            local lessTick = v.lessTick
            local skillUpLessTick = v.skillUpLessTick
            local ref = v.ref
            local chain = v.chain

            local iconName

            if cfgType == "warShip" then
                iconName = gg.getSpriteAtlasName("Warship_A_Atlas", curCfg.icon .. "_A")
                go.transform:Find("Mask/IconBg").gameObject:SetActiveEx(false)
            elseif cfgType == "hero" then
                go.transform:Find("Mask/IconBg").gameObject:SetActiveEx(true)
                iconName = gg.getSpriteAtlasName("Hero_A_Atlas", curCfg.icon .. "_A")
            elseif cfgType == "build" then
                iconName = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
                go.transform:Find("Mask/IconBg").gameObject:SetActiveEx(false)
            end

            local iconImg = go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

            gg.setSpriteAsync(iconImg, iconName)
            UIUtil.setQualityBg(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)

            go.transform:Find("ImageCurSel").gameObject:SetActiveEx(false)

            go.transform:Find("ImageSelected").gameObject:SetActiveEx(false)

            if self.swichType == PnlHeadquarters.SWICH_SHIP and selId == id then
                go.transform:Find("ImageSelected").gameObject:SetActiveEx(true)
            end

            -- if selId == id then
            --     go.transform:Find("ImageSelected").gameObject:SetActiveEx(true)
            -- else
            --     go.transform:Find("ImageSelected").gameObject:SetActiveEx(false)
            -- end
            if chain > 0 and chain ~= constant.NOTNFTID then
                go.transform:Find("ImageNft").gameObject:SetActiveEx(true)
            else
                go.transform:Find("ImageNft").gameObject:SetActiveEx(false)
            end
            if self.swichType == PnlHeadquarters.SWICH_HERO and self.armyData and self.armyData[id] then
                local number2RomaNumber = {"Ⅰ", "Ⅱ", "Ⅲ", "Ⅵ", "Ⅴ"}

                local army = self.armyData[id]
                -- go.transform:Find("ImageNft").gameObject:SetActiveEx(false)
                go.transform:Find("ImageSequence").gameObject:SetActiveEx(true)
                go.transform:Find("ImageSequence/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    number2RomaNumber[army.armyId]
            else
                go.transform:Find("ImageSequence").gameObject:SetActiveEx(false)
            end
            go.transform:Find("ImageCurSel").gameObject:SetActiveEx(false)
            if firstData then
                self:setViewInfo(id)
                go.transform:Find("ImageCurSel").gameObject:SetActiveEx(true)

                firstData = false
            end

            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:onBtnItemHeadquartersNft(id)
            end)

            self.itemHeadquartersNftList[id] = go

            self:onRefreshItemHeadquartersNft(id, v)
            return true
        end, true)
    end
end

function PnlHeadquarters:onSetTowerStage(data)
    if self.selId ~= data.id then
        return
    end

    if data.ref == 0 then
        self.view.btnRecycle.gameObject:SetActiveEx(false)
        self.view.txtLocation.gameObject:SetActiveEx(false)
        self.view.txtState.text = Utils.getText("headquarters_DFInHQ")
    elseif data.ref == 4 then
        if data.refBy == 0 then
            self.view.btnRecycle.gameObject:SetActiveEx(true)
            self.view.txtLocation.gameObject:SetActiveEx(false)
            self.view.txtState.text = Utils.getText("headquarters_DFInDAO")
        elseif data.refBy > 0 then
            local starmap = cfg.getCfg("starmap1", data.refBy)
            self.GVGTowerCfgid = starmap.cfgId
            self.view.btnRecycle.gameObject:SetActiveEx(true)
            self.view.txtLocation.text = "[" .. starmap.pos.x .. "," .. starmap.pos.y .. "]"
            self.view.txtLocation.gameObject:SetActiveEx(true)
            self.view.txtState.text = starmap.name
        end
    elseif data.ref == 5 and data.refBy > 0 then
        local starmap = cfg.getCfg("starmap1", data.refBy)
        self.GVGTowerCfgid = starmap.cfgId
        self.view.btnRecycle.gameObject:SetActiveEx(true)
        self.view.txtLocation.text = "[" .. starmap.pos.x .. "," .. starmap.pos.y .. "]"
        self.view.txtLocation.gameObject:SetActiveEx(true)
        self.view.txtState.text = starmap.name
    end
end

function PnlHeadquarters:onSetSelWarship(args, id)
    if self.itemHeadquartersNftList[id] then
        -- for k, go in pairs(self.itemHeadquartersNftList) do
        --     go.transform:Find("ImageSelected").gameObject:SetActiveEx(false)
        -- end
        -- self.itemHeadquartersNftList[id].transform:Find("ImageSelected").gameObject:SetActiveEx(true)
        self:setBoxNftScrollView(PnlHeadquarters.SWICH_SHIP)
    end
end

function PnlHeadquarters:onRefreshItemHeadquartersNft(id, data)
    if self.itemHeadquartersNftList[id] then
        local go = self.itemHeadquartersNftList[id]
        if not data then
            go:SetActiveEx(false)
            return
        end
        local level = data.level

        go.transform:Find("BgLv/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("LV.%s", level)

        go.transform:Find("BgUpgradeTime").gameObject:SetActiveEx(false)
        go.transform:Find("BgWrenchTime").gameObject:SetActiveEx(false)

        local lessTick = data.lessTickEnd - os.time()

        local repairLessTick = data.repairLessTickEnd - os.time()
        local skillUpLessTick = 0
        if data.skillUpLessTickEnd then
            skillUpLessTick = data.skillUpLessTickEnd - os.time()
        end
        if lessTick > 0 then
            go.transform:Find("BgUpgradeTime").gameObject:SetActiveEx(true)
            self.tickTimerFun[id] = function()
                local tick = data.lessTickEnd - os.time()
                go.transform:Find("BgUpgradeTime/TxtUpgradeTime"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    gg.time:getTick(tick)
                if tick <= 0 then
                    go.transform:Find("BgUpgradeTime").gameObject:SetActiveEx(false)
                    self.tickTimerFun[id] = nil
                end
            end
        elseif skillUpLessTick > 0 then
            go.transform:Find("BgUpgradeTime").gameObject:SetActiveEx(true)
            self.tickTimerFun[id] = function()
                local tick = data.skillUpLessTickEnd - os.time()
                go.transform:Find("BgUpgradeTime/TxtUpgradeTime"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    gg.time:getTick(tick)
                if tick <= 0 then
                    go.transform:Find("BgUpgradeTime").gameObject:SetActiveEx(false)
                    self.tickTimerFun[id] = nil
                end
            end
        elseif repairLessTick > 0 then
            go.transform:Find("BgWrenchTime").gameObject:SetActiveEx(true)
            self.tickTimerFun[id] = function()
                local tick = data.repairLessTickEnd - os.time()
                go.transform:Find("BgWrenchTime/TxtWrenchTime"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    gg.time:getTick(tick)
                if tick <= 0 then
                    go.transform:Find("BgUpgradeTime").gameObject:SetActiveEx(false)
                    self.tickTimerFun[id] = nil
                end
            end
        else
            self.tickTimerFun[id] = nil
        end

    end
end

function PnlHeadquarters:releaseItemHeadquartersNft()
    if self.itemHeadquartersNftList then
        for k, v in pairs(self.itemHeadquartersNftList) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.itemHeadquartersNftList = {}
    end
end

function PnlHeadquarters:onPersonalArmyChange()
    self:setBoxNftScrollView(self.swichType)
end

function PnlHeadquarters:startLoopTimer()
    self:stopLoopTimer()
    self.loopTimer = gg.timer:startLoopTimer(0, 1, -1, function()
        for k, v in pairs(self.tickTimerFun) do
            v()
        end
    end)
end

function PnlHeadquarters:stopLoopTimer()
    if self.loopTimer then
        gg.timer:stopTimer(self.loopTimer)
        self.loopTimer = nil
    end
    self.tickTimerFun = {}
end

return PnlHeadquarters
