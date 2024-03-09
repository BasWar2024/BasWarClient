using System;
using System.Collections;
using DG.Tweening;
using UnityEngine;
using UnityEngine.Events;
[SerializeField]
public class DoTweener : MonoBehaviour {

    public enum Style {
        Once,
        Loop,
        Repeatedly,
        PingPong
    }
    //
    public Ease easeStyle = Ease.Linear;
    // ;
    public bool IsStartRun = true;
    public Style style = Style.Once;
    public bool isUseCustomEase;
    public AnimationCurve curve;
    //
    [Serializable]
    public class OnCompleteEvent : UnityEvent { }
    //  //Once type  
    [SerializeField]
    private OnCompleteEvent OnCompleted = new OnCompleteEvent ();

    // Tweener
    public delegate void DoTweenerComplete ();

    // Tweener
    public DoTweenerComplete OnComplete;

    void Reset () {

        StartValue ();
        EndValue ();

    }

    protected virtual void TweenAnim () {
        if (OnCompleted != null) {
            OnCompleted.Invoke ();
            OnCompleted.RemoveAllListeners ();
        }
    }
    void Awake () {
        if (OnComplete == null)
            OnComplete = TweenAnim;
        DoAwake ();
    }
    void Start () {
        if (IsStartRun)
            PlayForward ();
    }

    /// <summary>
    /// Update is called every frame, if the MonoBehaviour is enabled.
    /// </summary>
    void Update () {

        if (IsStartRun) {
            PlayForward ();
            IsStartRun = false;
        }

    }

    public virtual void DoAwake () { }
    public virtual void DoStart () { }
    public virtual void PlayForward () { }
    public virtual void PlayReverse () { }
    public virtual void Kill (Tweener tweener) { }
    protected virtual void StartValue () { }
    protected virtual void EndValue () { }

    public virtual void SetAlpha (float startalpha, float alpha, float animTime, DoTweener.Style style) {

    }
    public virtual void SetingTweener (Tweener _tweener) {
        if (_tweener != null) {
            if (isUseCustomEase) {
                _tweener.SetEase (curve);
            } else {
                _tweener.SetEase (easeStyle);
            }
        }
    }

    public virtual void InitHCTweener () {

    }

}