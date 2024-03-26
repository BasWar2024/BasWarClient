GalaxyData = {}
GalaxyData.galaxyData = {} -- ""
GalaxyData.galaxyBrief = {} -- ""
GalaxyData.resPlanetData = {} -- ""

GalaxyData.curPlanetCfgId = 0
GalaxyData.season = 1
GalaxyData.lifeTime = 0
GalaxyData.score = 0

GalaxyData.gridReward = {}
GalaxyData.gridRewardRecords = {}
GalaxyData.matchRewards = {}

GalaxyData.StarmapGridCountData = {}

GalaxyData.unionFavGrids = {}
GalaxyData.myFavGrids = {}

GalaxyData.unionFavGridCount = nil
GalaxyData.myFavGridsCount = nil

GalaxyData.specialGround = {}

-- -- ""
-- function GalaxyData.C2S_Player_QueryGalaxys()
--     gg.client.gameServer:send("C2S_Player_QueryGalaxys", {})
-- end

-- -- ""
-- function GalaxyData.S2C_Player_QueryGalaxys(galaxys)
--     GalaxyData.galaxyData = {}

--     for _, v in pairs(galaxys) do
--         GalaxyData.galaxyData[v.cfgId] = v
--     end
--     gg.event:dispatchEvent("onEnterGalaxyScene")
-- end

-- 2022.05.31""
-- ""
function GalaxyData.C2S_Player_EnterStarmap(gridCfgIds)
    gg.client.gameServer:send("C2S_Player_enterStarmap", {
        gridCfgIds = gridCfgIds
    })
end

-- ""
function GalaxyData.C2S_Player_LeaveStarmap()
    gg.client.gameServer:send("C2S_Player_leaveStarmap", {})
    GalaxyData.galaxyBrief = {}
    GalaxyData.unionFavGrids = {}
    GalaxyData.myFavGrids = {}

end

-- ""
function GalaxyData.C2S_Player_scoutStarmapGrid(cfgId)
    GalaxyData.curPlanetCfgId = cfgId
    gg.client.gameServer:send("C2S_Player_scoutStarmapGrid", {
        cfgId = cfgId
    })
end

-- ""
function GalaxyData.C2S_Player_putBuildOnGrid(cfgId, buildId, pos)
    gg.client.gameServer:send("C2S_Player_putBuildOnGrid", {
        cfgId = cfgId,
        buildId = buildId,
        pos = pos
    })
end

-- ""g""
function GalaxyData.C2S_Player_PutUnionBuildOnGrid(cfgId, buildId, pos)
    gg.client.gameServer:send("C2S_Player_PutUnionBuildOnGrid", {
        cfgId = cfgId,
        buildId = buildId,
        pos = pos
    })
end

-- ""
function GalaxyData.C2S_Player_moveBuildOnGrid(cfgId, buildId, x, z)
    gg.client.gameServer:send("C2S_Player_moveBuildOnGrid", {
        cfgId = cfgId,
        buildId = buildId,
        pos = Vector3.New(x, 0, z)
    })
    gg.uiManager:onOpenPnlLink("Player_BuildCreate", true)

end

-- ""
function GalaxyData.C2S_Player_delBuildOnGrid(cfgId, buildId)
    gg.client.gameServer:send("C2S_Player_delBuildOnGrid", {
        cfgId = cfgId,
        buildId = buildId
    })
end

-- ""
function GalaxyData.C2S_Player_GiveUpMyGrid(cfgId)
    gg.client.gameServer:send("C2S_Player_GiveUpMyGrid", {
        cfgId = cfgId
    })
end

-- ""
function GalaxyData.C2S_Player_storeBuildOnGrid(cfgId, buildId)
    gg.client.gameServer:send("C2S_Player_storeBuildOnGrid", {
        cfgId = cfgId,
        buildId = buildId
    })
end

-- ""
function GalaxyData.C2S_Player_SubscribeGrids(cfgIds)
    gg.client.gameServer:send("C2S_Player_subscribeGrids", {
        cfgIds = cfgIds
    })
end

-- ""
function GalaxyData.C2S_Player_unsubscribeGrids(cfgIds)
    gg.client.gameServer:send("C2S_Player_unsubscribeGrids", {
        cfgIds = cfgIds
    })
end

-- ""
function GalaxyData.C2S_Player_GetMyStarmapRewardList()
    gg.client.gameServer:send("C2S_Player_GetMyStarmapRewardList", {})
end

-- ""
function GalaxyData.C2S_Player_DrawMyStarmapReward()
    gg.client.gameServer:send("C2S_Player_DrawMyStarmapReward", {})
end

-- ""
function GalaxyData.C2S_Player_StarmapTransferBeginGrid(cfgId)
    GalaxyData.lastBeginGridId = UnionData.beginGridId
    gg.client.gameServer:send("C2S_Player_StarmapTransferBeginGrid", {
        cfgId = cfgId
    })
end

-- ""
function GalaxyData.C2S_Player_GetMyFavoriteGridList()
    gg.client.gameServer:send("C2S_Player_GetMyFavoriteGridList", {})
end

-- ""
function GalaxyData.C2S_Player_GetUnionFavoriteGridList()
    gg.client.gameServer:send("C2S_Player_GetUnionFavoriteGridList", {})
end

-- ""
function GalaxyData.C2S_Player_AddMyFavoriteGrid(cfgId, tag)
    gg.client.gameServer:send("C2S_Player_AddMyFavoriteGrid", {
        cfgId = cfgId,
        tag = tag
    })
end

-- ""
function GalaxyData.C2S_Player_DelMyFavoriteGrid(cfgId)
    gg.client.gameServer:send("C2S_Player_DelMyFavoriteGrid", {
        cfgId = cfgId
    })
end

-- ""
-- function GalaxyData.C2S_Player_QueryFavoriteResPlanets()
--     gg.client.gameServer:send("C2S_Player_QueryFavoriteResPlanets", {})
-- end

-- ""
function GalaxyData.C2S_Player_AddUnionFavoriteGrid(cfgId, tag)
    gg.client.gameServer:send("C2S_Player_AddUnionFavoriteGrid", {
        cfgId = cfgId,
        tag = tag
    })
end

-- ""
function GalaxyData.C2S_Player_DelUnionFavoriteGrid(cfgId)
    gg.client.gameServer:send("C2S_Player_DelUnionFavoriteGrid", {
        cfgId = cfgId
    })
end

-- ""
function GalaxyData.C2S_Player_StarmapMinimap()
    gg.client.gameServer:send("C2S_Player_StarmapMinimap", {})
    gg.uiManager:onOpenPnlLink("Player_StarmapMinimap")
end

----------------S2C---------------------------------------
-- ""
function GalaxyData.S2C_Player_EnterStarmap(grids, beginGridId, season, lifeTime, score)
    GalaxyData.galaxyBrief = {}

    for _, v in pairs(grids) do
        GalaxyData.galaxyBrief[v.cfgId] = v
    end

    if UnionData.beginGridId == 0 and beginGridId ~= 0 then
        local curCfg = gg.galaxyManager:getGalaxyCfg(beginGridId)
        gg.galaxyManager:getAreaMembers(Vector2.New(curCfg.pos.x, curCfg.pos.y), true)
    end

    UnionData.beginGridId = beginGridId
    GalaxyData.lastBeginGridId = UnionData.beginGridId
    GalaxyData.season = season
    GalaxyData.lifeTime = lifeTime
    GalaxyData.lifeTimeEnd = lifeTime + os.time()
    GalaxyData.score = score

    gg.event:dispatchEvent("onEnterGalaxyScene")
end

-- ""
function GalaxyData.S2C_Player_Starmap_Exclusive_Grids(data)
    print("sssssssss data:")
    print(table.dump(data))
end

-- ""
function GalaxyData.S2C_Player_ScoutStarmapGrid(grid)
    GalaxyData.resPlanetData = {}
    GalaxyData.resPlanetData = grid
    if GalaxyData.resPlanetData.cfgId == 0 then
        GalaxyData.resPlanetData.cfgId = GalaxyData.curPlanetCfgId
    end
    gg.galaxyManager:onLookResPlanetData()
end

-- ""
function GalaxyData.S2C_Player_buildOnGridAdd(cfgId, build)
    gg.event:dispatchEvent("onRefreshBuildNum", 1)
    gg.event:dispatchEvent("onAddOtherBuild", build)
    gg.buildingManager:buildSuccessful(build, true)
end

-- ""
function GalaxyData.S2C_Player_buildOnGridUpdate(cfgId, buildId, pos)
    gg.event:dispatchEvent("onUpdateGalaxyBuildPos", buildId, pos)
    gg.uiManager:onClosePnlLink("Player_BuildCreate")

end

-- ""
function GalaxyData.S2C_Player_buildOnGridDel(cfgId, buildId)
    gg.event:dispatchEvent("onRefreshBuildNum", -1)
    gg.event:dispatchEvent("onRemoveOtherBuilding", buildId)
end

-- ""
function GalaxyData.S2C_Player_starmapGridUpdate(args)
    local grid = args.grid
    GalaxyData.galaxyBrief[grid.cfgId] = grid

    gg.event:dispatchEvent("onUpdateGround", grid)

end

--  ""
function GalaxyData.S2C_Player_UnionGridDel(args)
    gg.event:dispatchEvent("OnGridDel")
end

function GalaxyData.S2C_Player_SubscribeGrids(args)
    local grids = args.grids
    local unionFavGrids = args.unionFavGrids
    local myFavGrids = args.myFavGrids

    for _, v in pairs(grids) do
        GalaxyData.galaxyBrief[v.cfgId] = v
        gg.event:dispatchEvent("onRefreshBoxInfomation", v.cfgId)
    end

    for k, v in pairs(unionFavGrids) do
        GalaxyData.unionFavGrids[v] = v
    end
    for k, v in pairs(myFavGrids) do
        GalaxyData.myFavGrids[v] = v
    end

    gg.event:dispatchEvent("onUpdateGrounds", grids)
end

-- ""
function GalaxyData.S2C_Player_GetMyStarmapRewardList(args)
    GalaxyData.gridRewardRecords = {}
    local gridReward = args.gridReward -- ""
    local gridRewardRecords = args.gridRewardRecords -- ""
    local matchRewards = args.matchRewards -- ""

    GalaxyData.gridReward = gridReward

    for k, v in pairs(gridRewardRecords) do
        table.insert(GalaxyData.gridRewardRecords, 1, v)
    end

    GalaxyData.matchRewards = matchRewards

    gg.uiManager:openWindow("PnlMaterialReward")
end

-- ""
function GalaxyData.S2C_Player_DrawMyStarmapReward(args)
    local gridReward = args.gridReward -- ""
    GalaxyData.gridReward = gridReward
    gg.event:dispatchEvent("onSetReward")
end

-- ""
function GalaxyData.S2C_Player_StarmapGridCount(args)
    GalaxyData.StarmapGridCountData = args
end

-- ""
function GalaxyData.S2C_Player_StarmapTransferBeginGrid(args)
    if args.cfgId ~= 0 then
        UnionData.beginGridId = args.cfgId
        gg.event:dispatchEvent("onRefreshBeginGrid", GalaxyData.lastBeginGridId, UnionData.beginGridId)
        gg.uiManager:showTip(Utils.getText("league_Move_Successful"))
        GalaxyData.lastBeginGridId = UnionData.beginGridId
    else
        -- gg.uiManager:showTip(Utils.getText("league_Move_Failed"))
    end
end

-- ""
function GalaxyData.S2C_Player_GetMyFavoriteGridList(args)
    local grids = args.grids
    local unionGrids = args.unionGrids
    GalaxyData.unionFavGridCount = #unionGrids
    GalaxyData.myFavGridsCount = #grids
    gg.event:dispatchEvent("onLoadMaskBoxGrids", unionGrids, grids)
    gg.event:dispatchEvent("onRefreshTxtCollectionNum", unionGrids, grids)

end

-- ""
function GalaxyData.S2C_Player_GetUnionFavoriteGridList(args)

end

-- ""
function GalaxyData.S2C_Player_MyFavoriteGridAdd(args)
    local cfgId = args.cfgId
    GalaxyData.myFavGrids[cfgId] = args
    if GalaxyData.myFavGridsCount then
        GalaxyData.myFavGridsCount = GalaxyData.myFavGridsCount + 1
    end
end

-- ""
function GalaxyData.S2C_Player_MyFavoriteGridDel(args)
    local cfgId = args.cfgId
    GalaxyData.myFavGrids[cfgId] = nil
    if GalaxyData.myFavGridsCount then
        GalaxyData.myFavGridsCount = GalaxyData.myFavGridsCount - 1
    end
end

-- ""
function GalaxyData.S2C_Player_UnionFavoriteGridAdd(args)
    local cfgId = args.cfgId
    GalaxyData.unionFavGrids[cfgId] = args
    if GalaxyData.unionFavGridCount then
        GalaxyData.unionFavGridCount = GalaxyData.unionFavGridCount + 1
    end

end

-- ""
function GalaxyData.S2C_Player_UnionFavoriteGridDel(args)
    local cfgId = args.cfgId
    GalaxyData.unionFavGrids[cfgId] = nil
    if GalaxyData.unionFavGridCount then
        GalaxyData.unionFavGridCount = GalaxyData.unionFavGridCount - 1
    end

end

-- ""
function GalaxyData.S2C_Player_StarmapMinimap(args)
    local list = args.list
    GalaxyData.StarmapMinimap = {}
    for k, v in pairs(list) do
        GalaxyData.StarmapMinimap[v.cfgId] = v
    end

    gg.uiManager:openWindow("PnlSmallMap")
    gg.uiManager:onClosePnlLink("Player_StarmapMinimap")
end

function GalaxyData.S2C_Player_Starmap_Exclusive_Grids(args)
    GalaxyData.specialGround = {}

    for k, v in pairs(args.data) do
        GalaxyData.specialGround[v.cfgId] = v.chain
    end
end

return GalaxyData

