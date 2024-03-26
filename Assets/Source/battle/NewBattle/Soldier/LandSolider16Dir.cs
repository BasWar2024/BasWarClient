
namespace Battle
{
    public class LandSolider16Dir : SoliderBase
    {

        public override void Init()
        {
            base.Init();

            SignalState = SignalState.NoReachSignal;
            Direction = 16;
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
                NewGameData._PoolManager.Pop<EntityMoveFsm>(),
                //NewGameData._PoolManager.Pop<EntityAStarMoveFsm>(),
                NewGameData._PoolManager.Pop<EntityAtkFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>(),
                NewGameData._PoolManager.Pop<EntityMoveSignalFsm>(),
                NewGameData._PoolManager.Pop<EntityFindSignalFsm>(),
                NewGameData._PoolManager.Pop<EntityIdleFsm>(),
                NewGameData._PoolManager.Pop<EntityMoveSignalLockBuildingFsm>(),
                NewGameData._PoolManager.Pop<EntityDisappearFsm>(),
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
