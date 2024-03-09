cfg = cfg or {}
local cfgMap = {}

local meta = {}
meta.__index = function (t, k)
    if not cfgMap[k] then
        cfgMap[k] = require("etc.cfg." .. k)
    end
    return cfgMap[k]
end
setmetatable(cfg, meta)

function cfg.get(path)
    return require(path)
end

function cfg:getCfg(type, cfgId, level)
    local path = "etc.cfg."..type
    local allCfg = self.get(path)
    local cfgData = nil
    for k, v in ipairs(allCfg) do
        if v.cfgId == cfgId and v.level == level then
            cfgData = v
        end
    end
    return cfgData
end

return cfg