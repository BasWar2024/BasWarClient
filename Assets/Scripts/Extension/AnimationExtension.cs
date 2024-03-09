using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class AnimationExtension {
    public static float GetClipLength (this Animation anim, string clipName) {
        return anim[clipName].length;
    }

    public static void ForwardPlay (this Animation anim, string clipName) {
        var clip = anim[clipName];
        if (clip == null) {
            Debug.LogError (" " + anim.gameObject.name + " clipName " + clipName);
            return;
        }
        clip.time = 0;
        clip.speed = 1;
        anim.Play (clipName);
    }

    /// <summary>
    /// Unity  Playing 
    /// Stop Playing 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="clipName"></param>
    public static void BackwardPlay (this Animation anim, string clipName, bool useCurrentTime = false) {
        var clip = anim[clipName];
        if (clip == null) {
            Debug.LogError (" " + anim.gameObject.name + " clipName " + clipName);
            return;
        }

        var startTime = anim.GetClipLength (clipName);
        if (useCurrentTime) {
            if (clip.time > 0) {
                startTime = clip.time;
            }
        }
        clip.time = startTime;
        clip.speed = -1;
        anim.Play (clipName);
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="name"></param>
    public static void ResetAnimToFirst (this Animation anim, string name) {
        AnimationState state = anim[name];
        anim.Play (name);
        state.time = 0;
        anim.Sample ();
        state.enabled = false;
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="name"></param>
    public static void ResetAnimToLast (this Animation anim, string name) {
        AnimationState state = anim[name];
        anim.Play (name);
        state.time = anim[name].length;
        anim.Sample ();
        state.enabled = false;
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="clipName"></param>
    /// <param name="methodName"></param>
    /// <param name="eventTime"></param>
    public static void AddEventRuntime (this Animation anim, string clipName, string methodName, float eventTime) {
        if (anim.GetClipCount () <= 0) return;
        var clip = anim.GetClip (clipName);
        if (IsContainAnimEvent (clip, methodName)) return;
        clip.AddEvent (new AnimationEvent { time = eventTime, functionName = methodName, stringParameter = clipName });
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="clipName"></param>
    /// <param name="methodName"></param>
    public static void AddEventEnding (this Animation anim, string clipName, string methodName) {
        if (anim.GetClipCount () <= 0) return;
        var clip = anim.GetClip (clipName);
        if (IsContainAnimEvent (clip, methodName)) return;
        clip.AddEvent (new AnimationEvent { time = clip.length, functionName = methodName, stringParameter = clipName });
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="clipName"></param>
    /// <param name="methodName"></param>
    public static void AddEventStarting (this Animation anim, string clipName, string methodName) {
        if (anim.GetClipCount () <= 0) return;
        var clip = anim.GetClip (clipName);
        if (IsContainAnimEvent (clip, methodName)) return;
        clip.AddEvent (new AnimationEvent { time = 0, functionName = methodName, stringParameter = clipName });
    }

    public static void AddAnimEventInSometime (this Animation anim, string clipName, string methodName, float _time) {
        if (anim.GetClipCount () <= 0) return;
        var clip = anim.GetClip (clipName);
        if (IsContainAnimEvent (clip, methodName)) return;
        clip.AddEvent (new AnimationEvent { time = _time, functionName = methodName, stringParameter = clipName });
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="animationClip"></param>
    /// <param name="methodName"></param>
    /// <returns></returns>
    static bool IsContainAnimEvent (AnimationClip animationClip, string methodName) {
        // anim.GetClip
        foreach (var item in animationClip.events) {
            if (item.functionName == methodName) {
                return true;
            }
        }
        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="clipName"></param>
    /// <returns></returns>
    public static float GetAnimationTime (this Animation anim, string clipName) {
        return anim[clipName].time;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="clipName"></param>
    /// <returns></returns>
    public static float GetAnimationSpeed (this Animation anim, string clipName) {
        return anim[clipName].speed;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="clipName"></param>
    /// <returns></returns>
    public static void SetAnimationSpeed (this Animation anim, string clipName, float speed) {
        anim[clipName].speed = speed;
    }
}