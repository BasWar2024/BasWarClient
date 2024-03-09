
namespace Battle
{

    public class StraightBullet : BulletBase
    {
        public override void Init(EntityBase origin, EntityBase target, FixVector3 originPos, FixVector3 targetPos)
        {
            base.Init(origin, target, originPos, targetPos);
            LoadProperties();

            Fsm = new FsmCompent<EntityBase>();
            Fsm.CreateFsm(this, new EntityMoveStraightFsm(), new EntityArriveFsm(), new EntityDeadFsm());
            Fsm.OnStart<EntityMoveStraightFsm>();
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }

}