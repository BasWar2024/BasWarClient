MineUtil = MineUtil or {}

function MineUtil:getMineCfgMap()
    if not self.mineCfgMap then
        self.mineCfgMap = {}
        for key, value in pairs(cfg.build) do
            if value.subType == 2 then
                self.mineCfgMap[value.cfgId] = self.mineCfgMap[value.cfgId] or {}
                self.mineCfgMap[value.cfgId][value.level] = value
            end
        end
    end
    return self.mineCfgMap
end

function MineUtil:checkIsEnoughtUpgrade(cfgID, level)
    if level == 0 or not MineUtil:getMineCfgMap()[cfgID] or
        not MineUtil:getMineCfgMap()[cfgID][level + 1]
        then
        return false
    end

    local curCfg = MineUtil:getMineCfgMap()[cfgID][level]
    return Utils:checkIsEnoughtLevelUpRes(curCfg, false)
end
