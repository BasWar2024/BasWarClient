SkillUtil = SkillUtil or {}

function SkillUtil.getSkillCfgMap()
    if not SkillUtil.skillCfgMap then
        SkillUtil.skillCfgMap = {}
        for key, value in pairs(cfg.skill) do
            if value.cfgId then
                SkillUtil.skillCfgMap[value.cfgId] = SkillUtil.skillCfgMap[value.cfgId] or {}
                SkillUtil.skillCfgMap[value.cfgId][value.level] = value
            end
        end
    end
    return SkillUtil.skillCfgMap
end
