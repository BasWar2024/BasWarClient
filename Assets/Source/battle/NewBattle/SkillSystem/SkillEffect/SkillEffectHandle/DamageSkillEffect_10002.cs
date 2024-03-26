
namespace Battle
{
    public class DamageSkillEffect_10002 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();

            NewGameData._FightManager.Attack(Args[0] / 1000, OriginEntity, TargetEntity);
        }
    }
}
