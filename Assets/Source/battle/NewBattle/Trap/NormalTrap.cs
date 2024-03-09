
namespace Battle
{
    public class NormalTrap : TrapBase
    {
        public override void Init()
        {
            base.Init();

            LoadProperties();

            Fsm = new FsmCompent<EntityBase>();
            Fsm.CreateFsm(this, new TrapIdleFsm(), new TrapDelayAtkFsm(), new EntityDeadFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}