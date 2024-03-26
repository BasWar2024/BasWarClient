AttrUtil = AttrUtil or {}

function AttrUtil.getAttrList(showAttr)
    local attrList = {}
    if showAttr == nil then
        return attrList
    end
    
    for key, value in ipairs(showAttr) do
        table.insert(attrList, cfg.attribute[value])
    end
    return attrList
end

function AttrUtil.getAttrChangeCfgList(attrCfgList, attrMap, compareAttrMap)
    attrCfgList = gg.copy(attrCfgList)

    if not compareAttrMap or not attrMap then
        return {}
    end

    for i = #attrCfgList, 1, -1 do
        if attrCfgList[i].cfgKey ~= "atkSpeed" then
            if not compareAttrMap[attrCfgList[i].cfgKey] then
                table.remove(attrCfgList, i)
            elseif attrMap[attrCfgList[i].cfgKey] then
                if attrCfgList[i].cfgKey == "atk" then
                    local atkSpeed = attrMap.atkSpeed or 1
                    local atk = attrMap[attrCfgList[i].cfgKey] / atkSpeed
                    local compareAtkSpeed = compareAttrMap.atkSpeed or 1
                    local compareAtk = compareAttrMap[attrCfgList[i].cfgKey] / compareAtkSpeed
        
                    if compareAtk == atk then
                        table.remove(attrCfgList, i)
                    end
                else
                    if attrMap[attrCfgList[i].cfgKey] == compareAttrMap[attrCfgList[i].cfgKey] then
                        table.remove(attrCfgList, i)
                    end
                end
            end
        end
    end

    return attrCfgList
end

function AttrUtil.getAttrNumberByCfg(attrCfg, targetCfg)
    if not targetCfg or not attrCfg then
        return 0
    end

    local attr = targetCfg[attrCfg.cfgKey]
    if attr == nil then
        attr = 0
    end

    return attr
end

function AttrUtil.getAttrByCfg(attrCfg, targetCfg, targetAtkSpeedCfg)
    if not targetCfg or not attrCfg then
        return 0
    end

    targetAtkSpeedCfg = targetAtkSpeedCfg or targetCfg
    local attr = AttrUtil.getAttrNumberByCfg(attrCfg, targetCfg)

    if attrCfg.cfgKey == "atk" then
        if targetAtkSpeedCfg.atkSpeed ~= nil and targetAtkSpeedCfg.atkSpeed ~= 0 then
            attr = attr / targetAtkSpeedCfg.atkSpeed * 1000
        else
            attr = 0
        end
    elseif attrCfg.cfgKey == "atkAir" then
        if attr == 0 then
            attr = Utils.getText("atkType_ToAirAndGround")
        elseif attr == 1 then
            attr = Utils.getText("atkType_ToGround")
        elseif attr == 2 then
            attr = Utils.getText("atkType_ToAir")
        end
    end

    if attrCfg.trueMul and attrCfg.trueMul > 0 then
        attr = attr * attrCfg.trueMul
    end

    if attrCfg.mul and attrCfg.mul > 0 then
        attr = math.ceil(attr * attrCfg.mul)
    end

    return attr
end

local letnLenth = 50
function AttrUtil.getAttrScrollViewLenth(itemCount, spancing)
    spancing = spancing or 1
    return (letnLenth + spancing) * itemCount - spancing
end