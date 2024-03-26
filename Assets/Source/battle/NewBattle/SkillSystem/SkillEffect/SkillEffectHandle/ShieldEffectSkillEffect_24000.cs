
namespace Battle
{
    public class ShieldEffectSkillEffect_24000 : SkillEffectBase
    {   
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.Shield(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
