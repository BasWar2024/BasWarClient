//*********************************************************************
//
//					   ScriptName 	: DOMoveFormTo
//                                 
//                                 
//*********************************************************************

using System.Collections;
using DG.Tweening;
using UnityEditor;
using UnityEngine;

[CustomEditor (typeof (HCTweenLocalPosition))]
[CanEditMultipleObjects]
public class DOLocalPosition : Editor {
    HCTweenLocalPosition obj;
    SerializedProperty m_serializedEventTrigger;
    SerializedProperty Form;
    SerializedProperty To;
    SerializedProperty easeStyle;
    SerializedProperty style;
    SerializedProperty MoveTime;
    SerializedProperty IsStartRun;
    SerializedProperty curve;
    SerializedProperty isUseCustomEase;
    void OnEnable () {

        obj = (HCTweenLocalPosition) target;
        Form = serializedObject.FindProperty ("Form");
        To = serializedObject.FindProperty ("To");
        easeStyle = serializedObject.FindProperty ("easeStyle");
        style = serializedObject.FindProperty ("style");
        MoveTime = serializedObject.FindProperty ("MoveTime");
        IsStartRun = serializedObject.FindProperty ("IsStartRun");
        m_serializedEventTrigger = serializedObject.FindProperty ("OnCompleted");
        curve = serializedObject.FindProperty ("curve");
        isUseCustomEase = serializedObject.FindProperty ("isUseCustomEase");
    }

    public override void OnInspectorGUI () {
        serializedObject.Update ();


        EditorGUILayout.PropertyField (Form, new GUIContent ("Start Position: "));
        EditorGUILayout.PropertyField (To, new GUIContent ("End Position: "));
        EditorGUILayout.PropertyField (isUseCustomEase, new GUIContent ("Custom Ease"));
        if (isUseCustomEase.boolValue) {
            EditorGUILayout.PropertyField (curve, new GUIContent ("Custom Ease"));
        } else {
            EditorGUILayout.PropertyField (easeStyle, new GUIContent ("Ease Type: "));
        }
        EditorGUILayout.PropertyField (style, new GUIContent ("Anim Type: "));
        EditorGUILayout.PropertyField (MoveTime, new GUIContent ("Duration Time: "));
        EditorGUILayout.PropertyField (IsStartRun, new GUIContent ("Auto Play"));
        EditorGUILayout.PropertyField (m_serializedEventTrigger, true);

        serializedObject.ApplyModifiedProperties ();
    }
}