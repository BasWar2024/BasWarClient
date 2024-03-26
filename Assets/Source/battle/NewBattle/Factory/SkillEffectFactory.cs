
namespace Battle
{
    public class SkillEffectFactory
    {
        public SkillEffectBase CreateSkillEffect(int effectId, Buff buff, EntityBase originEntity,
            EntityBase targetEntity, params Fix64[] args)
        {
            if (effectId == 0)
                return null;
            
            SkillEffectModel model = NewGameData._SkillEffectModelDict[effectId];
            SkillEffectBase skillEffect = GetSkillEffect(model);
            skillEffect.Init(model, originEntity, targetEntity, buff, args);
            SetAttr(skillEffect, model);
            skillEffect.Start();
            skillEffect.DoNextSkillEffect();
            if (buff == null)
                skillEffect.Leave();
            return skillEffect;
        }

        private void SetAttr(SkillEffectBase skillEffect, SkillEffectModel model)
        {
            skillEffect.CfgId = model.cfgId;
            skillEffect.Type = model.type;
            var skillEffectJarray = SimpleJson.SimpleJson.DeserializeObject<SimpleJson.JsonArray>(model.args);
            foreach (var value in skillEffectJarray)
            {
                skillEffect.Args.Add((Fix64)int.Parse(value.ToString()));
            }

            skillEffect.RangeType = model.rangeType;
            skillEffect.Range = (Fix64)model.range / 1000;
            skillEffect.BuffCfgId = model.buffCfgId;
            skillEffect.SkillEffectCfgId = model.skillEffectCfgId;
            skillEffect.entityCfgId = model.entityCfgId;
            skillEffect.skillCfgId = model.skillCfgId;
        }

        private SkillEffectBase GetSkillEffect(SkillEffectModel model)
        {
            SkillEffectBase skillEffect;
            switch ((SkillEffectType)model.type)
            {
                case SkillEffectType.Atk_10001:
                    skillEffect = NewGameData._PoolManager.Pop<DamageSkillEffect_10001>();
                    break;

                case SkillEffectType.Atk_10002:
                    skillEffect = NewGameData._PoolManager.Pop<DamageSkillEffect_10002>();
                    break;

                case SkillEffectType.Atk_10003:
                    skillEffect = NewGameData._PoolManager.Pop<DamageSkillEffect_10003>();
                    break;

                case SkillEffectType.PercentageDamage_10004:
                    skillEffect = NewGameData._PoolManager.Pop<PercentageDamageSkillEffect_10004>();
                    break;

                case SkillEffectType.BurnSkillEffect_10005:
                    skillEffect = NewGameData._PoolManager.Pop<BurnSkillEffect_10005>();
                    break;

                case SkillEffectType.Bloodthirsty_10006:
                    skillEffect = NewGameData._PoolManager.Pop<BloodthirstySkillEffect_10006>();
                    break;

                case SkillEffectType.Atk_10007:
                    skillEffect = NewGameData._PoolManager.Pop<DamageSkillEffect_10007>();
                    break;

                case SkillEffectType.BurnSkillEffect_10008:
                    skillEffect = NewGameData._PoolManager.Pop<BurnSkillEffect_10008>();
                    break;

                case SkillEffectType.Heal_15000:
                    skillEffect = NewGameData._PoolManager.Pop<HealSkillEffect_15000>();
                    break;

                case SkillEffectType.HealBuff_15001:
                    skillEffect = NewGameData._PoolManager.Pop<HealBuffSkillEffect_15001>();
                    break;

                case SkillEffectType.AtkSpeed_20000:
                    skillEffect = NewGameData._PoolManager.Pop<AtkSpeedSkillEffect_20000>();
                    break;
                case SkillEffectType.MinusAtkSpeed_20003:
                    skillEffect = NewGameData._PoolManager.Pop<MinusAtkSpeedSkillEffect_20003>();
                    break;

                //case SkillEffectType.AtkSpeedAndMoveSpeed_20001:
                //    skillEffect = NewGameData._PoolManager.Pop<AtkSpeedAndMoveSpeedSkillEffect_20001>();
                //    break;

                case SkillEffectType.AtkSpeedTimes_20002:
                    skillEffect = NewGameData._PoolManager.Pop<AtkSpeedTimesSkillEffect_20002>();
                    break;

                case SkillEffectType.MoveSpeed_21000:
                    skillEffect = NewGameData._PoolManager.Pop<MoveSpeedSkillEffect_21000>();
                    break;

                case SkillEffectType.MinusMoveSpeed_21001:
                    skillEffect = NewGameData._PoolManager.Pop<MinusMoveSpeedSkillEffect_21001>();
                    break;

                case SkillEffectType.AddAtk_22000:
                    skillEffect = NewGameData._PoolManager.Pop<AddAtkEffectSkillEffect_22000>();
                    break;

                case SkillEffectType.MinusAtk_22003:
                    skillEffect = NewGameData._PoolManager.Pop<MinusAtkSkillEffect_22003>();
                    break;

                case SkillEffectType.AtkAddAtk_22004:
                    skillEffect = NewGameData._PoolManager.Pop<AtkAddAtk_22004>();
                    break;

                //case SkillEffectType.AddAtkAndAtkSpeed_22001:
                //    skillEffect = NewGameData._PoolManager.Pop<AddAtkAndAtkSpeedSkillEffect_22001>();
                //    break;

                //case SkillEffectType.AddAtkAndMoveSpeed_22002:
                //    skillEffect = NewGameData._PoolManager.Pop<AddAtkAndMoveSpeedSkillEffect_22002>();
                //    break;

                case SkillEffectType.Summon_23000:
                    skillEffect = NewGameData._PoolManager.Pop<SummonSkillEffect_23000>();
                    break;

                case SkillEffectType.Shield_24000:
                    skillEffect = NewGameData._PoolManager.Pop<ShieldEffectSkillEffect_24000>();
                    break;

                case SkillEffectType.Cloak_24002:
                    skillEffect = NewGameData._PoolManager.Pop<CloakSkillEffect_24002>();
                    break;

                case SkillEffectType.MaxHp_24003:
                    skillEffect = NewGameData._PoolManager.Pop<AddMaxHpSkillEffect_24003>();
                    break;

                case SkillEffectType.StrengthenAtk_24004:
                    skillEffect = NewGameData._PoolManager.Pop<StrengthenAtkSkillEfect_24004>();
                    break;

                case SkillEffectType.StrengthenGetHurt_24005:
                    skillEffect = NewGameData._PoolManager.Pop<StrengthGetHurtSkillEffect_24005>();
                    break;

                case SkillEffectType.StopAction_24006:
                    skillEffect = NewGameData._PoolManager.Pop<StopActionSkillEffect_24006>();
                    break;

                //case SkillEffectType.SmokeCloak_24007:
                //    skillEffect = NewGameData._PoolManager.Pop<SmokeCloakSkillEffect_24007>();
                //    break;

                case SkillEffectType.Invincible_24008:
                    skillEffect = NewGameData._PoolManager.Pop<InvincibleSkillEffect_24008>();
                    break;

                //case SkillEffectType.StopAction_Cloak_24009:
                //    skillEffect = NewGameData._PoolManager.Pop<StopAction_CloakSkillEffect_24009>();
                //    break;

                case SkillEffectType.Sneer_24010:
                    skillEffect = NewGameData._PoolManager.Pop<SneerSkillEffect_24010>();
                    break;

                case SkillEffectType.BreakAtkcd_24011:
                    skillEffect = NewGameData._PoolManager.Pop<BreakAtkcd_24011>();
                    break;

                case SkillEffectType.ShieldMaxHp_24012:
                    skillEffect = NewGameData._PoolManager.Pop<ShieldMaxHpEffectSkillEffect_24012>();
                    break;

                case SkillEffectType.CreateBuff_25000:
                    skillEffect = NewGameData._PoolManager.Pop<CreateBuffSkillEffect_25000>();
                    break;

                case SkillEffectType.CreateSkill_25001:
                    skillEffect = NewGameData._PoolManager.Pop<CreateSkillSkillEffect_25001>();
                    break;

                case SkillEffectType.ChangeAtkSkillId_25002:
                    skillEffect = NewGameData._PoolManager.Pop<ChangeAtkSkillId_25002>();
                    break;

                case SkillEffectType.AroundAttr_25003:
                    skillEffect = NewGameData._PoolManager.Pop<PassiveSkillAttrSkillEffect_25003>();
                    break;

                case SkillEffectType.ReBuild_24013:
                    skillEffect = NewGameData._PoolManager.Pop<RebuildSkillEffect_24013>();
                    break;

                case SkillEffectType.BounceAtk_24014:
                    skillEffect = NewGameData._PoolManager.Pop<BounceAtkSkillEffect_24014>();
                    break;

                case SkillEffectType.LowHpAction_24015:
                    skillEffect = NewGameData._PoolManager.Pop<LowHpActionSkillEffect_24015>();
                    break;

                default:
                    skillEffect = NewGameData._PoolManager.Pop<SkillEffectBase>();
                    break;
            }

            return skillEffect;
        }
    }
}
