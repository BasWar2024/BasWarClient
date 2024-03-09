HeroData = {}

-- HeroData.heroData = {}
HeroData.ChooseingHero = nil

--
function HeroData.C2S_Player_HeroLevelUp(id, speedUp)
    gg.client.gameServer:send("C2S_Player_HeroLevelUp",{
        id = id,
        speedUp = speedUp,
    })
end

--
function HeroData.C2S_Player_SpeedUp_HeroLevelUp(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_HeroLevelUp",{
        id = id,
    })
end

--
function HeroData.C2S_Player_HeroSkillUp(id, skillUp, speedUp)
    gg.client.gameServer:send("C2S_Player_HeroSkillUp",{
        id = id,
        skillUp = skillUp,
        speedUp = speedUp,
    })
end

--
function HeroData.C2S_Player_SpeedUp_HeroSkillUp(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_HeroSkillUp",{
        id = id,
    })
end

--
function HeroData.C2S_Player_HeroSelectSkill(id, selectSkill)
    gg.client.gameServer:send("C2S_Player_HeroSelectSkill",{
        id = id,
        selectSkill = selectSkill,
    })
end

function HeroData.S2C_Player_HeroData(heroData)
    HeroData.heroData = {}
    for _, hero in ipairs(heroData) do
        -- HeroData.heroData[hero.id] = hero
        ItemData.updateHero(hero)
    end
    gg.event:dispatchEvent("onHeroChange")
end

function HeroData.S2C_Player_HeroAdd(hero)
    -- HeroData.heroData[hero.id] = hero
    ItemData.updateHero(hero)
    gg.event:dispatchEvent("onHeroChange")
end

function HeroData.S2C_Player_HeroDel(id)
    -- HeroData.heroData[id] = nil
    if HeroData.ChooseingHero.id == id then
        HeroData.ChooseingHero = nil
    end
    gg.event:dispatchEvent("onHeroChange")
end

function HeroData.S2C_Player_HeroUpdate(hero)
    ItemData.updateHero(hero)
    gg.event:dispatchEvent("onHeroChange")
end

function ItemData.updateHero(hero)
    hero.lessTickEnd = hero.lessTick + os.time()
    hero.skillUpLessTickEnd = hero.skillUpLessTick + os.time()
    HeroData.ChooseingHero = hero
end

return HeroData