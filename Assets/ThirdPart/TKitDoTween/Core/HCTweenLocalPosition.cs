using System.Collections;
using DG.Tweening;
using UnityEngine;
[SerializeField]
public class HCTweenLocalPosition : DoTweener {
    public Vector3 Form;
    public Vector3 To;
    public float MoveTime = 1f;
    Transform my;
    Transform myTransform {
        get {
            if (my == null)
                my = transform;
            return my;
        }
    }
    Vector3 position {
        get {
            return myTransform.localPosition;
        }
    }
    public override void PlayForward () {
        StyleFunction (this.Form, this.To);
    }
    public override void PlayReverse () {
        StyleFunction (this.To, this.Form);
    }

    public Tweener PlayForward_New () {
        return StyleFunction (this.Form, this.To);
    }
    public Tweener PlayReverse_New () {
        return StyleFunction (this.To, this.Form);
    }
    public override void Kill (Tweener tweener) {
        KillTween (tweener);
    }
    Tweener StyleFunction (Vector3 From, Vector3 To) {
        Tweener tweener = null;
        switch (style) {
            case Style.Once:
                tweener = One (From, To);
                break;
            case Style.Loop:
                tweener = Loop (From, To);
                break;
            case Style.Repeatedly:
                tweener = Repeatedly (From, To);
                break;
            case Style.PingPong:
                tweener = PingPong (From, To);
                break;
        }
        return tweener;
    }
    Tweener One (Vector3 From, Vector3 To) {
        myTransform.localPosition = From;
        Tweener tweener = myTransform.DOLocalMove (To, MoveTime).OnComplete (() => OnComplete ());
        SetingTweener (tweener);
        return tweener;
    }
    Tweener Repeatedly (Vector3 From, Vector3 To) {
        myTransform.localPosition = From;
        Tweener tweener = myTransform.DOLocalMove (To, MoveTime).OnComplete (() => {
            Tweener tweenerBBC = myTransform.DOLocalMove (Form, MoveTime);
            SetingTweener (tweenerBBC);
        });
        SetingTweener (tweener);
        return tweener;
    }
    Tweener Loop (Vector3 From, Vector3 To) {
        myTransform.localPosition = From;
        Tweener tweener = myTransform.DOLocalMove (To, MoveTime).OnComplete (() => Loop (Form, To));
        SetingTweener (tweener);
        return tweener;
    }
    Tweener PingPong (Vector3 From, Vector3 To) {
        Tweener tweener = myTransform.DOLocalMove (To, MoveTime).OnComplete (() => PingPong (To, From));
        SetingTweener (tweener);
        return tweener;
    }
    void KillTween (Tweener tweener) {
        tweener.Kill ();
    }
    protected override void StartValue () {
        Form = this.position;
    }
    protected override void EndValue () {
        To = this.position;
    }

}