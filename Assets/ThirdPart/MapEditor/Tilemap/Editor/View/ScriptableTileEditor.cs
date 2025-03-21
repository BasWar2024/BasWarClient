using CanglxMapEditor.Utillity;
using GG.Tilemapping;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditorInternal;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
	public class ScriptableTileEditor : Editor {
		protected ScriptableTile scriptableTile;

		public override void OnInspectorGUI () {
			base.OnInspectorGUI ();
		}
		protected override void OnHeaderGUI () {

			scriptableTile = target as ScriptableTile;

			if (scriptableTile == null)
				return;

			Rect headerRect = new Rect (0, 0, Screen.width, 50);
			GUILayout.BeginArea (headerRect, new GUIStyle ("IN ThumbnailShadow"));
			Rect contentRect = new Rect (10, 10, Screen.width - 20, 30);
			var texture = scriptableTile.GetIcon ();
			if (texture != null)
				GUI.DrawTexture (new Rect (contentRect.x, contentRect.y, contentRect.height, contentRect.height), scriptableTile.GetIcon (), ScaleMode.ScaleAndCrop);
			contentRect.x += contentRect.height + 10;
			contentRect.width -= contentRect.x;
			GUI.Label (new Rect (contentRect.x, contentRect.y, contentRect.width, contentRect.height / 2), scriptableTile.name, MyStyles.leftBoldLabel);
			GUI.Label (new Rect (contentRect.x, contentRect.y + contentRect.height / 2, contentRect.width, contentRect.height / 2), "Tile Type: " + scriptableTile.GetType ().Name, MyStyles.leftMiniLabel);
			GUIContent content = new GUIContent (EditorGUIUtility.FindTexture ("_Help"), "Open Reference for " + scriptableTile.GetType ().Name);

			GUILayout.EndArea ();
			GUILayout.Space (headerRect.height + 10);
		}
		/*
		[DidReloadScripts]
		static ScriptableTileEditor ()
		{
			EditorApplication.projectWindowItemOnGUI = ItemOnGUI;
		}

		static void ItemOnGUI (string guid, Rect rect)
		{
			string assetPath = AssetDatabase.GUIDToAssetPath (guid);

			ScriptableTile obj = AssetDatabase.LoadAssetAtPath (assetPath, typeof (ScriptableTile)) as ScriptableTile;

			if (obj != null)
			{
				rect.width = rect.height;
				GUI.DrawTexture (rect, new Texture2D(16, 16));
				GUI.DrawTexture (rect, obj.GetTexture (null, Point.zero));
				GUI.Label (rect, obj.Name, UI.CustomStyles.centerWhiteBoldLabel);
			}
		}
		*/
	}
}