using UnityEngine;
using DG.Tweening;
using System;
using System.Collections.Generic;

//tween, tween
public enum TweeningType
{
    None = 0,
    Horizontal = 1,
    Vertical = 2,
}

public class TweenAnimation : Singleton<TweenAnimation>
{
    public enum AnimType
    {
        enlarge = 0,
        minify = 1,
        panelEnlarge = 2,
        fadeIn = 3,
        fadeOut = 4,
    }

    public enum AnimMoveType
    {
        moveToLeftRightHide = 0,
        moveToUpDownHide = 1,
        upDownShow = 2,
        leftRightShow = 3,
    }

    //ui
    private Dictionary<Transform, Vector3> _posDic = new Dictionary<Transform, Vector3>(5);

    //ui
    private Vector3 _nodeScale = Vector3.zero;

    //calcu param
    private Vector3 _tempVec3 = Vector3.zero;

    private Camera _uiCamera;

    public void Release()
    {
        _posDic.Clear();
        _posDic = null;
    }

    /// <summary>
    /// 
    /// 
    /// ui
    /// </summary>
    public void PlayMove(AnimMoveType animType, RectTransform movedTrans, float duration = 0.2f, TweenCallback callback = null)
    {
        if (!CanTweenMove(movedTrans, animType))//
            return;

        //   1.   2.   3.pivotui
        switch (animType)
        {
            case AnimMoveType.moveToLeftRightHide:
                LeftRightHide(movedTrans, duration, callback);
                break;
            case AnimMoveType.moveToUpDownHide:
                UpDownHide(movedTrans, duration, callback);
                break;
            case AnimMoveType.upDownShow:
                UpDownShow(movedTrans, duration, callback);
                break;
            case AnimMoveType.leftRightShow:
                LeftRightShow(movedTrans, duration, callback);
                break;
            default:
                break;
        }
    }

    public void Play(AnimType animType, RectTransform movedTrans, TweenCallback callback = null)
    {
        switch (animType)
        {
            case AnimType.enlarge:
                Enlarge(movedTrans, callback);
                break;
            case AnimType.minify:
                Minify(movedTrans, callback);
                break;
            case AnimType.panelEnlarge:
                PanelEnlarge(movedTrans, callback);
                break;
            case AnimType.fadeIn:
                FadeIn(movedTrans, callback);
                break;
            case AnimType.fadeOut:
                FadeOut(movedTrans, callback);
                break;
            default:
                break;
        }
    }

    private void Enlarge(RectTransform movedTrans, TweenCallback callback)
    {
        float startValue = 0.85f;
        float endValue = 1f;
        Ease ease = Ease.OutElastic;
        float duration = 0.7f;

        movedTrans.localScale = Vector3.one * startValue;
        Tweener tween = movedTrans.DOScale(endValue, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
    }

    private void Minify(RectTransform movedTrans, TweenCallback callback)
    {
        float endValue = 0.85f;
        Ease ease = Ease.OutCubic;
        float duration = 0.3f;
        Tweener tween = movedTrans.DOScale(endValue, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
    }

    private void PanelEnlarge(RectTransform movedTrans, TweenCallback callback)
    {
        float startValue = 0.5f;
        float endValue = 1f;
        Ease ease = Ease.OutBack;
        float duration = 0.3f;

        movedTrans.localScale = Vector3.one * startValue;
        Tweener tween = movedTrans.DOScale(endValue, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
    }

    private void FadeIn(RectTransform movedTrans, TweenCallback callback)
    {
        float startValue = 0f;
        float endValue = 1f;
        Ease ease = Ease.Linear;
        float duration = 0.2f;
        CanvasGroup group = movedTrans.GetComponent<CanvasGroup>();
        if (group == null)
        {
            group = movedTrans.gameObject.AddComponent<CanvasGroup>();
        }
        group.alpha = startValue;
        Tweener tween = group.DOFade(endValue, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
    }
    private void FadeOut(RectTransform movedTrans, TweenCallback callback)
    {
        float startValue = 1f;
        float endValue = 0f;
        Ease ease = Ease.Linear;
        float duration = 0.2f;
        CanvasGroup group = movedTrans.GetComponent<CanvasGroup>();
        if (group == null)
        {
            group = movedTrans.gameObject.AddComponent<CanvasGroup>();
        }
        group.alpha = startValue;
        Tweener tween = group.DOFade(endValue, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
    }

    private void LeftRightHide(RectTransform movedTrans, float duration, TweenCallback callback)
    {

        Vector3 showPos = Vector3.zero;
        Vector3 hidePos = Vector3.zero;

        CalcuLeftRightPos(movedTrans, ref showPos, ref hidePos);

        Camera uiCamera = GetUICamera();
        _tempVec3 = uiCamera.WorldToScreenPoint(movedTrans.position);
        //if (_tempVec3.x < 0f || _tempVec3.x > Screen.width)
        //    return;

        movedTrans.position = showPos;
        movedTrans.localPosition = new Vector3(movedTrans.localPosition.x, movedTrans.localPosition.y, 0f);//z0
        Ease ease = Ease.InCubic;
        Tweener tween = movedTrans.DOMoveX(hidePos.x, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
        tween.SetAutoKill();
    }

    private void UpDownHide(RectTransform movedTrans, float duration, TweenCallback callback)
    {
        Camera uiCamera = GetUICamera();
        _tempVec3 = uiCamera.WorldToScreenPoint(movedTrans.position);
        //if (_tempVec3.y < 0f || _tempVec3.y > Screen.height)
        //    return;

        Vector3 showPos = Vector3.zero;
        Vector3 hidePos = Vector3.zero;
        CalcuUpDownPos(movedTrans, ref showPos, ref hidePos);

        hidePos.z = showPos.z;
        movedTrans.position = showPos;

        Ease ease = Ease.InCubic;
        Tweener tween = movedTrans.DOMoveY(hidePos.y, duration);
        tween.SetUpdate<Tweener>(true);
        tween.SetEase(ease);
        tween.OnComplete(callback);
        tween.SetAutoKill();

    }

    private void LeftRightShow(RectTransform movedTrans, float duration, TweenCallback callback)
    {
        Vector3 showPos = Vector3.zero;
        Vector3 hidePos = Vector3.zero;

        CalcuLeftRightPos(movedTrans, ref showPos, ref hidePos);

        movedTrans.position = hidePos;
        movedTrans.localPosition = new Vector3(movedTrans.localPosition.x, movedTrans.localPosition.y, 0f);//z0

        Vector3 target = showPos;
        Tweener tween = movedTrans.DOMoveX(target.x, duration);
        tween.SetUpdate<Tweener>(true);
        Ease ease = Ease.OutCubic;
        tween.SetEase(ease);
        tween.OnComplete(callback);
        tween.SetAutoKill();
    }
    private void UpDownShow(RectTransform movedTrans, float duration, TweenCallback callback)
    {
        Vector3 showPos = Vector3.zero;
        Vector3 hidePos = Vector3.zero;
        CalcuUpDownPos(movedTrans, ref showPos, ref hidePos);

        hidePos.z = showPos.z;
        movedTrans.position = hidePos;

        Vector3 target = showPos;
        Tweener tween = movedTrans.DOMoveY(target.y, duration);
        tween.SetUpdate<Tweener>(true);
        Ease ease = Ease.OutCubic;
        tween.SetEase(ease);
        tween.OnComplete(callback);
        tween.SetAutoKill();
    }

    private Vector3[] CalcuUpDownPos(RectTransform movedTrans, ref Vector3 showPos, ref Vector3 hidePos)
    {
        //
        foreach (var item in _posDic)
        {
            if (item.Key == null)
            {
                _posDic.Remove(item.Key);
                break;
            }
        }

        Camera uiCamera = GetUICamera();
        _tempVec3 = uiCamera.WorldToScreenPoint(movedTrans.position);

        if (_posDic.ContainsKey(movedTrans))
        {
            showPos = _posDic[movedTrans];
        }
        else
        {
            showPos = movedTrans.position;
            _posDic.Add(movedTrans, showPos);
        }
        hidePos = showPos;

        Vector3 showScreenPos = uiCamera.WorldToScreenPoint(showPos);

        if (showScreenPos.y <= GetUICamera().pixelHeight / 2)
        {
            Vector3 curPos = new Vector3(showScreenPos.x, -showScreenPos.y, 0f);//
            hidePos = uiCamera.ScreenToWorldPoint(curPos);//
            hidePos.y -= movedTrans.sizeDelta.y * (1 - movedTrans.pivot.y) * nodeScale.y;//pivotui
        }
        else
        {
            Vector3 curPos = new Vector3(showScreenPos.x, 2 * GetUICamera().pixelHeight - showScreenPos.y, 0f);
            hidePos = uiCamera.ScreenToWorldPoint(curPos);
            hidePos.y += movedTrans.sizeDelta.y * movedTrans.pivot.y * nodeScale.y;
        }
        return new Vector3[2] { showPos, hidePos };
    }
    private Vector3[] CalcuLeftRightPos(RectTransform movedTrans, ref Vector3 showPos, ref Vector3 hidePos)
    {
        //
        foreach (var item in _posDic)
        {
            if (item.Key == null)
            {
                _posDic.Remove(item.Key);
                break;
            }
        }

        Camera uiCamera = GetUICamera();

        //
        if (movedTrans.GetComponent<NotchedScreenComp>() != null)
        {
            NotchedScreenComp notchedComp = movedTrans.GetComponent<NotchedScreenComp>();
            notchedComp.CalcShowPos();
            showPos = movedTrans.position;
        }
        else
        {
            _tempVec3 = uiCamera.WorldToScreenPoint(movedTrans.position);

            if (_posDic.ContainsKey(movedTrans))
            {
                showPos = _posDic[movedTrans];
            }
            else if (_tempVec3.x >= 0f && _tempVec3.x <= GetUICamera().pixelWidth)
            {
                showPos = movedTrans.position;
                _posDic.Add(movedTrans, showPos);
            }
        }
        hidePos = showPos;

        Vector3 showScreenPos = uiCamera.WorldToScreenPoint(showPos);

        if (showScreenPos.x <= GetUICamera().pixelWidth / 2) //left
        {
            Vector3 curPos = new Vector3(-showScreenPos.x, showScreenPos.y, showScreenPos.z);
            hidePos = uiCamera.ScreenToWorldPoint(curPos);
            hidePos.x -= movedTrans.sizeDelta.x * (1 - movedTrans.pivot.x) * nodeScale.x;
        }
        else //right
        {
            Vector3 curPos = new Vector3(2 * GetUICamera().pixelWidth - showScreenPos.x, showScreenPos.y, showScreenPos.z);
            hidePos = uiCamera.ScreenToWorldPoint(curPos);
            hidePos.x += movedTrans.sizeDelta.x * movedTrans.pivot.x * nodeScale.x;
        }

        return new Vector3[2] { showPos, hidePos };
    }

    private Camera GetUICamera()
    {
        if (_uiCamera == null)
        {
            _uiCamera = GameObject.Find("UIRoot/UICamera").GetComponent<Camera>();
        }
        return _uiCamera;
    }

    private Vector3 nodeScale
    {
        get
        {
            if (_nodeScale == Vector3.zero)
            {
                _nodeScale = GameObject.Find("UIRoot/NormalNode").transform.localScale;
            }

            return _nodeScale;
        }
    }

    private bool CanTweenMove(Transform movedTrans, AnimMoveType animType)
    {
        NotchedScreenComp notchComp = movedTrans.GetComponent<NotchedScreenComp>();
        if (notchComp != null)
        {
            if (notchComp.tweeningType == TweeningType.None)
                return true;

            if (animType == AnimMoveType.leftRightShow || animType == AnimMoveType.moveToLeftRightHide)
            {
                if (notchComp.tweeningType == TweeningType.Horizontal)
                    return false;
            }
            if (animType == AnimMoveType.upDownShow || animType == AnimMoveType.moveToUpDownHide)
            {
                if (notchComp.tweeningType == TweeningType.Vertical)
                    return false;
            }
        }

        return true;
    }
}
