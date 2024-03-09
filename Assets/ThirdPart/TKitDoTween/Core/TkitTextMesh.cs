using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TkitTextMesh : MonoBehaviour
{

    public Color color;
    void Awake()
    {
        color = this.GetComponent<Text>().color;
    }
}
