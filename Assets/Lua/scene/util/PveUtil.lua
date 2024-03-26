PveUtil = PveUtil or {}

function PveUtil.getStarReward(cfgId, star1, star2, star3)
    local pveCfg = cfg.pve[cfgId]

    local rewardMap = {}

    if star1 then
        PveUtil.addStarReward(pveCfg.firstStarReward, rewardMap)
    end

    if star2 then
        PveUtil.addStarReward(pveCfg.secondStarReward, rewardMap)
    end

    if star3 then
        PveUtil.addStarReward(pveCfg.thirdStarReward, rewardMap)
    end

    local rewardList = {}

    for key, value in pairs(rewardMap) do
        if value[2] > 0 then
            table.insert(rewardList, value)
        end
    end

    return rewardList
end

function PveUtil.addStarReward(addRewardList, targetMap)
    for key, value in pairs(addRewardList) do
        targetMap[value[1]] = targetMap[value[1]] or {[1] = value[1], [2] = 0}
        targetMap[value[1]][2] = targetMap[value[1]][2] + value[2]
    end
end

function PveUtil.getCount()
    if PveUtil.pveCount then
        return PveUtil.pveCount
    end

    PveUtil.pveCount = 0
    for key, value in pairs(cfg.pve) do
        PveUtil.pveCount = PveUtil.pveCount + 1
    end

    return PveUtil.pveCount
end


function PveUtil.checkIsCanFetchDaily()
    local existReward = false

    local rewardMap = {}
    for key, value in pairs(BattleData.pvePassMap) do
        if not BattleData.pveDailyRewardMap[value.cfgId] then
            PveUtil.addStarReward(PveUtil.getStarReward(value.cfgId, value.star >= 1, value.star >= 2, value.star >= 3), rewardMap)
        end
    end
    for _, value in pairs(rewardMap) do
        if value[2] > 0 then
            existReward = true
            break
        end
    end
    if not existReward then
        return false
    end

    for key, value in pairs(BattleData.pvePassMap) do
        if not BattleData.pveDailyRewardMap[value.cfgId] then
            return true
        end
    end
    return false, rewardMap
end