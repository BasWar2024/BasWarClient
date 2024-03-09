using DG.Tweening;
using UnityEngine;
using UnityEngine.EventSystems;
using System.Collections;

public class TweenComp : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    public bool _isBtnScale = false;
    public bool _isPnlEnlarged = false;
    public bool _isFadeInOut = false;
    public bool _isMoveHorizontal = false;
    public bool _isMoveVertical = false;

    public float _moveDuration = 0.4f;

    private bool _inited = false;

    private TweeningType _tweeningType; //tween
    private Camera _uiCamera;
    void Start()
    {
        _inited = true;

        PlayTween();
    }

    private void OnEnable()
    {
        if (!_inited)
            return;

        PlayTween();
    }
    private void PlayTween()
    {
        _tweeningType = TweeningType.None;
        if (_isPnlEnlarged)
        {
            TweenAnimation.instance.Play(TweenAnimation.AnimType.panelEnlarge, GetComponent<RectTransform>());
        }
        if (_isFadeInOut)
        {
            TweenAnimation.instance.Play(TweenAnimation.AnimType.fadeIn, GetComponent<RectTransform>());
        }

        if (_isMoveHorizontal || _isMoveVertical)
        {
            if (_isMoveHorizontal)
            {
                _tweeningType = TweeningType.Horizontal;
                TweenAnimation.instance.PlayMove(TweenAnimation.AnimMoveType.leftRightShow, GetComponent<RectTransform>(), _moveDuration, () => {
                    _tweeningType = TweeningType.None;
                });
            }
            if (_isMoveVertical)
            {
                _tweeningType = TweeningType.Vertical;
                TweenAnimation.instance.PlayMove(TweenAnimation.AnimMoveType.upDownShow, GetComponent<RectTransform>(), _moveDuration, () => {
                    _tweeningType = TweeningType.None;
                });
            }
        }
    }

    public void TweenFinish(TweenCallback action)
    {
        bool actioned = false;
        _tweeningType = TweeningType.None;

        if (_isFadeInOut)
        {
            TweenAnimation.instance.Play(TweenAnimation.AnimType.fadeOut, GetComponent<RectTransform>(), action);
            actioned = true;
        }
        if (_isMoveHorizontal)
        {
            _tweeningType = TweeningType.Horizontal;
            TweenAnimation.instance.PlayMove(TweenAnimation.AnimMoveType.moveToLeftRightHide, GetComponent<RectTransform>(), _moveDuration, () => {
                _tweeningType = TweeningType.None;
                action();
            });
            actioned = true;
        }
        if (_isMoveVertical)
        {
            TweenAnimation.instance.PlayMove(TweenAnimation.AnimMoveType.moveToUpDownHide, GetComponent<RectTransform>(), _moveDuration, () => {
                _tweeningType = TweeningType.None;
                action();
            });
            actioned = true;
        }

        if (actioned == false && action != null)
        {
            action.Invoke();
        }
    }

    public TweeningType tweeningType
    {
        get { return _tweeningType; }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (_isBtnScale)
        {
            //
            float minifyFactor = 0.85f;
            RectTransform rectTrans = GetComponent<RectTransform>();
            Vector2 pos = GetUICamera().WorldToScreenPoint(rectTrans.position);
            Rect rect = new Rect(pos.x - rectTrans.rect.width / 2 * minifyFactor, pos.y - rectTrans.rect.height / 2 * minifyFactor,
                rectTrans.rect.width * minifyFactor, rectTrans.rect.height * minifyFactor);

            if (rect.Contains(eventData.pressPosition))
            {
                TweenAnimation.instance.Play(TweenAnimation.AnimType.minify, rectTrans);
            }
        }
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (_isBtnScale)
        {
            TweenAnimation.instance.Play(TweenAnimation.AnimType.enlarge, GetComponent<RectTransform>());
        }
    }

    private Camera GetUICamera()
    {
        if (_uiCamera == null)
        {
            _uiCamera = GameObject.Find("UIRoot/UICamera").GetComponent<Camera>();
        }
        return _uiCamera;
    }
}
