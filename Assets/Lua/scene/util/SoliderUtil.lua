SoliderUtil = SoliderUtil or {}

-- DEMO""
-- SoliderUtil.SOLDIER_WHITELIST = {4101001, 4102001, 4103001, 4104001, 4201001,
--                                  4202001, 4203001, 4301001, 4302001, 4105001,
--                                  4106001, 4107001, 4108001}

SoliderUtil.SOLDIER_WHITELIST = {
    6030001,
    6030003,
    6030004,
    6030005,
    6030006,
    6030007,
    6030008,
    6030009,
    6030010,
    7100001,
    7100003,
    7100008,
    7100009,
    7100011,
    7200002,
    7200004,
    7200005,
    7200006,
    7200007,
}

-- ""
function SoliderUtil.getSoliderCfgMap()
    if SoliderUtil.soliderCfgMap then
        return SoliderUtil.soliderCfgMap
    end
    SoliderUtil.soliderCfgMap = {}
    for key, value in pairs(cfg.solider) do
        SoliderUtil.soliderCfgMap[value.cfgId] = SoliderUtil.soliderCfgMap[value.cfgId] or {}
        SoliderUtil.soliderCfgMap[value.cfgId][value.level] = value
    end
    return SoliderUtil.soliderCfgMap
end

-- ""
function SoliderUtil.getSoliderForgeCfgMap()
    if not SoliderUtil.soliderForgeCfgMap then
        SoliderUtil.soliderForgeCfgMap = {}
        for key, value in pairs(cfg.soliderForge) do
            SoliderUtil.soliderForgeCfgMap[value.cfgId] = SoliderUtil.soliderForgeCfgMap[value.cfgId] or {}
            SoliderUtil.soliderForgeCfgMap[value.cfgId][value.level] = value
        end
    end
    return SoliderUtil.soliderForgeCfgMap
end

function SoliderUtil.getSubSoliderCfg(cfgId)
    local soldierLevelData = BuildData.soliderLevelData[cfgId]
    if SoliderUtil.getSoliderCfgMap()[cfgId] then
        if not soldierLevelData then
            return SoliderUtil.getSoliderCfgMap()[cfgId][0]
        else
            return SoliderUtil.getSoliderCfgMap()[cfgId][soldierLevelData.level]
        end
    end
end

-- ""
function SoliderUtil.getSoliderStudyCfgMap()
    if SoliderUtil.soliderStudyCfgMap then
        return SoliderUtil.soliderStudyCfgMap
    end
    SoliderUtil.soliderStudyCfgMap = {}

    for key, value in pairs(SoliderUtil.getSoliderCfgMap()) do
        local studyId = value[1].studyId
        SoliderUtil.soliderStudyCfgMap[studyId] = SoliderUtil.soliderStudyCfgMap[studyId] or {}
        SoliderUtil.soliderStudyCfgMap[studyId][key] = value
    end

    for key, value in pairs(SoliderUtil.soliderStudyCfgMap) do
        local list = {}
        for k, v in pairs(value) do
            table.insert(list, v)
        end
        table.sort(list, function(a, b)
            return a[1].cfgId < b[1].cfgId
        end)
        SoliderUtil.soliderStudyCfgMap[key] = list
    end

    return SoliderUtil.soliderStudyCfgMap
end

-- ""
function SoliderUtil.getSoliderQualityCfgMap()
    if SoliderUtil.soliderQualityCfgMap then
        return SoliderUtil.soliderQualityCfgMap
    end
    SoliderUtil.soliderQualityCfgMap = {}

    for key, value in pairs(SoliderUtil.getSoliderCfgMap()) do
        local studyId = value[1].studyId
        SoliderUtil.soliderQualityCfgMap[studyId] = SoliderUtil.soliderQualityCfgMap[studyId] or {}
        SoliderUtil.soliderQualityCfgMap[studyId][key] = value
    end

    for key, value in pairs(SoliderUtil.soliderQualityCfgMap) do
        local list = {}
        for k, v in pairs(value) do
            table.insert(list, v)
        end
        table.sort(list, function(a, b)
            return a[1].cfgId < b[1].cfgId
        end)
        table.remove(list, 1)
        SoliderUtil.soliderQualityCfgMap[key] = list
    end

    return SoliderUtil.soliderQualityCfgMap
end

function SoliderUtil.getSoldierQuality(cfgId)
    return 0

    -- local curCfg = SoliderUtil.getSoliderCfgMap()[cfgId][0]
    -- for index, value in ipairs(SoliderUtil.getSoliderStudyCfgMap()[curCfg.studyId]) do
    --     if value[0].cfgId == cfgId then
    --         return index
    --     end
    -- end
end

function SoliderUtil.checkIsEnoughtUpgrade(cfgID, level)
    if level == 0 or BuildData.isSoldierUpgradeing or not SoliderUtil.getSoliderCfgMap()[cfgID] or
        not SoliderUtil.getSoliderCfgMap()[cfgID][level + 1] then
        return false
    end
    local curCfg = SoliderUtil.getSoliderCfgMap()[cfgID][level]
    return Utils.checkIsEnoughtLevelUpRes(curCfg, false)
end

function SoliderUtil.checkIsEnoughtAscend(cfgID, level)
    if level ~= 0 or BuildData.isSoldierAscending or not SoliderUtil.getSoliderCfgMap()[cfgID] then
        return false
    end
    local curCfg = SoliderUtil.getSoliderCfgMap()[cfgID][level]
    return Utils.checkIsEnoughtLevelUpRes(curCfg, false)
end

function SoliderUtil.checkIsEnoughtForge(cfgID)
    local forgeData = BuildData.soliderForgeData[cfgID]

    if not forgeData or SoliderUtil.getSoliderForgeCfgMap()[cfgID][forgeData.level + 1] == nil then
        return false
    end

    local forgeCfg = SoliderUtil.getSoliderForgeCfgMap()[cfgID][forgeData.level]
    return Utils.checkIsEnoughtLevelUpRes(forgeCfg, false)
end

function SoliderUtil.checkTrainStage()
    local isTraining = false
    local isCanTrain = false
    for key, buildData in pairs(BuildData.buildData) do
        if buildData.cfgId == constant.BUILD_LIBERATORSHIP then
            if buildData.soliderCfgId ~= 0 or buildData.trainCfgId ~= 0 then
                local soliderCfgId = buildData.soliderCfgId
                if buildData.trainCfgId ~= 0 then
                    soliderCfgId = buildData.trainCfgId
                end

                if buildData.lessTrainTick > 0 then
                    isTraining = true
                else
                    local buildCfg = BuildUtil.getCurBuildCfg(buildData.cfgId, buildData.level, buildData.quality)
                    local soldierCfg = SoliderUtil.getSubSoliderCfg(soliderCfgId)

                    local maxCount = math.floor(buildCfg.maxTrainSpace / soldierCfg.trainSpace)
                    local canTrainCount = maxCount - buildData.soliderCount

                    if canTrainCount > 0 then
                        isCanTrain = true
                    end
                end
                if isCanTrain and isTraining then
                    break
                end
            end
        end
    end

    return isCanTrain, isTraining
end

function SoliderUtil.getSoldierAttr(cfgId, level, forgeLevel, attrCfgList)
    local attrMap = {}
    local soldierCfg = SoliderUtil.getSoliderCfgMap()[cfgId][level]

    local forgeCfg = {
        showAttr = {}
    }

    if SoliderUtil.getSoliderForgeCfgMap()[cfgId] then
        forgeCfg = SoliderUtil.getSoliderForgeCfgMap()[cfgId][forgeLevel]
    end

    if not soldierCfg or not forgeCfg then
        return attrMap
    end

    attrCfgList = attrCfgList or constant.INSTITUE_SOLDIER_SHOW_ATTR

    for key, value in pairs(attrCfgList) do
        attrMap[value.cfgKey] = AttrUtil.getAttrNumberByCfg(value, soldierCfg)
    end

    local forgeAttrCfgList = AttrUtil.getAttrList(forgeCfg.showAttr[1])
    for key, value in pairs(forgeAttrCfgList) do
        attrMap[value.cfgKey] = attrMap[value.cfgKey] or 0
        attrMap[value.cfgKey] = attrMap[value.cfgKey] + AttrUtil.getAttrNumberByCfg(value, forgeCfg)
    end
    attrMap.atkSpeed = soldierCfg.atkSpeed
    return attrMap
end

function SoliderUtil.showSoldierInfo(soliderCfg)
    local args = {
        type = ggclass.PnlItemInfo.TYPE_SOLDIER_INFO,
        cfg = soliderCfg,
        attrDataList = constant.SOLDIER_INFO_ATTR
    }
    gg.uiManager:openWindow("PnlItemInfo", args)
end

function SoliderUtil.isInSoldierWhiteList(cfgId)
    for i, v in ipairs(SoliderUtil.SOLDIER_WHITELIST) do
        if cfgId == v then
            return true
        end
    end
    return false
end

function SoliderUtil.isLevelMax(cfgId)
    local soldierData = BuildData.soliderLevelData[cfgId]
    return SoliderUtil.getSoliderCfgMap()[cfgId][soldierData.level + 1] == nil
end
