using UnityEngine;
using System;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UIEventHandler : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler,
    IPointerDownHandler, IPointerUpHandler
{
    private Action onClick;
    private Action<PointerEventData> onPointerDown;
    private Action<PointerEventData> onPointerUp;
    private Action onPointerEnter;
    private Action onPointerExit;
    private Action onLongPress;
    private Action onLongPressMoreThanOnce;
    private bool isPointerDown = false;
    private bool isLongPressEnd = true;
    private bool isLongPressMoreThanOnceEnd = true;
    private float longPressTimer = 0f;
    private float longPressTime = 0.5f;
    private float longPressInterval = 0.1f;
    private float longPressMoreThanOnceTimer = 0f;
    private float longPressAcceleration = 0f;
    private float longPressMinInterval = 0.1f;
    private float longPressCurInterval = 0f;

    private bool isOnClick = false;
    private float afterClickTime = 0f;
    private Vector3 objSize;
    private bool isDelay = true;

    public static UIEventHandler Get(GameObject go)
    {
        UIEventHandler handler = go.GetComponent<UIEventHandler>();
        if (handler == null)
        {
            handler = go.AddComponent<UIEventHandler>();
        }
        
        //RectTransform rectTransform = go.transform.GetComponent<RectTransform>();
        //rectTransform.pivot = new Vector2(0.5f, 0.5f);

        return handler;
    }

    public static void Clear(GameObject go)
    {
        foreach (UIEventHandler handler in go.GetComponentsInChildren<UIEventHandler>(true))
        {
            handler.ClearDelegates();
        }
    }

    public void ClearStatus()
    {
        longPressTimer = 0f;
        longPressMoreThanOnceTimer = 0f;
        isPointerDown = false;
        isLongPressEnd = true;
        isLongPressMoreThanOnceEnd = true;
    }

    private void OnDisable()
    {
        ClearStatus();
    }

    public void OnDestroy()
    {
        this.ClearDelegates();
    }

    public void ClearDelegates()
    {
        this.onClick = null;
        this.onPointerDown = null;
        this.onPointerUp = null;
        this.onPointerEnter = null;
        this.onPointerExit = null;
        this.onLongPress = null;
        this.onLongPressMoreThanOnce = null;
    }

    private void Update()
    {
        //""，""，ondrag，""longpress timer""
        if(isPointerDown)
        {
            longPressTimer += Time.deltaTime;
            longPressMoreThanOnceTimer += Time.deltaTime;
            if(!isLongPressEnd)
            {
                if(longPressTimer >= longPressTime)
                {
                    OnLongPress();
                    isLongPressEnd = true;
                    longPressTimer = 0f;
                }
            }

            if(!isLongPressMoreThanOnceEnd)
            {
                if(longPressMoreThanOnceTimer >= longPressCurInterval)
                {
                    OnLongPressMoreThanOnce();
                    //longPressMoreThanOnceTimer = 0;
                    longPressCurInterval -= longPressAcceleration;
                    if(longPressCurInterval < longPressMinInterval)
                    {
                        longPressCurInterval = longPressMinInterval;
                    }
                }
            }
        }
        PlayClickAnimator();
    }

    float clickAnimatorTime = 0.2f;
    float addSize = 0.1f;

    private void afterClickEvent() {
        isOnClick = true;
        afterClickTime = 0f;
        gameObject.transform.localScale = objSize;
        
    }

    private void PlayClickAnimator() {
        if (isOnClick) {
            //isOnClick = false;
            //OnClickInvoke();

            afterClickTime += Time.deltaTime;
            if (afterClickTime <= clickAnimatorTime / 2f)
            {
                float percent = afterClickTime / clickAnimatorTime * 2f;
                float size = percent * addSize + 1f;
                gameObject.transform.localScale = objSize * size;
            }
            else if (afterClickTime >= clickAnimatorTime / 2f && afterClickTime <= clickAnimatorTime)
            {
                float percent = 2 - afterClickTime / clickAnimatorTime * 2f;
                float size = percent * addSize + 1;
                gameObject.transform.localScale = objSize * size;
            }
            else if (afterClickTime >= clickAnimatorTime)
            {
                gameObject.transform.localScale = objSize;
                isOnClick = false;
                OnClickInvoke();
            }

        }
    }

    private void OnClickInvoke() {
        onClick();//(gameObject, eventData);

        ClickMark.getInstance().afterBtnClick = true;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (onClick != null)
        {
            if (isDelay) {
                afterClickEvent();
            }
            else {
                onClick();//(gameObject, eventData);

                ClickMark.getInstance().afterBtnClick = true;
            }
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (onPointerDown != null)
            onPointerDown(eventData);

        isPointerDown = true;
        isLongPressEnd = false;
        isLongPressMoreThanOnceEnd = false;
        longPressCurInterval = longPressInterval;
        longPressMoreThanOnceTimer = longPressInterval - Time.deltaTime;
    }

    public void OnPointerUp(PointerEventData eventData) {
        if (onPointerUp != null)
            onPointerUp(eventData);

        longPressTimer = 0f;
        longPressMoreThanOnceTimer = 0f;
        isPointerDown = false;
        isLongPressEnd = true;
        isLongPressMoreThanOnceEnd = true;
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (onPointerEnter != null)
            onPointerEnter();//(gameObject, eventData);

    }
    public void OnPointerExit(PointerEventData eventData)
    {
        if (onPointerExit != null)
            onPointerExit();//(gameObject, eventData);
    }
    public void OnLongPress()
    {
        if (onLongPress != null)
        {
            onLongPress();//(gameObject);
        }
    }

    public void OnLongPressMoreThanOnce()
    {
        if(onLongPressMoreThanOnce != null)
            onLongPressMoreThanOnce();//(gameObject);

        longPressMoreThanOnceTimer = 0;
    }

    /*
    public void AddInputFieldValueChangeEventListener(Action callback)
    {
        UnityEngine.UI.InputField inputField = gameObject.GetComponent<UnityEngine.UI.InputField>();
        if (inputField)
        {
            inputField.onValueChanged.AddListener(delegate { callback(gameObject); });
        }
    }

    public void AddScrollRectValueChangeEventListener(Action callback)
    {
        UnityEngine.UI.ScrollRect scrollRect = gameObject.GetComponent<UnityEngine.UI.ScrollRect>();
        if (scrollRect)
        {
            scrollRect.onValueChanged.AddListener(delegate { callback(gameObject); });
        }
    }
    */

    public void SetOnPointerDown(Action<PointerEventData> onPointerDown)
    {
        if (onPointerDown == null)
            return;

        this.onPointerDown = onPointerDown;
    }
    public void SetOnPointerUp(Action<PointerEventData> onPointerUp)
    {
        if (onPointerUp == null)
            return;

        this.onPointerUp = onPointerUp;
    }
    // public void SetOnClick(Action onClick)
    // {
    //     if (onClick == null)
    //         return;

    //     this.onClick = onClick;
    // }

    public void SetOnClick(Action onClick, String audioEvent = "event:/UI_button_click", String bank = "se_UI", bool isDelay = true)
    {
        if (onClick == null)
            return;

        objSize = transform.localScale;
        this.isDelay = isDelay;
        this.onClick = () => {
            
            onClick();
            if(audioEvent != null && audioEvent != "")
            {
                //AudioFmodMgr.instance.PlaySFX(audioEvent);

                AudioFmodMgr.instance.Play2DOneShot(audioEvent, bank);
                //AudioMgr.instance.Play2DAudio(audioName);
            }
        };
    }

    public void InvokeOnClick()
    {
        if (onClick != null)
            onClick.Invoke();

    }

   

    public void InvokeOnPointerDown()
    {
        if(onPointerDown != null)
            onPointerDown.Invoke(null);
    }

    public void InvokeOnPointerUp()
    {
        if(onPointerUp != null)
            onPointerUp.Invoke(null);
    }

    public void SetOnLongPress(Action onLongPress)
    {
        if (onLongPress == null)
            return;

        this.onLongPress = onLongPress;
    }

    public void SetOnLongPressMoreThanOnce(Action onLongPressMoreThanOnce)
    {
        if(onLongPressMoreThanOnce == null)
            return;

        this.onLongPressMoreThanOnce = onLongPressMoreThanOnce;
    }

    void OnMouseDown() {
    }

    void OnMouseUp() {
        if (IsUILayerInput())
            return;

        if (onClick != null)
            onClick.Invoke();
    }

    private bool IsUILayerInput() {
        if (EventSystem.current == null) {
            return false;
        }
#if UNITY_EDITOR
        if (EventSystem.current.IsPointerOverGameObject())
#else
        if (EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
#endif
        {
            return true;
        }
        return false;

    }
}
