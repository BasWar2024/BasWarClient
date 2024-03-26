
namespace Battle
{
    public class BreakAtkcd_24011 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();

            if (TargetEntity.LockedAttackEntity != null)
            {
                TargetEntity.AtkElpaseTime = Fix64.Zero;

                if (TargetEntity is SoliderBase)
                {
                    TargetEntity.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                }
                else if (TargetEntity is BuildingBase)
                {
                    TargetEntity.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
                }
            }
        }
    }
}
