
namespace Battle
{
    public class EntityStopActionFsm : FsmState<EntityBase>
    {
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

#if _CLIENTLOGIC_
            if (owner.ObjType == ObjectType.Soldier)
                owner.SpineAnim.SpineAnimPlayAuto8Turn(owner, "idle", true);
            else if (owner.ObjType == ObjectType.Tower)
                owner.SpineAnim.SpineAnimPlayAuto30Turn(owner, "idle", true);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
