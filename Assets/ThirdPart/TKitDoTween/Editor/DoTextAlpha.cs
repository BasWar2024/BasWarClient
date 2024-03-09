//*********************************************************************
//
//					   ScriptName 	: DoAlpha
//                                 
//                                 
//*********************************************************************

using UnityEngine;
using System.Collections;
using UnityEditor;
using DG.Tweening;

[CustomEditor(typeof(HCTweenTextAlpha))]
[CanEditMultipleObjects]
public class DoTextAlpha : Editor
{
    HCTweenTextAlpha obj;
    SerializedProperty m_serializedEventTrigger; 
    void OnEnable()
    {
        obj = (HCTweenTextAlpha)target;
        m_serializedEventTrigger = serializedObject.FindProperty("OnCompleted");
    }
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUILayout.LabelField("Start Alpha :");
        obj.StartAlpha = EditorGUILayout.Slider(obj.StartAlpha, 0, 1);
        EditorGUILayout.LabelField("End   Alpha :");
        obj.EndAlpha = EditorGUILayout.Slider(obj.EndAlpha, 0, 1);
        obj.easeStyle = (Ease)EditorGUILayout.EnumPopup("Ease Type :", obj.easeStyle);
        obj.style = (DoTweener.Style)EditorGUILayout.EnumPopup("Anim Type :", obj.style);
        obj.durtion = EditorGUILayout.FloatField("Duration Time :", obj.durtion);

        obj.IsStartRun = EditorGUILayout.Toggle("Auto Play", obj.IsStartRun);
        EditorGUILayout.PropertyField(m_serializedEventTrigger,true);
        serializedObject.ApplyModifiedProperties();
    }


}
