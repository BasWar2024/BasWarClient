
namespace Battle
{
    public class EntityArriveFsm : FsmState<EntityBase>
    {

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            if (owner is LandingShip)
            {
                owner.Fsm.ChangeFsmState<EntityLandingSoliderFsm>();
            }
            else if (owner is BomberAirSolider)
            {
                owner.Fsm.ChangeFsmState<EntityCarpetAtkFsm>();
            }
            else if (owner is SuicideAirSolider)
            {
                owner.Fsm.ChangeFsmState<EntityAirSelfDestructAtkFsm>();
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

