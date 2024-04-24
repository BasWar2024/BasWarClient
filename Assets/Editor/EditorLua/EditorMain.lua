
print("EditerMainLua=============================")


gg = gg or {}
require(".Lua.gg.base.util.functions")
require(".Lua.scene.util.SkillUtil")
require(".Lua.scene.util.SoliderUtil")

ResMgr = CS.GG.ResMgr.instance
EditModelData = CS.EditModel.EditModelData
Cjson = require "cjson"
require(".Editor.EditorLua.Cfg")

-- gg.printData(CFG.hero)
-- print("11111111111111111111111111111111")
-- gg.printData(Cjson.encode(CFG.hero))

MODEL_TYPE_HERO = 0
MODEL_TYPE_SOLDIER = 1
MODEL_TYPE_TANK = 2
MODEL_TYPE_BUILD = 3
MODEL_TYPE_DEF_BUILD = 4
MODEL_TYPE_WARSHIP = 5

MODEL_TYPE_OTHER_MODEL = 10
MODEL_TYPE_SKILL = 20

function Awake()
    print("lua Awake")

    for key, value in pairs(cfg.hero) do
        local battleCfg = cfg.heroBattle[value.heroBattleCfgId]
        EditModelData.SetSubCfg(MODEL_TYPE_HERO, Cjson.encode(value), Cjson.encode(battleCfg))
    end

    for key, value in pairs(cfg.solider) do
        local battleCfg = cfg.soliderBattle[value.soliderBattleCfgId]
        if battleCfg.type == 4 then
            EditModelData.SetSubCfg(MODEL_TYPE_TANK, Cjson.encode(value), Cjson.encode(battleCfg))
        else
            EditModelData.SetSubCfg(MODEL_TYPE_SOLDIER, Cjson.encode(value), Cjson.encode(battleCfg))
        end
    end

    for key, value in pairs(cfg.build) do
        local battleCfg = cfg.buildBattle[value.buildBattleCfgId]
        if battleCfg then
            if battleCfg.type == 3 then
                EditModelData.SetSubCfg(MODEL_TYPE_DEF_BUILD, Cjson.encode(value), Cjson.encode(battleCfg))
            else
                EditModelData.SetSubCfg(MODEL_TYPE_BUILD, Cjson.encode(value), Cjson.encode(battleCfg))
            end
        end
    end

    for key, value in pairs(cfg.warShip) do
        local battleCfg = cfg.warShipBattle[value.warShipBattleCfgId]
        EditModelData.SetSubCfg(MODEL_TYPE_WARSHIP, Cjson.encode(value), Cjson.encode(battleCfg))
    end

    for key, value in pairs(cfg.modelInfo) do
        local battleCfg = value
        EditModelData.SetSubCfg(MODEL_TYPE_OTHER_MODEL, Cjson.encode(value), Cjson.encode(battleCfg))
    end

    for key, value in pairs(cfg.skill) do
        local battleCfg = cfg.skillBattle[value.skillBattleCfgId]
        EditModelData.SetSubCfg(MODEL_TYPE_SKILL, Cjson.encode(value), Cjson.encode(battleCfg))
    end

    local buffMap = {}
    local buffList = {[1] = "none"}

    for key, value in pairs(cfg.buff) do
        if value.model and value.model ~= "" then
            buffMap[value.model] = value.model
        end
    end

    for key, value in pairs(buffMap) do
        table.insert(buffList, value)
        EditModelData.SetBuff(buffList)
    end

    GetBattleModel()
end

function GetBattleModel()
    local allModel = {}
    -- allModel.skills = {}

    allModel.builds = {}
    allModel.soliders = {}
    allModel.mainShip = {}
    allModel.skills = {}
    allModel.heroSkill = {}
    allModel.buffs = {}
    allModel.traps = {}
    allModel.skillEffects = {}
    allModel.summonSoliders = {}

    allModel.battleMapInfo = {sceneId = 1, length = 1000, width = 1000}

    local skillMap = {}
    local skillEffectMap = {}
    local buffMap = {}
    local summonSoliderMap = {}

    local soliderMap = {}

    for key, value in pairs(cfg.solider) do
        if value.atkSkillCfgId then
            local skill = SkillUtil.getSkillCfgMap()[value.atkSkillCfgId]
            if skill then
                ParseSkill(skill[1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
            end
        end

        if not soliderMap[value.cfgId] then
            soliderMap[value.cfgId] = value
        end
    end

    for key, value in pairs(cfg.hero) do
        if value.atkSkillCfgId then
            local atkSkill = SkillUtil.getSkillCfgMap()[value.atkSkillCfgId]
            if atkSkill then
                ParseSkill(atkSkill[1], skillMap, skillEffectMap, buffMap, summonSoliderMap)

                for index, value in ipairs(value.initSkill) do
                    local skill = SkillUtil.getSkillCfgMap()[value]
                    if skill then
                        ParseSkill(skill[1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
                    end
                end
                -- initSkill

                -- for i = 1, 3 do
                --     for _, skillId in pairs(value["skill" .. i]) do
                --         local skill = SkillUtil.getSkillCfgMap()[skillId]
                --         if skill then
                --             ParseSkill(skill[1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
                --         end
                --     end
                -- end

            end
        end
    end

    for key, value in pairs(cfg.build) do
        if value.atkSkillCfgId then
            local skill = SkillUtil.getSkillCfgMap()[value.atkSkillCfgId]
            if skill then
                ParseSkill(skill[1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
            end
        end
    end

    for key, value in pairs(cfg.warShip) do
        for i = 1, 5 do
            for _, skillId in pairs(value["skill" .. i]) do
                local skill = SkillUtil.getSkillCfgMap()[skillId]
                if skill then
                    ParseSkill(skill[1], skillMap, skillEffectMap, buffMap, summonSoliderMap)
                end
            end
        end
    end

    for key, value in pairs(skillMap) do
        table.insert(allModel.skills, GetSkill(value))
    end

    for key, value in pairs(skillEffectMap) do
        table.insert(allModel.skillEffects, GetSkillEffect(value))
    end

    for key, value in pairs(buffMap) do
        table.insert(allModel.buffs, GetBuff(value))
    end

    for key, value in pairs(summonSoliderMap) do
        table.insert(allModel.summonSoliders, GetSolider(value))
    end

    for key, value in pairs(soliderMap) do
        table.insert(allModel.soliders, GetSolider(value))
    end

    local jsonModel = Cjson.encode(allModel)

    -- print("GetBattleModel====================")
    -- gg.printData(jsonModel)
    EditModelData.LoadData(jsonModel)
end

function Start()
    -- print("luaStart")
end

function Update()
    -- print("luaUpdate")
end

Id = 0
function GetId()
    Id = Id + 1
    return Id
end

function ParseSkill(skillCfg, skillMap, skillEffectMap, buffMap, summonSoliderMap)
    if skillMap[skillCfg.cfgId] then
        return
    end

    skillMap[skillCfg.cfgId] = skillCfg
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

function GetSkill(skillCfg)
    if skillCfg == nil then
        return
    end
    local skill = {}
    skill.id = GetId()
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

function GetSolider(soliderCfg)
    if not soliderCfg then
        return
    end
    local solider = {}
    solider.id = GetId()
    solider.cfgId = soliderCfg.cfgId
    solider.model = soliderCfg.model
    solider.icon = soliderCfg.icon
    solider.amount = 0
    solider.moveSpeed = soliderCfg.moveSpeed
    solider.maxHp = soliderCfg.maxHp
    solider.hp = solider.maxHp
    solider.atk = soliderCfg.atk
    solider.atkSpeed = soliderCfg.atkSpeed
    solider.atkRange = soliderCfg.atkRange
    solider.radius = soliderCfg.radius
    solider.originCost = soliderCfg.originCost
    solider.addCost = soliderCfg.addCost
    solider.atkSkillId = soliderCfg.atkSkillCfgId
    solider.flashMoveDelayTime = soliderCfg.flashMoveDelayTime
    solider.type = soliderCfg.type
    solider.center = soliderCfg.center
    solider.deadEffect = soliderCfg.deadEffect
    solider.isDeminer = soliderCfg.isDeminer
    solider.atkReadyTime = soliderCfg.atkReadyTime
    solider.atkSkillShowRadius = soliderCfg.atkSkillShowRadius
    solider.isMedical = soliderCfg.isMedical
    solider.inAtkRange = soliderCfg.inAtkRange
    solider.deadSkillId = soliderCfg.deadSkillCfgId
    solider.bornSkillId = soliderCfg.bornSkillCfgId
    solider.race = soliderCfg.race
    return solider
end
