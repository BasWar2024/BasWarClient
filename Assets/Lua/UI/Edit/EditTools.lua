-- EditTools = EditTools or {}
local Cjson = require "cjson"
function GetBattleModel(builds, soliders, heros)

    -- for key, value in pairs(heros) do
    --     if value.cfgId == 5000001 then
    --         print("aaaaaaaaaaaaaaaaaaaaaa", value.cfgId, value.skill2, value.skillCfgId2)
    --         gg.printData(value)
    --     end
    -- end

    local allModel = {}
    -- allModel.skills = {}
    allModel.signinPosId = 3
    allModel.battleId = 7008355013870120977
    allModel.battleType = 2 
    allModel.bVersion = "1"
    allModel.battleInfo = {}

    allModel.battleInfo.builds = builds
    allModel.battleInfo.soliders = soliders
    allModel.battleInfo.heros = heros

    allModel.battleInfo.battleMapInfo = {
        sceneId = 1,
        length = 40000,
        width = 40000,
    }

    allModel.battleInfo.mainShip = {
        id = GetId(),
        cfgId = 4000001,
        model = "Spine_400000101",
        skillPoint = 11,
    }

    allModel.battleInfo.skills = {}
    allModel.battleInfo.heroSkills = {}
    allModel.battleInfo.buffs = {}
    allModel.battleInfo.traps = {}
    allModel.battleInfo.skillEffects = {}
    allModel.battleInfo.summonSoliders = {}

    allModel.operates = UnionUtil.getUnionBattleOperate(allModel.signinPosId)

    local skillMap = {}
    local skillEffectMap = {}
    local buffMap = {}
    local summonSoliderMap = {}

    for key, value in pairs(builds) do
        if value.atkSkillCfgId and value.atkSkillCfgId > 0 then
            local skill = SkillUtil.getSkillCfgMap()[value.atkSkillCfgId]
            if skill then
                local skillCfg = skill[1]
                ParseSkill(skillCfg, skillMap, skillEffectMap, buffMap, summonSoliderMap)
                value.atkSkillId = GetSkillId(skillCfg.cfgId, skillCfg.level)
            end
        end
    end

    local heroSkillMap = {}
    for key, value in pairs(heros) do
        local skill = SkillUtil.getSkillCfgMap()[value.atkSkillCfgId]
        if skill then
            local skillCfg = skill[1]
            ParseSkill(skillCfg, skillMap, skillEffectMap, buffMap, summonSoliderMap)
            value.atkSkillId = GetSkillId(skillCfg.cfgId, skillCfg.level)
        end

        for i = 1, 3, 1 do
            local skillCfgId = value["skillCfgId" .. i]
            local skillLevel = value["skillLevel" .. i]

            if skillCfgId and skillCfgId > 0 and skillLevel and skillLevel > 0 then
                local heroskill = SkillUtil.getSkillCfgMap()[skillCfgId]
                if heroskill then
                    local heroskillCfg = heroskill[skillLevel]
                    ParseSkill(heroskillCfg, heroSkillMap, skillEffectMap, buffMap, summonSoliderMap)
                    value["skill" .. i] = GetSkillId(heroskillCfg.cfgId, heroskillCfg.level)
                end
            end
        end
    end

    for key, value in pairs(soliders) do
        local skill = SkillUtil.getSkillCfgMap()[value.atkSkillCfgId]
        local skillCfg = skill[1]
        ParseSkill(skillCfg, skillMap, skillEffectMap, buffMap, summonSoliderMap)
        value.atkSkillId = GetSkillId(skillCfg.cfgId, skillCfg.level)
    end

    for key, value in pairs(heroSkillMap) do
        table.insert(allModel.battleInfo.heroSkills, GetSkill(value))
    end

    for key, value in pairs(skillMap) do
        table.insert(allModel.battleInfo.skills, GetSkill(value))
    end

    for key, value in pairs(skillEffectMap) do
        table.insert(allModel.battleInfo.skillEffects, GetSkillEffect(value))
    end

    for key, value in pairs(buffMap) do
        table.insert(allModel.battleInfo.buffs, GetBuff(value))
    end

    for key, value in pairs(summonSoliderMap) do
        table.insert(allModel.battleInfo.summonSoliders, GetSolider(value))
    end

    -- for key, value in pairs(allModel.battleInfo.heros) do
    --     if value.cfgId == 5000001 then
    --         print("qqqqqqqqqqqqqqqqqqqq", value.skill2)
    --         gg.printData(value)
    --     end
    -- end

    local jsonModel = Cjson.encode(allModel)

    return jsonModel
end

Id = 0
function GetId()
    Id = Id + 1
    return Id
end

function ParseSkill(skillCfg, skillMap, skillEffectMap, buffMap, summonSoliderMap)
    if not skillCfg then
        return
    end

    local id = GetSkillId(skillCfg.cfgId, skillCfg.level)
    if skillMap[id] then
        return
    end

    skillMap[id] = skillCfg
    if skillCfg.skillEffectCfgId then
        ParseSkillEffect(cfg.skillEffect[skillCfg.skillEffectCfgId], skillMap, skillEffectMap, buffMap, summonSoliderMap)
    end
end

function ParseSkillEffect(skillEffect, skillMap, skillEffectMap, buffMap, summonSoliderMap)
    if not skillEffect or skillEffectMap[skillEffect.cfgId] then
        return
    end

    skillEffectMap[skillEffect.cfgId] = skillEffect

    if skillEffect.skillEffectCfgId then
        ParseSkillEffect(cfg.skillEffect[skillEffect.skillEffectCfgId], skillMap, skillEffectMap, buffMap, summonSoliderMap)
    end

    if skillEffect.buffCfgId then
        ParseBuff(cfg.buff[skillEffect.buffCfgId], skillMap, skillEffectMap, buffMap, summonSoliderMap)
    end

    if skillEffect.skillCfgId then
        ParseSkill(SkillUtil.getSkillCfgMap()[skillEffect.skillCfgId][1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
    end

    if skillEffect.entityCfgId then
        if SoliderUtil.getSoliderCfgMap()[skillEffect.entityCfgId] then
            ParseSoldier(SoliderUtil.getSoliderCfgMap()[skillEffect.entityCfgId][1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
        end
    end
end

function ParseBuff(buff, skillMap, skillEffectMap, buffMap, summonSoliderMap)
    if buffMap[buff.cfgId] then
        return
    end
    buffMap[buff.cfgId] = buff

    if buff.skillEffectCfgId then
        ParseSkillEffect(cfg.skillEffect[buff.skillEffectCfgId], skillMap, skillEffectMap, buffMap, summonSoliderMap)
    end
end

function ParseSoldier(soldier, skillMap, skillEffectMap, buffMap, summonSoliderMap)
    if summonSoliderMap[soldier.cfgId] then
        return
    end
    summonSoliderMap[soldier.cfgId] = soldier
end

function GetSkillId(cfgId, level)
    if level == 1 then
        return cfgId
    end

    return cfgId * 100 + level
end

function GetSkill(skillCfg)
    if skillCfg == nil then
        return
    end
    local skill = {}
    skill.id = GetSkillId(skillCfg.cfgId, skillCfg.level)
    skill.cfgId = skillCfg.cfgId
    skill.icon = skillCfg.icon
    skill.type = skillCfg.type
    skill.skillType = skillCfg.skillType
    skill.targetGroup = skillCfg.targetGroup
    skill.skillEffectCfgId = skillCfg.skillEffectCfgId
    skill.originCost = skillCfg.originCost
    skill.addCost = skillCfg.addCost
    skill.skillCd = skillCfg.skillCd
    skill.useArea = skillCfg.useArea

    skill.intArg1 = skillCfg.intArg1
    skill.intArg2 = skillCfg.intArg2
    skill.intArg3 = skillCfg.intArg3
    skill.intArg4 = skillCfg.intArg4
    skill.intArg5 = skillCfg.intArg5
    skill.intArg6 = skillCfg.intArg6
    skill.intArg7 = skillCfg.intArg7
    skill.intArg8 = skillCfg.intArg8
    skill.intArg9 = skillCfg.intArg9
    skill.intArg10 = skillCfg.intArg10
    skill.intArg11 = skillCfg.intArg11
    skill.intArg12 = skillCfg.intArg12
    skill.intArg13 = skillCfg.intArg13
    skill.intArg14 = skillCfg.intArg14
    skill.intArg15 = skillCfg.intArg15

    skill.stringArg1 = skillCfg.stringArg1
    skill.stringArg2 = skillCfg.stringArg2
    skill.stringArg3 = skillCfg.stringArg3
    skill.stringArg4 = skillCfg.stringArg4
    skill.stringArg5 = skillCfg.stringArg5
    skill.stringArg6 = skillCfg.stringArg6
    skill.stringArg7 = skillCfg.stringArg7
    skill.stringArg8 = skillCfg.stringArg8
    skill.stringArg9 = skillCfg.stringArg9
    skill.stringArg10 = skillCfg.stringArg10

    return skill
end

function GetSkillEffect(skillEffectCfg)
    if not skillEffectCfg or not next(skillEffectCfg) then
        return
    end
    local skillEffect = {}
    skillEffect.cfgId = skillEffectCfg.cfgId
    skillEffect.type = skillEffectCfg.type
    skillEffect.args = skillEffectCfg.args
    skillEffect.rangeType = skillEffectCfg.rangeType
    skillEffect.range = skillEffectCfg.range
    skillEffect.skillEffectCfgId = skillEffectCfg.skillEffectCfgId
    skillEffect.buffCfgId = skillEffectCfg.buffCfgId
    skillEffect.entityCfgId = skillEffectCfg.entityCfgId
    skillEffect.skillCfgId = skillEffectCfg.skillCfgId
    return skillEffect
end

function GetBuff(buffcfg)
    if not buffcfg or not next(buffcfg) then
        return
    end
    local buff = {}
    buff.cfgId = buffcfg.cfgId
    buff.name = buffcfg.name
    buff.model = buffcfg.model 
    buff.lifeTime = buffcfg.lifeTime
    buff.frequency = buffcfg.frequency
    buff.skillEffectCfgId = buffcfg.skillEffectCfgId
    buff.skillCfgId = buffcfg.skillCfgId
    return buff
end

----------------------------------------------------------------------

function GetDefaultHero()
    return {
        cfgId = GetId(),
        model = "King_spine",
        icon = "",
        moveSpeed = 10000,
        maxHp = 3000,
        atk = 1000,
        atkSpeed = 1000,
        atkRange = 3000,
        radius = 1000,
        atkSkillCfgId = 8301001,
        atkSkillId = 0,
        center = "0,0,0",
        deadEffect = "",
        isDeminer = 0,
        atkReadyTime = 500,
        id = 100001 + GetId(),
        level = 1,
        atkSkillShowRadius = 0,
        isMedical = 0,
        inAtkRange = 0,
        deadSkillId = 0,
        bornSkillId = 0,
        aroundSkillId = 0,
        race = 0,
        index = 0,                -- ""
        atkSkillShowRad = 0,

        skillCfgId1 = 8201001,
        skillCfgId2 = 0,
        skillCfgId3 = 0,

        skillLevel1 = 1,
        skillLevel2 = 0,
        skillLevel3 = 0,

        skill1 = 0,
        skill2 = 0,
        skill3 = 0,
    }
end

function GetDefaultSoldier()
    return {
        cfgId = GetId(),
        model = "King_spine",
        icon = "",
        amount = 20,
        moveSpeed = 10000,
        maxHp = 3000,
        atk = 1000,
        atkSpeed = 1000,
        atkRange = 3000,
        radius = 1000,
        atkSkillCfgId = 8301001,
        atkSkillId = 0,
        type = 1,
        center = "0,0,0",
        deadEffect = "",
        isDeminer = 0,
        atkReadyTime = 500,
        id = GetId(),
        atkSkillShowRadius = 0,
        isMedical = 0,
        inAtkRange = 0,
        deadSkillId = 0,
        bornSkillId = 0,
        race = 0,
        index = 0,           -- ""
        atkSkillShowRad = 0,
    }
end

function GetDefaultBuilding()
    return {
        cfgId = 0,
        model = "Spine_603000501",
        explosionEffect = "",
        wreckageModel = "",
        x = 0,
        z = 0,
        maxHp = 5000,
        atk = 1000,
        atkSpeed = 1000,
        atkRange = 6000,
        radius = 1500,
        atkAir = 0,
        atkSkillCfgId = 8301001,
        atkSkillId = 0,
        isMain = 0,
        type = 3,
        subType = 1,
        center = "0,0,0",
        isConstruct = 0,
        direction = 0,
        atkReadyTime = 500,
        id = GetId(),
        atkSkillShowRadius = 0,
        inAtkRange = 0,
        hp = 5000,
        floor = "",
        deadSkillId = 0,
        bornSkillId = 0,
        race = 0,
        atkSkill1Id = 0,
        firstAtk = 0,
        intArgs1 = 0,
        intArgs2 = 0,
        intArgs3 = 0,
        atkSkillShowRad = 0,
    }
end

-- function GetSolider(soliderCfg)
--     if not soliderCfg then
--         return
--     end
--     local solider = {}
--     solider.id = GetId()
--     solider.cfgId = soliderCfg.cfgId
--     solider.model = soliderCfg.model
--     solider.icon = soliderCfg.icon
--     solider.amount = 0
--     solider.moveSpeed = soliderCfg.moveSpeed
--     solider.maxHp = soliderCfg.maxHp
--     solider.hp = solider.maxHp
--     solider.atk = soliderCfg.atk
--     solider.atkSpeed = soliderCfg.atkSpeed
--     solider.atkRange = soliderCfg.atkRange
--     solider.radius = soliderCfg.radius
--     solider.originCost = soliderCfg.originCost
--     solider.addCost = soliderCfg.addCost
--     solider.atkSkillId = soliderCfg.atkSkillCfgId
--     solider.flashMoveDelayTime = soliderCfg.flashMoveDelayTime
--     solider.type = soliderCfg.type
--     solider.center = soliderCfg.center
--     solider.deadEffect = soliderCfg.deadEffect
--     solider.isDeminer = soliderCfg.isDeminer
--     solider.atkReadyTime = soliderCfg.atkReadyTime
--     solider.atkSkillShowRadius = soliderCfg.atkSkillShowRadius
--     solider.isMedical = soliderCfg.isMedical
--     solider.inAtkRange = soliderCfg.inAtkRange
--     solider.deadSkillId = soliderCfg.deadSkillCfgId
--     solider.bornSkillId = soliderCfg.bornSkillCfgId
--     solider.race = soliderCfg.race
--     return solider
-- end

-- function GetHero(heroCfg)
--     local hero = {}
--     hero.id = heroCfg.id
--     hero.level = heroCfg.level
--     hero.cfgId = heroCfg.cfgId
--     hero.model = heroCfg.model
--     hero.icon = heroCfg.icon
--     hero.moveSpeed = heroCfg.moveSpeed
--     hero.maxHp = heroCfg.maxHp
--     hero.atk = heroCfg.atk
--     hero.atkSpeed = heroCfg.atkSpeed
--     hero.atkRange = heroCfg.atkRange
--     hero.radius = heroCfg.radius
--     hero.flashMoveDelayTime = heroCfg.flashMoveDelayTime
--     hero.atkSkillId = heroCfg.atkSkillCfgId
--     hero.center = heroCfg.center
--     hero.deadEffect = heroCfg.deadEffect
--     hero.isDeminer = heroCfg.isDeminer
--     hero.atkReadyTime = heroCfg.atkReadyTime
--     hero.atkSkillShowRadius = heroCfg.atkSkillShowRadius
--     hero.isMedical = heroCfg.isMedical
--     hero.inAtkRange = heroCfg.inAtkRange
--     return hero
-- end

-- return EditTools