
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class SuicideAirSolider : SoliderBase
    {

#if _CLIENTLOGIC_
        public Transform Shadow;
#endif
        public override void Init()
        {
            base.Init();

            ModelType = ModelType.Model3D;
            IsInTheSky = true;
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
                NewGameData._PoolManager.Pop<EntityAirDownFsm>(),
                NewGameData._PoolManager.Pop<EntityAirSelfDestructAtkFsm>(),
                NewGameData._PoolManager.Pop<EntityKillSelfFsm>(),
                NewGameData._PoolManager.Pop<EntityDisappearFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>()
                );

            Fsm.OnStart<EntityAirDownFsm>();
        }

#if _CLIENTLOGIC_
        private void CreatePrefbabCallBack()
        {
            NewGameData._GameObjFactory.CreateGameObj("Shadow", Fixv3LogicPosition, CreateShadowCallBack);
        }

        private void CreateShadowCallBack(GameObject shadow)
        {
            Shadow = shadow.transform;
            Shadow.SetParent(Trans);
        }
#endif

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm?.OnUpdate(this);

#if _CLIENTLOGIC_
            if (Shadow != null)
            {
                if (Shadow.position.y != 0)
                {
                    Shadow.position = new Vector3((float)Fixv3LogicPosition.x, 0, (float)Fixv3LogicPosition.z);
                }
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
    }
}