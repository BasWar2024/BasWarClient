AchievementData = {}

AchievementData.taskChapterId = 0
AchievementData.chapterState = 0
AchievementData.completeTasksMap = {}
AchievementData.taskTargetsMap = {}
AchievementData.dailyTaskTargetsMap = {}

AchievementData.activation = 0
AchievementData.activationBox = {}
AchievementData.dailyResetTick = 0

function AchievementData.clear()
    AchievementData.taskChapterId = 0
    AchievementData.chapterState = 0
    AchievementData.completeTasksMap = {}
    AchievementData.taskTargetsMap = {}
    AchievementData.dailyTaskTargetsMap = {}
    
    AchievementData.activation = 0
    AchievementData.activationBox = {}
    AchievementData.dailyResetTick = 0
end


-- ""
function AchievementData.C2S_Player_DrawTask(index)
    gg.client.gameServer:send("C2S_Player_DrawTask", {
        index = index
    })
end

-- ""
function AchievementData.C2S_Player_DrawChapterTask()
    gg.client.gameServer:send("C2S_Player_DrawChapterTask", {
        
    })
end

--""
function AchievementData.C2S_Player_DrawTaskActivation(cfgId)
    gg.client.gameServer:send("C2S_Player_DrawTaskActivation", {
        cfgId = cfgId
    })
end

-- "" op_type "" 1"",2"",3""
function AchievementData.S2C_Player_TaskUpdate(args)
    AchievementData.taskChapterId = args.chapterId  -- ""id
    AchievementData.chapterState = args.chapterState    
    AchievementData.activation = args.activation    
    AchievementData.dailyResetTick = args.dailyResetTick
    
    if args.op_type == 1 then
        for key, value in pairs(args.activationBox) do
            table.insert(AchievementData.activationBox, value)
        end

    elseif args.op_type == 2 then
        for key, value in pairs(args.completeTasks) do
            AchievementData.completeTasksMap[value.cfgId] = nil
        end

        for key, value in pairs(args.activationBox) do
            for i = #AchievementData.activationBox, 1, -1 do
                if AchievementData.activationBox[i] == value then
                    table.remove(AchievementData.activationBox, i)
                end
            end
        end

        for key, value in pairs(args.dailyTargets) do
            AchievementData.dailyTaskTargetsMap[value.tarId] = nil
        end
    end

    if args.op_type == 1 or args.op_type == 3 then
        for key, value in pairs(args.completeTasks) do
            AchievementData.completeTasksMap[value.cfgId] = value
        end

        for key, value in pairs(args.taskTargets) do
            AchievementData.taskTargetsMap[value.tarId] = value
        end

        for key, value in pairs(args.dailyTargets) do
            AchievementData.dailyTaskTargetsMap[value.tarId] = value
        end
    end

    gg.event:dispatchEvent("OnTaskChange")
    gg.event:dispatchEvent("onLoadBoxTask")
end

return AchievementData
