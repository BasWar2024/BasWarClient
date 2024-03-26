

namespace Battle
{
    public class NormalBuilding : BuildingBase
    {
        public override void Init()
        {
            base.Init();
        }

        public override void Start()
        {
            base.Start();


            LoadProperties();

            Fsm = NewGameData._PoolManager.Pop<FsmCompent<EntityBase>>();

            Fsm.CreateFsm(this,
                NewGameData._PoolManager.Pop<EntityFindSoliderFsm>(),
                NewGameData._PoolManager.Pop<EntityIdleFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>(),
                NewGameData._PoolManager.Pop<EntityStopActionFsm>()
                );
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm?.OnUpdate(this);
        }
    }
}