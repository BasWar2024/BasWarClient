
namespace Battle
{
    public class LandingShip : SoliderBase
    {
        public SoliderModel SoliderModel;
        public HeroModel HeroModel;
        public bool IsLanding; //

        public override void Init()
        {
            base.Init();

            ModelType = ModelType.Model3D;
            Radius = (Fix64)1;
            MoveSpeed = (Fix64)8;
            FixOriginHp = (Fix64)30;
            FixHp = FixOriginHp;

            IsLanding = false;
            IsInTheSky = true;

            LoadProperties();

#if _CLIENTLOGIC_
            CreateFromPrefab("Liberatorwarship", null);
#endif

            Fsm = new FsmCompent<EntityBase>();
            Fsm.CreateFsm(this, new EntityMoveStraightFsm(), new EntityArriveFsm(), new EntitAirSoliderReverseFsm(), new EntityReturnStraighFsm(), new EntityDeadFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}

