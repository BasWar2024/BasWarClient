UnionUtil = UnionUtil or {}

-- function UnionUtil.getStarMapCfgMap()
--     if not UnionUtil.starmapCfg then
--         UnionUtil.starmapCfg = {}
--         for key, value in pairs(cfg.starmap) do
--             UnionUtil.starmapCfg[value.cfgId] = value
--         end
--     end
--     return UnionUtil.starmapCfg
-- end

-- army

function UnionUtil.checkIsCanEditArmy()
    if UnionData.editArmyInfo and UnionData.editArmyInfo.editArmyTickEnd > os.time()
        and UnionData.editArmyInfo.editArmyPid ~= PlayerData.myInfo.pid then
            gg.uiManager:showTip(string.format("%s is editing", UnionData.editArmyInfo.editArmyPid))
        return false
    end
    return true
end

function UnionUtil.startEdit(data, armyType)
    if armyType == constant.UNION_TYPE_ARMY_UNION then
        if UnionUtil.checkIsCanEditArmy() then
            if not data and #UnionData.unionArmyList >= cfg.global.UnionArmyTeamsLimit.intValue then
                gg.uiManager:showTip("max team")
                return
            end
            gg.uiManager:openWindow("PnlUnionArmyEdit", {data = data, type = armyType})
        end
    else
        gg.uiManager:openWindow("PnlUnionArmyEdit", {data = data, type = armyType})
    end
end

function UnionUtil.openEditArmyView(planetId, showType)
    gg.uiManager:openWindow("PnlUnionArmyNew", {planetId = planetId})

    -- showType = showType or constant.UNION_TYPE_ARMY_UNION
    -- if showType == constant.UNION_TYPE_ARMY_UNION then
    --     if UnionData.unionData then
    --         if UnionUtil.checkIsCanEditArmy() then
    --             gg.uiManager:openWindow("PnlUnionArmy", {planetId = planetId, type = showType})
    --         end
    --     else
    --         gg.uiManager:showTip("join or create a union first")
    --     end
    -- else
    --     gg.uiManager:openWindow("PnlUnionArmy", {planetId = planetId, type = showType})
    -- end
end

function UnionUtil.getUnionSoldierLessCount(cfgId, editingData)
    editingData = editingData or {}

    local unionSoldierData = UnionData.unionData.soliders[cfgId]
    local count = unionSoldierData.count

    for _, value in pairs(UnionData.unionArmyList) do
        if value.id ~= editingData.id and value.battleArmy and value.battleArmy.teams then
            for _, team in pairs(value.battleArmy.teams) do
                if team.soliderCfgId == cfgId then
                    -- local soldierCfg = SoliderUtil.getSoliderCfgMap()[cfgId][1]
                    count = count - team.soliderCount -- (team.soliderCount * soldierCfg.trainSpace)
                end
            end
        end
    end

    if editingData.battleArmy and editingData.battleArmy.teams then
        for _, team in pairs(editingData.battleArmy.teams) do
            if team.soliderCfgId == cfgId then
                count = count - team.soliderCount -- (team.soliderCount * soldierCfg.trainSpace)
            end
        end
    end

    return count
end

function UnionUtil.getSelfSoldierLessCount(soldier, editingData)
    editingData = editingData or {}

    -- local unionSoldierData = UnionData.unionData.soliders[cfgId]
    local count = soldier.build.soliderCount
    local isCanUsed = true

    for _, value in pairs(UnionData.unionArmyList) do
        if value.id ~= editingData.id and value.battleArmy and value.battleArmy.teams then
            for _, team in pairs(value.battleArmy.teams) do
                if team.solider and team.solider.build.id == soldier.build.id then
                    count = count - team.soliderCount
                    isCanUsed = false
                end
            end
        end
    end

    if editingData.battleArmy and editingData.battleArmy.teams then
        for _, team in pairs(editingData.battleArmy.teams) do
            if team.solider and team.solider.build.id == soldier.build.id then
                count = count - team.soliderCount
                isCanUsed = false
            end
        end
    end

    return count, isCanUsed
end

--""UnionData.unionArmyList "" C2S_Player_StartBattle "" armys
function UnionUtil.getUnionBattleArmys()
    local armys = {}

    for key, value in pairs(UnionData.unionArmyList) do
        local battleArmy = {}
        battleArmy.warShipId = value.battleArmy.warShipId
        battleArmy.teams = {}
        for _, team in pairs(value.battleArmy.teams) do
            if team.heroId and team.heroId > 0 or team.soliderCfgId and team.soliderCfgId > 0 then

                local data = {heroId = team.heroId, soliderCfgId = team.soliderCfgId, soliderCount = team.soliderCount}
                if team.soliderCfgId and team.soliderCfgId > 0 and team.solider.build then
                    data.buildId = team.solider.build.id
                end

                table.insert(battleArmy.teams, data)
            end
        end

        if #battleArmy.teams > 0 then
            table.insert(armys, battleArmy)
        end
    end

    return armys
end

function UnionUtil.getUnionArmySoldierSpace(heroId, armyType)
    local space = cfg.global.unionBattleBaseSpace.intValue

    if armyType == constant.UNION_TYPE_ARMY_UNION then
        if heroId then
            local heroData = UnionData.unionData.items[heroId]
            if heroData then
                local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
                space = space + heroCfg.unionSoldierSpace
            end
        end
    elseif armyType == constant.UNION_TYPE_ARMY_SELF then
        if heroId then
            local heroData = HeroData.heroDataMap[heroId]
            if heroData then
                local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
                space = space + heroCfg.unionSoldierSpace
            end
        end
    end

    return math.min(space, cfg.global.unionBattleMaxSpace.intValue)
end

function UnionUtil.checkHeroUsed(heroId, editingData)
    editingData = editingData or {}

    for _, value in pairs(UnionData.unionArmyList) do
        if value.id ~= editingData.id and value.battleArmy and value.battleArmy.teams then
            for _, team in pairs(value.battleArmy.teams) do
                if team.heroId == heroId then
                    return true
                end
            end
        end
    end

    if editingData.battleArmy and editingData.battleArmy.teams then
        for _, team in pairs(editingData.battleArmy.teams) do
            if team.heroId == heroId then
                return true
            end
        end
    end

    return false
end

function UnionUtil.checkWarshipUsed(id, editingData)
    editingData = editingData or {}

    for _, value in pairs(UnionData.unionArmyList) do
        if value.id ~= editingData.id and value.battleArmy and value.battleArmy.warShipId == id then
            return true
        end
    end

    if editingData.battleArmy and editingData.battleArmy.warShipId == id then
        return true
    end

    return false
end

function UnionUtil.getMatchCfg(season)
    local seasonCfg
    local weedCfg

    for key, value in pairs(cfg.match) do

        if value.season == season then
            if value.matchType == 3 then

                seasonCfg = value
            elseif value.matchType == 1 then
                local starTime = gg.time.strTime2utcTime2(value.startTime)
                local endTime = gg.time.strTime2utcTime2(value.endTime)
                local serverSec = Utils.getServerSec()

                if serverSec >= starTime and serverSec <= endTime then
                    weedCfg = value
                end
            end
        end
    end

    return seasonCfg, weedCfg
end

function UnionUtil.getUnionBattleOperate(signPosId)
    local operates = {}

    for k, v in pairs(BattleData.UnionBattleOperOrders) do
        operates[k] = {}
        operates[k].GameFrame = k
        operates[k].Order = v
        local pos = UnionUtil.getUnionBattleLandPos(signPosId, k)
        operates[k].X = pos.x
        operates[k].Y = 0
        operates[k].Z = pos.z
    end

    return operates
end

function UnionUtil.getUnionBattleLandPos(signPosId, i)
    local pos = {}

    if signPosId == 1 then
        pos.x = BattleData.BATTLE_MAX_POS
        pos.z = BattleData.UnionBattleLandCoord[i]
    elseif signPosId == 2 then
        pos.x = BattleData.UnionBattleLandCoord[i]
        pos.z = BattleData.BATTLE_MIN_POS
    elseif signPosId == 3 then
        pos.x = BattleData.BATTLE_MIN_POS
        pos.z = BattleData.UnionBattleLandCoord[i]
    else 
        pos.x = BattleData.UnionBattleLandCoord[i]
        pos.z = BattleData.BATTLE_MAX_POS
    end

    return pos
end

-- quick army

function UnionUtil.quickGetSelfOneArmy()
    local unionArmy = {id = UnionData.getUnionArmyTeamId(), warship = nil,  battleArmy = {warShipId = nil, teams = {}}}

    local warship
    for key, value in pairs(WarShipData.warShipData) do
        if not UnionUtil.checkWarshipUsed(value.id, unionArmy) then
            if not warship then
                warship = value
            elseif warship.level < value.level then
                warship = value
            end
        end
    end

    if warship then
        unionArmy.warship = warship
        unionArmy.battleArmy.warShipId = warship.id
    end

    -- hero
    local heroList = {}
    for key, value in pairs(HeroData.heroDataMap) do
        if not UnionUtil.checkHeroUsed(value.id, unionArmy) then
            table.insert(heroList, value)
        end
    end

    table.sort(heroList, function (a, b)
        return a.level > b.level
    end)

    for index, hero in ipairs(heroList) do
        if index > 5 then
            break
        end
        unionArmy.battleArmy.teams[index] = unionArmy.battleArmy.teams[index] or {}
        local team = unionArmy.battleArmy.teams[index]
        team.heroId = hero.id
        team.hero = hero
    end

    -- soldier
    local soldierList = {}
    for key, value in pairs(BuildData.shipExistSoliderData) do
        local soldierData = BuildData.soliderLevelData[value.soliderCfgId]

        if soldierData then
            local soldier = {
                level = soldierData.level,
                cfgId = value.soliderCfgId,
                build = value,
            }
            table.insert(soldierList, soldier)
        end
    end

    table.sort(soldierList, function (a, b)
        return a.level > b.level
    end)

    for index, value in ipairs(soldierList) do
        if index > 5 then
            break
        end
        unionArmy.battleArmy.teams[index] = unionArmy.battleArmy.teams[index] or {}
        local team = unionArmy.battleArmy.teams[index]

        local count, isCanUsed = UnionUtil.getSelfSoldierLessCount(value, unionArmy)
        if count > 0 and isCanUsed then
            local space = UnionUtil.getUnionArmySoldierSpace(team.heroId, constant.UNION_TYPE_ARMY_SELF)
            team.soliderCfgId = value.cfgId
            team.soliderCount = math.min(space, count)
            team.solider = value
        end
    end

    return unionArmy
end

--

function UnionUtil.unionAtk(curPlanetCfgId)
    local selfUnionJod = {}
    for k, v in pairs(cfg["daoPosition"]) do
        if v.accessLevel == UnionData.myUnionJod then
             selfUnionJod = v
            break
        end
    end

    if  selfUnionJod.isAttack ~= 1 then
        gg.uiManager:showTip("No authority for this action")
        return
    end

    -- self:onHideBoxInfomation()

    -- if gg.galaxyManager.galaxyMap:getAround(curPlanetCfgId) then
        -- local starCfg = gg.galaxyManager:getGalaxyCfg(curPlanetCfgId)

        local gridCount = GalaxyData.StarmapGridCountData.uGridCount or 0
        local gridCountMax = GalaxyData.StarmapGridCountData.uGridMax or 1
        if gridCount >= gridCountMax then
            local args = {
                txtTitel = "Alert",
                txtTips = Utils.getText("league_DaoPoltMaxTips"),
                txtYes = Utils.getText("universal_DetermineButton"),
                callbackYes = function()
                    UnionUtil.openEditArmyView(curPlanetCfgId, constant.UNION_TYPE_ARMY_UNION)
                end,
                txtNo = Utils.getText("universal_Ask_BackButton"),
                bigSize = true
            }
            gg.uiManager:openWindow("PnlAlertNew", args)
            return
        else
            UnionUtil.openEditArmyView(curPlanetCfgId, constant.UNION_TYPE_ARMY_UNION)
        end
    -- else
    --     gg.uiManager:showTip(Utils.getText("league_CannotAttack"))
    -- end
end
