
namespace Battle
{
    using System.Collections.Generic;

    public class EntityFindSignalFsm : FsmState<EntityBase>
    {
        private EntityBase m_Owner;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_Owner = owner;

            if (owner.BuildAroundPoint != null)
            {
                owner.BuildAroundPoint.Use = false;
                owner.BuildAroundPoint = null;
            }

            if (NewGameData._SignalLockBuilding != null)
            {
                if (FixVector3.Distance(owner.Fixv3LogicPosition, NewGameData._SignalLockBuilding.Fixv3LogicPosition) <=
                    owner.AtkRange + NewGameData._SignalLockBuilding.Radius)
                {
                    owner.LockedAttackEntity = NewGameData._SignalLockBuilding;
                    owner.SignalState = SignalState.ReachSignal;
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }

                //NewGameData._AStar.PushFindMovePathComd(owner, FindPathType.FindSignalLockBuilding, FindMoveSignalLockBuildingCallBack);
            }
            else
            {
                if (FixVector3.Distance(owner.Fixv3LogicPosition, NewGameData._SignalBomb.Entity.Fixv3LogicPosition) <=
                    owner.Radius + NewGameData._SignalBomb.IntArg3)
                {
                    owner.LockedAttackEntity = NewGameData._SignalBomb.Entity;
                    owner.SignalState = SignalState.ReachSignal;
                    owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                    return;
                }

                //NewGameData._AStar.PushFindMovePathComd(owner, FindPathType.FindSignal, FindMoveSignalCallBack);
            }
        }

        private void FindMoveSignalLockBuildingCallBack(List<ASPoint> path)
        {
            if (path != null && path.Count > 0)
            {
                m_Owner.Fsm.ChangeFsmState<EntityMoveSignalLockBuildingFsm>();
            }
            else
            {
                m_Owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
            }
        }

        private void FindMoveSignalCallBack(List<ASPoint> path)
        {
            if (path != null && path.Count > 0)
            {
                m_Owner.Fsm.ChangeFsmState<EntityMoveSignalFsm>();
            }
            else
            {
                m_Owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
            }
        }
    }
}
