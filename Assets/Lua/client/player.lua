local net = {}

function net.S2C_Player_LookBriefs(args)
    local session = args.session
    local briefs = args.briefs
    for i, brief in ipairs(briefs) do
        local pid = brief.pid
        local player = gg.playerMgr:getPlayer(pid)
        if not player then
            player = ggclass.Player.new(pid)
            gg.playerMgr:addPlayer(player)
        end
        player:setProperties(brief)
    end
    gg.playerMgr:onLookPlayers(session)
end

function net.S2C_Player_UpdateBrief(args)
    local brief = args.brief
    local pid = brief.pid
    local player = gg.playerMgr:getPlayer(pid)
    if player then
        player:setProperties(brief)
    end
end

function net.S2C_Player_ResData(args)
    local resData = args.resData or {}
    ResData.S2C_Player_ResData(resData)
end

function net.S2C_Player_ResAnimation(args)
    ResData.S2C_Player_ResAnimation(args)
end

function net.S2C_Player_ResChange(args)
    local resCfgId = args.resCfgId
    local count = args.count
    local change = args.change
    ResData.S2C_Player_ResChange(resCfgId, count, change, args.bind)
end

function net.S2C_Player_BuildData(args)
    BuildData.S2C_Player_BuildData(args)
end

function net.S2C_Player_BuildQueueData(args)
    BuildData.S2C_Player_BuildQueueData(args.buildQueueCount)
end

function net.S2C_Player_BuildAdd(args)
    BuildData.S2C_Player_BuildAdd(args)
end

function net.S2C_Player_BuildMove(args)
    local ret = args.ret
    local build = args.build
    BuildData.S2C_Player_BuildMove(ret, build)
end

function net.S2C_Player_BuildLevelUp(args)
    BuildData.S2C_Player_BuildLevelUp(args)
end

function net.S2C_Player_BuildUpdate(args)
    BuildData.S2C_Player_BuildUpdate(args)
end

function net.S2C_Player_BuildGetRes(args)
    BuildData.S2C_Player_BuildGetRes(args)
end

-- ""
function net.S2C_Player_SoliderLevelData(args)
    local soliderLevelData = args.soliderLevelData
    BuildData.S2C_Player_SoliderLevelData(soliderLevelData)
end

function net.S2C_Player_SoliderLevelUpdate(args)
    local soliderLevel = args.soliderLevel
    BuildData.S2C_Player_SoliderLevelUpdate(soliderLevel)
end

function net.S2C_Player_SoliderForgeLevelUpdate(args)
    BuildData.S2C_Player_SoliderForgeLevelUpdate(args.forgeLevelInfo, args.result)
end

function net.S2C_Player_SoliderForgeLevelData(args)
    BuildData.S2C_Player_SoliderForgeLevelData(args.forgeLevelInfos)
end
--
function net.S2C_Player_MineLevelData(args)
    local mineLevelData = args.mineLevelData
    BuildData.S2C_Player_MineLevelData(mineLevelData)
end

function net.S2C_Player_MineLevelUpdate(args)
    local mineLevel = args.mineLevel
    BuildData.S2C_Player_MineLevelUpdate(mineLevel)
end

function net.S2C_Player_BuildDel(args)
    BuildData.S2C_Player_BuildDel(args)
end

function net.S2C_Player_RemoveMess(args)
    local id = args.id
    local getMit = args.getMit
    BuildData.S2C_Player_RemoveMess(id, getMit)
end

function net.S2C_Player_PledgeData(args)
    BuildData.S2C_Player_PledgeData(args.pledges)
end

function net.S2C_Player_PledgeAdd(args)
    BuildData.S2C_Player_PledgeAdd(args.pledge)
end

function net.S2C_Player_PledgeDel(args)
    BuildData.S2C_Player_PledgeDel(args.cfgId)
end

function net.S2C_Player_VipData(args)
    VipData.S2C_Player_VipData(args)
end

function net.S2C_Player_ItemBag(args)
    local maxSpace = args.maxSpace
    local expandSpace = args.expandSpace
    local items = args.items
    ItemData.S2C_Player_ItemBag(maxSpace, expandSpace, items)
end

function net.S2C_Player_ExpandItemBag(args)
    local expandSpace = args.expandSpace
    ItemData.S2C_Player_ExpandItemBag(expandSpace)
end

function net.S2C_Player_ItemAdd(args)
    local item = args.item
    ItemData.S2C_Player_ItemAdd(item)
end

function net.S2C_Player_ItemDel(args)
    local id = args.id
    ItemData.S2C_Player_ItemDel(id)
end

function net.S2C_Player_ItemUpdate(args)
    local item = args.item
    ItemData.S2C_Player_ItemUpdate(item)
end

function net.S2C_Player_ItemComposeAdd(args)
    local composeItem = args.item
    ItemData.S2C_Player_ItemComposeAdd(composeItem)
end

function net.S2C_Player_ComposeItemData(args)
    local composeItems = args.items
    ItemData.S2C_Player_ComposeItemData(composeItems)
end

function net.S2C_Player_ItemCompose(args)
    ItemData.S2C_Player_ItemCompose(args)
end

function net.S2C_Player_ItemComposeCancel(args)
    local item = args.item
    ItemData.S2C_Player_ItemComposeCancel(item)
end

function net.S2C_Player_UseItem(args)
    ItemData.S2C_Player_UseItem(args)
end


function net.S2C_Player_UseGiftCode(args)
    GiftData.S2C_Player_UseGiftCode(args)
end

-- hero
function net.S2C_Player_HeroData(args)
    local heroData = args.heroData or {}
    HeroData.S2C_Player_HeroData(heroData, args.useId)
end

function net.S2C_Player_HeroAdd(args)
    local hero = args.hero
    HeroData.S2C_Player_HeroAdd(hero)
end

function net.S2C_Player_HeroDel(args)
    local id = args.id
    HeroData.S2C_Player_HeroDel(id)
end

function net.S2C_Player_HeroUpdate(args)
    local hero = args.hero
    HeroData.S2C_Player_HeroUpdate(hero)
end

function net.S2C_Player_DismantleReward(args)
    HeroData.S2C_Player_DismantleReward(args)
end

function net.S2C_Player_UseHeroUpdate(args)
    HeroData.S2C_Player_UseHeroUpdate(args.useId)
end

-- warship
function net.S2C_Player_WarShipData(args)
    local warShipData = args.warShipData or {}
    local useId = args.useId
    WarShipData.S2C_Player_WarShipData(warShipData, useId)
end

function net.S2C_Player_WarShipAdd(args)
    local warShip = args.warShip
    WarShipData.S2C_Player_WarShipAdd(warShip)
end

function net.S2C_Player_WarShipDel(args)
    local id = args.id
    WarShipData.S2C_Player_WarShipDel(id)
end

function net.S2C_Player_WarShipUpdate(args)
    local warShip = args.warShip
    WarShipData.S2C_Player_WarShipUpdate(warShip)
end

function net.S2C_Player_UseWarShipUpdate(args)
    local useId = args.useId
    WarShipData.S2C_Player_UseWarShipUpdate(useId)
end

function net.S2C_Player_ResPlanetData(args)
    local planet = args.planet
    ResPlanetData.S2C_Player_ResPlanetData(planet)
end

function net.S2C_Player_PickBoatRes(args)
    local boats = args.boats
    ResPlanetData.S2C_Player_PickBoatRes(boats)
end

function net.S2C_Player_ResPlanet_BuildAdd(args)
    local index = args.index
    local build = args.build
    ResPlanetData.S2C_Player_ResPlanet_BuildAdd(index, build)
end

function net.S2C_Player_ResPlanet_BuildDel(args)
    local index = args.index
    local buildId = args.buildId
    ResPlanetData.S2C_Player_ResPlanet_BuildDel(index, buildId)
end

function net.S2C_Player_ResPlanet_BuildUpdate(args)
    local index = args.index
    local build = args.build
    ResPlanetData.S2C_Player_ResPlanet_BuildUpdate(index, build)
end


-- ""
function net.S2C_Player_MyResPlanets(args)
    local planets = args.planets
    ResPlanetData.S2C_Player_MyResPlanets(planets)
end

-- ""
function net.S2C_Player_MyResPlanetAdd(args)
    ResPlanetData.S2C_Player_MyResPlanetAdd(args.planet)
end

-- ""
function net.S2C_Player_MyResPlanetDel(args)
    ResPlanetData.S2C_Player_MyResPlanetDel(args.index)
end


-- ""
function net.S2C_Player_QueryResPlanetByStellar(args)
    ResPlanetData.S2C_Player_QueryResPlanetByStellar(args.planets)
end

function net.S2C_Player_GetMyStarmapRewardList(args)
    GalaxyData.S2C_Player_GetMyStarmapRewardList(args)
end

function net.S2C_Player_DrawMyStarmapReward(args)
    GalaxyData.S2C_Player_DrawMyStarmapReward(args)
end

function net.S2C_Player_StarmapGridCount(args)
    GalaxyData.S2C_Player_StarmapGridCount(args)
end

function net.S2C_Player_StarmapTransferBeginGrid(args)
    GalaxyData.S2C_Player_StarmapTransferBeginGrid(args)
end

function net.S2C_Player_Starmap_Exclusive_Grids(args)
    local data = args.data
    GalaxyData.S2C_Player_Starmap_Exclusive_Grids(data)
end

function net.S2C_Player_ResPlanetBriefUpdate(args)
    ResPlanetData.S2C_Player_ResPlanetBriefUpdate(args.planet)
end

function net.S2C_Player_ResPlanetFightBegin(args)
    ResPlanetData.S2C_Player_ResPlanetFightBegin(args)
end

function net.S2C_Player_ResPlanetFightEnd(args)
    ResPlanetData.S2C_Player_ResPlanetFightEnd(args)
end

function net.S2C_Player_ResPlanetPack(args)
    ResPlanetData.S2C_Player_ResPlanetPack(args.index)
end

function net.S2C_Player_ResPlanetUnpack(args)
    ResPlanetData.S2C_Player_ResPlanetUnpack(args.index)
end

function net.S2C_Player_PickBoatResNotify(args)
    local boats = args.boats
    ResPlanetData.S2C_Player_PickBoatResNotify(boats)
end

function net.S2C_Player_Exchange_Rate(args)
    ResData.S2C_Player_Exchange_Rate(args)
end

function net.S2C_Player_FightReports(args)
    local reports = args.reports
    local battleType = args.battleType
    BattleReportData.S2C_Player_FightReports(reports, battleType)
end

function net.S2C_Player_FightReportAdd(args)
    local report = args.report
    -- BattleReportData.S2C_Player_FightReportAdd(report)
end

function net.S2C_Player_PvpData(args)
    BattleData.S2C_Player_PvpData(args)
end

function net.S2C_Player_pvpMatchRewardTips(args)
    BattleData.S2C_Player_pvpMatchRewardTips(args)
end

function net.S2C_Player_FoundationData(args)
    BattleData.S2C_Player_FoundationData(args)
end

function net.S2C_Player_PvpScoutFoundation(args)
    BattleData.S2C_Player_PvpScoutFoundation(args)
end

function net.S2C_Player_ChatVisitFoundation(args)
    BattleData.S2C_Player_ChatVisitFoundation(args)
end

function net.S2C_Player_UnionVisitFoundation(args)
    BattleData.S2C_Player_UnionVisitFoundation(args)
end

function net.S2C_Player_PveScoutFoundation(args)
    BattleData.S2C_Player_PveScoutFoundation(args)
end

function net.S2C_Player_PvpGmRobotPlayers(args)
    BattleData.S2C_Player_PvpGmRobotPlayers(args)
end

function net.S2C_Player_sendPvpBackGroundCfg(args)
    BattleData.S2C_Player_sendPvpBackGroundCfg(args)
end

function net.S2C_Player_pvpMatchRewardRecords(args)
    BattleData.S2C_Player_pvpMatchRewardRecords(args)
end

function net.S2C_Player_PveInfo(args)
    BattleData.S2C_Player_PveInfo(args)
end

function net.S2C_Player_Rank_Info(args)
    RankData.S2C_Player_Rank_Info(args)
end

function net.S2C_Player_FirstGetGridRank(args)
    RankData.S2C_Player_FirstGetGridRank(args)
end

function net.S2C_Player_AirwayData(args)
    local airways = args.airways
    RoutesData.S2C_Player_AirwayData(airways)
end

function net.S2C_Player_AirwayUpdate(args)
    local airway = args.airway
    RoutesData.routesData[airway.cfgId] = airway
end

function net.S2C_Player_AchievementData(args)
end

function net.S2C_Player_AchievementUpdate(args)
end

function net.S2C_Player_AchievementReplace(args)
end

function net.S2C_Player_TaskData(args)
end

function net.S2C_Player_TaskUpdate(args)
    AchievementData.S2C_Player_TaskUpdate(args)
end

function net.S2C_Player_TaskReplace(args)
end

function net.S2C_Player_SystemNotice(args)
    MsgData.S2C_Player_SystemNotice(args)
end

function net.S2C_Player_MitNotEnoughTips(args)
    MsgData.S2C_Player_MitNotEnoughTips(args)
end

-- function net.S2C_Player_QueryGalaxys(args)
--     local galaxys = args.galaxys
--     GalaxyData.S2C_Player_QueryGalaxys(galaxys)

-- end

function net.S2C_Player_EnterStarmap(args)
    local grids = args.grids
    local beginGridId = args.beginGridId
    local season = args.season
    local lifeTime = args.lifeTime
    local score = args.score

    GalaxyData.S2C_Player_EnterStarmap(grids, beginGridId, season, lifeTime, score)
end

function net.S2C_Player_ScoutStarmapGrid(args)
    local grid = args.grid
    GalaxyData.S2C_Player_ScoutStarmapGrid(grid)
end

function net.S2C_Player_buildOnGridAdd(args)
    local cfgId = args.cfgId
    local build = args.build

    GalaxyData.S2C_Player_buildOnGridAdd(cfgId, build)
end

function net.S2C_Player_buildOnGridUpdate(args)
    local cfgId = args.cfgId
    local buildId = args.buildId
    local pos = args.pos

    GalaxyData.S2C_Player_buildOnGridUpdate(cfgId, buildId, pos)
end

function net.S2C_Player_buildOnGridDel(args)
    local cfgId = args.cfgId
    local buildId = args.buildId

    GalaxyData.S2C_Player_buildOnGridDel(cfgId, buildId)
end

function net.S2C_Player_MyDaoInfo(args)
    DaoData.S2C_Player_MyDaoInfo(args.myDaoInfo)
end

function net.S2C_Player_JoinableDaoList(args)
    DaoData.S2C_Player_JoinableDaoList(args)
end

function net.S2C_Player_SearchDaoResult(args)
    DaoData.S2C_Player_SearchDaoResult(args)
end

function net.S2C_Player_QueryDaoDetail(args)
    DaoData.S2C_Player_QueryDaoDetail(args.daoInfo)
end

function net.S2C_Player_DaoPlayerApplyList(args)
    DaoData.S2C_Player_DaoPlayerApplyList(args.applyList)
end

function net.S2C_Player_AnswerJoinDaoApply(args)
    DaoData.S2C_Player_AnswerJoinDaoApply(args)
end

-- dao
function net.S2C_Player_DaoPlayerApplyAdd(args)
    DaoData.S2C_Player_DaoPlayerApplyUpdate(args.apply)
end

function net.S2C_Player_DaoPlayerApplyUpdate(args)
    DaoData.S2C_Player_DaoPlayerApplyUpdate(args.apply)
end

function net.S2C_Player_DaoAppointJob(args)
    DaoData.S2C_Player_DaoAppointJob(args)
end

function net.S2C_Player_DaoMemberUpdate(args)
    DaoData.DaoMemberUpdate(args.member.playerId, DaoData.MEMBER_UPDATE_TYPE_UPDATE, args.member)
end

function net.S2C_Player_DaoMemberAdd(args)
    DaoData.DaoMemberUpdate(args.member.playerId, DaoData.MEMBER_UPDATE_TYPE_ADD, args.member)
end

function net.S2C_Player_DaoMemberDel(args)
    DaoData.DaoMemberUpdate(args.playerId, DaoData.MEMBER_UPDATE_TYPE_DEL)
end

function net.S2C_Player_DaoTransferPresident(args)
    DaoData.S2C_Player_DaoTransferPresident(args)
end

function net.S2C_Player_DaoTaxData(args)
    DaoData.S2C_Player_DaoTaxData(args)
end

function net.S2C_Player_QueryDaoVoteData(args)
    DaoData.S2C_Player_QueryDaoVoteData(args)
end

function net.S2C_Player_DaoTaxSettleData(args)
    DaoData.S2C_Player_DaoTaxSettleData(args)
end

function net.S2C_Player_DaoInvite(args)
    DaoData.S2C_Player_DaoInvite(args)
end

function net.S2C_Player_ChatMsgs(args)
    ChatData.S2C_Player_ChatMsgs(args)
end

-- player
function net.S2C_Player_PlayerInfo(args)
    PlayerData.S2C_Player_PlayerInfo(args)
end

function net.S2C_Player_NextGuides(args)
    PlayerData.S2C_Player_NextGuides(args)
end

function net.S2C_Player_Wallet(args)
    PlayerData.S2C_Player_Wallet(args.ownerAddress, args.chainId)
end

-- ""
function net.S2C_Player_MailUpdate(args)
    local type = args.op_type
    local mailList = args.mailList
    MailData.S2C_Player_MailUpdate(type, mailList)
end

function net.S2C_Player_MailDetail(args)
    local mail = args.mail
    MailData.S2C_Player_MailDetail(mail)
end

-- card
function net.S2C_Player_CardUpdate(args)
    CardData.S2C_Player_CardUpdate(args)
end

function net.S2C_Player_drawCardResult(args)
    CardData.S2C_Player_drawCardResult(args)
end

-- ""
function net.S2C_Player_JoinableUnionList(args)
    UnionData.S2C_Player_JoinableUnionList(args)
end

function net.S2C_Player_UnionBaseInfo(args)
    UnionData.S2C_Player_UnionBaseInfo(args)
end

function net.S2C_Player_MyUnionInfo(args)
    UnionData.S2C_Player_MyUnionInfo(args)
end

function net.S2C_Player_UnionJob(args)
    UnionData.S2C_Player_UnionJob(args)
end

function net.S2C_Player_UnionMemberDel(args)
    UnionData.S2C_Player_UnionMemberDel(args)
end

function net.S2C_Player_UnionMembers(args)
    UnionData.S2C_Player_UnionMembers(args)
end

function net.S2C_Player_UnionApplyList(args)
    UnionData.S2C_Player_UnionApplyList(args)
end

function net.S2C_Player_SearchUnionResult(args)
    UnionData.S2C_Player_SearchUnionResult(args)
end

function net.S2C_Player_UnionInviteList(args)
    UnionData.S2C_Player_UnionInviteList(args)
end

function net.S2C_Player_UnionNfts(args)
    UnionData.S2C_Player_UnionNfts(args)
end

function net.S2C_Player_UnionRes(args)
    UnionData.S2C_Player_UnionRes(args)
end

function net.S2C_Player_QueryDaoVoteData(args)
    UnionData.S2C_Player_QueryDaoVoteData(args)
end

function net.S2C_Player_SearchPlayer(args)
    UnionData.S2C_Player_SearchPlayer(args)
end

function net.S2C_Player_UnionSoliders(args)
    UnionData.S2C_Player_UnionSoliders(args)
end

function net.S2C_Player_UnionBuilds(args)
    UnionData.S2C_Player_UnionBuilds(args)
end

function net.S2C_Player_UnionTechs(args)
    UnionData.S2C_Player_UnionTechs(args)
end

function net.S2C_Player_UnionStarmapCampaignReportUpdate(args)
    UnionData.S2C_Player_UnionStarmapCampaignReportUpdate(args)
end

function net.S2C_Player_StarmapCampaignReportUpdate(args)
    UnionData.S2C_Player_StarmapCampaignReportUpdate(args)
end

function net.S2C_Player_UnionStarmapBattleReports(args)
    UnionData.S2C_Player_UnionStarmapBattleReports(args)
end

function net.S2C_Player_StarmapBattleReports(args)
    UnionData.S2C_Player_StarmapBattleReports(args)
end

function net.S2C_Player_StarmapCampaignPlyStatistics(args)
    UnionData.S2C_Player_StarmapCampaignPlyStatistics(args)
end

function net.S2C_Player_UnionStarmapCampaignReports(args)
    UnionData.S2C_Player_UnionStarmapCampaignReports(args)
end

function net.S2C_Player_StarmapCampaignReports(args)
    UnionData.S2C_Player_StarmapCampaignReports(args)
end

function net.S2C_Player_UnionStartEditArmy(args)
    UnionData.S2C_Player_UnionStartEditArmy(args)
end

function net.S2C_Player_StarmapRankList(args)
    UnionData.S2C_Player_StarmapRankList(args)
end

function net.S2C_Player_StarmapHyJackpot(args)
    UnionData.S2C_Player_StarmapHyJackpot(args)
end

function net.S2C_Player_StarmapMatchUnionGrids(args)
    UnionData.S2C_Player_StarmapMatchUnionGrids(args)
end

function net.S2C_Player_StarmapMatchPersonalGrids(args)
    UnionData.S2C_Player_StarmapMatchPersonalGrids(args)
end

function net.S2C_Player_MyGridAdd(args)
    UnionData.S2C_Player_MyGridAdd(args)
end

function net.S2C_Player_MyGridDel(args)
    UnionData.S2C_Player_MyGridDel(args)
end

function net.S2C_Player_StarmapScore(args)
    UnionData.S2C_Player_StarmapScore(args)
end

function net.S2C_Player_GuildReserveArmy(args)
    UnionData.S2C_Player_GuildReserveArmy(args)
end

function net.S2C_Player_DonateDaoItem(args)
    UnionData.S2C_Player_DonateDaoItem(args)
end

function net.S2C_Player_starmapGridUpdate(args)
    GalaxyData.S2C_Player_starmapGridUpdate(args)

end

function net.S2C_Player_SubscribeGrids(args)
    GalaxyData.S2C_Player_SubscribeGrids(args)

end

function net.S2C_Player_AutoPushStatus(args)
    AutoPushData.S2C_Player_AutoPushStatus(args)
end

function net.S2C_Player_Url_Config(args)
    AutoPushData.S2C_Player_Url_Config(args)
end

-- ""
function net.S2C_Player_GetMyFavoriteGridList(args)
    GalaxyData.S2C_Player_GetMyFavoriteGridList(args)
end

-- ""
function net.S2C_Player_GetUnionFavoriteGridList(args)
    GalaxyData.S2C_Player_GetUnionFavoriteGridList(args)
end


-- ""
function net.S2C_Player_MyFavoriteGridAdd(args)
    GalaxyData.S2C_Player_MyFavoriteGridAdd(args)
end

-- ""
function net.S2C_Player_MyFavoriteGridDel(args)
    GalaxyData.S2C_Player_MyFavoriteGridDel(args)
end

-- ""
function net.S2C_Player_UnionFavoriteGridAdd(args)
    GalaxyData.S2C_Player_UnionFavoriteGridAdd(args)
end

-- ""
function net.S2C_Player_UnionFavoriteGridDel(args)
    GalaxyData.S2C_Player_UnionFavoriteGridDel(args)
end

-- ""
function net.S2C_Player_StarmapMinimap(args)
    GalaxyData.S2C_Player_StarmapMinimap(args)
end

function net.S2C_Player_Starmap_Exclusive_Grids(args)
    GalaxyData.S2C_Player_Starmap_Exclusive_Grids(args)
end

------------------------------------------------------------

function net.S2C_Player_ChainBridgeInfo(args)
    ChainBridgeData.S2C_Player_ChainBridgeInfo(args)
end

function net.S2C_Player_GetLaunchBridgeRecrods(args)
    ChainBridgeData.S2C_Player_GetLaunchBridgeRecrods(args)
end

function net.S2C_Player_LaunchBridgeFees(args)
    ChainBridgeData.S2C_Player_LaunchBridgeFees(args)

end

function net.S2C_Player_UnionGridDel(args)
    GalaxyData.S2C_Player_UnionGridDel(args)
end

-- DraftData

function net.S2C_Player_ReserveArmyUpdate(args)
    DraftData.S2C_Player_ReserveArmyUpdate(args)
end

-- army
function net.S2C_Player_ArmysQuery(args)
    PlayerData.S2C_Player_ArmysQuery(args)
end

function net.S2C_Player_DrawCardData(args)
    DrawCardData.S2C_Player_DrawCardData(args)
end

function net.S2C_Player_DrawCardResult(args)
    DrawCardData.S2C_Player_DrawCardResult(args)
end

-- function net.S2C_Player_MintsUpdate(args)
--     DrawCardData.S2C_Player_DrawCardData(args)
-- end

function net.S2C_Player_MintsUpdate(args)
    MintData.S2C_Player_MintsUpdate(args)
end

function net.S2C_Player_DrawCardRecords(args)
    DrawCardData.S2C_Player_DrawCardRecords(args)
end

function net.S2C_Player_UnionSelfBattleResult(args)
    BattleData.S2C_Player_UnionSelfBattleResult(args)
end

-- army Shrine

function net.S2C_Player_SanctuaryHeros(args)
    ShrineData.S2C_Player_SanctuaryHeros(args)
end

-- activity

function net.S2C_Player_CumulativeFunds(args)
    ActivityData.S2C_Player_CumulativeFunds(args)
end

function net.S2C_Player_Recharge(args)
    ActivityData.S2C_Player_Recharge(args)
end

function net.S2C_Player_DoubelRecharge(args)
    ActivityData.S2C_Player_DoubelRecharge(args)
end

function net.S2C_Player_MoonCard(args)
    ActivityData.S2C_Player_MoonCard(args)
end

function net.S2C_Player_DailyCheck(args)
    ActivityData.S2C_Player_DailyCheck(args)
end

function net.S2C_Player_DailyGift(args)
    ActivityData.S2C_Player_DailyGift(args)
end

function net.S2C_Player_ShoppingMall(args)
    ActivityData.S2C_Player_ShoppingMall(args)
end


function net.S2C_Player_LoginActivityInfo(args)
    ActivityData.S2C_Player_LoginActivityInfo(args)
end

------------------------------------------

function net.S2C_Player_PayChannelInfo(args)
    PlayerData.S2C_Player_PayChannelInfo(args)
end

-- shop
function net.S2C_Player_MoreBuilder(args)
    ShopData.S2C_Player_MoreBuilder(args)
end

function net.S2C_Player_TipNote(args)
    ShopData.S2C_Player_TipNote(args)
end

function net.S2C_Player_StarPack(args)
    ShopData.S2C_Player_StarPack(args)
end

return net
