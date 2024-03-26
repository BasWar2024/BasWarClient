

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    //""
    public class CarrierAircraftSolider : SoliderBase
    {
#if _CLIENTLOGIC_
        public Transform Shadow;
#endif

        public override void Init()
        {
            base.Init();

            ModelType = ModelType.Model3D;
            IsInTheSky = true;
            OperOrder = OperOrder.None;
        }

        public override void Start()
        {
            base.Start();

            LoadProperties();

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, CreatePrefbabCallBack);
#endif

            Fsm = NewGameData._PoolManager.Pop<FsmCompent<EntityBase>>();
            Fsm.CreateFsm(this,
               NewGameData._PoolManager.Pop<EntityBezierCurveMove>(),
               NewGameData._PoolManager.Pop<EntityCarrierAircraftAtk>(),
               NewGameData._PoolManager.Pop<EntityDeadFsm>()
               );

            Fsm.OnStart<EntityBezierCurveMove>();
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm?.OnUpdate(this);

#if _CLIENTLOGIC_
            if (Shadow != null)
            {
                Shadow.position = new Vector3((float)Fixv3LogicPosition.x, 0, (float)Fixv3LogicPosition.z);
            }
#endif
        }

        public override void Release()
        {
            base.Release();

#if _CLIENTLOGIC_
            if (Shadow != null)
            {
                NewGameData._GameObjFactory.ReleaseGameObj(Shadow.gameObject);
                Shadow = null;
            }
#endif
        }

#if _CLIENTLOGIC_
        private void CreatePrefbabCallBack()
        {
            NewGameData._GameObjFactory.CreateGameObj("Shadow", Fixv3LogicPosition, CreateShadowCallBack);

            var forword = TargetPos.ToVector3() - OriginPos.ToVector3();
            Trans.LookAt(forword);
            CurrRotation = Trans.rotation;
        }

        private void CreateShadowCallBack(GameObject shadow)
        {
            Shadow = shadow.transform;
            Shadow.SetParent(Trans);
        }
#endif
    }
}
