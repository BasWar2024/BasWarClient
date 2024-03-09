
namespace Battle
{
    public class LandFlashSolider : SoliderBase
    {
        public int OperSolider;

        public override void Init()
        {
            base.Init();

            SignalState = SignalState.NoReachSignal;

            LoadProperties();
#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, null);
#endif

            Fsm = new FsmCompent<EntityBase>();
            Fsm.CreateFsm(this, new EntityFindBuildingFsm(), new EntityMoveFlashFsm(), new EntityAtkFsm(), new EntityDeadFsm(), new EntityMoveFlashSignalFsm(),
                new EntityMoveFlashFindSignalFsm(), new EntityIdleFlashFsm(), new EntityMoveFlashSignalLockBuildingFsm(), new EntityStopActionFsm());

        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}
