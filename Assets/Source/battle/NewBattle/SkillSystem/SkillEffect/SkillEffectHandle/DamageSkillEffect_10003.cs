
namespace Battle
{
    //""
    public class DamageSkillEffect_10003 : SkillEffectBase
    {
        private Fix64 m_Damage;
        private Fix64 m_Damping;
        private int m_JumpNum;

        public override void Init(SkillEffectModel model, EntityBase originEntity, EntityBase targetEntity, Buff buff,
            params Fix64[] args)
        {
            base.Init(model, originEntity, targetEntity, buff, args);

            m_JumpNum = (int)args[0];
        }

        public override void Start()
        {
            base.Start();
            m_Damage = Args[0] / 1000 * OriginEntity.GetFixAtk();
            m_Damping = Args[1] / 1000;
            var damge = JumpingDamage();
            NewGameData._FightManager.Attack(damge, OriginEntity, TargetEntity);
        }

        private Fix64 JumpingDamage()
        {
            Fix64 damge = m_Damage;
            damge = damge - m_Damping * m_JumpNum * damge;

            return damge;
        }
    }
}
