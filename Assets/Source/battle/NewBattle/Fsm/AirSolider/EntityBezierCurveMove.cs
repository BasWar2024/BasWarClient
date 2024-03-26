

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class EntityBezierCurveMove : FsmState<EntityBase>
    {
        private FixVector3 m_TurnPos;
        private Fix64 m_Time;
        private Fix64 m_TotalTime;
        private FixVector3 m_S2e;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_S2e = owner.TargetPos - owner.OriginPos;
            var right = FixVector3.Cross(m_S2e, NewGameData._FixUp);
            right.Normalize();


            m_TurnPos = owner.OriginPos + m_S2e / (Fix64)2 + right * (Fix64)(NewGameData._Srand.Range(0, 2) == 0 ? -1 : 1) * (Fix64)20;
            m_Time = Fix64.Zero;
            m_TotalTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_S2e)) / owner.OriginMoveSpeed;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
#if _CLIENTLOGIC_
            if(owner.Trans != null)
                owner.CurrRotation = Quaternion.LookRotation(m_S2e.ToVector3(), owner.Trans.up);
#endif

            m_Time += NewGameData._FixFrameLen;
            var t = m_Time / m_TotalTime;

            owner.Fixv3LogicPosition = FixMath.BezierCurve2(t, owner.OriginPos, owner.TargetPos, m_TurnPos);

            if (t >= (Fix64)0.95)
            {
                if (owner is CarrierAircraftSolider cairSolider)
                {
                    
                    owner.Fsm.ChangeFsmState<EntityCarrierAircraftAtk>();
                }
            }
        }
    }
}
