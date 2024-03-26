ResPlanetData = {}

ResPlanetData.resPlanetBrief = {}

ResPlanetData.resBoatDatas = {}

ResPlanetData.resPlanetData = {}

ResPlanetData.myResPlanetData = {}

ResPlanetData.favoriteResPlanetData = {}

-- ""
function ResPlanetData.C2S_Player_putBuildListOnGrid(cfgId, buildList, from)
    gg.client.gameServer:send("C2S_Player_putBuildListOnGrid", {
        cfgId = cfgId,
        buildList = buildList,
        from = from,
    })
end

-- ""
function ResPlanetData.C2S_Player_PickBoatRes(boatIds)
    gg.client.gameServer:send("C2S_Player_PickBoatRes", {
        boatIds = boatIds
    })
end

-- ""
function ResPlanetData.C2S_Player_ResPlanetMoveBuild(index, buildId, x, z)
    gg.client.gameServer:send("C2S_Player_ResPlanetMoveBuild", {
        index = index,
        buildId = buildId,
        pos = Vector3.New(x, 0, z)
    })
end

-- ""
function ResPlanetData.C2S_Player_ResPlanetBuild2ItemBag(index, id)
    gg.client.gameServer:send("C2S_Player_ResPlanetBuild2ItemBag", {
        index = index,
        id = id
    })
end

-- ""
function ResPlanetData.C2S_Player_ItemBagBuild2ResPlanet(index, id, pos)
    gg.client.gameServer:send("C2S_Player_ItemBagBuild2ResPlanet", {
        index = index,
        id = id,
        pos = pos
    })
end

-- ""
function ResPlanetData.C2S_Player_LookResPlanet(index)
    gg.client.gameServer:send("C2S_Player_LookResPlanet", {
        index = index
    })
end

-- ""
function ResPlanetData.C2S_Player_QueryMyResPlanets()
    gg.client.gameServer:send("C2S_Player_QueryMyResPlanets", {})
end

-- ""
function ResPlanetData.C2S_Player_BeginAttackResPlanet(index)
    gg.client.gameServer:send("C2S_Player_BeginAttackResPlanet", {
        index = index
    })
end

-- ""
function ResPlanetData.C2S_Player_EndAttackResPlanet(index, isWin)
    gg.client.gameServer:send("C2S_Player_EndAttackResPlanet", {
        index = index,
        isWin = isWin
    })
end

-- ""
function ResPlanetData.C2S_Player_QueryResPlanetByStellar(stellarId)
    gg.client.gameServer:send("C2S_Player_QueryResPlanetByStellar", {
        stellarId = stellarId
    })
end



-- ""
function ResPlanetData.C2S_Player_ModifyResPlanetName(index, planetName)
    gg.client.gameServer:send("C2S_Player_ModifyResPlanetName", {
        index = index,
        planetName = planetName
    })
end

-- ""
function ResPlanetData.C2S_Player_ModifyPlanetRemark(index, remark)
    gg.client.gameServer:send("C2S_Player_ModifyPlanetRemark", {
        index = index,
        remark = remark
    })
end

-- ""
function ResPlanetData.C2S_Player_ResPlanet2ItemBag(index)
    gg.client.gameServer:send("C2S_Player_ResPlanet2ItemBag", {
        index = index,
    })
end

-- ""
function ResPlanetData.C2S_Player_PlaceResPlanet(itemId)
    gg.client.gameServer:send("C2S_Player_PlaceResPlanet", {
        itemId = itemId
    })
end
  
-- ""
function ResPlanetData.C2S_Player_putBuildListOnGrid(cfgId, buildList, from)
    gg.client.gameServer:send("C2S_Player_putBuildListOnGrid", {
        cfgId = cfgId,
        buildList = buildList,
        from = from,
    })
end


-- ""
function ResPlanetData.S2C_Player_ResPlanetData(planet)
    ResPlanetData.refreshResPlanetData(planet)
end

-- ""
function ResPlanetData.S2C_Player_PickBoatResNotify(boats)
    ResPlanetData.refreshResBoatData(boats)
end

-- ""
function ResPlanetData.S2C_Player_PickBoatRes(boats)
    gg.event:dispatchEvent("onCollectSuccessful", boats)
end

-- ""
function ResPlanetData.S2C_Player_ResPlanet_BuildAdd(index, build)
    gg.buildingManager:buildSuccessful(build)
end

-- ""
function ResPlanetData.S2C_Player_ResPlanet_BuildDel(index, buildId)
    gg.event:dispatchEvent("onRemoveOtherBuilding", buildId)
end

-- ""
function ResPlanetData.S2C_Player_ResPlanet_BuildUpdate(index, build)
    gg.event:dispatchEvent("onUpdateBuildData", build)
end

-- ""
function ResPlanetData.S2C_Player_MyResPlanets(planets)
    ResPlanetData.myResPlanetData = {}

    for k, v in pairs(planets) do
        ResPlanetData.myResPlanetData[v.index] = v
    end

    gg.uiManager:openWindow("PnlMyPlanet")
end

function ResPlanetData.S2C_Player_MyResPlanetAdd(planet)

end

function ResPlanetData.S2C_Player_MyResPlanetDel(index)

end

-- ""
function ResPlanetData.S2C_Player_ResPlanetBriefUpdate(planet)
    ResPlanetData.favoriteResPlanetData[planet.index] = planet
    gg.event:dispatchEvent("onRefreshBoxCollect")
    gg.event:dispatchEvent("onRefreshPlanetData", planet, nil)
    gg.uiManager:closeWindow("PnlRename")
end

-- ""
function ResPlanetData.S2C_Player_QueryResPlanetByStellar(planets)
    ResPlanetData.resPlanetBrief = {}
    for k, v in pairs(planets) do
        ResPlanetData.resPlanetBrief[v.index] = v
    end
    ResPlanetData.refreshResPlanetBrief()
end

-- ""
function ResPlanetData.S2C_Player_ResPlanetFightBegin(args)

end

-- ""
function ResPlanetData.S2C_Player_ResPlanetFightEnd(args)

end

-- ""
function ResPlanetData.S2C_Player_ResPlanetPack(index)
    gg.buildingManager:destroyOtherBuilding()
    gg.sceneManager:returnBaseScene()
end

-- ""
function ResPlanetData.S2C_Player_ResPlanetUnpack(index)

end

function ResPlanetData.refreshResBoatData(boats)
    ResPlanetData.resBoatDatas = {}
    ResPlanetData.resBoatDatas = boats
    gg.event:dispatchEvent("onRefreshBoatData")
end

function ResPlanetData.refreshResPlanetBrief(planet)
    if planet then
        ResPlanetData.resPlanetBrief[planet.index] = planet
    end
    gg.event:dispatchEvent("onRefreshResPlanetData")
end

function ResPlanetData.refreshResPlanetData(planet)
    ResPlanetData.resPlanetData = {}
    ResPlanetData.resPlanetData = planet
    --gg.event:dispatchEvent("onLookResPlanetData", planet)
end

return ResPlanetData
