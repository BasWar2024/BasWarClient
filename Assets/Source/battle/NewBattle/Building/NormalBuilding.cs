

namespace Battle
{
    public class NormalBuilding : BuildingBase
    {
        public override void Init()
        {
            base.Init();

            LoadProperties();

            Fsm = new FsmCompent<EntityBase>();
            Fsm.CreateFsm(this, new EntityFindSoliderFsm(), new EntityIdleFsm(), new EntityDeadFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}