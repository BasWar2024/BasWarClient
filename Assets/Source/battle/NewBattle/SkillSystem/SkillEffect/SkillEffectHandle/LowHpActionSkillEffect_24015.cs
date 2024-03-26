

namespace Battle
{
    public class LowHpActionSkillEffect_24015 : SkillEffectBase
    {
        private Fix64 m_LowHp;
        public override void Start()
        {
            base.Start();
            m_LowHp = (Args[0] / 1000) * TargetEntity.GetFixMaxHp();
            TargetEntity.LowHpAction += DoAction;
        }

        private void DoAction(Fix64 hp)
        {
            if (hp > m_LowHp)
                return;

            if (TargetEntity != null)
            {
                base.DoNextSkillEffect();
                if (Buff != null)
                    Buff.IsEnd = true;

                if (TargetEntity != null)
                {
                    TargetEntity.LowHpAction -= DoAction;
                }
            }
        }

        public override void Leave()
        {
            if (TargetEntity != null)
            {
                TargetEntity.LowHpAction -= DoAction;
            }
            base.Leave();
        }

        public override void DoNextSkillEffect()
        {
            
        }
    }
}
