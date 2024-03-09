using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UniRx;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace GG {
	/// <summary>
	/// 
	/// </summary>
	public enum Direction {
		Vertical,
		Horizontal
	}

	/// <summary>
	/// 
	/// </summary>
	public enum ScrollAlignment {
		TopLeft,
		TopCenter,
		TopRight,
	}
	/// <summary>
	/// 
	/// </summary>
	public enum LayoutMode {
		SingleLayout, // 
		GridLayout // 
	}

	//Scroll Main Controller
	[RequireComponent (typeof (RectTransform), typeof (ScrollRect))]
	[DisallowMultipleComponent]
	public abstract class BaseScrollController<T> : UIBehaviour {
		ObjectPoolService objectPoolService;

		[Tooltip ("")]
		public bool usePool;
		string usePoolKey;
		[Tooltip ("")]
		//
		public Direction scrollDirection;
		//
		public bool scorllLoop;
		[Tooltip ("")]
		//
		public bool scrollReverse;
		[Tooltip ("")]
		//
		public LayoutMode layoutMode;
		// 
		[Tooltip ("")]
		public int permutationCount = 4;
		[Tooltip ("")]
		public ScrollAlignment scrollAlignment;
		//cell
		public GameObject cellObject;
		//
		public float defaultCellSizeX = 200.0f;
		public float defaultCellSizeY = 200.0f;
		//cellcell
		public float spacing = 20.0f;
		//rect
		public RectOffset contentPadding;
		//padding 
		public float activePadding;
		//scroller rect
		private RectTransform rectTransform;
		protected ScrollRect scrollRect;
		[Header ("")]
		public float moveSpeed = 0.5f;
		private Vector2 scrollPosition; //
		private LinkedList<BaseCell<T>> Cells = new LinkedList<BaseCell<T>> ();
		protected LinkedList<BaseCell<T>> CurrentCells { get { return Cells; } }

		[HideInInspector]
		public List<BaseCell<T>> MoveCellList = new List<BaseCell<T>> ();
		public RectTransform contentRectTransform;
		/// <summary>
		/// 
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <returns></returns>
		private List<T> cellData = new List<T> ();
		/// <summary>
		///  
		///   SetCellDataNotCreate
		/// </summary>
		/// <value></value>
		public List<T> CellData {
			get {
				return cellData;
			}
			set {
				cellData = value;
				ReloadData (true);
			}
		}

		protected bool scrollHadAddListener = false; //

		//init
		protected override void Awake () {
			base.Awake ();
			scrollHadAddListener = false;
			// objectPoolService = ResourcesManager.Inst.GetGameServer<ObjectPoolService> ();

			rectTransform = GetComponent<RectTransform> ();
			scrollRect = GetComponent<ScrollRect> ();
			//content 
			contentRectTransform = scrollRect.content.GetComponent<RectTransform> ();
			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				contentRectTransform.anchorMin = contentRectTransform.anchorMax = new Vector2 (0, 1);
			} else {
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						contentRectTransform.anchorMin = Vector2.zero;
						contentRectTransform.anchorMax = Vector2.right;
					} else {
						contentRectTransform.anchorMin = Vector2.up;
						contentRectTransform.anchorMax = Vector2.one;
					}
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						contentRectTransform.anchorMin = Vector2.right;
						contentRectTransform.anchorMax = Vector2.one;
					} else {
						contentRectTransform.anchorMin = Vector2.zero;
						contentRectTransform.anchorMax = Vector2.up;
					}
				}
			}
			//content 
			contentRectTransform.anchoredPosition = Vector2.zero;
			contentRectTransform.sizeDelta = Vector2.zero;
			ActiveScrolled ();
		}
		public void ActiveScrolled () {
			if (!scrollHadAddListener) {
				scrollRect.onValueChanged.AddListener (OnScrolled);
				//Debug.LogError ("");
			}
		}
		public void UnActiveScrolled () {
			scrollHadAddListener = false;
			scrollRect.onValueChanged.RemoveListener (OnScrolled);
			//Debug.LogError ("");
		}
		/// <summary>
		/// 
		/// </summary>
		public virtual void ReductionContentRectTransform () {
			scrollRect.StopMovement ();
			if (scrollDirection == Direction.Horizontal) {
				contentRectTransform.anchoredPosition *= Vector2.up;
			} else if (scrollDirection == Direction.Vertical) {
				contentRectTransform.anchoredPosition *= Vector2.right;
			}
		}
		/// <summary>
		/// 
		/// </summary>
		public virtual void JumpTopTargetContentPos (int targetValue) {
			var cellDataCount = cellData.Count;
			if (targetValue < 0 || targetValue >= cellDataCount) return;
			UnActiveScrolled ();
			scrollRect.StopMovement ();
			float longNum = scrollRect.content.sizeDelta.y;
			longNum /= cellDataCount;
			longNum *= targetValue;
			if (scrollDirection == Direction.Horizontal) {
				contentRectTransform.SetRectPosX (longNum);
			} else if (scrollDirection == Direction.Vertical) {
				contentRectTransform.SetRectPosY (longNum);
			}
			//Debug.LogError ("targetValue " + targetValue);
			ActiveScrolled ();
		}

#if UNITY_EDITOR
		protected override void OnValidate () {
			base.OnValidate ();
			if (cellObject && !cellObject.GetComponent<BaseCell<T>> ()) {
				cellObject = null;
			}
		}
#endif
		/// <summary>
		/// content 
		/// </summary>
		void SetContentAlignment (float contentWidth) {
			switch (scrollAlignment) {
				case ScrollAlignment.TopLeft:
					break;
				case ScrollAlignment.TopCenter:
					var halfScrollrect = rectTransform.sizeDelta.x * 0.5f;
					var halfContent = contentWidth * 0.5f;
					scrollRect.content.anchoredPosition = new Vector2 (halfScrollrect - halfContent, 0);
					break;
				case ScrollAlignment.TopRight:
					scrollRect.content.anchoredPosition = new Vector2 (rectTransform.sizeDelta.x - contentWidth, 0);
					break;

			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="newCelllist"></param>
		protected virtual void SetCellDataAndNoReload (List<T> newCelllist) {
			if (!this.gameObject.activeSelf) return;
			// if (newCelllist.Count != cellData.Count) {
			// 	Debug.LogWarning ("//-------  --------//   " + cellData.Count + "  " + newCelllist.Count);
			// }

			cellData = newCelllist;
		}

		/// <summary>
		/// cell  
		/// </summary>
		/// <param name="newCelllist"></param>
		protected virtual void SetCellDataNotCreate (List<T> newCelllist) {
			if (!this.gameObject.activeSelf) return;
			// if (newCelllist.Count != cellData.Count) {
			// 	Debug.LogWarning ("//-------  --------//   " + cellData.Count + "  " + newCelllist.Count);
			// }

			cellData = newCelllist;
			ReloadData (false);
		}
		/// <summary>
		/// 
		/// </summary>
		/// <param name="pos"></param>
		protected void OnScrolled (Vector2 pos) {
			// Debug.LogError (this.transform.lossyScale);
			if (this.transform.lossyScale.x <= 0 || this.transform.lossyScale.y <= 0) return;
			ReuseCells (pos - scrollPosition);
			FillCells ();
			scrollPosition = pos;
		}
		/// <summary>
		/// 
		/// </summary>
		/// <param name="isReset"></param>
		protected void ReloadData (bool isReset = false) {
			//
			Vector2 sizeDelta = scrollRect.content.sizeDelta;
			float contentSize = 0;
			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				//
				for (int i = 0; i < cellData.Count; i++) {
					//
					if (i % permutationCount == 0) {
						//y
						contentSize += GetCellSize (i).y + (i > 0 ? spacing : 0);
					}
				}
				sizeDelta.x = GetCellSize (0).x * permutationCount + spacing * (permutationCount + 1);
				sizeDelta.y = contentSize + spacing * 2 + contentPadding.vertical;

			} else {
				//
				for (int i = 0; i < cellData.Count; i++) {
					if (scrollDirection == Direction.Vertical) {
						contentSize += GetCellSize (i).y + (i > 0 ? spacing : 0);
					} else {
						contentSize += GetCellSize (i).x + (i > 0 ? spacing : 0);
					}
				}
				if (scrollDirection == Direction.Vertical) {
					contentSize += contentPadding.vertical;
					sizeDelta.y = contentSize > rectTransform.rect.height ? contentSize : rectTransform.rect.height;
				} else if (scrollDirection == Direction.Horizontal) {
					contentSize += contentPadding.horizontal;
					sizeDelta.x = contentSize > rectTransform.rect.width ? contentSize : rectTransform.rect.width;
				}
			}
			scrollRect.content.sizeDelta = sizeDelta;
			// Debug.LogError ("scrollRect.content.sizeDelta " + scrollRect.content.sizeDelta);

			//
			if (isReset) {
				foreach (BaseCell<T> cell in Cells) {
					Destroy (cell.gameObject);
				}
				Cells.Clear ();

				scrollRect.normalizedPosition = scrollRect.content.GetComponent<RectTransform> ().anchorMin;
				scrollRect.onValueChanged.Invoke (scrollRect.normalizedPosition);

				// if (layoutMode.Equals (LayoutMode.GridLayout)) {
				// 	SetContentAlignment (sizeDelta.x);
				// }

			} else {
				UpdateCells ();
				FillCells ();
			}

			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				SetContentAlignment (sizeDelta.x);
			}

		}
		/// <summary>
		/// 
		/// </summary>
		/// <param name="index"></param>
		private void CreateCell (int index) {
			if (usePool) {
				if (cellObject == null) {
					Debug.LogError ("View Controller Error,,");
					return;
				} else {
					if (objectPoolService == null) {
						// objectPoolService = ResourcesManager.Inst.GetGameServer<ObjectPoolService> ();
					}

					usePoolKey = cellObject.name;
					objectPoolService.AllocateMono (usePoolKey)
						.Subscribe (_ => {
							var cell = _.GetComponent<BaseCell<T>> ();
							CellPostProcessing (cell, index);
						});
				}
			} else {
				BaseCell<T> cell = Instantiate (cellObject).GetComponent<BaseCell<T>> ();
				CellPostProcessing (cell, index);

				cell.name = "manager" + index;
			}
		}

		protected override void OnDestroy () {
			if (usePool) {
				var cellList = new List<BaseCell<T>> (Cells);
				for (int i = 0; i < cellList.Count; i++) {
					var cell = cellList[i].GetComponent<MonoBehaviour> ();
					objectPoolService.RecycleMono (cell, usePoolKey);
				}
			}
		}

		void CellPostProcessing (BaseCell<T> cell, int index) {
			if (cell == null) {
				Debug.LogError ("cell  " + typeof (T));
				return;
			}
			cell.mController = this;
			// content

			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				cell.SetAnchors (new Vector2 (0, 1), new Vector2 (0, 1));
			} else {
				cell.SetAnchors (scrollRect.content.anchorMin, scrollRect.content.anchorMax);
			}

			cell.transform.SetParent (scrollRect.content.transform, false);
			UpdateCell (cell, index); //

			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				int count = Cells.Count;
				if (count % permutationCount == 0) {
					//permutationCount  
					cell.SetTopLeft (count > 0 ? Cells.Last.Value.Bottom - spacing : -contentPadding.top, contentPadding.left);
				} else {
					//
					cell.SetTopLeft (Cells.Last.Value.Top, Cells.Last.Value.Left + spacing + Cells.Last.Value.Width);
				}

			} else {

				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						cell.Bottom = (Cells.Count > 0 ? Cells.Last.Value.Top + spacing : contentPadding.bottom);
					} else {
						cell.Top = (Cells.Count > 0 ? Cells.Last.Value.Bottom - spacing : -contentPadding.top);
					}
					cell.SetOffsetHorizontal (contentPadding.left, contentPadding.right);

				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						cell.Right = (Cells.Count > 0 ? Cells.Last.Value.Left - spacing : -contentPadding.right);
					} else {
						cell.Left = (Cells.Count > 0 ? Cells.Last.Value.Right + spacing : contentPadding.left);
					}
					cell.SetOffsetVertical (contentPadding.top, contentPadding.bottom);
				}
			}

			Cells.AddLast (cell);
		}

		/// <summary>
		/// cell
		/// </summary>
		/// <param name="cell"></param>
		/// <param name="index"></param>
		private void UpdateCell (BaseCell<T> cell, int index) {
			cell.dataIndex = index;
			if (cell.dataIndex >= 0 && cell.dataIndex < cellData.Count) {
				if (layoutMode.Equals (LayoutMode.GridLayout)) {
					cell.Height = GetCellSize (cell.dataIndex).y;
					cell.Width = GetCellSize (cell.dataIndex).x;
				} else {
					if (scrollDirection == Direction.Vertical) {
						cell.Height = GetCellSize (cell.dataIndex).y;
					} else if (scrollDirection == Direction.Horizontal) {
						cell.Width = GetCellSize (cell.dataIndex).x;
					}
				}
				cell.UpdateContent (cellData[cell.dataIndex]);
				cell.gameObject.SetActive (true);
			} else {
				cell.gameObject.SetActive (false);
			}
		}
		/// <summary>
		/// cell
		/// </summary>
		private void UpdateCells () {
			if (Cells.Count == 0) return;
			// Debug.LogError("???????????????????");
			LinkedListNode<BaseCell<T>> node = Cells.First;
			UpdateCell (node.Value, node.Value.dataIndex);
			node = node.Next;
			while (node != null) {
				// Debug.LogError ("node.Previous.Value.dataIndex + 1:   " + node.Previous.Value.dataIndex + 1);
				UpdateCell (node.Value, node.Previous.Value.dataIndex + 1);

				if (layoutMode.Equals (LayoutMode.GridLayout)) {
					int count = node.Value.dataIndex;
					if (count % permutationCount == 0) {
						//permutationCount  
						node.Value.SetTopLeft (count > 0 ? node.Previous.Value.Bottom - spacing : -contentPadding.top, contentPadding.left);
					} else {
						//
						node.Value.SetTopLeft (node.Previous.Value.Top, node.Previous.Value.Left + spacing + node.Previous.Value.Width);
					}

				} else {
					if (scrollDirection == Direction.Vertical) {
						if (scrollReverse) {
							node.Value.Bottom = node.Previous.Value.Top + spacing;
						} else {
							node.Value.Top = node.Previous.Value.Bottom - spacing;
							// node.Value.SetTopWithAnim (node.Previous.Value.Bottom - spacing);
						}
						node.Value.SetOffsetHorizontal (contentPadding.left, contentPadding.right);
					} else if (scrollDirection == Direction.Horizontal) {
						if (scrollReverse) {
							node.Value.Right = node.Previous.Value.Left - spacing;
						} else {
							node.Value.Left = node.Previous.Value.Right + spacing;
						}
						node.Value.SetOffsetVertical (contentPadding.top, contentPadding.bottom);
					}
				}

				node = node.Next;
			}
		}
		/// <summary>
		/// cell
		/// </summary>
		private void FillCells () {
			if (cellObject != null) {
				//
				if (Cells.Count == 0) CreateCell (0);
				//cell
				if (layoutMode.Equals (LayoutMode.GridLayout)) {
					while (NeedFillCellInGroup ()) {
						int needCount = permutationCount - (Cells.Count % permutationCount);
						// Debug.LogError ("(Cells.Count % permutationCount) " + (Cells.Count % permutationCount));
						for (int i = 0; i < needCount; i++) {
							CreateCell (Cells.Last.Value.dataIndex + 1);
						}
					}

				} else {

					if (Cells.Last.Value.dataIndex < CellData.Count - 1) {
						// Debug.LogError ("CellsTailEdge + spacing  " + (CellsTailEdge + spacing) +"ActiveTailEdge "+ActiveTailEdge);
						while ((CellsTailEdge + spacing <= ActiveTailEdge)) {
							CreateCell (Cells.Last.Value.dataIndex + 1);
						}
					}
				}

			} else {
				Debug.LogWarning ("----------- item null   -------------");
			}
		}
		bool NeedFillCellInGroup () {
			bool b1 = (CellsTailEdge + spacing < ActiveTailEdge);
			bool b2 = (Cells.Last.Value.dataIndex < CellData.Count - 1);
			// if (b1 && b2) {
			// Debug.LogError ("CellsTailEdge " + (CellsTailEdge + spacing) + "  ActiveTailEdge " + ActiveTailEdge);
			// }
			return b1 && b2;
		}
		/// <summary>
		/// cell
		/// </summary>
		/// <param name="scrollVector"></param>
		private void ReuseCells (Vector2 scrollVector) {
			if (Cells.Count == 0) return;
			if (scrollReverse) scrollVector *= -1;

			if (scrollDirection == Direction.Vertical) {
				if (scrollVector.y > 0) {
					if (Cells.First.Value.dataIndex > 0) {
						while (CellsTailEdge - GetCellSize (Cells.Last.Value.dataIndex).y >= ActiveTailEdge) {
							MoveCellLastToFirst ();
						}
					}
				} else if (scrollVector.y < 0) {
					if (Cells.Last.Value.dataIndex < CellData.Count - 1) {
						while (CellsHeadEdge + GetCellSize (Cells.First.Value.dataIndex).y <= ActiveHeadEdge) {
							MoveCellFirstToLast ();
						}
					}
				}
			} else if (scrollDirection == Direction.Horizontal) {
				if (scrollVector.x > 0) {
					while (CellsHeadEdge + GetCellSize (Cells.First.Value.dataIndex).x <= ActiveHeadEdge) {
						MoveCellFirstToLast ();
					}
				} else if (scrollVector.x < 0) {
					while (CellsTailEdge - GetCellSize (Cells.Last.Value.dataIndex).x >= ActiveTailEdge) {
						MoveCellLastToFirst ();
					}
				}
			}

		}
		/// <summary>
		/// 
		/// </summary>
		private void MoveCellFirstToLast () {
			if (Cells.Count == 0) return;

			BaseCell<T> firstCell = Cells.First.Value;
			BaseCell<T> lastCell = Cells.Last.Value;
			firstCell.OnReuse ();
			UpdateCell (firstCell, lastCell.dataIndex + 1);

			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				int count = firstCell.dataIndex;
				// Debug.LogError ("first " + count + " firstCell.dataIndex " + firstCell.dataIndex);
				if (count % permutationCount == 0) {
					//permutationCount  
					firstCell.SetTopLeft (count > 0 ? lastCell.Bottom - spacing : -contentPadding.top, contentPadding.left);
				} else {
					//
					firstCell.SetTopLeft (lastCell.Top, lastCell.Left + spacing + lastCell.Width);
				}

			} else {
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						firstCell.Bottom = lastCell.Top + spacing;
					} else {
						firstCell.Top = lastCell.Bottom - spacing;
					}
					firstCell.SetOffsetHorizontal (contentPadding.left, contentPadding.right);
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						firstCell.Right = lastCell.Left - spacing;
					} else {
						firstCell.Left = lastCell.Right + spacing;
					}
					firstCell.SetOffsetVertical (contentPadding.top, contentPadding.bottom);
				}
			}

			Cells.RemoveFirst ();
			Cells.AddLast (firstCell);

		}

		bool isPlayAnim = true;
		private int tempNum = -1;
		/// <summary>
		/// cell
		/// </summary>
		/// <param name="selectCell"></param>
		public void MoveCellToLast (BaseCell<T> selectCell, int num = 1) {
			if (Cells.Count == 0) return;

			LinkedListNode<BaseCell<T>> tempCell = new LinkedListNode<BaseCell<T>> (null);
			var tempFirst = Cells.First;
			while (tempFirst != null) {
				if (selectCell == tempFirst.Value) {
					tempCell = tempFirst.Next;
					break;
				}
				tempFirst = tempFirst.Next;
			}
			if (tempCell == null) {
				// Debug.LogError ("NULL------------------");
				UpdateCell (selectCell, selectCell.dataIndex);
				isPlayAnim = false;
				return;
			}
			int index = tempCell.Value.dataIndex - 1;

			BaseCell<T> lastCell = Cells.Last.Value;

			if (tempNum == -1) {
				if (num >= lastCell.dataIndex)
					tempNum = 0;
				else if (num > 1)
					tempNum = lastCell.dataIndex + 1 - num;
				else
					tempNum = lastCell.dataIndex + 1;
			}

			// selectCell.OnReuse ();
			// Debug.LogError ("num: " + num + "  " + "tempNum:  " + tempNum);
			UpdateCell (selectCell, tempNum);

			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				int count = selectCell.dataIndex;
				if (count % permutationCount == 0) {
					//permutationCount  
					selectCell.SetTopLeft (count > 0 ? lastCell.Bottom - spacing : -contentPadding.top, contentPadding.left);
				} else {
					//
					selectCell.SetTopLeft (lastCell.Top, lastCell.Left + spacing + lastCell.Width);
				}

			} else {
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						selectCell.Bottom = lastCell.Top + spacing;
					} else {
						selectCell.Top = lastCell.Bottom - spacing;
					}
					selectCell.SetOffsetHorizontal (contentPadding.left, contentPadding.right);
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						selectCell.Right = lastCell.Left - spacing;
					} else {
						selectCell.Left = lastCell.Right + spacing;
					}
					selectCell.SetOffsetVertical (contentPadding.top, contentPadding.bottom);
				}
			}

			Cells.Remove (selectCell);

			Cells.AddLast (selectCell);

			// var tempCell = Cells.First;
			// int index = selectCell.Value.dataIndex-1;
			// while (tempCell != null) {
			// 	(tempCell.Value).dataIndex = index;
			// 	// Debug.LogError (tempCell.Value.gameObject.name + " index: " + (tempCell.Value).dataIndex);
			// 	tempCell = tempCell.Next;
			// 	index++;
			// }

			while (tempCell != null) {
				(tempCell.Value).dataIndex = index;
				// Debug.LogError (tempCell.Value.gameObject.name + " index: " + (tempCell.Value).dataIndex);
				tempCell = tempCell.Next;
				index++;
			}

			tempNum++;
		}

		/// <summary>
		/// cellcell
		/// </summary>
		/// <param name="selectCell"></param>
		public void SaveMoveCell (BaseCell<T> selectCell) {
			MoveCellList.Clear ();
			var tempCell = CurrentCells.First;
			bool isFind = false;

			while (tempCell != null) {
				if (selectCell == tempCell.Value) {
					isFind = true;
				}
				if (isFind) {
					// Debug.LogError("tempCell.Value: "+tempCell.Value);
					MoveCellList.Add (tempCell.Value);
				}

				tempCell = tempCell.Next;
			}
		}

		/// <summary>
		/// cell
		/// </summary>
		/// <param name="num"></param>
		/// <param name="finish"></param>
		/// <param name="isQuickBuy"></param>
		public void DoMoveCell (int num, Callback finish, bool isQuickBuy) {
			if (!isPlayAnim) {
				isPlayAnim = true;
				finish ();
				return;
			}
			// UpdateCells ();
			// ReloadData ();
			tempNum = -1; //
			List<BaseCell<T>> tempList = new List<BaseCell<T>> ();
			// Debug.LogError ("MoveCellList " + MoveCellList.Count);
			if (num == 1 && !isQuickBuy)
				tempList = MoveCellList;
			else if (num > 1 || isQuickBuy) {
				tempList.Clear ();
				var firstCell = CurrentCells.First;
				for (int i = 0; i < CurrentCells.Count; i++) {
					tempList.Add (firstCell.Value);
					if (firstCell.Next != null)
						firstCell = firstCell.Next;
				}
			}

			// DOTween.To (() => contentRectTransform.anchoredPosition, pos => contentRectTransform.anchoredPosition = pos,
			// 			new Vector2(contentRectTransform.anchoredPosition.x,contentRectTransform.anchoredPosition.y-(defaultCellSizeX + spacing) * num), 1);

			for (int i = 0; i < tempList.Count; i++) {

				RectTransform rectTrans = tempList[i].GetComponent<RectTransform> ();
				var temptarget = new Vector2 (rectTrans.anchoredPosition.x, rectTrans.anchoredPosition.y + (defaultCellSizeX + spacing) * num);

				if (i >= tempList.Count - 1) {
					DOTween.To (() => rectTrans.anchoredPosition, pos => rectTrans.anchoredPosition = pos,
							temptarget, moveSpeed)
						.OnComplete (() => {
							finish ();
							ReloadData ();
						});
				} else {
					DOTween.To (() => rectTrans.anchoredPosition, pos => rectTrans.anchoredPosition = pos,
						temptarget, moveSpeed);
				}

			}
		}

		/// <summary>
		/// 
		/// </summary>
		private void MoveCellLastToFirst () {
			if (Cells.Count == 0) return;

			BaseCell<T> lastCell = Cells.Last.Value;
			BaseCell<T> firstCell = Cells.First.Value;

			lastCell.OnReuse ();
			UpdateCell (lastCell, firstCell.dataIndex - 1);

			if (layoutMode.Equals (LayoutMode.GridLayout)) {
				int count = lastCell.dataIndex;
				int perCount = (permutationCount - 1);
				if (count < 0) {
					lastCell.SetTopLeft (firstCell.Top, firstCell.Left); //
				} else {
					// Debug.LogError ("last " + count + " lastCell.dataIndex " + lastCell.dataIndex);
					if (count % permutationCount == perCount) { //
						//permutationCount  
						lastCell.SetTopLeft (firstCell.Top + spacing + firstCell.Height, firstCell.Left + (spacing + firstCell.Width) * perCount);
					} else {
						//
						lastCell.SetTopLeft (firstCell.Top, firstCell.Left - spacing - firstCell.Width);
					}
				}
			} else {
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						lastCell.Top = firstCell.Bottom - spacing;
					} else {
						lastCell.Bottom = firstCell.Top + spacing;
					}
					lastCell.SetOffsetHorizontal (contentPadding.left, contentPadding.right);
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						lastCell.Left = firstCell.Right + spacing;
					} else {
						lastCell.Right = firstCell.Left - spacing;
					}
					lastCell.SetOffsetVertical (contentPadding.top, contentPadding.bottom);
				}
			}

			Cells.RemoveLast ();
			Cells.AddFirst (lastCell);
		}
		/// <summary>
		/// cellsize
		/// </summary>
		/// <param name="index"></param>
		/// <returns></returns>
		protected virtual Vector2 GetCellSize (int index) {
			if (LayoutMode.GridLayout.Equals (layoutMode)) {
				return new Vector2 (defaultCellSizeX, defaultCellSizeY);
			}
			return new Vector2 (defaultCellSizeX, defaultCellSizeX); //
		}
		/// <summary>
		/// /
		/// </summary>
		/// <value></value>
		private float ActiveHeadEdge {
			get {
				float edge = -activePadding;
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						edge += scrollRect.content.rect.height - scrollRect.content.anchoredPosition.y;
					} else {
						edge += scrollRect.content.anchoredPosition.y;
					}
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						edge += scrollRect.content.rect.width + scrollRect.content.anchoredPosition.x;
					} else {
						edge += -scrollRect.content.anchoredPosition.x;
					}
				}
				return edge;
			}
		}
		/// <summary>
		/// /
		/// </summary>
		/// <value></value>
		private float ActiveTailEdge {
			get {
				float edge = activePadding;
				// if (layoutMode.Equals (LayoutMode.GruopLayout)) {
				// 	edge += rectTransform.rect.height;
				// 	Debug.LogError ("ActiveTailEdge " + edge);
				// } else {

				// }
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						edge += scrollRect.content.rect.height - scrollRect.content.anchoredPosition.y + rectTransform.rect.height;
					} else {
						edge += scrollRect.content.anchoredPosition.y + rectTransform.rect.height;
						// Debug.LogError ("rectTransform.rect.height " + rectTransform.rect.height + " scrollRect.content.anchoredPosition.y " + scrollRect.content.anchoredPosition.y);
					}
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						edge += scrollRect.content.rect.width + scrollRect.content.anchoredPosition.x + rectTransform.rect.width;
					} else {
						edge += -scrollRect.content.anchoredPosition.x + rectTransform.rect.width;
					}
				}

				return (int) edge;
			}
		}
		/// <summary>
		/// cell/
		/// </summary>
		/// <value></value>
		private float CellsHeadEdge {
			get {
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						return Cells.Count > 0 ? Cells.First.Value.Bottom : contentPadding.bottom;
					} else {
						return Cells.Count > 0 ? -Cells.First.Value.Top : contentPadding.top;
					}
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						return Cells.Count > 0 ? -Cells.First.Value.Right : contentPadding.right;
					} else {
						return Cells.Count > 0 ? Cells.First.Value.Left : contentPadding.left;
					}
				}
				return 0;
			}
		}
		/// <summary>
		/// cell/
		/// </summary>
		/// <value></value>
		private float CellsTailEdge {
			get {
				if (scrollDirection == Direction.Vertical) {
					if (scrollReverse) {
						return Cells.Count > 0 ? Cells.Last.Value.Top : contentPadding.top;
					} else {
						return Cells.Count > 0 ? -Cells.Last.Value.Bottom : contentPadding.bottom;
					}
				} else if (scrollDirection == Direction.Horizontal) {
					if (scrollReverse) {
						return Cells.Count > 0 ? -Cells.Last.Value.Left : contentPadding.left;
					} else {
						return Cells.Count > 0 ? Cells.Last.Value.Right : contentPadding.right;
					}
				}
				return 0;
			}
		}

	}
}