using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public static class TransformExtension {
    public static void ReSet (this Transform tr) {
        tr.localPosition = Vector3.zero;
    }
    public static void SetScale (this Transform tr, Vector3 scale) {
        tr.localScale = scale;
    }

    public static void SetLocalScaleX (this Transform tr, float x) {
        var scale = tr.localScale;
        scale.x = x;
        tr.localScale = scale;
    }
    public static void SetLocalScaleY (this Transform tr, float y) {
        var scale = tr.localScale;
        scale.y = y;
        tr.localScale = scale;
    }
    public static void SetLocalScale (this Transform tr, float size) {
        var scale = tr.localScale;
        scale.x = size;
        scale.y = size;
        tr.localScale = scale;
    }

    public static void SetWorldPosX (this Transform tr, float x) {
        var worldPos = tr.position;
        worldPos.x = x;
        tr.position = worldPos;
    }

    public static void SetWorldPosY (this Transform tr, float y) {
        var worldPos = tr.position;
        worldPos.y = y;
        tr.position = worldPos;
    }
    public static void SetWorldPosZ (this Transform tr, float z) {
        var worldPos = tr.position;
        worldPos.z = z;
        tr.position = worldPos;
    }

    public static void SetLocalPosX (this Transform tr, float x) {
        var localPos = tr.localPosition;
        localPos.x = x;
        tr.localPosition = localPos;
    }

    public static void SetLocalPosY (this Transform tr, float y) {
        var localPos = tr.localPosition;
        localPos.y = y;
        tr.localPosition = localPos;
    }

    public static void SetLocalPosZ (this Transform tr, float z) {
        var localPos = tr.localPosition;
        localPos.z = z;
        tr.localPosition = localPos;
    }

    public static void SetRectPosX (this RectTransform rt, float x) {
        var pos = rt.anchoredPosition;
        pos.x = x;
        rt.anchoredPosition = pos;
    }
    public static void SetRectPosY (this RectTransform rt, float y) {
        var pos = rt.anchoredPosition;
        pos.y = y;
        rt.anchoredPosition = pos;
    }

    public static void SetRectSizeX (this RectTransform rt, float x) {
        var size = rt.sizeDelta;
        size.x = x;
        rt.sizeDelta = size;
    }

    public static void SetRectSizeY (this RectTransform rt, float y) {
        var size = rt.sizeDelta;
        size.y = y;
        rt.sizeDelta = size;
    }
    public static void SetActiveEx (this GameObject obj, bool active) {

        if (obj.activeSelf != active) {
            obj.SetActive (active);
        }
    }
    public static void SetActiveEx (this Transform obj, bool active) {
        if (obj.gameObject.activeSelf != active) {
            obj.gameObject.SetActive (active);
        }
    }
    public static void SetImageEnable (this Image img, bool active) {
        if (img.enabled != active) {
            img.enabled = active;
        }
    }
    public static void SetTextEnable (this Text text, bool active) {
        if (text.enabled != active) {
            text.enabled = active;
        }
    }

    public static void SetParentEx (this Transform tran, Transform parent, bool worldPositionStays) {
        if (tran.parent != null && tran.parent.Equals (parent)) {
            //
        } else {
            tran.SetParent (parent, worldPositionStays);
        }
    }
}