
namespace Battle
{
    public class AtkSpeedSkillEffect_20000 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.AddAtkSpeed(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
