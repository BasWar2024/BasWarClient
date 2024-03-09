
using System;
using UnityEngine;
using DG.Tweening;

public class UITweenScale : MonoBehaviour
{
    public float _startScale = 0f;
    public float _nextScale = 1.2f;
    public float _endScale = 1f;
    public float _startDuration = 0.2f;
    public float _endDuration = 0.1f;
    public Ease _startEaseType = Ease.Linear;
    public Ease _endEaseType = Ease.Linear;

    public void TweenScale()
    {
        RectTransform obj = transform as RectTransform;

        obj.localScale = Vector3.one * _startScale;
        Tweener tween = obj.DOScale(_nextScale, _startDuration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(_startEaseType);
        tween.OnComplete(() => {
            ScaleEnd();
        });
    }

    private void ScaleEnd()
    {
        RectTransform obj = transform as RectTransform;

        obj.localScale = Vector3.one * _nextScale;
        Tweener tween = obj.DOScale(_endScale, _endDuration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(_endEaseType);
    }
}