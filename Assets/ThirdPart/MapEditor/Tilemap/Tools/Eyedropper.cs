using System;
using GG.Tilemapping;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
    [Serializable]
    public class Eyedropper : ScriptableTool {
        public Eyedropper () : base () {

        }
        public override KeyCode Shortcut { get { return KeyCode.I; } }
        public override string Description { get { return "Sets the primary tile to whatever you click"; } }

        public override void OnClickDown (Point point, ScriptableTile tile, TileMap map) { }
        public override void OnClick (Point point, ScriptableTile tile, TileMap map) {

        }
        public override void OnClickUp (Point point, ScriptableTile tile, TileMap map) {
#if UNITY_EDITOR
            map.primaryTile = map.GetTileAt (point);
#endif
        }
    }
}