using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(LayoutGroup))]
public class LayoutTween : MonoBehaviour
{
    //""
    public float _showDuration = 0.3f;
    public float _startScale = 0f;
    public float _nextScale = 1.2f;
    public float _endScale = 1f;
    public float _startDuration = 0.2f;
    public float _endDuration = 0.1f;
    public Ease _startEaseType = Ease.Linear;
    public Ease _endEaseType = Ease.Linear;
    public bool _isPlayAudio = false;

    private int _childCount;
    private Transform _cachedTransform;

    void Awake ()
    {
        _cachedTransform = transform;
    }

    private void OnEnable()
    {
        PlayTween();
    }

    public void PlayTween()
    {
        _childCount = _cachedTransform.childCount;

        for (int i = 0; i < _childCount; i++)
        {
            _cachedTransform.GetChild(i).GetChild(0).gameObject.SetActive(false);
        }
        StartCoroutine(ItemWaitShow());
    }

    IEnumerator ItemWaitShow()
    {
        yield return null;
        YieldInstruction wait = new WaitForSeconds(_showDuration);
        for (int i = 0; i < _childCount; i++)
        {
            _cachedTransform.GetChild(i).GetChild(0).gameObject.SetActive(true);
            TweenScale(_cachedTransform.GetChild(i).GetComponent<RectTransform>());
            yield return wait;
        }
    }

    private void TweenScale(RectTransform movedTrans, TweenCallback callback = null)
    {
        movedTrans.localScale = Vector3.one * _startScale;
        Tweener tween = movedTrans.DOScale(_nextScale, _startDuration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(_startEaseType);
        tween.OnComplete( () => {
            ScaleEnd(movedTrans, callback);
        });
    }

    private void ScaleEnd(RectTransform movedTrans, TweenCallback callback)
    {
        movedTrans.localScale = Vector3.one * _nextScale;
        Tweener tween = movedTrans.DOScale(_endScale, _endDuration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(_endEaseType);
        tween.OnComplete(callback);
    }
}
