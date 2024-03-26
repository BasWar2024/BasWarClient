
using System.Collections.Generic;

namespace Battle
{
    //""（""18""，""）
    public class RangeMoreTargetOneHurt18Skill : SkillBase
    {
        private Fix64 m_TotalTime;
        private Fix64 m_DelayHurtTime;
        private int m_Count;
        private int m_MaxCount;
        private bool m_IsDoSkill;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_TotalTime = Fix64.Zero;
            m_Count = 0;
            m_DelayHurtTime = Fix64.Zero;
            m_MaxCount = (int)IntArg2;
            m_IsDoSkill = false;

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });
            Fix64 time = IntArg3 == Fix64.Zero ? m_MaxCount * NewGameData._FixFrameLen : IntArg3 * m_MaxCount;
            NewGameData._EffectFactory.CreateEffect(StringArg3, EndPos, IntArg4, time + 1.5);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (OriginEntity == null || OriginEntity.BKilled)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;
            m_DelayHurtTime += NewGameData._FixFrameLen;

            if (m_TotalTime >= IntArg3)
            {
                m_TotalTime -= IntArg3;

                DoUpthrowStraightSkill();
                m_Count++;
            }

            if (!m_IsDoSkill && m_DelayHurtTime >= IntArg5)
            {
                DoSkill();
            }

            if (m_Count >= m_MaxCount)
            {
                NewGameData._EntityManager.BeKill(this);
            }
        }

        private void DoUpthrowStraightSkill()
        {
            var pos = EndPos + (IntArg4 == Fix64.Zero ? FixVector3.Zero : GameTools.RandomTargetPos(IntArg4));
            StartPos = OriginEntity.Fixv3LogicPosition + OriginEntity.Center +
                OriginEntity.AtkSkillShowRadius * FixMath.Vector3Rotate(NewGameData._FixForword, OriginEntity.AngleY);

            SkillModel skillModel = Create18SkillModel();
            NewGameData._SkillFactory.CreateSkill(StartPos, pos, OriginEntity, TargetEntity, skillModel);
            NewGameData._PoolManager.Push(skillModel);
        }

        private void DoSkill()
        {
            m_IsDoSkill = true;
            if (SkillEffectCfgId != 0)
            {
                var entityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);
                foreach (var entity in entityList)
                {
                    if (!GameTools.RangeSkillAirDefenseDetected(entity, AtkAir.AtkLand))
                        continue;

                    if (FixMath.CircularRegion(EndPos, entity.Fixv3LogicPosition, IntArg4 + entity.Radius))
                    {
                        NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, entity);
                    }
                }
            }
        }

        //""18""model
        private SkillModel Create18SkillModel()
        {
            var skillModel = NewGameData._PoolManager.Pop<SkillModel>();
            skillModel.id = -999918;
            skillModel.cfgId = -999918;
            skillModel.type = 18;
            skillModel.skillType = 1;
            skillModel.targetGroup = 2;
            skillModel.skillEffectCfgId = 0;
            skillModel.skillAnimTime = 0;

            skillModel.intArg1 = (int)(IntArg1 * 1000);
            skillModel.intArg2 = 0;
            skillModel.intArg3 = 0;
            skillModel.intArg4 = 300;

            skillModel.stringArg1 = StringArg1;
            skillModel.stringArg2 = StringArg2;

            return skillModel;
        }
    }
}
