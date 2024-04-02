

PnlPersonalQuickSelectArmy = class("PnlPersonalQuickSelectArmy", ggclass.UIBase)

function PnlPersonalQuickSelectArmy:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onPersonalArmyChange", "onSetPnlDraftView", "onUpdateUnionData", "OnGuildReserveArmyChange" }
end

function PnlPersonalQuickSelectArmy:onAwake()
    self.view = ggclass.PnlPersonalQuickSelectArmyView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "PersonalQuickSelectArmyItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

PnlPersonalQuickSelectArmy.MODE_PERSONAL = 1
PnlPersonalQuickSelectArmy.MODE_UNION = 2

-- PnlPersonalQuickSelectArmy.SELECT_TYPE_SINGLE = 1
-- PnlPersonalQuickSelectArmy.SELECT_TYPE_MULTI = 2

-- args = {fightCB = ,playerInfo = {head, score, name}, selectCount, isEnableUnionMode, isGVG}
function PnlPersonalQuickSelectArmy:onShow()
    local view = self.view
    self.selectingArmys = {}

    self:bindEvent()
    PlayerData.C2S_Player_ArmyFormationQuery()

    PlayerData.C2S_Player_OneKeyFillUpSoliders(nil)

    self:refreshArmyCount()
    if self.args.playerInfo then
        view.layoutEnemyInfo:SetActiveEx(true)
        -- view.txtName.text = self.args.playerInfo.name
        -- gg.setSpriteAsync(view.imgHead, Utils.getHeadIcon(self.args.playerInfo.head))

        view.txtName.text = "GB COMMANDER"
        gg.setSpriteAsync(view.imgHead, "Head_Atlas[profile phpto 21_icon]")

        local stageCfg = PvpUtil.bladge2StageCfg(self.args.playerInfo.score)
        gg.setSpriteAsync(view.imgStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))
    else
        view.layoutEnemyInfo:SetActiveEx(false)
    end

    self.selectCount = self.args.selectCount or 1

    -- self.args.isEnableUnionMode = false

    
    -- self:changeSoldierMode(PnlPersonalQuickSelectArmy.MODE_PERSONAL)
    if self.args.isEnableUnionMode then
        UnionData.C2S_Player_QueryUnionSoliders()
        if UnionData.armyData.isUseGuildArmy == 0 then
            self.view.toggleUnionMode:SetIsOnWithoutNotify(false)
        else
            self.view.toggleUnionMode:SetIsOnWithoutNotify(true)
        end
    else
        self.view.toggleUnionMode:SetIsOnWithoutNotify(false)
    end

    self:onToggleUnionMode(view.toggleUnionMode.isOn)
    self:refreshSoldierMode()

    --""
    -- view.toggleUnionMode.transform:SetActiveEx(self.args.isEnableUnionMode)
    view.toggleUnionMode.transform:SetActiveEx(false)

    view.root:SetActiveEx(false)

    view.layoutEdit:SetActiveEx(EditData.isEditMode)
end

function PnlPersonalQuickSelectArmy:onConditionValueChange(isOn)
    if isOn then
        PlayerData.C2S_Player_automaticForces(1)
    else
        PlayerData.C2S_Player_automaticForces(0)
    end
end

function PnlPersonalQuickSelectArmy:onRenderItem(obj, index)

    local item = PersonalQuickSelectArmyItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])

end

function PnlPersonalQuickSelectArmy:selectArmy(army)
    if self.selectCount == 1 then
        self.selectingArmys = {army}
    else
        local isSelect = false
        for key, value in pairs(self.selectingArmys) do
            if value.armyId == army.armyId then
                isSelect = true
                table.remove(self.selectingArmys, key)
                break
            end
        end

        if not isSelect then
            if #self.selectingArmys < self.selectCount then
                table.insert(self.selectingArmys, army)
            end
        end
    end

    for key, value in pairs(self.itemList) do
        value:refreshSelect()
    end
end

function PnlPersonalQuickSelectArmy:refresh()
    local view = self.view

    if PlayerData.autoStatus == 1 then
        self.view.toggleAutoAddForces:SetIsOnWithoutNotify(true)
    else
        self.view.toggleAutoAddForces:SetIsOnWithoutNotify(false)
    end
    self.dataList = PlayerData.armyData

    if #self.dataList == 0 then
        view.layoutEmp:SetActiveEx(true)
        view.btnAttack:SetActiveEx(false)
    else
        local serverTime = Utils.getServerSec()

        if self.args.isGVG then
            for _, army in ipairs(self.dataList) do
                local isCd = false
                for key, value in pairs(army.teams) do
                    if value.heroId > 0 and not heroData then
                        local heroData = HeroData.heroDataMap[value.heroId]
                        if heroData.battleCd / 1000 > serverTime then
                            isCd = true
                        end
                    end
                end
                if not isCd then
                    self.selectingArmys = {army}
                    break
                end
            end
        else
            self:selectArmy(self.dataList[1])
        end

        view.layoutEmp:SetActiveEx(false)
        view.btnAttack:SetActiveEx(true)
    end

    self.scrollView:setItemCount(#self.dataList)
end

function PnlPersonalQuickSelectArmy:onSetPnlDraftView()
    self:refreshArmyCount()
end

function PnlPersonalQuickSelectArmy:onUpdateUnionData(_, funcType, subType)
    if funcType == PnlUnion.VIEW_UNIONWAREHOUSE and subType == PnlUnion.WAREHOUSE_SOLIDIER then
        if self.soldierMode == PnlPersonalQuickSelectArmy.MODE_UNION then
            self:changeSoldierMode(self.soldierMode)
        end
    end
end

function PnlPersonalQuickSelectArmy:refreshArmyCount()
    local maxSpace = 0
    local totalCount = 0

    for key, value in pairs(DraftData.reserveArmys) do
        totalCount = totalCount + value.count
        local buildData = BuildData.buildData[value.buildId]
        if buildData then
            local buildCfg = BuildUtil.getCurBuildCfg(buildData.cfgId, buildData.level, buildData.quality)
            maxSpace = maxSpace + buildCfg.maxTrainSpace
        end
    end

    self.view.textForces.text = totalCount .. "/" .. maxSpace
end

function PnlPersonalQuickSelectArmy:onPersonalArmyChange()
    self.view.root:SetActiveEx(true)
    self:refresh()
end

function PnlPersonalQuickSelectArmy:onHide()
    self:releaseEvent()
end

function PnlPersonalQuickSelectArmy:bindEvent()
    local view = self.view

    view.toggleAutoAddForces.onValueChanged:AddListener(gg.bind(self.onConditionValueChange, self))

    CS.UIEventHandler.Get(view.btnAttack):SetOnClick(function()
        self:onBtnAttack()
    end)

    self:setOnClick(view.btnClose, gg.bind(self.close, self))
    self:setOnClick(view.btnGo, gg.bind(self.onBtnGo, self))
    self:setOnClick(view.btnAddUnionArmy, gg.bind(self.onBtnAddUnionArmy, self))
    self:setOnClick(view.btnDraft, gg.bind(self.onBtnDraft, self))

    view.toggleUnionMode.onValueChanged:AddListener(gg.bind(self.onToggleUnionMode, self))
end

function PnlPersonalQuickSelectArmy:onToggleUnionMode(isOn)
    self:setDaoToggleStage(isOn, self.view.toggleUnionModeImgSelect)
    self.isUnionMode = isOn

    if isOn then
        UnionData.C2S_Player_IsUseGuidArmy(1)
    else
        UnionData.C2S_Player_IsUseGuidArmy(0)
    end
end

function PnlPersonalQuickSelectArmy:refreshSoldierMode()
    if UnionData.armyData.isUseGuildArmy == 1 then
        self:changeSoldierMode(PnlPersonalQuickSelectArmy.MODE_UNION)
    else
        self:changeSoldierMode(PnlPersonalQuickSelectArmy.MODE_PERSONAL)
    end
end

function PnlPersonalQuickSelectArmy:changeSoldierMode(soldierMode)
    local view = self.view

    self.soldierMode = soldierMode

    view.layoutForces:SetActiveEx(false)
    view.layoutUnionForces:SetActiveEx(false)
    if soldierMode == PnlPersonalQuickSelectArmy.MODE_PERSONAL then
        view.layoutForces:SetActiveEx(true)
    elseif soldierMode == PnlPersonalQuickSelectArmy.MODE_UNION then
        view.layoutUnionForces:SetActiveEx(true)
        self:refreshUnionForce()
    end

    for key, value in pairs(self.itemList) do
        value:setSoldierMode(soldierMode)
    end
end

function PnlPersonalQuickSelectArmy:refreshUnionForce()
    self.view.textUnionForces.text = UnionData.armyData.guildReserveCount .. "/" .. cfg.global.GuildReserveArmyLimt.intValue
end

function PnlPersonalQuickSelectArmy:OnGuildReserveArmyChange()
    self:refreshUnionForce()
    self:refreshSoldierMode()
end

function PnlPersonalQuickSelectArmy:onBtnAddUnionArmy()
    local costCfg = cfg.global.GuildReserveArmyCostRes

    local costRes = costCfg.tableValue[1][1]
    local costPer = costCfg.tableValue[1][2]
    local buyMaxCount = cfg.global.GuildReserveArmyLimt.intValue - UnionData.armyData.guildReserveCount

    local args = {
        minCount = 1,
        maxCount = buyMaxCount,
        startCount = 1,
        resId = costRes,
        title = Utils.getText("formation_Choose_AddDaoReservist"),
        title2 = "",
    }

    args.yesCallback = function (count)
        UnionData.C2S_Player_AddGuildReserveCount(count)
    end

    args.changeCallback = function (count)
        return count * costPer
    end

    gg.uiManager:openWindow("PnlBuyCount", args)
end

function PnlPersonalQuickSelectArmy:onBtnDraft()
    for key, value in pairs(BuildData.buildData) do
        if value.cfgId == constant.BUILD_DRAFT then
            gg.uiManager:openWindow("PnlDraft", {
                buildData = value,
                buildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)

            })
            return
        end
    end
end

function PnlPersonalQuickSelectArmy:setDaoToggleStage(isOn, imgSelect)
    if isOn then
        imgSelect.transform.anchoredPosition = UnityEngine.Vector2(-55.5, imgSelect.transform.anchoredPosition.y)
        imgSelect.transform:Find("TextSelect"):GetComponent(UNITYENGINE_UI_TEXT).text = "ON"
    else
        imgSelect.transform.anchoredPosition = UnityEngine.Vector2(55.5, imgSelect.transform.anchoredPosition.y)
        imgSelect.transform:Find("TextSelect"):GetComponent(UNITYENGINE_UI_TEXT).text = "OFF"
    end
end

function PnlPersonalQuickSelectArmy:onBtnGo()
    gg.uiManager:openWindow("PnlPersonalArmy")
end

function PnlPersonalQuickSelectArmy:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnAttack)
    view.toggleAutoAddForces.onValueChanged:RemoveAllListeners()
    view.toggleUnionMode.onValueChanged:RemoveAllListeners()
end

function PnlPersonalQuickSelectArmy:onDestroy()
    local view = self.view
    self.scrollView:release()
end

function PnlPersonalQuickSelectArmy:onBtnAttack(isIgnoreSoldierCount)
    self.fixHeroList = {}
    local cost = 0

    local warshipData = WarShipData.useData

    local fixWarShip = nil
    if warshipData and warshipData.curLife <= 0 then
        fixWarShip = warshipData
        local repairTick = warshipData.repairLessTickEnd - os.time()
        if repairTick > 0 then
            cost = cost + math.floor(cfg["global"].RepairSpeedUpPerMinute.intValue) * math.floor(repairTick / 60)
        else
            cost = cost + cfg.repairCost[warshipData.level].cost
        end
    end

    for _, army in pairs(self.selectingArmys) do
        local isEmp = true
        local isNotFullSoldier = false

        for _, value in pairs(army.teams) do
            if (value.heroId and value.heroId > 0) or (value.soliderCfgId and value.soliderCfgId > 0) then
                isEmp = false
            end
            if value.heroId and value.heroId > 0 then
                local hero = HeroData.heroDataMap[value.heroId]
                if hero.curLife == 0 then
                    table.insert(self.fixHeroList, hero)
                    local repairTick = hero.repairLessTickEnd - os.time()
                    if repairTick > 0 then
                        cost = cost + cfg["global"].RepairSpeedUpPerMinute.intValue * math.floor(repairTick / 60)
                    else
                        -- cost = cost + math.floor(cfg["global"].RepairCostPerTime.intValue)
                        local heroData = HeroData.heroDataMap[value.heroId]
                        cost = cost + cfg.repairCost[heroData.level].cost
                    end
                end

                if not isNotFullSoldier and not isIgnoreSoldierCount then
                    local maxSpace = PersonalArmyUtils.getSoldierMaxSpace(value.heroId)
                    -- local soliderCfgId = value.soliderCfgId
                    if value.soliderCfgId > 0 then
                        local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.soliderCfgId][1]
                        local maxCount = math.floor(maxSpace / soldierCfg.trainSpace)
                        if maxCount > value.soliderCount then
                            isNotFullSoldier = true
                        end
                    else
                        isNotFullSoldier = true
                    end
                end

                -- gg.printData(value, "tttttttttttttttttttttttttt")
            end
        end
        if isEmp then
            gg.uiManager:showTip("exist empty team")
            return
        end

        if isNotFullSoldier then
            local args = {
                title = "not enought soldier",
                txt = "not enought soldier, are you sure want to continue?",
                callbackYes = function ()
                    self:onBtnAttack(true)
                end,
                txtYes = Utils.getText("universal_ConfirmButton")
            }
            gg.uiManager:openWindow("PnlAlert", args)
            return
            -- gg.uiManager:showTip("exist not full soldier team, are you sure want to continue?")
        end
    end

    if #self.fixHeroList > 0 or fixWarShip then
        local callbackYes = function ()
            if ResData.getStarCoin() >= cost then
                for key, value in pairs(self.fixHeroList) do
                    HeroData.C2S_Player_HeroRepair(value.id)
                end

                if fixWarShip then
                    WarShipData.C2S_Player_WarShipRepair(fixWarShip.id)
                end
            else
                -- string.format(Utils.getText("universal_xxxNotEnough"), Utils.getText(constant.RES_2_CFG_KEY[constant.RES_STARCOIN].languageKey))
                gg.uiManager:showTip(string.format(Utils.getText("universal_xxxNotEnough"), Utils.getText(constant.RES_2_CFG_KEY[constant.RES_STARCOIN].languageKey)))
            end
        end

        local args = {
            txtTitel = Utils.getText("universal_Ask_Title"),
            -- txtTips = string.format("cost %s Tesseract to fix 0 life hero or warShip", cost),
            txtYes = Utils.getText("universal_DetermineButton"),
            callbackYes = callbackYes,
            txtNo = Utils.getText("universal_Ask_BackButton"),
            yesCost = {{resId = constant.RES_STARCOIN, count = cost}}
        }

        -- local txtHero = ""
        -- for key, value in pairs(self.fixHeroList) do
        --     local heroCfg = HeroUtil.getHeroCfg(value.cfgId, value.level, value.quality)

        --     if key == #self.fixHeroList then
        --         txtHero = txtHero .. Utils.getText(heroCfg.languageNameID)
        --     else
        --         txtHero = txtHero .. Utils.getText(heroCfg.languageNameID) .. ","
        --     end
        -- end
        -- args.txtTips = string.format("your hero %s curlife is 0, do you want to fix?", txtHero)

        args.txtTips = string.format(Utils.getText("headquarters_Ask_Repair"), Utils.getShowRes(cost))
        gg.uiManager:openWindow("PnlAlertNew", args)
        return
    end

    if self.args.isEnableUnionMode and UnionData.armyData.isUseGuildArmy == 1 then
        local totalNeedArmy = 0
        for key, value in pairs(self.selectingArmys) do
            local soldierSpace, soldierMaxSpace = PersonalArmyUtils.getArmySoldierInfo(value, PnlPersonalQuickSelectArmy.MODE_UNION)
            totalNeedArmy = totalNeedArmy + soldierSpace
        end
        if totalNeedArmy > UnionData.armyData.guildReserveCount then

            local args = {
                title = Utils.getText("universal_Ask_TitleWarning"),
                txt = Utils.getText("universal_Ask_ContinueNoReservist"),
                callbackYes = function ()
                    self.args.fightCB(self.selectingArmys)
                    self:close()
                end,
                txtYes = Utils.getText("universal_ConfirmButton")
            }
            gg.uiManager:openWindow("PnlAlert", args)
            return
        end
    end

    if #self.selectingArmys <= 0 then
        gg.uiManager:showTip("empty army")
        return
    end

    -- view.layoutEdit:SetActiveEx(EditData.isEditMode)

    if EditData.isEditMode then
        local callBackCount = tonumber(self.view.inputLoopAtkTimes.text) or 1
        local lessTimes = callBackCount
        gg.timer:startLoopTimer(0, 1, callBackCount, function()
            gg.uiManager:showTip(string.format(""" %s", lessTimes))
            lessTimes = lessTimes - 1
            self.args.fightCB(self.selectingArmys)
        end)
        return
    end

    if self.args.fightCB then
        self.args.fightCB(self.selectingArmys)
        self:close()
    end
end

-- guide
-- ""ui
-- override
function PnlPersonalQuickSelectArmy:getGuideRectTransform(guideCfg)
    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlPersonalQuickSelectArmy:triggerGuideClick(guideCfg)

    if guideCfg.gameObjectName == "toggleAutoAddForces" then
        self.view.toggleAutoAddForces.isOn = true
        return
    end

    ggclass.UIBase.triggerGuideClick(self, guideCfg)
end

----------------------------------------------

PersonalQuickSelectArmyItem = PersonalQuickSelectArmyItem or class("PersonalQuickSelectArmyItem", ggclass.UIBaseItem)
function PersonalQuickSelectArmyItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PersonalQuickSelectArmyItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtForces = self:Find("TxtForces", UNITYENGINE_UI_TEXT)

    self.bgIcon = self:Find("BgIcon")
    self.imgIcon = self:Find("BgIcon/mask/ImgIcon", UNITYENGINE_UI_IMAGE)

    self.imgSelect = self:Find("ImgSelect")

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))

    self.layoutCd = self:Find("LayoutCd").transform
    self.txtCd = self.layoutCd:Find("TxtCd"):GetComponent(UNITYENGINE_UI_TEXT)
end

function PersonalQuickSelectArmyItem:onClickItem()
    if self.cdHeroData then
        return
    end

    self.initData:selectArmy(self.data)
end

function PersonalQuickSelectArmyItem:refreshSelect()
    local isSelect = false
    for key, value in pairs(self.initData.selectingArmys) do
        if value.armyId == self.data.armyId then
            isSelect = true
        end
    end

    -- selectingArmys
    self.imgSelect:SetActiveEx(isSelect)
end

function PersonalQuickSelectArmyItem:setData(data)
    self.data = data

    self.txtName.text = data.armyName

    local heroData = nil
    for key, value in pairs(data.teams) do
        if value.heroId > 0 and not heroData then
            heroData = HeroData.heroDataMap[value.heroId]
        end
    end

    if heroData then
        self.bgIcon:SetActiveEx(true)
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        gg.setSpriteAsync(self.imgIcon, string.format("Hero_A_Atlas[%s_A]", heroCfg.icon))
    else
        self.bgIcon:SetActiveEx(false)
    end

    self.heroData = heroData

    -- if not self.initData.army or self.initData.army.armyId == self.data.armyId then
    --     self.initData:selectArmy(self.data)
    -- end

    self:setSoldierMode(self.initData.soldierMode)
    self:refreshSelect()

    -- for key, value in pairs(self.data.teams) do
    --     if value.heroId > 0 then
    --         HeroData.heroDataMap[value.heroId].battleCd = (Utils.getServerSec() + 3) * 1000
    --     end
    -- end

    self:refreshCd()
end

function PersonalQuickSelectArmyItem:refreshCd()
    self.cdHeroData = nil
    gg.timer:stopTimer(self.timer)

    if not self.initData.args.isGVG then
        self.layoutCd:SetActiveEx(false)
        return
    end

    local serverTime = Utils.getServerSec()

    for key, value in pairs(self.data.teams) do
        if value.heroId > 0 then
            local heroData = HeroData.heroDataMap[value.heroId]
            if heroData.battleCd / 1000 > serverTime then
                if not self.cdHeroData then
                    self.cdHeroData = heroData
                elseif self.cdHeroData.battleCd < heroData.battleCd then
                    self.cdHeroData = heroData
                end
            end
        end
    end

    if self.cdHeroData then
        local time = self.cdHeroData.battleCd - Utils.getServerSec()
        self.layoutCd:SetActiveEx(true)
        if time > 0 then
            self.timer = gg.timer:startLoopTimer(0, 1, -1, function ()
                time = math.ceil(self.cdHeroData.battleCd / 1000) - Utils.getServerSec()

                local hms = gg.time.dhms_time({
                    day = false,
                    hour = false,
                    min = 1,
                    sec = 1
                }, time)
        
                self.txtCd.text = string.format("%s:%s", hms.min, hms.sec)

                if time < 0 then
                    gg.timer:stopTimer(self.timer)
                    self.layoutCd:SetActiveEx(false)
                    self:refreshCd()
                end
            end)
        else
            gg.timer:stopTimer(self.timer)
            self:refreshCd()
            -- self.layoutCd:SetActiveEx(false)
        end
    else
        self.layoutCd:SetActiveEx(false)
    end
end

function PersonalQuickSelectArmyItem:setSoldierMode(soldierMode)
    local soldierCount, soldierMaxCount = PersonalArmyUtils.getArmySoldierInfo(self.data, soldierMode)

    if soldierMode == PnlPersonalQuickSelectArmy.MODE_PERSONAL then
        self.txtForces.text = soldierCount .. "/" .. soldierMaxCount
    else
        self.txtForces.text = soldierCount
    end
end

function PersonalQuickSelectArmyItem:onRelease()
    gg.timer:stopTimer(self.timer)
end

return PnlPersonalQuickSelectArmy
