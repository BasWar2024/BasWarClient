
namespace Battle
{
    public class PercentageDamageSkillEffect_10004 : SkillEffectBase
    {
        private Fix64 m_Percentage;

        public override void Start()
        {
            base.Start();
            m_Percentage = Args[0] / 1000;
            NewGameData._FightManager.Attack(TargetEntity.GetFixMaxHp() * m_Percentage, OriginEntity, TargetEntity);
        }

        public override void Update()
        {
            base.Update();
            NewGameData._FightManager.Attack(TargetEntity.GetFixMaxHp() * m_Percentage, OriginEntity, TargetEntity);
        }
    }
}
