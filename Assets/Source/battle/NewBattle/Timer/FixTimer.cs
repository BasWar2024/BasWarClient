
namespace Battle
{
    using System;

    public class FixTimer
    {
        private Action m_CallBack;
        private Fix64 m_Delay;
        private Fix64 m_StartTime;

        public FixTimer(Action callBack, Fix64 delay, Fix64 startTime)
        {
            m_CallBack = callBack;
            m_Delay = delay;
            m_StartTime = startTime;
        }

        public void OnUpdate(Fix64 time)
        {
            if (time - m_StartTime >= m_Delay)
            {
                m_CallBack();
                NewGameData._TimerManager.RemoveTimerCallBack(OnUpdate);
            }
        }
    }
}
