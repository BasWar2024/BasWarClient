


namespace Battle
{
#if _CLIENTLOGIC_
    using Spine.Unity;
    using UnityEngine;

    enum animStage
    {
        exit = 0,
        move = 1,
        standby = 2,
    }

#endif
    public class LandingShip : SoliderBase
    {
        public SoliderModel SoliderModel;
        public HeroModel HeroModel;
        //public bool IsLanding; //""，""，""
        public OperOrder LandingSoliderOperOrder;
        public int Amount; //""
        public FixVector3 Dir;
        public FixVector3 LandPos;
#if _CLIENTLOGIC_
        public Transform LandHaloPs;
        public GameObject LandHalo;
        public SkeletonAnimation LandHaloSkeletonAnim;
#endif

        public override void Init()
        {
            base.Init();

            LandingSoliderOperOrder = OperOrder.None;
            ModelType = ModelType.Model3D;
            //IsLanding = false;
            IsInTheSky = true;
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
                NewGameData._PoolManager.Pop<EntityLandShipMoveFsm>(),
                NewGameData._PoolManager.Pop<EntityArriveFsm>(),
                NewGameData._PoolManager.Pop<EntityLandingSoliderFsm>(),
                NewGameData._PoolManager.Pop<EntityLandingShipIdle>(),
                //NewGameData._PoolManager.Pop<EntityAirSoliderReturnFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>()
                );

            Fsm.OnStart<EntityLandShipMoveFsm>();
        }

#if _CLIENTLOGIC_
        private void CreateFromPrefabCallBack()
        {
            LandHaloPs = Trans.Find("Eff/Eff_LandHalo_ps");
            LandHaloPs.gameObject.SetActive(false);

            //TurnForward();
        }

        //public override void UpdateRenderRotation(float interpolation)
        //{
            
        //}

        public void CreateLandHaloPrefabCallBack(GameObject obj)
        {
            LandHalo = obj;
            LandHaloSkeletonAnim = LandHalo.transform.Find("Spine").GetComponent<SkeletonAnimation>();
            LandHaloSkeletonAnim.AnimationState.SetEmptyAnimation(0, 0);
            LandHaloSkeletonAnim.SpineAimPlayAuto0Turn("birth", false, 0, "idle");
        }

        public void ReleaseLandHalo()
        {
            NewGameData._GameObjFactory.ReleaseGameObj(LandHalo);
            LandHalo = null;
            LandHaloSkeletonAnim = null;
        }
#endif

        public override void Release()
        {
            base.Release();
            SoliderModel = null;
            HeroModel = null;
#if _CLIENTLOGIC_
            LandHaloPs = null;
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm?.OnUpdate(this);
        }

    }
}

