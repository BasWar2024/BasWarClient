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

[CustomEditor(typeof(HCTweenSpriteAlpha))]
[CanEditMultipleObjects]
public class DoSpriteAlpha : Editor
{
    HCTweenSpriteAlpha obj;
    SerializedProperty m_serializedEventTrigger;

    SerializedProperty StartAlpha;
    SerializedProperty EndAlpha;
    SerializedProperty easeStyle;
    SerializedProperty style;
    SerializedProperty durtion;
    SerializedProperty IsStartRun;
    void OnEnable()
    {
        obj = (HCTweenSpriteAlpha)target;

        StartAlpha = serializedObject.FindProperty ("StartAlpha");
		EndAlpha = serializedObject.FindProperty ("EndAlpha");
		easeStyle = serializedObject.FindProperty ("easeStyle");
		style = serializedObject.FindProperty ("style");
		durtion = serializedObject.FindProperty ("durtion");
        IsStartRun = serializedObject.FindProperty ("IsStartRun");
        m_serializedEventTrigger = serializedObject.FindProperty("OnCompleted");
    }
    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        // EditorGUILayout.LabelField("Start Alpha :");
        // obj.StartAlpha = EditorGUILayout.Slider(obj.StartAlpha, 0, 1);
        // EditorGUILayout.LabelField("End   Alpha :");
        // obj.EndAlpha = EditorGUILayout.Slider(obj.EndAlpha, 0, 1);
        // obj.easeStyle = (Ease)EditorGUILayout.EnumPopup("Ease Type :", obj.easeStyle);
        // obj.style = (DoTweener.Style)EditorGUILayout.EnumPopup("Anim Type :", obj.style);
        // obj.durtion = EditorGUILayout.FloatField("Duration Time :", obj.durtion);

        // obj.IsStartRun = EditorGUILayout.Toggle("Auto Play", obj.IsStartRun);

        EditorGUILayout.Slider (StartAlpha, 0, 1);
        EditorGUILayout.Slider (EndAlpha, 0, 1);
        EditorGUILayout.PropertyField (easeStyle, new GUIContent ("Ease Type: "));
        EditorGUILayout.PropertyField (style, new GUIContent ("Anim Type: "));
        EditorGUILayout.PropertyField (durtion, new GUIContent ("Duration Time: "));
        EditorGUILayout.PropertyField (IsStartRun, new GUIContent ("Auto Play"));
        EditorGUILayout.PropertyField(m_serializedEventTrigger, true);
        serializedObject.ApplyModifiedProperties();
    }


}
