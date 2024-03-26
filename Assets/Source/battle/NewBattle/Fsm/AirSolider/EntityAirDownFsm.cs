
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class EntityAirDownFsm : FsmState<EntityBase> //""
    {
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private FixVector3 m_Fixv3MoveDistance;
#if _CLIENTLOGIC_
        private bool m_IsLookAtTarget;
#endif

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = FixVector3.Distance(owner.OriginPos, owner.TargetPos) / owner.GetFixMoveSpeed();
            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
            m_Fixv3MoveDistance = owner.TargetPos - owner.OriginPos;
#if _CLIENTLOGIC_
            m_IsLookAtTarget = false;
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = owner.OriginPos + elpaseDistance;

#if _CLIENTLOGIC_
            if (!m_IsLookAtTarget)
            {
                if (owner.ModelType == ModelType.Model3D && owner.Trans != null)
                {
                    owner.Trans.LookAt(owner.TargetPos.ToVector3());
                    owner.CurrRotation = owner.Trans.rotation;
                    m_IsLookAtTarget = true;
                }
            }
#endif

            if (timeScale >= Fix64.One || owner.Fixv3LogicPosition.y < 0)
                owner.Fsm.ChangeFsmState<EntityAirSelfDestructAtkFsm>();

        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
