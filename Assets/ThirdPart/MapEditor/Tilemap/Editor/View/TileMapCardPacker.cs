using System;
using System.Collections;
using SimpleJson;
using UnityEditor;
using UnityEditor.IMGUI.Controls;
using UnityEngine;
namespace CanglxMapEditor.Tilemapping {
    public class TileMapCardPacker : EditorWindow {
        public static void OpenPacker (Callback<int> cb) {
            var w = EditorWindow.GetWindow<TileMapCardPacker> ();
            w.titleContent = new GUIContent ("");
            cbPath = cb;
            searchField = new SearchField ();

            jsonObj = getJson ("Assets/ThirdPart/MapEditor/Editor/cfg/card.json");
        }
        static JsonObject jsonObj;
        static Callback<int> cbPath;
        static SearchField searchField;
        string searchString;
        Vector2 scrollPos;
        void OnGUI () {
            GUILayout.Space (10);
            GUILayout.BeginHorizontal (EditorStyles.toolbar);
            var rect = GUILayoutUtility.GetRect (1, 200, 1, 18);
            searchString = searchField.OnToolbarGUI (rect, searchString);
            GUILayout.EndHorizontal ();

            scrollPos = EditorGUILayout.BeginScrollView (scrollPos, GUI.skin.box);

            foreach (JsonObject item in jsonObj.Values) {
                var id = item.GetInt ("id");
                var name = item.GetString ("name");

                if (searchString != "" && searchString != null) {
                    if (!name.Contains (searchString) && !id.ToString ().Contains (searchString)) continue;
                }

                if (GUILayout.Button ("" + id + " " + name, GUI.skin.button)) {
                    if (cbPath != null) {
                        cbPath (id);
                    }
                    this.Close ();
                }
            }

            EditorGUILayout.EndScrollView ();
        }

        static SimpleJson.JsonObject getJson (string path) {
            string jsonText = AssetDatabase.LoadAssetAtPath<TextAsset> (path).text;
            return SimpleJson.SimpleJson.DeserializeObject<JsonObject> (jsonText);
        }
    }
}