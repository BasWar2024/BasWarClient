# if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class SkillFactory
    {
        public SkillBase CreateSkill(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity,
            EntityBase targetEntity, SkillModel model)
        {

            SkillBase skill;
            switch ((SkillType)model.type)
            {
                case SkillType.RangeSkill:
                    skill = NewGameData._PoolManager.Pop<RangeSkill>();
                    break;
                case SkillType.SignalBombSkill:
                    skill = NewGameData._PoolManager.Pop<SignalBombSkill>();
                    break;
                case SkillType.SummonSkill:
                    skill = NewGameData._PoolManager.Pop<SummonSkill>();
                    break;
                case SkillType.BounceChainSkill:
                    if (NewGameData._SignalBomb != null && originEntity.LockedAttackEntity == NewGameData._SignalBomb.Entity)
                        return null;
 
                    skill = NewGameData._PoolManager.Pop<BounceChainSkill>();
                    break;
                case SkillType.PointLocationRangeSkill:
                    skill = NewGameData._PoolManager.Pop<PointLocationRangeSkill>();
                    break;
                case SkillType.SummonAirSoliderSkill:
                    skill = NewGameData._PoolManager.Pop<SummonAirSoliderSkill>();
                    break;
                case SkillType.StraightAtkSkill:
                    skill = NewGameData._PoolManager.Pop<StraightAtkSkill>();
                    break;

                case SkillType.RectangleRangeAtkSkill:
                    skill = NewGameData._PoolManager.Pop<RectangleRangeAtkSkill>();
                    break;
                case SkillType.FireRainSkill:
                    skill = NewGameData._PoolManager.Pop<FireRainSkill>();
                    break;
                case SkillType.Inhalation:
                    skill = NewGameData._PoolManager.Pop<InhalationSkill>();
                    break;
                case SkillType.BezierCurveSkill:
                    skill = NewGameData._PoolManager.Pop<BezierCurveSkill>();
                    break;
                case SkillType.Laser:
                    skill = NewGameData._PoolManager.Pop<LaserSkill>();
                    break;
                case SkillType.Cluster:
                    skill = NewGameData._PoolManager.Pop<ClusterSkill>();
                    break;
                case SkillType.AbsorbSkill:
                    skill = NewGameData._PoolManager.Pop<AbsorbSkill>();
                    break;
                case SkillType.SectorShootSkill:
                    skill = NewGameData._PoolManager.Pop<SectorShootSkill>();
                    break;
                case SkillType.LaserStrafeSkill:
                    skill = NewGameData._PoolManager.Pop<LaserStrafeSkill>();
                    break;
                case SkillType.ChargeSkill:
                    skill = NewGameData._PoolManager.Pop<ChargeSkill>();
                    break;
                case SkillType.UpthrowStraightSkill:
                    skill = NewGameData._PoolManager.Pop<UpthrowStraightSkill>();
                    break;

                case SkillType.RangeMoreTargetSkill:
                    skill = NewGameData._PoolManager.Pop<RangeMoreTargetSkill>();
                    break;

                case SkillType.SkillEmitterSkill:
                    skill = NewGameData._PoolManager.Pop<SkillEmitterSkill>();
                    break;

                case SkillType.SectorSkill:
                    skill = NewGameData._PoolManager.Pop<SectorSkill>();
                    break;

                case SkillType.RangeMoreTargetOneHurt18Skill:
                    skill = NewGameData._PoolManager.Pop<RangeMoreTargetOneHurt18Skill>();
                    break;

                case SkillType.TornadoSkill:
                    skill = NewGameData._PoolManager.Pop<TornadoSkill>();
                    break;

                case SkillType.ShieldStabSkill:
                    skill = NewGameData._PoolManager.Pop<ShieldStabSkill>();
                    break;

                case SkillType.ThundercloundSkill:
                    skill = NewGameData._PoolManager.Pop<ThundercloundSkill>();
                    break;

                case SkillType.ReBuildSkill:
                    skill = NewGameData._PoolManager.Pop<ReBuildSkill>();
                    break;

                default:
                    skill = NewGameData._PoolManager.Pop<SkillBase>();
                    break;
            }

            skill.Init();
            SetAttr(skill, model);
            skill.Fixv3LogicPosition = startPos;
            skill.Start(startPos, endPos, originEntity, targetEntity);

            NewGameData._SkillList.Add(skill);

            return skill;
        }

        private void SetAttr(SkillBase skill, SkillModel model)
        {
            skill.Id = model.id;
            skill.CfgId = model.cfgId;
            skill.Icon = model.icon;
            skill.Type = model.type;
            skill.SkillType = model.skillType;
            skill.TargetGroup = (TargetGroup)model.targetGroup;
            skill.SkillEffectCfgId = model.skillEffectCfgId;
            skill.OriginCost = (Fix64)model.originCost;
            skill.AddCost = (Fix64)model.addCost;
            skill.SkillCd = (Fix64)model.skillCd / 1000;
            skill.UseArea = (AreaType)model.useArea;
            skill.Level = model.level;
            skill.Quality = model.quality;
            skill.ReleaseDistance = (Fix64)model.releaseDistance / 1000;
            skill.SkillAnimTime = (Fix64)model.skillAnimTime / 1000;
            skill.SkillDelayTime = (Fix64)model.skillDelayTime / 1000;

            skill.IntArg1 = (Fix64)model.intArg1 / 1000;
            skill.IntArg2 = (Fix64)model.intArg2 / 1000;
            skill.IntArg3 = (Fix64)model.intArg3 / 1000;
            skill.IntArg4 = (Fix64)model.intArg4 / 1000;
            skill.IntArg5 = (Fix64)model.intArg5 / 1000;
            skill.IntArg6 = (Fix64)model.intArg6 / 1000;
            skill.IntArg7 = (Fix64)model.intArg7 / 1000;
            skill.IntArg8 = (Fix64)model.intArg8 / 1000;
            skill.IntArg9 = (Fix64)model.intArg9 / 1000;
            skill.IntArg10 = (Fix64)model.intArg10 / 1000;
            skill.IntArg11 = (Fix64)model.intArg11 / 1000;
            skill.IntArg12 = (Fix64)model.intArg12 / 1000;
            skill.IntArg13 = (Fix64)model.intArg13 / 1000;
            skill.IntArg14 = (Fix64)model.intArg14 / 1000;
            skill.IntArg15 = (Fix64)model.intArg15 / 1000;

            skill.StringArg1 = model.stringArg1;
            skill.StringArg2 = model.stringArg2;
            skill.StringArg3 = model.stringArg3;
            skill.StringArg4 = model.stringArg4;
            skill.StringArg5 = model.stringArg5;
            skill.StringArg6 = model.stringArg6;
            skill.StringArg7 = model.stringArg7;
            skill.StringArg8 = model.stringArg8;
            skill.StringArg9 = model.stringArg9;
            skill.StringArg10 = model.stringArg10;
        }
    }
}