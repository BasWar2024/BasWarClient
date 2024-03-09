#if _CLIENTLOGIC_
namespace Battle
{
    public class WarShipReadyFsm : FsmState<LockStepLogicMonoBehaviour>
    {
        public override void OnInit(LockStepLogicMonoBehaviour owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(LockStepLogicMonoBehaviour owner)
        {
            base.OnEnter(owner);

            owner.Fsm.ChangeFsmState<WarShipMoveFsm>();
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
