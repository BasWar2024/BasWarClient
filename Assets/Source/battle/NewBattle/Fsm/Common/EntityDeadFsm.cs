
namespace Battle
{
    public class EntityDeadFsm : FsmState<EntityBase>
    {
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            if (owner.BuildAroundPoint != null)
                owner.BuildAroundPoint.Use = false;

            owner.CanRelease = true;

            if (owner is BuildingBase)
            {
                BuildingBase building = (BuildingBase)owner;
#if _CLIENTLOGIC_

                NewGameData._GameObjFactory.CreateGameObj(building.DeadResPath, building.Fixv3LogicPosition);
                NewGameData._EffectFactory.CreateEffect(building.EffectResPath, building.Fixv3LogicPosition);
#endif

                if (building.IsMain)
                {
                    NewGameData._Victory = true;
                }
            }
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}

