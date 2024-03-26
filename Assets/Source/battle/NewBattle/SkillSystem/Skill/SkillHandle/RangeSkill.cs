
# if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    using System.Collections.Generic;
    public class RangeSkill : SkillBase
    {
        private enum RangeSkillArgs2Type
        {
            FollowOriginEntity = 1,
        }
        private enum Stage
        {
            Move = 0,
            Delay = 1,
            Do = 2,
        }

        private Stage m_Stage;
        private Fix64 m_TotalTime;
        private Fix64 m_RuningFrequencyTime;
        private Fix64 m_LifeTime;
        private Fix64 m_DelayDoTime;

        private Fix64 m_MoveTime;
        private FixVector3 m_Start2End;
        private List<EntityBase> m_EntityList;
        private bool m_IsOnlyEffectOrigin;
        private Fix64 m_EffectScale;
        private AtkAir m_AtkAir;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_Stage = Stage.Move;
            m_TotalTime = Fix64.Zero;
            m_LifeTime = Fix64.Zero;
            m_RuningFrequencyTime = IntArg3;
            m_IsOnlyEffectOrigin = IntArg4 == Fix64.Zero;
            m_DelayDoTime = IntArg10;
            m_AtkAir = (AtkAir)(int)IntArg11;
            if (IntArg7 != Fix64.Zero)
            {
                m_EffectScale = IntArg4;
            }
            else
            {
                m_EffectScale = Fix64.One / 2;
            }

            if (!m_IsOnlyEffectOrigin)
            {
                GroupType selfGroup = GroupType.PlayerGroup;
                if (originEntity != null)
                {
                    selfGroup = originEntity.Group;
                }

                m_EntityList = GameTools.GetTargetGroup(selfGroup, TargetGroup);
                m_Start2End = endPos - startPos;
                if (IntArg1 == Fix64.Zero)
                    IntArg1 = (Fix64)20;

                m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;
            }
            else
            {
                if (m_LifeTime == Fix64.Zero && m_DelayDoTime != Fix64.Zero)
                {
                    IntArg2 = m_DelayDoTime;
                }
            }

#if _CLIENTLOGIC_

            CreateFromPrefab(StringArg1, (obj) =>
            {
                var tail = Trans.Find("Tail");
                if (tail != null)
                {
                    tail.GetComponent<TrailRenderer>().Clear();
                }

                if ((RangeSkillArgs2Type)(int)IntArg8 == RangeSkillArgs2Type.FollowOriginEntity || m_IsOnlyEffectOrigin)
                {
                    obj.transform.localScale = Vector3.one * (float)m_EffectScale * 2;
                }

                if (IntArg9 != Fix64.Zero)
                {
                    TurnForward();
                }
            });

            if ((RangeSkillArgs2Type)(int)IntArg8 == RangeSkillArgs2Type.FollowOriginEntity)
            {
                NewGameData._EffectFactory.CreateEffect(StringArg2, OriginEntity.Fixv3LogicPosition, m_EffectScale, IntArg2);
            }
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();
            m_TotalTime += NewGameData._FixFrameLen;
            m_RuningFrequencyTime += NewGameData._FixFrameLen;

            if (!m_IsOnlyEffectOrigin)
            {
                if (m_Stage == Stage.Move)
                {
                    Move();
                }
                else if (m_Stage == Stage.Delay)
                {
                    if (m_TotalTime >= m_DelayDoTime)
                    {
                        m_Stage = Stage.Do;
                    }
                }
                else if (m_Stage == Stage.Do)
                {
                    m_LifeTime += NewGameData._FixFrameLen;
                    Do();
                }
            }
            else
            {
                m_LifeTime += NewGameData._FixFrameLen;

                if (m_TotalTime >= m_DelayDoTime)
                {
                    DoSkill();
                }
            }

            if (m_LifeTime > IntArg2)
            {
                NewGameData._EntityManager.BeKill(this);
            }
        }

        private void FollorOriginEntity()
        {
            Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition;
        }

        private void Move()
        {
            Fix64 t = Fix64.Min(m_TotalTime / m_MoveTime, Fix64.One);

            if ((RangeSkillArgs2Type)(int)IntArg8 == RangeSkillArgs2Type.FollowOriginEntity)
            {
                FollorOriginEntity();
            }
            else
            {
                Fixv3LogicPosition = StartPos + FixMath.MoveStraight(t, m_Start2End);
            }


            if (t >= Fix64.One)
            {
                m_Stage = Stage.Delay;
                m_RuningFrequencyTime = IntArg3;
                m_TotalTime = Fix64.Zero;

#if _CLIENTLOGIC_
                if ((RangeSkillArgs2Type)(int)IntArg8 != RangeSkillArgs2Type.FollowOriginEntity)
                    NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, m_EffectScale, IntArg2);
#endif
            }
        }

        private void Do()
        {
            if (m_RuningFrequencyTime >= IntArg3)
            {
                m_RuningFrequencyTime -= IntArg3;
                DoSkill();
            }
        }

        private void DoSkill()
        {
            if (m_IsOnlyEffectOrigin)
            {
                TriggerSkill(OriginEntity, OriginEntity);
            }
            else
            {
                foreach (var entity in m_EntityList)
                {
                    if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                        continue;

                    if (FixMath.CircularRegion(Fixv3LogicPosition, entity.Fixv3LogicPosition, IntArg4 + entity.Radius))
                    {
                        TriggerSkill(OriginEntity, entity);
                    }
                }
            }
        }

        public override void Release()
        {
            base.Release();
            m_EntityList = null;
        }

        //public void TriggerSkill(EntityBase entity)
        //{
        //    if (SkillEffectCfgId != 0)
        //    {
        //        NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, entity);
        //    }
        //}
    }
}
