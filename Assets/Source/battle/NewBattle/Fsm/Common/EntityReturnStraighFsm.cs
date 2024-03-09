
namespace Battle
{

#if _CLIENTLOGIC_
    using UnityEngine;
#endif


    public class EntityReturnStraighFsm : FsmState<EntityBase>
    {
        private Fix64 m_FixMoveElpaseTime = Fix64.Zero;
        private Fix64 m_FixMoveTime = Fix64.Zero;
        private FixVector3 m_Fixv3MoveDistance;

        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_FixMoveElpaseTime = Fix64.Zero;
            var originPosTemp = owner.OriginPos;
            owner.OriginPos = owner.Fixv3LogicPosition;
            owner.TargetPos = originPosTemp;

            m_FixMoveTime = FixVector3.Distance(owner.OriginPos, owner.TargetPos) / owner.MoveSpeed;
            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
            m_Fixv3MoveDistance = owner.TargetPos - owner.OriginPos;

#if _CLIENTLOGIC_
            owner.Trans.LookAt(owner.TargetPos.ToVector3());
            owner.Trans.localEulerAngles = new Vector3(0, owner.Trans.localEulerAngles.y, owner.Trans.localEulerAngles.z);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = owner.OriginPos + elpaseDistance;
            if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.TargetPos) <= (Fix64)3)
            {
                NewGameData._EntityManager.BeKill(owner);
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
