using UnityEngine;
using System.Collections;
using DG.Tweening;
using UnityEngine.UI;

//UI
[SerializeField]
public class HCTweenAlpha : DoTweener
{
    public float StartAlpha;
    public float EndAlpha;
    public float durtion = 1f;

    Image _sprite;
    Image sprite
    {
        get
        {
            if (_sprite == null)
            {
                _sprite = gameObject.GetComponent<Image>();
            }
            return _sprite;
        }
        set
        {
            _sprite = value;
        }
    }
    public float GetAlpha
    {
        get
        {
            return sprite.color.a;
        }
    }


    bool Forward = true;
    public override void PlayForward()
    {
        Forward = true;
        StyleFunction(StartAlpha, EndAlpha, durtion, style);
    }
    public override void PlayReverse()
    {
        Forward = false;
        StyleFunction(EndAlpha, StartAlpha, durtion, style);
    }

    void StyleFunction(float fromAlpha, float toAlpha, float animTime, DoTweener.Style style)
    {
        if (sprite == null)
        {
            Des();
            return;
        }
        switch (style)
        {
            case Style.Once:
                One(fromAlpha, toAlpha, animTime);
                break;
            case Style.Loop:
                Loop(fromAlpha, toAlpha, animTime);
                break;
            case Style.Repeatedly:
                Repeatedly(fromAlpha, toAlpha, animTime);
                break;
            case Style.PingPong:
                PingPong(fromAlpha, toAlpha, animTime);
                break;
        }
    }
    void One(float fromAlpha, float toAlpha, float time)
    {
        sprite.color = new Color(sprite.color.r, sprite.color.g, sprite.color.b, fromAlpha);
        Tweener tweener = DOTween.ToAlpha(() => sprite.color, x => sprite.color = x, toAlpha, time).OnComplete(() => OnComplete());
        SetingTweener(tweener);
    }
    void Repeatedly(float fromAlpha, float toAlpha, float time)
    {
        sprite.color = new Color(sprite.color.r, sprite.color.g, sprite.color.b, fromAlpha);

        Tweener tweener = DOTween.ToAlpha(() => sprite.color, x => sprite.color = x, toAlpha, time).OnComplete(() =>
       {
           Tweener tweenerBBC = DOTween.ToAlpha(() => sprite.color, x => sprite.color = x, fromAlpha, time);
           SetingTweener(tweenerBBC);
       }
        );
        SetingTweener(tweener);
    }
    void Loop(float fromAlpha, float toAlpha, float time)
    {
        sprite.color = new Color(sprite.color.r, sprite.color.g, sprite.color.b, fromAlpha);
        Tweener tweener = DOTween.ToAlpha(() => sprite.color, x => sprite.color = x, EndAlpha, time).OnComplete(() => Loop(fromAlpha, toAlpha, time));
        SetingTweener(tweener);
    }
    void PingPong(float fromAlpha, float toAlpha, float time)
    {
        Tweener tweener = DOTween.ToAlpha(() => sprite.color, x => sprite.color = x, toAlpha, time).OnComplete(() => PingPong(toAlpha, fromAlpha, time));
        SetingTweener(tweener);
    }

    protected override void StartValue()
    {
        if (sprite)
        {
            StartAlpha = sprite.color.a;
            EndAlpha = sprite.color.a;
            return;
        }
    }

    void Des()
    {
        Destroy(GetComponent<HCTweenAlpha>(), 1f);
        HCTweenTextAlpha text = gameObject.AddComponent<HCTweenTextAlpha>();
        text.StartAlpha = this.StartAlpha;
        text.EndAlpha = this.EndAlpha;
        text.durtion = this.durtion;
        text.style = this.style;
        text.IsStartRun = this.IsStartRun;
        if (Forward)
            text.PlayForward();
        else
            text.PlayReverse();

    }
}
