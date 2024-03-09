namespace Battle
{
    public class SkillSignalBoobFsm : FsmState<SkillBase>
    {
        private Fix64 m_TotalTime;

        public override void OnEnter(SkillBase owner)
        {
            base.OnEnter(owner);

            m_TotalTime = Fix64.Zero;

            if (NewGameData._SignalBomb != null)
            {
                NewGameData._SignalBomb.CanRelease = true;
                NewGameData._EntityManager.BeKill(NewGameData._SignalBomb);
            }

            NewGameData._SignalBomb = (SignalBombSkill)owner;
            NewGameData.SignalLockBuild();

            NewGameData.ResetReachSignal();

            foreach (var entity in NewGameData._SoldierList)
            {
                if (entity.SignalState != SignalState.None)
                {
                    if (entity.FlashMoveDelayTime == Fix64.Zero)
                        entity.Fsm.ChangeFsmState<EntityFindSignalFsm>();
                    else
                        entity.Fsm.ChangeFsmState<EntityMoveFlashFindSignalFsm>();
                }
            }

            if (NewGameData._Hero != null)
            {
                if (NewGameData._Hero.FlashMoveDelayTime == Fix64.Zero)
                    NewGameData._Hero.Fsm.ChangeFsmState<EntityFindSignalFsm>();
                else
                    NewGameData._Hero.Fsm.ChangeFsmState<EntityMoveFlashFindSignalFsm>();
            }

        }

        public override void OnUpdate(SkillBase owner)
        {
            base.OnUpdate(owner);

            m_TotalTime += NewGameData._FixFrameLen;

            if (m_TotalTime >= owner.LifeTime)
            {
                NewGameData._EntityManager.BeKill(owner);
            }
        }

        public override void OnLeave(SkillBase owner)
        {
            base.OnLeave(owner);
            if (NewGameData._SignalBomb == owner)
            {
                NewGameData._SignalLockBuilding = null;
                NewGameData._SignalBomb = null;
            }
        }
    }
}
