
namespace Battle
{
    public class LandFlashSolider : SoliderBase
    {
        public override void Init()
        {
            base.Init();

            SignalState = SignalState.NoReachSignal;
            Direction = 8;
        }

        public override void Start()
        {
            base.Start();

            LoadProperties();
#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, null);
#endif

            Fsm = NewGameData._PoolManager.Pop<FsmCompent<EntityBase>>();

            Fsm.CreateFsm(this,
                NewGameData._PoolManager.Pop<EntityBirthFsm>(),
                NewGameData._PoolManager.Pop<EntityFindBuildingFsm>(),
                NewGameData._PoolManager.Pop<EntityMoveFlashFsm>(),
                NewGameData._PoolManager.Pop<EntityAtkFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>(),
                NewGameData._PoolManager.Pop<EntityMoveFlashSignalFsm>(),
                NewGameData._PoolManager.Pop<EntityMoveFlashFindSignalFsm>(),
                NewGameData._PoolManager.Pop<EntityIdleFlashFsm>(),
                NewGameData._PoolManager.Pop<EntityMoveFlashSignalLockBuildingFsm>(),
                NewGameData._PoolManager.Pop<EntityStopActionFsm>()
                );

            Fsm.OnStart<EntityBirthFsm>();
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm?.OnUpdate(this);
        }
    }
}
