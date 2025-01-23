using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CustomReflection : MonoBehaviour {
    public Cubemap[] cubemaps;

    public void SetReflection(int i) {
        if (i >= 0 && i < cubemaps.Length) {
            RenderSettings.customReflection = cubemaps[i];
        }
    }
}
