using System;
using System.Collections.Generic;
using GG.Tilemapping;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
    [Serializable]
    public class CardBrush : ScriptableTool {
        public AttachMode mode;
        public int radius;
        public enum BrushShape { Square, Circle, }
        public BrushShape shape;

        public CardBrush () : base () {
            radius = 1;
            shape = BrushShape.Square;
        }

        public override KeyCode Shortcut { get { return KeyCode.C; } }

        public override string Description { get { return "   "; } }

        public override void OnClick (Point point, ScriptableTile tile, TileMap map) {
            if (map == null)
                return;

            if (!map.OperationInProgress ())
                map.BeginOperation ();

            if (map.specialDrawMode == SpecialDrawMode.CardMode && map.selfDrawMode == DrawTileMapMode.keyCode)
                mode = map.attachMode;

            for (int i = 0; i < region.Count; i++) {
                Point offsetPoint = region[i];

                var oldTile = map.GetTileAt (offsetPoint);
                if (oldTile) {
                    var clone = UnityEngine.Object.Instantiate (oldTile);
                    clone.name = "_Clone";
                    clone.CardID = mode == AttachMode.add? map.currentCardID : 0;
                    clone.Direction = mode == AttachMode.add? map.tileMapDirection : 0;
                    clone.CardCamp = mode == AttachMode.add?(int) map.camp : 0;
                    map.SetTileAt (offsetPoint, clone);
                }
            }
        }

        public override void OnClickDown (Point point, ScriptableTile tile, TileMap map) {
            OnClick (point, tile, map);
        }
        public override List<Point> GetRegion (Point point, ScriptableTile tile, TileMap map) {
            region = new List<Point> ();
            //Arbitrary clamping of brush size
            radius = Mathf.Clamp (radius, 1, 64);
            int correctedRadius = radius - 1;
            for (int x = -correctedRadius; x <= correctedRadius; x++) {
                for (int y = -correctedRadius; y <= correctedRadius; y++) {
                    Point offsetPoint = point + new Point (x, y);
                    if (shape == BrushShape.Square || ((Vector2) (offsetPoint - point)).sqrMagnitude <= correctedRadius * correctedRadius)
                        region.Add (offsetPoint);
                }
            }
            return region;
        }
    }
}