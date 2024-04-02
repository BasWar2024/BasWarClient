PnlMap = class("PnlMap", ggclass.UIBase)

PnlMap.infomationType = ggclass.UIBase.INFOMATION_NORMAL

function PnlMap:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onShowBoxInfomation", "onHideBoxInfomation", "onReShowBoxInfomation", "onShowGvgResult",
                   "onRefreshBoxInfomation", "onRedPointChange"}

    self.curPlanetCfgId = nil
    self.curWorldPos = {}
    self.isCollect = false
    self.isUnionCollect = false

    self.biasX = gg.sceneManager.biasX
    self.biasY = gg.sceneManager.biasY

end

function PnlMap:onAwake()
    self.view = ggclass.PnlMapView.new(self.pnlTransform)
    -- self.view.btnAttackSelf:SetActiveEx(false)
    -- self.view.btnAttackSelfQuick:SetActiveEx(false)
    local globalCfg = cfg["global"]
    self.leagueMakeResCD = globalCfg.LeagueMakeResCD.intValue
    self.leagueMakeHYCD = globalCfg.LeagueMakeHYCD.intValue
    self.muneButton = MuneButton.new(self.view.muneButton)
    self.starMakePointCD = globalCfg.StarMakePointCD.intValue
    self.redPointBtnMap = {
        [RedPointChat.__name] = self.view.btnChat
    }

end

function PnlMap:onShow()
    self:bindEvent()
    self:setSoldier()
    self.view.boxInfomation:SetActive(false)
    self.curPlanetCfgId = nil
    self.view.txtSeason.text = GalaxyData.season

    local lifeTimeEnd = GalaxyData.lifeTimeEnd or 0
    gg.timer:stopTimer(self.txtTimeTimer)

    local daySec = 24 * 60 * 60
    if lifeTimeEnd > os.time() then
        self.txtTimeTimer = gg.timer:startLoopTimer(0, 1, -1, function()
            local time = lifeTimeEnd - os.time()
            if time > 0 then
                local hms = gg.time.dhms_time({
                    day = 1,
                    hour = 1,
                    min = 1,
                    sec = 1
                }, time)
                if time >= daySec then
                    self.view.txtTime.text = string.format("%sd %sh", hms.day, hms.hour)
                elseif time < 60 then
                    self.view.txtTime.text = string.format("%ss", hms.sec)
                else
                    self.view.txtTime.text = string.format("%sh %sm", hms.hour, hms.min)
                end
            else
                self.view.txtTime.text = string.format("season end")
                gg.timer:stopTimer(self.txtTimeTimer)
            end
        end)
    else
        self.view.txtTime.text = string.format("season end")
    end

    self.view.txtIntegralMap.text = GalaxyData.score

    self.selfUnionJod = {}
    for k, v in pairs(cfg["daoPosition"]) do
        if v.accessLevel == UnionData.myUnionJod then
            self.selfUnionJod = v
            break
        end
    end

    self.view.btnAttackSelfEditAuto:SetActiveEx(EditData.isEditMode)

    self:initRedPoint()
end

function PnlMap:initRedPoint()
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function PnlMap:onRedPointChange(_, name, isRed)
    if self.redPointBtnMap[name] then
        RedPointManager:setRedPoint(self.redPointBtnMap[name], isRed)
    end
end

function PnlMap:onHide()
    self:releaseEvent()
    -- gg.event:dispatchEvent("onReturnSpineAni", 4)
    gg.galaxyManager:unLoadGalaxy()
    gg.timer:stopTimer(self.txtTimeTimer)
    self:stopStatusTimer()
    RedPointManager:releaseAllRedPoint()
end

function PnlMap:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)
    CS.UIEventHandler.Get(view.btnRank):SetOnClick(function()
        self:onBtnRank()
    end)
    CS.UIEventHandler.Get(view.btnReward):SetOnClick(function()
        self:onBtnReward()
    end)
    CS.UIEventHandler.Get(view.btnBattleReport):SetOnClick(function()
        self:onBtnBattleReport()
    end)
    CS.UIEventHandler.Get(view.btnCollection):SetOnClick(function()
        self:onBtnCollection(1)
    end)
    CS.UIEventHandler.Get(view.btnUnionCollection):SetOnClick(function()
        self:onBtnCollection(2)
    end)
    CS.UIEventHandler.Get(view.btnDel):SetOnClick(function()
        self:onBtnDel()
    end)
    CS.UIEventHandler.Get(view.btnCheck):SetOnClick(function()
        self:onBtnCheck()
    end)
    CS.UIEventHandler.Get(view.btnAttack):SetOnClick(function()
        self:onBtnAttackSelf()
    end)
    CS.UIEventHandler.Get(view.btnAttackUnion):SetOnClick(function()
        self:onBtnAttack()
    end)
    CS.UIEventHandler.Get(view.btnEnter):SetOnClick(function()
        self:onBtnEnter()
    end)
    CS.UIEventHandler.Get(view.btnMove):SetOnClick(function()
        self:onBtnMove()
    end)
    CS.UIEventHandler.Get(view.btnShare):SetOnClick(function()
        self:onBtnShare()
    end)
    CS.UIEventHandler.Get(view.btnChat):SetOnClick(function()
        self:onBtnChat()
    end)
    CS.UIEventHandler.Get(view.btnChain):SetOnClick(function()
        self:onBtnChain()
    end)
    CS.UIEventHandler.Get(view.btnBeginGrid):SetOnClick(function()
        self:onBtnBeginGrid()
    end)

    -- self:setOnClick(view.btnAttackSelf, gg.bind(self.onBtnAttackSelf, self))
    -- self:setOnClick(view.btnAttackSelfQuick, gg.bind(self.onBtnAttackSelfQuick, self))
    self:setOnClick(view.btnAttackSelfEditAuto, gg.bind(self.onBtnAttackSelfEditAuto, self))
    self:setOnClick(view.btnPersionPlot, gg.bind(self.onBtnPersionPlot, self))
    self:setOnClick(view.btnSmallMap, gg.bind(self.onBtnSmallMap, self))

end

function PnlMap:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnReturn)
    CS.UIEventHandler.Clear(view.btnRank)
    CS.UIEventHandler.Clear(view.btnReward)
    CS.UIEventHandler.Clear(view.btnBattleReport)
    CS.UIEventHandler.Clear(view.btnCollection)
    CS.UIEventHandler.Clear(view.btnUnionCollection)
    CS.UIEventHandler.Clear(view.btnDel)
    CS.UIEventHandler.Clear(view.btnCheck)
    CS.UIEventHandler.Clear(view.btnAttack)
    CS.UIEventHandler.Clear(view.btnAttackUnion)
    CS.UIEventHandler.Clear(view.btnEnter)
    CS.UIEventHandler.Clear(view.btnAttackSelfEditAuto)
    CS.UIEventHandler.Clear(view.btnPersionPlot)
    CS.UIEventHandler.Clear(view.btnSmallMap)
    CS.UIEventHandler.Clear(view.btnMove)
    CS.UIEventHandler.Clear(view.btnShare)
    CS.UIEventHandler.Clear(view.btnChat)
    CS.UIEventHandler.Clear(view.btnChain)
    CS.UIEventHandler.Clear(view.btnBeginGrid)
end

function PnlMap:onDestroy()
    local view = self.view

    self.muneButton:release()
    self.muneButton = nil
end

function PnlMap:onBtnReturn()
    gg.galaxyManager:destroyGalaxy()
    gg.sceneManager:returnBaseScene()
    self:close()
end

function PnlMap:onBtnRank()
    gg.uiManager:openWindow("PnlLeagueRank")
end

function PnlMap:onBtnReward()
    GalaxyData.C2S_Player_GetMyStarmapRewardList()

end

function PnlMap:onBtnBattleReport()
    gg.uiManager:openWindow("PnlUnionWarReport")

    -- if #UnionData.unionReports > 0 then
    --     gg.uiManager:openWindow("PnlUnionWarReport")
    -- else
    --     UnionData.C2S_Player_QueryUnionStarmapCampaignReports(1, 5)
    -- end
end

function PnlMap:onBtnChat()
    gg.uiManager:openWindow("PnlChat")
    gg.buildingManager:cancelBuildOrMove()

    -- gg.uiManager:showTip("currently unavailable")
end

function PnlMap:onBtnChain()
    local contenGrid = gg.galaxyManager:getOnLookContenCfg()
    local chainID = contenGrid.chainID
    -- 5.23 ""

    --gg.uiManager:openWindow("PnlMapEntrance", chainID)
end

function PnlMap:onBtnBeginGrid()
    local endCfg = gg.galaxyManager:getGalaxyCfg(UnionData.beginGridId)
    if endCfg then
        gg.event:dispatchEvent("onJumpGalaxyGrid", endCfg, true)
    else
        gg.uiManager:showTip(Utils.getText("league_NoBeginGrid"))
    end
end

function PnlMap:onBtnDel()
    self.plotCfg = gg.galaxyManager:getGalaxyCfg(self.curPlanetCfgId)

    local txt = string.format(Utils.getText("league_GiveUp_AskText"), self.plotCfg.name)

    local callbackYes = function()
        GalaxyData.C2S_Player_GiveUpMyGrid(self.curPlanetCfgId)
    end

    local args = {
        txt = txt,
        callbackYes = callbackYes
    }

    gg.uiManager:openWindow("PnlAlert", args)

    self:onHideBoxInfomation()
end

function PnlMap:onBtnCollection(type)
    local curCfg = gg.galaxyManager:getGalaxyCfg(self.curPlanetCfgId)

    if type == 1 then

        if not self.isCollect then
            -- ""
            local args = {
                type = 1,
                name = curCfg.name,
                callback = function(mark)
                    GalaxyData.C2S_Player_AddMyFavoriteGrid(self.curPlanetCfgId, mark)
                    self.isCollect = not self.isCollect
                    self:setCollectBtn()
                end
            }

            gg.uiManager:openWindow("PnlCollections", args)
        else
            -- ""
            GalaxyData.C2S_Player_DelMyFavoriteGrid(self.curPlanetCfgId)
            self.isCollect = not self.isCollect
            self:setCollectBtn()
        end
    else
        if self.selfUnionJod.isCollect ~= 1 then
            gg.uiManager:showTip("No authority for this action")
            return
        end

        if not self.isUnionCollect then
            -- ""
            local args = {
                type = 2,
                name = curCfg.name,
                callback = function(mark)
                    GalaxyData.C2S_Player_AddUnionFavoriteGrid(self.curPlanetCfgId, mark)
                    self.isUnionCollect = not self.isUnionCollect
                    self:setCollectBtn()
                end
            }

            gg.uiManager:openWindow("PnlCollections", args)

        else
            -- ""
            GalaxyData.C2S_Player_DelUnionFavoriteGrid(self.curPlanetCfgId)
            self.isUnionCollect = not self.isUnionCollect
            self:setCollectBtn()
        end
    end

end

function PnlMap:onBtnShare()
    local callbackYes = function()
        local curCfg = gg.galaxyManager:getGalaxyCfg(self.curPlanetCfgId)
        local msg = string.format("I share a coordinate(x:%s y:%s)", curCfg.pos.x, curCfg.pos.y)
        ChatData.C2S_Player_SendChatMsg(msg, constant.CHAT_TYPE_UNION, 1)
    end

    local txtTitel = Utils.getText("universal_Ask_Title")
    local txtTips = Utils.getText("universal_Ask_ShareChat")

    local txtNo = Utils.getText("universal_Ask_BackButton")
    local txtYes = Utils.getText("universal_ConfirmButton")

    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtYes = txtYes,
        callbackYes = callbackYes,
        txtNo = txtNo
    }
    gg.uiManager:openWindow("PnlAlertNew", args)

end

function PnlMap:onBtnCheck()
    self:applyForScoutStarmapGrid()
end

-- ""，""
-- signPosId : ""
function PnlMap:onBtnAttack()
    if self.selfUnionJod.isAttack ~= 1 then
        gg.uiManager:showTip("No authority for this action")
        return
    end

    self:onHideBoxInfomation()

    if gg.galaxyManager.galaxyMap:getAround(self.curPlanetCfgId) then
        local starCfg = gg.galaxyManager:getGalaxyCfg(self.curPlanetCfgId)

        local gridCount = GalaxyData.StarmapGridCountData.uGridCount or 0
        local gridCountMax = GalaxyData.StarmapGridCountData.uGridMax or 1
        if gridCount >= gridCountMax then
            local args = {
                txtTitel = "Alert",
                txtTips = Utils.getText("league_DaoPoltMaxTips"),
                txtYes = Utils.getText("universal_DetermineButton"),
                callbackYes = function()
                    UnionUtil.openEditArmyView(self.curPlanetCfgId, constant.UNION_TYPE_ARMY_UNION)
                end,
                txtNo = Utils.getText("universal_Ask_BackButton"),
                bigSize = true
            }
            gg.uiManager:openWindow("PnlAlertNew", args)
            return
        else
            UnionUtil.openEditArmyView(self.curPlanetCfgId, constant.UNION_TYPE_ARMY_UNION)
        end
    else
        gg.uiManager:showTip(Utils.getText("league_CannotAttack"))
    end

    -- local signPosId = 1
    -- local operates = self:getUnionBattleOperate(signPosId)
    -- BattleData.C2S_Player_StartBattle(BattleData.BATTLE_TYPE_RES_PLANNET, self.curPlanetCfgId, nil, 1, 1,
    --     signPosId, "1", operates)
end

function PnlMap:personAtk()
    local signPosId = 3
    gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {
        fightCB = function(armys)
            local battleArmys = {}
            for key, value in pairs(armys) do
                local battleArmy = PersonalArmyUtils.personalArmy2BattleArmy(value.armyId)
                if battleArmy then
                    table.insert(battleArmys, battleArmy)
                end
            end

            BattleData.StartUnionBattle(BattleData.ARMY_TYPE_SELF, self.curPlanetCfgId, battleArmys, signPosId,
                CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(signPosId), nil)
        end,
        selectCount = 5,
        isEnableUnionMode = true,
        isGVG = true
    })
end

function PnlMap:onBtnAttackSelf()
    -- if true then
    --     UnionUtil.openEditArmyView(planetId)
    --     return
    -- end
    local vipLevel = VipData.vipData.vipLevel
    local vipCfg = cfg.vip[vipLevel]

    local gridCount = GalaxyData.StarmapGridCountData.pGridCount or 0
    local gridCountMax = vipCfg.gridPlayerMax or 1

    if gridCount >= gridCountMax then
        local args = {
            txtTitel = Utils.getText("universal_Ask_Title"),
            txtTips = Utils.getText("league_OwnPoltMaxTips"),
            txtYes = Utils.getText("universal_DetermineButton"),
            callbackYes = gg.bind(self.personAtk, self),
            txtNo = Utils.getText("universal_Ask_BackButton"),
            bigSize = true
        }
        gg.uiManager:openWindow("PnlAlertNew", args)
        return
    end

    self:personAtk()
    self:onHideBoxInfomation()
end

function PnlMap:onBtnAttackSelfQuick()
    local army = UnionUtil.quickGetSelfOneArmy()
    UnionData.updateUnionArmy(army)
    local signPosId = 3
    local armys = UnionUtil.getUnionBattleArmys()
    BattleData.StartUnionBattle(BattleData.ARMY_TYPE_SELF, self.curPlanetCfgId, armys, signPosId,
        CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(signPosId))
    UnionData.clearUnionArmy()
end

function PnlMap:onBtnAttackSelfEditAuto()
    -- EditData.startUnionSelfAutoBattle(true, self.curPlanetCfgId)

    gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {
        fightCB = function(selectingArmys)

            local battleArmys = {}
            for key, value in pairs(selectingArmys) do
                local battleArmy = PersonalArmyUtils.personalArmy2BattleArmy(value.armyId)
                if battleArmy then
                    table.insert(battleArmys, battleArmy)
                end
            end

            BattleData.StartUnionBattle(BattleData.ARMY_TYPE_SELF, self.curPlanetCfgId, battleArmys, signPosId,
                CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(signPosId),
                BattleData.BATTLE_TYPE_SELF_EDIT_AUTO)
        end,
        selectCount = 5,
        isEnableUnionMode = true
    })

    -- UnionUtil.openEditArmyView(self.curPlanetCfgId, constant.UNION_TYPE_ARMY_UNION)
end

function PnlMap:onBtnPersionPlot()
    gg.uiManager:openWindow("PnlStarMapPlot", {
        type = PnlStarMapPlot.TYPE_PERSON
    })
end

function PnlMap:onBtnSmallMap()
    GalaxyData.C2S_Player_StarmapMinimap()
end

-- ""
-- function PnlMap:getUnionBattleOperate(signPosId)
--     local operates = {}

--     for k, v in pairs(BattleData.UnionBattleOperOrders) do
--         operates[k] = {}
--         operates[k].GameFrame = k
--         operates[k].Order = v
--         local pos = self:getUnionBattleLandPos(signPosId, k)
--         operates[k].X = pos.x
--         operates[k].Y = 0
--         operates[k].Z = pos.z
--     end

--     return operates
-- end

-- function PnlMap:getUnionBattleLandPos(signPosId, i)
--     local pos = {}

--     if signPosId == 1 then
--         pos.x = BattleData.BATTLE_MAX_POS
--         pos.z = BattleData.UnionBattleLandCoord[i]
--     elseif signPosId == 2 then
--         pos.x = BattleData.UnionBattleLandCoord[i]
--         pos.z = BattleData.BATTLE_MIN_POS
--     elseif signPosId == 3 then
--         pos.x = BattleData.BATTLE_MIN_POS
--         pos.z = BattleData.UnionBattleLandCoord[i]
--     else 
--         pos.x = BattleData.UnionBattleLandCoord[i]
--         pos.z = BattleData.BATTLE_MAX_POS
--     end

--     return pos
-- end

function PnlMap:onBtnEnter()
    self:applyForScoutStarmapGrid()
end

function PnlMap:onBtnMove()
    -- if self.selfUnionJod.canMoveStartGrid == 1 then

    -- else
    --     gg.uiManager:showTip(Utils.getText("league_Move_Failed"))
    -- end

    local args = {
        txtTitel = Utils.getText("universal_Ask_Title"),
        txtTips = Utils.getText("league_Move_AskMove"),
        txtYes = Utils.getText("universal_DetermineButton"),
        callbackYes = function()
            GalaxyData.C2S_Player_StarmapTransferBeginGrid(self.curPlanetCfgId)
        end,
        txtNo = Utils.getText("universal_Ask_BackButton"),
        bigSize = true
    }
    gg.uiManager:openWindow("PnlAlertNew", args)

end

function PnlMap:applyForScoutStarmapGrid()
    gg.uiManager:openWindow("PnlLoading", nil, function()
        GalaxyData.C2S_Player_scoutStarmapGrid(self.curPlanetCfgId)
    end)
end

function PnlMap:setSoldier()
    self.soldierDataList = {}
    for key, value in pairs(BuildData.shipExistSoliderData) do
        if value.soliderCfgId and value.soliderCfgId > 0 then
            table.insert(self.soldierDataList, value)
        end
    end
    local soldierCount = #self.soldierDataList

    -- print("aaa", table.dump(self.soldierDataList))

    for i = 1, 8, 1 do
        local key = "boxSoldierInMap" .. i
        local tans = self.view[key]

        if i <= soldierCount then
            tans.gameObject:SetActive(true)
            local soliderCfgId = self.soldierDataList[i].soliderCfgId
            local soliderCount = self.soldierDataList[i].soliderCount
            local soldierLevel = BuildData.soliderLevelData[soliderCfgId].level
            local soldierCfg = cfg.getCfg("solider", soliderCfgId, soldierLevel)
            local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", soldierCfg.icon .. "_A")
            gg.setSpriteAsync(tans:Find("IconSoldier"):GetComponent(UNITYENGINE_UI_IMAGE), icon)
            tans:Find("TxtSoldierCount"):GetComponent(UNITYENGINE_UI_TEXT).text = soliderCount
        else
            tans.gameObject:SetActive(false)
        end
    end
    -- local heroItem = self.view.transform:Find("BgSoldier/BoxHeroInMap")

    -- if HeroData.ChooseingHero then
    --     heroItem.gameObject:SetActive(true)
    --     local heroCfgId = HeroData.ChooseingHero.cfgId
    --     local heroLevel = HeroData.ChooseingHero.level
    --     local heroQuality = HeroData.ChooseingHero.quality
    --     local heroCfg = cfg.getCfg("hero", heroCfgId, heroLevel, heroQuality)
    --     local heroIcon = gg.getSpriteAtlasName("Hero_A_Atlas", heroCfg.icon .. "_A")
    --     gg.setSpriteAsync(heroItem:Find("IconHero"):GetComponent(UNITYENGINE_UI_IMAGE), heroIcon)

    --     local sprite = gg.getSpriteAtlasName("Battle_Atlas", "item_Bg_" .. heroQuality)
    --     gg.setSpriteAsync(heroItem:GetComponent(UNITYENGINE_UI_IMAGE), sprite)

    --     heroItem:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = "LV." .. heroLevel

    --     local selectSkillCfgId = HeroData.ChooseingHero["skill" .. HeroData.ChooseingHero.selectSkill]
    --     local selectSkillLevel = HeroData.ChooseingHero["skillLevel" .. HeroData.ChooseingHero.selectSkill]
    --     local skillCfg = cfg.getCfg("skill", selectSkillCfgId, selectSkillLevel)
    --     local skillIcon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")
    --     gg.setSpriteAsync(heroItem:Find("IconSkill"):GetComponent(UNITYENGINE_UI_IMAGE), skillIcon)

    --     if soldierCount <= 4 then
    --         local posX = 20 + soldierCount * 140
    --         self.view.transform:Find("BgSoldier"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(148)
    --         heroItem:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(posX, -67)
    --     else
    --         self.view.transform:Find("BgSoldier"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(282)
    --         heroItem:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(580, -207)
    --     end
    -- else
    --     heroItem.gameObject:SetActive(false)
    -- end

end

function PnlMap:onShowBoxInfomation(args, cfgId, wroldPos, isShow)
    self.curWorldPos = wroldPos
    if isShow then
        self:setBoxInfomationActive(true, cfgId, wroldPos)
    else
        if self.curPlanetCfgId then
            if cfgId == self.curPlanetCfgId then
                self:setBoxInfomationActive(false)
            else
                self:setBoxInfomationActive(true, cfgId, wroldPos)
            end
        else
            self:setBoxInfomationActive(true, cfgId, wroldPos)
        end
    end

end

function PnlMap:onHideBoxInfomation()
    -- self:setBoxInfomationActive(false)
    self.view.boxInfomation:SetActive(false)

end

function PnlMap:onReShowBoxInfomation()
    if self.curPlanetCfgId then
        self:setBoxInfomationActive(true, self.curPlanetCfgId, self.curWorldPos)
    end
end

function PnlMap:onRefreshBoxInfomation(args, cfgId)
    if self.curPlanetCfgId and self.curPlanetCfgId == cfgId then
        self:setBoxInfomationActive(true, self.curPlanetCfgId, self.curWorldPos)
    end
end

function PnlMap:setBoxInfomationActive(bool, cfgId, wroldPos)
    if gg.galaxyManager:isSpecialGround(cfgId) == -1 then
        bool = false
    end

    self.view.boxInfomation:SetActive(bool)
    if bool then
        if UnionData.beginGridId == 0 then
            gg.uiManager:showTip(Utils.getText("league_NoDao"))
        end
        self.curPlanetCfgId = cfgId
        self:setBoxInfomation(wroldPos)
    else
        self.curPlanetCfgId = nil
        self:stopStatusTimer()
    end
end

function PnlMap:stopStatusTimer()
    if self.statusTimer then
        gg.timer:stopTimer(self.statusTimer)
        self.statusTimer = nil
    end
end

function PnlMap:setBoxInfomation(wroldPos)
    local view = self.view
    local pos = UnityEngine.Camera.main:WorldToScreenPoint(wroldPos)
    local vec2 = Vector2.New(pos.x * self.biasX, pos.y * self.biasY)
    view.boxInfomation.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = vec2
    local newScreenWidth = UnityEngine.Screen.width
    if vec2.x <= newScreenWidth / 2 then
        view.imgLine.transform.localRotation = Quaternion.Euler(0, 0, 50)
        view.bgInfomation.localPosition = Vector3(518, 368, 0)
    else
        view.imgLine.transform.localRotation = Quaternion.Euler(0, 180, 50)
        view.bgInfomation.localPosition = Vector3(-518, 368, 0)
    end
    local starCfg = gg.galaxyManager:getGalaxyCfg(self.curPlanetCfgId)
    local starData = GalaxyData.galaxyBrief[self.curPlanetCfgId] or {
        belong = 0,
        isFavorite = 0,
        owner = {
            playerName = "",
            unionName = ""
        }
    }
    local starName = starCfg.name -- string.format("Lv.<color=#f8bb00>%s</color> %s", starCfg.level, starCfg.name)
    local starPos = string.format("X:%s Y:%s", starCfg.pos.x, starCfg.pos.y)
    local ownerName = starData.owner.playerName
    local unionName = starData.owner.unionName
    local unionNum = starData.owner.unionNum

    local makeRes = 0
    if starCfg.perMakeRes[1] then
        makeRes = starCfg.perMakeRes[1][2]
    end
    local makeResTime = self.leagueMakeResCD
    if starCfg.belongType == 1 then
        makeResTime = self.leagueMakeHYCD
    end
    local perMakeRes = makeRes / 1000 * (3600 / makeResTime)
    local point = starCfg.point * 3600 / self.starMakePointCD
    view.txtName.text = starName
    view.txtPos.text = starPos
    view.txtOwner.text = ownerName
    view.txtUnion.text = unionName
    view.txtGuildNumber.text = unionNum
    view.txtHydroxyl.text = string.format("%0.0f /h", perMakeRes)
    view.txtIntegral.text = string.format("%0.0f /h", point)

    self.isCollect = false
    self.isUnionCollect = false

    if GalaxyData.myFavGrids[self.curPlanetCfgId] then
        self.isCollect = true
    end
    if GalaxyData.unionFavGrids[self.curPlanetCfgId] then
        self.isUnionCollect = true
    end

    self:setCollectBtn()
    self.view.statusTimeBg:SetActiveEx(false)
    self:stopStatusTimer()
    -- print("aaaaaaa", table.dump(starData))
    if starData.status then
        local timerFunc = function(ticket)
            self.view.statusTimeBg:SetActiveEx(true)
            if starData.belong == 0 or starData.belong == 1 or starData.belong == 2 then
                self.view.imgSelfTime:SetActiveEx(true)
                self.view.imgOtherTime:SetActiveEx(false)
            else
                self.view.imgSelfTime:SetActiveEx(false)
                self.view.imgOtherTime:SetActiveEx(true)
            end
            self.statusTimer = gg.timer:startLoopTimer(0, 1, -1, function()
                local time = ticket - Utils.getServerSec()
                -- print("aaaaa", time, ticket, Utils.getServerSec())
                if time > 0 then
                    local hms = gg.time.dhms_time({
                        day = false,
                        hour = true,
                        min = true,
                        sec = true
                    }, time)
                    self.view.txtStatusTime.text = string.format("%02s:%02s:%02s", hms.hour, hms.min, hms.sec)
                else
                    self.view.statusTimeBg:SetActiveEx(false)
                    self:stopStatusTimer()
                end

            end)
        end
        if starData.status == 1 then
            -- ""
            if starData.battleEndTick and starData.battleEndTick - Utils.getServerSec() > 0 then
                timerFunc(starData.battleEndTick)
            end
        elseif starData.status == 2 then
            -- ""
            -- print("bbbbb", starData.protectTime, Utils.getServerSec())
            if starData.protectTime and starData.protectTime - Utils.getServerSec() > 0 then
                timerFunc(starData.protectTime)
            end
        end
    end
    if starData.belong == 1 or starData.belong == 2 then
        -- ""
        view.btnEnter:SetActive(true)
        if starData.belong == 1 then
            view.btnDel:SetActive(true)
            view.btnEnter.transform.localPosition = Vector3(-81.6, -29, 0)
            view.btnDel.transform.localPosition = Vector3(81.6, -29, 0)
        else
            if starCfg.belongType == 1 and self.selfUnionJod.accessLevel > 0 then
                view.btnDel:SetActive(true)
                view.btnEnter.transform.localPosition = Vector3(-81.6, -29, 0)
                view.btnDel.transform.localPosition = Vector3(81.6, -29, 0)
            else
                view.btnDel:SetActive(false)
                view.btnEnter.transform.localPosition = Vector3(0, -29, 0)
            end
        end
        view.btnAttack:SetActiveEx(false)
        view.btnAttackUnion:SetActiveEx(false)
        view.btnCheck:SetActiveEx(false)
        view.btnMove:SetActiveEx(false)
    else
        -- ""
        view.btnEnter:SetActive(false)
        view.btnDel:SetActive(false)
        view.btnAttack:SetActiveEx(true)
        view.btnCheck:SetActiveEx(true)
        view.btnMove:SetActiveEx(false)

        -- ""
        view.btnAttackUnion:SetActiveEx(false)
        view.btnAttack.transform.localPosition = Vector3(81.6, -29, 0)
        view.btnCheck.transform.localPosition = Vector3(-81.6, -29, 0)

        -- "" [7.4]""（""） 1.""，""
        -- if starCfg.belongType == 1 then
        --     view.btnAttackUnion:SetActiveEx(true)
        --     view.btnAttack.transform.localPosition = Vector3(153, -29, 0)
        --     view.btnCheck.transform.localPosition = Vector3(0, -72, 0)
        -- else
        --     view.btnAttackUnion:SetActiveEx(false)
        --     view.btnAttack.transform.localPosition = Vector3(81.6, -29, 0)
        --     view.btnCheck.transform.localPosition = Vector3(-81.6, -29, 0)
        -- end
    end
    local resIconName = nil
    if starCfg.type == 3 then
        -- ""
        view.boxGet:SetActiveEx(false)
        view.txtAttTips.gameObject:SetActiveEx(false)
        view.bgInfomation:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(605.4, 168)
        view.bgInfomation:Find("GuildNumber").gameObject:SetActiveEx(true)
        view.bgInfomation:Find("OwnerName").gameObject:SetActiveEx(false)
        view.bgInfomation:Find("UnionName").gameObject:SetActiveEx(false)
        view.btnEnter:SetActive(false)
        view.btnDel:SetActive(false)
        view.btnAttack:SetActiveEx(false)
        view.btnAttackUnion:SetActiveEx(false)
        view.btnCheck:SetActiveEx(false)
        view.btnMove:SetActiveEx(true)

        resIconName = gg.getSpriteAtlasName("ResIcon_E_Atlas", "myplot_icon")
    else
        view.txtAttTips.gameObject:SetActiveEx(true)
        view.bgInfomation:Find("GuildNumber").gameObject:SetActiveEx(false)
        view.bgInfomation:Find("OwnerName").gameObject:SetActiveEx(true)
        view.bgInfomation:Find("UnionName").gameObject:SetActiveEx(true)
        local level = starCfg.level
        if level <= 0 then
            level = 1
        end
        local tip = string.format("league_UseAttack_%s_%s", starCfg.subType, level)
        view.txtAttTips.text = Utils.getText(tip)
        local resId = 0
        if starCfg.perMakeRes[1] then
            view.boxGet.transform:Find("Res/Res").gameObject:SetActiveEx(true)
            resId = starCfg.perMakeRes[1][1]
            resIconName = gg.getSpriteAtlasName("ResIcon_E_Atlas", constant.RES_2_CFG_KEY[resId].iconNameHead .. "E1")
            gg.setSpriteAsync(view.boxGet.transform:Find("Res/Res/Icon"):GetComponent(UNITYENGINE_UI_IMAGE),
                constant.RES_2_CFG_KEY[resId].iconBig)
        else
            view.boxGet.transform:Find("Res/Res").gameObject:SetActiveEx(false)
        end
        if point > 0 then
            view.boxGet.transform:Find("Res/Integral").gameObject:SetActiveEx(true)
        else
            view.boxGet.transform:Find("Res/Integral").gameObject:SetActiveEx(false)
        end
        if point <= 0 and perMakeRes <= 0 then
            view.boxGet:SetActiveEx(false)
            view.bgInfomation:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(605.4, 253)
        else
            view.boxGet:SetActiveEx(true)
            view.bgInfomation:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(605.4, 396)
        end
    end
    if resIconName then
        gg.setSpriteAsync(view.iconRes, resIconName, nil, nil, true)
    end
    view.txtCfgId.gameObject:SetActiveEx(false)
    if gg.galaxyManager.showCfgId then
        view.txtCfgId.text = self.curPlanetCfgId
        view.txtCfgId.gameObject:SetActiveEx(true)
    end
end

function PnlMap:setCollectBtn()
    local btn = self.view.btnCollection.transform
    if self.isCollect then
        btn:Find("Coll").gameObject:SetActive(true)
        btn:Find("NoColl").gameObject:SetActive(false)
    else
        btn:Find("Coll").gameObject:SetActive(false)
        btn:Find("NoColl").gameObject:SetActive(true)
    end
    local btnUnion = self.view.btnUnionCollection.transform
    if self.isUnionCollect then
        btnUnion:Find("Coll").gameObject:SetActive(true)
        btnUnion:Find("NoColl").gameObject:SetActive(false)
    else
        btnUnion:Find("Coll").gameObject:SetActive(false)
        btnUnion:Find("NoColl").gameObject:SetActive(true)
    end

end

function PnlMap:onShowGvgResult(args, data)
    gg.uiManager:openWindow("PnlGvgResult", data)
end

return PnlMap
