using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBar : MonoBehaviour {
    MeshRenderer healthBar;
    MaterialPropertyBlock Block;
    public Color grey, blue, red;
    void Awake () {
        healthBar = this.transform.GetComponent<MeshRenderer> ();
        healthBar.sortingLayerName = "HUD";
        Block = new MaterialPropertyBlock ();
    }

    public void SetHealthBar (float percent, int colorIndex) {
        SetHealthBarColor (colorIndex);
        SetHealthBarPercent (percent);
    }

    public void SetHealthBarPercent (float percent) {
        healthBar.GetPropertyBlock (Block);
        Block.SetFloat ("_Percent", percent);
        healthBar.SetPropertyBlock (Block);
    }
    public void SetHealthBarColor (int colorIndex) {
        var col = Color.white;
        switch (colorIndex) {
            case 0:
                col = grey;
                break;
            case 1:
                col = blue;
                break;
            case 2:
                col = red;
                break;
        }
        healthBar.GetPropertyBlock (Block);
        Block.SetColor ("_MainColor", col);
        healthBar.SetPropertyBlock (Block);
    }
}