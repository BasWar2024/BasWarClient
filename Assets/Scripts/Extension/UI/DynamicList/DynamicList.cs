
using System;
using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class DynamicRect
{
    // 
    public Rect rect;

    public int index;  // 
    public bool visable = false;

    public DynamicRect(float x, float y, float width, float height, int index)
    {
        this.index = index;
        rect = new Rect(x, y, width, height);
    }

    // 
    public bool Overlaps(DynamicRect otherRect)
    {
        return rect.Overlaps(otherRect.rect);
    }

    // 
    public bool Overlaps(Rect otherRect)
    {
        return rect.Overlaps(otherRect, true);
    }

    public override string ToString()
    {
        return string.Format("Index:{0}, x:{1}, y:{2}, w:{3}, h:{4}", index, rect.x, rect.y, rect.width, rect.height);
    }
}


// 
public class DynamicList : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public delegate void DelegateOnUpdateData(DynamicItem item);
    public delegate void DelegateOnInitItem(int index, Transform trans);
    public delegate void DelegateOnUpdateItem(int iIndex, int dIndex);
    public delegate void DelegateOnItemSelected(int index);

    // 
    public Vector2 _cellSize;
    // 
    public Vector2 _spacingSize;
    // 
    public int _columnCount = 1;
    // 
    public int _rowCount = 1;

    public string _itemPath;

    // 
    public Vector2 _offset = Vector2.zero;

    private bool _isDynamicRect = false;
    public bool isDynamicRect
    {
        set
        {
            _isDynamicRect = value;
        }
    }

    public enum Movement
    {
        Horizontal,
        Vertical,
    }

    [SerializeField]
    private Movement _moveType = Movement.Horizontal;

    // 
    protected int _gridCount;

    // 
    private Vector2 _maskSize;

    // 
    private Rect _rectMask;
    protected ScrollRect _scrollRect;

    private List<ScrollRect> _additionalScrollRect = new List<ScrollRect>();

    // 
    protected RectTransform _rtContainer;

    // 
    private List<DynamicItem> _listItems;
    private bool _useItemPool = false;

    // 
    private SortedDictionary<int, DynamicRect> _dictRect;
    private Dictionary<int, DynamicRect> _inOverlaps = new Dictionary<int, DynamicRect>();

    // 
    protected List<DynamicItemData> _dataProviders;

    protected bool _hasInited = false;
    protected bool _released = false;

    // lua
    public DelegateOnInitItem onInitItem = null;
    public DelegateOnUpdateItem onUpdateItem = null;
    public DelegateOnItemSelected onItemSelected = null;
    public Action onRelease = null;

    private DelegateOnUpdateData _onUpdate;


    private bool _isFirstShow = true;

    //
    private WaitForEndOfFrame _ienuWaitFrame = new WaitForEndOfFrame();
    protected Coroutine _coroutine = null;

    private int _selectedIndex;
    private bool _mustHasSelected;

    //item 
    public bool _isItemTweened = false;
    public float _tweenTime = 0.3f;
    private YieldInstruction itemShowInterval;

    //item
    private bool _needLocate = false;
    private float _locateDelay = 0f;
    private int _locateIndex = 0;

    //
    private bool _needJumpChoose = false;
    private string _jumpChooseId;

    public bool sectorAlign = false;
    public Vector2 basePoint = new Vector2(0, 0);
    public float ellipseA = 0;
    public float ellipseB = 0;
    public float rotateDegree = 0;
    private bool refreshPosition = true;

    private void Awake()
    {
        itemShowInterval = new WaitForSeconds(_tweenTime);
    }

    private void OnEnable()
    {
        _isFirstShow = true;

        // item()
        if(_listItems != null)
        {
            for(int index = 0; index < _listItems.Count; ++index)
            {
                DynamicItem item = _listItems[index];
                item.Reset();
            }
        }
    }

    public void SetUseItemPool(bool usePool)
    {
        _useItemPool = usePool;
    }

    // 
    public virtual void InitRendererList(DelegateOnUpdateData OnUpdate = null, bool mustHasSelected = true) //enddrag
    {
        _selectedIndex = -1;
        _mustHasSelected = mustHasSelected;

        if(_hasInited)
            return;

        _onUpdate = OnUpdate;

        //
        _rtContainer = transform as RectTransform;
        InitScroller();
        InitRenderCount();
        // 
        UpdateDynmicRects(_gridCount);
        InitChildren();
    }

    public void ResetRenderRect()
    {
        InitScroller();
        InitRenderCount();
        // 
        UpdateDynmicRects(_dataProviders.Count);
        SetListRenderSize(_dataProviders.Count);
        ClearAllListRenderDr();
        Update();
    }

    public List<DynamicItemData> ResetItemDatas()
    {
        if(_dataProviders == null)
            _dataProviders = new List<DynamicItemData>();
        else
            _dataProviders.Clear();

        return _dataProviders;
    }

    // 
    public void RefreshData(List<DynamicItemData> datas, bool isRefreshSelected = false)
    {
        if (datas == null)
        {
            Debug.LogError("datas ");
            return;
        }
        _dataProviders = datas;

        UpdateDynmicRects(datas.Count);
        SetListRenderSize(datas.Count);
        ClearAllListRenderDr();
        refreshPosition = true;

        if (_isItemTweened)
        {
            if (_isFirstShow && this.isActiveAndEnabled)
            {
                _isFirstShow = false;
                StartCoroutine(ItemWaitShow());
            }
        }

        if(isRefreshSelected && isActiveAndEnabled)
            StartCoroutine(NextFrameOnselect());
    }

    public void ReleaseListItems()
    {
        if(_listItems != null)
        {
            for(int index = 0; index < _listItems.Count; ++index)
            {
                DynamicItem item = _listItems[index];
                item.Release();

                GameObject go = item.gameObject;
                GG.ResMgr.instance.ReleaseAsset(go);
            }
            _listItems.Clear();
        }

        _hasInited = false;
        _released = true;
    }

    public void Release()
    {
        if(onRelease != null)
        {
            onRelease();
        }
        onInitItem = null;
        onUpdateItem = null;
        onItemSelected = null;
        onRelease = null;

        ReleaseListItems();
    }

    IEnumerator ItemWaitShow()
    {
        do
        {
            yield return null;
        } while(!_hasInited);

        for (int i = 0; i < _listItems.Count; i++)
        {
            _listItems[i].gameObject.SetActive(false);
        }

        int length = Math.Min(_listItems.Count, _dataProviders.Count);
        for (int i = 0; i < length; i++)
        {
            _listItems[i].gameObject.SetActive(_listItems[i].valid);
            _listItems[i].DoTween();
            yield return itemShowInterval;
        }
    }

    IEnumerator NextFrameOnselect()
    {
        do
        {
            yield return null;
        } while(!_hasInited);

        // 
        if (_listItems.Count > 0)
        {
            _listItems[0].OnSelected();

            if (onItemSelected != null)
                onItemSelected(0);
        }
    }

    public int GetItemCount()
    {
        return _listItems.Count;
    }

    public DynamicItem GetItem(int index)
    {
        if(0 <= index && index < _listItems.Count)
            return _listItems[index];

        return null;
    }

    public Transform GetItemByDataIndex(int index)
    {
        if(index < 0 || index >= _dataProviders.Count)
        {
            Debug.LogError("data index out of range when GetItemByDataIndex : " + index);
            return null;
        }

        for(int i = 0; i < _listItems.Count; ++i)
        {
            DynamicItem item = _listItems[i];
            if(item.index == index)
                return item.transform;
        }

        return null;
    }

    // 
    private int GetFirstValidItemIndex()
    {
        int len = _listItems.Count;
        for (int i = 0; i < len; ++i)
        {
            DynamicItem item = _listItems[i];
            if (!item.valid)
                return i;
        }

        return -1;
    }

    // 
    private DynamicItem GetDynmicItem(DynamicRect rect)
    {
        int len = _listItems.Count;
        for (int i = 0; i < len; ++i)
        {
            DynamicItem item = _listItems[i];
            if (!item.valid)
                continue;

            if (rect.index == item.index)
                return item;
        }

        return null;
    }

    // item
    public void RefreshItem(int index)
    {
        int count = _listItems.Count;
        for (int i = 0; i < count; i++)
        {
            var item = _listItems[i];
            if (item.valid)
            {
                if (item.index == index && item.gameObject.activeSelf)
                {
                    item.Refresh();

                    if(_onUpdate != null)
                        _onUpdate(item);

                    //
                    if(onUpdateItem != null)
                        onUpdateItem(i, index);
                }
            }
        }
    }

    public void SetItemSelected(int index)
    {
        if(index < 0 || index >= _dataProviders.Count)
        {
            _selectedIndex = -1;
            return;
        }

        _selectedIndex = index;

        int count = _listItems.Count;
        for (int i = 0; i < count; i++)
        {
            DynamicItem item = _listItems[i];
            if (item.valid)
            {
                if (item.index != index)
                    item.OnUnSelected();
                else
                {
                    item.OnSelected();
                }
            }
        }

        if(onItemSelected != null)
            onItemSelected(index);
    }

    // 
    private void InitScroller()
    {
        // Init Scroller
        _scrollRect = transform.parent.GetComponent<ScrollRect>();
        _rectMask = _scrollRect.GetComponent<RectTransform>().rect;

        if (_moveType == Movement.Horizontal)
        {
            _scrollRect.vertical = false;
            _scrollRect.horizontal = true;
        }
        else
        {
            _scrollRect.vertical = true;
            _scrollRect.horizontal = false;
        }
    }

    // 
    private void InitRenderCount()
    {
        //
        _maskSize = _rectMask.size;

        if (_moveType == Movement.Horizontal)
        {
            int column = Mathf.CeilToInt(_maskSize.x / GetBlockSizeX());
            _gridCount = _rowCount * (column + 1);
        }
        else
        {
            int row = Mathf.CeilToInt(_maskSize.y / GetBlockSizeY());
            _gridCount = (row + 1) * _columnCount;
        }
    }

    public void RestoreListItems()
    {
        if(_released)
        {
            _released = false;
            InitChildren();
        }
    }

    private void InitChildren()
    {
        if(_listItems == null)
            _listItems = new List<DynamicItem>(_gridCount);

        for (int i = 0; i < _gridCount; ++i)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(_itemPath, (obj) => {
                if(_released)
                    return false;

                return OnItemLoaded(obj);
            }, _useItemPool);
        }
    }

    public bool IsAllItemLoaded()
    {
        return _hasInited && _listItems.Count == _gridCount;
    }

    private bool OnItemLoaded(GameObject obj)
    {
        // item
        if (_listItems.Count >= _gridCount)
            return false;

        obj.transform.SetParent(transform);
        obj.transform.localRotation = Quaternion.identity;
        obj.transform.localScale = Vector3.one;
        obj.layer = gameObject.layer;

        DynamicItem dfItem = obj.GetComponent<DynamicItem>();
        if (dfItem == null)
        {
            dfItem = obj.AddComponent<DynamicItem>();
        }

        dfItem.Init();
        dfItem.Reset();
        dfItem.SetList(this);

        int index = _listItems.Count;
        _listItems.Add(dfItem);

        if (_dictRect.ContainsKey(index))
            _listItems[index].index = _dictRect[index].index;

        obj.SetActive(false);
        UpdateChildTransformPos(obj, index);

        //
        if(onInitItem != null)
            onInitItem(index, obj.transform);

        if (_listItems.Count >= _gridCount)
        {
            OnAllItemLoaded();
        }

        return true;
    }

    private void OnAllItemLoaded()
    {
        _hasInited = true;

        if (_dataProviders == null)
            return;

        UpdateDynmicRects(_dataProviders.Count);
        SetListRenderSize(_dataProviders.Count);
        ClearAllListRenderDr();

        Update();

        if (_needLocate)
        {
            _needLocate = false;
            LocateItemAtIndex(_locateIndex, _locateDelay);
        }

        if (_needJumpChoose)
        {
            _needJumpChoose = false;
            JumpChoose(_jumpChooseId);
        }
    }


    // 
    private void SetListRenderSize(int count)
    {
        if (_rtContainer == null) return;

        if (_moveType == Movement.Horizontal)
        {
            _rtContainer.sizeDelta = new Vector2(Mathf.CeilToInt((count * 1.0f / _rowCount)) * GetBlockSizeX(), _rtContainer.sizeDelta.y);
            _rectMask = new Rect(0, 0, _maskSize.x, _maskSize.y);

            //_scrollRect.horizontal = _rtContainer.sizeDelta.x > _maskSize.x;

            // todo: 
            float containerY = _rtContainer.anchoredPosition.y;
            _rtContainer.anchoredPosition = new Vector2(0, containerY);
        }
        else
        {
            _rtContainer.sizeDelta = new Vector2(_rtContainer.sizeDelta.x, Mathf.CeilToInt((count * 1.0f / _columnCount)) * GetBlockSizeY());
            _rectMask = new Rect(0, 0, _maskSize.x, _maskSize.y);

            //_scrollRect.vertical = _rtContainer.sizeDelta.y > _maskSize.y;

            // todo: 
            float containerX = _rtContainer.anchoredPosition.x;
            _rtContainer.anchoredPosition = new Vector2(containerX, 0);

            if (_isDynamicRect)
            {
                MathUtil.CalcuVector2.x = _rtContainer.sizeDelta.x;
                if (_dictRect.Count > 0)
                    MathUtil.CalcuVector2.y = -_dictRect[_dictRect.Count - 1].rect.y + _dictRect[_dictRect.Count - 1].rect.height;
                else
                    MathUtil.CalcuVector2.y = _maskSize.y;

                MathUtil.CalcuVector2.y = MathUtil.CalcuVector2.y > _maskSize.y ? MathUtil.CalcuVector2.y : _maskSize.y;
                _rtContainer.sizeDelta = MathUtil.CalcuVector2;
            }
        }
    }

    // 
    private void UpdateChildTransformPos(GameObject child, int index)
    {
        int row;
        int column;

        Vector2 v2Pos = MathUtil.CalcuVector2;
        if (_moveType == Movement.Horizontal)
        {
            row = index / _rowCount;
            column = index % _rowCount;

            v2Pos.x = GetBlockSizeX() * row + _offset.x;
            v2Pos.y = -column * GetBlockSizeY() - _offset.y;
        }
        else
        {
            row = index / _columnCount;
            column = index % _columnCount;

            v2Pos.x = column * GetBlockSizeX() + _offset.x;
            v2Pos.y = -row * GetBlockSizeY() - _offset.y;
        }

        ((RectTransform)child.transform).anchoredPosition3D = Vector3.zero;
        ((RectTransform)child.transform).anchoredPosition = v2Pos;
    }

    // 
    protected float GetBlockSizeY() { return _cellSize.y + _spacingSize.y; }
    protected float GetBlockSizeX() { return _cellSize.x + _spacingSize.x; }

    // 
    private void UpdateDynmicRects(int count)
    {
        if(_dictRect == null)
        {
            _dictRect = new SortedDictionary<int, DynamicRect>();
        }

        int curCount = _dictRect.Count;
        // 
        for (int i = 0; i < curCount; ++i)
        {
            _dictRect[i].visable = false;
        }

        // 
        if (_moveType == Movement.Horizontal)
        {
            float sx = GetBlockSizeX();
            float sy = GetBlockSizeY();

            for (int i = curCount; i < count; ++i)
            {
                int row = i / _rowCount;
                int column = i % _rowCount;

                DynamicRect dRect = new DynamicRect(row * sx, -column * sy, _cellSize.x, _cellSize.y, i);
                _dictRect[i] = dRect;
            }
        }
        else
        {
            if (_isDynamicRect)
                GenerateDynamicRect();
            else
            {
                float sx = GetBlockSizeX();
                float sy = GetBlockSizeY();

                for (int i = curCount; i < count; ++i)
                {
                    int row = i / _columnCount;
                    int column = i % _columnCount;

                    DynamicRect dRect = new DynamicRect(column * sx, -row * sy, _cellSize.x, _cellSize.y, i);
                    _dictRect[i] = dRect;
                }
            }
        }


        // 
        int minIndex = 0;
        int maxIndex = count-1;

        // 
        if(sectorAlign)
        {
            int showCount = Mathf.CeilToInt(_maskSize.x / GetBlockSizeX());
            if(count < showCount)
            {
                int middle = (int)(showCount / 2);
                maxIndex = middle + (int)(count / 2);
                minIndex = maxIndex - count + 1;
            }
        }

        for (int index = minIndex; index <= maxIndex; ++index)
        {
            if (_dictRect.ContainsKey(index))
                _dictRect[index].visable = true;
        }
    }

    //rect
    private void GenerateDynamicRect()
    {
        if (!_isDynamicRect || _dataProviders == null || _dataProviders.Count == 0) return;

        _dictRect.Clear();

        float sx = GetBlockSizeX();
        float cury = 0;
        int count = _dataProviders.Count;
        for (int i = 0; i < count; ++i)
        {
            //int row = i / _columnCount;
            //int column = i % _columnCount;

            float sy = GetBlockSizeY() > _dataProviders[i].height? GetBlockSizeY() : _dataProviders[i].height;

            DynamicRect dRect = new DynamicRect(0, -cury, sx, sy, i);
            dRect.index = i;
            _dictRect[i] = dRect;

            cury += sy;
        }
    }

    // 
    private void ClearAllListRenderDr()
    {
        if (_listItems != null)
        {
            int len = _listItems.Count;
            for (int i = 0; i < len; ++i)
            {
                DynamicItem item = _listItems[i];
                item.index = -1;
            }
        }
    }

    // 
    public List<DynamicItemData> GetDataProvider()
    {
        return _dataProviders;
    }

    public DynamicItemData GetItemData(int index)
    {
        // todo: user should handle null return value
        if(_dataProviders == null)
        {
            Debug.LogError("no data for dynamicList!");
            return null;
        }

        index = RectIndex2DataIndex(index);
        if(index < 0 || index >= _dataProviders.Count)
        {
            Debug.LogError("data index out of range for dynamicList : " + index);
            return null;
        }

        return _dataProviders[index];
    }

    #region 
    // 
    public virtual void LocateItemAtTarget(DynamicItemData target, float delay)
    {
        LocateItemAtIndex(_dataProviders.IndexOf(target), delay);
    }

    public virtual void LocateItemAtIndex(int index, float delay)
    {
        if (index < 0 || index > _dataProviders.Count - 1)
        {
            //Logger.LogError("Locate Index Error " + index);
            index = 0;
        }
        if (!_hasInited)
        {
            _needLocate = true;
            _locateDelay = delay;
            _locateIndex = index;
            return;
        }

        if (!gameObject.activeInHierarchy)
            return;

        if (!_isDynamicRect)
            index = Math.Min(index, _dataProviders.Count - _gridCount +  _columnCount);
        else
            index = Math.Min(index, _dataProviders.Count - 1);

        index = Math.Max(0, index);
        Vector2 pos = _rtContainer.anchoredPosition;
        if (_moveType == Movement.Vertical)
        {
            if (!_isDynamicRect)
            {
                int row = index / _columnCount;
                Vector2 v2Pos = new Vector2 (pos.x, pos.y + row * GetBlockSizeY ());
                _coroutine = StartCoroutine (TweenMoveToPos (pos, v2Pos, delay));
            }
            else
            {
                float height = 0;
                foreach (var item in _dictRect)
                {
                     height += item.Value.rect.size.y;
                }
                if (height > _maskSize.y)
                {
                    Vector2 v2Pos = new Vector2 (pos.x, -_dictRect[index].rect.y - _rectMask.y - _dictRect[index].rect.size.y);
                    _coroutine = StartCoroutine (TweenMoveToPos (pos, v2Pos, delay));
                }
            }
        }
        else
        {
            int row = index / _rowCount;
            Vector2 v2Pos = new Vector2(pos.x - row * GetBlockSizeX(), pos.y);
            _coroutine = StartCoroutine(TweenMoveToPos(pos, v2Pos, delay));
        }
    }

    protected IEnumerator TweenMoveToPos(Vector2 pos, Vector2 v2Pos, float delay)
    {
        bool running = true;
        float passedTime = 0f;
        while (running)
        {
            yield return _ienuWaitFrame;

            passedTime += Time.deltaTime;
            Vector2 vCur;
            if (passedTime >= delay)
            {
                vCur = v2Pos;
                running = false;
                if (_coroutine != null)
                {
                    StopCoroutine(_coroutine);
                    _coroutine = null;
                }
            }
            else
            {
                vCur = Vector2.Lerp(pos, v2Pos, passedTime / delay);
            }
            _rtContainer.anchoredPosition = vCur;
        }

    }
    #endregion

    public void OnBeginDrag(PointerEventData eventData)
    {
        _scrollRect.OnBeginDrag(eventData);

        foreach (var item in _additionalScrollRect)
        {
            item.OnBeginDrag(eventData);
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        _scrollRect.OnDrag(eventData);

        foreach (var item in _additionalScrollRect)
        {
            item.OnDrag(eventData);
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        _scrollRect.OnEndDrag(eventData);

        foreach (var item in _additionalScrollRect)
        {
            item.OnEndDrag(eventData);
        }

        if (_mustHasSelected)
            StartCoroutine(NextFrameEndDrag());
    }

    IEnumerator NextFrameEndDrag()
    {
        yield return null;
        if (_dataProviders != null)
        {
            for (int i = 0; i < _dataProviders.Count; i++)
            {
                if (_selectedIndex == _dataProviders[i].index)
                {
                    SetItemSelected(i);
                    break;
                }
            }
        }
    }

    public void JumpChoose(string id)
    {
        _jumpChooseId = id;
        if (!_hasInited || _dataProviders == null || _dataProviders.Count == 0)
        {
            _needJumpChoose = true;
            return;
        }

        foreach (var item in _dataProviders)
        {
            if (item.id == id)
            {
                LocateItemAtTarget(item, 0f);

                StartCoroutine(WaitRefreshItem(item.index)); //
                break;
            }
        }
    }

    private IEnumerator WaitRefreshItem(int index)
    {
        yield return null;

        SetItemSelected(index);
    }

    private void Update()
    {
        if(_hasInited)
        {
            UpdateRender();

            if(sectorAlign)
            {
                if(refreshPosition)
                {
                    UpdateItemPosition();
                }

                float velocity = _scrollRect.velocity.x;
                refreshPosition = (velocity != 0f);
            }
        }
    }

    protected void UpdateRender()
    {
        if(_moveType == Movement.Horizontal)
        {
            _rectMask.x = -_rtContainer.anchoredPosition.x;
            _rectMask.y = -_rtContainer.anchoredPosition.y - (GetBlockSizeY() + _spacingSize.y) * (_rowCount - 1);
        }
        else
        {
            _rectMask.x = -_rtContainer.anchoredPosition.x;
            _rectMask.y = -_rtContainer.anchoredPosition.y + GetBlockSizeY() - _maskSize.y;

            if (_isDynamicRect)
            {
                foreach (var item in _dictRect)
                {
                    if (-item.Value.rect.y + item.Value.rect.size.y + 1 > _rtContainer.anchoredPosition.y)
                    {
                        MathUtil.CalcuVector2.x = _maskSize.x;
                        MathUtil.CalcuVector2.y = _maskSize.y + item.Value.rect.size.y;
                        if (MathUtil.CalcuVector2.y <= _maskSize.y)
                        {
                            MathUtil.CalcuVector2.y = _maskSize.y;
                        }
                        _rectMask.size = MathUtil.CalcuVector2;
                        break;
                    }
                }
                if (_rectMask.size.y <= _maskSize.y)
                {
                    _rectMask.y = 0;
                }
                else
                {
                    _rectMask.y = -_rtContainer.anchoredPosition.y - _maskSize.y;
                }

                //_rectMask.y = _rectMask.y > _maskSize.y ? _rectMask.y : _maskSize.y;
            }
        }

        UpdateShowRect();
        UpdateShowItems();
    }

    private void UpdateShowRect()
    {
        _inOverlaps.Clear();
        bool isCrossed = false;

        // 
        for (int i = 0; i < _dictRect.Count; i++)
        {
            DynamicRect dR = _dictRect[i];
            if (dR.visable && dR.Overlaps(_rectMask))
            {
                _inOverlaps.Add(dR.index, dR);
                isCrossed = true;
            }
            else if (isCrossed) // 
                break;
        }
    }

    private void UpdateShowItems()
    {
        for (int i = 0; i < _listItems.Count; ++i)
        {
            DynamicItem item = _listItems[i];
            if (item.valid && !_inOverlaps.ContainsKey(item.index))
                item.index = -1;
        }

        //UnityEngine.Profiling.Profiler.BeginSample("DynamicItem.RefreshItem");
        foreach (DynamicRect dR in _inOverlaps.Values)
        {
            if (GetDynmicItem(dR) == null)
            {
                int itemIndex = GetFirstValidItemIndex();
                if (itemIndex != -1)
                {
                    DynamicItem item = _listItems[itemIndex];
                    item.index = dR.index;

                    if (!_isDynamicRect)
                        UpdateChildTransformPos(item.gameObject, dR.index);
                    else
                        item.GetComponent<RectTransform>().anchoredPosition = dR.rect.position;

                    int dataIndex = RectIndex2DataIndex(dR.index);
                    if (_dataProviders != null && dataIndex < _dataProviders.Count)
                    {
                        // todo: data.index
                        _dataProviders[dataIndex].index = dR.index;
                        item.Refresh();

                        if(_onUpdate != null)
                            _onUpdate(item);

                        if(onUpdateItem != null)
                            onUpdateItem(itemIndex, dR.index);
                    }
                }
            }
        }
        //UnityEngine.Profiling.Profiler.EndSample();
    }

    private int RectIndex2DataIndex(int rectIndex)
    {
        int index = rectIndex;

        // 
        if(sectorAlign)
        {
            int dataCount = _dataProviders == null ? 0 : _dataProviders.Count;
            int showCount = Mathf.CeilToInt(_maskSize.x / GetBlockSizeX());
            if(dataCount < showCount)
            {
                int middle = (int)(showCount / 2);
                int maxIndex = middle + (int)(dataCount / 2);
                int minIndex = maxIndex - dataCount + 1;

                index = rectIndex - minIndex;
            }
        }

        return index;
    }

    private void UpdateItemPosition()
    {
        //UnityEngine.Profiling.Profiler.BeginSample("DynamicList.UpdateItemPosition");
        Vector2 parentPos = new Vector2(_rtContainer.localPosition.x, _rtContainer.localPosition.y);
        Vector2 iCenterOffset = new Vector2(_cellSize.x/2, - _cellSize.y/2);

        foreach (DynamicRect dR in _inOverlaps.Values)
        {
            DynamicItem item = GetDynmicItem(dR);
            if(item != null)
            {
                // 
                int index = item.index;
                Vector2 pos = new Vector2(GetBlockSizeX() * index + _offset.x, -_offset.y) + parentPos;
                float offset = GetItemOffset();

                Vector2 itemCenter = new Vector2(pos.x + offset, pos.y) + iCenterOffset;
                itemCenter -= basePoint; //  (0, 0)

                float x = itemCenter.x;
                float y = CalculateY(x);
                float angle = itemCenter.x / ellipseA * (-rotateDegree);

                Vector2 newPos = new Vector2(x, y);
                newPos = newPos + basePoint - iCenterOffset - parentPos;

                item.UpdateTransform(newPos, angle);
            }
        }
        //UnityEngine.Profiling.Profiler.EndSample();
    }

    private float GetItemOffset()
    {
        float offset = 0;

        int dataCount = _dataProviders == null ? 0 : _dataProviders.Count;
        int showCount = Mathf.CeilToInt(_maskSize.x / GetBlockSizeX());
        if(dataCount < showCount)
        {
            //
            if(((showCount&1) == 0 && (dataCount&1) != 0) || ((showCount&1) != 0 && (dataCount&1) == 0))
            {
                offset = -GetBlockSizeX() / 2;
            }
        }

        return offset;
    }

    // Y
    private float CalculateY(float x)
    {
        x = Mathf.Max(x, -ellipseA);
        x = Mathf.Min(x, ellipseA);

        return Mathf.Sqrt((1f - (x*x)/(ellipseA*ellipseA)) * (ellipseB*ellipseB));
    }

    public void AddScrollRect(ScrollRect sRect)
    {
        _additionalScrollRect.Add(sRect);
    }

}
