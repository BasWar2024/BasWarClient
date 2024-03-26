MineUtil = MineUtil or {}

function MineUtil.getMineCfgMap()
    if not MineUtil.mineCfgMap then
        MineUtil.mineCfgMap = {}
        for key, value in pairs(cfg.build) do
            if value.subType == 2 then
                MineUtil.mineCfgMap[value.cfgId] = MineUtil.mineCfgMap[value.cfgId] or {}
                MineUtil.mineCfgMap[value.cfgId][value.level] = value
            end
        end
    end
    return MineUtil.mineCfgMap
end

function MineUtil.checkIsEnoughtUpgrade(cfgId, level)
    if level == 0 or not MineUtil.getMineCfgMap()[cfgId] or
        not MineUtil.getMineCfgMap()[cfgId][level + 1]
        then
        return false
    end

    local curCfg = MineUtil.getMineCfgMap()[cfgId][level]
    return Utils.checkIsEnoughtLevelUpRes(curCfg, false)
end
