
namespace Battle
{
    public class BounceAtkSkillEffect_24014 : SkillEffectBase
    {
        private Fix64 m_Value;
        public override void Start()
        {
            base.Start();

            NewGameData._BuffManager.BounceAtk(Buff, OriginEntity, TargetEntity);
            m_Value = Args[0] / 1000;
            TargetEntity.BeAtkAction += BounceAtk;
        }

        private void BounceAtk(EntityBase atker, Fix64 atk)
        {
            if (atker == null)
                return;

            if (TargetEntity != null)
            {
                NewGameData._FightManager.Attack(atk * m_Value, TargetEntity, atker);
            }
        }

        public override void Leave()
        {
            if (TargetEntity != null)
            {
                TargetEntity.BeAtkAction -= BounceAtk;
            }
            base.Leave();
        }
    }
}
