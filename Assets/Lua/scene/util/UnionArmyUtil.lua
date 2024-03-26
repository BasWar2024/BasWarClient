UnionArmyUtil = UnionArmyUtil or {}

function UnionArmyUtil.checkHeroUsed(heroId)
    for index, army in pairs(UnionData.unionArmyList) do
        for _, team in pairs(army.battleArmy.teams) do
            if team.heroId == heroId then
                return true, index, army
            end
        end
    end
end

function UnionArmyUtil.getCanSetSoldierCount(cfgId, settingTeam)
    local soldierCfg = SoliderUtil.getSoliderCfgMap()[cfgId][1]
    local armySpace = UnionData.armyData.guildReserveCount

    armySpace = armySpace - UnionArmyUtil.getSpaceUsed()
    if settingTeam then
        local settingSoldierCfgId = settingTeam.soliderCfgId
        if settingSoldierCfgId and settingSoldierCfgId > 0 then
            local settingCfg = SoliderUtil.getSoliderCfgMap()[settingSoldierCfgId][1]
            armySpace = armySpace + settingCfg.trainSpace * settingTeam.soliderCount
        end
    end

    local unionLevelCfg = cfg.daoLevel[UnionData.unionData.unionLevel] or cfg.daoLevel[1]
    local space = math.min(unionLevelCfg.daoSoliderSpace, armySpace)
    local count = math.floor(space / soldierCfg.trainSpace)
    return count, unionLevelCfg.daoSoliderSpace > armySpace
end

function UnionArmyUtil.getSpaceUsed()
    local space = 0
    for index, army in pairs(UnionData.unionArmyList) do
        for _, team in pairs(army.battleArmy.teams) do

            local soldierCfgId = team.soliderCfgId
            if soldierCfgId and soldierCfgId > 0 then
                local teamSoldierCfg = SoliderUtil.getSoliderCfgMap()[soldierCfgId][1]
                space = space + teamSoldierCfg.trainSpace * team.soliderCount
            end
        end
    end
    return space
end

--""UnionData.unionArmyList "" C2S_Player_StartBattle "" armys
function UnionArmyUtil.getUnionBattleArmys()
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

--""UnionData.unionArmyList "" C2S_Player_StartBattle "" armys
function UnionArmyUtil.autoSetArmy(armyCount, callBack, isAlert)
    local heroList = {}
    if UnionData.unionData.items then
        for key, value in pairs(UnionData.unionData.items) do
            if value.itemType == constant.ITEM_ITEMTYPE_HERO and UnionArmyUtil.checkHero(value) then
                local heroCfg = HeroUtil.getHeroCfg(value.cfgId, value.level, value.quality)
                local sortWeight = heroCfg.atk / heroCfg.atkSpeed * heroCfg.maxHp

                table.insert(heroList, {data = value, cfg = heroCfg, sortWeight = sortWeight})
            end
        end
    end

    table.sort(heroList, function (a, b)
        return a.sortWeight > b.sortWeight
    end)

    local soldierMap = {}
    local maxLevel = 0

    for key, value in pairs(UnionData.unionData.soliders) do
        if value.level > 0 and Utils.checkUnionsloiderDefenseWhiteList(1, value.cfgId) and value.level >= maxLevel then
            maxLevel = value.level
            soldierMap[value.level] = soldierMap[value.level] or {}
            local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][value.level]
            table.insert(soldierMap[value.level], {data = value, cfg = soldierCfg})
        end
    end

    local soldierList = soldierMap[maxLevel]

    local maxArmyCountBaseHero = math.ceil(#heroList / 5)

    local armySpace = UnionData.armyData.guildReserveCount
    local unionLevelCfg = cfg.daoLevel[UnionData.unionData.unionLevel] or cfg.daoLevel[1]
    local teamNeedSpace = unionLevelCfg.daoSoliderSpace
    local maxTeam = math.ceil(armySpace / teamNeedSpace)
    local maxArmyCountBaseSoldier = math.max(math.ceil(maxTeam / 5), 1)

    local maxArmyCount = math.min(maxArmyCountBaseHero, maxArmyCountBaseSoldier)
    maxArmyCount = math.min(maxArmyCount, armyCount)

    local args = {}
    args.callbackYes = function ()
        local armyList = {}
        for i = 1, maxArmyCount, 1 do
            local army = UnionData.getEmpArmy()
            
            for j = 1, 5, 1 do
                local team = army.battleArmy.teams[j]
                local heroInfo = table.remove(heroList, 1)
    
                if heroInfo then
                    team.heroId = heroInfo.data.id
                    team.hero = heroInfo.data

                    if soldierList and next(soldierList) then
                        local soldierInfo = soldierList[1]
                        for key, value in pairs(soldierList) do
                            if value.cfg.race == heroInfo.cfg.race then
                                soldierInfo = value
                            end
                        end
                        team.soliderCfgId = soldierInfo.cfg.cfgId
        
                        local space = math.min(armySpace, teamNeedSpace)
                        team.soliderCount = math.floor(space / soldierInfo.cfg.trainSpace)
                        team.solider = soldierInfo.data
                        armySpace = armySpace - team.soliderCount * soldierInfo.cfg.trainSpace
                    else
                        team.soliderCfgId = 0
                        team.soliderCount = 0
                        team.solider = 0
                    end
                end
            end
    
            table.insert(armyList, army)
        end

        callBack(armyList)
    end

    if isAlert and (maxArmyCountBaseSoldier < armyCount or maxArmyCountBaseHero < armyCount) then
        if maxArmyCountBaseSoldier < armyCount then
            args.txt = "not enought soldier, are you sure want to continue?"

        elseif maxArmyCountBaseHero < armyCount then
            args.txt = "not enought hero, are you sure want to continue?"
        end

        gg.uiManager:openWindow("PnlAlert", args)
    else
        args.callbackYes()
    end
    -- return armyList, maxArmyCountBaseHero, maxArmyCountBaseSoldier
end

function UnionArmyUtil.checkHero(hero)
    local endTime = hero.battleCd or 0
    --gg.printData(hero, "yyyyyyyyyyyyyyyyyyyyyy")
    --print(endTime, Utils.getServerSec(), endTime <= Utils.getServerSec())
    return endTime <= Utils.getServerSec()
end
