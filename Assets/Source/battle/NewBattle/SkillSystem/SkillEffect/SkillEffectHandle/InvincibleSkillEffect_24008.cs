
namespace Battle
{
    public class InvincibleSkillEffect_24008 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.Invincible(Buff, null, TargetEntity);
        }
    }
}
