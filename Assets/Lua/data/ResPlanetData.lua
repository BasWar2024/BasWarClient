ResPlanetData = {}

ResPlanetData.resPlanetBrief = {}

ResPlanetData.resBoatDatas = {}

ResPlanetData.resPlanetData = {}

-- 
function ResPlanetData.C2S_Player_PickBoatRes(boatIds)
    gg.client.gameServer:send("C2S_Player_PickBoatRes", {
        boatIds = boatIds
    })
end

-- 
function ResPlanetData.C2S_Player_ResPlanetMoveBuild(index, buildId, x, z)
    gg.client.gameServer:send("C2S_Player_ResPlanetMoveBuild", {
        index = index,
        buildId = buildId,
        pos = Vector3.New(x, 0, z),
    })
end

-- 
function ResPlanetData.C2S_Player_ResPlanetBuild2ItemBag(index, id)
    gg.client.gameServer:send("C2S_Player_ResPlanetBuild2ItemBag", {
        index = index,
        id = id
    })
end

-- 
function ResPlanetData.C2S_Player_ItemBagBuild2ResPlanet(index, id, pos)
    gg.client.gameServer:send("C2S_Player_ItemBagBuild2ResPlanet", {
        index = index,
        id = id,
        pos = pos
    })
end

-- 
function ResPlanetData.C2S_Player_LookResPlanet(index)
    gg.client.gameServer:send("C2S_Player_LookResPlanet", {
        index = index
    })
end

-- 
function ResPlanetData.C2S_Player_QueryAllResPlanetBrief()
    gg.client.gameServer:send("C2S_Player_QueryAllResPlanetBrief", {})
end

-- 
function ResPlanetData.C2S_Player_BeginAttackResPlanet(index)
    gg.client.gameServer:send("C2S_Player_BeginAttackResPlanet", {
        index = index
    })
end

-- 
function ResPlanetData.C2S_Player_EndAttackResPlanet(index, isWin)
    gg.client.gameServer:send("C2S_Player_EndAttackResPlanet", {
        index = index,
        isWin = isWin
    })
end

-- 
function ResPlanetData.S2C_Player_ResPlanetData(planet)
    ResPlanetData:refreshResPlanetData(planet)
end

-- 
function ResPlanetData.S2C_Player_PickBoatResNotify(boats)
    ResPlanetData:refreshResBoatData(boats)
end

-- 
function ResPlanetData.S2C_Player_PickBoatRes(boats)
    gg.event:dispatchEvent("onCollectSuccessful", boats)
end

-- 
function ResPlanetData.S2C_Player_ResPlanet_BuildAdd(index, build)
    gg.buildingManager:buildSuccessful(build)
end

-- 
function ResPlanetData.S2C_Player_ResPlanet_BuildDel(index, buildId)

end

-- 
function ResPlanetData.S2C_Player_ResPlanet_BuildUpdate(index, build)

end

-- 
function ResPlanetData.S2C_Player_AllResPlanetBrief(planets)
    ResPlanetData:refreshResPlanetBrief(planets)
end

-- 
function ResPlanetData.S2C_Player_ResPlanetFightBegin(args)

end

-- 
function ResPlanetData.S2C_Player_ResPlanetFightEnd(args)

end

function ResPlanetData:refreshResBoatData(boats)
    ResPlanetData.resBoatDatas = {}
    ResPlanetData.resBoatDatas = boats
    gg.event:dispatchEvent("onRefreshBoatData")
end

function ResPlanetData:refreshResPlanetBrief(planets)
    ResPlanetData.resPlanetBrief = {}
    ResPlanetData.resPlanetBrief = planets
    gg.event:dispatchEvent("onRefreshResPlanetData")
end

function ResPlanetData:refreshResPlanetData(planet)
    ResPlanetData.resPlanetData = {}
    ResPlanetData.resPlanetData = planet
    gg.event:dispatchEvent("onLookResPlanetData")
end

return ResPlanetData
