using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetBgObjScaleByScreenSize : MonoBehaviour
{
    public float defaultWidth = 1920;
    public float defaultHeight = 1080;
    // Start is called before the first frame update

    void Awake() {
        float screenWidth = UnityEngine.Screen.width;
        float screenHeight = UnityEngine.Screen.height;

        float defaultProportion = defaultWidth / defaultHeight;
        float screenProportion = screenWidth / screenHeight;

        float w;
        float h;

        if (screenProportion >= defaultProportion) {
            if(screenWidth>= defaultWidth) {
                w = screenWidth;
            }
            else {
                w = defaultHeight * screenProportion;
            }
            h = w / defaultProportion;
        }
        else {
            if(screenHeight >= defaultHeight) {
                h = screenHeight;
            }
            else {
                h = defaultWidth / screenProportion;
            }
            w = h * defaultProportion;
        }

        transform.localScale = new Vector3(w, h, 1);
    }
}
