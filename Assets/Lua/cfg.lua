cfg = cfg or {}
local cfgMap = {}

local cfg2CfgBattle = {
    ["build"] = {
        key = "buildBattleCfgId",
        tableName = "buildBattle"
    },

    ["solider"] = {
        key = "soliderBattleCfgId",
        tableName = "soliderBattle"
    },

    ["hero"] = {
        key = "heroBattleCfgId",
        tableName = "heroBattle"
    },

    ["skill"] = {
        key = "skillBattleCfgId",
        tableName = "skillBattle"
    },

    ["warShip"] = {
        key = "warShipBattleCfgId",
        tableName = "warShipBattle"
    }
}

local meta = {}
meta.__index = function(t, k)
    if not cfgMap[k] then
        cfgMap[k] = require("etc.cfg." .. k)

        local targetData = cfg2CfgBattle[k]
        if targetData then
            local targetCfg = require("etc.cfg." .. cfg2CfgBattle[k].tableName)

            for key, value in pairs(cfgMap[k]) do
                local subCfg = targetCfg[value[targetData.key]] or {}
                -- local subCfg = nil
                -- for _, targetSubCfg in pairs(targetCfg) do
                --     if targetSubCfg.cfgId == value[targetData.key] then
                --         subCfg = targetSubCfg
                --     end
                -- end
                -- subCfg = subCfg or {}

                local tableMeta = {}
                tableMeta.__index = function(t1, k1)
                    return subCfg[k1]
                end
                setmetatable(value, tableMeta)
            end
        end
    end
    return cfgMap[k]
end
setmetatable(cfg, meta)

function cfg.get(path)
    return require(path)
end

function cfg.getCfg(type, cfgId, level, quality, belong)
    -- local path = cfg[type] --"etc.cfg." .. type
    local allCfg = cfg[type] -- cfg.get(path)
    local cfgData = nil
    for k, v in pairs(allCfg) do
        local bool = true
        if v.cfgId ~= cfgId then
            bool = false
        end
        if bool then
            if level then
                if v.level ~= level then
                    bool = false
                end
            end
            if quality then
                if v.quality ~= quality then
                    bool = false
                end
            end
            if belong then
                if v.belong ~= belong then
                    bool = false
                end
            end
        end

        if bool then
            cfgData = v
            break
        end
    end

    return cfgData
end

starmapTable = {}

function loadTable()
    starmapTable = cfg.get("etc.cfg.starmap")
end

return cfg
