cfg = cfg or {}
local cfgMap = {}

local cfg2CfgBattle = {
    ["build"] = {
        key = "buildBattleCfgId",
        tableName = "buildBattle",
    },

    ["solider"] = {
        key = "soliderBattleCfgId",
        tableName = "soliderBattle",
    },

    ["hero"] = {
        key = "heroBattleCfgId",
        tableName = "heroBattle",
    },

    
    ["skill"] = {
        key = "skillBattleCfgId",
        tableName = "skillBattle",
    },

    ["warShip"] = {
        key = "warShipBattleCfgId",
        tableName = "warShipBattle",
    },
}

local meta = {}
meta.__index = function(t, k)
    if not cfgMap[k] then
        cfgMap[k] = require(".Lua.etc.cfg." .. k)

        local targetData = cfg2CfgBattle[k]
        if targetData then
            -- G:\work\StarWarClient\Assets\Lua\etc\cfg\build.lua

            local targetCfg = require(".Lua.etc.cfg." .. cfg2CfgBattle[k].tableName)

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
                tableMeta.__index = function (t1, k1)
                    return subCfg[k1]
                end
                setmetatable(value, tableMeta)
            end
        end
    end
    return cfgMap[k]
end
setmetatable(cfg, meta)

return cfg
