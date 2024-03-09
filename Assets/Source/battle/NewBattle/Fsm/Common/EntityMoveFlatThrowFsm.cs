
namespace Battle
{
    //
    public class EntityMoveFlatThrowFsm : FsmState<EntityBase>
    {
        private Fix64 m_FixMoveElpaseTime = Fix64.Zero;
        private Fix64 m_FixMoveTime = Fix64.Zero;
        private FixVector3 m_Fixv3MoveDistance;
        private Fix64 m_TargetSize;

        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = Fix64.Sqrt(NewGameData.AirHigh * 2 / (Fix64)9.8);
            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
            m_Fixv3MoveDistance = new FixVector3(owner.TargetPos.x - owner.OriginPos.x, Fix64.Zero, owner.TargetPos.z - owner.OriginPos.z);
            m_TargetSize = owner.LockedAttackEntity == null ? (Fix64)0.5 : owner.LockedAttackEntity.Radius;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;
            Fix64 y = NewGameData.AirHigh - (Fix64)0.5 * (Fix64)9.8 * m_FixMoveElpaseTime * m_FixMoveElpaseTime;

            owner.Fixv3LogicPosition = new FixVector3(owner.OriginPos.x + elpaseDistance.x, y, owner.OriginPos.z + elpaseDistance.z);
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
