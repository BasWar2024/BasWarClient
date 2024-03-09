
namespace Battle
{
    public class DefenseTower : BuildingBase
    {

        public override void Init()
        {
            base.Init();

            LoadProperties();

            Fsm = new FsmCompent<EntityBase>();
            Fsm.CreateFsm(this, new EntityFindSoliderFsm(), new EntityAtkFsm(), new EntityDeadFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}