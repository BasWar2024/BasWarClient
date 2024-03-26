
namespace Battle
{
    public class EntityStopActionFsm : FsmState<EntityBase>
    {
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

#if _CLIENTLOGIC_
            owner.SpineAnim.SpineAnimPlay(owner, "idle", true);
#endif
        }
    }
}
