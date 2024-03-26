

namespace Battle
{
    public class BloodthirstySkillEffect_10006 : SkillEffectBase
    {
        private Fix64 m_Atk;
        private Fix64 m_Heal; //""
        public override void Start()
        {
            base.Start();
            m_Atk = OriginEntity.GetFixAtk() * (Args[0] / 1000);
            m_Heal = OriginEntity.GetFixAtk() * (Args[1] / 1000);
            NewGameData._FightManager.Attack(m_Atk, OriginEntity, TargetEntity);
            NewGameData._FightManager.Cure(m_Heal, OriginEntity);
        }
    }
}
