#if _CLIENTLOGIC_
using Spine.Unity;
#endif

namespace Battle
{
    public class Tank : SoliderBase
    {
        public Fix64 GunAngleY;
#if _CLIENTLOGIC_
        public SkeletonAnimation GunSpineAnim; //""，""spine 
#endif

        public override void Init()
        {
            base.Init();

            SignalState = SignalState.NoReachSignal;
            Direction = 16;
            ModelType = ModelType.Model2D_Tank;

            GunAngleY = Fix64.Zero;

        }

        public override void Start()
        {
            base.Start();

            LoadProperties();

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, CreateFromPrefabCallBack);
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

        public override void Release()
        {
            base.Release();
#if _CLIENTLOGIC_
            GunSpineAnim = null;
#endif
        }

#if _CLIENTLOGIC_
        private void CreateFromPrefabCallBack()
        {
            GunSpineAnim = Trans.Find("Gun/Spine").GetComponent<SkeletonAnimation>();
            SpineAnim.transform.localScale = new UnityEngine.Vector3(1, 1, 1);
            GunSpineAnim.transform.localScale = new UnityEngine.Vector3(1, 1, 1);
        }
#endif
    }
}
