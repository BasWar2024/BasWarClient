using System;
using System.Collections.Generic;
using GG.Tilemapping;
using UnityEngine;
/// <summary>
/// 1.Tile   ID tile 
// / 2.    ----- done
/// 3.boom map  boommap 
/// 4.TileMap 
/// 5.
/// </summary>
namespace CanglxMapEditor.Tilemapping {
    //
    public enum TileMapDirection {
        left = 0,
        top = 2,
        right = 4,
        down = 6,
    }
    //
    public enum CampType {
        none = 0, //
        systemNeutral1 = 1000,
        systemNeutral2 = 1001,
        systemNeutral3 = 1002,
        systemNeutral4 = 1003,
        systemNeutral5 = 1004,
        systemNeutral6 = 1005,
        systemNeutral7 = 1006,
        systemNeutral8 = 1007,
        systemNeutral9 = 1008,
        systemNeutral10 = 1009,
        systemEnemy1 = 2000, //
        systemEnemy2 = 2001,
        player1 = 1, //
        player2 = 2,
        player3 = 3,
        player4 = 4,
        player5 = 5,
        player6 = 6,
    }
    //  
    public enum TileMapEditorMode {
        MapEditor,
        LevelEditor,
        PrefabsEditor
    }
    // 
    public enum SpecialDrawMode {
        Terrain,
        AOIMode, //
        CardMode, //
        PrefabsAdd, //
    }
    public enum DrawTileMapMode {
        Mouse, //
        keyCode, //
    }
    //
    public enum SpecialAddMode {
        None,
        PrefabsAdd
    }

    public enum AttachMode { add, clean }

    [RequireComponent (typeof (TileSpriteRenderer))]
    [ExecuteInEditMode, AddComponentMenu ("2D/TileMap"), DisallowMultipleComponent]
    public class TileMap : MonoBehaviour {
        [SerializeField]
        private int unitScale = 50;
        [SerializeField]
        private int width = 25, height = 25;
        [SerializeField]
        private ScriptableTile[] map = new ScriptableTile[0];

        private bool CurrentOperation = false;
        private List<ChangeElement> CurrentEdit;
        private Timeline timeline;

        public TileMapEditorMode tileMapEditorMode;
        public SpecialDrawMode specialDrawMode;
        public SpecialAddMode specialAddMode;

        public DrawTileMapMode selfDrawMode;
        public CampType camp;
        public TileMapDirection tileMapDirection;
        public AttachMode attachMode;
        public Action<int, int> OnUpdateTileAt = (x, y) => { };
        public Action OnUpdateTileMap = () => { };
        public Action<int, int> OnResize = (width, height) => { };

        public ScriptableTile[] Map { get { return map; } }
        public int Width { get { return width; } }
        public int Height { get { return height; } }
        public float UnitScale { get => (float) unitScale / 100f; }

        //sp
        public int currentCardID;

        private void Update () {
            for (int x = 0; x < Width; x++) {
                for (int y = 0; y < Height; y++) {
                    ScriptableTile tile = GetTileAt (x, y);
                    if (tile && tile.CheckIfCanTick ())
                        UpdateTileAt (x, y);
                }
            }
        }

        private Point WorldPositionToPoint (Vector2 worldPosition, bool clamp = false) {
            Point offset = (Point) transform.position;
            // Point point = (Point) worldPosition;
            Point point = (Point) (worldPosition * UnitScale);

            int x = point.x - offset.x;
            int y = point.y - offset.y;

            if (clamp) {
                x = Mathf.Clamp (x, 0, width - 1);
                y = Mathf.Clamp (y, 0, height - 1);
            }
            return new Point (x, y);
        }

        public void Reset () {
            map = new ScriptableTile[width * height];
            timeline = new Timeline ();
            CurrentEdit = new List<ChangeElement> ();

            UpdateTileMap ();
        }
        //
        public void Resize (int newWidth, int newHeight) {
            Resize (newWidth, newHeight, unitScale);
        }
        public void Resize (int newWidth, int newHeight, int scale) {

            if (scale != 0) {
                unitScale = scale;
            }

            if ((newWidth <= 0 || newHeight <= 0) || (width == newWidth && height == newHeight))
                return;

            int oldWidth = width, oldHeight = height;
            ScriptableTile[] oldMap = map;

            map = new ScriptableTile[newWidth * newHeight];
            width = newWidth;
            height = newHeight;
            OnResize.Invoke (newWidth, newHeight);

            for (int i = 0; i < oldMap.Length; i++) {
                int x = i % oldWidth;
                int y = i / oldWidth;
                ScriptableTile tile = oldMap[i];
                if (tile && IsInBounds (x, y))
                    SetTileAt (x, y, tile);
            }
        }
        public bool IsInBounds (Point point) {
            return IsInBounds (point.x, point.y);
        }
        public bool IsInBounds (int x, int y) {
            return (x >= 0 && x < width && y >= 0 && y < height);
        }

        public ScriptableTile GetTileAt (Vector2 worldPosition) {
            return GetTileAt (WorldPositionToPoint (worldPosition));
        }
        public ScriptableTile GetTileAt (Point point) {
            return GetTileAt (point.x, point.y);
        }
        public ScriptableTile GetTileAt (int x, int y) {
            if (!IsInBounds (x, y))
                return null;

            int index = x + y * width;

            // Debug.LogError (map.Length + "  " + index);
            return map[x + y * width];
        }

        public bool SetTileAt (Vector2 worldPosition, ScriptableTile to) {
            return SetTileAt (WorldPositionToPoint (worldPosition), to);
        }
        public bool SetTileAt (Point point, ScriptableTile to) {
            return SetTileAt (point.x, point.y, to);
        }
        public bool SetTileAt (int x, int y, ScriptableTile to) {
            ScriptableTile from = GetTileAt (x, y);
            //Conditions for returning
            if (IsInBounds (x, y) &&
                !(from == null && to == null) &&
                (((from == null || to == null) && (from != null || to != null)) ||
                    from.ID != to.ID)) {
                map[x + y * width] = to;

                if (CurrentEdit == null)
                    CurrentEdit = new List<ChangeElement> ();
                CurrentEdit.Add (new ChangeElement (x, y, from, to));

                UpdateTileAt (x, y);
                UpdateNeighbours (x, y, true);

                return true;
            }
            return false;
        }
        public void UpdateTileAt (Point point) {
            UpdateTileAt (point.x, point.y);
        }
        public void UpdateTileAt (int x, int y) {
            OnUpdateTileAt.Invoke (x, y);
        }
        public void UpdateTilesAt (Point[] points) {
            for (int i = 0; i < points.Length; i++) {
                UpdateTileAt (points[i]);
            }
        }
        public void UpdateNeighbours (int x, int y, bool incudeCorners = false) {
            for (int xx = -1; xx <= 1; xx++) {
                for (int yy = -1; yy <= 1; yy++) {
                    if (xx == 0 && yy == 0)
                        continue;

                    if (!incudeCorners && !(xx == 0 || yy == 0))
                        continue;

                    if (IsInBounds (x + xx, y + yy))
                        UpdateTileAt (x + xx, y + yy);
                }
            }
        }
        public void UpdateType (ScriptableTile type) {
            for (int x = 0; x <= Width; x++) {
                for (int y = 0; y <= Height; y++) {
                    if (GetTileAt (x, y) == type) {
                        UpdateTileAt (x, y);
                    }
                }
            }
        }
        public List<ScriptableTile> GetAllTileTypes () {
            List<ScriptableTile> result = new List<ScriptableTile> ();
            for (int x = 0; x <= Width; x++) {
                for (int y = 0; y <= Height; y++) {
                    ScriptableTile tile = GetTileAt (x, y);
                    if (!result.Contains (tile) && tile != null) {
                        result.Add (tile);
                    }
                }
            }
            return result;
        }
        public void UpdateTileMap () {
            OnUpdateTileMap.Invoke ();
        }

        public bool CanUndo {
            get { return (timeline != null && timeline.CanUndo); }
        }
        public bool CanRedo {
            get { return (timeline != null && timeline.CanRedo); }
        }

        public void Undo () {
            if (timeline == null)
                return;
            List<ChangeElement> changesToRevert = timeline.Undo ();

            foreach (var c in changesToRevert) {
                map[c.x + c.y * width] = c.from;
                UpdateTileAt (c.x, c.y);
                UpdateNeighbours (c.x, c.y, true);
            }
        }

        public void Redo () {
            if (timeline == null)
                return;
            List<ChangeElement> changesToRevert = timeline.Redo ();

            foreach (var c in changesToRevert) {
                map[c.x + c.y * width] = c.to;
                UpdateTileAt (c.x, c.y);
                UpdateNeighbours (c.x, c.y, true);
            }
        }

        public void BeginOperation () {
            CurrentOperation = true;
            CurrentEdit = new List<ChangeElement> ();
        }

        public void FinishOperation () {
            CurrentOperation = false;
            if (timeline == null)
                timeline = new Timeline ();
            timeline.PushChanges (CurrentEdit);
        }

        public bool OperationInProgress () {
            return CurrentOperation;
        }

        //A cheat-y way of serialising editor variables in the Unity Editor
#if UNITY_EDITOR
        public bool isInEditMode = false;

        public ScriptableTile primaryTile, secondaryTile;

        public Rect toolbarWindowPosition, tilePickerWindowPosition, isSelectPrefabMapWindowPosition;
        public Vector2 tilePickerScrollView, tilePrefabScrollView;

        public int selectedScriptableTool = -1, lastSelectedScriptableTool = -1;

        public bool primaryTilePickerToggle = false, secondaryTilePickerToggle = false, isSelectPrefabMap = false;

        public List<ScriptableTool> scriptableToolCache = new List<ScriptableTool> ();
        public List<ScriptableTile> scriptableTileCache = new List<ScriptableTile> ();

        public Vector3 tileMapPosition;
        public Quaternion tileMapRotation;
#endif
    }
}