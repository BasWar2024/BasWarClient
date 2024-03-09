using UnityEditor;
using UnityEngine;

namespace GG {
	[CustomEditor (typeof (BaseScrollController<>), true)]
	public class BaseControllerEditor : Editor {
		public override void OnInspectorGUI () {
			serializedObject.Update ();
			DrawPropertiesExcluding (serializedObject, "m_Script");
			serializedObject.ApplyModifiedProperties ();
		}
	}
}