
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class EntityMoveStraightFsm : FsmState<EntityBase> //
    {
        private Fix64 m_FixMoveElpaseTime = Fix64.Zero;
        private Fix64 m_FixMoveTime = Fix64.Zero;
        private FixVector3 m_Fixv3MoveDistance;
        private Fix64 m_TargetSize;
        private bool m_IsLookAtTarget;

        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = FixVector3.Distance(owner.OriginPos, owner.TargetPos) / owner.MoveSpeed;
            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
            m_Fixv3MoveDistance = owner.TargetPos - owner.OriginPos;
            m_TargetSize = owner.LockedAttackEntity == null ? (Fix64)1.5 : owner.LockedAttackEntity.Radius;
            m_IsLookAtTarget = false;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = owner.OriginPos + elpaseDistance;

#if _CLIENTLOGIC_
            if(owner.ModelType == ModelType.Model3D && owner.Trans != null)
            {
                if (!m_IsLookAtTarget)
                {
                    owner.Trans.LookAt(owner.TargetPos.ToVector3());
                    owner.Trans.localEulerAngles = new Vector3(0, owner.Trans.localEulerAngles.y, owner.Trans.localEulerAngles.z);
                    m_IsLookAtTarget = true;
                }
            }
#endif

            if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.TargetPos) <= m_TargetSize || owner.Fixv3LogicPosition.y < 0)
            {
                owner.Fsm.ChangeFsmState<EntityArriveFsm>();
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
