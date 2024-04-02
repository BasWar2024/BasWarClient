RedPointTask = class("RedPointTask", ggclass.RedPointBase)

function RedPointTask:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointTask:onCheck()
    return false
end

------------------------------------------------

RedPointChapterTask = class("RedPointChapterTask", ggclass.RedPointBase)

function RedPointChapterTask:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointTask}, {"OnTaskChange"})
end

function RedPointChapterTask:onCheck()
    local ChapterCfg = cfg.chapterTask[AchievementData.taskChapterId]

    if AchievementData.chapterState == 1 then
        return false
    end

    if not ChapterCfg then
        return false
    end

    local mainTaskFinishCount = 0
    local mainTaskTotelCount = 0

    for index, value in ipairs(ChapterCfg.mainTaskList) do
        local task = cfg.subTask[value]

        if task.available == 1 then
            mainTaskTotelCount = mainTaskTotelCount + 1
            local taskData = AchievementData.completeTasksMap[task.cfgId]
            if taskData then
                if taskData.stage == 1 then
                    return true
                elseif taskData.stage == 2 then
                    mainTaskFinishCount = mainTaskFinishCount + 1
                end
            end
        end
    end

    if mainTaskFinishCount >= mainTaskTotelCount then
        return true
    end

    return false
end

------------------------------------------------
RedPointBranchTask = class("RedPointBranchTask", ggclass.RedPointBase)

function RedPointBranchTask:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointTask}, {"OnTaskChange"})
end

function RedPointBranchTask:onCheck()
    if AchievementData.taskChapterId > 0 then
        for i = 1, AchievementData.taskChapterId, 1 do
            if self:checkSubChapterBranch(i) then
                return true
            end
        end
    end

    return false
end

function RedPointBranchTask:checkSubChapterBranch(id)
    if not id then
        return false
    end
    local chapterCfg = cfg.chapterTask[id]

    if not chapterCfg then
        return false
    end

    for index, taskId in ipairs(chapterCfg.branchTaskList) do
        local task = cfg.subTask[taskId]
        if task.available == 1 then
            local taskData = AchievementData.completeTasksMap[task.cfgId]
            if taskData and taskData.stage == 1 then
                return true
            end
        end
    end

    return false
end
------------------------------------------------

RedPointDailyTask = class("RedPointDailyTask", ggclass.RedPointBase)

function RedPointDailyTask:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointTask}, {"OnTaskChange"})
end

function RedPointDailyTask:onCheck()
    for key, value in pairs(cfg.subTask) do
        if value.type == 3 and value.available == 1 then
            local taskData = AchievementData.completeTasksMap[value.cfgId]
            if taskData and taskData.stage == 1 then
                return true
            end
        end
    end

    for key, value in pairs(cfg.taskActivation) do
        if AchievementData.activation >= value.activation then
            local isFetch = false
            for _, id in pairs(AchievementData.activationBox) do
                if id == value.id then
                    isFetch = true
                    break
                end
            end

            if not isFetch then
                return true
            end
        end
    end
    return false
end
