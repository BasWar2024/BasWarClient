using UnityEngine;
using XLua;

public enum AnchorPresets {
    TopLeft,
    TopCenter,
    TopRight,

    MiddleLeft,
    MiddleCenter,
    MiddleRight,

    BottomLeft,
    BottonCenter,
    BottomRight,
    BottomStretch,

    VertStretchLeft,
    VertStretchRight,
    VertStretchCenter,

    HorStretchTop,
    HorStretchMiddle,
    HorStretchBottom,

    StretchAll
}

public enum PivotPresets {
    TopLeft,
    TopCenter,
    TopRight,

    MiddleLeft,
    MiddleCenter,
    MiddleRight,

    BottomLeft,
    BottomCenter,
    BottomRight,
}

public static class RectTransformExtensions
{
    public static bool Overlaps(this RectTransform a, RectTransform b)
    {
        return a.WorldRect().Overlaps(b.WorldRect());
    }
    public static bool Overlaps(this RectTransform a, RectTransform b, bool allowInverse)
    {
        return a.WorldRect().Overlaps(b.WorldRect(), allowInverse);
    }

    public static Rect WorldRect(this RectTransform rectTransform)
    {
        Vector2 sizeDelta = rectTransform.sizeDelta;
        float rectTransformWidth = sizeDelta.x * rectTransform.lossyScale.x;
        float rectTransformHeight = sizeDelta.y * rectTransform.lossyScale.y;

        Vector3 position = rectTransform.position;
        return new Rect(position.x + rectTransformWidth * rectTransform.pivot.x, position.y - rectTransformHeight * rectTransform.pivot.y, rectTransformWidth, rectTransformHeight);
    }

     /// <summary>
    /// 
    /// </summary>
    /// <param name="source"></param>
    /// <param name="allign"></param>
    /// <param name="offsetX">x</param>
    /// <param name="offsetY">y</param>
    public static void SetAnchor (this RectTransform source, AnchorPresets allign, int offsetX = 0, int offsetY = 0) {
        source.anchoredPosition = new Vector3 (offsetX, offsetY, 0);

        switch (allign) {
            case (AnchorPresets.TopLeft):
                {
                    source.anchorMin = new Vector2 (0, 1);
                    source.anchorMax = new Vector2 (0, 1);
                    break;
                }
            case (AnchorPresets.TopCenter):
                {
                    source.anchorMin = new Vector2 (0.5f, 1);
                    source.anchorMax = new Vector2 (0.5f, 1);
                    break;
                }
            case (AnchorPresets.TopRight):
                {
                    source.anchorMin = new Vector2 (1, 1);
                    source.anchorMax = new Vector2 (1, 1);
                    break;
                }

            case (AnchorPresets.MiddleLeft):
                {
                    source.anchorMin = new Vector2 (0, 0.5f);
                    source.anchorMax = new Vector2 (0, 0.5f);
                    break;
                }
            case (AnchorPresets.MiddleCenter):
                {
                    source.anchorMin = new Vector2 (0.5f, 0.5f);
                    source.anchorMax = new Vector2 (0.5f, 0.5f);
                    break;
                }
            case (AnchorPresets.MiddleRight):
                {
                    source.anchorMin = new Vector2 (1, 0.5f);
                    source.anchorMax = new Vector2 (1, 0.5f);
                    break;
                }

            case (AnchorPresets.BottomLeft):
                {
                    source.anchorMin = new Vector2 (0, 0);
                    source.anchorMax = new Vector2 (0, 0);
                    break;
                }
            case (AnchorPresets.BottonCenter):
                {
                    source.anchorMin = new Vector2 (0.5f, 0);
                    source.anchorMax = new Vector2 (0.5f, 0);
                    break;
                }
            case (AnchorPresets.BottomRight):
                {
                    source.anchorMin = new Vector2 (1, 0);
                    source.anchorMax = new Vector2 (1, 0);
                    break;
                }

            case (AnchorPresets.HorStretchTop):
                {
                    source.anchorMin = new Vector2 (0, 1);
                    source.anchorMax = new Vector2 (1, 1);
                    break;
                }
            case (AnchorPresets.HorStretchMiddle):
                {
                    source.anchorMin = new Vector2 (0, 0.5f);
                    source.anchorMax = new Vector2 (1, 0.5f);
                    break;
                }
            case (AnchorPresets.HorStretchBottom):
                {
                    source.anchorMin = new Vector2 (0, 0);
                    source.anchorMax = new Vector2 (1, 0);
                    break;
                }

            case (AnchorPresets.VertStretchLeft):
                {
                    source.anchorMin = new Vector2 (0, 0);
                    source.anchorMax = new Vector2 (0, 1);
                    break;
                }
            case (AnchorPresets.VertStretchCenter):
                {
                    source.anchorMin = new Vector2 (0.5f, 0);
                    source.anchorMax = new Vector2 (0.5f, 1);
                    break;
                }
            case (AnchorPresets.VertStretchRight):
                {
                    source.anchorMin = new Vector2 (1, 0);
                    source.anchorMax = new Vector2 (1, 1);
                    break;
                }

            case (AnchorPresets.StretchAll):
                {
                    source.anchorMin = new Vector2 (0, 0);
                    source.anchorMax = new Vector2 (1, 1);
                    break;
                }
        }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="source"></param>
    /// <param name="preset"></param>
    public static void SetPivot (this RectTransform source, PivotPresets preset) {

        switch (preset) {
            case (PivotPresets.TopLeft):
                {
                    source.pivot = new Vector2 (0, 1);
                    break;
                }
            case (PivotPresets.TopCenter):
                {
                    source.pivot = new Vector2 (0.5f, 1);
                    break;
                }
            case (PivotPresets.TopRight):
                {
                    source.pivot = new Vector2 (1, 1);
                    break;
                }

            case (PivotPresets.MiddleLeft):
                {
                    source.pivot = new Vector2 (0, 0.5f);
                    break;
                }
            case (PivotPresets.MiddleCenter):
                {
                    source.pivot = new Vector2 (0.5f, 0.5f);
                    break;
                }
            case (PivotPresets.MiddleRight):
                {
                    source.pivot = new Vector2 (1, 0.5f);
                    break;
                }

            case (PivotPresets.BottomLeft):
                {
                    source.pivot = new Vector2 (0, 0);
                    break;
                }
            case (PivotPresets.BottomCenter):
                {
                    source.pivot = new Vector2 (0.5f, 0);
                    break;
                }
            case (PivotPresets.BottomRight):
                {
                    source.pivot = new Vector2 (1, 0);
                    break;
                }
        }
    }
}
