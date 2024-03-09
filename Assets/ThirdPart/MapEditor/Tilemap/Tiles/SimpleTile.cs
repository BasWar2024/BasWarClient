using CanglxMapEditor.Tilemapping;
using UnityEngine;

namespace GG.Tilemapping {
    [CreateAssetMenu (fileName = "New SimpleTile", menuName = "Tilemap/Tiles/SimpleTile")]
    public class SimpleTile : ScriptableTile {

        
        public Sprite sprite;
        //
        public void SetSprite (Sprite sp) {
            sprite = sp;
            // var num = sprite.name.Split ('_') [1];
            // GridID = int.Parse (num);
        }

        public override bool IsValid {
            get {
                if (sprite == null)
                    return false;

                try {
                    sprite.texture.GetPixel (0, 0);
                } catch (UnityException e) {
                    return false;
                }
                return true;
            }
        }

        public override Sprite GetSprite (TileMap tilemap = null, Point position = default (Point)) {
            return sprite;
        }
        public override Texture2D GetIcon () {
            if (!IsValid) return null;
            return sprite.ToTexture2D ();
        }
    }
}