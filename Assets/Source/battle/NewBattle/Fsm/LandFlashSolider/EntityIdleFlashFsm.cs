
namespace Battle
{
    public class EntityIdleFlashFsm : FsmState<EntityBase>
    {
        private Fix64 m_ElpaseTime;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_ElpaseTime = Fix64.Zero;

            owner.AngleY = owner.UpdateSpineRenderRotation(AnimType.FlashIdle);
#if _CLIENTLOGIC_
            owner.SpineAnim.SpineAnimPlay(owner, "idle_attack", true);
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

            if (owner.IsSmoke())
            {
                if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.LockedAttackEntity.Fixv3LogicPosition) <=
                    owner.AtkRange + owner.LockedAttackEntity.Radius)
                {
                    return;
                }
            }

            m_ElpaseTime += NewGameData._FixFrameLen;

            if (m_ElpaseTime >= owner.FlashMoveDelayTime)
            {
                if (NewGameData._SignalBomb != null && owner.SignalState == SignalState.NoReachSignal)
                {
                    owner.Fsm.ChangeFsmState<EntityMoveFlashFindSignalFsm>();
                    return;
                }

                if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.LockedAttackEntity.Fixv3LogicPosition) <=
                    owner.AtkRange + owner.LockedAttackEntity.Radius)
                {
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
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
