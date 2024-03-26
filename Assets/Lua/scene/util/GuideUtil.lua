GuideUtil = GuideUtil or {}

-- cfg
function GuideUtil.getGuideMap()
    if not GuideUtil.guideCfgMap then
        GuideUtil.guideCfgMap = {}
        for key, value in pairs(cfg.guide) do
            GuideUtil.guideCfgMap[value.guideId] = GuideUtil.guideCfgMap[value.guideId] or {}
            GuideUtil.guideCfgMap[value.guideId][value.stepId] = value
        end
    end
    return GuideUtil.guideCfgMap
end

function GuideUtil.getGuideCfg(guideId, stepId)
    local guideCfgMap = GuideUtil:getGuideMap()
    if guideCfgMap[guideId] then
        return guideCfgMap[guideId][stepId]
    end
end

----------------------------------------------------------------------
function GuideUtil.checkRequirements(guideCfg)
    if not guideCfg.requirements then
        return true
    end

    local needBuildList = {}
    -- local needViewOpenList = {}

    for key, value in pairs(guideCfg.requirements) do
        if value[1] == "build" then
            table.insert(needBuildList, {[1] = value[2], [2] = value[3]})
        elseif value[1] == "viewOpen" then
            -- table.insert(needViewOpenList, value)
            if not GuideUtil.checkIsCanGuideView(value[2]) then
                return false
            end
        end
    end

    local isUnlock, lockMap, lockList = BuildingManager:checkNeedBuild(needBuilds)

    -- for index, value in ipairs(needViewOpenList) do
    --     local view = gg.uiManager:getWindow(value[2])
    --     if not view or not view:isShow() then
    --         return false
    --     end
    -- end

    return isUnlock
end

function GuideUtil.checkIsCanGuideView(pnlName)
    -- local view = gg.uiManager:getWindow(pnlName)
    -- if not view or not view:isShow() then
    --     return false
    -- end

    local view = gg.uiManager:getOpenWindow(pnlName)
    if not view or not view.transform then
        return false
    end

    if pnlName == "PnlAlert" then
        return true
    end

    if pnlName == "PnlOptions" then
        return true
    end

    if pnlName == "PnlPlanet" then
        return true
    end

    -- if pnlName == "PnlPlayerInformation" then
    --     return true
    -- end

    for key, value in pairs(gg.uiManager.openWindows) do
        if value.name ~= pnlName and
        (value.name ~= "PnlMain" and value.name ~= "PnlPlayerInformation" and value.name ~= "PnlTip" and  value.name ~= "PnlTipNode" and value.name ~= "PnlGuide") then
            if value.layer > view.layer or (value.layer == view.layer and value.transform:GetSiblingIndex() > view.transform:GetSiblingIndex()) then
                return false
            end
        end
    end

    return true, view
end

function GuideUtil.checkIsCanGuide(stepCfg)
    if not stepCfg then
        return false
    end

    if not GuideUtil.checkRequirements(stepCfg) then
        return false
    end

    local targetType = stepCfg.targetType
    if targetType == GuideManager.TARGET_TYPE_ONLY_TALK then
        for key, value in pairs(gg.uiManager.openWindows) do
            if value.name == "PnlLoading" or value.name == "PnlBattleLoading" or value.name == "PnlLogin" or value.name == "PnlRegister" then
                return false
            end
        end

        -- if stepCfg.pnlName and stepCfg.pnlName ~= "" then
        --     local view =  gg.uiManager:getWindow(stepCfg.pnlName)
        --     if not view or not view:isShow() then
        --         return false
        --     end
        -- end

        -- local view = gg.uiManager:getWindow("PnlLogin")
        -- local isPnlLoginOpen = view and view:isShow()
        return true

    elseif targetType == GuideManager.TARGET_TYPE_VIEW then
        return GuideUtil.checkIsCanGuideView(stepCfg.pnlName)

    elseif targetType == GuideManager.TARGET_TYPE_BUILDING then
        if gg.sceneManager.showingScene ~= constant.SCENE_BASE then
            return false
        end
        local ani = UnityEngine.Camera.main:GetComponent("Animator")

        if ani.enabled then
            return false
        end
        return GuideUtil.checkIsCanGuideView("PnlMain")

    elseif targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
        if gg.sceneManager.showingScene ~= constant.SCENE_BATTLE then
            return false
        end
        local ani = UnityEngine.Camera.main:GetComponent("Animator")
        if ani.enabled then
            return false
        end
        local isViewOpen, view = GuideUtil.checkIsCanGuideView("PnlBattle")
        if not view then
            return false
        end
        return isViewOpen and view.stage == stepCfg.otherArgs[1]

    elseif targetType == GuideManager.TARGET_TYPE_BATTLE_REPLAY then
        return true
    elseif targetType == GuideManager.TARGET_TYPE_BATTLE_CONDITION then
        return true
    elseif targetType == GuideManager.TARGET_TYPE_OPEN_VIEW then
        return true
    end
end
----------------------------------------------------------------------