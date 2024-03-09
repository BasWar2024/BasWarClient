using System;
using System.Collections;
using UnityEditor;
using UnityEditor.IMGUI.Controls;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
    /// <summary>
    /// 
    /// </summary>
    public class TileMapFilePacker : EditorWindow {
        public static void OpenPacker (string searchInFolderPath, Callback<string> cb) {
            var w = EditorWindow.GetWindow<TileMapFilePacker> ();
            w.titleContent = new GUIContent ("");
            searchInFolder = searchInFolderPath;
            cbPath = cb;
            searchField = new SearchField ();
        }
        static Callback<string> cbPath;
        static string searchInFolder;
        static SearchField searchField;
        string searchString;
        Vector2 scrollPos;
        void OnGUI () {
            GUILayout.Space (10);
            GUILayout.BeginHorizontal (EditorStyles.toolbar);
            var rect = GUILayoutUtility.GetRect (1, 200, 1, 18);
            searchString = searchField.OnToolbarGUI (rect, searchString);
            GUILayout.EndHorizontal ();

            var allFiles = AssetDatabase.FindAssets (searchString, new string[] { searchInFolder });

            scrollPos = EditorGUILayout.BeginScrollView (scrollPos, GUI.skin.box);

            foreach (var item in allFiles) {
                var path = AssetDatabase.GUIDToAssetPath (item);
                if (GUILayout.Button (path, GUI.skin.button)) {
                    if (cbPath != null) {
                        cbPath (path);
                    }
                    this.Close ();
                }
            }

            EditorGUILayout.EndScrollView ();
        }
    }
}