
namespace Battle
{
    public class EntityIdleFlashFsm : FsmState<EntityBase>
    {
        private Fix64 m_ElpaseTime;
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_ElpaseTime = Fix64.Zero;

#if _CLIENTLOGIC_
            owner.UpdateSpineRenderRotation(AnimType.FlashIdle);
            owner.SpineAnim.SpineAnimPlayAuto8Turn(owner, "idle", true);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled)
            {
                owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                return;
            }

            m_ElpaseTime += NewGameData._FixFrameLen;

            if (m_ElpaseTime >= owner.FlashMoveDelayTime)
            {
                if (NewGameData._SignalBomb != null && owner.SignalState == SignalState.NoReachSignal)
                {
                    owner.Fsm.ChangeFsmState<EntityMoveFlashFindSignalFsm>();
                    return;
                }

                owner.Fsm.ChangeFsmState<EntityMoveFlashFsm>();
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
