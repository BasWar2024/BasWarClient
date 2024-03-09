
#if _CLIENTLOGIC_
namespace Battle
{
    public class WarShipOverFsm : FsmState<LockStepLogicMonoBehaviour>
    {
        public override void OnInit(LockStepLogicMonoBehaviour owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(LockStepLogicMonoBehaviour owner)
        {
            base.OnEnter(owner);
            owner.StartBattle();
        }

        public override void OnUpdate(LockStepLogicMonoBehaviour owner)
        {
            base.OnUpdate(owner);
        }
        public override void OnLeave(LockStepLogicMonoBehaviour owner)
        {
            base.OnLeave(owner);
        }
    }
}
#endif
