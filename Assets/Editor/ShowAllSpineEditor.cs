using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
[CustomEditor(typeof(ShowAllSpine))]
public class ShowAllSpineEditor : Editor {
    public override void OnInspectorGUI() {
        base.OnInspectorGUI();

        ShowAllSpine showAllSpine = (ShowAllSpine)target;
        

        if (GUILayout.Button("""Spine")) {
            showAllSpine.ShowAll();
            EditorUtility.SetDirty(target);
        }
    }
}
#endif