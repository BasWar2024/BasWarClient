
namespace Battle
{
    public class ShieldMaxHpEffectSkillEffect_24012 : SkillEffectBase
    {   
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.Shield(OriginEntity.GetFixMaxHp() * (Args[0] / 1000), Buff, null, TargetEntity);
           
        }
    }
}
