HeroUtil = HeroUtil or {}

function HeroUtil.getHeroCfgMap()
    if HeroUtil.heroMap then
        return HeroUtil.heroMap
    end
    HeroUtil.heroMap = {}
    for k, v in ipairs(cfg.hero) do
        HeroUtil.heroMap[v.cfgId] = HeroUtil.heroMap[v.cfgId] or {}
        HeroUtil.heroMap[v.cfgId][v.quality] = HeroUtil.heroMap[v.cfgId][v.quality] or {}
        HeroUtil.heroMap[v.cfgId][v.quality][v.level] = v
    end
    return HeroUtil.heroMap
end

function HeroUtil.getHeroCfg(cfgId, level, quality)

    if quality == 0 then
        quality = 1
    end

    return HeroUtil.getHeroCfgMap()[cfgId][quality][level]
end

function HeroUtil.getSkillMap()
    if HeroUtil.skillCfgMap then
        return HeroUtil.skillCfgMap
    end
    HeroUtil.skillCfgMap = {}
    for k, v in ipairs(cfg.skill) do
        HeroUtil.skillCfgMap[v.cfgId] = HeroUtil.skillCfgMap[v.cfgId] or {}
        HeroUtil.skillCfgMap[v.cfgId][v.level] = v
    end
    return HeroUtil.skillCfgMap
end

function HeroUtil.getSkillCfg()
    if HeroUtil.skillCfg then
        return HeroUtil.skillCfg
    end
    HeroUtil.skillCfg = {}
    for k, v in ipairs(cfg.skill) do
        HeroUtil.skillCfg[v.level] = HeroUtil.skillCfg[v.level] or {}
        HeroUtil.skillCfg[v.level][v.cfgId] = v
    end
    return HeroUtil.skillCfg
end

function HeroUtil.getChooseHeroCfg()
    if HeroData.ChooseingHero then
        return HeroUtil.getHeroCfg(HeroData.ChooseingHero.cfgId, HeroData.ChooseingHero.level, HeroData.ChooseingHero.quality)
    end
end

function HeroUtil.checkIsEnoughtUpgrade()
    if not HeroData.ChooseingHero then
        return false
    end
    local curCfg = HeroUtil.getChooseHeroCfg()
    if HeroUtil.getHeroCfg(HeroData.ChooseingHero.cfgId, HeroData.ChooseingHero.level + 1, HeroData.ChooseingHero.quality) then
        return curCfg.levelUpNeedStarCoin <= ResData.getStarCoin()
        and curCfg.levelUpNeedIce <= ResData.getIce()
        and curCfg.levelUpNeedCarboxyl <= ResData.getCarboxyl()
        and curCfg.levelUpNeedTitanium <= ResData.getTitanium()
        and curCfg.levelUpNeedGas <= ResData.getGas()
    end
    return false
end

function HeroUtil.checkIsEnoughtSkillUpgrade(index)
    if not HeroData.ChooseingHero or 
        not HeroData.ChooseingHero["skill" .. index] or
        HeroData.ChooseingHero["skill" .. index] == 0 or
        HeroData.ChooseingHero.level <= HeroData.ChooseingHero["skillLevel" .. index]  then
        return false
    end

    local level = HeroData.ChooseingHero["skillLevel" .. index]
    local skillCfgId = HeroData.ChooseingHero["skill" .. index]

    if SkillUtil.getSkillCfgMap()[skillCfgId][level + 1] == nil then
        return false
    end

    return Utils.checkIsEnoughtLevelUpRes(SkillUtil.getSkillCfgMap()[skillCfgId][level])
end

function HeroUtil.getHeroAttr(cfgId, level, quality)
    local attrMap = {}
    local heroCfg = HeroUtil.getHeroCfg(cfgId, level, quality)

    if not heroCfg then
        return attrMap
    end

    for key, value in pairs(constant.HERO_SHOW_ATTR) do
        attrMap[value.cfgKey] = AttrUtil.getAttrNumberByCfg(value, heroCfg)
    end

    attrMap.atkSpeed = heroCfg.atkSpeed
    return attrMap
end

HeroUtil.HERO_UPGRADING_TYPE_SKILL = 1
HeroUtil.HERO_UPGRADING_TYPE_LEVEL = 2

function HeroUtil.checkHeroBusy(isAlertAndUpgrade, skill)
    local isBusy = false
    local cost = 0
    local busyType

    local heroData --= HeroData.ChooseingHero

    for key, value in pairs(HeroData.heroDataMap) do
        if value then
            if value.skillUpLessTick > 0 then
                isBusy = true
                cost = ResUtil.getSpeedUpCost(value.skillUpLessTickEnd - os.time())
                busyType = HeroUtil.HERO_UPGRADING_TYPE_SKILL
                heroData = value
                break
    
            elseif value.lessTick > 0 then
                isBusy = true
                cost = ResUtil.getSpeedUpCost(value.lessTickEnd - os.time())
                busyType = HeroUtil.HERO_UPGRADING_TYPE_LEVEL
                heroData = value
                break
            end
        end
    end

    if isAlertAndUpgrade and isBusy then
        local args = {btnType = PnlAlert.BTN_TYPE_SINGLE}
        if busyType == HeroUtil.HERO_UPGRADING_TYPE_SKILL then
            args.txt = Utils.getText("universal_Ask_FinishAndExchangeRes")
        elseif busyType == HeroUtil.HERO_UPGRADING_TYPE_LEVEL then
            args.txt = Utils.getText("universal_Ask_FinishAndExchangeRes")
        end

        args.callbackYes = function ()
            if skill then
                HeroData.C2S_Player_HeroSkillUp(heroData.id, skill, 0)
            else
                HeroData.C2S_Player_HeroLevelUp(heroData.id, 0)
            end
        end
        args.yesCostList = {{cost = cost, resId = constant.RES_TESSERACT},}
        gg.uiManager:openWindow("PnlAlert", args)
    end

    return isBusy, cost, busyType
end
