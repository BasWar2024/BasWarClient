using System;
using System.Collections.Generic;
using GG.Tilemapping;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
    public class PrefabBurshData {
        public string prefabName;
        public ScriptableTile[][] tempPrefab;
        public int max_x, max_y;
    }
    //
    [Serializable]
    public class PrefabAddBrush : ScriptableTool {
        public PrefabBurshData burshData;
        public override KeyCode Shortcut { get { return KeyCode.P; } }
        public override string Description { get { return "   "; } }
        public override void OnClick (Point point, ScriptableTile tile, TileMap map) {
            if (map == null)
                return;

            if (!map.OperationInProgress ())
                map.BeginOperation ();

            for (int x = 0; x < burshData.max_x; x++) {
                for (int y = 0; y < burshData.max_y; y++) {
                    Point offsetPoint = point + new Point (x, y);
                    var newTile = burshData.tempPrefab[x][y];

                    var clone = UnityEngine.Object.Instantiate (newTile);
                    clone.CampID = clone.CampID != 0 ? (int) map.camp : 0; //
                    clone.CardCamp = clone.CardCamp != 0 ? (int) map.camp : 0; //
                    map.SetTileAt (offsetPoint, clone);
                }
            }

        }
        public override void OnClickDown (Point point, ScriptableTile tile, TileMap map) {
            OnClick (point, tile, map);
        }

        public override List<Point> GetRegion (Point point, ScriptableTile tile, TileMap map) {
            region = new List<Point> ();

            if (burshData != null) {
                //Arbitrary clamping of brush size
                for (int x = 0; x < burshData.max_x; x++) {
                    for (int y = 0; y < burshData.max_y; y++) {
                        Point offsetPoint = point + new Point (x, y);
                        region.Add (offsetPoint);
                    }
                }
            }
            return region;
        }
    }
}