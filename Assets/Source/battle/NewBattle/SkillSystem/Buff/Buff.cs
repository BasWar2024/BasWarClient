
namespace Battle
{
    using System;
    using System.Collections.Generic;

    public class Buff
    {
        public int CfgId;
        public string Name;
        public string Model;
        
        public Fix64 LifeTime;
        public Fix64 Frequency;

        public EntityBase OriginEntity; //buff""
        public EntityBase TargetEntity; //""buff""

        public bool IsEnd;
        private Fix64 m_Time;
        public Fix64 TotalTime;

        public int SkillEffId;

        private SkillEffectBase m_SkillEffect;

        public void Init()
        {
            m_SkillEffect = null;
            m_Time = Fix64.Zero;
            TotalTime = Fix64.Zero;
            IsEnd = false;
            CfgId = 0;
            TargetEntity = null;
            OriginEntity = null;
        }

        public void Start()
        {
            m_Time = Fix64.Zero;
            m_SkillEffect = NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffId, this, OriginEntity, TargetEntity);

            if (LifeTime >= (Fix64)999)
            {
                NewGameData._BuffManager.AddOrderBuff(this, null, TargetEntity);
            }
        }

        public void UpdateLogic()
        {
            if (IsEnd)
                return;

            TotalTime += NewGameData._FixFrameLen;

            if (Frequency > 0)
            {
                m_Time += NewGameData._FixFrameLen;
                if (m_Time >= Frequency)
                {
                    m_Time -= Frequency;
                    m_SkillEffect?.Update();
                }
            }

            if (TotalTime >= LifeTime)
            {
                IsEnd = true;
                //Release();
                return;
            }
        }

        public void ReSetTime()
        {
            TotalTime = Fix64.Zero;
        }

        public void Release()
        {
#if _CLIENTLOGIC_

            TargetEntity?.UpdateEntityMessage();
#endif
            m_SkillEffect?.Leave();
            m_SkillEffect = null;
            OriginEntity = null;
            TargetEntity = null;

            CfgId = 0;
            Name = "";
            Model = null;

            LifeTime = Fix64.Zero;
            Frequency = Fix64.Zero;
            IsEnd = true;

            //buff""bug，""
            //NewGameData._PoolManager.Push(this);
        }
    }
}
