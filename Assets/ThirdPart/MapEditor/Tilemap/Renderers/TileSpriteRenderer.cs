using GG.Tilemapping;
using UnityEngine;

namespace CanglxMapEditor.Tilemapping {
    [AddComponentMenu ("2D/Renderer/TileSpriteRenderer")]
    public class TileSpriteRenderer : TileRenderer {
        [SerializeField]
        private SpriteRenderer[] spriteMap = new SpriteRenderer[0];

        public override void Resize (int width, int height) {
            if (width * height == spriteMap.Length)
                return;

            ClearChildren ();

            spriteMap = new SpriteRenderer[width * height];
        }

        public override void UpdateTileAt (int x, int y) {
            int index = x + y * tileMap.Width;
            SpriteRenderer current = spriteMap[index];
            if (current == null) {
                current = new GameObject (string.Format ("[{0}, {1}]", x, y)).AddComponent<SpriteRenderer> ();
                current.transform.SetParent (parent);

                spriteMap[index] = current;
            }
            ScriptableTile tile = tileMap.GetTileAt (x, y);
            if (tile) {
                current.sprite = tile.GetSprite (tileMap, new Point (x, y));

                if (tileMap.specialDrawMode == SpecialDrawMode.AOIMode) {
                    if (tile.CampID == (int) CampType.player1) {
                        current.color = new Color (0, 0.7f, 1, 0.5f);
                    } else if (tile.CampID >= 2000) {
                        current.color = new Color (1, 0, 0, 0.5f);
                    } else if (tile.CampID >= 1000 && tile.CampID < 2000) {
                        current.color = new Color (0, 0, 0, 0.2f);
                    } else {
                        current.color = Color.white;
                    }
                } else
                if (tileMap.specialDrawMode == SpecialDrawMode.CardMode) {
                    if (tile.CardCamp == (int) CampType.player1) {
                        current.color = new Color (0, 0.7f, 1, 0.5f);
                    } else if (tile.CardCamp >= 2000) {
                        current.color = new Color (1, 0, 0, 0.5f);
                    } else if (tile.CardCamp >= 1000 && tile.CardCamp < 2000) {
                        current.color = new Color (0, 0, 0, 0.2f);
                    } else {
                        current.color = Color.white;
                    }
                } else {
                    current.color = color;
                }
            }

            current.transform.localPosition = new Vector2 (x, y) + (tile ?
                new Vector2 (current.sprite.pivot.x / current.sprite.rect.width,
                    current.sprite.pivot.y / current.sprite.rect.height) : Vector2.zero);

            current.transform.localPosition *= tileMap.UnitScale;

            current.transform.localScale = Vector2.one * 0.5f / 0.64f;
            // current.sharedMaterial = material;

            current.sortingLayerID = sortingLayer;
            current.sortingOrder = orderInLayer;

            current.gameObject.SetActive (tile != null);

        }
    }
}