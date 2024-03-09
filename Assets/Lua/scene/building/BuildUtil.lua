BuildUtil = BuildUtil or {}

function BuildUtil:getBuildCfgMap()
    if not self.buildCfgMap then
        self.buildCfgMap = {}
        for key, value in pairs(cfg.build) do
            self.buildCfgMap[value.cfgId] = self.buildCfgMap[value.cfgId] or {}
            self.buildCfgMap[value.cfgId][value.level] = value
        end
    end
    return self.buildCfgMap
end

-- {1,2,3} cfg.attribute
function BuildUtil:getAttrList(showAttr)
    if showAttr == nil then
        return
    end
    local attrList = {}
    for key, value in ipairs(showAttr[1]) do
        table.insert(attrList, cfg.attribute[value])
    end
    return attrList
end