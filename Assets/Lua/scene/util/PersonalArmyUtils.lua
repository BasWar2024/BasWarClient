PersonalArmyUtils = PersonalArmyUtils or {}

function PersonalArmyUtils.getSoldierMaxSpace(heroId)
    local baseCfg = BuildUtil.getCurBuildCfg(constant.BUILD_BASE, gg.buildingManager:getBaseLevel(), 0)
    local maxSpace = baseCfg.buildSoldierSpace
    if heroId and heroId > 0 then
        local heroData = HeroData.heroDataMap[heroId]
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        maxSpace = maxSpace + heroCfg.heroSoldierSpace
    end
    return maxSpace
end

function PersonalArmyUtils.getArmySoldierInfo(army, soldierMode)
    local soldierSpace = 0
    local soldierMaxSpace = 0
    soldierMode = soldierMode or PnlPersonalQuickSelectArmy.MODE_PERSONAL
    -- local heroData = nil

    for key, value in pairs(army.teams) do
        if value.soliderCfgId and value.soliderCfgId > 0 then
            local soldierLevelData = BuildData.soliderLevelData[value.soliderCfgId]
            local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.soliderCfgId][soldierLevelData.level]

            local useSpace = soldierCfg.trainSpace * value.soliderCount

            if soldierMode == PnlPersonalQuickSelectArmy.MODE_PERSONAL then
                soldierSpace = soldierSpace + useSpace

            elseif soldierMode == PnlPersonalQuickSelectArmy.MODE_UNION then

                local defaultSoldierCfgId = cfg.global.GuildBaseSolider.intValue
                local unionSoldierCfgId = defaultSoldierCfgId

                if cfg.soliderComparison[value.soliderCfgId] then
                    unionSoldierCfgId = cfg.soliderComparison[value.soliderCfgId].guildcfgId
                end

                local unionSoldierMap = UnionData.unionData.soliders or {}
                local unionSoliderData = unionSoldierMap[unionSoldierCfgId] or unionSoldierMap[defaultSoldierCfgId]

                if unionSoliderData then
                    local unionSoliderCfg = SoliderUtil.getSoliderCfgMap()[unionSoldierCfgId][unionSoliderData.level]
                    local unionSoldierCount = math.floor(useSpace / unionSoliderCfg.trainSpace)
                    soldierSpace = soldierSpace + unionSoldierCount * unionSoliderCfg.trainSpace
                end
            end
        end

        soldierMaxSpace = soldierMaxSpace + PersonalArmyUtils.getSoldierMaxSpace(value.heroId)
        -- if value.heroId > 0 and not heroData then
        --     heroData = HeroData.heroDataMap[value.heroId]
        -- end
    end

    return soldierSpace, soldierMaxSpace --, heroData
end

function PersonalArmyUtils.personalArmy2BattleArmy(armyId)
    local personArmy = nil
    for key, value in pairs(PlayerData.armyData) do
        if value.armyId == armyId then
            personArmy = value
        end
    end

    if not personArmy then
        return
    end
    local battleArmy = {warShipId = 0, teams = {}}

    for key, value in ipairs(personArmy.teams) do
        local team = {
            heroId = value.heroId,
            soliderCfgId = value.soliderCfgId,
            soliderCount = value.soliderCount,
            buildId = armyId,
        }
        table.insert(battleArmy.teams, team)
    end

    return battleArmy
end

-- message ArmyTeamType {
--     int64 heroId = 1;                 //""id
--     int32 soliderCfgId = 2;            //""cfgId
--     int32 soliderCount = 3;           //""
-- }

-- message BattleTeamType {
--     int64 heroId = 1;                 //""id
--     int32 soliderCfgId = 2;           //""cfgId
--     int32 soliderCount = 3;           //""
--     int64 buildId = 4;                //""id
-- }