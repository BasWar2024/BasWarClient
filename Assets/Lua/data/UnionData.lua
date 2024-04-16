UnionData = {}

UnionData.armyData = {}

UnionData.unionData = nil -- ""
UnionData.joinableUnionList = {} -- ""
UnionData.playerApplyList = {} -- ""
UnionData.unionInviteList = {} -- ""
UnionData.editArmyInfo = nil -- ""
UnionData.unionReports = {}
UnionData.myReports = {}

UnionData.unionCamReports = {}
UnionData.myCamReports = {}

UnionData.members = {} -- ""
UnionData.techs = {} -- ""

UnionData.beginGridId = 0

UnionData.myUnionJod = 0

UnionData.unionRank = {}

UnionData.starmapMatchUnionGrids = nil
UnionData.starmapMatchPersonalGrids = nil

UnionData.noMyCampaignReportData = false
UnionData.noUnionCampaignReportData = false
UnionData.noMyBattleReportData = false
UnionData.noUnionBattleReportData = false

-- BattleData.unionArmyList = {[1] = {id = , battleArmy = message BattleArmy, } }
UnionData.unionArmyTeamId = 0
UnionData.unionArmyList = {}

UnionData.jackpot = 0

local cjson = require "cjson"

function UnionData.clearData()
    UnionData.myUnionJod = 0
    UnionData.unionData = nil
    UnionData.unionRank = {}
    UnionData.unionArmyList = {}
    UnionData.starmapMatchUnionGrids = nil
    UnionData.starmapMatchPersonalGrids = nil
    UnionData.armyData = {}
end

--------------------------------C2S----------------------------------
-- ""
function UnionData.C2S_Player_QueryJoinableUnionList()
    gg.client.gameServer:send("C2S_Player_QueryJoinableUnionList", {})
end

-- ""
function UnionData.C2S_Player_CreateUnion(unionName, unionNotice, unionFlag, enterType, enterScore, unionSharing)
    gg.client.gameServer:send("C2S_Player_CreateUnion", {
        unionName = unionName, -- ""
        unionNotice = unionNotice, -- ""
        unionFlag = unionFlag, -- ""
        enterType = enterType, -- ""0-"" 1-"" 2-""
        enterScore = enterScore, -- ""
        unionSharing = unionSharing -- ""
    })
end

-- ""
function UnionData.C2S_Player_JoinUnion(unionId)
    gg.client.gameServer:send("C2S_Player_JoinUnion", {
        unionId = unionId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_SearchUnion(keyWord)
    gg.client.gameServer:send("C2S_Player_SearchUnion", {
        keyWord = keyWord -- ""
    })
end

-- ""
function UnionData.C2S_Player_EditUnionJob(unionId, playerId, unionJob, editType)
    gg.client.gameServer:send("C2S_Player_EditUnionJob", {
        unionId = unionId, -- ""ID
        playerId = playerId, -- ""ID
        unionJob = unionJob, -- ""
        editType = editType -- 1-"" 2-"" 3-"" 4-""
    })
end

-- ""
function UnionData.C2S_Player_TickOutUnion(unionId, playerId)
    gg.client.gameServer:send("C2S_Player_TickOutUnion", {
        unionId = unionId, -- ""ID
        playerId = playerId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_QuitUnion(unionId)
    gg.client.gameServer:send("C2S_Player_QuitUnion", {
        unionId = unionId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_ModifyUnionInfo(unionId, unionFlag, enterType, enterScore, unionSharing, unionNotice,
    unionName)
    gg.client.gameServer:send("C2S_Player_ModifyUnionInfo", {
        unionId = unionId, -- ""ID
        unionFlag = unionFlag, -- ""
        enterType = enterType, -- ""
        enterScore = enterScore, -- ""
        unionSharing = unionSharing, -- ""
        unionNotice = unionNotice, -- ""
        unionName = unionName -- ""
    })
end

-- ""
function UnionData.C2S_Player_JoinUnionAnswer(answer, playerId, unionId)
    gg.client.gameServer:send("C2S_Player_JoinUnionAnswer", {
        answer = answer, -- "" 1-""；2-""
        playerId = playerId, -- ""ID
        unionId = unionId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_InviteJoinUnion(playerId, unionId)
    gg.client.gameServer:send("C2S_Player_InviteJoinUnion", {
        playerId = playerId, -- ""ID
        unionId = unionId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_AnswerUnionInvite(unionId, answer)
    gg.client.gameServer:send("C2S_Player_AnswerUnionInvite", {
        unionId = unionId, -- ""ID
        answer = answer -- -- "" 1=""；2=""
    })
end

-- ""
function UnionData.C2S_Player_GetUnionInviteList()
    gg.client.gameServer:send("C2S_Player_GetUnionInviteList", {})
end

-- ""
function UnionData.C2S_Player_GetUnionApplyList(unionId)
    gg.client.gameServer:send("C2S_Player_GetUnionApplyList", {
        unionId = unionId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_QueryUnionItemBag(unionId)
    gg.client.gameServer:send("C2S_Player_QueryUnionItemBag", {
        unionId = unionId -- ""ID
    })
end

-- ""
function UnionData.C2S_Player_UntionContribute(unionId, itemIds, resData)
    -- ResType resData
    gg.client.gameServer:send("C2S_Player_UntionContribute", {
        unionId = unionId, -- ""ID
        itemIds = itemIds, -- ""
        resData = resData -- ""
    })
end

-- ""
function UnionData.C2S_Player_UnionDonate(unionId, starCoin, ice, titanium, gas, carboxyl)
    -- ResType resData
    gg.client.gameServer:send("C2S_Player_UnionDonate", {
        unionId = unionId, -- ""ID
        starCoin = starCoin,
        ice = ice,
        titanium = titanium,
        gas = gas,
        carboxyl = carboxyl
    })
end

-- ""
function UnionData.C2S_Player_SearchPlayer(playerId)
    playerId = tonumber(playerId)
    gg.client.gameServer:send("C2S_Player_SearchPlayer", {
        playerId = playerId
    })
end

-- ""
function UnionData.C2S_Player_UnionTrainSolider(unionId, cfgId, count)
    gg.client.gameServer:send("C2S_Player_UnionTrainSolider", {
        unionId = unionId,
        cfgId = cfgId,
        count = count
    })
end

-- ""
function UnionData.C2S_Player_UnionGenBuild(unionId, cfgId, count)
    gg.client.gameServer:send("C2S_Player_UnionGenBuild", {
        unionId = unionId,
        cfgId = cfgId,
        count = count
    })
end

-- ""
function UnionData.C2S_Player_UnionTechLevelUp(unionId, cfgId)
    gg.client.gameServer:send("C2S_Player_UnionTechLevelUp", {
        unionId = unionId,
        cfgId = cfgId
    })
end

-- ""
function UnionData.C2S_Player_StartEditUnionArmys()
    gg.client.gameServer:send("C2S_Player_StartEditUnionArmys", {
        unionId = UnionData.unionData.unionId
    })
end

-- ""NFT
function UnionData.C2S_Player_UnionDonateNft(unionId, idList)
    gg.client.gameServer:send("C2S_Player_UnionDonateNft", {
        unionId = unionId,
        idList = idList
    })
end

-- ""NFT
function UnionData.C2S_Player_UnionTakeBackNft(unionId, idList)
    gg.client.gameServer:send("C2S_Player_UnionTakeBackNft", {
        unionId = unionId,
        idList = idList
    })

end

-- ""
function UnionData.C2S_Player_QueryUnionStarmapCampaignReports(pageNo, pageSize)
    if pageNo == 1 then
        UnionData.unionReports = {}
    end
    gg.client.gameServer:send("C2S_Player_QueryUnionStarmapCampaignReports", {
        pageNo = pageNo,
        pageSize = pageSize
    })
end

-- ""
function UnionData.C2S_Player_QueryUnionStarmapBattleReports(campaignId, pageNo, pageSize)
    gg.client.gameServer:send("C2S_Player_QueryUnionStarmapBattleReports", {
        campaignId = campaignId,
        pageNo = pageNo,
        pageSize = pageSize
    })
end

-- ""
function UnionData.C2S_Player_QueryStarmapCampaignReports(pageNo, pageSize)
    if pageNo == 1 then
        UnionData.myReports = {}
    end
    gg.client.gameServer:send("C2S_Player_QueryStarmapCampaignReports", {
        pageNo = pageNo,
        pageSize = pageSize
    })
end

-- ""
function UnionData.C2S_Player_QueryStarmapBattleReports(campaignId, pageNo, pageSize)
    gg.client.gameServer:send("C2S_Player_QueryStarmapBattleReports", {
        campaignId = campaignId,
        pageNo = pageNo,
        pageSize = pageSize
    })
end

-- ""
function UnionData.C2S_Player_QueryStarmapCampaignPlyStatistics(campaignId)
    gg.client.gameServer:send("C2S_Player_QueryStarmapCampaignPlyStatistics", {
        campaignId = campaignId
    })
end

-- ""
function UnionData.C2S_Player_JoinableUnionList()
    gg.client.gameServer:send("C2S_Player_JoinableUnionList", {})
end

-- ""id""
function UnionData.C2S_Player_QueryUnionBaseInfo(unionId)
    gg.client.gameServer:send("C2S_Player_QueryUnionBaseInfo", {
        unionId = unionId
    })
end

-- ""
function UnionData.C2S_Player_QueryMyUnionInfo()
    gg.client.gameServer:send("C2S_Player_QueryMyUnionInfo", {})
end

-- ""
function UnionData.C2S_Player_QueryUnionRes()
    gg.client.gameServer:send("C2S_Player_QueryUnionRes", {})
end

-- ""
function UnionData.C2S_Player_QueryUnionSoliders()
    gg.client.gameServer:send("C2S_Player_QueryUnionSoliders", {})
end

-- ""
function UnionData.C2S_Player_QueryUnionBuilds()
    gg.client.gameServer:send("C2S_Player_QueryUnionBuilds", {})
end

-- ""nft
function UnionData.C2S_Player_QueryUnionNfts()
    gg.client.gameServer:send("C2S_Player_QueryUnionNfts", {})
end

-- ""
function UnionData.C2S_Player_QueryUnionMembers()
    gg.client.gameServer:send("C2S_Player_QueryUnionMembers", {})
end

-- ""
function UnionData.C2S_Player_QueryUnionTechs()
    gg.client.gameServer:send("C2S_Player_QueryUnionTechs", {})
end

-- ""
function UnionData.C2S_Player_UnionClearAllApply()
    gg.client.gameServer:send("C2S_Player_UnionClearAllApply", {})

end

-- ""
function UnionData.C2S_Player_QueryStarmapHyJackpot()
    gg.client.gameServer:send("C2S_Player_QueryStarmapHyJackpot", {})
end

-- ""
-- 1-"" 2-"" 3-""
UnionData.RANK_WEEK = 1
UnionData.RANK_MONTH = 2
UnionData.RANK_CORE = 3

function UnionData.C2S_Player_StarmapMatchRank(matchType, unionChain)
    gg.client.gameServer:send("C2S_Player_StarmapMatchRank", {
        matchType = matchType,
        unionChain = unionChain
    })
end

-- ""
function UnionData.C2S_Player_StarmapMatchUnionGrids()
    gg.client.gameServer:send("C2S_Player_StarmapMatchUnionGrids", {})
end

-- ""
function UnionData.C2S_Player_StarmapMatchPersonalGrids()
    gg.client.gameServer:send("C2S_Player_StarmapMatchPersonalGrids", {})
end

-- ""
function UnionData.C2S_Player_GetStarmapScore()
    gg.client.gameServer:send("C2S_Player_GetStarmapScore")
end

-- ""dao""
function UnionData.C2S_Player_DonateDaoItem(id, count)
    gg.client.gameServer:send("C2S_Player_DonateDaoItem", {
        id = id,
        count = count
    })

end
--------------------------------S2C----------------------------------

-- ""
function UnionData.S2C_Player_UnionBaseInfo(args)
    local union = args.union -- unionBaseType

    gg.event:dispatchEvent("onVisitUnion", union)
end

-- ""("")
function UnionData.S2C_Player_MyUnionInfo(args)
    local union = args.union -- UnionType 

    UnionData.unionData = union
    UnionData.beginGridId = union.beginGridId
    if PlayerData.myInfo then
        PlayerData.myInfo.unionId = union.unionId
    end
    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONMAIN)
end

-- ""
function UnionData.S2C_Player_UnionJob(args)
    local unionJob = args.unionJob
    UnionData.myUnionJod = unionJob
    -- print("ffffffffffff unionJob:", unionJob)
end

-- ""
function UnionData.S2C_Player_JoinableUnionList(args)
    UnionData.unionData = nil
    local unions = args.unions -- UnionBriefType 
    UnionData.joinableUnionList = {}
    for k, v in pairs(unions) do
        UnionData.joinableUnionList[v.unionId] = v
    end

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONLIST)
end

-- ""
function UnionData.S2C_Player_UnionMemberDel(args)
    local unionId = args.unionId -- UnionBriefType
    local playerId = args.playerId

    if unionId == UnionData.unionData.unionId then
        UnionData.members[playerId] = nil
        gg.event:dispatchEvent("onUpdateUnionData")
    end

    if playerId == gg.playerMgr.localPlayer:getPid() then
        UnionData.unionData = nil
        UnionData.editArmyInfo = nil
        UnionData.beginGridId = 0
        gg.uiManager:closeWindow("PnlUnion")
        ChatData.clearChannel(constant.CHAT_TYPE_UNION)
    end

end

-- ""
function UnionData.S2C_Player_UnionMembers(args)
    local members = args.members -- UnionMemberType
    UnionData.members = {}
    for k, v in pairs(members) do
        UnionData.members[v.playerId] = v
        UnionData.members[v.playerId].contriDegree = v.contriDegree / 1000
    end
    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONMEMBER)
end

-- ""
function UnionData.S2C_Player_UnionApplyList(args)
    local applys = args.applys -- UnionApplyType
    UnionData.playerApplyList = {}
    for k, v in pairs(applys) do
        UnionData.playerApplyList[v.playerId] = v
    end

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONAPPLY)
end

-- ""
function UnionData.S2C_Player_SearchUnionResult(args)
    local unions = args.unions -- UnionBaseTyp
    UnionData.joinableUnionList = {}
    for k, v in pairs(unions) do
        UnionData.joinableUnionList[v.unionId] = v
    end

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONLIST)
end

-- ""
function UnionData.S2C_Player_UnionInviteList(args)
    local invites = args.invites -- UnionInviteType

    UnionData.unionInviteList = {}
    for k, v in pairs(invites) do
        table.insert(UnionData.unionInviteList, v)
    end

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONINVITE)
end

-- ""
function UnionData.S2C_Player_UnionRes(args)
    UnionData.unionData.starCoin = args.starCoin
    UnionData.unionData.titanium = args.titanium
    UnionData.unionData.ice = args.ice
    UnionData.unionData.gas = args.gas
    UnionData.unionData.carboxyl = args.carboxyl
    UnionData.unionData.contriDegree = args.contriDegree / 1000

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONWAREHOUSE, PnlUnion.WAREHOUSE_RES)
end

-- ""NFT
function UnionData.S2C_Player_UnionNfts(args)
    local items = {}
    for k, v in pairs(args.items) do
        items[v.id] = v
        -- items[v.id].entity = cjson.decode(v.entity)
        -- items[v.id].lessLaunchEnd = items[v.id].lessLaunch + os.time()
    end
    if UnionData.unionData then
        UnionData.unionData.items = {}
        UnionData.unionData.items = items
        UnionData.unionData.contriDegree = args.contriDegree / 1000
    end

    gg.event:dispatchEvent("onUpdateUnionNft", PnlUnionNft.WAREHOUSE_NFT)
    gg.event:dispatchEvent("onShowUnionBag")
end

-- ""
function UnionData.S2C_Player_UnionSoliders(args)
    local soliders = {}

    for k, v in pairs(args.soliders) do
        v.genTick = v.genTick + os.time()
        soliders[v.cfgId] = v
    end

    UnionData.unionData.soliders = {}
    UnionData.unionData.soliders = soliders

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONWAREHOUSE, PnlUnion.WAREHOUSE_SOLIDIER)

end

-- ""
function UnionData.S2C_Player_UnionBuilds(args)
    local builds = {}

    for k, v in pairs(args.builds) do
        builds[v.cfgId] = v
        builds[v.cfgId].genTick = builds[v.cfgId].genTick + os.time()
    end

    UnionData.unionData.builds = {}
    UnionData.unionData.builds = builds

    gg.event:dispatchEvent("onShowBuild")

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONWAREHOUSE, PnlUnion.WAREHOUSE_TOWER)

end

-- ""
function UnionData.S2C_Player_QueryDaoVoteData(args)
    local democratic = args.democratic -- ""
    local dicatorship = args.dicatorship -- ""
    local oligarch = args.oligarch -- ""
    local myDistribution = args.myDistribution -- "" 0"" >0""
    local lessTime = args.lessTime -- ""
    local isVoteOpen = args.isVoteOpen -- "",""
end

-- ""
function UnionData.S2C_Player_SearchPlayer(args)
    local playerId = args.playerId
    local playerName = args.playerName
    local baseLevel = args.baseLevel
    local chain = args.chain
    gg.event:dispatchEvent("onShowSearchPlayer", playerId, playerName, baseLevel, chain)
end

-- ""
function UnionData.S2C_Player_UnionTechs(args)
    local techs = {}

    for k, v in pairs(args.techs) do
        techs[v.cfgId] = v
        techs[v.cfgId].levelUpTick = techs[v.cfgId].levelUpTick + os.time()
    end

    UnionData.techs = {}
    UnionData.techs = techs

    gg.event:dispatchEvent("onUpdateUnionData", PnlUnion.VIEW_UNIONTECH)
end

-- ""
function UnionData.S2C_Player_UnionStarmapCampaignReportUpdate(args)
end

-- ""
function UnionData.S2C_Player_UnionStarmapCampaignReports(args)
    UnionData.noUnionCampaignReportData = true
    if #args.reports <= 0 then
        return
    end
    UnionData.noUnionCampaignReportData = false
    for k, v in pairs(args.reports) do
        table.insert(UnionData.unionReports, v)
    end

    QuickSort.quickSort(UnionData.unionReports, "startTime", 1, #UnionData.unionReports)

    gg.event:dispatchEvent("onSetReportData")
end

-- ""
function UnionData.S2C_Player_UnionStarmapBattleReportUpdate(args)

end

-- ""
function UnionData.S2C_Player_UnionStarmapBattleReports(args)
    local reports = args.reports
    UnionData.noUnionBattleReportData = true
    if #reports <= 0 then
        return
    end
    UnionData.noUnionBattleReportData = false
    for k, v in pairs(reports) do
        table.insert(UnionData.unionCamReports, v)
    end
    gg.event:dispatchEvent("setUnionWarReportInfo", UnionData.unionCamReports)
end

-- ""
function UnionData.S2C_Player_StarmapCampaignReportUpdate(args)

end

-- ""
function UnionData.S2C_Player_StarmapCampaignReports(args)
    UnionData.noMyCampaignReportData = true
    if #args.reports <= 0 then
        return
    end
    UnionData.noMyCampaignReportData = false
    for k, v in pairs(args.reports) do
        table.insert(UnionData.myReports, v)
    end

    QuickSort.quickSort(UnionData.myReports, "startTime", 1, #UnionData.myReports)

    gg.event:dispatchEvent("onSetMyReport")
end

-- ""
function UnionData.S2C_Player_StarmapBattleReportUpdate(args)

end

-- ""
function UnionData.S2C_Player_StarmapBattleReports(args)
    local reports = args.reports
    UnionData.noMyBattleReportData = true
    if #reports <= 0 then
        return
    end
    UnionData.noMyBattleReportData = false
    for k, v in pairs(reports) do
        table.insert(UnionData.myCamReports, v)
    end

    gg.event:dispatchEvent("setUnionWarReportInfo", UnionData.myCamReports)
end

-- ""
function UnionData.S2C_Player_StarmapCampaignPlyStatistics(args)
    gg.event:dispatchEvent("onLoadBoxWarPlayerInfo", args)
end

-- ""
function UnionData.S2C_Player_UnionStartEditArmy(args)
    UnionData.editArmyInfo = args
    UnionData.editArmyInfo.editArmyTickEnd = UnionData.editArmyInfo.editArmyTick + os.time()
    gg.event:dispatchEvent("onEditUnionArmy")
end

-- ""
function UnionData.S2C_Player_StarmapHyJackpot(args)
    UnionData.jackpot = args.jackpot / 1000
    gg.event:dispatchEvent("onUnionRankJackpot")
end


-- ""
function UnionData.S2C_Player_StarmapRankList(args)
    UnionData.unionRank[args.chainId] = {}
    UnionData.unionRank[args.chainId] = args
    gg.event:dispatchEvent("onUnionRankChange", args.chainId)
end

-- ""
function UnionData.S2C_Player_StarmapMatchUnionGrids(args)
    -- gg.printData(args)
    UnionData.starmapMatchUnionGrids = args
    if UnionData.beginGridId ~= 0 then
        local data = {
            gridCfgId = UnionData.beginGridId,
            leftTime = 0
        }
        table.insert(UnionData.starmapMatchUnionGrids.list, 1, data)
    end

    gg.event:dispatchEvent("onUnionUnionGridsChange")
end

-- ""
function UnionData.S2C_Player_StarmapMatchPersonalGrids(args)
    -- gg.printData(args)
    UnionData.starmapMatchPersonalGrids = args
    if UnionData.beginGridId ~= 0 then
        local data = {
            gridCfgId = UnionData.beginGridId,
            leftTime = 0
        }
        table.insert(UnionData.starmapMatchPersonalGrids.list, 1, data)
    end
    gg.event:dispatchEvent("onUnionPersonGridsChange")
end

-- ""
function UnionData.S2C_Player_MyGridAdd(args)
    local data = {
        gridCfgId = args.grid.cfgId,
        leftTime = Utils.getServerSec()
    }

    table.insert(UnionData.starmapMatchPersonalGrids.list, data)
end

-- ""
function UnionData.S2C_Player_MyGridDel(args)
    local key = nil
    for k, v in pairs(UnionData.starmapMatchPersonalGrids.list) do
        if v.gridCfgId == args.cfgId then
            key = k
            break
        end
    end
    if key then
        UnionData.starmapMatchPersonalGrids.list[key] = nil
    end

    gg.event:dispatchEvent("OnGridDel")
end

-- // ""
function UnionData.S2C_Player_StarmapScore(args)
    UnionData.starScore = args.starScore
    gg.event:dispatchEvent("onStarScoreChange")
end

-------------------------union army

function UnionData.C2S_Player_IsUseGuidArmy(isUseGuidArmy)
    gg.client.gameServer:send("C2S_Player_IsUseGuidArmy", {
        isUseGuidArmy = isUseGuidArmy -- ""|""  1|0
    })
end

function UnionData.C2S_Player_AddGuildReserveCount(guildReserveCount)
    gg.client.gameServer:send("C2S_Player_AddGuildReserveCount", {
        guildReserveCount = guildReserveCount -- ""|""  1|0
    })
end

function UnionData.S2C_Player_GuildReserveArmy(args)
    UnionData.armyData = args
    gg.event:dispatchEvent("OnGuildReserveArmyChange")
end

function UnionData.S2C_Player_DonateDaoItem(args)
    if UnionData.unionData then
        UnionData.unionData.exp = args.exp
        UnionData.unionData.unionLevel = args.unionLevel
        UnionData.unionData.contriDegree = args.contriDegree / 1000
    end
    gg.event:dispatchEvent("onSetViewWarehouseDao")
end

-----------------------union army ""

-- UnionData.unionArmyList = {{id = , battleArmy = {warShipId = , teams = {{heroId = , soliderCfgId = , soliderCount = , hero = , solider = },}}}}
-- hero = {id = value.id, cfgId = value.entity.cfgId, level = value.entity.level, quality = value.entity.quality,}
-- solider = {level = soldierData.level,cfgId = value.soliderCfgId,build = value,}

function UnionData.getUnionArmyTeamId()
    UnionData.unionArmyTeamId = UnionData.unionArmyTeamId + 1
    return UnionData.unionArmyTeamId
end

function UnionData.updateUnionArmy(army)
    for key, value in pairs(UnionData.unionArmyList) do
        if value.id == army.id then
            UnionData.unionArmyList[key] = army
            gg.event:dispatchEvent("onUnionArmyChange")
            return
        end
    end

    if #UnionData.unionArmyList < cfg.global.UnionArmyTeamsLimit.intValue then
        army.id = UnionData.getUnionArmyTeamId()
        table.insert(UnionData.unionArmyList, army)
        gg.event:dispatchEvent("onUnionArmyChange")
    else
        gg.uiManager:showTip("max team")
    end
end

function UnionData.addEmptyArmy()
    local army = UnionData.getEmpArmy()

    table.insert(UnionData.unionArmyList, army)
    gg.event:dispatchEvent("onUnionArmyChange")

    return army
end

function UnionData.getEmpArmy()
    local army = {
        id = UnionData.getUnionArmyTeamId(),
        battleArmy = {
            warShipId = 0,
            teams = {}
        }
    }

    for i = 1, 5, 1 do
        table.insert(army.battleArmy.teams, {
            heroId = 0,
            soliderCfgId = 0,
            soliderCount = 0,
            hero = nil,
            solider = nil
        })
    end

    return army
end

function UnionData.autoSelectArmy(armyCount)
    -- local armyList

    UnionArmyUtil.autoSetArmy(armyCount, function(armyList)
        UnionData.unionArmyList = armyList
        gg.event:dispatchEvent("onUnionArmyChange")
    end, true)

    -- UnionData.unionArmyList = UnionArmyUtil.autoSetArmy(armyCount)
end

function UnionData.removeUnionArmy(id)
    for index, value in ipairs(UnionData.unionArmyList) do
        if value.id == id then
            table.remove(UnionData.unionArmyList, index)
            gg.event:dispatchEvent("onUnionArmyChange")
            break
        end
    end
end

function UnionData.clearUnionArmy()
    UnionData.unionArmyList = {}
    gg.event:dispatchEvent("onUnionArmyChange")
end

return UnionData
