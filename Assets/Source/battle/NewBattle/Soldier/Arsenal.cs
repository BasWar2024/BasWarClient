
namespace Battle
{
    public class Arsenal : SoliderBase
    {
        public override void Init()
        {
            base.Init();

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
              NewGameData._PoolManager.Pop<ArsenalBirthFsm>(),
              NewGameData._PoolManager.Pop<EntityCreateSoliderFsm>(),
              NewGameData._PoolManager.Pop<EntityDeadFsm>()
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
