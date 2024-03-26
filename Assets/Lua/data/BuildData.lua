BuildData = {}

BuildData.buildData = {}
BuildData.soliderLevelData = {}
BuildData.soliderForgeData = {}
BuildData.mineLevelData = {}
BuildData.shipExistSoliderData = {}
BuildData.pledgeData = {}
BuildData.buildQueueCount = 1
BuildData.isSoldierUpgradeing = false

BuildData.BAG_TYPE_BUILDING = 0
BuildData.BAG_TYPE_NFT_TOWER = 1
BuildData.nftBuildData = {}

function BuildData.clear()
    BuildData.shipExistSoliderData = {}
    BuildData.buildQueueCount = 1
end

-- ""
function BuildData.C2S_Player_BuildCreate(cfgId, x, z, opType, guideNow)
    local protoName
    if EditData.isEditMode then
        protoName = "C2S_Player_GMBuildCreate"
    else
        protoName = "C2S_Player_BuildCreate"
    end

    gg.client.gameServer:send(protoName, {
        cfgId = cfgId,
        pos = Vector3.New(x, 0, z),
        opType = opType or 0,
        guideNow = guideNow
    })

    gg.uiManager:onOpenPnlLink("Player_BuildCreate", true)
end

-- ""
function BuildData.C2S_Player_BuildMove(id, x, z)
    local protoName
    if EditData.isEditMode then
        protoName = "C2S_Player_OPMoveBuild"
    else
        protoName = "C2S_Player_BuildMove"
    end

    gg.client.gameServer:send(protoName, {
        id = id,
        pos = Vector3.New(x, 0, z)
    })

    gg.uiManager:onOpenPnlLink("C2S_Player_BuildMove", true)
end

-- ""
function BuildData.C2S_Player_BuildExchange(fromId, toId)
    gg.client.gameServer:send("C2S_Player_BuildExchange", {
        fromId = fromId,
        toId = toId
    })
end

function BuildData.C2S_Player_freshBuild(buildId)
    gg.client.gameServer:send("C2S_Player_freshBuild", {
        buildId = buildId,
    })
end

-- speedUp 0""， 1""
-- ""
function BuildData.C2S_Player_BuildLevelUp(id, speedUp)
    gg.client.gameServer:send("C2S_Player_BuildLevelUp", {
        id = id,
        speedUp = speedUp
    })
    gg.uiManager:onOpenPnlLink("C2S_Player_BuildLevelUp", true)
end

-- ""
function BuildData.C2S_Player_BuildGetRes(id)
    gg.client.gameServer:send("C2S_Player_BuildGetRes", {
        id = id
    })
end

-- ""
function BuildData.C2S_Player_SoliderLevelUp(cfgId, speedUp)
    gg.client.gameServer:send("C2S_Player_SoliderLevelUp", {
        cfgId = cfgId,
        speedUp = speedUp
    })
end

-- ""
function BuildData.C2S_Player_SoliderQualityUpgrade(cfgId, speedUp)
    -- gg.client.gameServer:send("C2S_Player_SoliderQualityUpgrade", {
    --     cfgId = cfgId,
    --     speedUp = speedUp
    -- })
end

-- ""
function BuildData.C2S_Player_SoliderForge(cfgId, addRatio)
    -- gg.client.gameServer:send("C2S_Player_SoliderForge", {
    --     cfgId = cfgId,
    --     addRatio = addRatio
    -- })
end

-- ""
function BuildData.C2S_Player_MineLevelUp(cfgId, speedUp)
    gg.client.gameServer:send("C2S_Player_MineLevelUp", {
        cfgId = cfgId,
        speedUp = speedUp
    })
end

-- ""  guideNow""
function BuildData.C2S_Player_SoliderTrain(id, soliderCfgId, soliderCount, guideNow)
    gg.client.gameServer:send("C2S_Player_SoliderTrain", {
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount,
        guideNow = guideNow
    })
end

-- ""
function BuildData.C2S_Player_SpeedUp_SoliderTrain(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_SoliderTrain", {
        id = id
    })
end

-- ""
function BuildData.C2S_Player_OneKeyTrainSoldiers(ids)
    gg.client.gameServer:send("C2S_Player_OneKeyTrainSoldiers", {
        ids = ids
    })
end

-- ""
function BuildData.C2S_Player_OneKeySpeedTrainSoldiers(ids)
    gg.client.gameServer:send("C2S_Player_OneKeySpeedTrainSoldiers", {
        ids = ids
    })
end

-- ""
function BuildData.C2S_Player_OneKeySpeedAndFullTrainSoldiers(ids)
    gg.client.gameServer:send("C2S_Player_OneKeySpeedAndFullTrainSoldiers", {
        ids = ids
    })
end

-- ""
function BuildData.C2S_Player_SoliderReplace(id, soliderCfgId, soliderCount)
    gg.client.gameServer:send("C2S_Player_SoliderReplace", {
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount
    })
end

-- ""
function BuildData.C2S_Player_RemoveMess(id)
    local buildData = BuildData.buildData[id]
    local buildCfg = BuildUtil.getCurBuildCfg(buildData.cfgId, buildData.level, buildData.quality)

    if buildCfg.type == constant.BUILD_CLUTTER then
        local levelCount = 0
        for key, value in pairs(BuildData.buildData) do
            local subBuildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)
            if subBuildCfg.type == constant.BUILD_CLUTTER and value.level == buildData.level then
                levelCount = levelCount + 1
            end
        end
        if levelCount == 1 then
            local baseLevel = gg.buildingManager:getBaseLevel()
            local baseUnlockArea = 0
            for key, value in pairs(cfg.area) do
                if value.baseLevel <= baseLevel and value.id > baseUnlockArea then
                    baseUnlockArea = value.id
                end
            end
            local nextArea = cfg.area[baseUnlockArea + 1]
            if baseUnlockArea < buildData.level + 1 and nextArea then
                gg.uiManager:showTip(string.format("upgrade base to level %s to unlock area %s", nextArea.baseLevel,
                    nextArea.id))
            end
        end
    end

    gg.client.gameServer:send("C2S_Player_RemoveMess", {
        id = id
    })
end

-- ""
function BuildData.C2S_Player_ReapGuideRes(id, resId)
    gg.client.gameServer:send("C2S_Player_ReapGuideRes", {
        id = id,
        resId = resId
    })
end

-- ""
function BuildData.C2S_Player_BuildRepair(id)
    gg.client.gameServer:send("C2S_Player_BuildRepair", {
        id = id
    })
end

-------------------------------------------------------------------------

function BuildData.S2C_Player_BuildData(args)
    local buildData = args.buildData
    BuildData.buildData = {}
    for _, build in ipairs(buildData) do
        BuildData.buildData[build.id] = build
        BuildData.buildData[build.id].pos = Vector3(math.keepDecimal(2, build.pos.x), math.keepDecimal(2, build.pos.y),
            math.keepDecimal(2, build.pos.z))
        build.lessTickEnd = build.lessTick + os.time()
        build.lessTrainTickEnd = build.lessTrainTick + os.time()
        build.repairLessTickEnd = os.time()
        -- build.repairLessTickEnd = build.repairLessTick + os.time()
        BuildData.refreshShipData(build.id, build, false, false)
    end
    gg.event:dispatchEvent("onInitBuildData", build)
end

function BuildData.refreshNFTTowerData(build, isDispatchEvent)
    BuildData.nftBuildData[build.id] = build
    -- build.pos = Vector3(math.keepDecimal(2, build.pos.x), math.keepDecimal(2, build.pos.y),
    -- math.keepDecimal(2, build.pos.z))
    build.lessTickEnd = build.lessTick + os.time()
    build.lessTrainTickEnd = build.lessTrainTick + os.time()
    build.repairLessTickEnd = os.time()
    -- build.repairLessTickEnd = build.repairLessTick + os.time()

    if isDispatchEvent then
        gg.event:dispatchEvent("onNFTTowerChange", build)
    end
end

function BuildData.refreshShipData(id, buildData, isDispatchEvent, isRemove)
    if isRemove then
        BuildData.shipExistSoliderData[id] = nil
    else
        if buildData.cfgId == constant.BUILD_LIBERATORSHIP then
            if (buildData.soliderCfgId and buildData.soliderCfgId > 0) or
                (buildData.trainCfgId and buildData.trainCfgId > 0) then

                BuildData.shipExistSoliderData[buildData.id] = buildData
            else
                BuildData.shipExistSoliderData[id] = nil
            end
        end
    end

    if isDispatchEvent then
        gg.event:dispatchEvent("onShipExistSoldierChange")
    end
end

function BuildData.S2C_Player_BuildQueueData(buildQueueCount)
    BuildData.buildQueueCount = buildQueueCount
end

function BuildData.S2C_Player_BuildAdd(args)
    local build = args.build
    if build.pos.x ~= 0 or build.pos.z ~= 0 then
        gg.buildingManager:buildSuccessful(build)
    end
    BuildData.refreshData(build)
    gg.uiManager:onClosePnlLink("Player_BuildCreate")
end

function BuildData.S2C_Player_BuildMove(ret, build)
    -- ret = 0 "";ret = 1 ""
    if ret == 0 then
        BuildData.refreshData(build)
    end

    gg.uiManager:onClosePnlLink("C2S_Player_BuildMove")
end

function BuildData.S2C_Player_BuildLevelUp(args)
    local build = args.build
    BuildData.refreshData(build)
    gg.uiManager:onClosePnlLink("C2S_Player_BuildLevelUp")
end

function BuildData.S2C_Player_BuildUpdate(args)
    local build = args.build
    if BuildData.buildData[build.id] then
        if BuildData.buildData[build.id].level < build.level then
            -- AudioFmodMgr:PlaySFX(constant.AUDIO_BUILDING_UPGRADE_COMPLETE.event)
            AudioFmodMgr:Play2DOneShot(constant.AUDIO_BUILDING_UPGRADE_COMPLETE.event,
                constant.AUDIO_BUILDING_UPGRADE_COMPLETE.bank)
        end
    end
    BuildData.refreshData(build)
end

function BuildData.S2C_Player_BuildGetRes(args)
    -- gg.buildingManager:buildGetResMsg(args)
end

function BuildData.refreshData(build)
    BuildData.buildData[build.id] = build
    BuildData.buildData[build.id].pos = Vector3(math.keepDecimal(2, build.pos.x), math.keepDecimal(2, build.pos.y),
        math.keepDecimal(2, build.pos.z))

    BuildData.buildData[build.id].lessTickEnd = build.lessTick + os.time()
    BuildData.buildData[build.id].lessTrainTickEnd = build.lessTrainTick + os.time()
    -- BuildData.buildData[build.id].repairLessTickEnd = build.repairLessTick + os.time()
    BuildData.buildData[build.id].repairLessTickEnd = os.time()

    if build.pos.x ~= 0 or build.pos.z ~= 0 then
        gg.event:dispatchEvent("onUpdateBuildData", build)
        BuildData.refreshShipData(build.id, build, true)
    else
        gg.event:dispatchEvent("onSetViewInfo", build.id, build, PnlHeadquarters.SWICH_TOWER)
    end

    if build.cfgId == constant.BUILD_BASE then
        gg.event:dispatchEvent("onBaseChange", build)
    end

    gg.event:dispatchEvent("onRefreshWarShipData", build, build.id, 2)
end

function BuildData.S2C_Player_SoliderLevelData(soliderLevelData)
    BuildData.soliderLevelData = {}
    for _, soldierData in ipairs(soliderLevelData) do
        BuildData.updateSoliderData(soldierData)
    end
    BuildData.refreshSoldierUpgradeStatus()
    gg.event:dispatchEvent("onSoliderChange")
end

function BuildData.S2C_Player_SoliderLevelUpdate(soliderLevel)
    BuildData.updateSoliderData(soliderLevel)
    BuildData.refreshSoldierUpgradeStatus()
    gg.event:dispatchEvent("onSoliderChange")
end

function BuildData.updateSoliderData(data)
    BuildData.soliderLevelData[data.cfgId] = data
    data.lessTickEnd = data.lessTick + os.time()
end

function BuildData.refreshSoldierUpgradeStatus()
    BuildData.isSoldierUpgradeing = false
    BuildData.isSoldierAscending = false
    for key, value in pairs(BuildData.soliderLevelData) do
        if value.lessTick > 0 then
            if value.level == 0 then
                BuildData.isSoldierAscending = true
            else
                BuildData.isSoldierUpgradeing = true
            end
            if BuildData.isSoldierAscending and BuildData.isSoldierUpgradeing then
                return
            end
        end
    end
end

function BuildData.S2C_Player_SoliderForgeLevelUpdate(forgeLevelInfo, result)
    if forgeLevelInfo then
        BuildData.soliderForgeData[forgeLevelInfo.cfgId] = forgeLevelInfo
    end
    gg.event:dispatchEvent("onSoliderForgeChange", result)
end

function BuildData.S2C_Player_SoliderForgeLevelData(forgeLevelInfos)
    BuildData.soliderForgeData = BuildData.soliderForgeData or {}
    for key, value in pairs(forgeLevelInfos) do
        BuildData.soliderForgeData[value.cfgId] = value
    end
    gg.event:dispatchEvent("onSoliderForgeChange")
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

function BuildData.S2C_Player_BuildDel(args)
    local id = args.id
    BuildData.buildData[id] = nil
    gg.event:dispatchEvent("onRemoveBuilding", id)
    BuildData.refreshShipData(id, nil, true, true)
end

function BuildData.S2C_Player_RemoveMess(args)
    -- print("S2C_Player_RemoveMess:", args)
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
