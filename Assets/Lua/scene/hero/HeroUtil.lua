HeroUtil = HeroUtil or {}

function HeroUtil:getHeroCfgMap()
    if self.heroMap then
        return self.heroMap
    end
    self.heroMap = {}
    for k, v in ipairs(cfg.hero) do
        self.heroMap[v.cfgId] = self.heroMap[v.cfgId] or {}
        self.heroMap[v.cfgId][v.level] = v
    end
    return self.heroMap
end

function HeroUtil:getSkillMap()
    if self.skillCfgMap then
        return self.skillCfgMap
    end
    self.skillCfgMap = {}
    for k, v in ipairs(cfg.skill) do
        self.skillCfgMap[v.cfgId] = self.skillCfgMap[v.cfgId] or {}
        self.skillCfgMap[v.cfgId][v.level] = v
    end
    return self.skillCfgMap
end

function HeroUtil:getSkillCfg()
    if self.skillCfg then
        return self.skillCfg
    end
    self.skillCfg = {}
    for k, v in ipairs(cfg.skill) do
        self.skillCfg[v.level] = self.skillCfg[v.level] or {}
        self.skillCfg[v.level][v.cfgId] = v
    end
    return self.skillCfg
end

function HeroUtil:getChooseHeroCfg()
    if HeroData.ChooseingHero then
        return self:getHeroCfgMap()[HeroData.ChooseingHero.cfgId][HeroData.ChooseingHero.level]
    end
end

function HeroUtil:checkIsEnoughtUpgrade()
    if not HeroData.ChooseingHero then
        return false
    end
    local curCfg = self:getChooseHeroCfg()
    if self:getHeroCfgMap()[HeroData.ChooseingHero.cfgId] and self:getHeroCfgMap()[HeroData.ChooseingHero.cfgId][HeroData.ChooseingHero.level + 1] then
        return curCfg.levelUpNeedStarCoin <= ResData.getStarCoin()
        and curCfg.levelUpNeedIce <= ResData.getIce()
        and curCfg.levelUpNeedCarboxyl <= ResData.getCarboxyl()
        and curCfg.levelUpNeedTitanium <= ResData.getTitanium()
        and curCfg.levelUpNeedGas <= ResData.getGas()
    end
    return false
end

function HeroUtil:checkIsEnoughtSkillUpgrade(index)
    if not HeroData.ChooseingHero or 
        not self:getChooseHeroCfg()["skill" .. index] or
        HeroData.ChooseingHero.level <= HeroData.ChooseingHero["skillLevel" .. index]  then
        return false
    end

    if not self:getSkillCfg()[HeroData.ChooseingHero["skillLevel" .. index] + 1] then
        return false
    end

    if self:getSkillCfg()[HeroData.ChooseingHero["skillLevel" .. index]] and 
        self:getSkillCfg()[HeroData.ChooseingHero["skillLevel" .. index]][self:getChooseHeroCfg()["skill" .. index]] then
            local curSkillCfg = self:getSkillCfg()[HeroData.ChooseingHero["skillLevel" .. index]][self:getChooseHeroCfg()["skill" .. index]]
            return curSkillCfg.levelUpNeedStarCoin <= ResData.getStarCoin()
            and curSkillCfg.levelUpNeedIce <= ResData.getIce()
            and curSkillCfg.levelUpNeedCarboxyl <= ResData.getCarboxyl()
            and curSkillCfg.levelUpNeedTitanium <= ResData.getTitanium()
            and curSkillCfg.levelUpNeedGas <= ResData.getGas()
    end
    return false
end