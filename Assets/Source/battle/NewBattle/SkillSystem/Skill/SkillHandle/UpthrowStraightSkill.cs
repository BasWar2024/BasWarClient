



namespace Battle
{
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class UpthrowStraightSkill : SkillBase
    {
        private enum Stage
        {
            Move = 0,
            Wait = 1,
        }

        private FixVector3 m_UpthrowTurnPos;
        private FixVector3 m_UpthrowTurnPos1;
        private FixVector3 m_Forword;
        private Fix64 m_TotalTime;
        private Fix64 m_MoveTime;
        private Fix64 m_Range;
        private List<EntityBase> m_EntityList;
        private AtkAir m_AtkAir;
        private Stage m_Stage;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_TotalTime = Fix64.Zero;
            m_Forword = new FixVector3(endPos.x, Fix64.Zero, endPos.z) - new FixVector3(startPos.x, Fix64.Zero, startPos.z);
            var length = FixVector3.Model(m_Forword);
            var p1high = length * 0.7;
            var p2high = p1high / 4;
            var p2length = length / 2;
            m_UpthrowTurnPos = startPos + NewGameData._FixUp * p1high;
            m_UpthrowTurnPos1 = startPos + NewGameData._FixUp * p2high + m_Forword.GetNormalized() * p2length;
            m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(endPos - startPos)) / IntArg1;
            m_Range = IntArg2;
            m_AtkAir = (AtkAir)(int)IntArg3;
            m_Stage = Stage.Move;
            EndPos = targetEntity.Fixv3LogicPosition;

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, (obj) =>
            {
                Trans.forward = Vector3.up;
            });
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_TotalTime += NewGameData._FixFrameLen;

            if (m_Stage == Stage.Move)
            {
                Fix64 timeScale = m_TotalTime / m_MoveTime;

                if (timeScale >= Fix64.One)
                {
                    Fixv3LogicPosition = TargetEntity == null ? EndPos : TargetEntity.Fixv3LogicPosition + TargetEntity.Center;

                    if (m_Range > 0)
                    {
                        m_EntityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);
                        foreach (var entity in m_EntityList)
                        {
                            if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                                continue;

                            if (FixMath.CircularRegion(Fixv3LogicPosition, entity.Fixv3LogicPosition + entity.Center, m_Range + entity.Radius))
                            {
                                TriggerSkill(OriginEntity, entity);
                            }
                        }
                    }
                    else
                    {
                        TriggerSkill(OriginEntity, TargetEntity);
                    }
#if _CLIENTLOGIC_
                    NewGameData._EffectFactory.CreateEffect(StringArg2, Fixv3LogicPosition, Fix64.Zero, Fix64.Zero);
#endif
                    m_Stage = Stage.Wait;
                    m_TotalTime = Fix64.Zero;

                    return;
                }

                if (TargetEntity != null)
                {
                    Fixv3LogicPosition = FixMath.BezierCurve3(timeScale, StartPos, TargetEntity.Fixv3LogicPosition + TargetEntity.Center, m_UpthrowTurnPos, m_UpthrowTurnPos1);
                }
                else
                {
                    Fixv3LogicPosition = FixMath.BezierCurve3(timeScale, StartPos, EndPos, m_UpthrowTurnPos, m_UpthrowTurnPos1);
                }

#if _CLIENTLOGIC_
                if (Trans != null)
                {
                    TurnForward();
                }
#endif
            }
            else
            {
                if (m_TotalTime >= IntArg4)
                {
                    NewGameData._EntityManager.BeKill(this);
                }
            }
        }

#if _CLIENTLOGIC_
        protected override void TurnForward()
        {
            var origin2Targer = (Fixv3LogicPosition - Fixv3LastPosition).ToVector3();
            Trans.forward = origin2Targer;
        }

#endif
        public override void Release()
        {
            base.Release();

            m_EntityList = null;
        }
    }
}
