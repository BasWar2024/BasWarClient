local net = {}

function net.S2C_Player_LookBriefs(args)
    local session = args.session
    local briefs = args.briefs
    for i,brief in ipairs(briefs) do
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

function net.S2C_Player_ResChange(args)
    local resCfgId = args.resCfgId
    local count = args.count
    local change = args.change
    ResData.S2C_Player_ResChange(resCfgId, count, change)
end

function net.S2C_Player_BuildData(args)
    local buildData = args.buildData or {}
    BuildData.S2C_Player_BuildData(buildData)
end

function net.S2C_Player_BuildAdd(args)
    local build = args.build
    BuildData.S2C_Player_BuildAdd(build)
end

function net.S2C_Player_BuildMove(args)
    local ret = args.ret
    local build = args.build
    BuildData.S2C_Player_BuildMove(ret, build)
end

function net.S2C_Player_BuildLevelUp(args)
    local build = args.build
    BuildData.S2C_Player_BuildLevelUp(build)
end

function net.S2C_Player_BuildUpdate(args)
    local build = args.build
    BuildData.S2C_Player_BuildUpdate(build)
end

function net.S2C_Player_BuildGetRes(args)
    BuildData.S2C_Player_BuildGetRes(args)
end

function net.S2C_Player_SoliderLevelData(args)
    local soliderLevelData = args.soliderLevelData
    BuildData.S2C_Player_SoliderLevelData(soliderLevelData)
end

function net.S2C_Player_SoliderLevelUpdate(args)
    local soliderLevel = args.soliderLevel
    BuildData.S2C_Player_SoliderLevelUpdate(soliderLevel)
end

function net.S2C_Player_MineLevelData(args)
    local mineLevelData = args.mineLevelData
    BuildData.S2C_Player_MineLevelData(mineLevelData)
end

function net.S2C_Player_MineLevelUpdate(args)
    local mineLevel = args.mineLevel
    BuildData.S2C_Player_MineLevelUpdate(mineLevel)
end

function net.S2C_Player_BuildDel(args)
    local id = args.id
    BuildData.S2C_Player_BuildDel(id)
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

function net.S2C_Player_HeroData(args)
    local heroData = args.heroData or {}
    HeroData.S2C_Player_HeroData(heroData)
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

function net.S2C_Player_WarShipData(args)
    local warShipData = args.warShipData or {}
    WarShipData.S2C_Player_WarShipData(warShipData)
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

function net.S2C_Player_RepairItems(args)
    ItemData.S2C_Player_RepairItems(args.items)
end

function net.S2C_Player_RepairReturn(args)
    ItemData.S2C_Player_RepairReturn(args.successItems, args.totalCost)
end

function net.S2C_Player_RepairItemAdd(args)
    ItemData.S2C_Player_RepairItemUpdate(args.item)
end

function net.S2C_Player_RepairItemUpdate(args)
    ItemData.S2C_Player_RepairItemUpdate(args.item)
end

function net.S2C_Player_RepairItemDel(args)
    ItemData.S2C_Player_RepairItemDel(args.id)
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
    local build = args.build
    ResPlanetData.S2C_Player_ResPlanet_BuildDel(index, buildId)
end

function net.S2C_Player_ResPlanet_BuildUpdate(args)
    local index = args.index
    local build = args.build
    ResPlanetData.S2C_Player_ResPlanet_BuildUpdate(index, build)
end

function net.S2C_Player_AllResPlanetBrief(args)
    local planets = args.planets
    ResPlanetData.S2C_Player_AllResPlanetBrief(planets)
end

function net.S2C_Player_ResPlanetFightBegin(args)
    ResPlanetData.S2C_Player_ResPlanetFightBegin(args)
end

function net.S2C_Player_ResPlanetFightEnd(args)
    ResPlanetData.S2C_Player_ResPlanetFightEnd(args)
end

function net.S2C_Player_PickBoatResNotify(args)
    local boats = args.boats
    ResPlanetData.S2C_Player_PickBoatResNotify(boats)
end

function net.S2C_Player_Exchange_Rate(args)
    ResData.S2C_Player_Exchange_Rate(args)
end

return net