
namespace Battle
{


    public class LandHero : SoliderBase
    {
        public int SkillId;
        public SkillModel HeroSkillModel;
        public Fix64 SkillDelayTime;
        public int Level;

        public override void Init()
        {
            base.Init();

            SignalState = SignalState.NoReachSignal;
            Direction = 8;
        }

        public override void Start()
        {
            base.Start();

            if (NewGameData._OperOrder_ModelIdDict.TryGetValue((OperOrder)ArmyIndex + 5, out long heroSkillId))
            {
                HeroSkillModel = NewGameData._SkillModelDict[heroSkillId];
                SkillAnimTime = (Fix64)HeroSkillModel.skillAnimTime / 1000;
                SkillDelayTime = (Fix64)HeroSkillModel.skillDelayTime / 1000;
            }

            LoadProperties();
#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, CreateHeroCallBack);
#endif
            Fsm = NewGameData._PoolManager.Pop<FsmCompent<EntityBase>>();

            Fsm.CreateFsm(this,
                NewGameData._PoolManager.Pop<EntityBirthFsm>(),
                NewGameData._PoolManager.Pop<EntityFindBuildingFsm>(),
                NewGameData._PoolManager.Pop<EntityDoSkillFsm>(),
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

#if _CLIENTLOGIC_
        private void CreateHeroCallBack()
        {
            var level = HpSprite.transform.Find("Level");
            level.gameObject.SetActive(true);
            level.Find("Text").GetComponent<UnityEngine.TextMesh>().text = Level.ToString();
            HpSprite.transform.parent.localScale = new UnityEngine.Vector3(1.5f, 1.5f, 1.5f);
            HpSprite.gameObject.SetActive(true);
        }
#endif

        public override void Release()
        {
            base.Release();
            HeroSkillModel = null;
        }
    }
}
