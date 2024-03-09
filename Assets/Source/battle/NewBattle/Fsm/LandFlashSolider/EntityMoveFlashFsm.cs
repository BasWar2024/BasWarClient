
namespace Battle
{
    public class EntityMoveFlashFsm : FsmState<EntityBase>
    {
        private FixVector3 m_FixMoveEndPosition;
        private FixVector3 m_Start2End = new FixVector3(Fix64.Zero, Fix64.Zero, Fix64.Zero);
        private bool m_Move2BuildAroundPoint;
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_Move2BuildAroundPoint = owner.BuildAroundPoint == null ? false : true;
            m_FixMoveEndPosition = m_Move2BuildAroundPoint ? owner.BuildAroundPoint.FixV3 : owner.LockedAttackEntity.Fixv3LogicPosition;
            m_Start2End = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
            m_Start2End.Normalize();

            var newLogicPosition = owner.Fixv3LogicPosition + m_Start2End * owner.MoveSpeed;
            var newLogicPos2End = new FixVector3(m_FixMoveEndPosition.x - newLogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - newLogicPosition.z);
            var dot = FixVector3.Dot(newLogicPos2End, m_Start2End);


            if (FixVector3.Distance(newLogicPosition, owner.LockedAttackEntity.Fixv3LogicPosition) <= owner.AtkRange + owner.LockedAttackEntity.Radius)
            {
                m_Start2End.Reverse();
                owner.Fixv3LogicPosition = owner.LockedAttackEntity.Fixv3LogicPosition + m_Start2End * (owner.AtkRange + owner.LockedAttackEntity.Radius);
                owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                return;
            }

            if (m_Move2BuildAroundPoint)
            {
                if (FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) <= owner.MoveSpeed ||
                    FixVector3.Dot(newLogicPos2End, m_Start2End) < 0)
                {
                    owner.Fixv3LogicPosition = m_FixMoveEndPosition;
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }
            }

            owner.Fixv3LogicPosition = newLogicPosition;
            owner.Fsm.ChangeFsmState<EntityIdleFlashFsm>();
        }
    }
}
