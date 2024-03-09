using System;
using System.Collections.Generic;
using System.Reflection;
using GG.Tilemapping;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
	[Serializable]
	public class Eraser : Brush {
		public Eraser () : base () {
			radius = 1;
		}
		public override KeyCode Shortcut { get { return KeyCode.E; } }
		public override string Description { get { return "Sets the painted tile to nothing"; } }

		public override void OnClick (Point point, ScriptableTile tile, TileMap map) {
			base.OnClick (point, null, map);
		}
	}
}