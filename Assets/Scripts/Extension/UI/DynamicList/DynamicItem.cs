using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System;
using DG.Tweening;

public class DynamicItemData
{
    public int index;

    public string id; //""，""，""id

    // ""item
    public float height = -1;
}

// ""item
// todo : item""(btn""、go"")
public class DynamicItem : MonoBehaviour
{
    protected DynamicList _list;

    protected int _index = -1;
    public int index
    {
        get
        {
            return _index;
        }
        set
        {
            _index = value;
            gameObject.SetActive(value != -1);
        }
    }

    public bool valid
    {
        get
        {
            // todo ""?
            return _index != -1;
        }
    }

    private RectTransform _cachedTransform;
    private Button itemBtn;

    public virtual void Init()
    {
        if(itemBtn == null)
        {
            itemBtn = gameObject.GetComponent<Button>();
            if(itemBtn)
            {
                itemBtn.onClick.RemoveAllListeners();
                itemBtn.onClick.AddListener(() => {
                    _list.SetItemSelected(_index);
                });
            }
        }

        _cachedTransform = GetComponent<RectTransform>();
    }

    public virtual void Reset()
    {
        OnUnSelected();
    }

    public virtual void Release()
    {
        _list = null;
        _index = -1;
    }

    public void UpdateTransform(Vector2 pos, float angle = 0)
    {
        if(_cachedTransform != null)
        {
            _cachedTransform.localPosition = new Vector3(pos.x, pos.y, 0);
            _cachedTransform.localRotation = Quaternion.Euler(0, 0, angle);
        }
    }

    public void DoTween()
    {
        UITweenScale t = GetComponent<UITweenScale>();
        if(t != null)
            t.TweenScale();
    }

    // ""item""list
    public void SetList(DynamicList list)
    {
        _list = list;
    }

    // ""item
    public virtual void Refresh()
    {
    }

    public virtual void OnSelected()
    {
    }

    public virtual void OnUnSelected()
    {
    }

    public DynamicItemData GetData()
    {
        return _list.GetItemData(_index);
    }

    protected void LoadAssetAsync<T>(string path, Action<T> onLoaded) where T : UnityEngine.Object
    {
        GG.ResMgr.instance.LoadAssetAsync<T>(path, (go) => {
            if (_cachedTransform == null)
                return;

            onLoaded(go);
        });
    }

    protected void LoadGameObjectAsync(string path, Action<GameObject> onloaded, bool cache = false)
    {
        GG.ResMgr.instance.LoadGameObjectAsync(path, (go) => {
            if (_cachedTransform == null)
                return false;

            onloaded(go);
            return true;
        }, cache);
    }
}
