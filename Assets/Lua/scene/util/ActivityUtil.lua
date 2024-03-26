ActivityUtil = ActivityUtil or {}

function ActivityUtil.getActivityRewardMap()
    if not ActivityUtil.ActivityRewardMap then
        ActivityUtil.ActivityRewardMap = {}
        for k, v in ipairs(cfg.activitiesReward) do
            ActivityUtil.ActivityRewardMap[v.cfgId] = ActivityUtil.ActivityRewardMap[v.cfgId] or {}
            table.insert(ActivityUtil.ActivityRewardMap[v.cfgId], v)
        end
    end

    return ActivityUtil.ActivityRewardMap
end

-- activities""
function ActivityUtil.checkActivityOpen(cfgId)
    local activityCfg = cfg.activities[cfgId]

    if not activityCfg then
        return false
    end

    local starTime = gg.time.strTime2utcTime2(activityCfg.startTime)
    local endTime = gg.time.strTime2utcTime2(activityCfg.endTime)
    local serverTime = Utils.getServerSec()

    return serverTime >= starTime and serverTime <= endTime
end

-- giftActivities""
function ActivityUtil.checkGiftActivitiesOpen(cfgId)

    
    if cfgId == constant.CUMULATIVE_FUNDS then                      -- ""
        -- if true then
        --     return false
        -- end

        if IsAuditVersion() then
            return false
        end

        if not ActivityData.CumulativeFundsData or not next(ActivityData.CumulativeFundsData) then
            return false
        end

        for key, value in pairs(cfg.cumulativeFunds) do
            local data = nil
            for _, cumulativeFundsData in pairs(ActivityData.CumulativeFundsData.info) do
                if value.cfgId == cumulativeFundsData.cfgId then
                    data = cumulativeFundsData
                    if cumulativeFundsData.status == 0 then
                        return true
                    end
                end
            end

            if not data then
                return true
            end
        end
        return false
    elseif cfgId == constant.FIRST_CHARGE then                             --6""
        if not ActivityData.RechargeData then
            return false
        end

        return ActivityData.RechargeData.firstRec == 0

    elseif cfgId == constant.RECHARGE then                                --66""
        if not ActivityData.RechargeData then
            return false
        end
        return ActivityData.RechargeData.rechargeStat == 0

    elseif cfgId == constant.DAILY_CHECK then                              --""

        return true
    elseif cfgId == constant.DAILY_GIFT then                               -- ""
        if ActivityData.dailyGift and #ActivityData.dailyGift > 0 then
            return true
        else
            return false
        end

    elseif cfgId == constant.LIMIT_TIME_SHOP then                          -- ""
        if IsIOSAuditVersion() then
            return false
        end

        return ActivityData.ShoppingMallData and ActivityData.ShoppingMallData.overTimes > Utils.getServerSec()

    elseif cfgId == constant.NEW_PLAYER_LOGIN then                         -- ""
        if IsAuditVersion() then
            return false
        end

        if not ActivityData.loginActivityInfo or not next(ActivityData.loginActivityInfo) then
            return false
        end
        return ActivityData.loginActivityInfo.endTime > Utils.getServerSec()
    end

    return false
end

-- giftReward""reward
function ActivityUtil.getRewardList(reward)
    local rewardLis = {}

    if reward.herosReward and #reward.herosReward > 0 then
        for key, value in pairs(reward.herosReward) do
            table.insert(rewardLis, {
                rewardType = constant.ACTIVITY_REWARD_HERO,
                cfgId = value[1],
                quality = value[2],
                level = value[3]
            })
        end
    end

    if reward.resReward and #reward.resReward > 0 then
        for key, value in pairs(reward.resReward) do
            table.insert(rewardLis, {
                rewardType = constant.ACTIVITY_REWARD_RES,
                resId = value[1],
                count = value[2]
            })
        end
    end

    if reward.itemReward and #reward.itemReward > 0 then
        for key, value in pairs(reward.itemReward) do
            table.insert(rewardLis, {
                rewardType = constant.ACTIVITY_REWARD_ITEM,
                cfgId = value[1],
                count = value[2]
            })
        end
    end

    return rewardLis
end

-- activitiesReward""reward
function ActivityUtil.getActivitiesRewardList(reward)
    local rewardList1 = {}
    local rewardList2 = {}

    if not reward then
        return rewardList1, rewardList2
    end

    if reward.resReward and next(reward.resReward) then
        for key, value in pairs(reward.resReward) do
            table.insert(rewardList1, {
                rewardType = constant.ACTIVITY_REWARD_RES,
                resId = value[1],
                count = value[2]
            })
        end
    end

    if reward.itemReward and next(reward.itemReward) then
        for key, value in pairs(reward.itemReward) do
            table.insert(rewardList1, {
                rewardType = constant.ACTIVITY_REWARD_ITEM,
                cfgId = value[1],
                count = value[2]
            })
        end
    end

    if reward.resReward2 and next(reward.resReward2) then
        for key, value in pairs(reward.resReward2) do
            table.insert(rewardList2, {
                rewardType = constant.ACTIVITY_REWARD_RES,
                resId = value[1],
                count = value[2]
            })
        end
    end

    if reward.itemReward2 and next(reward.itemReward2) then
        for key, value in pairs(reward.itemReward2) do
            table.insert(rewardList2, {
                rewardType = constant.ACTIVITY_REWARD_ITEM,
                cfgId = value[1],
                count = value[2]
            })
        end
    end

    return rewardList1, rewardList2
end
