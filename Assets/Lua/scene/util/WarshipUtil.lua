WarshipUtil = WarshipUtil or {}

function WarshipUtil.getWarshipCfg(cfgId, quality, level)
    for key, value in pairs(cfg.warShip) do
        if value.cfgId == cfgId and value.quality == quality and value.level == level then
            return value
        end
    end
end

function WarshipUtil.getWarshipAttr(cfgId, quality, level, forgeLevel, curLi)
    local levelCfg = WarshipUtil.getWarshipCfg(cfgId, quality, level)

    if not levelCfg then
        return {}
    end

    local attrMap = {}
    for key, value in pairs(constant.WARSHIP_SHOW_ATTR) do
        local attr = AttrUtil.getAttrNumberByCfg(value, levelCfg) or 0
        if value.cfgKey == "durability" then
            attrMap[value.cfgKey] = curLi
        else
            attrMap[value.cfgKey] = attr
        end
    end

    return attrMap
end

function WarshipUtil.checkIsCanUpgradeWarshipSkill(skillCfg)
    if not gg.warShip.warShipData or
        gg.warShip.warShipData.lessTick > 0 or
        gg.warShip.warShipData.skillUpLessTick > 0 or
        skillCfg.level >= gg.warShip.warShipData.level or
        not SkillUtil.getSkillCfgMap()[skillCfg.cfgId][skillCfg.level + 1] then
        return false
    end
    return Utils.checkIsEnoughtLevelUpRes(skillCfg)
end

WarshipUtil.BUSY_TYPE_SKILL = 1
WarshipUtil.BUSY_TYPE_LEVEL = 2

function WarshipUtil.checkWarshipBusy(isAlertAndUpgrade, skill)
    if true then
        return false
    end

    if not gg.warShip.warShipData then
        return false
    end

    local isBusy = false
    local cost = 0
    local busyType

    local data = gg.warShip.warShipData

    if gg.warShip.warShipData.lessTick > 0 then
        isBusy = true
        cost = ResUtil.getSpeedUpCost(data.lessTickEnd - os.time())
        busyType = WarshipUtil.BUSY_TYPE_LEVEL

    elseif gg.warShip.warShipData.skillUpLessTick > 0 then
        isBusy = true
        cost = ResUtil.getSpeedUpCost(data.skillUpLessTickEnd - os.time())
        busyType = WarshipUtil.BUSY_TYPE_SKILL
    end


    if isAlertAndUpgrade and isBusy then
        local args = {btnType = PnlAlert.BTN_TYPE_SINGLE}
        if busyType == WarshipUtil.BUSY_TYPE_SKILL then
            args.txt = Utils.getText("universal_Ask_FinishAndUpgrade")  --string.format("upgradeing skill, cost %s Hydroxyl to finish and start upgrade", Utils.getShowRes(cost))
        elseif busyType == WarshipUtil.BUSY_TYPE_LEVEL then
            args.txt = Utils.getText("universal_Ask_FinishAndUpgrade") --string.format("upgradeing level, cost %s Hydroxyl to finish and start upgrade", Utils.getShowRes(cost))
        end

        args.callbackYes = function ()
            if skill then
                WarShipData.C2S_Player_WarShipSkillUp(data.id, skill, 0)
            else
                WarShipData.C2S_Player_WarShipLevelUp(data.id, 0)
            end
        end

        args.yesCostList = {{cost = cost, resId = constant.RES_TESSERACT},}
        gg.uiManager:openWindow("PnlAlert", args)
    end

    return isBusy, cost, busyType
end
