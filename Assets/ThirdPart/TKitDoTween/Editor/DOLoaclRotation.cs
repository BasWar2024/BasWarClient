//*********************************************************************
//
//					   ScriptName 	: DORotaFormTo
//                                 
//                                 
//*********************************************************************

using System.Collections;
using DG.Tweening;
using UnityEditor;
using UnityEngine;

[CustomEditor (typeof (HCTweenLocalRotation))]
[CanEditMultipleObjects]
public class DOLoaclRotation : Editor {
    HCTweenLocalRotation obj;
    SerializedProperty m_serializedEventTrigger;

    SerializedProperty Form;
    SerializedProperty To;
    SerializedProperty easeStyle;
    SerializedProperty style;
    SerializedProperty MoveTime;
    SerializedProperty IsStartRun;
    void OnEnable () {

        obj = (HCTweenLocalRotation) target;
        m_serializedEventTrigger = serializedObject.FindProperty ("OnCompleted");

        Form = serializedObject.FindProperty ("Form");
        To = serializedObject.FindProperty ("To");
        easeStyle = serializedObject.FindProperty ("easeStyle");
        style = serializedObject.FindProperty ("style");
        MoveTime = serializedObject.FindProperty ("MoveTime");
        IsStartRun = serializedObject.FindProperty ("IsStartRun");
        // m_serializedEventTrigger = serializedObject.FindProperty ("OnCompleted");
    }

    public override void OnInspectorGUI () {
        serializedObject.Update ();
        // obj.Form = EditorGUILayout.Vector3Field("Start Position", obj.Form);
        // obj.To = EditorGUILayout.Vector3Field("End Position", obj.To);
        // obj.easeStyle = (Ease)EditorGUILayout.EnumPopup("Ease Type :", obj.easeStyle);
        // obj.style = (DoTweener.Style)EditorGUILayout.EnumPopup("Anim Type", obj.style);
        // obj.MoveTime = EditorGUILayout.FloatField("Duration Time :", obj.MoveTime);
        // obj.IsStartRun = EditorGUILayout.Toggle("Auto Play", obj.IsStartRun);

        EditorGUILayout.PropertyField (Form, new GUIContent ("Start Position: "));
        EditorGUILayout.PropertyField (To, new GUIContent ("End Position: "));
        EditorGUILayout.PropertyField (easeStyle, new GUIContent ("Ease Type: "));
        EditorGUILayout.PropertyField (style, new GUIContent ("Anim Type: "));
        EditorGUILayout.PropertyField (MoveTime, new GUIContent ("Duration Time: "));
        EditorGUILayout.PropertyField (IsStartRun, new GUIContent ("Auto Play"));
        EditorGUILayout.PropertyField (m_serializedEventTrigger, true);
        serializedObject.ApplyModifiedProperties ();
    }
}