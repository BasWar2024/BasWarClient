using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MathUtil {
    public static Vector2 CalcuVector2 = Vector2.zero;
    public static Vector3 CalcuVector3 = Vector3.zero;
    public static Rect CalcuRect = Rect.zero;

    // ""list""
    public static bool IsListIntersection<T>(List<T> list1, List<T> list2)
    {
        List<T> t = list1.Distinct().ToList();
        List<T> exceptArr = t.Except(list2).ToList();
        if (exceptArr.Count < t.Count)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    /*
     * ""
     * ""a=(x₁,y₁,z₁),b=(x₂,y₂,z₂)
     * cos=a*b÷(|a|*|b|)=(x₁x₂+y₁y₂+z₁z₂)÷(a""*b"")
     * ""[0, 180]
     */
    public static float Angle(Vector3 a, Vector3 b)
    {
        float dot = Vector3.Dot(a, b);
        float cosValue = dot / (a.magnitude * b.magnitude);
        float angle = Mathf.Acos(cosValue) / Mathf.PI * 180; // Mathf.Acos(cosValue)""[0, π]
        return angle;
    }

    public static float Angle(Vector2 a, Vector2 b)
    {
        float dot = Vector2.Dot(a, b);
        float cosValue = dot / (a.magnitude * b.magnitude);
        float angle = Mathf.Acos(cosValue) / Mathf.PI * 180;
        return angle;
    }
}
