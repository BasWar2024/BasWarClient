using UnityEngine;
using System.Collections;
using DG.Tweening;
[SerializeField]
public class HCTweenPosition : DoTweener{
    public Vector3 Form;
    public Vector3 To;
    public float   MoveTime=1f;
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
    public override void PlayForward() {
        StyleFunction(this.Form, this.To);
    }
    public override void PlayReverse() {
        StyleFunction(this.To, this.Form);
    }
    void StyleFunction(Vector3 From, Vector3 To) {
        switch (style) {
            case Style.Once:
                One(From, To);
                break;
            case Style.Loop:
                Loop(From, To);
                break;
            case Style.Repeatedly:
                Repeatedly(From, To);
                break;
            case Style.PingPong:
                PingPong(From, To);
                break;
        }
    }
    void One(Vector3 From, Vector3 To) {
        myTransform.localPosition = From;
        Tweener tweener = myTransform.DOLocalMove(To, MoveTime).OnComplete(() => OnComplete());
        SetingTweener(tweener);
    }
    void Repeatedly(Vector3 From,Vector3 To) {
        myTransform.localPosition = From;
        Tweener tweener = myTransform.DOLocalMove(To, MoveTime).OnComplete(() => 
        {
            Tweener tweenerBBC = myTransform.DOLocalMove(Form, MoveTime);
            SetingTweener(tweenerBBC);
        });
        SetingTweener(tweener);
    }
    void Loop(Vector3 From, Vector3 To) {
        myTransform.localPosition = From;
        Tweener tweener = myTransform.DOLocalMove(To, MoveTime).OnComplete(() => Loop(Form, To));
        SetingTweener(tweener);
    }
    void PingPong(Vector3 From, Vector3 To) {
        Tweener tweener = myTransform.DOLocalMove(To, MoveTime).OnComplete(() => PingPong(To, From));
        SetingTweener(tweener);
    }
    protected override void StartValue() {
        Form = this.position;
    }
    protected override void EndValue() {
        To = this.position;
    }
}
