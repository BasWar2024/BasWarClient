using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using UniRx;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent (typeof (RectTransform))]
public class VerticalOrHorizontalLayoutLight : MonoBehaviour {

    #region 
    //active
    List<RectTransform> rectTranList = new List<RectTransform> ();
    RectTransform contentRectTran;
    #endregion

    #region 

    //===================================================
    //
    public bool IsSelfAdaption = false;
    //layout
    public SwitchModel Switch_Model = SwitchModel.vertical;
    //item
    public float spacing = 5;
    //
    public ChildAlignment Child_Alignment = ChildAlignment.UpperLeft;
    //
    private bool isUseAnim = false;
    private float speedAnim = 0.4f;
    //============================================================

    //
    float[] elementsHeight;
    //
    float[] elementsWidth;
    //
    private float offsetY;
    private float offsetX;
    #endregion

    int chileCount = 0;
    void Awake () {
        contentRectTran = GetComponent<RectTransform> ();
        Init ();
    }

    void Init () {
        if (IsSelfAdaption) {
            if (Switch_Model == SwitchModel.vertical) {
                contentRectTran.SetAnchor (AnchorPresets.HorStretchTop);
                contentRectTran.offsetMax = new Vector2 (0, contentRectTran.offsetMax.y);
                contentRectTran.offsetMin = new Vector2 (0, contentRectTran.offsetMax.y);
            } else {
                contentRectTran.SetAnchor (AnchorPresets.VertStretchLeft);
                contentRectTran.offsetMax = new Vector2 (contentRectTran.offsetMax.x, 0);
                contentRectTran.offsetMin = new Vector2 (contentRectTran.offsetMax.x, 0);
            }
        }
    }

    void GetElementsHW () {
        if (Switch_Model == SwitchModel.Horizontal)
            elementsWidth = GetElementsWidth ();
        else
            elementsHeight = GetElementsHeight ();
    }

    void GetAllChild () {
        var tempChildCount = transform.childCount;

        int activeCount = 0;
        rectTranList.Clear ();
        for (int i = 0; i < tempChildCount; i++) {
            var child = transform.GetChild (i);
            if (child.gameObject.activeSelf) {
                activeCount++;
                rectTranList.Add (child.GetComponent<RectTransform> ());
            }
        }

        chileCount = activeCount;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    float[] GetElementsHeight () {
        float[] elemsHeight = new float[rectTranList.Count];
        for (int i = 0; i < rectTranList.Count; i++) {
            elemsHeight[i] = rectTranList[i].rect.height;
            // Debug.LogError (rectTrans[i].name + "  rectTrans[i].rect.height: " + rectTrans[i].rect.height);
        }
        return elemsHeight;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    float[] GetElementsWidth () {
        float[] elementsWidth = new float[rectTranList.Count];
        for (int i = 0; i < rectTranList.Count; i++) {
            elementsWidth[i] = rectTranList[i].rect.width;
        }
        return elementsWidth;
    }

    /// <summary>
    /// 
    /// </summary>
    void RebuildContent () {
        if (Switch_Model == SwitchModel.vertical) {
            // contentRectTran.SetAnchor (AnchorPresets.HorStretchTop);
            Rebuildvertical ();
        } else {
            // contentRectTran.SetAnchor (AnchorPresets.VertStretchLeft);
            RebuildHorizontal ();
        }
    }

    void RebuildHorizontal () {
        float tempWidth = 0;
        for (int i = 0; i < rectTranList.Count; i++) {
            if (i == 0) {
                SetAnchor (rectTranList[i]);
                rectTranList[i].anchoredPosition = new Vector2 (spacing, rectTranList[i].anchoredPosition.y);
            } else {
                SetAnchor (rectTranList[i]);
                rectTranList[i].anchoredPosition = new Vector2 ((tempWidth + (spacing * (i + 1))), rectTranList[i].anchoredPosition.y);
            }
            tempWidth += elementsWidth[i];
            // Debug.LogError("tempHeight: "+tempHeight +"  ---  elementsHeight[i]: "+elementsHeight[i]);
        }
        //content
        // contentRectTran.sizeDelta = new Vector2 (tempWidth + (spacing * rectTranList.Count) + offsetX, contentRectTran.sizeDelta.y);
        ChangeContentRect (tempWidth + (spacing * rectTranList.Count) + offsetX, contentRectTran.sizeDelta.y);
    }

    void Rebuildvertical () {
        float tempHeight = 0;
        for (int i = 0; i < rectTranList.Count; i++) {
            if (!rectTranList[i].gameObject.activeSelf)
                continue;
            if (i == 0) {
                SetAnchor (rectTranList[i]);
                rectTranList[i].anchoredPosition = new Vector2 (rectTranList[i].anchoredPosition.x, -spacing);
            } else {
                SetAnchor (rectTranList[i]);
                rectTranList[i].anchoredPosition = new Vector2 (rectTranList[i].anchoredPosition.x, -(tempHeight + (spacing * (i + 1))));
            }
            tempHeight += elementsHeight[i];
            // Debug.LogError("tempHeight: "+tempHeight +"  ---  elementsHeight[i]: "+elementsHeight[i]);
        }
        //content
        // contentRectTran.sizeDelta = new Vector2 (contentRectTran.sizeDelta.x, tempHeight + (spacing * rectTranList.Count) + offsetY);
        ChangeContentRect (contentRectTran.sizeDelta.x, tempHeight + (spacing * rectTranList.Count) + offsetY);
    }

    void ChangeContentRect (float width, float heigth) {
        if (isUseAnim) {
            Vector2 tempSize = new Vector2 ();
            tempSize = contentRectTran.sizeDelta;

            DOTween.To (() => tempSize, size => contentRectTran.sizeDelta = size, new Vector2 (width, heigth), speedAnim);

        } else {
            contentRectTran.sizeDelta = new Vector2 (width, heigth);
        }
    }

    void SetAnchor (RectTransform rectTransform) {
        switch (Child_Alignment) {
            case ChildAlignment.UpperLeft:
                rectTransform.SetAnchor (AnchorPresets.TopLeft);
                rectTransform.pivot = new Vector2 (0, 1);
                break;
            case ChildAlignment.UpperCenter:
                rectTransform.SetAnchor (AnchorPresets.TopCenter);
                rectTransform.pivot = new Vector2 (0.5f, 1);
                break;
            case ChildAlignment.UpperRight:
                rectTransform.SetAnchor (AnchorPresets.TopRight);
                rectTransform.pivot = new Vector2 (1, 1);
                break;
            case ChildAlignment.MiddleLeft:
                rectTransform.SetAnchor (AnchorPresets.MiddleLeft);
                rectTransform.pivot = new Vector2 (0, 0.5f);
                break;
            case ChildAlignment.LowerLeft:
                rectTransform.SetAnchor (AnchorPresets.BottomLeft);
                rectTransform.pivot = new Vector2 (0, 0);
                break;
        }
    }

    /// <summary>
    /// content
    /// </summary>
    public void JustRebuild (float _offsetX = 0, float _offsetY = 0) {
        offsetX = _offsetX;
        offsetY = _offsetY;
        GetElementsHW ();
        RebuildContent ();
    }

    /// <summary>
    /// content
    /// </summary>
    public void CompleteRebuild (float _offsetX = 0, float _offsetY = 0) {
        if (contentRectTran == null)
            contentRectTran = transform.GetComponent<RectTransform> ();

        offsetX = _offsetX;
        offsetY = _offsetY;
        GetAllChild ();
        GetElementsHW ();
        RebuildContent ();
    }

    public enum ChildAlignment {
        UpperLeft = 0, //
        UpperCenter = 1, //
        UpperRight = 2, //
        MiddleLeft, //
        LowerLeft, //
    }

    public enum SwitchModel {
        Horizontal,
        vertical
    }
}