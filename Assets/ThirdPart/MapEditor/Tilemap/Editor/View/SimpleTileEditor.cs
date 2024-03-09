using CanglxMapEditor.Utillity;
using GG.Tilemapping;
using UnityEditor;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
	[CustomEditor (typeof (SimpleTile))]
	public class TileCustomEditor : ScriptableTileEditor {
		private SimpleTile tile;
		SerializedProperty sprite;
		SerializedProperty gridId;
		SerializedProperty terrian;
		private void OnEnable () {
			tile = (SimpleTile) target;
			// tile = serializedObject.targetObject as SimpleTile;
			sprite = serializedObject.FindProperty ("sprite");
			terrian = serializedObject.FindProperty ("terrian");
			gridId = serializedObject.FindProperty ("GridID");
		}
		public override void OnInspectorGUI () {

			serializedObject.Update ();

			GUILayout.Space (10);
			EditorGUILayout.HelpBox ("As simple as it comes, renders the sprite selected", MessageType.Info);
			GUILayout.Space (10);

			GUILayout.Label ("GridID:", MyStyles.leftBoldLabel);
			gridId.intValue = EditorGUILayout.IntField (gridId.intValue, MyStyles.leftBoldLabel);
			GUILayout.Space (10);

			// GUILayout.Label ("Terrian:", MyStyles.leftBoldLabel);
			// var iEnum = (TerrianType) EditorGUILayout.EnumPopup ((TerrianType) terrian.enumValueIndex);
			// terrian.enumValueIndex = (int) iEnum;

			GUILayout.Space (10);

			GUILayout.Label ("Sprite:", MyStyles.leftBoldLabel);

			float width = EditorGUIUtility.labelWidth;
			if (!tile.IsValid) {
				GUI.color = new Color (1, 0.5f, 0.5f);
			}
			if (GUILayout.Button (GUIContent.none, MyStyles.centerWhiteBoldLabel, GUILayout.Width (width), GUILayout.Height (width))) {
				EditorGUIUtility.ShowObjectPicker<Sprite> (tile.sprite, false, "", 0);
			}
			Rect r = GUILayoutUtility.GetLastRect ();

			Texture2D texture = tile.IsValid ? tile.sprite.ToTexture2D () : new Texture2D (16, 16);
			GUI.DrawTexture (r, texture);
			GUI.color = Color.white;

			GUIStyle labelStyle = new GUIStyle (MyStyles.centerWhiteBoldLabel);
			if (!tile.sprite)
				GUI.Label (r, "Tile not valid!\nSprite cannot be left empty", labelStyle);
			else if (!tile.IsValid)
				GUI.Label (r, "Tile not valid!\nEnable Read/Write in import settings", labelStyle);

			/*
			if (!tile.sprite) 
				EditorGUILayout.HelpBox ("This tile is not valid, main sprite (15) cannot be left empty.", MessageType.Error);
			else if (!tile.IsValid)
				EditorGUILayout.HelpBox ("This tile is not valid, please check that Read/Write is enabled in the main sprite (15)'s import settings", MessageType.Error);
			*/
			if (Event.current.commandName == "ObjectSelectorUpdated") {
				// tile.sprite = EditorGUIUtility.GetObjectPickerObject () as Sprite;
				sprite.objectReferenceValue = EditorGUIUtility.GetObjectPickerObject () as Sprite;
				tile.SetSprite (EditorGUIUtility.GetObjectPickerObject () as Sprite);
			}

			if (GUI.changed) {
				EditorUtility.SetDirty (this);
			}

			// 
			serializedObject.ApplyModifiedProperties ();
		}
	}
}