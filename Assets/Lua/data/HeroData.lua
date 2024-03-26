HeroData = {}

HeroData.heroDataMap = {}
HeroData.ChooseingHero = nil

-- ""
function HeroData.C2S_Player_HeroLevelUp(id, speedUp)
    gg.client.gameServer:send("C2S_Player_HeroLevelUp", {
        id = id,
        speedUp = speedUp
    })
end

-- ""
function HeroData.C2S_Player_HeroSkillUp(id, skillUp, speedUp)
    gg.client.gameServer:send("C2S_Player_HeroSkillUp", {
        id = id,
        skillUp = skillUp,
        speedUp = speedUp
    })
end

-- ""
function HeroData.C2S_Player_HeroSelectSkill(id, selectSkill)
    gg.client.gameServer:send("C2S_Player_HeroSelectSkill", {
        id = id,
        selectSkill = selectSkill
    })
end

-- ""
function HeroData.C2S_Player_SetUseHero(id)
    gg.client.gameServer:send("C2S_Player_SetUseHero", {
        id = id
    })
end

-- ""
function HeroData.C2S_Player_HeroRepair(id)
    gg.client.gameServer:send("C2S_Player_HeroRepair", {
        id = id
    })
end

-- ""
function HeroData.C2S_Player_HeroPutonSkill(id, skillIndex, itemCfgId)
    gg.client.gameServer:send("C2S_Player_HeroPutonSkill", {
        id = id, -- ""id
        skillIndex = skillIndex, -- ""
        itemCfgId = itemCfgId -- ""id
    })
end

-- ""
function HeroData.C2S_Player_HeroResetSkill(id, skillIndex)
    gg.client.gameServer:send("C2S_Player_HeroResetSkill", {
        id = id, -- ""id
        skillIndex = skillIndex -- ""
    })
end

-- ""
function HeroData.C2S_Player_HeroForgetSkill(id, skillIndex)
    gg.client.gameServer:send("C2S_Player_HeroForgetSkill", {
        id = id, -- ""id
        skillIndex = skillIndex -- ""
    })
end

-- ""
function HeroData.C2S_Player_DismantleHero(heroIds)
    gg.client.gameServer:send("C2S_Player_DismantleHero", {
        heroIds = heroIds -- ""id
    })
end

-- ""
function HeroData.C2S_Player_SellEntity(idList, type)
    gg.client.gameServer:send("C2S_Player_SellEntity", {
        idList = idList, -- id
        type = type -- 1.""，2.""，3.""
    })

end

---------------------------------------------------------

function HeroData.S2C_Player_UseHeroUpdate(useId)
    for _, hero in pairs(HeroData.heroDataMap) do
        if hero.id == useId then
            HeroData.ChooseingHero = hero
        end
    end
    gg.event:dispatchEvent("onHeroChange")
end

function HeroData.S2C_Player_HeroData(heroData, useId)
    HeroData.heroDataMap = {}
    for _, hero in pairs(heroData) do
        HeroData.heroDataMap[hero.id] = hero
        ItemData.updateHero(hero)
        if hero.id == useId then
            HeroData.ChooseingHero = hero
        end
    end

    gg.event:dispatchEvent("onHeroChange")
end

function HeroData.S2C_Player_HeroAdd(hero)
    HeroData.heroDataMap[hero.id] = hero
    ItemData.updateHero(hero)
    gg.event:dispatchEvent("onHeroChange")
end

function HeroData.S2C_Player_HeroDel(id)
    HeroData.heroDataMap[id] = nil
    if HeroData.ChooseingHero and id == HeroData.ChooseingHero.id then
        HeroData.ChooseingHero = nil
    end
    gg.event:dispatchEvent("onHeroChange")
    gg.event:dispatchEvent("onSetViewInfo", id)
end

function HeroData.S2C_Player_HeroUpdate(hero)
    ItemData.updateHero(hero)
    HeroData.heroDataMap[hero.id] = hero
    if HeroData.ChooseingHero and hero.id == HeroData.ChooseingHero.id then
        HeroData.ChooseingHero = hero
    end
    gg.event:dispatchEvent("onHeroChange")
    gg.event:dispatchEvent("onSetViewInfo", hero.id, hero)
    gg.event:dispatchEvent("onUpgradeSkill", hero)
end

function HeroData.S2C_Player_DismantleReward(args)
    if args.result then
        gg.event:dispatchEvent("onDismantleReward", args.items)
    end
end

function ItemData.updateHero(hero)
    local nowTime = os.time()
    hero.lessTickEnd = hero.lessTick + nowTime
    hero.skillUpLessTickEnd = hero.skillUpLessTick + nowTime
    -- hero.repairLessTickEnd = hero.repairLessTick + nowTime
    hero.repairLessTickEnd = nowTime
end

return HeroData
