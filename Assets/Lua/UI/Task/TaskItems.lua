--------------------------------------------------------------------------------
CommonTaskItem = CommonTaskItem or class("CommonTaskItem", ggclass.UIBaseItem)

CommonTaskItem.TYPE_CHAPTER = 1
CommonTaskItem.TYPE_DAILY = 2

function CommonTaskItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function CommonTaskItem:onInit()
    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)
    self.btnFetch = self:Find("BtnFetch")
    self:setOnClick(self.btnFetch, gg.bind(self.onBtnFetch, self))
    self.txtFetch = self.btnFetch.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.gOcomplete = self:Find("GOcomplete")

    self.rewardItem = self:Find("LayoutRewards/RewardItem")
    self.rewardList = {}
    self.rewardList[1] = self:getRewardItem(1, self.rewardItem)
end

function CommonTaskItem:setData(taskCfg, taskType)
    self.taskType = taskType or CommonTaskItem.TYPE_CHAPTER

    self.taskCfg = taskCfg
    self.txtTitle.text = Utils.getText(taskCfg.desc)

    self.rewardDataList = TaskUtil.parseSubTaskReward(taskCfg.cfgId)
    -- self.rewardDataList = TaskUtil.parseSubTaskReward(102009)

    for index, value in ipairs(self.rewardDataList) do
        local item = self:getRewardItem(index)
        item.go:SetActiveEx(true)
        item.activityRewardItem:setData(value)

        local count = value.count
        if value.rewardType == constant.ACTIVITY_REWARD_RES then
            count = Utils.getShowRes(count)
        end
        item.text.text = count
    end

    for key, value in pairs(self.rewardList) do
        if key > #self.rewardDataList then
            value.go:SetActiveEx(false)
        end
    end

    local targetProgress = taskCfg.targetArgs[1]
    local taskData = AchievementData.completeTasksMap[taskCfg.cfgId]
    self.taskData = taskData
    self.taskTypeMessage = nil

    local targetType = taskCfg.targetType

    self.progress = 0
    self.targetProgress = targetProgress
    self.progressText = ""

    if taskData then
        self.progressText = TaskUtil.getShowProgress(targetType, targetProgress, targetProgress)
        self.progress = targetProgress
        if taskData.stage == 1 then
            self.btnFetch:SetActiveEx(true)
            self.gOcomplete.gameObject:SetActiveEx(false)
            self.txtFetch.text = Utils.getText("task_GainBtn")
        else
            self.btnFetch:SetActiveEx(false)
            self.gOcomplete.gameObject:SetActiveEx(true)
        end
    else
        local taskTarget
        if self.taskType == CommonTaskItem.TYPE_CHAPTER then
            taskTarget = AchievementData.taskTargetsMap[taskCfg.targetType]
        elseif self.taskType == CommonTaskItem.TYPE_DAILY then
            taskTarget = AchievementData.dailyTaskTargetsMap[taskCfg.targetType]
        end

        self.progress = 0
        if taskTarget then
            for key, value in pairs(taskTarget.targetConds) do
                if value.condId == taskCfg.cfgId then
                    self.progress = value.curVal
                    break
                end
            end
        end
        self.progressText = TaskUtil.getShowProgress(targetType, self.progress, targetProgress)

        self.btnFetch:SetActiveEx(false)
        self.gOcomplete.gameObject:SetActiveEx(false)

        self.taskTypeMessage = constant.TASK_TYPE_MESSAGE[taskCfg.targetType]
        self.jumpOpenView = nil
        if self.taskTypeMessage then
            if self.taskTypeMessage.jumpView then
                    self:showGoBtn()
                    self.jumpOpenView = self.taskTypeMessage.jumpView

            elseif self.taskTypeMessage.type == "BUILD_BUILDING" then
                if taskCfg.targetArgs[3] == 1 then
                    self:showGoBtn()
                    self.jumpOpenView = "PnlBuild"
                end
            end
        end
    end
end

function CommonTaskItem:showGoBtn()
    self.btnFetch:SetActiveEx(true)
    self.txtFetch.text = Utils.getText("task_GoBtn")
end

function CommonTaskItem:onBtnFetch()
    if self.taskData and self.taskData.stage == 1 then
        local rewardList = TaskUtil.parseSubTaskReward(self.taskCfg.cfgId)
        if next(rewardList) then
            gg.uiManager:openWindow("PnlTaskReward", {
                reward = rewardList
            })
        end
        AchievementData.C2S_Player_DrawTask(self.taskCfg.cfgId)
    elseif self.taskTypeMessage then
        if self.jumpOpenView then
            self.initData:close()
            gg.uiManager:openWindow(self.jumpOpenView)
        end
    end
end

function CommonTaskItem:getRewardItem(index, go)
    if self.rewardList[index] then
        return self.rewardList[index]
    end

    local item = {}
    go = go or UnityEngine.GameObject.Instantiate(self.rewardItem)
    item.go = go
    -- item.icon = go.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.text = go.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    item.activityRewardItem = ActivityRewardItem.new(go.transform:Find("ActivityRewardItem"))
    go.transform:SetParent(self.rewardItem.transform.parent, false)

    self:setOnClick(item.activityRewardItem.gameObject, gg.bind(self.onClickReward, self, index))
    self.rewardList[index] = item

    return item
end

function CommonTaskItem:onClickReward(index)
    local rewardData = self.rewardDataList[index]

    if rewardData.rewardType == constant.ACTIVITY_REWARD_ITEM then
        gg.printData(rewardData)
        gg.uiManager:openWindow("PnlTaskRewardDesc", {reward = rewardData, pos = self.rewardList[index].activityRewardItem.transform.position})
        -- gg.
    end
end

function CommonTaskItem:getRewardAnimObject(resType)
    for index, value in ipairs(self.rewardDataList) do
        if value[1] == resType then
            return self:getRewardItem(index).go
        end
    end
end

function CommonTaskItem:onRelease()
    for key, value in pairs(self.rewardList) do
        value.activityRewardItem:release()
    end
end

-------------------------------------------------------
TaskItem = TaskItem or class("TaskItem", ggclass.CommonTaskItem)

function TaskItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function TaskItem:onInit()
    CommonTaskItem.onInit(self)
    self.txtProgress = self:Find("TxtProgress", UNITYENGINE_UI_TEXT)

end

function TaskItem:setData(taskCfg, taskType)
    CommonTaskItem.setData(self, taskCfg, taskType)
    self.txtProgress.text = self.progressText
end
-------------------------------------------------------
DailyTaskItem = DailyTaskItem or class("DailyTaskItem", ggclass.CommonTaskItem)

function DailyTaskItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function DailyTaskItem:onInit()
    CommonTaskItem.onInit(self)
    self.layoutLock = self:Find("LayoutLock").transform
    self.txtLock = self.layoutLock:Find("TxtLock"):GetComponent(UNITYENGINE_UI_TEXT)
    self.activationItem = self:Find("LayoutRewards/ActivationItem").transform
    self.txtActivation = self.activationItem:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtProgress = self:Find("TxtTitle/TxtProgress", UNITYENGINE_UI_TEXT)
    self.sliderProgress = self:Find("SliderProgress", UNITYENGINE_UI_SLIDER)
end

function DailyTaskItem:setData(taskCfg, taskType)
    self.rewardItem:SetActiveEx(true)
    CommonTaskItem.setData(self, taskCfg, taskType)

    self.txtProgress.gameObject:SetActiveEx(true)
    self.txtProgress.text = string.format("[%s]", self.progressText)
    self.sliderProgress.value = self.progress / self.targetProgress

    self.progress = 0
    self.targetProgress = targetProgress

    self.activationItem:SetAsLastSibling()

    local baseLevel = gg.buildingManager:getBaseLevel()

    if taskCfg.activation then
        self.txtActivation.text = taskCfg.activation
    else
        self.txtActivation.text = 0
    end

    if taskCfg.lvRange then
        if baseLevel < taskCfg.lvRange[1] or baseLevel > taskCfg.lvRange[2] then
            self.rewardItem:SetActiveEx(false)
            self.btnFetch:SetActiveEx(false)
            self.txtProgress.gameObject:SetActiveEx(false)
            self.layoutLock:SetActiveEx(true)
            -- self.txtLock.text = string.format("unlock till %s to %s", taskCfg.lvRange[1], taskCfg.lvRange[2])
            self.txtLock.text = string.format("LV.%s", taskCfg.lvRange[1])
        else
            self.layoutLock:SetActiveEx(false)
        end
    else
        self.layoutLock:SetActiveEx(false)
    end
end

----------------------------------------------------------------
DailyActivityRewardItem = DailyActivityRewardItem or class("DailyActivityRewardItem", ggclass.UIBaseItem)

function DailyActivityRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function DailyActivityRewardItem:onInit()
    self.icon = self:Find("Icon", UNITYENGINE_UI_IMAGE)
    self.txtProgress = self:Find("TxtProgress", UNITYENGINE_UI_TEXT)
    -- self.imgLight = self:Find("ImgPoint/ImgLight")

    self.spineRewardFetch = self:Find("SpineRewardFetch")
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function DailyActivityRewardItem:setData(activationCfg)
    self.activationCfg = activationCfg

    self.txtProgress.text = activationCfg.activation
    local endActivation = cfg.taskActivation[#cfg.taskActivation]
    local parentLenth = self.transform.parent.rect.width
    self.transform.anchoredPosition = UnityEngine.Vector2(parentLenth * (activationCfg.activation / endActivation.activation), 0)

    self.isFetch = false
    for key, value in pairs(AchievementData.activationBox) do
        if value == activationCfg.id then
            self.isFetch = true
            break
        end
    end

    if self.isFetch then
        gg.setSpriteAsync(self.icon, string.format("TaskIcon_Atlas[%s_B]", activationCfg.icon))
    else
        gg.setSpriteAsync(self.icon, string.format("TaskIcon_Atlas[%s_A]", activationCfg.icon))
    end

    self:refresh()
end

function DailyActivityRewardItem:refresh()
    self.spineRewardFetch:SetActiveEx(false)

    if AchievementData.activation >= self.activationCfg.activation then
        if not self.isFetch then
            self.spineRewardFetch:SetActiveEx(true)
            if self.sequence == nil then
                self.icon.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
                self.sequence = CS.DG.Tweening.DOTween.Sequence()
                self.sequence:Append(self.icon.transform:DOPunchScale(CS.UnityEngine.Vector3(0.4, 0.4, 0.4), 0.3, 0, 0))
                self.sequence:AppendInterval(0.3)
                self.sequence:Append(self.icon.transform:DOPunchScale(CS.UnityEngine.Vector3(0.4, 0.4, 0.4), 0.3, 0, 0))
                self.sequence:AppendInterval(1)
                self.sequence:SetLoops(999999999999)
            end
        else
            self:killTweenSequence()
        end
    else
        self:killTweenSequence()
    end
end

function DailyActivityRewardItem:killTweenSequence()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.icon.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
end

function DailyActivityRewardItem:onBtnItem()
    if not self.isFetch and AchievementData.activation >= self.activationCfg.activation then
        local args = {rewards = {}}
        for _, taskActivationCfg in pairs(cfg.taskActivation) do
            if taskActivationCfg.activation <= AchievementData.activation then

                local isFetch = false
                for key, value in pairs(AchievementData.activationBox) do
                    if value == taskActivationCfg.id then
                        isFetch = true
                        break
                    end
                end

                if not isFetch then
                    local baseLevel = gg.buildingManager:getBaseLevel()
                    local baseBuildCfg = nil
                    for key, value in pairs(cfg.baseBuild) do
                        if value.minBaseLv >= baseLevel and value.minBaseLv <= baseLevel and value.id == taskActivationCfg.id then
                            baseBuildCfg = value
                        end
                    end

                    local rewards = baseBuildCfg.activationReward
                    for _, value in pairs(rewards) do
                        if value[2] > 0 then
                            table.insert(args.rewards, {rewardType = constant.ACTIVITY_REWARD_RES, resId = value[1], count = value[2]})
                        end
                    end
                    AchievementData.C2S_Player_DrawTaskActivation(taskActivationCfg.id)
                end
            end
        end

        if #args.rewards > 0 then
            gg.uiManager:openWindow("PnlReward", args)
        end
        -- AchievementData.C2S_Player_DrawTaskActivation(self.activationCfg.id)
    else
        self.initData:showActivationInfo(true, self)
    end
end

function DailyActivityRewardItem:onRelease()
    self:killTweenSequence()
end

----------------------------------------------------------------
TaskActivationInfoBox = TaskActivationInfoBox or class("TaskActivationInfoBox", ggclass.UIBaseItem)

function TaskActivationInfoBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function TaskActivationInfoBox:onInit()
    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)
    self.itemList = {}

    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "TaskActivationInfoBoxItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function TaskActivationInfoBox:setData(activationCfg, localPos)
    self.transform.localPosition = localPos

    self.isFetch = false
    for key, value in pairs(AchievementData.activationBox) do
        if value == activationCfg.id then
            self.isFetch = true
            break
        end
    end

    if self.isFetch then
        self.txtTitle.text = Utils.getText("task_Daily_RewardClaimed") --"AWARD RECEIVED"
    else
        self.txtTitle.text = string.format(Utils.getText("task_Daily_ReachToGet"), activationCfg.activation)
    end

    self.rewardDataList = {}

    local baseLevel = gg.buildingManager:getBaseLevel()
    local baseBuildCfg = nil
    for key, value in pairs(cfg.baseBuild) do
        if value.minBaseLv >= baseLevel and value.minBaseLv <= baseLevel and value.id == activationCfg.id then
            baseBuildCfg = value
        end
    end

    for key, value in pairs(baseBuildCfg.activationReward) do
        if value[2] > 0 then
            table.insert(self.rewardDataList, value)
        end
    end

    self.scrollView:setItemCount(#self.rewardDataList)
end

function TaskActivationInfoBox:onRenderItem(obj, index)
    local item = TaskActivationInfoBoxItem:getItem(obj)
    item:setData(self.rewardDataList[index], self.isFetch)
end

function TaskActivationInfoBox:onRelease()
    self.scrollView:release()
end

----------------------------------------------------------------
TaskActivationInfoBoxItem = TaskActivationInfoBoxItem or class("TaskActivationInfoBoxItem", ggclass.UIBaseItem)

function TaskActivationInfoBoxItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function TaskActivationInfoBoxItem:onInit()
    self.imgIcon = self:Find("ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
end

function TaskActivationInfoBoxItem:setData(data, isFetch)
    local resInfo = constant.RES_2_CFG_KEY[data[1]]
    gg.setSpriteAsync(self.imgIcon, resInfo.icon)
    self.txtName.text = Utils.getText(resInfo.languageKey)
    self.txtCount.text = string.upper(Utils.getShowRes(data[2])) 

    if isFetch then
        EffectUtil.setGray(self.imgIcon, true)

        local color = UnityEngine.Color(0x8b/0xff, 0x8b/0xff, 0x8b/0xff, 1)
        self.txtName.color = color
        self.txtCount.color = color
    else
        EffectUtil.setGray(self.imgIcon, false)

        local color = UnityEngine.Color(0x2e/0xff, 0x2e/0xff, 0x2e/0xff, 1)
        self.txtName.color = color
        self.txtCount.color = color
    end
end

function TaskActivationInfoBoxItem:onRelease()

end
