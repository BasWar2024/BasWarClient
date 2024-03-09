using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public sealed class CoTask
{
    private static ulong _autoID = 1;

    private IEnumerator  _routine;
    private Func<bool> _conditionFunc;
    private Action<bool> _finishAction;

    private bool _running;
    private bool _paused;

    public string name { get; private set; }

    public CotaskType type { get; private set; }
#if DEBUG
    string stackInfo;
#endif

    public CoTask(IEnumerator routine, Func<bool> conditionFunc = null, string ext = "", CotaskType taskType =  CotaskType.None, Action<bool> act = null)
    {

        name = string.Format("{0}, ID: {1}", ext, _autoID++);
        type = taskType;
#if DEBUG
        var st = new System.Diagnostics.StackTrace(true);
        var frame = st.GetFrame(1);
        stackInfo = System.IO.Path.GetFileName(frame.GetFileName()) + "->" + frame.GetMethod().Name;
#endif
        _routine = routine;
        _conditionFunc = conditionFunc;
        _finishAction = (value) => {
            Release();

            if (act != null)
            {
                act(value);
            }
        };

        _running = false;
        _paused = false;
        Start();
    }

    private void Release()
    {
        CoTaskMgr.instance.RemoveTask(name);
    }

    public void Start()
    {
        _running = true;
        CoTaskMgr.instance.AddTask(this);
    }

    public void Stop()
    {
        _paused = true;
        _running = false;
        _finishAction(false);
    }

    public void Pause()
    {
        _paused = true;
    }

    public void Resume()
    {
        _paused = false;
    }

    public IEnumerator TaskImpl()
    {

        if (_conditionFunc != null)
            yield return new WaitUntil(_conditionFunc);

        while (_running)
        {
#if DEBUG
            UnityEngine.Profiling.Profiler.BeginSample(stackInfo);
#endif
            if (_paused)
            {
#if DEBUG
                UnityEngine.Profiling.Profiler.EndSample();
#endif
                yield return null;
            }
            else
            {

                if (_routine != null && _routine.MoveNext())
                {
#if DEBUG
                    UnityEngine.Profiling.Profiler.EndSample();
#endif
                    yield return _routine.Current;
                }
                else
                {
                    _running = false;
                    _finishAction(true);
#if DEBUG
                    UnityEngine.Profiling.Profiler.EndSample();
#endif
                }
            }
         }
    }
}

public enum CotaskType
{
    None = 0,
    Fight = 1,
}

public class CoTaskMgr : MonoSingleton<CoTaskMgr>
{
    private Dictionary<string, CoTask> _tasks = new Dictionary<string, CoTask>();

    public void AddTask(CoTask task)
    {
        if (_tasks.ContainsKey(task.name))
        {
            task.Resume();
        }
        else
        {
            _tasks.Add(task.name, task);
            StartCoroutine(task.TaskImpl());
        }
    }

    public void RemoveTask(string name)
    {
        _tasks.Remove(name);
    }

    public void Clear()
    {
        foreach (var task in _tasks.Values)
        {
            // clear 
            task.Stop();
        }

        _tasks.Clear();
    }

    public void StopTasks(CotaskType type)
    {
        List<CoTask> tasks = new List<CoTask>();
        foreach (var task in _tasks.Values)
        {
            if (task.type == type)
            {
                tasks.Add(task);
            }
        }
        foreach (var item in tasks)
        {
            item.Stop();
        }
        tasks.Clear();
    }
}