
namespace Battle
{
    using System.Collections.Generic;

    public class EntityFindBuildingFsm : FsmState<EntityBase>
    {
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            if (owner.BuildAroundPoint != null)
            {
                owner.BuildAroundPoint.Use = false;
                owner.BuildAroundPoint = null;
            }

            Fix64 minDistance = (Fix64)99999999;
            EntityBase nearestObj = null;
            foreach (var building in NewGameData._BuildingList)
            {
                if (building.BKilled)
                    continue;

                var buildingPos = new FixVector2(building.Fixv3LogicPosition.x, building.Fixv3LogicPosition.z);
                var distance = FixVector2.Distance(new FixVector2(owner.Fixv3LogicPosition.x, owner.Fixv3LogicPosition.z), buildingPos);

                if (minDistance > distance)
                {
                    minDistance = distance;
                    nearestObj = building;
                }
            }

            if(nearestObj != null)
            {
                owner.LockedAttackEntity = nearestObj;
                owner.BuildAroundPoint = NewGameData.GetBuildingAroundPoint(nearestObj);

                if (owner.FlashMoveDelayTime == Fix64.Zero)
                    owner.Fsm.ChangeFsmState<EntityMoveFsm>();
                else
                    owner.Fsm.ChangeFsmState<EntityIdleFlashFsm>();
            }
        }
    }
}
