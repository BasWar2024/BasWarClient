BuildData = {}

BuildData.buildData = {}
BuildData.soliderLevelData = {}
BuildData.mineLevelData = {}
BuildData.pledgeData = {}


--
function BuildData.C2S_Player_BuildCreate(cfgId, x, z)
    gg.client.gameServer:send("C2S_Player_BuildCreate",{
        cfgId = cfgId,
        pos = Vector3.New(x, 0, z),
    })
end

--
function BuildData.C2S_Player_BuildMove(id, x, z)
    gg.client.gameServer:send("C2S_Player_BuildMove",{
        id = id,
        pos = Vector3.New(x, 0, z),
    })
end

--
function BuildData.C2S_Player_BuildExchange(fromId, toId)
    gg.client.gameServer:send("C2S_Player_BuildExchange",{
        fromId = fromId,
        toId = toId,
    })
end

--
function BuildData.C2S_Player_BuildLevelUp(id, speedUp)
    gg.client.gameServer:send("C2S_Player_BuildLevelUp",{
        id = id,
        speedUp = speedUp,
    })
end

--
function BuildData.C2S_Player_SpeedUp_BuildLevelUp(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_BuildLevelUp",{
        id = id,
    })
end

--
function BuildData.C2S_Player_BuildGetRes(id)
    gg.client.gameServer:send("C2S_Player_BuildGetRes",{
        id = id,
    })
end

--
function BuildData.C2S_Player_SoliderLevelUp(cfgId,speedUp)
    gg.client.gameServer:send("C2S_Player_SoliderLevelUp",{
        cfgId = cfgId,
        speedUp = speedUp,
    })
end

--
function BuildData.C2S_Player_SpeedUp_SoliderLevelUp(cfgId)
    gg.client.gameServer:send("C2S_Player_SpeedUp_SoliderLevelUp",{
        cfgId = cfgId,
    })
end

--
function BuildData.C2S_Player_MineLevelUp(cfgId,speedUp)
    gg.client.gameServer:send("C2S_Player_MineLevelUp",{
        cfgId = cfgId,
        speedUp = speedUp,
    })
end

--
function BuildData.C2S_Player_SpeedUp_MineLevelUp(cfgId)
    gg.client.gameServer:send("C2S_Player_SpeedUp_MineLevelUp",{
        cfgId = cfgId,
    })
end

--
function BuildData.C2S_Player_SoliderTrain(id, soliderCfgId, soliderCount)
    gg.client.gameServer:send("C2S_Player_SoliderTrain",{
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount,
    })
end

--
function BuildData.C2S_Player_SpeedUp_SoliderTrain(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_SoliderTrain",{
        id = id,
    })
end

--
function BuildData.C2S_Player_SoliderReplace(id, soliderCfgId, soliderCount)
    gg.client.gameServer:send("C2S_Player_SoliderReplace",{
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount,
    })
end

--
function BuildData.C2S_Player_RemoveMess(id)
    gg.client.gameServer:send("C2S_Player_RemoveMess",{
        id = id,
    })
end

--
function BuildData.C2S_Player_Pledge(cfgId, mit)
    gg.client.gameServer:send("C2S_Player_Pledge",{
        cfgId = cfgId,
        mit = mit,
    })
end

--
function BuildData.C2S_Player_PledgeCancel(cfgId)
    gg.client.gameServer:send("C2S_Player_PledgeCancel",{
        cfgId = cfgId,
    })
end

function BuildData.S2C_Player_BuildData(buildData)
    --print("S2C_Player_BuildData:", table.dump(buildData))
    BuildData.buildData = {}
    for _, build in ipairs(buildData) do
        BuildData.buildData[build.id] = build
        build.lessTickEnd = build.lessTick + os.time()
    end
end

function BuildData.S2C_Player_BuildAdd(build)
    gg.buildingManager:buildSuccessful(build)
    BuildData.refreshData(build)
end

function BuildData.S2C_Player_BuildMove(ret, build)
    --ret = 0 ;ret = 1 
    if ret == 0 then
        BuildData.refreshData(build)
    end
end

function BuildData.S2C_Player_BuildLevelUp(build)
    BuildData.refreshData(build)
end

function BuildData.S2C_Player_BuildUpdate(build)
    BuildData.refreshData(build)
end

function BuildData.S2C_Player_BuildGetRes(args)
    gg.buildingManager:buildGetResMsg(args)
end

function BuildData.refreshData(build)
    BuildData.buildData[build.id] = build
    build.lessTickEnd = build.lessTick + os.time()
    gg.event:dispatchEvent("onUpdateBuildData", build)
end

function BuildData.S2C_Player_SoliderLevelData(soliderLevelData)
    BuildData.soliderLevelData = {}
    for _, skillLevel in ipairs(soliderLevelData) do
        BuildData.updateSoliderData(skillLevel)
    end
    gg.event:dispatchEvent("onSoliderChange")
end

function BuildData.S2C_Player_SoliderLevelUpdate(soliderLevel)
    BuildData.updateSoliderData(soliderLevel)
    gg.event:dispatchEvent("onSoliderChange")
end

function BuildData.updateSoliderData(data)
    BuildData.soliderLevelData[data.cfgId] = data
    data.lessTickEnd = data.lessTick + os.time()
end

function BuildData.S2C_Player_MineLevelData(mineLevelData)
    BuildData.mineLevelData = {}
    for _, mineLevel in ipairs(mineLevelData) do
        BuildData.updateMine(mineLevel)
    end
    gg.event:dispatchEvent("onMineChange")
end

function BuildData.S2C_Player_MineLevelUpdate(mineLevel)
    BuildData.updateMine(mineLevel)
    gg.event:dispatchEvent("onMineChange")
end

function BuildData.updateMine(mine)
    BuildData.mineLevelData[mine.cfgId] = mine
    mine.lessTickEnd = mine.lessTick + os.time()
end

function BuildData.S2C_Player_BuildDel(id)
    --print("S2C_Player_BuildDel:", id)
    BuildData.buildData[id] = nil
    gg.event:dispatchEvent("onRemoveBuilding", id)
end

function BuildData.S2C_Player_RemoveMess(args)
    --print("S2C_Player_RemoveMess:", args)
end

function BuildData.S2C_Player_PledgeData(pledgeData)
    BuildData.pledgeData = {}
    for key, value in pairs(pledgeData) do
        BuildData.pledgeData[value.cfgId] = value
    end
end

function BuildData.S2C_Player_PledgeAdd(pledge)
    BuildData.pledgeData[pledge.cfgId] = pledge
end

function BuildData.S2C_Player_PledgeDel(cfgId)
    BuildData.pledgeData[cfgId] = nil
end

return BuildData