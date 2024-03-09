using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BezierBase : MonoBehaviour {

    public struct Bezier4 {
        public Vector3 a;
        public Vector3 b;
        public Vector3 c;
        public Vector3 d;

        public Bezier4 (Vector3 a, Vector3 b, Vector3 c, Vector3 d) {
            this.a = a;
            this.b = b;
            this.c = c;
            this.d = d;
        }

    }

    public struct Bezier3 {
        public Vector3 a;
        public Vector3 b;
        public Vector3 c;

        public Bezier3 (Vector3 a, Vector3 b, Vector3 c) {
            this.a = a;
            this.b = b;
            this.c = c;
        }
    }
    //
    Callback mCallback = null;
    public Callback callback {
        get { return mCallback; }
        set { mCallback = value; }
    }
    //
    Bezier4 mBezier4;
    Bezier3 mBezier3;
    //
    public float moveSpeed = 1;
    public float MoveSpeed {
        get { return moveSpeed; }
        set { moveSpeed = value; }
    }
    //
    float mPassedTime;
    //
    Vector3 mNextPostion;
    //
    public int jumpHeight;
    //
    Vector3 mStartPosition;
    //
    public Vector3 mTargetPoint;
    private float mTotalTime;
    //
    public Vector3 objectPosition;

    public Vector3 LogicPosition {
        get { return objectPosition; }
        set {
            this.transform.localPosition = value;
            objectPosition = this.transform.localPosition;
        }
    }

    [SerializeField]
    bool BezierEnd = true;
    public bool BezierOver {
        get { return BezierEnd; }
    }

    public virtual void Awake () {
        // InitEmit(this.transform.localPosition, new Vector3(5, 30, 0), () =>
        // {
        //     InitEmit(this.transform.localPosition, new Vector3(3, 80, 0), null, 1);

        // }, 1);
    }
    public virtual void Start () {

    }
    //
    void ResetPosition () {
        objectPosition = Vector3.zero;
        mTargetPoint = Vector3.zero;
    }
    //update
    public virtual void Update () {
        if (!BezierEnd) {
            mPassedTime += Time.deltaTime;
            float ratio = mPassedTime / mTotalTime;
            MoveLerp (Mathf.Min (1, ratio));
            if (this.transform.localPosition == mTargetPoint) {
                //
                if (this.mCallback != null) {
                    ResetPosition ();
                    this.mCallback ();
                }
                BezierEnd = true;
                mPassedTime = 0;
                return;
            }
        }
    }

    //,
    void MoveLerp (float ratio) {
        mBezier3.c = mTargetPoint;
        mNextPostion = Bezier3At (ref mBezier3, ratio);
        // //
        Vector3 relativePos = mNextPostion - objectPosition;
        if (relativePos != Vector3.zero) {
            transform.rotation = Quaternion.LookRotation(relativePos.normalized);
        }
        //
        LogicPosition = mNextPostion;
    }
    //
    public void InitEmit (Vector3 startPosition, Vector3 totalTarget, Callback callback = null) {
        this.mCallback = callback;
        this.mTargetPoint = totalTarget;
        this.mStartPosition = startPosition;
        this.transform.localPosition = startPosition;
        var distance = Vector3.Distance (startPosition, this.mTargetPoint);
        this.mTotalTime = distance / moveSpeed;
        this.mBezier3 = new Bezier3 (mStartPosition, CaculateTopPoint (mStartPosition, mTargetPoint, jumpHeight), mTargetPoint);

        BezierEnd = false;
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="startPosition"></param>
    /// <param name="totalTarget"></param>
    /// <param name="callback"></param>
    /// <param name="UnitSpeed"></param>
    public void InitEmit (Vector3 startPosition, Vector3 totalTarget, float UnitSpeed, int rotateDegree = 90, Callback callback = null) {
        this.mCallback = callback;
        this.mTargetPoint = totalTarget;
        this.mStartPosition = startPosition;
        this.transform.localPosition = startPosition;
        this.mTotalTime = UnitSpeed;
        var jumpHeightPos = CaculateTopPoint (mStartPosition, mTargetPoint, jumpHeight, rotateDegree);
        // Debug.LogError (
        //     " mStartPosition: " + mStartPosition +
        //     " jumpHeightPos: " + jumpHeightPos +
        //     " mTargetPoint: " + mTargetPoint
        // );
        this.mBezier3 = new Bezier3 (mStartPosition, jumpHeightPos, mTargetPoint);

        BezierEnd = false;
    }
    //  6  
    //
    Vector3 CaculateTopPoint (Vector3 startP, Vector3 endP, int height, int rotateDegree = 90) /**/ {
        var dir = endP - startP;
        //
        // float degree = Vector3.Angle (Vector3.forward, dir);

        // //
        // Vector3 verticalDir = Quaternion.AngleAxis (dir.x > 0 ? rotateDegree : -rotateDegree, Vector3.forward) * dir;
        // Vector3 delta = verticalDir.normalized * height * (float) Math.Sin (Mathf.Deg2Rad * degree);

        // var p2 = (startP + endP) * 0.5f + delta;

        var delta = Vector3.up * height;

        var p2 = (startP + endP) * 0.5f + delta;

        return p2;
    }
    //
    static Vector3 Bezier3At (ref Bezier3 bezier, float t) {
        return Bezier3At (ref bezier.a, ref bezier.b, ref bezier.c, t);
    }

    static Vector3 Bezier3At (ref Vector3 a, ref Vector3 b, ref Vector3 c, float t) {
        return Mathf.Pow (1 - t, 2) * a + 2 * t * (1 - t) * b + Mathf.Pow (t, 2) * c;
    }
    //
    static Vector3 Bezier4At (ref Bezier4 bezier, float t) {
        return Bezier4At (ref bezier.a, ref bezier.b, ref bezier.c, ref bezier.d, t);
    }

    static Vector3 Bezier4At (ref Vector3 a, ref Vector3 b, ref Vector3 c, ref Vector3 d, float t) {
        return (Mathf.Pow (1 - t, 3) * a +
            3 * t * (Mathf.Pow (1 - t, 2)) * b +
            3 * Mathf.Pow (t, 2) * (1 - t) * c +
            Mathf.Pow (t, 3) * d);
    }
    //  
    static Vector3 JumpAt (ref Vector3 startPos, ref Vector3 endPos, int height, float t) {
        var delta = endPos - startPos;
        float frac = t / 1.0f;
        float x = delta.x * t;
        float y = delta.y * t + height * 4 * frac * (1 - frac);

        return new Vector3 (startPos.x + x, startPos.y + y, startPos.z);
    }
}