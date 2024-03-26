

using System;
#if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class ChargeSkill : SkillBase
    {
        private Fix64 m_ChargeTime;
        private FixVector3 m_S2e;
        private Fix64 m_TotalTime;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_TotalTime = Fix64.Zero;
            var range = originEntity.AtkRange + targetEntity.Radius;

            if (FixVector3.SqrMagnitude(originEntity.Fixv3LogicPosition - targetEntity.Fixv3LogicPosition) <= Fix64.Square(range))
            {
                DoSkill();
                return;
            }

            var e2s = startPos - endPos;
            e2s.Normalize();
            var chargeEndPos = endPos + e2s * range;
            m_S2e = chargeEndPos - StartPos;
            m_ChargeTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_S2e) / IntArg1);
            OriginEntity.Fsm.ChangeFsmState<EntityStopActionFsm>();

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();
            m_TotalTime += NewGameData._FixFrameLen;
            Fix64 t = m_TotalTime / m_ChargeTime;

            OriginEntity.Fixv3LogicPosition = StartPos + FixMath.MoveStraight(t, m_S2e);
            Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition;

            if (t >= Fix64.One)
            {
                DoSkill();
            }
        }

        private void DoSkill()
        {
            TriggerSkill(OriginEntity, TargetEntity);

#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect(StringArg2, Fixv3LogicPosition, Fix64.Zero, Fix64.Zero);
#endif
            OriginEntity.Fsm.ChangeFsmState<EntityIdleFsm>();

            NewGameData._EntityManager.BeKill(this);
        }
    }
}
