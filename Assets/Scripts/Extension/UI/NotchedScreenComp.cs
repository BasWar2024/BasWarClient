using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class NotchedScreenComp : MonoBehaviour
{

    public enum UISide
    {
        Left = 1,
        Right = 2,
    }

    public float _originPosX = 0f;
    public UISide _side = UISide.Left;
    //androidO""，""
    public float _defaultPadding = 0f;

    private RectTransform _cachedTransform;
    private ScreenOrientation _direction = ScreenOrientation.Unknown;
    private float _tweenDuration = 0.5f;

    private TweeningType _tweeningType = TweeningType.None;
    private Tweener _moveTweener = null;

    void Awake()
    {
        _cachedTransform = GetComponent<RectTransform>();

        if (Screen.orientation == ScreenOrientation.LandscapeLeft || Screen.orientation == ScreenOrientation.Landscape)//""
            _direction = ScreenOrientation.LandscapeLeft;
        else if (Screen.orientation == ScreenOrientation.LandscapeRight)
            _direction = ScreenOrientation.LandscapeRight;

        NotchScreen.instance.lastDirection = _direction;
    }

    private void OnEnable()
    {
        OnScreenRotate();
    }

    void Update()
    {
        //""
        if (_direction != Screen.orientation)
        {
            _direction = Screen.orientation;

            if (Screen.orientation == ScreenOrientation.LandscapeLeft)
            {
                NotchScreen.instance.lastDirection = _direction;
                OnScreenRotate();
            }
            else if (Screen.orientation == ScreenOrientation.LandscapeRight)
            {
                NotchScreen.instance.lastDirection = _direction;
                OnScreenRotate();
            }
            else
            {
                OnScreenRotate();
            }
        }
    }

    public void CalcShowPos()
    {
        OnScreenRotate(true);
    }

    public TweeningType tweeningType
    {
        get { return _tweeningType; }
    }

    private void OnScreenRotate(bool calculate = false)  //""
    {
        if (_cachedTransform == null)
        {
            _cachedTransform = GetComponent<RectTransform>();
        }
        InitDirection();
        _tweeningType = TweeningType.None;
        if (!calculate)
        {
            if (!NotchScreen.instance.isAndroidO && Mathf.Abs(NotchScreen.instance.leftValue) <  0.1f)
                return;

            if (!InScreen(_cachedTransform.position))
                return;
        }

        if (_direction == ScreenOrientation.Portrait || _direction == ScreenOrientation.PortraitUpsideDown || _direction == ScreenOrientation.Unknown)
        {
            MathUtil.CalcuVector2.x = _originPosX;
            MathUtil.CalcuVector2.y = _cachedTransform.anchoredPosition.y;

            _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
            return;
        }

        float offset = 0f;
        if (NotchScreen.instance.isAndroidO)
        {
            offset = _originPosX + _defaultPadding;
        }
        else
        {
            if (_side == UISide.Left)
                offset = _originPosX + NotchScreen.instance.leftValue;
            else
                offset = _originPosX - NotchScreen.instance.leftValue;
        }

        // if (gameObject.name == "negoBottomLeft")
        // {
        //    Debug.Log("left   " + NotchScreen.instance.leftValue + "   _originPosX   " + _originPosX + "     " + _direction.ToString());
        // }

        ScreenOrientation transferDirection = (_direction == ScreenOrientation.LandscapeLeft || _direction == ScreenOrientation.LandscapeRight) ? _direction : NotchScreen.instance.lastDirection;
        if (transferDirection == ScreenOrientation.LandscapeLeft)
        {
            if (_side == UISide.Left)
            {
                MathUtil.CalcuVector2.x = offset;
                MathUtil.CalcuVector2.y = _cachedTransform.anchoredPosition.y;

                if (calculate)
                    _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
                else
                {
                    if (Mathf.Abs(_cachedTransform.anchoredPosition.x - offset) < 0.1f)
                    {
                        MathUtil.CalcuVector2.x -= offset;
                        _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
                    }
                    _moveTweener = _cachedTransform.DOLocalMoveX(offset, _tweenDuration);
                }
            }
            else
            {
                MathUtil.CalcuVector2.x = _originPosX;
                MathUtil.CalcuVector2.y = _cachedTransform.anchoredPosition.y;

                if (calculate)
                    _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
                else
                    _moveTweener = _cachedTransform.DOLocalMoveX(_originPosX, _tweenDuration);
            }
        }
        //else if (Screen.orientation == ScreenOrientation.LandscapeLeft || Screen.orientation == ScreenOrientation.Landscape)
        else if (transferDirection == ScreenOrientation.LandscapeRight)
        {
            if (_side == UISide.Left)
            {
                MathUtil.CalcuVector2.x = _originPosX;
                MathUtil.CalcuVector2.y = _cachedTransform.anchoredPosition.y;

                if (calculate)
                    _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
                else
                    _moveTweener = _cachedTransform.DOLocalMoveX(_originPosX, _tweenDuration);
            }
            else
            {
                MathUtil.CalcuVector2.x = offset;
                MathUtil.CalcuVector2.y = _cachedTransform.anchoredPosition.y;

                if (calculate)
                    _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
                else
                {
                    if (Mathf.Abs(_cachedTransform.anchoredPosition.x - offset) <  0.1f)
                    {
                        MathUtil.CalcuVector2.x += offset;
                        _cachedTransform.anchoredPosition = MathUtil.CalcuVector2;
                    }
                    _moveTweener = _cachedTransform.DOLocalMoveX(offset, _tweenDuration);
                }
            }
        }
        else
        {
            Debug.Log("unknown direction  " + transferDirection.ToString());
        }

        if (_moveTweener != null)
        {
            _tweeningType = TweeningType.Horizontal;
            _moveTweener.SetUpdate<Tweener>(true);
            _moveTweener.OnComplete( () =>
            {
                _moveTweener = null;
                _tweeningType = TweeningType.None;
            });
        }
        else
        {
            _tweeningType = TweeningType.None;
        }
    }

    private bool InScreen(Vector3 pos)
    {
        Camera uiCamera = GetUICamera();
        Vector3 temp = uiCamera.WorldToScreenPoint(pos);

        if (temp.x < 0 || temp.x > uiCamera.pixelWidth)
        {
            return false;
        }

        return true;
    }

    private Camera GetUICamera()
    {
        return NotchScreen.instance._uiCamera;
    }

    private void InitDirection()
    {
        if (_direction == ScreenOrientation.Unknown)
        {
            if (Screen.orientation == ScreenOrientation.LandscapeLeft || Screen.orientation == ScreenOrientation.Landscape)//""
                _direction = ScreenOrientation.LandscapeLeft;
            else if (Screen.orientation == ScreenOrientation.LandscapeRight)
                _direction = ScreenOrientation.LandscapeRight;
        }
    }
}
