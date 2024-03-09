using UnityEngine;
using System.Collections;
using DG.Tweening;
[SerializeField]
public class HCTweenLocalRotation : DoTweener
{
    public Vector3 Form;
    public Vector3 To;
    public float MoveTime = 1f;
    Transform my;
    Tweener mtweener;
    Transform myTransform
    {
        get
        {
            if (my == null)
                my = transform;
            return my;
        }
    }
    Quaternion rotation
    {
        get
        {
            return myTransform.rotation;
        }
    }
    public override void PlayForward()
    {
        if (mtweener == null)
        {
            StyleFunction(this.Form, this.To);
        }
    }
    public override void PlayReverse()
    {
        StyleFunction(this.To, this.Form);
    }
    void StyleFunction(Vector3 From, Vector3 To)
    {
        switch (style)
        {
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
    void One(Vector3 From, Vector3 To)
    {
        myTransform.rotation = Quaternion.Euler(From);
        mtweener = myTransform.DORotate(To, MoveTime).OnComplete(() => OnComplete());
        SetingTweener(mtweener);
    }
    void Repeatedly(Vector3 From, Vector3 To)
    {
        myTransform.rotation = Quaternion.Euler(From);
        mtweener = myTransform.DORotate(To, MoveTime).OnComplete(() =>
        {
            Tweener tweenerBBC = myTransform.DORotate(Form, MoveTime);
            SetingTweener(tweenerBBC);
        });
        SetingTweener(mtweener);
    }
    void Loop(Vector3 From, Vector3 To)
    {
        myTransform.rotation = Quaternion.Euler(From);
        mtweener = myTransform.DORotate(To, MoveTime).OnComplete(() => Loop(Form, To));
        SetingTweener(mtweener);
    }
    void PingPong(Vector3 From, Vector3 To)
    {
        mtweener = myTransform.DORotate(To, MoveTime).OnComplete(() => PingPong(To, From));
        SetingTweener(mtweener);
    }
    protected override void StartValue()
    {
        Form = this.rotation.eulerAngles;
    }
    protected override void EndValue()
    {
        To = this.rotation.eulerAngles;
    }
}
