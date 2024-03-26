
namespace Battle
{
    public class AddAtkEffectSkillEffect_22000 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.AddAtk(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
