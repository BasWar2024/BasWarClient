using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using DG.Tweening;

class ItemInfo
{
    public int dataIndex;
    public GameObject go;
    public RectTransform rect;

    public ItemInfo(GameObject go)
    {
        this.go = go;
        rect = go.GetComponent<RectTransform>();
    }
}

enum ScrollDirection
{
    Vertical = 0,
    Horizontal = 1,
}
enum PosDir
{
    Top = 0,
    Bottom = 1,
}

public class LoopScrollView : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public float spancing = 0;
    public GameObject itemPrefab;
    public int dataCount = 0;
    public int direction = 1;

    // Start is called before the first frame update
    ScrollRect _scrollRect = null;
    RectTransform _rectViewport = null;
    RectTransform _rectContent = null;
    RectTransform _rect = null;
    Action<GameObject, int> _renderHandler;
    Action<GameObject, int> _renderSizeHandler;

    Dictionary<GameObject, ItemInfo> _dictItem;
    Stack<ItemInfo> _itemPool = new Stack<ItemInfo>();

    int _beginDataIndex = 0;
    int _endDataIndex = 0;

    public bool isRefreshAsync = false;

    void Awake()
    {
        Init();
    }

    void Start()
    {
        
        SetDataCount(dataCount);
        //SetDataCount(30);
    }

    // Update is called once per frame
    void Update()
    {
        UpdateItems();
    }

    void OnDestroy()
    {
        //Release();
    }
    
    void Init()
    {
        _scrollRect = transform.GetComponent<ScrollRect>();
        _rectViewport = _scrollRect.viewport.GetComponent<RectTransform>();
        _rectContent = _scrollRect.content.GetComponent<RectTransform>();
        _rect = transform.GetComponent<RectTransform>();
        _dictItem = new Dictionary<GameObject, ItemInfo>();
        _scrollRect.onValueChanged.AddListener(OnScrollValueChange);

        if (direction == 1)
        {
            _rectContent.anchorMin = new Vector2(0, 1);
            _rectContent.anchorMax = new Vector2(1, 1);
            _rectContent.pivot = new Vector2(0, 1);
        }
        else
        {
            _rectContent.anchorMin = new Vector2(0, 0);
            _rectContent.anchorMax = new Vector2(1, 0);
            _rectContent.pivot = new Vector2(0, 0);
        }
    }

    void InitList()
    {
        _beginDataIndex = dataCount + 1;
        _endDataIndex = 0;
        _rectContent.anchoredPosition = new Vector2(_rectContent.anchoredPosition.x, 0);

        if (direction == 1)
        {
            _beginDataIndex = 1;
            InitTop2BottomByIndex(1);
        }
        else if (direction == -1)
        {
            _endDataIndex = dataCount;
            InitBottom2TopByIndex(_rectContent.childCount);
        }
    }
    void RecycleAllItem()
    {
        List<ItemInfo> itemList = new List<ItemInfo>();
        foreach (var item in _dictItem.Values)
        {
            itemList.Add(item);
        }
        foreach (var item in itemList)
        {
            RecycleItem(item.go);
        }
    }

    void Refresh()
    {
        InitList();
        if (isRefreshAsync)
        {
            isUpdateItems = true;
        }
        else
        {
            LoopRefreshVertical();
        }
    }

    bool isUpdateItems;
    void UpdateItems() {
        if (isUpdateItems)
        {
            if (direction == 1)
            {
                isUpdateItems = RefreshTop2Bottom(true);
            }
            else
            {
                isUpdateItems = RefreshBottom2Top(true);
            }
        }
    }

    void LoopRefreshVertical()
    {
        if (direction == 1)
        {
            if (RefreshTop2Bottom(true))
            {
                LoopRefreshVertical();
                return;
            }
        }
        else
        {
            if (RefreshBottom2Top(true))
            {
                LoopRefreshVertical();
                return;
            }
        }
    }

    float lastValueY = 0;
    public void OnScrollValueChange(Vector2 vector)
    {
        if (Math.Abs(vector.y - lastValueY) < 0.001)
        {
            return;
        }
        //print("OnScrollValueChange" + " " + Convert.ToString(vector.y) + " " + (vector.y - lastValueY < 0));
        if (vector.y - lastValueY < 0)
        {
            RefreshTop2Bottom(direction == 1);
        }
        else
        {
            RefreshBottom2Top(direction == -1);
        }

        lastValueY = vector.y;
    }

    void InitTop2BottomByIndex(int index)
    {
        int childCount = _rectContent.childCount;
        if (childCount < index || childCount == 0 || index == 0) return;
        ItemInfo item = _dictItem[_rectContent.GetChild(index - 1).gameObject];
        int dataIndex = _beginDataIndex + index - 1;
        if (dataIndex > dataCount)
        {
            RecycleItem(item.go);
            InitTop2BottomByIndex(index);
        }
        else
        {
            RenderItem(item.go, dataIndex);
            RenderItemSize(item.go, dataIndex);
            _endDataIndex = dataIndex;
            if (index == 1)
            {
                item.rect.anchoredPosition = new Vector2(0, 0);
            }
            else
            {
                ItemInfo lastItem = _dictItem[_rectContent.GetChild(index - 1 - 1).gameObject];
                item.rect.anchoredPosition = new Vector2(0, lastItem.rect.anchoredPosition.y - (spancing + lastItem.rect.rect.height));
            }
            InitTop2BottomByIndex(index + 1);
        }
    }

    void InitBottom2TopByIndex(int index)
    {
        int childCount = _rectContent.childCount;
        if (childCount < index || childCount == 0 || index == 0) return;
        ItemInfo item = _dictItem[_rectContent.GetChild(index - 1).gameObject];
        int dataIndex = dataCount - (childCount - index);
        if (dataIndex < 1)
        {
            RecycleItem(item.go);
            InitBottom2TopByIndex(index - 1);
        }
        else
        {
            _beginDataIndex = dataIndex;
            if (index == childCount)
            {
                item.rect.anchoredPosition = new Vector2(0, 0);
            }
            else
            {
                ItemInfo lastItem = _dictItem[_rectContent.GetChild(index - 1 + 1).gameObject];
                item.rect.anchoredPosition = new Vector2(0, lastItem.rect.anchoredPosition.y + (spancing + lastItem.rect.rect.height));
            }
            InitBottom2TopByIndex(index - 1);
        }
    }

    public bool RefreshTop2Bottom(bool isSetContentSize)
    {
        if (_endDataIndex >= dataCount)
        {
            return false;
        }

        RectTransform bottomRect = null;
        if (_rectContent.transform.childCount > 0)
        {
            bottomRect = _rectContent.GetChild(_rectContent.childCount - 1).GetComponent<RectTransform>();
        }

        bool isSet = false;
        if (_rectContent.transform.childCount <= 0 || GetPosYBaseRect(_rectViewport, -1) - GetPosYBaseRect(bottomRect, -1) < 0)
        {
            isSet = true;
            GetNewItem((item) =>
            {
                _endDataIndex++;
                item.go.transform.SetAsLastSibling();
                RenderItem(item.go, _endDataIndex);
                RenderItemSize(item.go, _endDataIndex);
                item.dataIndex = _endDataIndex;

                if (bottomRect != null)
                {
                    item.rect.anchoredPosition = new Vector2(0, bottomRect.anchoredPosition.y - (spancing + bottomRect.rect.height));
                }
                else
                {
                    _beginDataIndex = 1;
                    item.rect.anchoredPosition = new Vector2(0, 0);
                }

                if (isSetContentSize)
                {
                    float subLenth = GetPosYBaseRect(item.rect, -1) - GetPosYBaseRect(_rectContent, -1);
                    _rectContent.SetRectSizeY(_rectContent.rect.height - subLenth + 1);
                }
                return true;
            });
        }

        if (CheckOutOfRange(_scrollRect.content.GetChild(0).gameObject))
        {
            _beginDataIndex += 1;
        }
        return isSet;
    }

    public bool RefreshBottom2Top(bool isSetContentSize)
    {
        if (_beginDataIndex <= 1)
        {
            return false;
        }

        RectTransform topRect = null;
        if (_rectContent.transform.childCount > 0)
        {
            topRect = _rectContent.GetChild(0).GetComponent<RectTransform>();
        }

        bool isSet = false;
        if (_rectContent.transform.childCount <= 0 || GetPosYBaseRect(_rectViewport, 1) - GetPosYBaseRect(topRect, 1) > 0)
        {
            isSet = true;
            GetNewItem((item) =>
            {
                _beginDataIndex = _beginDataIndex - 1;
                item.go.transform.SetAsFirstSibling();
                RenderItem(item.go, _beginDataIndex);
                RenderItemSize(item.go, _beginDataIndex);
                item.dataIndex = _beginDataIndex;

                if (topRect != null)
                {
                    item.rect.anchoredPosition = new Vector2(0, topRect.anchoredPosition.y + (spancing + topRect.rect.height));
                }
                else
                {
                    _endDataIndex = dataCount;
                    item.rect.anchoredPosition = new Vector2(0, 0);
                }

                if (isSetContentSize)
                {
                    float subLenth = GetPosYBaseRect(item.rect, 1) - GetPosYBaseRect(_rectContent, 1);
                    _rectContent.SetRectSizeY(_rectContent.rect.height + subLenth + 1);
                }
                return true;
            });
        }

        if (CheckOutOfRange(_rectContent.GetChild(_rectContent.childCount - 1).gameObject))
        {
            _endDataIndex -= 1;
        }
        return isSet;
    }

    void GetNewItem(Func<ItemInfo, bool> callBack, int index = -1)
    {
        ItemInfo item;
        if (index > 0 && _rectContent.childCount >= index)
        {
            item = _dictItem[_rectContent.GetChild(index - 1).gameObject];
        }
        else
        {
            if (_itemPool.Count > 0)
            {
                item = _itemPool.Pop();
            }
            else
            {
                item = new ItemInfo(Instantiate(itemPrefab));
            }
            if (!_dictItem.ContainsKey(item.go))
            {
                _dictItem.Add(item.go, item);
            }
        }
        item.go.transform.SetParentEx(_rectContent, false);
        item.go.transform.SetActiveEx(true);
        if (direction == 1)
        {
            item.rect.anchorMax = new Vector2(0.5f, 1);
            item.rect.anchorMin = new Vector2(0.5f, 1);
            item.rect.pivot = new Vector2(0.5f, 1);
        }
        else
        {
            item.rect.anchorMax = new Vector2(0.5f, 0);
            item.rect.anchorMin = new Vector2(0.5f, 0);
            item.rect.pivot = new Vector2(0.5f, 0);
        }
        callBack(item);
    }

    public bool CheckOutOfRange(GameObject go)
    {
        if (!_dictItem.TryGetValue(go, out ItemInfo item))
        {
            return false;
        }
        if (GetPosYBaseRect(item.rect, -1) > GetPosYBaseRect(_rectViewport, 1) || GetPosYBaseRect(item.rect, 1) < GetPosYBaseRect(_rectViewport, -1))
        {
            return RecycleItem(go);
        }
        return false;
    }

    bool RecycleItem(GameObject go)
    {
        if (!_dictItem.TryGetValue(go, out ItemInfo item))
        {
            item = new ItemInfo(go);
        }
        go.transform.SetParent(_rectViewport, false);
        go.transform.SetActiveEx(false);
        _itemPool.Push(item);
        _dictItem.Remove(go);
        return true;
    }

    float GetPosYBaseRect(RectTransform trans, int direction)
    {
        if (direction == 1)
        {
            return _rect.InverseTransformPoint(trans.transform.position).y + trans.rect.height * (1 - trans.pivot.y);
        }
        else
        {
            return _rect.InverseTransformPoint(trans.transform.position).y - trans.rect.height * trans.pivot.y;
        }
    }

    void SetAllItemAnchorPivot(Vector2 min, Vector2 max, Vector2 pivot)
    {
        foreach (ItemInfo item in _dictItem.Values)
        {
            item.rect.pivot = new Vector2(0.5f, 0.5f);
            if (item.rect.anchorMin != min)
            {
                item.rect.anchorMin = min;
            }
            if (item.rect.anchorMax != max)
            {
                item.rect.anchorMax = max;
            }
            if (item.rect.pivot != pivot)
            {
                item.rect.pivot = pivot;
            }
        }
    }
    //=============================================================
    public void SetRenderHandler(Action<GameObject, int> renderHandler)
    {
        _renderHandler = renderHandler;
    }

    public void SetRenderSizeHandler(Action<GameObject, int> renderSizeHandler)
    {
        _renderSizeHandler = renderSizeHandler;
    }

    public void SetDataCount(int dataCount)
    {
        this.dataCount = dataCount;
        Refresh();
    }

    public void Release()
    {
        foreach (var item in _itemPool)
        {
            Destroy(item.go);
        }

        foreach (var item in _dictItem)
        {
            Destroy(item.Value.go);
        }
    }
    //=================================================================================
    void RenderItemSize(GameObject go, int index)
    {
        //print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + index + " " + _beginDataIndex + " " + _endDataIndex + " " + dataCount);
        _renderSizeHandler?.Invoke(go, index);
    }

    void RenderItem(GameObject go, int index)
    {
        _renderHandler?.Invoke(go, index);
    }
    // ==================================================================================
    void IBeginDragHandler.OnBeginDrag(PointerEventData eventData)
    {
    }

    public void OnDrag(PointerEventData eventData)
    {
    }

    public void OnEndDrag(PointerEventData eventData)
    {
    }
}
