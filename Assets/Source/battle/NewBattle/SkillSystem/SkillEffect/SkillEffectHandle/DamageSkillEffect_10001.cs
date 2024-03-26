
namespace Battle
{
    public class DamageSkillEffect_10001 : SkillEffectBase
    {

        public override void Start()
        {
            base.Start();

            NewGameData._FightManager.Attack(OriginEntity.GetFixAtk(), OriginEntity, TargetEntity);
        }
    }
}
