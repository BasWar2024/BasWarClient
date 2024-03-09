using System;
using System.Collections.Generic;
using UnityEngine;

public enum TimerStatus
{
    Pending,
    Active,
    Paused,
    Stop,
}

public class Timer : IComparable<Timer>
{
    private double _expireTime;     // 
    private double _pauseLeaveTime;     //
    private float _interval;                    // 
    private bool _loop;                 // 
    private int _maxCount;              //
    private int _curCount = 0;
    private Action _act;
// #if UNITY_EDITOR
//     public string stackInfo;
// #endif
    public uint id { get; set; }
    public double expireTime
    {
        get
        {
            return _expireTime;
        }
    }
    public bool isLoop
    {
        get
        {
            return _loop;
        }
    }

    public TimerStatus status { get; set; }

    public Timer(float delay, float interval, Action act, bool loop, int maxCount)
    {
        _interval = interval;
        _act = act;
        _loop = loop;
        _maxCount = maxCount;

        _expireTime = Time.time + delay;
        status = TimerStatus.Active;
// #if UNITY_EDITOR
//         var st = new System.Diagnostics.StackTrace(true);
//         var frame = st.GetFrame(2);
//         stackInfo = System.IO.Path.GetFileName(frame.GetFileName()) + "->" + frame.GetMethod().Name;
// #endif
    }

    public int CompareTo(Timer t)
    {
        return _expireTime.CompareTo(t._expireTime);
    }

    public void Reset()
    {
        _expireTime = Time.time + _interval;
    }

    public void Pause()
    {
        _pauseLeaveTime = _expireTime - Time.time;
    }

    public void Resume()
    {
        _expireTime = Time.time + _pauseLeaveTime;
    }

    public void Call()
    {
        if (status != TimerStatus.Active)
            return;

        _act();

        if (_loop)
        {
            ++ _curCount;
            if(_curCount == _maxCount && _maxCount > 0)
            {
                status = TimerStatus.Stop;
            }
            else
            {
                _expireTime += _interval;
            }
        }
        else
        {
            status = TimerStatus.Stop;
        }
    }
}


public class TimerMgr : MonoSingleton<TimerMgr>
{
    // timer id
    public static uint kInvalidTimerID = 0;

    private uint _autoID = kInvalidTimerID;
    private bool _dirty = false;

    private List<Timer> _allTimers = new List<Timer>();
    private bool _isFixedUpdate = false;
    List<int> deadTimers = new List<int>();

    public void Update()
    {
        // sort if dirty
        if (_dirty)
        {
            _allTimers.Sort();
            _dirty = false;
        }

        if (!_isFixedUpdate)
            Tick();
    }

    private void FixedUpdate()
    {
        if (_isFixedUpdate)
            Tick();
    }

    public void SetUpdateMode(bool isFixedUpdate)
    {
        _isFixedUpdate = isFixedUpdate;
    }


    //
    public uint StartLoopTimer(float delay, float interval, Action act, int maxCount = 0)
    {
        ++_autoID;

        Timer t = new Timer(delay, interval, act, true, maxCount);
        t.id = _autoID;
        _allTimers.Add(t);
        _dirty = true;

        return _autoID;
    }

    //
    public uint StartTimer(float interval, Action act)
    {
        ++_autoID;

        Timer t = new Timer(interval, interval, act, false, 1);
        t.id = _autoID;
        _allTimers.Add(t);
        _dirty = true;

        return _autoID;
    }

    private Timer FindTimer(uint id)
    {
        Timer t = _allTimers.Find((timer) => {
            return timer.id == id;
        });

        return t;
    }

    //timer
    public void RemoveTimer(uint id)
    {
        Timer t = _allTimers.Find((timer) =>
        {
            return timer.id == id;
        });

        if (t != null)
        {
            t.status = TimerStatus.Stop;
        }
    }

    private void PauseTimer(int id, bool pause)
    {
        Timer t = _allTimers.Find((timer) =>
        {
            return timer.id == id;
        });

        if (t != null)
        {
            TimerStatus lastStatus = t.status;

            t.status = pause ? TimerStatus.Paused : TimerStatus.Active;

            if (pause)
            {
                t.Pause();
            }

            // reset when resume
            if (!pause && lastStatus == TimerStatus.Paused)
            {
                t.Resume();
                _dirty = true;
            }
        }
    }

    //timer
    public void PauseTimer(int id)
    {
        PauseTimer(id, true);
    }

    //timer
    public void ResumeTimer(int id)
    {
        PauseTimer(id, false);
    }

    //
    public void ResetTimer(int id)
    {
        Timer t = _allTimers.Find((timer) =>
        {
            return timer.id == id;
        });

        if (t != null)
        {
            t.Reset();
            _dirty = true;
        }
    }

    private void Tick()
    {

        deadTimers.Clear();
        // tick
        for (int index = 0; index < _allTimers.Count; ++index)
        {
            Timer t = _allTimers[index];
            if (Time.time >= t.expireTime)
            {
// #if UNITY_EDITOR
//                 UnityEngine.Profiling.Profiler.BeginSample(t.stackInfo);
// #endif
                if (t.status == TimerStatus.Active)
                {
                    t.Call();
                    _dirty = true;
                }

                if (t.status == TimerStatus.Stop)
                {
                    deadTimers.Add(index);
                }
// #if UNITY_EDITOR
//                 UnityEngine.Profiling.Profiler.EndSample();
// #endif
                continue;
            }

            break;
        }

        // remove dead timers
        for (int index = deadTimers.Count - 1; index >= 0; --index)
        {
            int value = deadTimers[index];
            _allTimers.RemoveAt(value);
        }
    }
}