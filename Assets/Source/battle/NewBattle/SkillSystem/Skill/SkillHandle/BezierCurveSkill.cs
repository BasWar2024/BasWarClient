

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class BezierCurveSkill : SkillBase
    {
        private Fix64 m_MoveTime;
        private Fix64 m_TotalTime;
        private FixVector3 m_TurnPos;
        private FixVector3 m_Start2End;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_TotalTime = Fix64.Zero;
            var turnPosY = IntArg2;
            m_Start2End = endPos - startPos;
            Fix64 distance = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End));
            m_MoveTime = distance / IntArg1;

            var right = FixVector3.Cross(m_Start2End, NewGameData._FixUp);
            var turnPosDir = FixVector3.Cross(right, m_Start2End);
            turnPosDir.Normalize();
            m_TurnPos = StartPos + m_Start2End / (Fix64)2 + turnPosDir * turnPosY;

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_TotalTime += NewGameData._FixFrameLen;
            Fix64 t = Fix64.Min(m_TotalTime / m_MoveTime, Fix64.One);


            if (TargetEntity != null && TargetEntity.ObjType == ObjectType.Soldier && EndPos != TargetEntity.Fixv3LogicPosition)
            {
                EndPos = TargetEntity.Fixv3LogicPosition + TargetEntity.Center;
                m_Start2End = EndPos - StartPos;
                m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;
            }

            Fixv3LogicPosition = FixMath.BezierCurve2(t, StartPos, EndPos, m_TurnPos);

#if _CLIENTLOGIC_
            if (Trans != null)
                CurrRotation = Quaternion.LookRotation((Fixv3LogicPosition - Fixv3LastPosition).ToVector3(), Trans.up);
#endif
            if (t >= Fix64.One)
            {
#if _CLIENTLOGIC_
                NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
#endif

                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity);
                NewGameData._EntityManager.BeKill(this);
            }
        }

        public override void Release()
        {
            base.Release();
        }
    }
}
