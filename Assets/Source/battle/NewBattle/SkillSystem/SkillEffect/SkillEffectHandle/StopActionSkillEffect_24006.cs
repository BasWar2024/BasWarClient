
namespace Battle
{
    public class StopActionSkillEffect_24006 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.StopAction(Buff, null, TargetEntity);
        }

        public override void Leave()
        {
            if (TargetEntity != null)
            {
                if (TargetEntity.Group == GroupType.PlayerGroup)
                {
                    if (NewGameData._SignalBomb != null && TargetEntity.SignalState == SignalState.NoReachSignal)
                    {
                        if (TargetEntity.FlashMoveDelayTime == Fix64.Zero)
                            TargetEntity.Fsm.ChangeFsmState<EntityFindSignalFsm>();
                        else
                            TargetEntity.Fsm.ChangeFsmState<EntityMoveFlashFindSignalFsm>();
                    }
                    else
                    {
                        TargetEntity.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                    }
                }
                else if (TargetEntity.Group == GroupType.EnemyGroup)
                {
                    TargetEntity.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
                }
            }

            base.Leave();
        }
    }
}
