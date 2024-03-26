BuildUtil = BuildUtil or {}

function BuildUtil.getBuildCfgMap()
    if not BuildUtil.buildCfgMap then
        BuildUtil.buildCfgMap = {}
        for key, value in pairs(cfg.build) do
            BuildUtil.buildCfgMap[value.cfgId] = BuildUtil.buildCfgMap[value.cfgId] or {}
            BuildUtil.buildCfgMap[value.cfgId][value.quality] = BuildUtil.buildCfgMap[value.cfgId][value.quality] or {}
            BuildUtil.buildCfgMap[value.cfgId][value.quality][value.level] = value
        end
    end
    return BuildUtil.buildCfgMap
end

function BuildUtil.getCurBuildCfg(cfgId, level, quality)
    quality = quality or 0
    -- for key, value in pairs(cfg.build) do
    --     if value.cfgId == cfgId and value.level == level and value.quality == quality then
    --         return value
    --     end
    -- end
    if BuildUtil.getBuildCfgMap()[cfgId] and BuildUtil.getBuildCfgMap()[cfgId][quality] then
        return BuildUtil.getBuildCfgMap()[cfgId][quality][level]
    end
end

function BuildUtil.getBuildForgeCfgMap()
    if not BuildUtil.buildForgeCfgMap then
        BuildUtil.buildForgeCfgMap = {}
        -- for key, value in pairs(cfg.buildForge) do
        --     BuildUtil.buildForgeCfgMap[value.cfgId] = BuildUtil.buildForgeCfgMap[value.cfgId] or {}
        --     BuildUtil.buildForgeCfgMap[value.cfgId][value.level] = value
        -- end
    end
    return BuildUtil.buildForgeCfgMap
end

-- {1,2,3} ""cfg.attribute
function BuildUtil.getAttrList(showAttr)
    return AttrUtil.getAttrList(showAttr[1])
end

function BuildUtil.getBuildAttr(cfgId, level, quality, forgeLevel)
    quality = quality or 0
    local buildCfg = BuildUtil.getCurBuildCfg(cfgId, level, quality)

    local forgeCfg = nil
    if BuildUtil.getBuildForgeCfgMap()[cfgId] then
        forgeCfg = BuildUtil.getBuildForgeCfgMap()[cfgId][forgeLevel]
    end
    forgeCfg = forgeCfg or {}

    if not buildCfg then
        return nil
    end

    local attrList = BuildUtil.getAttrList(buildCfg.showAttr)

    local attrMap = {}
    for index, value in ipairs(attrList) do
        attrMap[value.cfgKey] = AttrUtil.getAttrNumberByCfg(value, buildCfg)
        if forgeCfg then
            attrMap[value.cfgKey] = attrMap[value.cfgKey] + AttrUtil.getAttrNumberByCfg(value, forgeCfg)
        end
    end
    attrMap.atkSpeed = buildCfg.atkSpeed
    attrMap.attEnableRatio = buildCfg.attEnableRatio
    attrMap.hpEnableRatio = buildCfg.hpEnableRatio
    -- attrMap.atkAir = buildCfg.atkAir
    return attrMap
end

function BuildUtil.checkIsCanLevelUp(buildCfg, isAlertRes, isAlertWorker)
    if not Utils.checkIsEnoughtLevelUpRes(buildCfg, isAlertRes) or
        not BuildUtil.getCurBuildCfg(buildCfg.cfgId, buildCfg.level + 1, buildCfg.quality) or
        not gg.buildingManager:checkWorkers(isAlertWorker) or not BuildUtil.checkConstruction(buildCfg) 
        then
        return false
    end

    return gg.buildingManager:checkUpgradeLock(buildCfg)
end

function BuildUtil.checkConstruction(buildCfg)
    local construction = 0
    for key, value in pairs(BuildData.buildData) do
        local buildingCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)
        construction = buildingCfg.construction + construction
    end
    return construction >= buildCfg.levelUpNeedConstruction
end

function BuildUtil.afterBuildingBuild(buildCfg, yesCallback, exchangeFailedCallback)
    local count, buildId, cost = BuildingManager.getBuildWorkSpeedUpInfo()
    local exchangeInfo = nil
    if count >= BuildData.buildQueueCount then
        exchangeInfo = {
            extraExchangeCost = cost,
            text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        }
    else
        exchangeInfo = {
            text = Utils.getText("universal_Ask_ExchangeRes"),
        }
    end

    local exchangeCallback = function(cost)
        if cost and cost > ResData.getTesseract() then
            gg.uiManager:showTip("Tesseract is not enough")
            if exchangeFailedCallback then
                exchangeFailedCallback()
            end
            return
        end

        if count >= BuildData.buildQueueCount then
            BuildData.C2S_Player_BuildLevelUp(buildId, 1)
        end
        yesCallback()
    end

    if Utils.checkIsEnoughtLevelUpRes(buildCfg, true, exchangeCallback, exchangeInfo) then
        if count >= BuildData.buildQueueCount then
            local args = {
                btnType = PnlAlert.BTN_TYPE_SINGLE
            }
            args.txt = string.format(Utils.getText("universal_Ask_NotEnoughtWorker"), Utils.getShowRes(cost), Utils.getText(constant.RES_2_CFG_KEY[constant.RES_TESSERACT].languageKey))
            args.callbackYes = gg.bind(exchangeCallback, cost)
            args.callbackNo = function()
                gg.buildingManager:cancelBuildOrMove()
            end
            args.yesCostList = {{cost = cost, resId = constant.RES_TESSERACT},}
            gg.uiManager:openWindow("PnlAlert", args)
        else
            yesCallback()
        end
    end
end

function BuildUtil.chackLevelUpNeedConstruction(buildCfg)
    local totalCon = 0
    for k, v in pairs(gg.buildingManager.buildingTable) do
        if v.buildCfg.type ~= constant.BUILD_CLUTTER then
            totalCon = totalCon + v.buildCfg.construction
        end
    end
    return totalCon >= buildCfg.levelUpNeedConstruction, totalCon
end

function BuildUtil.getBuildUnlockText(buildCfg, level)
    if buildCfg.cfgId == constant.BUILD_HYPERSPACERESEARCH then
        return string.format(Utils.getText("unlock_ResearchTips"), level)
    else
        return string.format(Utils.getText("unlock_UniversalTips"), level, Utils.getText(buildCfg.languageNameID))
    end
end