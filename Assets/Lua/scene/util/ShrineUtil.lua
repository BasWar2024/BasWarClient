ShrineUtil = ShrineUtil or {}

function ShrineUtil.getAddAttr()
    local addAtk = 0
    local addHp = 0
    
    for _, shrineData in pairs(ShrineData.ShrineMap) do
        local buildData = BuildData.buildData[shrineData.buildId]
        local buildCfg = BuildUtil.getCurBuildCfg(buildData.cfgId, buildData.level, buildData.quality)

        local subAddAtk = 0
        local subAddHp = 0

        for _, value in pairs(shrineData.data) do
            local heroData = HeroData.heroDataMap[value.id]
            local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)

            subAddAtk = subAddAtk + heroCfg.atk
            subAddHp = subAddHp + heroCfg.maxHp

            -- addAtk = addAtk + heroCfg.atk
            -- addHp = addHp + heroCfg.maxHp
        end

        subAddAtk = subAddAtk * buildCfg.translationRatio
        subAddHp = subAddHp * buildCfg.translationRatio

        addAtk = addAtk + subAddAtk
        addHp = addHp + subAddHp
    end

    return addAtk, addHp
end
