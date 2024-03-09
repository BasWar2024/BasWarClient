//*********************************************************************
//
//					   ScriptName 	: DOScale
//                                 
//                                 
//*********************************************************************

using UnityEngine;
using System.Collections;
using UnityEditor;
using DG.Tweening;

[CustomEditor(typeof(HCTweenScale))]
[CanEditMultipleObjects]
public class DOScale : Editor
{
    HCTweenScale obj;
    SerializedProperty m_serializedEventTrigger;

    SerializedProperty formScale;
    SerializedProperty toScale;
    SerializedProperty easeStyle;
    SerializedProperty style;
    SerializedProperty animTime;
    SerializedProperty IsStartRun;
    void OnEnable()
    {
        obj = (HCTweenScale)target;

        formScale = serializedObject.FindProperty ("formScale");
		toScale = serializedObject.FindProperty ("toScale");
		easeStyle = serializedObject.FindProperty ("easeStyle");
		style = serializedObject.FindProperty ("style");
		animTime = serializedObject.FindProperty ("animTime");
		IsStartRun = serializedObject.FindProperty ("IsStartRun");
        m_serializedEventTrigger = serializedObject.FindProperty("OnCompleted");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        // obj.formScale = EditorGUILayout.Vector3Field("Start Scale", obj.formScale);
        // obj.toScale = EditorGUILayout.Vector3Field("End Scale", obj.toScale);
        // obj.easeStyle = (Ease)EditorGUILayout.EnumPopup("Ease Type :", obj.easeStyle);
        // obj.style = (DoTweener.Style)EditorGUILayout.EnumPopup("Anim Type :", obj.style);
        // obj.animTime = EditorGUILayout.FloatField("Duration Time :", obj.animTime);
        // obj.IsStartRun = EditorGUILayout.Toggle("Auto Play", obj.IsStartRun);

        EditorGUILayout.PropertyField (formScale, new GUIContent ("Start Scale: "));
		EditorGUILayout.PropertyField (toScale, new GUIContent ("End Scale: "));
		EditorGUILayout.PropertyField (easeStyle, new GUIContent ("Ease Type: "));
		EditorGUILayout.PropertyField (style, new GUIContent ("Anim Type: "));
		EditorGUILayout.PropertyField (animTime, new GUIContent ("Duration Time: "));
		EditorGUILayout.PropertyField (IsStartRun, new GUIContent ("Auto Play"));
		EditorGUILayout.PropertyField (m_serializedEventTrigger, true);
        serializedObject.ApplyModifiedProperties();
    }
}
