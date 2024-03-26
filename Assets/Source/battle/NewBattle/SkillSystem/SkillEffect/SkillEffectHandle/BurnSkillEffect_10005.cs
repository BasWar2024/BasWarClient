
namespace Battle
{
    public class BurnSkillEffect_10005 : SkillEffectBase
    {
        private Fix64 m_Value;
        public override void Start()
        {
            base.Start();

            m_Value = Args[0] / 1000;
            NewGameData._BuffManager.Burn(m_Value, Buff, null, TargetEntity);
        }

        public override void Update()
        {
            base.Update(); 
            NewGameData._FightManager.Attack(m_Value, OriginEntity, TargetEntity);
        }
    }
}
