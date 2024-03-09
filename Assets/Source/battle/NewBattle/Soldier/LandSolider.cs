
namespace Battle
{
    public class LandSolider : SoliderBase
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

            Fsm.CreateFsm(this, new EntityFindBuildingFsm(), new EntityMoveFsm(), new EntityAtkFsm(), new EntityDeadFsm(),
                    new EntityMoveSignalFsm(), new EntityFindSignalFsm(), new EntityIdleFsm(), new EntityMoveSignalLockBuildingFsm(), new EntityStopActionFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}
