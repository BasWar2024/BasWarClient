
namespace Battle
{
    public class RebuildSkillEffect_24013 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            Fix64 value = Args[0] / 1000;
            OriginEntity.FixHp = OriginEntity.FixOriginHp * value;
        }
    }
}
