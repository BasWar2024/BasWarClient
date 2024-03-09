using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public delegate void OnTapDelegate (Vector2 pos, GameObject go);
public delegate void OnPinchDelegate (Vector2 pos, GameObject go, float delta, float gap, int phase);
public delegate void OnFirstFingerDragDelegate (Vector2 pos, GameObject go, Vector2 deltaMove, int phase);
public delegate void OnFingerDownDelegate (Vector2 pos, GameObject go);
public delegate void OnFingerUpDelegate (Vector2 pos, GameObject go);
public delegate void OnLongPressDelegate (Vector2 pos, GameObject go);
public class InputMgr : Singleton<InputMgr>
{
    public List<RaycastResult> raycastResults = new List<RaycastResult>();

    private OnTapDelegate onTap;
    private OnPinchDelegate onPinch;
    private OnFirstFingerDragDelegate onFirstFingerDrag;
    private OnFingerDownDelegate onFingerDown;
    private OnFingerUpDelegate onFingerUp;
    private OnLongPressDelegate onLongPress;

    public void Init()
    {
        XLua.LuaTable table = Lua.getInstance ().luaEnv.Global;
        onTap = table.Get<OnTapDelegate> ("OnTap");
        onPinch = table.Get<OnPinchDelegate> ("onPinch");
        onFirstFingerDrag = table.Get<OnFirstFingerDragDelegate> ("onFirstFingerDrag");
        onFingerDown = table.Get<OnFingerDownDelegate> ("onFingerDown");
        onFingerUp = table.Get<OnFingerUpDelegate> ("onFingerUp");
        onLongPress = table.Get<OnLongPressDelegate> ("onLongPress");

    }

    private bool IsUILayerInput()
    {
        if (ClickMark.getInstance().afterBtnClick) {
            return true;
        }
        if (EventSystem.current == null)
        {
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

    public void OnFirstFingerDrag(Vector2 pos, GameObject go, Vector2 deltaMove, int phase)
    {
        if(IsUILayerInput())
            return;

        if (onFirstFingerDrag != null)
        {
            onFirstFingerDrag(pos, go, deltaMove, phase);
        }

    }

    public void OnFingerDown(Vector2 pos, GameObject go)
    {
        if(IsUILayerInput())
            return;

        if (onFingerDown != null)
        {
            onFingerDown(pos, go);
        }
    }

    public void OnFingerUp(Vector2 pos, GameObject go)
    {
        //if(IsUILayerInput())
        //    return;

        if (onFingerUp != null)
        {
            onFingerUp(pos, go);
        }
    }

    public void OnLongPress(Vector2 pos, GameObject go)
    {
        if(IsUILayerInput())
            return;

        if (onLongPress != null)
        {
            onLongPress(pos, go);
        }
    }

    public void OnTap(Vector2 pos, GameObject go)
    {
        if(IsUILayerInput())
            return;

        if (onTap != null)
        {
            onTap(pos, go);
        }
    }

    public void OnPinch(Vector2 pos, GameObject go, float delta, float gap, int phase)
    {
        if(IsUILayerInput())
            return;

        if (onPinch != null)
        {
            onPinch(pos, go, delta, gap, phase);
        }
    }

    public void OnTwist(Vector2 pos, GameObject go, float deltaRotation, float totalRotation)
    {
        //
    }

}
