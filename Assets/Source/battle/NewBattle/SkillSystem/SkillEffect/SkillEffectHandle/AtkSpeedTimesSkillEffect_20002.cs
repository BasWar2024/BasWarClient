
namespace Battle
{
    public class AtkSpeedTimesSkillEffect_20002 : SkillEffectBase
    {
        private Fix64 m_AtkTimes;

        public override void Start()
        {
            base.Start();
            m_AtkTimes = Args[0];
            TargetEntity.BeforeAtkAction += DecreaseAtkTimesBuffTimes;
            NewGameData._BuffManager.AddAtkSpeed((Fix64)0.99, Buff, null, TargetEntity);
        }

        public void DecreaseAtkTimesBuffTimes()
        {
            m_AtkTimes -= Fix64.One;
            if (m_AtkTimes <= Fix64.Zero)
            {
                if(Buff != null)
                    Buff.IsEnd = true;

                if (TargetEntity != null)
                {
                    TargetEntity.BeforeAtkAction -= DecreaseAtkTimesBuffTimes;
#if _CLIENTLOGIC_
                    if (TargetEntity.SpineAnim != null)
                    {
                        TargetEntity.SpineAnim.timeScale = 1;
                    }
#endif
                }
            }
        }
    }
}
