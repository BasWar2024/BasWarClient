
namespace Battle
{
    public class HealBuffSkillEffect_15001 : SkillEffectBase
    {
        private Fix64 m_Cure;
        public override void Start()
        {
            base.Start();
            m_Cure = OriginEntity.FixOriginHp * (Args[0] / 1000);
            NewGameData._BuffManager.Cure(m_Cure, Buff, OriginEntity, TargetEntity);
        }

        public override void Update()
        {
            base.Update();
            NewGameData._BuffManager.Cure(m_Cure, null, OriginEntity, TargetEntity);
        }
    }
}
