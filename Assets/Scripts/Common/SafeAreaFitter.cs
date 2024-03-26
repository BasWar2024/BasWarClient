using UnityEngine;
public class SafeAreaFitter : MonoBehaviour {
    // Start is called before the first frame update
    public bool drag;
    public float offset;
    void Start() {
#if UNITY_IOS
        Rect safeArea = Screen.safeArea;
        float height = Screen.height - safeArea.height; //  ""
#if UNITY_EDITOR
        Debug.Log("====== " + height);
#endif
        if (height > 0 && !drag)    //""
        {
            float h = height / 2 + offset;
            RectTransform rectTransform = this.GetComponent<RectTransform>();
            Vector2 pos = rectTransform.anchoredPosition;
            pos = new Vector2(pos.x,pos.y - (h));
            rectTransform.anchoredPosition = pos;
        }
        else if(height > 0 && drag)    //""
        {
            float h = height / 2 + offset;
            RectTransform rectTransform = this.GetComponent<RectTransform>();

            Vector2 size = rectTransform.sizeDelta;
            size.y = h;
            rectTransform.sizeDelta = size;
        }
#endif
    }


}