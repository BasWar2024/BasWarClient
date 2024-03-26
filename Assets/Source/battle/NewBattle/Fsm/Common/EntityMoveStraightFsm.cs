
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class EntityMoveStraightFsm : FsmState<EntityBase> //""
    {
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private FixVector3 m_Fixv3MoveDistance;
        private Fix64 m_EndTimeScale;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = FixVector3.Distance(owner.OriginPos, owner.TargetPos) / owner.GetFixMoveSpeed();
            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.01;
            }
            m_Fixv3MoveDistance = owner.TargetPos - owner.OriginPos;

            m_EndTimeScale = Fix64.One;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = owner.OriginPos + elpaseDistance;

#if _CLIENTLOGIC_
            if (owner.ModelType == ModelType.Model3D && owner.Trans != null)
            {
                owner.CurrRotation = Quaternion.LookRotation(m_Fixv3MoveDistance.ToVector3(), Vector3.up);
            }
#endif

            if (timeScale >= m_EndTimeScale || owner.Fixv3LogicPosition.y < 0)
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
