
namespace Battle
{
    public class EntityCarpetAtkFsm : FsmState<EntityBase>
    {
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private FixVector3 m_Fixv3MoveDistance;
        private FixVector3 m_OriginPos;
        private Fix64 m_TotalTime;

        private Fix64 m_AtkElpaseTime;
        private Fix64 m_AtkSpeed;

        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = (Fix64)2;
            m_OriginPos = owner.Fixv3LogicPosition;
            var dir = owner.Fixv3LogicPosition - NewGameData.CreateLandShipPos;
            dir.Normalize();
            m_Fixv3MoveDistance = dir * m_FixMoveTime * owner.MoveSpeed / (Fix64)2;

            m_AtkSpeed = owner.AtkSpeed;
            m_AtkElpaseTime = m_AtkSpeed;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;
            m_AtkElpaseTime += NewGameData._FixFrameLen;
            m_TotalTime += NewGameData._FixFrameLen;

            if (m_AtkElpaseTime >= m_AtkSpeed)
            {
                m_AtkElpaseTime -= m_AtkSpeed;
                if (owner.BulletId != 0)
                {
                    FixVector3 targetPos = new FixVector3(owner.Fixv3LogicPosition.x, Fix64.Zero, owner.Fixv3LogicPosition.z);
                    NewGameData._BulletFactory.CreateBullet(owner, null, owner.Fixv3LogicPosition, targetPos);
                }
            }

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = m_OriginPos + elpaseDistance;

            if (m_TotalTime >= m_FixMoveTime)
            {
                owner.Fsm.ChangeFsmState<EntitAirSoliderReverseFsm>();
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
