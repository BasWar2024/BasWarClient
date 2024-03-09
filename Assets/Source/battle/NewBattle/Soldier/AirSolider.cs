
namespace Battle
{
    public class AirSolider : SoliderBase
    {

        public override void Init()
        {
            base.Init();

            ModelType = ModelType.Model3D;
            IsInTheSky = true;

            LoadProperties();

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, null);
#endif

            Fsm = new FsmCompent<EntityBase>();
            if (IsAtkAndReturn == 0)
            {
                SignalState = SignalState.NoReachSignal;
                Fsm.CreateFsm(this, new EntityMoveStraightFsm(), new EntityArriveFsm(), new EntityFindBuildingFsm(), new EntityMoveFsm(), new EntityAtkFsm(), new EntityDeadFsm(),
                    new EntityMoveSignalFsm());
            }
            else
            {
                Fsm.CreateFsm(this, new EntityMoveStraightFsm(), new EntityArriveFsm(), new EntityCarpetAtkFsm(), new EntitAirSoliderReverseFsm(), new EntityReturnStraighFsm(),
                    new EntityDeadFsm());
            }
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
            //UnityTools.Log("" + Fixv3LogicPosition + "" + NewGameData._UGameLogicFrame);
        }
    }
}