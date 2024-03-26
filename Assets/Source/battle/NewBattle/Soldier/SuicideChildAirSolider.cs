using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class SuicideChildAirSolider : SoliderBase
    {
        public override void Init()
        {
            base.Init();

            SignalState = SignalState.None;
            IsInTheSky = true;
            ModelType = ModelType.Model3D;
            ImmuneBuff = true;
        }

        public override void Start()
        {
            base.Start();

            LoadProperties();
#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, CreateCallBack);

#endif

            Fsm = NewGameData._PoolManager.Pop<FsmCompent<EntityBase>>();

            Fsm.CreateFsm(this,
                NewGameData._PoolManager.Pop<SuicideChildMoveFsm>(),
                NewGameData._PoolManager.Pop<SuicideChildAtkFsm>(),
                NewGameData._PoolManager.Pop<EntityDisappearFsm>(),
                NewGameData._PoolManager.Pop<EntityDeadFsm>()
                );

            Fsm.OnStart<SuicideChildMoveFsm>();
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm?.OnUpdate(this);
        }

#if _CLIENTLOGIC_
        private void CreateCallBack()
        {
            var s2e = new FixVector3(TargetPos.x, Fix64.Zero, TargetPos.z) - new FixVector3(OriginPos.x, Fix64.Zero, OriginPos.z);
            TurnForword(this, s2e);
        }

        public void TurnForword(EntityBase owner, FixVector3 forword)
        {
            if (owner.Trans != null)
            {
                var origin2Targer = forword.ToVector3();
                owner.Trans.forward = origin2Targer;
            }
        }

#endif
    }
}

