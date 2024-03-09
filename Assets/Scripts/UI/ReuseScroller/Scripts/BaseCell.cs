using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UniRx;
using UnityEngine;
using UnityEngine.EventSystems;

namespace GG {
	[RequireComponent (typeof (RectTransform))]
	[DisallowMultipleComponent]
	public abstract class BaseCell<T> : UIBehaviour, IPoolable {
		private RectTransform rectTransform; //tran
		public RectTransform RectTransform { get { return rectTransform; } }
		protected BaseScrollController<T> _mController;
		public BaseScrollController<T> mController { set { _mController = value; } }

		public int dataIndex = -1; //index
		// public int cellDateIndex = -1;
		Animation animCell;
		bool playEffectAnim;
		protected override void Awake () {
			base.Awake ();
			rectTransform = GetComponent<RectTransform> ();
			animCell = GetComponent<Animation> ();

			if (animCell && animCell.clip != null) {
				animCell.AddEventEnding (animCell.clip.name, "OnAnimCellEnding");
			}

			OnCellAwake ();

		}

		void OnAnimCellEnding (string key) {
			if (!playEffectAnim) return;

			animCell.ResetAnimToFirst (animCell.clip.name);
			_mController.MoveCellToLast (this, count);
			// _mController.CellData.Remove (data);
			// Debug.LogError (doMoveCellNow);
			if (doMoveCellNow) {
				_mController.DoMoveCell (count, finish, isQuickBuy);
			}
		}
		private T data;
		private int count;
		private bool doMoveCellNow;
		private Callback finish;
		private bool isQuickBuy;
		public virtual void OnAnimationPlay (int _count, bool _doMoveCellNow = true, Callback _finish = null, bool _isQuickBuy = false) {
			playEffectAnim = true;
			if (animCell != null) {
				// data = _data;
				count = _count;
				doMoveCellNow = _doMoveCellNow;
				finish = _finish;
				isQuickBuy = _isQuickBuy;
				if (_isQuickBuy)
					animCell.Play ();
				else
					OnAnimCellEnding ("");
			}
		}
		public virtual void OnCellAwake () { }

		public virtual void OnReuse () { }

		public void DebugDrawBox (Color color, float duration = 10) {
			Vector3[] corners = new Vector3[4];
			rectTransform.GetWorldCorners (corners);
			Debug.DrawLine (corners[0], corners[1], color, duration);
			Debug.DrawLine (corners[1], corners[2], color, duration);
			Debug.DrawLine (corners[2], corners[3], color, duration);
			Debug.DrawLine (corners[3], corners[0], color, duration);
		}
		/// <summary>
		/// 
		/// </summary>
		/// <param name="item"></param>
		public abstract void UpdateContent (T item);
		/// <summary>
		/// cell 
		/// </summary>
		/// <param name="min"></param>
		/// <param name="max"></param>
		public void SetAnchors (Vector2 min, Vector2 max) {
			rectTransform.anchorMin = min;
			rectTransform.anchorMax = max;
		}
		//
		public void SetOffsetVertical (float top, float bottom) {
			rectTransform.offsetMin = new Vector2 (rectTransform.offsetMin.x, bottom);
			rectTransform.offsetMax = new Vector2 (rectTransform.offsetMax.x, -top);
		}
		//
		public void SetOffsetHorizontal (float left, float right) {
			rectTransform.offsetMin = new Vector2 (left, rectTransform.offsetMin.y);
			rectTransform.offsetMax = new Vector2 (-right, rectTransform.offsetMax.y);
		}
		public void SetTopLeft (float top, float left) {
			Vector3[] corners = new Vector3[4];
			rectTransform.GetLocalCorners (corners);
			// Debug.LogError ("top - corners[1].y " + (top - corners[1].y) + " corners[1].y " + corners[1].y + "  top " + top);
			rectTransform.anchoredPosition = new Vector2 (left - corners[0].x, top - corners[1].y);
		}

		#region 
		public bool IsInPool { get; set; }
		public void OnActive () { }
		public void OnRelease () { }
		public void OnRecycled () { }
		#endregion

		#region  
		public float Width {
			get {
				return rectTransform.sizeDelta.x;
			}
			set {
				Vector2 sizeDelta = rectTransform.sizeDelta;
				sizeDelta.x = value;
				rectTransform.sizeDelta = sizeDelta;
			}
		}

		public float Height {
			get {
				return rectTransform.sizeDelta.y;
			}
			set {
				Vector2 sizeDelta = rectTransform.sizeDelta;
				sizeDelta.y = value;
				rectTransform.sizeDelta = sizeDelta;
			}
		}

		public float Left {
			get {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				return rectTransform.anchoredPosition.x + corners[0].x;
			}
			set {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				rectTransform.anchoredPosition = new Vector2 (value - corners[0].x, 0);
			}
		}

		public float Top {
			get {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				return rectTransform.anchoredPosition.y + corners[1].y;
			}
			set {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				rectTransform.anchoredPosition = new Vector2 (0, value - corners[1].y);
			}
		}

		public float Right {
			get {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				return rectTransform.anchoredPosition.x + corners[2].x;
			}
			set {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				rectTransform.anchoredPosition = new Vector2 (value - corners[2].x, 0);
			}
		}

		public float Bottom {
			get {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				return rectTransform.anchoredPosition.y + corners[3].y;
			}
			set {
				Vector3[] corners = new Vector3[4];
				rectTransform.GetLocalCorners (corners);
				rectTransform.anchoredPosition = new Vector2 (0, value - corners[3].y);
			}
		}
		#endregion

	}
}