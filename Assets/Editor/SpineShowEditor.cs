using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;

[CustomEditor(typeof(SpineShow))]
public class SpineShowEditor : Editor {
    SpineShow spineShow;
    List<string> attachmentNames;
    private void Awake() {
        spineShow = (SpineShow)target;
        attachmentNames = spineShow.GetAttachmentList();
    }


    public override void OnInspectorGUI() {
        base.OnInspectorGUI();

        //DrawDefaultInspector();

        foreach (string name in attachmentNames) {

            if (GUILayout.Button(name)) {
                spineShow.setAttachmentName(name);
                EditorUtility.SetDirty(target);
            }
        }
    }
}
#endif
