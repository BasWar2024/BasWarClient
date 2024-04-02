
namespace Battle
{
    public class NormalTrap : TrapBase
    {
        public override void Init()
        {
            base.Init();
        }

        public override void Start()
        {
            base.Start();

            LoadProperties();

            //Fsm = new FsmCompent<EntityBase>();
            //Fsm.CreateFsm(this, new TrapIdleFsm(), new TrapDelayAtkFsm(), new EntityDeadFsm());

            Fsm = NewGameData._PoolManager.Pop<FsmCompent<EntityBase>>();

            Fsm.CreateFsm(this,
                NewGameData._PoolManager.Pop<TrapIdleFsm>(),
                NewGameData._PoolManager.Pop<TrapDelayAtkFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>()
                );

            Fsm.OnStart<TrapIdleFsm>();
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}