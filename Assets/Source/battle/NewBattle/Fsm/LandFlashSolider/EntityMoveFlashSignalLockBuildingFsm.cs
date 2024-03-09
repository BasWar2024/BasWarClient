
namespace Battle
{
    public class EntityMoveFlashSignalLockBuildingFsm : FsmState<EntityBase>
    {
        private FixVector3 m_FixMoveEndPosition;
        private FixVector3 m_Start2End = new FixVector3(Fix64.Zero, Fix64.Zero, Fix64.Zero);
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_FixMoveEndPosition = NewGameData._SignalLockBuilding.Fixv3LogicPosition;
            m_Start2End = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
            m_Start2End.Normalize();

            var newLogicPosition = owner.Fixv3LogicPosition + m_Start2End * owner.MoveSpeed;
            var newLogicPos2End = new FixVector3(m_FixMoveEndPosition.x - newLogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - newLogicPosition.z);


            if (FixVector3.Distance(newLogicPosition, m_FixMoveEndPosition) <= owner.AtkRange + NewGameData._SignalLockBuilding.Radius || FixVector3.Dot(newLogicPos2End, m_Start2End) < 0)
            {
                m_Start2End.Reverse();
                owner.Fixv3LogicPosition = NewGameData._SignalLockBuilding.Fixv3LogicPosition + m_Start2End * (owner.AtkRange + NewGameData._SignalLockBuilding.Radius);
                owner.SignalState = SignalState.ReachSignal;
                owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                return;
            }


            owner.Fixv3LogicPosition = newLogicPosition;
            owner.Fsm.ChangeFsmState<EntityIdleFlashFsm>();
        }
    }
}
