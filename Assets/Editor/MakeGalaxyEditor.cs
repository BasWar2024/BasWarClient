using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
[CustomEditor(typeof(MakeGalaxy))]
public class MakeGalaxyEditor : Editor {
    public override void OnInspectorGUI() {
        base.OnInspectorGUI();

        //DrawDefaultInspector();

        MakeGalaxy makeGalaxy = (MakeGalaxy)target;

        if (GUILayout.Button("""")) {
            makeGalaxy.LoadMap();
        }
        if (GUILayout.Button("""")) {
            makeGalaxy.Make();
        }
        if (GUILayout.Button("""/""")) {
            makeGalaxy.PullExcel();
        }
        if (GUILayout.Button("""")) {
            makeGalaxy.CalcCound();
        }
    }
}
#endif