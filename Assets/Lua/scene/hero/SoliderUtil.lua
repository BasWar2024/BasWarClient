SoliderUtil = SoliderUtil or {}

function SoliderUtil:getSoliderCfgMap()
    if self.soliderCfgMap then
        return self.soliderCfgMap
    end
    self.soliderCfgMap = {}
    for key, value in pairs(cfg.solider) do
        self.soliderCfgMap[value.cfgId] = self.soliderCfgMap[value.cfgId] or {}
        self.soliderCfgMap[value.cfgId][value.level] = value
    end
    return self.soliderCfgMap
end

function SoliderUtil:checkIsEnoughtUpgrade(cfgID, level)
    if level == 0 or not self:getSoliderCfgMap()[cfgID] or
        not self:getSoliderCfgMap()[cfgID][level + 1]
        then
        return false
    end

    local curCfg = self:getSoliderCfgMap()[cfgID][level]
    return Utils:checkIsEnoughtLevelUpRes(curCfg, false)
end
