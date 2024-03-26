

namespace Battle
{
    public class AtkAddAtk_22004 : SkillEffectBase
    {
        private Fix64 m_Atk;
        private Fix64 m_AddAtk;
        private Fix64 m_CurAddTime; //""
        private Fix64 m_MaxAddTime; //""

        public override void Start()
        {
            base.Start();
            m_Atk = Fix64.Zero;
            m_AddAtk = TargetEntity.GetFixAtk() * (Args[0] / 1000);
            m_MaxAddTime = Args[1];
            m_CurAddTime = Fix64.Zero;
            TargetEntity.AtkAction += AddAtk;
            TargetEntity.ChangeAtkTargetAction += ChangeAtkTarget;
        }

        public override void Leave()
        {
            if(TargetEntity != null)
            {
                TargetEntity.AtkAction -= AddAtk;
                TargetEntity.ChangeAtkTargetAction -= ChangeAtkTarget;
            }
            base.Leave();
        }

        public void AddAtk()
        {
            m_CurAddTime += Fix64.One;
            if (m_CurAddTime <= m_MaxAddTime)
            {
                m_Atk += m_AddAtk;
                NewGameData._BuffManager.AddNoBuffAtk(m_AddAtk, null, TargetEntity);
            }
        }

        public void ChangeAtkTarget()
        {
            NewGameData._BuffManager.AddNoBuffAtk(-m_Atk, null, TargetEntity);
            m_Atk = Fix64.Zero;
            m_CurAddTime = Fix64.Zero;
        }
    }

}