using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClickMark : MonoBehaviour
{
    private static ClickMark instance;

    public bool afterBtnClick = false;

    private int frame = 0;

    public static ClickMark getInstance() {
        return instance;
    }

    void Awake() {
        instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (afterBtnClick) {
            if (frame >= 2) {
                afterBtnClick = false;
                frame = 0;
            }
            frame++;
        }
    }
}
