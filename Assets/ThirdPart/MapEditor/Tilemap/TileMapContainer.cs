using GG.Tilemapping;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
	public class TileMapContainer : ScriptableObject {
		public int width, height;
		public ScriptableTile[] map;
	}
}
