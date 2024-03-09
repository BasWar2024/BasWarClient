using UnityEngine;
using System;
using UnityEngine.EventSystems;

public class UIDragEventHandler : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler
{
    private Action onDragPointerEnter;
    private Action onDragPointerExit;

    private Action<PointerEventData> onBeginDrag;
    private Action<PointerEventData> onEndDrag;
    private Action<PointerEventData> onDrag;

    private bool isDrag = false;

    public static UIDragEventHandler Get(GameObject go)
    {
        UIDragEventHandler handler = go.GetComponent<UIDragEventHandler>();
        if (handler == null)
        {
            handler = go.AddComponent<UIDragEventHandler>();
        }

        return handler;
    }

    public static void Clear(GameObject go)
    {
        foreach (UIDragEventHandler handler in go.GetComponentsInChildren<UIDragEventHandler>(true))
        {
            handler.ClearDelegates();
        }
    }


    private void OnDisable()
    {
    }

    public void OnDestroy()
    {
        this.ClearDelegates();
    }

    public void ClearDelegates()
    {
        this.onDragPointerEnter = null;
        this.onDragPointerExit = null;
        this.onBeginDrag = null;
        this.onEndDrag = null;
        this.onDrag = null;
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        isDrag = true;

        if(onBeginDrag != null)
            onBeginDrag(eventData);
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        isDrag = false;

        if(onEndDrag != null)
            onEndDrag(eventData);
    }
    public void OnDrag(PointerEventData data)
    {
        if(onDrag != null)
            onDrag(data);
    }

    public void SetOnBeginDrag(Action<PointerEventData> onBeginDrag)
    {
        if (onBeginDrag == null)
            return;

        this.onBeginDrag = onBeginDrag;
    }

    public void SetOnEndDrag(Action<PointerEventData> onEndDrag)
    {
        if (onEndDrag == null)
            return;

        this.onEndDrag = onEndDrag;
    }

    public void SetOnDrag(Action<PointerEventData> onDrag)
    {
        if(onDrag == null)
            return;

        this.onDrag = onDrag;
    }
}
