//*********************************************************************
//
//					   ScriptName 	: DoColor
//                                 
//                                 
//*********************************************************************

using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEditor;
using UnityEngine;

[CustomEditor (typeof (HCTweenSpriteColor))]
[CanEditMultipleObjects]
public class DoSpriteColor : Editor {

	HCTweenSpriteColor obj;
	SerializedProperty m_serializedEventTrigger;

	SerializedProperty StartColor;
    SerializedProperty EndColor;
    SerializedProperty easeStyle;
    SerializedProperty style;
    SerializedProperty durtion;
    SerializedProperty IsStartRun;
	void OnEnable () {
		obj = (HCTweenSpriteColor) target;

		StartColor = serializedObject.FindProperty ("StartColor");
		EndColor = serializedObject.FindProperty ("EndColor");
		easeStyle = serializedObject.FindProperty ("easeStyle");
		style = serializedObject.FindProperty ("style");
		durtion = serializedObject.FindProperty ("durtion");
        IsStartRun = serializedObject.FindProperty ("IsStartRun");
		m_serializedEventTrigger = serializedObject.FindProperty ("OnCompleted");
	}
	public override void OnInspectorGUI () {
		serializedObject.Update ();
		// EditorGUILayout.LabelField ("Start Color :");
		// obj.StartColor = EditorGUILayout.ColorField (obj.StartColor);
		// EditorGUILayout.LabelField ("End   Color :");
		// obj.EndColor = EditorGUILayout.ColorField (obj.EndColor);
		// obj.easeStyle = (Ease) EditorGUILayout.EnumPopup ("Ease Type :", obj.easeStyle);
		// obj.style = (DoTweener.Style) EditorGUILayout.EnumPopup ("Anim Type :", obj.style);
		// obj.durtion = EditorGUILayout.FloatField ("Duration Time :", obj.durtion);

		// obj.IsStartRun = EditorGUILayout.Toggle ("Auto Play", obj.IsStartRun);

		EditorGUILayout.PropertyField (StartColor, new GUIContent ("Start Color: "));
        EditorGUILayout.PropertyField (EndColor, new GUIContent ("End Color: "));
        EditorGUILayout.PropertyField (easeStyle, new GUIContent ("Ease Type: "));
        EditorGUILayout.PropertyField (style, new GUIContent ("Anim Type: "));
        EditorGUILayout.PropertyField (durtion, new GUIContent ("Duration Time: "));
        EditorGUILayout.PropertyField (IsStartRun, new GUIContent ("Auto Play"));
		EditorGUILayout.PropertyField (m_serializedEventTrigger, true);

		//multiple
		// foreach (HCTweenSpriteColor objMulti in targets) {
		// 	objMulti.StartColor = obj.StartColor;
		// 	objMulti.EndColor = obj.EndColor;
		// 	objMulti.easeStyle = obj.easeStyle;
		// 	objMulti.style = obj.style;
		// 	objMulti.durtion = obj.durtion;
		// 	objMulti.IsStartRun = obj.IsStartRun;
		// }

		serializedObject.ApplyModifiedProperties ();

	}

}