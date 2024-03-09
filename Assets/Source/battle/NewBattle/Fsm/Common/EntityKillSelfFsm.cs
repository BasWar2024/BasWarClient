
namespace Battle
{
    public class EntityKillSelfFsm : FsmState<EntityBase>
    {
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            NewGameData._EntityManager.BeKill(owner);
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
