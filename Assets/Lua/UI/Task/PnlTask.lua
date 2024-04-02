

PnlTask = class("PnlTask", ggclass.UIBase)

function PnlTask:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"OnTaskChange", "onPlayTaskResAnimation", "onPlayDailyActivationAnimation", "onFingerUp"}
end

function PnlTask:onAwake()
    self.view = ggclass.PnlTaskView.new(self.pnlTransform)

    self.viewOptionBtnBox = ViewOptionBtnBox.new(self.view.fullViewOptionBtnBox)

    --CHAPTER
    self.mainTaskItemList = {}
    self.mainTaskScrollView = UIScrollView.new(self.view.mainTaskScrollView, "TaskItem", self.mainTaskItemList)
    self.mainTaskScrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
--branch
    self.branchTaskItemList = {}
    self.branchTaskScrollView = UILoopScrollView.new(self.view.branchTaskScrollView, self.branchTaskItemList)
    self.branchTaskScrollView:setRenderHandler(gg.bind(self.onRenderBranchItem, self))
-- daily

    self.dailyTaskItemList = {}
    self.dailyTaskScrollView = UIScrollView.new(self.view.dailyTaskScrollView, "DailyTaskItem", self.dailyTaskItemList)
    self.dailyTaskScrollView:setRenderHandler(gg.bind(self.onRenderDailyTask, self))

    self.taskActivationRewardItemList = {}
    self.activityRewardScrollView = UIScrollView.new(self.view.activityRewardScrollView, "DailyActivityRewardItem", self.taskActivationRewardItemList)
    self.activityRewardScrollView:setRenderHandler(gg.bind(self.onRenderActivationReward, self))

--
    self.type2Message = {
        [PnlTask.SHOWING_TYPE_CHAPTER] = {
            layout = self.view.layoutCharatcer,
            func = gg.bind(self.refreshChapter, self),

        },
        [PnlTask.SHOWING_TYPE_TASK] = {
            layout = self.view.layoutBranch,
            func = gg.bind(self.refreshBranch, self),
            icon = "TaskIcon_Atlas[mission_icon_A]",
            iconSelect = "TaskIcon_Atlas[mission_icon_B]",
        },
        [PnlTask.SHOWING_TYPE_DAILY_TASK] = {
            layout = self.view.layoutDailyTask,
            func = gg.bind(self.refreshDaily, self),
            icon = "TaskIcon_Atlas[task_icon_A]",
            iconSelect = "TaskIcon_Atlas[task_icon_B]",
        },
    }

    self.taskActivationInfoBox = TaskActivationInfoBox.new(self.view.taskActivationInfoBox)
end

PnlTask.SHOWING_TYPE_CHAPTER = 1
PnlTask.SHOWING_TYPE_TASK = 2
PnlTask.SHOWING_TYPE_DAILY_TASK = 3

function PnlTask:onShow()
    self:bindEvent()
    self:refreshData()

    self.viewOptionBtnBox:setBtnDataList(
        {
            {
                nemeKey = "task_MainBtn", 
                callback = gg.bind(self.refresh, self, PnlTask.SHOWING_TYPE_CHAPTER), 
                redPointName = RedPointChapterTask.__name,
                -- icon = "TaskIcon_Atlas[mission_icon_A]",
                -- iconSelect = "TaskIcon_Atlas[mission_icon_B]",
            },
            {
                nemeKey = "task_ExtraBtn", 
                callback = gg.bind(self.refresh, self, PnlTask.SHOWING_TYPE_TASK), 
                redPointName = RedPointBranchTask.__name,
                -- icon = "TaskIcon_Atlas[mission_icon_A]",
                -- iconSelect = "TaskIcon_Atlas[mission_icon_B]",
            },
            {
                nemeKey = "task_Daily_DailyBtn", 
                callback = gg.bind(self.refresh, self, PnlTask.SHOWING_TYPE_DAILY_TASK), 
                redPointName = RedPointDailyTask.__name,
                -- icon = "TaskIcon_Atlas[task_icon_A]",
                -- iconSelect = "TaskIcon_Atlas[task_icon_B]",
            },
         }, 1)
         self.viewOptionBtnBox:open()
end
function PnlTask:onFingerUp()
    self:showActivationInfo(false)
end

function PnlTask:showActivationInfo(isShow, dailyActivityRewardItem)
    self.view.taskActivationInfoBox:SetActiveEx(isShow)

    if isShow then
        -- local pos = dailyActivityRewardItem.transform.position
        -- pos.y = pos.y - 60
        local localPos = self.taskActivationInfoBox.transform.parent:InverseTransformPoint(dailyActivityRewardItem.transform.position)
        localPos.y = localPos.y - 100
        self.taskActivationInfoBox:setData(dailyActivityRewardItem.activationCfg, localPos)
    end
end

function PnlTask:onHide()
    self:releaseEvent()
    self.viewOptionBtnBox:close()
    gg.timer:stopTimer(self.taskResetTimer)
end

function PnlTask:refresh(showType)
    self.showingType = showType

    for key, value in pairs(self.type2Message) do
        if key == showType then
            value.layout:SetActiveEx(true)
            value.func()
        else
            value.layout:SetActiveEx(false)
        end
    end
end

function PnlTask:OnTaskChange()
    self:refreshData()
    if self.type2Message[self.showingType] then
        self.type2Message[self.showingType].func()
    end
end

function PnlTask:refreshData()
    local view = self.view
    self.branchTaskDataList = {}
    if AchievementData.taskChapterId > 0 then
        for i = 1, AchievementData.taskChapterId, 1 do
            local chapterCfg = cfg.chapterTask[i]
            for index, taskId in ipairs(chapterCfg.branchTaskList) do
                local task = cfg.subTask[taskId]
                if task.available == 1 then
                    table.insert(self.branchTaskDataList, task)
                end
            end
        end
    end
    TaskUtil.sortTask(self.branchTaskDataList)

    self.ChapterCfg = cfg.chapterTask[AchievementData.taskChapterId]
    self.mainTaskFinishCount = 0
    self.mainTaskTotelCount = 0--#self.ChapterCfg.mainTaskList

    self.mainTaskDataList = {}
    for index, value in ipairs(self.ChapterCfg.mainTaskList) do
        local subCfg = cfg.subTask[value]

        if subCfg.available == 1 then
            table.insert(self.mainTaskDataList, subCfg)
            self.mainTaskTotelCount = self.mainTaskTotelCount + 1
            local completeData = AchievementData.completeTasksMap[subCfg.cfgId]
            if completeData and completeData.stage == 2 then
                self.mainTaskFinishCount = self.mainTaskFinishCount + 1
            end
        end
    end

    TaskUtil.sortTask(self.mainTaskDataList)

    self.dailyTaskDataList = {}
    for key, value in pairs(cfg.subTask) do
        if value.type == 3 and value.available == 1 then
            table.insert(self.dailyTaskDataList, value)
        end
    end

    TaskUtil.sortTask(self.dailyTaskDataList)
end

-- Chapter
function PnlTask:refreshChapter()
    if self.ChapterCfg == nil then
        self.view.layoutCharatcer:SetActiveEx(false)
        return
    end
    local view = self.view

    view.txtChapterName.text = Utils.getText(self.ChapterCfg.name)
    view.txtChapterDesc.text = Utils.getText(self.ChapterCfg.desc)
    for i = 1, 2 do
        if self.ChapterCfg.reward and self.ChapterCfg.reward[i] then
            view.taskChapterRewardItemList[i].transform:SetActiveEx(true)
            gg.setSpriteAsync(view.taskChapterRewardItemList[i].icon, constant.RES_2_CFG_KEY[self.ChapterCfg.reward[i][1]].icon)
            view.taskChapterRewardItemList[i].text.text = Utils.getShowRes(self.ChapterCfg.reward[i][2])
        else
            view.taskChapterRewardItemList[i].transform:SetActiveEx(false)
        end
    end

    if self.mainTaskFinishCount >= self.mainTaskTotelCount then
        view.sliderProgress.transform:SetActiveEx(false)
        if AchievementData.chapterState == 1 then
            view.btnChapterFetch:SetActiveEx(false)
            view.txtChapterFinish.transform:SetActiveEx(true)
        else
            view.btnChapterFetch:SetActiveEx(true)
            view.txtChapterFinish.transform:SetActiveEx(false)
        end
    else
        view.btnChapterFetch:SetActiveEx(false)
        view.sliderProgress.transform:SetActiveEx(true)
        view.txtChapterFinish.transform:SetActiveEx(false)
        view.txtProgress.text = string.format("%s/<color=#54B2FF>%s</color>", self.mainTaskFinishCount, self.mainTaskTotelCount)

        
        view.sliderProgress.value = self.mainTaskFinishCount / self.mainTaskTotelCount
    end

    self.mainTaskScrollView:setItemCount(#self.mainTaskDataList)
end

function PnlTask:onRenderItem(obj, index)
    local item = TaskItem:getItem(obj, self.mainTaskItemList, self)
    item:setData(self.mainTaskDataList[index])
end

function PnlTask:onBtnChapterFetch()
    AchievementData.C2S_Player_DrawChapterTask()
end

-- branch
function PnlTask:refreshBranch()
    local view = self.view
    self.branchTaskScrollView:setDataCount(#self.branchTaskDataList)
end

function PnlTask:onRenderBranchItem(obj, index)
    local item = TaskItem:getItem(obj, self.branchTaskItemList, self)
    item:setData(self.branchTaskDataList[index])
end
--Daily

function PnlTask:refreshDaily()
    local view = self.view
    -- self.branchTaskScrollView:setDataCount(#self.branchTaskDataList)

    self.dailyTaskScrollView:setItemCount(#self.dailyTaskDataList)

    view.txtDailyProgress.text = AchievementData.activation

    local activationRewardCount = #cfg.taskActivation
    self.activityRewardScrollView:setItemCount(activationRewardCount)

    self.lastActivation = cfg.taskActivation[activationRewardCount]
    view.sliderDailyProgress.value = AchievementData.activation / self.lastActivation.activation

    gg.timer:stopTimer(self.taskResetTimer)
    self.taskResetTimer = gg.timer:startLoopTimer(0, 0.2, -1, function()
        local time = AchievementData.dailyResetTick - Utils.getServerSec()
        local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
        -- self.txtSlider.text = 
        view.txtTaskTitle.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    end)
end

function PnlTask:onRenderDailyTask(obj, index)
    local item = DailyTaskItem:getItem(obj, self.dailyTaskItemList, self)
    item:setData(self.dailyTaskDataList[index], CommonTaskItem.TYPE_DAILY)
end

function PnlTask:onRenderActivationReward(obj, index)
    local item = DailyActivityRewardItem:getItem(obj, self.taskActivationRewardItemList, self)
    item:setData(cfg.taskActivation[index])
end

--

function PnlTask:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(self.view.btnChapterFetch, gg.bind(self.onBtnChapterFetch))
end

function PnlTask:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlTask:onDestroy()
    local view = self.view
    self.mainTaskScrollView:release()
    self.branchTaskScrollView:release()
    self.dailyTaskScrollView:release()
    self.activityRewardScrollView:release()

    self.viewOptionBtnBox:release()

    self.taskActivationInfoBox:release()
end

function PnlTask:onBtnClose()
    self:close()
end

function PnlTask:onPlayTaskResAnimation(_, args)
    -- if args.animationId == 3 then
    --     if self.showingType == PnlTask.SHOWING_TYPE_CHAPTER then
    --         TaskUtil.startTaskAnim(self.mainTaskItemList, args)

    --     elseif self.showingType == PnlTask.SHOWING_TYPE_TASK then
    --         TaskUtil.startTaskAnim(self.branchTaskItemList, args)

    --     elseif self.showingType == PnlTask.SHOWING_TYPE_DAILY_TASK then
    --         TaskUtil.startTaskAnim(self.dailyTaskItemList, args)
    --     end
    -- elseif args.animationId == 2 and self.showingType == PnlTask.SHOWING_TYPE_CHAPTER then
    --     for key, value in pairs(self.ChapterCfg.reward) do
    --         local item = self.view.taskChapterRewardItemList[key]
    --         if item and value[1] == args.resCfgId then
    --             gg.event:dispatchEvent("onResAnimation", args)
    --             gg.resEffectManager:fly3dRes2TargetOnPnlPlayerInformation(item.transform.gameObject, args.resCfgId,  args.change, true)
    --         end
    --     end
    -- end
end

function PnlTask:onPlayDailyActivationAnimation(_, args)
    if self.showingType == PnlTask.SHOWING_TYPE_DAILY_TASK then
        for key, value in pairs(self.taskActivationRewardItemList) do
            if value.activationCfg and value.activationCfg.id == args.fromId then
                gg.event:dispatchEvent("onResAnimation", args)
                gg.resEffectManager:explodeUiRes2PnlPlayerInformation(value.icon.transform.position, args.resCfgId, args.change)
            end
        end
    end
end

-------------------------------------------------------

return PnlTask