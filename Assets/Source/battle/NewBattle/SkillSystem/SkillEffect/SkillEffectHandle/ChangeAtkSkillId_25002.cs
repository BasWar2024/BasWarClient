
namespace Battle
{
    //""CD""buff""，""buff""buff,""
    public class ChangeAtkSkillId_25002 : SkillEffectBase
    {
        private int m_OriginAtkSkillId;
        
        public override void Start()
        {
            base.Start();
            m_OriginAtkSkillId = TargetEntity.AtkSkillId;
            TargetEntity.AtkSkillId = skillCfgId;

            NewGameData._BuffManager.AddOrderBuff(Buff, null, TargetEntity);
        }

        public override void Leave()
        {
            if (TargetEntity != null)
            {
                TargetEntity.AtkSkillId = m_OriginAtkSkillId;
            }
            base.Leave();
        }
    }
}
