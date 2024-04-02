
namespace Battle
{
    using System;

    public class TimerManager
    {
        private Action<Fix64> m_UpdateCallBack;

        public void OnUpdate(Fix64 currTime)
        {
            if (m_UpdateCallBack != null)
            {
                m_UpdateCallBack(currTime);
            }
        }

        public void CreateTimer(Action callBack, Fix64 delay, Fix64 startTime)
        {
            FixTimer timer = new FixTimer(callBack, delay, startTime);
            m_UpdateCallBack += timer.OnUpdate;
        }

        public void RemoveTimerCallBack(Action<Fix64> timerCallBack)
        {
            m_UpdateCallBack -= timerCallBack;
        }
    }
}
