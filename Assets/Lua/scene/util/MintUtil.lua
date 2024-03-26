MintUtil = MintUtil or {}

function MintUtil.getMintCostCfgMap()
    if MintUtil.mintCostCfgMap then
        return MintUtil.mintCostCfgMap
    end
    MintUtil.mintCostCfgMap = {}
    for key, value in pairs(cfg.mintCost) do
        MintUtil.mintCostCfgMap[value.cfgId] = MintUtil.mintCostCfgMap[value.cfgId] or {}
        MintUtil.mintCostCfgMap[value.cfgId][value.mintTime] = value
    end
    return MintUtil.mintCostCfgMap
end
