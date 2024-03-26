
namespace Battle
{
    public class BurnSkillEffect_10008 : SkillEffectBase
    {
        private Fix64 m_value;
        public override void Start()
        {
            base.Start();
            m_value = OriginEntity.GetFixAtk() * (Args[0] / 1000);
            NewGameData._BuffManager.Burn(m_value, Buff, null, TargetEntity);
        }

        public override void Update()
        {
            base.Update();
            NewGameData._FightManager.Attack(m_value, OriginEntity, TargetEntity);
        }
    }
}
