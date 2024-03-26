BattleData = {}
BattleData.pvpData = nil
BattleData.botEnemies = nil
BattleData.pveData = nil

BattleData.pvpBackGroundCfg = nil
BattleData.pvpMatchRewardRecords = nil

BattleData.BATTLE_TYPE_BASE = 1
BattleData.BATTLE_TYPE_RES_PLANNET = 2
BattleData.BATTLE_TYPE_PVE = 3
BattleData.BATTLE_TYPE_SELF = 4

BattleData.BATTLE_TYPE_SELF_EDIT_AUTO = 100

BattleData.BATTLE_MIN_POS = 3
BattleData.BATTLE_MAX_POS = 55

BattleData.UnionBattleOperOrders = {1, 9, 2, 16, 3, 17, 4, 18, 5, 19}
BattleData.UnionBattleLandCoord = {29, 29, 36, 36, 22, 22, 43, 43, 15, 15}

BattleData.ARMY_TYPE_SELF = 1
BattleData.ARMY_TYPE_UNION = 2

-- pve
BattleData.pvePassMap = {}
BattleData.pveDayPassMap = {}
BattleData.pveDailyRewardMap = {}
BattleData.passCount = 0
BattleData.pveResetTickEnd = 0

BattleData.battleType = 0

-- ""
function BattleData.C2S_Player_StartBattle(battleType, enemyId, pnl, armyType, armyGroupId, signinPosId, bVersion,
    operates, armyId)
    gg.uiManager.battleLoadingPnl = pnl

    if enemyId > 100 and battleType == BattleData.BATTLE_TYPE_BASE then
        if not Utils.checkIsCanPvp(true, true) then
            return
        end
    end

    gg.client.gameServer:send("C2S_Player_StartBattle", {
        battleType = battleType,
        enemyId = enemyId,
        armyType = armyType,
        armyGroupId = armyGroupId,
        signinPosId = signinPosId,
        bVersion = bVersion,
        operates = operates,
        armyId = armyId
    })
    gg.uiManager:onOpenPnlLink("Player_StartBattle")
end

-- pvp""
function BattleData.startPvp(battleType, enemyId, armyId, pnl)
    gg.uiManager.battleLoadingPnl = pnl
    local yesCallBack = function()
        gg.client.gameServer:send("C2S_Player_StartBattle", {
            battleType = battleType,
            enemyId = enemyId,
            armyId = armyId
        })
        gg.uiManager:onOpenPnlLink("Player_StartBattle")
    end

    if enemyId > 100 and battleType == BattleData.BATTLE_TYPE_BASE then
        if not Utils.checkIsCanPvp(true, true, true) then
            return
        end
        if not Utils.checkPvpFightCount(true) then
            local args = {
                callbackYes = yesCallBack,
                txt = "not enought fight count,you can't get hy and pvp score, are you sure want to continue?"
            }
            gg.uiManager:openWindow("PnlAlert", args)
            return
        end
    end

    yesCallBack()
end

-- ""
function BattleData.StartUnionBattle(armyType, plantId, armys, signinPosId, bVersion, operates, battleType, armyId)
    gg.uiManager.battleLoadingPnl = pnl
    battleType = battleType or BattleData.BATTLE_TYPE_RES_PLANNET
    gg.client.gameServer:send("C2S_Player_StartBattle", {
        battleType = battleType,
        enemyId = plantId,
        armyType = armyType,
        armys = armys,
        signinPosId = signinPosId,
        bVersion = bVersion,
        operates = operates,
        armyId = armyId
    })
    gg.uiManager:onOpenPnlLink("Player_StartBattle")
end

-- message C2S_Player_StartBattle {
--     int32 battleType = 1;                           // "",1"",2""
--     int32 enemyId = 2;                             // ""id, battleType""1""id, battleType""2""id
--     int32 armyType = 3;                            // "": 1-"" 2-""
--     repeated BattleArmy armys = 4;                 // ""
--     int32 signinPosId = 5;                         // "" ("")
--     string bVersion = 6;                           // "" ("")
--     repeated BattleOperate operates = 7;           // "" ("")
-- }

-- ""
function BattleData.C2S_Player_EndBattle(battleId, bVersion, ret, signinPosId, operates, soliders, endStep,
    destoryDefendCount, destoryDevelopCount, destoryEconomyCount)
    gg.client.gameServer:send("C2S_Player_EndBattle", {
        battleId = battleId,
        bVersion = bVersion,
        ret = ret,
        signinPosId = signinPosId,
        operates = operates,
        soliders = soliders,
        endStep = endStep,
        destoryDefendCount = destoryDefendCount,
        destoryDevelopCount = destoryDevelopCount,
        destoryEconomyCount = destoryEconomyCount
    })

    local callback = function()
        gg.uiManager:showBattleError(-1)
    end

    gg.uiManager:onOpenPnlLink("Player_EndBattle", false, true, 10, callback)
end

-- ""
function BattleData.C2S_Player_LookBattlePlayBack(battleId, bVersion, pnl)
    gg.uiManager:closeWindow("PnlPlanet")

    gg.uiManager:onOpenPnlLink("Player_LookBattlePlayBack", false, true)

    if pnl then
        gg.uiManager.battleLoadingPnl = pnl
    end
    

    gg.client.gameServer:send("C2S_Player_LookBattlePlayBack", {
        battleId = battleId,
        bVersion = bVersion
    })
end

-- ""
function BattleData.C2S_Player_BuyBattleNum(battleNum)
    gg.client.gameServer:send("C2S_Player_BuyBattleNum", {
        battleNum = battleNum
    })
end

function BattleData.S2C_Player_StartBattle(args)
    gg.uiManager:closeWindow("PnlPlanet")

    BattleData.setIsBattleEnd(false)
    local battleId = args.battleId
    local battleInfo = args.battleInfo
    BattleData.battleType = args.battleType

    local needLoadAudioTableKeys = {"builds", "traps", "soliders", "skills", "bullets", "buffs", "summonSoliders"}
    local preBattleAudioCfgIDList = {}
    for _, tableKey in pairs(needLoadAudioTableKeys) do
        local data = battleInfo[tableKey]
        if data and type(data) == "table" then
            for k, v in pairs(data) do
                table.insert(preBattleAudioCfgIDList, v.cfgId)
            end
        end
    end
    -- gg.audioManager:preLoadAudioByBattleAudioCfgId(preBattleAudioCfgIDList)

    gg.audioManager:preloadBattleAudio(battleInfo)

    -- ""
    gg.sceneManager:enterBattleScene(battleId, battleInfo, 0)

    gg.uiManager:onClosePnlLink("Player_StartBattle")

    -- local cjson = require "cjson"
    -- local jsonPath = UnityEngine.PlayerPrefs.GetString(PnlEdit.EXPLORE_PATH_KEY) .. "\\battleJson.json"
    -- local file = io.open(jsonPath, "w+")
    -- file:write(cjson.encode(args))
    -- file:close()
end

function BattleData.setIsBattleEnd(isEnd)
    BattleData.isBattleEnd = isEnd
    gg.event:dispatchEvent("onClientBattleEnd")
end

-- ""pvp""
function BattleData.C2S_Player_ChangePvpPlayers()
    gg.client.gameServer:send("C2S_Player_ChangePvpPlayers", {})
end

-- ""pvp""
function BattleData.C2S_Player_QueryPvpPlayers()
    gg.client.gameServer:send("C2S_Player_QueryPvpPlayers")
end

-- ""pvp""
function BattleData.C2S_Player_PvpScoutFoundation(playerId)
    gg.client.gameServer:send("C2S_Player_PvpScoutFoundation", {
        playerId = playerId
    })
    gg.uiManager:onOpenPnlLink("Player_PvpScoutFoundation")
end

-- ""bot""
function BattleData.C2S_Player_queryGmRobotPlayers()
    gg.client.gameServer:send("C2S_Player_queryGmRobotPlayers")
end

-- ""pve""
function BattleData.C2S_Player_PVEScoutFoundation(cfgId)
    gg.client.gameServer:send("C2S_Player_PVEScoutFoundation", {
        cfgId = cfgId
    })
    gg.uiManager:onOpenPnlLink("Player_PVEScoutFoundation")
end

-- pve""
function BattleData.C2S_Player_PVERecvDailyRewards(cfgId)
    gg.client.gameServer:send("C2S_Player_PVERecvDailyRewards", {
        cfgId = cfgId
    })
end

function BattleData.C2S_Player_UploadBattle(battleId, signinPosId, bVersion, operates)
    gg.client.gameServer:send("C2S_Player_UploadBattle", {
        battleId = battleId,
        signinPosId = signinPosId,
        bVersion = bVersion,
        operates = operates
    })
end

--------------------------------------------------------------

function BattleData.S2C_Player_UploadBattle(args)
    gg.battleManager:uploadBattle(args)
end

function BattleData.S2C_Player_EndBattle_NotCompletely(args)
    local battleId = args.battleId
    local code = args.code
    gg.uiManager:onClosePnlLink("Player_EndBattle")

    gg.uiManager:showBattleError(code)
end

-- BattleData.ResultDelay = 0

-- "",1"",2"",4""
function BattleData.S2C_Player_EndBattle(args)
    BattleData.setIsBattleEnd(true)
    AudioFmodMgr:ClearBattleBank()

    if gg.battleManager.isInBattleServer then
        gg.uiManager:closeWindow("PnlBattle")

        local delay = 0
        if args.result == 1 then
            delay = 3.5
        end

        gg.timer:startTimer(delay, function()
            if args.battleType == BattleData.BATTLE_TYPE_PVE then
                if args.result == 1 then
                    gg.uiManager:openWindow("PnlPveResultWin", args)
                else
                    gg.uiManager:openWindow("PnlPveResultLose", args)
                end
            else
                gg.uiManager:openWindow("PnlResult", args)
            end
        end)
    end
    gg.uiManager:onClosePnlLink("Player_EndBattle")
end

function BattleData.S2C_Player_LookBattlePlayBack(args)
    gg.uiManager:onClosePnlLink("Player_LookBattlePlayBack")
    gg.uiManager:closeWindow("PnlBattleReport")
    gg.uiManager:closeWindow("PnlUnionWarReport")

    local window1 = gg.uiManager:getWindow("PnlBattleReport")
    if window1 then
        gg.uiManager:destroyWindow("PnlBattleReport")
    end
    local window2 = gg.uiManager:getWindow("PnlUnionWarReport")
    if window2 then
        gg.uiManager:destroyWindow("PnlUnionWarReport")
    end
    -- gg.uiManager:closeWindow("PnlBattleReport")
    -- gg.uiManager:closeWindow("PnlUnionWarReport")
    gg.uiManager:closeWindow("PnlUnion")
    gg.uiManager:closeWindow("PnlPvp")
    gg.battleManager:lookBattlePlayBack(args)
end

function BattleData.S2C_Player_PvpData(args)
    BattleData.pvpData = args
    local newTime = os.time()
    args.banLessTimeEnd = args.banLessTime + newTime
    args.lifeTimeEnd = args.lifeTime + newTime
    for key, value in pairs(args.enemies) do
        PlayerData.setPlayerHeadIcon(value.playerId, value.playerHead)
    end
    gg.event:dispatchEvent("onPvpPlayerDataChange")
end

function BattleData.S2C_Player_FoundationData(args)
    gg.galaxyManager:onLookOtherBase(args, args.playerId, args.builds)
end

function BattleData.S2C_Player_PvpScoutFoundation(args)
    local info = args.info
    if args.canAttack then
        gg.galaxyManager:onLookOtherBase(info, info.playerId, info.builds, PnlPlanet.TYPE_SHOW_BATTLE,
            BattleData.scoutReturnOpenWindow)
    else
        gg.galaxyManager:onLookOtherBase(info, info.playerId, info.builds, PnlPlanet.TYPE_SHOW_VISIT,
            BattleData.scoutReturnOpenWindow)
    end
    BattleData.scoutReturnOpenWindow = nil
    gg.uiManager:onClosePnlLink("Player_PvpScoutFoundation")
end

function BattleData.S2C_Player_PveScoutFoundation(args)
    local info = args.info
    info.battleType = BattleData.BATTLE_TYPE_PVE

    local battleInfo = {
        func = function()

            gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {
                fightCB = function(armys)
                    BattleData.startPvp(BattleData.BATTLE_TYPE_PVE, info.playerId, armys[1].armyId, self)
                end
            })
        end
    }

    if args.canAttack then
        gg.galaxyManager:onLookOtherBase(info, info.playerId, info.builds, PnlPlanet.TYPE_SHOW_BATTLE,
            BattleData.scoutReturnOpenWindow, battleInfo)
    else
        gg.galaxyManager:onLookOtherBase(info, info.playerId, info.builds, PnlPlanet.TYPE_SHOW_VISIT,
            BattleData.scoutReturnOpenWindow, battleInfo)
    end
    BattleData.scoutReturnOpenWindow = nil
    gg.uiManager:onClosePnlLink("Player_PVEScoutFoundation")
end

-- data = {name = "PnlMatch", args = {type = PnlMatch.TYPE_MATCH}, type = PnlMatch.TYPE_MATCH}
function BattleData.setPvpScoutReturnOpenWindow(data)
    BattleData.scoutReturnOpenWindow = data
end

function BattleData.S2C_Player_UnionVisitFoundation(args)
    local info = args.info
    gg.galaxyManager:onLookOtherBase(info, info.playerId, info.builds, PnlPlanet.TYPE_SHOW_VISIT)
    gg.uiManager:onClosePnlLink("Player_UnionVisitFoundation")

end

function BattleData.S2C_Player_ChatVisitFoundation(args)
    local info = args.info
    gg.galaxyManager:onLookOtherBase(info, info.playerId, info.builds, PnlPlanet.TYPE_SHOW_VISIT)
    gg.uiManager:onClosePnlLink("Player_ChatVisitFoundation")

end

function BattleData.S2C_Player_PvpGmRobotPlayers(args)
    BattleData.botEnemies = args.enemies

    BattleData.pveData = args
    BattleData.pveWinIds = args.pveWinIds

    gg.event:dispatchEvent("onPvpPlayerDataChange")
    gg.event:dispatchEvent("onPveBotDataChange")
end

function BattleData.S2C_Player_sendPvpBackGroundCfg(args)
    BattleData.pvpBackGroundCfg = args
end

function BattleData.S2C_Player_pvpMatchRewardRecords(args)
    BattleData.pvpMatchRewardRecords = args
end

function BattleData.S2C_Player_pvpMatchRewardTips(args)
    -- local viewArgs = {
    --     rewards = args.rewards,
    --     index = 1
    -- }
    -- gg.uiManager:openWindow("PnlPvpFetch", viewArgs)

    -- local rewardList = {}
    -- for _, matchReward in pairs(args.rewards) do
    --     for _, reward in pairs(matchReward.reward) do
    --         table.insert(rewardList, {
    --             reward.resCfgId,
    --             reward.count,
    --         })
    --     end
    -- end

    local rewardList = {}
    local index = 1
    for key, value in pairs(args.rewards[index].reward) do
        table.insert(rewardList, {
            rewardType = constant.ACTIVITY_REWARD_RES,
            resId = value.resCfgId,
            count = value.count
        })
    end

    gg.uiManager:openWindow("", {
        reward = rewardList,
        title = Utils.getText("pvp_GetReward_Title")
    })
end

-- pve""
function BattleData.S2C_Player_PveInfo(args)
    BattleData.passCount = #args.pass
    BattleData.pvePassMap = {}
    for key, value in pairs(args.pass) do
        BattleData.pvePassMap[value.cfgId] = value
    end

    BattleData.pveDayPassMap = {}
    for key, value in pairs(args.dayPass) do
        BattleData.pveDayPassMap[value.cfgId] = value
    end

    BattleData.pveDailyRewardMap = {}
    for key, value in pairs(args.dailyRewards) do
        BattleData.pveDailyRewardMap[value] = true
    end

    BattleData.pveResetTickEnd = args.dailyResetTick
    gg.event:dispatchEvent("onPveChange")
end

-- GVG""
function BattleData.S2C_Player_UnionSelfBattleResult(args)
    gg.uiManager:onClosePnlLink("Player_StartBattle")

    -- local battleTotal = args.battleTotal
    -- local reserveTotal = args.reserveTotal
    local battleResult = args.battleResult
    if battleResult ~= -1 then
        gg.event:dispatchEvent("onShowGvgResult", args)
    end
end

