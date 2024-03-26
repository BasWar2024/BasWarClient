using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UserInputProxy : MonoBehaviour
{
    public enum HoverEventPhase
    {
        None = 0,
        Enter,
        Exit,
    }
    public enum MotionEventPhase
    {
        None = 0,
        Started,
        Updated,
        Ended,
    }
    public enum ContinuousGestureEventPhase
    {
        None = 0,
        Started,
        Updated,
        Ended,
    }

    private int dragFingerIndex = -1;

    private void Awake()
    {
        //""delegate "" SendMessage ""。""SendMessage""。
        //""delegate""，""SendMessage""，""

        FingerGestures fingerGuestures = gameObject.AddComponent<FingerGestures>();
        fingerGuestures.makePersistent = true;
        fingerGuestures.detectUnityRemote = true;

        var sr = gameObject.AddComponent<ScreenRaycaster>();
        int layermask = LayerMask.NameToLayer("Ignore Raycast");
        sr.IgnoreLayerMask = 1 << layermask;

        FingerDownDetector fingerDownDetector = gameObject.AddComponent<FingerDownDetector>();
        fingerDownDetector.OnFingerDown += FingerDownEventHandler;

        /*
        FingerHoverDetector fingerHoverDetector = gameObject.AddComponent<FingerHoverDetector>();
        fingerHoverDetector.OnFingerHover += FingerHoverEventHandler;

        FingerMotionDetector fingerMotionDetector = gameObject.AddComponent<FingerMotionDetector>();
        fingerMotionDetector.OnFingerMove += FingerMoveEventHandler;
        fingerMotionDetector.OnFingerStationary += FingerStationaryEventHandler;
        */

        FingerUpDetector fingerUpDetector = gameObject.AddComponent<FingerUpDetector>();
        fingerUpDetector.OnFingerUp += FingerUpEventHandler;

        DragRecognizer dragRecognizer = gameObject.AddComponent<DragRecognizer>();
        //""finger""。
        dragRecognizer.IsExclusive = true;
        dragRecognizer.MoveTolerance = 0;
        dragRecognizer.OnGesture += FirstFingerDragEventHandler;

        LongPressRecognizer longPressRecognizer = gameObject.AddComponent<LongPressRecognizer>();
        longPressRecognizer.OnGesture += LongPressEventHandler;

        TapRecognizer tapRecognizer = gameObject.AddComponent<TapRecognizer>();
        tapRecognizer.IsExclusive = true;
        tapRecognizer.OnGesture += TapEventHandler;

        //SwipeRecognizer swipeRecognizer = gameObject.AddComponent<SwipeRecognizer>();
        //swipeRecognizer.OnGesture += SwipeEventHandler;

        PinchRecognizer pinchRecognizer = gameObject.AddComponent<PinchRecognizer>();
        pinchRecognizer.MinDistance = 0;
        pinchRecognizer.MinDOT = 0;
        pinchRecognizer.OnGesture += PinchEventHandler;

        TwistRecognizer twistRecognizer = gameObject.AddComponent<TwistRecognizer>();
        twistRecognizer.OnGesture += TwistEventHandler;
    }

    /*
    public void OnLevelFinishedLoading(Scene scene, LoadSceneMode mode)
    {
        ScreenRaycaster raycaster = gameObject.GetComponent<ScreenRaycaster>();
        raycaster.IncludeUIEvent = true;
        raycaster.Cameras = new Cameras[]{
            Camera.main,
        }
    }
    */

    public void IgnoreLayer(string layerName)
    {
        if(string.IsNullOrEmpty(layerName))
            return;

        int layer = LayerMask.NameToLayer(layerName);
        if(layer > 0)
        {
            int mask = (1 << layer);

            ScreenRaycaster raycaster = gameObject.GetComponent<ScreenRaycaster>();
            raycaster.IgnoreLayerMask |= mask;
        }
    }

    private bool IsInViewRect(Vector2 pos)
    {
        int width = Screen.currentResolution.width;
        int height = Screen.currentResolution.height;

#if UNITY_EDITOR
        if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height)
            return false;
#endif
        return true;
    }

    /*
    protected void OnSwipeMethod(Vector2 vec2, GameObject go, GameObject startGO, float velocity, Vector2 move)
    {
        AppContext.instance.OnSwipe(vec2, go, startGO, velocity, move);
    }
    */

    //""OnFingerDown，""，""delegate""，""SendMessage""
    void FingerDownEventHandler(FingerDownEvent e)
    {
        if(IsInViewRect(e.Position))
        {
            InputMgr.instance.OnFingerDown(e.Position, e.Selection);
        }
    }

    void FingerUpEventHandler(FingerUpEvent e)
    {
        if(IsInViewRect(e.Position))
        {
            InputMgr.instance.OnFingerUp(e.Position, e.Selection);
        }
    }

    /*
    void FingerHoverEventHandler(FingerHoverEvent e)
    {
        if(IsInViewRect(e.Position))
        {
            AppContext.instance.OnFingerHover(e.Position, e.Selection, (int)HoverPhaseConvertor(e.Phase));
        }
    }

    void FingerMoveEventHandler(FingerMotionEvent e)
    {
        if(IsInViewRect(e.Position))
        {
            AppContext.instance.OnFingerMove(e.Position, e.Selection, (int)MotionPhaseConvertor(e.Phase));
        }
    }

    void FingerStationaryEventHandler(FingerMotionEvent e)
    {
        if(IsInViewRect(e.Position))
        {
            AppContext.instance.OnFingerStationary(e.Position, e.Selection, (int)MotionPhaseConvertor(e.Phase));
        }
    }
    */

    //""，""finger""finger""，
    //""finger"" ""。
    void FirstFingerDragEventHandler(DragGesture gesture)
    {
        if(!IsInViewRect(gesture.Position))
            return;

        //""，""Fingers[0]""，
        //finger.Index""，""。""
        //fingers[0].index""。
        FingerGestures.Finger finger = gesture.Fingers[0];
        if (gesture.Phase == ContinuousGesturePhase.Started)
        {
            dragFingerIndex = finger.Index;
        }

        if (dragFingerIndex != finger.Index)
        {
            return;
        }
        //""。

        InputMgr.instance.OnFirstFingerDrag(gesture.Position, gesture.Selection, gesture.DeltaMove, (int)ContinuousGesturePhaseConvertor(gesture.Phase));
        //""，""index。
        if (gesture.Phase == ContinuousGesturePhase.Ended || gesture.Phase == ContinuousGesturePhase.None)
        {
            dragFingerIndex = -1;
        }
    }

    void LongPressEventHandler(LongPressGesture gesture)
    {
        if(IsInViewRect(gesture.Position))
        {
            InputMgr.instance.OnLongPress(gesture.Position, gesture.Selection);
        }
    }

    void TapEventHandler(TapGesture gesture)
    {
        if(IsInViewRect(gesture.Position))
        {
            InputMgr.instance.OnTap(gesture.Position, gesture.Selection);
        }
    }
    /*
    void SwipeEventHandler(SwipeGesture gesture)
    {
        if(IsInViewRect(gesture.Position))
        {
            AppContext.instance.OnSwipe(gesture.Position, gesture.Selection, gesture.StartSelection, gesture.Velocity, gesture.Move);
        }
    }
    */

    void PinchEventHandler(PinchGesture gesture)
    {
        if(IsInViewRect(gesture.Position))
        {
            int phase = (int)ContinuousGesturePhaseConvertor(gesture.Phase);
            InputMgr.instance.OnPinch(gesture.Position, gesture.Selection, gesture.Delta, gesture.Gap, phase);
        }
    }

    void TwistEventHandler(TwistGesture gesture)
    {
        if(IsInViewRect(gesture.Position))
        {
            InputMgr.instance.OnTwist(gesture.Position, gesture.Selection, gesture.DeltaRotation, gesture.TotalRotation);
        }
    }

    HoverEventPhase HoverPhaseConvertor(FingerHoverPhase phase)
    {
        if (phase == FingerHoverPhase.None)
        {
            return HoverEventPhase.None;
        }
        else if (phase == FingerHoverPhase.Enter)
        {
            return HoverEventPhase.Enter;
        }
        else
        {
            return HoverEventPhase.Exit;
        }

    }

    MotionEventPhase MotionPhaseConvertor(FingerMotionPhase phase)
    {
        if (phase == FingerMotionPhase.None)
        {
            return MotionEventPhase.None;
        }
        else if (phase == FingerMotionPhase.Started)
        {
            return MotionEventPhase.Started;
        }
        else if (phase == FingerMotionPhase.Updated)
        {
            return MotionEventPhase.Updated;
        }
        else
        {
            return MotionEventPhase.Ended;
        }
    }

    ContinuousGestureEventPhase ContinuousGesturePhaseConvertor(ContinuousGesturePhase phase)
    {
        if (phase == ContinuousGesturePhase.None)
        {
            return ContinuousGestureEventPhase.None;
        }
        else if (phase == ContinuousGesturePhase.Started)
        {
            return ContinuousGestureEventPhase.Started;
        }
        else if (phase == ContinuousGesturePhase.Updated)
        {
            return ContinuousGestureEventPhase.Updated;
        }
        else
        {
            return ContinuousGestureEventPhase.Ended;
        }
    }

}


