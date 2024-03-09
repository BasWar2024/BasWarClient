//*********************************************************************
//
//					   ScriptName 	: DoAlpha
//                                 
//                                 
//*********************************************************************

using System.Collections;
using DG.Tweening;
using UnityEditor;
using UnityEngine;

[CustomEditor (typeof (HCTweenAlpha))]
[CanEditMultipleObjects]
public class DoAlpha : Editor {
    HCTweenAlpha[] HCTobjs;
    SerializedProperty m_serializedEventTrigger;

    SerializedProperty StartAlpha;
    SerializedProperty EndAlpha;
    SerializedProperty easeStyle;
    SerializedProperty style;
    SerializedProperty durtion;
    SerializedProperty IsStartRun;
    void OnEnable () {
        // Object[] monoObjects = targets;
        // HCTobjs = new HCTweenAlpha[monoObjects.Length];
        // for (int i = 0; i < monoObjects.Length; i++) {
        //     HCTobjs[i] = monoObjects[i] as HCTweenAlpha;
        // }

        StartAlpha = serializedObject.FindProperty ("StartAlpha");
        EndAlpha = serializedObject.FindProperty ("EndAlpha");
        easeStyle = serializedObject.FindProperty ("easeStyle");
        style = serializedObject.FindProperty ("style");
        durtion = serializedObject.FindProperty ("durtion");
        IsStartRun = serializedObject.FindProperty ("IsStartRun");

        m_serializedEventTrigger = serializedObject.FindProperty ("OnCompleted");
    }
    public override void OnInspectorGUI () {
        serializedObject.Update ();

        // for (int i = 0; i < HCTobjs.Length; i++) {

        //     EditorGUILayout.LabelField ("Start Alpha :");
        // HCTobjs[i].StartAlpha = EditorGUILayout.Slider (HCTobjs[i].StartAlpha, 0, 1);
        //     EditorGUILayout.LabelField ("End   Alpha :");
        //     HCTobjs[i].EndAlpha = EditorGUILayout.Slider (HCTobjs[i].EndAlpha, 0, 1);
        //     HCTobjs[i].easeStyle = (Ease) EditorGUILayout.EnumPopup ("Ease Type :", HCTobjs[i].easeStyle);
        //     HCTobjs[i].style = (DoTweener.Style) EditorGUILayout.EnumPopup ("Anim Type :", HCTobjs[i].style);
        //     HCTobjs[i].durtion = EditorGUILayout.FloatField ("Duration Time :", HCTobjs[i].durtion);

        //     HCTobjs[i].IsStartRun = EditorGUILayout.Toggle ("Auto Play", HCTobjs[i].IsStartRun);
        //     
        // }

        // EditorGUILayout.Slider (StartAlpha, 0f, 10f, new GUIContent ("Start Alpha: "));
        EditorGUILayout.Slider (StartAlpha, 0, 1);
        EditorGUILayout.Slider (EndAlpha, 0, 1);
        EditorGUILayout.PropertyField (easeStyle, new GUIContent ("Ease Type: "));
        EditorGUILayout.PropertyField (style, new GUIContent ("Anim Type: "));
        EditorGUILayout.PropertyField (durtion, new GUIContent ("Duration Time: "));
        EditorGUILayout.PropertyField (IsStartRun, new GUIContent ("Auto Play"));
        EditorGUILayout.PropertyField (m_serializedEventTrigger, true);
        serializedObject.ApplyModifiedProperties ();
    }

}