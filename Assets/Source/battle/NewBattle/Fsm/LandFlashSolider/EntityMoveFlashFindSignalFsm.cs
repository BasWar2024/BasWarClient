
namespace Battle
{
    public class EntityMoveFlashFindSignalFsm : FsmState<EntityBase>
    {

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            if (owner.BuildAroundPoint != null)
            {
                owner.BuildAroundPoint.Use = false;
                owner.BuildAroundPoint = null;
            }

            if (NewGameData._SignalLockBuilding != null)
            {
                owner.LockedAttackEntity = NewGameData._SignalLockBuilding;

                if (FixVector3.Distance(owner.Fixv3LogicPosition, NewGameData._SignalLockBuilding.Fixv3LogicPosition) <=
                    owner.Radius + NewGameData._SignalLockBuilding.Radius)
                {
                    owner.SignalState = SignalState.ReachSignal;
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }

                owner.SignalState = SignalState.NoReachSignal;
                owner.Fsm.ChangeFsmState<EntityMoveFlashSignalLockBuildingFsm>();
            }
            else
            {
                owner.LockedAttackEntity = NewGameData._SignalBomb.Entity;

                if (FixVector3.Distance(owner.Fixv3LogicPosition, NewGameData._SignalBomb.Fixv3LogicPosition) <=
                    owner.Radius + NewGameData._SignalBomb.IntArg3)
                {
                    owner.SignalState = SignalState.ReachSignal;
                    owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                    return;
                }

                owner.SignalState = SignalState.NoReachSignal;
                owner.Fsm.ChangeFsmState<EntityMoveFlashSignalFsm>();
            }
        }
    }
}
