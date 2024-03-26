TaskUtil = TaskUtil or {}

-- ""
function TaskUtil.sortTask(subTaskCfgList)
    table.sort(subTaskCfgList, function (a, b)
        local sortWeightA = TaskUtil.getSortWeight(a)
        local sortWeightB = TaskUtil.getSortWeight(b)

        if sortWeightA ~= sortWeightB then
            return sortWeightA > sortWeightB
        end

        return a.cfgId < b.cfgId
    end)
end

function TaskUtil.getSortWeight(taskCfg)
    if taskCfg.lvRange then
        local baseLevel = gg.buildingManager:getBaseLevel()
        if baseLevel < taskCfg.lvRange[1] or baseLevel > taskCfg.lvRange[2] then
            return 2 * 1000000 + taskCfg.sortWeight
        end
    end

    local completeTasksData = AchievementData.completeTasksMap[taskCfg.cfgId]
    if completeTasksData then
        if completeTasksData.stage == 1 then
            return 4 * 1000000 + taskCfg.sortWeight
        else
            return 1 * 1000000 + taskCfg.sortWeight
        end
    else
        return 3 * 1000000 + taskCfg.sortWeight
    end
end

function TaskUtil.startTaskAnim(itemList, animArgs)
    for key, value in pairs(itemList) do
        if value.taskCfg.cfgId == animArgs.fromId then
            local animObj = value:getRewardAnimObject(animArgs.resCfgId)
            if animObj then
                gg.event:dispatchEvent("onResAnimation", animArgs)
                gg.resEffectManager:fly3dRes2TargetOnPnlPlayerInformation(animObj, animArgs.resCfgId,  animArgs.change, true)
            end
        end
    end
end

function TaskUtil.getShowProgress(targetType, subProgress, targetProgress)
    if constant.SHOW_RES_PROGRESS[targetType] then
        subProgress = Utils.getShowRes(subProgress)
        targetProgress = Utils.getShowRes(targetProgress)
    end

    return subProgress .. "/" .. string.format("<color=#43ABE8>%s</color>", targetProgress)
end

function TaskUtil.parseSubTaskReward(cfgId)
    local subTastCfg = cfg.subTask[cfgId]

    return TaskUtil.parseReawrd(subTastCfg)

    -- local rewardList = {}

    -- for key, value in pairs(subTastCfg.reward) do
    --     table.insert(rewardList, {rewardType = constant.ACTIVITY_REWARD_RES, resId = value[1], count = value[2]})
    -- end

    -- for key, value in pairs(subTastCfg.rewardItem) do
    --     table.insert(rewardList, {rewardType = constant.ACTIVITY_REWARD_ITEM, cfgId = value[1], count = value[2]})
    -- end

    -- return rewardList
end

-- "" reward "" rewardItem ""
function TaskUtil.parseReawrd(config)
    local rewardList = {}

    for key, value in pairs(config.reward) do
        table.insert(rewardList, {rewardType = constant.ACTIVITY_REWARD_RES, resId = value[1], count = value[2]})
    end

    for key, value in pairs(config.rewardItem) do
        table.insert(rewardList, {rewardType = constant.ACTIVITY_REWARD_ITEM, cfgId = value[1], count = value[2]})
    end

    return rewardList
end