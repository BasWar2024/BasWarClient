using CanglxMapEditor.Tilemapping;
using UnityEngine;

namespace GG.Tilemapping {
	public abstract class ScriptableTile : ScriptableObject {
		public string Name { get { return this.name; } }
		public int ID { get { return GetInstanceID (); } }
		public abstract bool IsValid { get; }

		public abstract Sprite GetSprite (TileMap tilemap = null, Point position = default (Point));
		public abstract Texture2D GetIcon ();

		public int GridID; //id
		public int CampID; //id
		public int CardID; //id
		public int CardCamp; //id
		public TileMapDirection Direction; //

		//Handle Ticking
		private float timeOffset = 0;
		public virtual float TickRate { get { return 0; } }

		public bool CheckIfCanTick () {
			//Clearly can't tick
			if (TickRate <= 0)
				return false;
			//If the time it has left till next tick is more than the TickRate, reset the timeOffset
			if (timeOffset - Time.realtimeSinceStartup > TickRate)
				timeOffset = 0;
			//If the current time is more than the (time + TickRate)
			if (Time.realtimeSinceStartup >= timeOffset) {
				//Then call Tick and reset the timeOffset
				timeOffset = Time.time + TickRate;
				return Tick ();
			}
			//By default return false
			return false;
		}
		//Override this function to add global behaviour to a tile type 
		protected virtual bool Tick () {
			//Make it return true if you want it to visually update
			return false;
		}
	}
}