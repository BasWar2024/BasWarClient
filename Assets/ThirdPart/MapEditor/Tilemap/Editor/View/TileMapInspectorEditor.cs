using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using GG.Tilemapping;
using SimpleJson;
using UnityEditor;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
    partial class TileMapEditor : Editor {
        SerializedProperty spWidth;
        SerializedProperty spHeight;
        SerializedProperty spScale;

        double gridSize = 0.5;
        bool isEditingMap = true;
        int mapMaxX = 12;
        int mapMaxY = 20;
        string mapName = "Map";
        string levelName = "Level";
        public const string mapCfgPath = "Assets/ThirdPart/MapEditor/Editor/cfg/grid.json";
        public const string mapTerrianCfgPath = "Assets/ThirdPart/MapEditor/Editor/cfg/terrian.json";
        public const string mapMapPath = "Assets/Lua/etc/map";
        public const string mapPrefabPath = "Assets/Lua/etc/prefab";

        partial void OnInspectorEnable () {
            spWidth = serializedObject.FindProperty ("width");
            spHeight = serializedObject.FindProperty ("height");
            spScale = serializedObject.FindProperty ("unitScale");
        }

        partial void OnInspectorDisable () {

        }
        public override void OnInspectorGUI () {
            serializedObject.Update ();

            if (tileMap.tileMapEditorMode == TileMapEditorMode.MapEditor) {
                MapEditorInspector ();
            } else if (tileMap.tileMapEditorMode == TileMapEditorMode.PrefabsEditor) {
                PrefabsEditor ();
            } else {
                LevelEditorInspector ();
            }

            EditorModeChange ();

            serializedObject.ApplyModifiedProperties ();
        }
        void EditorModeChange () {
            //
            if (Event.current.type == EventType.KeyDown && Event.current.isKey && Event.current.keyCode == KeyCode.Tab) {
                tileMap.isInEditMode = !tileMap.isInEditMode;
            }
            if (Event.current.type == EventType.KeyDown && Event.current.isKey && Event.current.keyCode == KeyCode.Escape) {
                tileMap.isInEditMode = false;
            }
        }
        //
        void PrefabsEditor () {
            GUILayout.BeginHorizontal ();
            GUILayout.Label ("", new GUILayoutOption[] { GUILayout.MaxWidth (90) });
            levelName = EditorGUILayout.TextField (levelName);

            if (GUILayout.Button ("")) {
                TileMapFilePacker.OpenPacker (mapPrefabPath, path => {
                    if (path != string.Empty) {
                        loadMap (path, true);
                    }
                });
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("  ");
            GUILayout.Label ("X  ");
            mapMaxX = EditorGUILayout.IntField (mapMaxX);
            GUILayout.Label ("Y  ");
            mapMaxY = EditorGUILayout.IntField (mapMaxY);
            GUILayout.EndHorizontal ();

            if (mapMaxX > 0 && mapMaxY > 0) {
                tileMap.Resize (mapMaxX, mapMaxY, (int) (gridSize * 100));
            }

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("ID: " + tileMap.currentCardID);
            if (GUILayout.Button ("")) {
                TileMapCardPacker.OpenPacker (id => {
                    tileMap.currentCardID = id;
                });
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("");
            var newMode = (SpecialDrawMode) EditorGUILayout.EnumPopup (tileMap.specialDrawMode);
            if (tileMap.specialDrawMode != newMode) {
                tileMap.specialDrawMode = newMode;
                tileMap.UpdateTileMap ();
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("");
            tileMap.camp = (CampType) EditorGUILayout.EnumPopup (tileMap.camp);
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("");
            tileMap.tileMapDirection = (TileMapDirection) EditorGUILayout.EnumPopup (tileMap.tileMapDirection);
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            if (GUILayout.Button ("")) {
                newMap ("prefab", true);
                tileMap.Reset ();
                tileMap.Resize (mapMaxX, mapMaxY, (int) (gridSize * 100));
            }
            if (GUILayout.Button ("")) {
                saveMap ("prefab", true);
            }
            if (GUILayout.Button ("")) {
                deleteMap ("prefab", true);
            }
            GUI.color = new Color (1f, 0.5f, 0.5f);
            if (GUILayout.Button ("")) {
                if (EditorUtility.DisplayDialog ("?", "?", "", "")) {
                    tileMap.Reset ();
                    SetTileMapDirty ();
                }
            }
            GUI.color = Color.white;
            GUILayout.EndHorizontal ();
        }

        void MapEditorInspector () {

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("", new GUILayoutOption[] { GUILayout.MaxWidth (90) });
            mapName = EditorGUILayout.TextField (mapName);

            if (GUILayout.Button ("")) {
                TileMapFilePacker.OpenPacker (mapMapPath, path => {
                    if (path != string.Empty) {
                        loadMap (path);
                    }
                });
            }

            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("  ");
            GUILayout.Label ("X  ");
            mapMaxX = EditorGUILayout.IntField (mapMaxX);
            GUILayout.Label ("Y  ");
            mapMaxY = EditorGUILayout.IntField (mapMaxY);
            GUILayout.EndHorizontal ();

            if (mapMaxX > 0 && mapMaxY > 0) {
                tileMap.Resize (mapMaxX, mapMaxY, (int) (gridSize * 100));
            }

            GUILayout.BeginHorizontal ();
            if (GUILayout.Button ("")) {
                newMap ("map");
            }
            if (GUILayout.Button ("")) {
                saveMap ("map");
            }
            if (GUILayout.Button ("")) {
                deleteMap ("map");
            }
            GUI.color = new Color (1f, 0.5f, 0.5f);
            if (GUILayout.Button ("")) {
                if (EditorUtility.DisplayDialog ("?", "?", "", "")) {
                    tileMap.Reset ();
                    SetTileMapDirty ();
                }
            }
            GUI.color = Color.white;
            GUILayout.EndHorizontal ();
        }
        /// <summary>
        /// 
        /// </summary>
        void LevelEditorInspector () {
            GUILayout.BeginHorizontal ();
            GUILayout.Label ("", new GUILayoutOption[] { GUILayout.MaxWidth (90) });
            levelName = EditorGUILayout.TextField (levelName);
            if (GUILayout.Button ("")) {
                TileMapFilePacker.OpenPacker (mapMapPath, path => {
                    if (path != string.Empty) {
                        loadMap (path, true);
                    }
                });
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("", new GUILayoutOption[] { GUILayout.MaxWidth (90) });
            mapName = EditorGUILayout.TextField (mapName);
            if (GUILayout.Button ("")) {
                TileMapFilePacker.OpenPacker (mapMapPath, path => {
                    if (path != string.Empty) {
                        loadMap (path);
                    }
                });
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("ID: " + tileMap.currentCardID);
            if (GUILayout.Button ("")) {
                TileMapCardPacker.OpenPacker (id => {
                    tileMap.currentCardID = id;
                });
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("");
            var newMode = (SpecialDrawMode) EditorGUILayout.EnumPopup (tileMap.specialDrawMode);
            if (tileMap.specialDrawMode != newMode) {
                tileMap.specialDrawMode = newMode;
                tileMap.UpdateTileMap ();
            }
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("");
            tileMap.camp = (CampType) EditorGUILayout.EnumPopup (tileMap.camp);
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            GUILayout.Label ("");
            tileMap.tileMapDirection = (TileMapDirection) EditorGUILayout.EnumPopup (tileMap.tileMapDirection);
            GUILayout.EndHorizontal ();

            GUILayout.BeginHorizontal ();
            if (GUILayout.Button ("")) {
                newMap ("map", true);
            }
            if (GUILayout.Button ("")) {
                saveMap ("map", true);
            }
            if (GUILayout.Button ("")) {
                deleteMap ("map", true);
            }
            GUI.color = new Color (1f, 0.5f, 0.5f);
            if (GUILayout.Button ("")) {
                if (EditorUtility.DisplayDialog ("?", "?", "", "")) {
                    tileMap.Reset ();
                    SetTileMapDirty ();
                }
            }
            GUI.color = Color.white;
            GUILayout.EndHorizontal ();
        }

        void newMap (string floder, bool isLevel = false) {
            string path = isLevel?getPathByName (floder, levelName) : getPathByName (floder, mapName);
            if (File.Exists (path)) {
                Debug.LogErrorFormat ("op=newMap,path={0},fail=", path);
                return;
            }
            Debug.Log ("newMap " + path);
            enterEditMode (true);
            if (!isLevel) {
                tileMap.Reset ();
                tileMap.Resize (mapMaxX, mapMaxY, (int) (gridSize * 100));
            }
        }

        void loadMap (string path, bool isLevel = false) {
            Debug.Log ("loadMap from " + path);
            if (isLevel) {
                levelName = getNameByPath (path);
            } else {
                mapName = getNameByPath (path);
            }
            enterEditMode (true);
            var map = MapLib.Map.deserializeFromFile (path);
            mapMaxX = map.maxX;
            mapMaxY = map.maxY;
            tileMap.Reset ();
            tileMap.Resize (map.maxX, map.maxY, (int) (map.gridSize * 100));

            for (int x = 0; x < map.maxX; x++) {
                for (int y = 0; y < map.maxY; y++) {
                    var grid = map.getGrid (x, y);
                    var tile = getScriptableTile (grid.type);
                    if (tile != null) {
                        if (isLevel) {
                            var clone = UnityEngine.Object.Instantiate (tile);
                            clone.name = "_Clone";
                            clone.CampID = grid.camp;
                            int dir = 0;
                            getCardEventId (grid.eventId, out clone.CardID, out clone.CardCamp, out dir);

                            // Debug.LogError ("clone.CardID " + clone.CardID + " clone.CardCamp " + clone.CardCamp + "  dir " + dir);
                            clone.Direction = (TileMapDirection) Enum.Parse (typeof (TileMapDirection), dir.ToString ());

                            tileMap.SetTileAt (x, y, clone);
                        } else {
                            tileMap.SetTileAt (x, y, tile);
                        }

                    }
                }
            }
        }

        void saveMap (string floder, bool isLevel = false) {
            if (!isEditingMap) {
                return;
            }

            var map = new MapLib.Map (0, 0, tileMap.Width, tileMap.Height, tileMap.UnitScale, 1);
            var json = getJson (mapCfgPath);
            var jsonTerrian = getJson (mapTerrianCfgPath);
            for (int x = 0; x < tileMap.Width; x++) {
                for (int y = 0; y < tileMap.Height; y++) {
                    var grid = tileMap.Map[x + y * tileMap.Width];
                    if (grid != null) {
                        var terrianId = json.GetJsonObject (grid.GridID.ToString ()).GetInt ("terrian");
                        var terrianCfg = jsonTerrian.GetJsonObject (terrianId.ToString ());
                        var terrian = toTerrian (terrianCfg);
                        // Debug.LogError("grid.GridID "+grid.GridID);
                        if (isLevel) {
                            map.setGrid (x, y, 0, terrian, grid.GridID, grid.CampID, toCardEventId (grid.CardID, grid.CardCamp, (int) grid.Direction));
                        } else {
                            map.setGrid (x, y, 0, terrian, grid.GridID, 0, 0);
                        }
                    }
                }
            }
            string path = isLevel? getPathByName (floder, levelName) : getPathByName (floder, mapName);
            if (path != null && path != "") {
                Debug.Log ("saveMap to " + path);
                map.serializeToFile (path);
            }
            AssetDatabase.Refresh ();
        }

        void deleteMap (string floder, bool isLevel = false) {
            string path = isLevel?getPathByName (floder, levelName) : getPathByName (floder, mapName);
            Debug.Log ("deleteMap " + path);
            File.Delete (path);
            File.Delete (path + ".meta");
            AssetDatabase.Refresh ();
        }

        int toTerrian (JsonObject terrianCfg) {
            int terrian = 1 << terrianCfg.GetInt ("id");
            return terrian;
        }
        ulong toCardEventId (int cardId, int cardCamp, int dir) {
            // Debug.LogError ("========== :: " + (cardId << 6 | cardCamp << 3 | dir));
            return (((ulong)cardId << 15) | ((ulong) cardCamp << 3) | (ulong) dir);
        }
        void getCardEventId (ulong eventId, out int cardId, out int cardCamp, out int dir) {

            ulong campMask = (1 << 12) - 1;
            cardId = (int) (eventId >> 15);
            cardCamp = (int) ((eventId >> 3) & campMask);
            dir = (int) ((eventId) & 0x00000007);
        }

        int getPrefabSize (out int minX, out int minY, out int maxX, out int maxY) {
            var json = getJson (mapCfgPath);
            int gridCount = 0;
            minX = tileMap.Width;
            minY = tileMap.Height;
            maxX = 0;
            maxY = 0;
            for (int x = 0; x < tileMap.Width; x++) {
                for (int y = 0; y < tileMap.Height; y++) {
                    var grid = tileMap.Map[x + y * tileMap.Width];
                    if (grid != null) {
                        int terrian = json.GetJsonObject (grid.GridID.ToString ()).GetInt ("terrian");
                        if (terrian != 0) {
                            gridCount++;
                            if (x < minX) {
                                minX = x;
                            }
                            if (x > maxX) {
                                maxX = x;
                            }
                            if (y < minY) {
                                minY = y;
                            }
                            if (y > maxY) {
                                maxY = y;
                            }
                        }
                    }
                }
            }
            return gridCount;
        }

        ScriptableTile getScriptableTile (int gridId) {
            foreach (var scriptable in tileMap.scriptableTileCache) {
                if (scriptable.GridID == gridId) {
                    return scriptable;
                }
            }
            return null;
        }

        SimpleJson.JsonObject getJson (string path) {
            string jsonText = AssetDatabase.LoadAssetAtPath<TextAsset> (path).text;
            return SimpleJson.SimpleJson.DeserializeObject<JsonObject> (jsonText);
        }

        void enterEditMode (bool isEditingMap) {
            this.isEditingMap = isEditingMap;

            tileMap.isInEditMode = true;
            OnEnterEditMode ();
        }

        string getNameByPath (string path) {
            return Path.GetFileNameWithoutExtension (path);
        }

        string getPathByName (string directory, string name) {
            return string.Format ("{0}/{1}.bytes", getDataPath (directory), name);
        }
        string getDataPath (string name) {
            return string.Format ("{0}/Lua/etc/{1}", Application.dataPath, name);
        }
    }
}