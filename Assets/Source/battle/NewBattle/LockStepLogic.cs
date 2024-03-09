//
// @brief: 
// @version: 1.0.0
// @author helin
// @date: 8/20/2018
// 
// 
//

namespace Battle
{
    public class LockStepLogic
    {
        //
        public float FAccumilatedTime = 0;

        //
        private float m_fNextGameTime = 0;

        //
        private float m_fFrameLen;

        //
        private NewBattleLogic m_CallUnit = null;

        //
        private float m_fInterpolation = 0;

        //public LockStepLogic()
        //{
        //    Init();
        //}

        public void Init()
        {
            m_fFrameLen = (float)NewGameData._FixFrameLen;
            NewGameData._CumTime = 0;
            NewGameData._Time = 0;

            FAccumilatedTime = 0;

            m_fNextGameTime = 0;

            m_fInterpolation = 0;
        }

        public void UpdateLogic()
        {
            float deltaTime = 0;
#if _CLIENTLOGIC_
            deltaTime = UnityEngine.Time.deltaTime;
#else
        deltaTime = 0.1f;
#endif

            /***********************************/
            FAccumilatedTime = FAccumilatedTime + deltaTime;
            NewGameData._CumTime += deltaTime;

            if (NewGameData._CumTime >= 1)
            {
                NewGameData._CumTime -= 1;

                if (m_CallUnit.Stage == BattleStage.ReadyBattle)
                {
                    NewGameData._Time = NewGameData._MaxReadyTime - FAccumilatedTime;
                }
                else if(m_CallUnit.Stage == BattleStage.InBattle)
                {
                    NewGameData._Time = NewGameData._MaxBattleTime - FAccumilatedTime;
                }

                //LUA
                m_CallUnit.UpdateTime1Sec();
            }

            //,,
            while (FAccumilatedTime > m_fNextGameTime)
            {

                //
                if(m_CallUnit.Stage == BattleStage.InBattle)
                    m_CallUnit.FrameLockLogic();

                //
                m_fNextGameTime += m_fFrameLen;

                //
                NewGameData._UGameLogicFrame += 1;
            }

            //,
            m_fInterpolation = (FAccumilatedTime + m_fFrameLen - m_fNextGameTime) / m_fFrameLen;

            //
            if (m_CallUnit.Stage == BattleStage.InBattle)
                m_CallUnit.UpdateRenderPosition(m_fInterpolation);
            //m_CallUnit.UpdateRenderRotation(m_fInterpolation);
            /***********************************/
        }

        //- 
        // 
        // @param unit 
        // @return none
        public void SetCallUnit(NewBattleLogic unit)
        {
            m_CallUnit = unit;
        }
    }
}
