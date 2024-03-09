using System.Collections;
using DG.Tweening;
using UnityEngine;
[SerializeField]
public class HCTweenScale : DoTweener {

    public Vector3 formScale;
    public Vector3 toScale;
    public float animTime = 1f;
    Transform tr;
    Transform myTransform {
        get {
            if (tr == null)
                tr = transform;
            return tr;
        }
        set {
            tr = value;
        }
    }

    Vector3 Scale {
        get {
            return myTransform.localScale;
        }
    }

    public override void PlayForward () {
        StyleFunction (formScale, toScale);
    }
    public override void PlayReverse () {
        StyleFunction (toScale, formScale);
    }

    void StyleFunction (Vector3 from, Vector3 to) {
        switch (style) {
            case Style.Once:
                One (from, to);
                break;
            case Style.Loop:
                Loop (from, to);
                break;
            case Style.Repeatedly:
                Repeatedly (from, to);
                break;
            case Style.PingPong:
                PingPong (from, to);
                break;
        }
    }
    void One (Vector3 from, Vector3 to) {
        myTransform.localScale = from;
        Tweener tweener = myTransform.DOScale (to, animTime).OnComplete (() => OnComplete ());
        SetingTweener (tweener);
        tweener.SetUpdate (true);
    }
    void Repeatedly (Vector3 from, Vector3 to) {
        myTransform.localScale = from;
        Tweener tweener = myTransform.DOScale (to, animTime).OnComplete (() => {
            Tweener tweenerBBC = myTransform.DOScale (from, animTime);
            SetingTweener (tweenerBBC);
        });
        SetingTweener (tweener);
    }
    void Loop (Vector3 from, Vector3 to) {
        myTransform.localScale = from;
        Tweener tweener = myTransform.DOScale (to, animTime).OnComplete (() => Loop (from, to));
        SetingTweener (tweener);
    }
    void PingPong (Vector3 from, Vector3 to) {
        Tweener tweener = myTransform.DOScale (to, animTime).OnComplete (() => PingPong (to, from));
        SetingTweener (tweener);
    }

    protected override void StartValue () {
        formScale = Scale;
    }
    protected override void EndValue () {
        toScale = Scale;
    }
}