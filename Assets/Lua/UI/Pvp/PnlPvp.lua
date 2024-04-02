PnlPvp = class("PnlPvp", ggclass.UIBase)

function PnlPvp:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onPvpPlayerDataChange", "onVipPledgeChange", "onRankChange"}
end

function PnlPvp:onAwake()
    self.view = ggclass.PnlPvpView.new(self.pnlTransform)

    local view = self.view
    self.pvpPlayerItemList = {}
    for i = 1, view.layoutPlayers.childCount do
        self.pvpPlayerItemList[i] = PvpPlayerItem.new(view.layoutPlayers:GetChild(i - 1), self)
    end
    self.pvpStageBox = PvpStageBox.new(view.pvpStageBox)
end

function PnlPvp:onShow()
    self:bindEvent()
    -- gg.warCameraCtrl:stopMoveTimer()
    self.view.layoutPlayers:SetActiveEx(false)
    self.view.layoutBan:SetActiveEx(false)
    BattleData.C2S_Player_QueryPvpPlayers()
    RankData.C2S_Player_Rank_Info(RankData.RANK_TYPE_PVP)
    self.selectData = nil

    self:refreshAudit()
end

function PnlPvp:refreshAudit()
    local view = self.view
    if IsAuditVersion() then
        self.view.layoutPool:SetActiveEx(false)
        self.view.btnRewardSys:SetActiveEx(false)
        self.view.btnRewardHist:SetActiveEx(false)
    end
end

function PnlPvp:refresh()
    local view = self.view

    local findCount = BattleData.pvpData.refreshCount + 1
    local cost = 0
    if findCount == 0 then
        cost = cfg.global.FindPvpPlayersCostStarCoin.tableValue[1]
    else
        cost = cfg.global.FindPvpPlayersCostStarCoin.tableValue[findCount]
        if not cost then
            cost = cfg.global.FindPvpPlayersCostStarCoin.tableValue[#cfg.global.FindPvpPlayersCostStarCoin.tableValue]
        end
    end
    self.findCost = cost
    view.txtCostFind.text = Utils.getShowRes(cost)

    view.layoutPlayers:SetActiveEx(true)
    for index, value in ipairs(self.pvpPlayerItemList) do
        value:setData(BattleData.pvpData.enemies[index])
    end

    -- self:selectEnemy(BattleData.pvpData.enemies[1])
    self:selectEnemy(nil)

    view.txtAttackCount1.text = BattleData.pvpData.battleNum .. "/" .. BattleData.pvpData.battleTotal
    -- view.txtAttackCount2.text = "/" .. BattleData.pvpData.battleTotal

    self:setNumbers(view.hydNumbers, math.floor(BattleData.pvpData.jackpot / 1000))
    view.txtMyReward.text = Utils.getShowRes(BattleData.pvpData.myreward)
    -- self.pvpStageBox:setBlade(BattleData.pvpData.myScore)
    PlayerData.myInfo.badge = BattleData.pvpData.myScore
    gg.event:dispatchEvent("onPlayerInfoChange", PlayerData.myInfo)
    self:setBlade(BattleData.pvpData.myScore)
    self:refreshReward()

    local daySec = 24 * 60 * 60
    gg.timer:stopTimer(self.endTimeTimer)
    if BattleData.pvpData.lifeTimeEnd > os.time() then
        self.endTimeTimer = gg.timer:startLoopTimer(0, 1, -1, function ()
            local time = BattleData.pvpData.lifeTimeEnd - os.time()
            local hms = gg.time.dhms_time({day=1,hour=1,min=1,sec=1}, time)
            if time >= 0 then
                if time >= daySec then
                    self.view.txtEndTime.text = string.format("%sd %sh", hms.day, hms.hour)
                elseif time < 60 then
                    self.view.txtEndTime.text = string.format("%ss", hms.sec)
                else
                    self.view.txtEndTime.text = string.format("%sh %sm", hms.hour, hms.min)
                end
                -- view.txtEndTime.text = string.format("%sd%sh%sm%ss", hms.day, hms.hour, hms.min, hms.sec)
            else
                view.txtEndTime.text = Utils.getText("pvp_SeasonOver") --"season end"
                gg.timer:stopTimer(self.endTimeTimer)
            end
        end)
    else
        view.txtEndTime.text = Utils.getText("pvp_SeasonOver")
    end

    gg.timer:stopTimer(self.banTimer)
    if BattleData.pvpData.banLessTimeEnd > os.time() then
        view.layoutBan:SetActiveEx(true)
        self.banTimer = gg.timer:startLoopTimer(0, 1, -1, function ()
            local time = BattleData.pvpData.banLessTimeEnd - os.time()
            local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
            if time >= 0 then
                view.txtBanTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
            else
                gg.timer:stopTimer(self.banTimer)
                view.layoutBan:SetActiveEx(false)
            end
        end)
    else
        view.layoutBan:SetActiveEx(false)
    end
end

function PnlPvp:setBlade(blade)
    local stageCfg, nextStageCfg = PvpUtil.bladge2StageCfg(blade)
    gg.setSpriteAsync(self.view.imgStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))

    if nextStageCfg then
        self.view.txtStage.gameObject:SetActiveEx(true)
        self.view.imgProgress.fillAmount = blade / nextStageCfg.startBladge
        self.view.txtStage.text = blade .. "/" .. nextStageCfg.startBladge
    
    else
        self.view.txtStage.gameObject:SetActiveEx(false)
        self.view.imgProgress.fillAmount = 1
    end
end

function PnlPvp:onRankChange(event, rankType, version)
    if rankType == RankData.RANK_TYPE_PVP then
        local rankDataList = RankData.rankMap[RankData.RANK_TYPE_PVP].dataList
        local mitTotalCount = 0
        for key, value in pairs(BattleData.pvpBackGroundCfg.reward) do
            if rankDataList[value.max_rank]  then
                mitTotalCount = mitTotalCount + (value.max_rank - value.min_rank + 1) * value.mit
            elseif rankDataList[value.min_rank] then
                mitTotalCount = mitTotalCount + (#rankDataList - value.min_rank + 1) * value.mit
            end
        end
        self:setNumbers(self.view.mitNumbers, Utils.getShowRes(mitTotalCount))
    end
end

function PnlPvp:setNumbers(numberList, str)
    local chars = string.utf8chars(str)
    if #chars < #numberList then
        for i = #chars + 1, #numberList, 1 do
            table.insert(chars, 1, 0)
        end
    end

    for index, value in ipairs(numberList) do
        value.text.text = chars[index]
    end
end

function PnlPvp:refreshReward()
    local curLevelCfg = Utils.getCurVipCfgByMit(VipData.vipData.mit)
    self.view.txtReward.text = Utils.getShowRes(cfg.global.PVPHydroxylBase.intValue + curLevelCfg.hydroxylAddition)

end

function PnlPvp:selectEnemy(data)
    local view = self.view

    if self.selectData == data then
        data = nil
    end
    self.selectData = data

    for key, value in pairs(self.pvpPlayerItemList) do
        value:refreshSelect()
    end

    if not data then
        -- view.layoutEnemyInfo:SetActiveEx(false)
        view.layoutAtk:SetActiveEx(false)
        return
    end

    -- view.layoutEnemyInfo:SetActiveEx(true)
    view.txtEnemyName.text = data.playerName
    local level = math.min(#cfg.pvpCost, math.max(1, data.playerLevel))
    local costCfg = cfg.pvpCost[level]
    view.txtCostScout.text = costCfg.scoutCost / 1000
    view.txtCostAttack.text = costCfg.fightCost / 1000

    local stageCfg = PvpUtil.bladge2StageCfg(data.playerScore)

    gg.setSpriteAsync(view.imgBgEnemyStage, string.format("PvpStage_Atlas[dan round_icon_%s]", stageCfg.stage))
    gg.setSpriteAsync(view.imgEnemyStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))

    view.txtEnemyStage:SetLanguageKey("pvpStageName_" .. stageCfg.stage)
    view.txtEnemyStageGradient:SetColor(constant.COLOR_PVP_STAGE[stageCfg.stage][1],
        constant.COLOR_PVP_STAGE[stageCfg.stage][2])

    if data.unionName and data.unionName ~= "" then
        view.bgDao:SetActiveEx(true)
        view.txtDao.text = data.unionName
    else
        view.bgDao:SetActiveEx(false)
    end

    view.layoutAtk:SetActiveEx(true)
    for index, value in ipairs(self.pvpPlayerItemList) do
        if data == value.data then
            view.layoutAtk.transform.position = value.pointAtkBtn.transform.position
        end
    end
end

function PnlPvp:onHide()
    self:releaseEvent()

    gg.timer:stopTimer(self.banTimer)
    -- gg.event:dispatchEvent("onReturnSpineAni", 3)
    gg.timer:stopTimer(self.endTimeTimer)
end

function PnlPvp:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnPlus):SetOnClick(function()
        self:onBtnPlus()
    end)
    CS.UIEventHandler.Get(view.btnFind):SetOnClick(function()
        self:onBtnFind()
    end)
    CS.UIEventHandler.Get(view.btnScout):SetOnClick(function()
        self:onBtnScout()
    end)
    CS.UIEventHandler.Get(view.btnAttack):SetOnClick(function()
        self:onBtnAttack()
    end)
    CS.UIEventHandler.Get(view.btnRank):SetOnClick(function()
        self:onBtnRank()
    end)
    CS.UIEventHandler.Get(view.btnInfo):SetOnClick(function()
        self:onBtnInfo()
    end)

    self:setOnClick(view.btnRewardSys, gg.bind(self.onBtnRewardSys, self))
    self:setOnClick(view.btnRewardHist, gg.bind(self.onBtnRewardHist, self))
end

function PnlPvp:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnPlus)
    CS.UIEventHandler.Clear(view.btnFind)
    CS.UIEventHandler.Clear(view.btnScout)
    CS.UIEventHandler.Clear(view.btnAttack)
    CS.UIEventHandler.Clear(view.btnRank)
    CS.UIEventHandler.Clear(view.btnInfo)

end

function PnlPvp:onDestroy()
    local view = self.view

    for key, value in pairs(self.pvpPlayerItemList) do
        value:release()
    end

    self.pvpStageBox:release()
end

function PnlPvp:onPvpPlayerDataChange()
    self:refresh()
end

function PnlPvp:onVipPledgeChange()
    self:refreshReward()
end

function PnlPvp:onBtnClose()
    self:close()
end

function PnlPvp:onBtnPlus()
    Utils.buyPvpCount()
end

function PnlPvp:onBtnFind()
    if self.findCost > ResData.getStarCoin() then
        gg.uiManager:showTip("not enought Star coin")
        return
    end
    self:selectEnemy(nil)
    self.view.layoutPlayers:SetActiveEx(false)
    BattleData.C2S_Player_ChangePvpPlayers()
end

function PnlPvp:onBtnScout()
    BattleData.setPvpScoutReturnOpenWindow({
        name = "PnlPvp",
        type = PnlMatch.TYPE_MATCH
    })
    gg.uiManager:openWindow("PnlLoading", nil, function()
        BattleData.C2S_Player_PvpScoutFoundation(self.selectData.playerId)
        self:close()
    end)
end

function PnlPvp:onBtnAttack()
    gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", 
    {
        fightCB = function (armys)
            if gg.warShip then
                local isAlert, life = gg.warShip:checkAlertLife()
                if isAlert then
                    local callbackYes = function()
                        self:attack()
                    end
                    local txt = string.format("warship life is %s, are you sure attack?", life)
                    gg.uiManager:openWindow("PnlAlert", {
                        callbackYes = callbackYes,
                        txt = txt
                    })
                    return
                end
            end
            self:attack(armys[1].armyId)
        end,

        playerInfo = {
            head = self.selectData.playerHead,
            score = self.selectData.playerScore,
            name = self.selectData.playerName,
        }
    })

end

function PnlPvp:attack(armyId)
    -- Utils.checkIsCanPvp(true, true, true)
    if not Utils.checkIsCanPvp(true, true, true) then
        return
    end

    local enemy = BattleData.pvpData.enemies[math.random(1, #BattleData.pvpData.enemies)]
    BattleData.startPvp(BattleData.BATTLE_TYPE_BASE, enemy.playerId, armyId, self)

    -- if self.selectData.canAttack then
    --     BattleData.startPvp(BattleData.BATTLE_TYPE_BASE, self.selectData.playerId, armyId, self)
    --     -- if Utils.checkPvpFightCount(true) then
    --     --     BattleData.startPvp(BattleData.BATTLE_TYPE_BASE, self.selectData.playerId, armyId, self)
    --     -- end
    -- end
end

function PnlPvp:onBtnRank()
    gg.uiManager:openWindow("PnlPvpRank")
end

function PnlPvp:onBtnInfo()
    gg.uiManager:openWindow("PnlBattleReport", BattleData.BATTLE_TYPE_BASE)
end

function PnlPvp:onBtnRewardSys()
    gg.uiManager:openWindow("PnlPvpRewardRule")
end

function PnlPvp:onBtnRewardHist()
    gg.uiManager:openWindow("PnlPvpHistory")
end

-- self:setOnClick(view.btnRewardSys, gg.bind(self.onBtnRewardSys, self))
-- self:setOnClick(view.btnRewardHist, gg.bind(self.onBtnRewardHist, self))

--------------------------------------------------------------------------
PvpPlayerItem = PvpPlayerItem or class("PvpPlayerItem", ggclass.UIBaseItem)
function PvpPlayerItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PvpPlayerItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self), nil, nil, false)

    self.imgHead = self:Find("LayoutHead/MaskHead/ImgHead", "Image")

    self.bgStage = self:Find("BgStage", "Image")
    self.imgBgStage = self:Find("BgStage/ImgBgStage", "Image")
    self.txtStage = self:Find("BgStage/TxtStage", typeof(CS.TextYouYU))

    self.txtName = self:Find("BgStage/TxtName", typeof(CS.TextYouYU))
    self.imgStage = self:Find("BgStage/TxtName/ImgStage", "Image")

    self.txtStageGradient = self.txtStage.transform:GetComponent(typeof(CS.TextGradient))

    self.imgSelect = self:Find("ImgSelect")
    self.pointAtkBtn = self:Find("PointAtkBtn")
end

function PvpPlayerItem:setData(data)
    self.data = data

    if not data then
        self:setActive(false)
        return
    end

    local stageCfg = PvpUtil.bladge2StageCfg(data.playerScore)

    -- gg.setSpriteAsync(self.bgStage, string.format("PvpStage_Atlas[dan floor_icon_%s]", stageCfg.stage))
    -- gg.setSpriteAsync(self.imgBgStage, string.format("PvpStage_Atlas[dan round_icon_%s]", stageCfg.stage))

    gg.setSpriteAsync(self.imgStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))

    -- self.txtName.text = data.playerName
    self.txtName.text = "GB COMMANDER"

    -- self.txtStage:SetLanguageKey("pvpStageName_" .. stageCfg.stage)
    -- self.txtStageGradient:SetColor(constant.COLOR_PVP_STAGE[stageCfg.stage][1], constant.COLOR_PVP_STAGE[stageCfg.stage][2])

    self:setActive(true)

    -- gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(data.playerHead))
    gg.setSpriteAsync(self.imgHead, "Head_Atlas[profile phpto 21_icon]")
end

function PvpPlayerItem:refreshSelect()
    if self.initData.selectData and self.initData.selectData == self.data then
        -- self.transform.localScale = Vector3(1.2, 1.2, 1.2)
        self.imgSelect:SetActiveEx(true)
    else
        self.imgSelect:SetActiveEx(false)
        --self.transform.localScale = Vector3(1, 1, 1)
    end
end

function PvpPlayerItem:onBtnItem()
    self.initData:selectEnemy(self.data)
end
--------------------------------------------------------------------------

return PnlPvp
