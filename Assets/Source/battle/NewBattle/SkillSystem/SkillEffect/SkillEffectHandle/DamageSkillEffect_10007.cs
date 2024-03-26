

namespace Battle
{
    public class DamageSkillEffect_10007 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();

            NewGameData._FightManager.Attack(OriginEntity.GetFixAtk() * (Args[0] / 1000), OriginEntity, TargetEntity);
        }
    }
}         
