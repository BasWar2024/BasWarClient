using UnityEngine;
using System.Collections;
using DG.Tweening;
using UnityEngine.UI;

//UI
[SerializeField]
public class HCTweenTextAlpha :DoTweener {
    public float StartAlpha;
    public float EndAlpha;
    public float durtion = 1f;


    Text _text;
    Text text {
        get {
            if (_text == null) {
                _text = GetComponent<Text>();
                if (text == null)
                    Debug.LogError(" Text ");
            }         
            return _text;
        }
        set {
            _text = value;
        }
    }
    public float GetAlpha {
        get {
            return text.color.a;
        }
    }
    public override void PlayForward() {
        StyleFunction(StartAlpha, EndAlpha,durtion,style);
    }
    public override void PlayReverse() {
        StyleFunction(EndAlpha, StartAlpha, durtion, style);
    }
    void StyleFunction(float fromAlpha, float toAlpha, float animTime, DoTweener.Style style) {
        switch (style) {
            case Style.Once:
                One(fromAlpha, toAlpha);
                break;
            case Style.Loop:
                Loop(fromAlpha, toAlpha);
                break;
            case Style.Repeatedly:
                Repeatedly(fromAlpha, toAlpha);
                break;
            case Style.PingPong:
                PingPong(fromAlpha, toAlpha);
                break;
        }
    }
    void One(float fromAlpha, float toAlpha) {
        text.color = new Color(text.color.r, text.color.g, text.color.b, fromAlpha);
        Tweener tweener = DOTween.ToAlpha(() => text.color, x => text.color = x, toAlpha, durtion).OnComplete(() => OnComplete());
        SetingTweener(tweener);
    }
    void Repeatedly(float fromAlpha, float toAlpha) {
        text.color = new Color(text.color.r, text.color.g, text.color.b, fromAlpha);
        Tweener tweener = DOTween.ToAlpha(() => text.color, x => text.color = x, toAlpha, durtion).OnComplete(() => 
        {
            Tweener tweenerBBC = DOTween.ToAlpha(() => text.color, x => text.color = x, fromAlpha, durtion);
            SetingTweener(tweenerBBC);
        });
        SetingTweener(tweener);
    }
    void Loop(float fromAlpha, float toAlpha) {
        text.color = new Color(text.color.r, text.color.g, text.color.b, fromAlpha);
        Tweener tweener = DOTween.ToAlpha(() => text.color, x => text.color = x, EndAlpha, durtion).OnComplete(() => Loop(fromAlpha,toAlpha));
        SetingTweener(tweener);
    }
    void PingPong(float fromAlpha, float toAlpha) {
        Tweener tweener = DOTween.ToAlpha(() => text.color, x => text.color = x, toAlpha, durtion).OnComplete(() => PingPong(toAlpha, fromAlpha));
        SetingTweener(tweener);
    }

    protected override void StartValue() {
        if (text) {
            StartAlpha = text.color.a;
            EndAlpha = text.color.a;
            return;
        }

        Debug.Log("  TextMesh Alahp   ");
    }
}
