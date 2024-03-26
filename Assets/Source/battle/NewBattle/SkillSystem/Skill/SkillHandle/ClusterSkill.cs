
# if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class ClusterSkill : SkillBase
    {
        internal enum ClusterStage
        {
            ClusterStage1 = 0,
            ClusterStage2 = 1
        }

        private Fix64 m_MoveTime;
        private Fix64 m_TotalTime;
        private FixVector3 m_TurnPos;
        private ClusterStage m_ClusterStage;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            if (IntArg4 > 0)
                m_ClusterStage = ClusterStage.ClusterStage1;
            else
                m_ClusterStage = ClusterStage.ClusterStage2;

            var turnPosY = IntArg3;
            var s2e = endPos - startPos;
            Fix64 distance = Fix64.Max((Fix64)0.1, FixVector3.Model(s2e));
            m_MoveTime = distance / IntArg1;

            var right = FixVector3.Cross(s2e, NewGameData._FixUp);
            var turnPosDir = FixVector3.Cross(right, s2e);
            turnPosDir.Normalize();
            m_TurnPos = StartPos + s2e / (Fix64)2 + turnPosDir * turnPosY;

            m_TotalTime = Fix64.Zero;

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_TotalTime += NewGameData._FixFrameLen;
            Fix64 t = Fix64.Min(m_TotalTime / m_MoveTime, Fix64.One);

            Fixv3LogicPosition = FixMath.BezierCurve2(t, StartPos, EndPos, m_TurnPos);
#if _CLIENTLOGIC_
            TurnForwardUpdate();
#endif
            if (m_ClusterStage == ClusterStage.ClusterStage1)
            {
                if (t >= (Fix64)0.5)
                {
#if _CLIENTLOGIC_
                    NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
#endif
                    for (int i = 0; i < (int)IntArg4; i++)
                    {
                        var startPos = Fixv3LogicPosition;
                        var endPos = EndPos;
                        endPos = endPos + GameTools.RandomTargetPos(IntArg2);
                        NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity,
                            startPos.x, startPos.y, startPos.z, endPos.x, endPos.y, endPos.z);
                    }

                    NewGameData._EntityManager.BeKill(this);
                }
            }
            else
            {
                if (t >= Fix64.One)
                {
#if _CLIENTLOGIC_
                    NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
#endif

                    NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity);
                    NewGameData._EntityManager.BeKill(this);
                }
            }
        }
    }
}
