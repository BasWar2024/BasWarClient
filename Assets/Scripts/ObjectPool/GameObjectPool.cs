using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;

public class GOContainer
{
    // ""
    private string _type = "";

    public string cType
    {
        get { return _type; }
    }

    // capacity of container
    private int _capacity = 128;

    public int capacity
    {
        set { _capacity = value; }
    }

    float _expirationTime = 120; // ""

    public float ExpirationTime
    {
        set { _expirationTime = value; }
    }

    float _cullInterval = 30; // ""

    public float CullInterval
    {
        set { _cullInterval = value; }
    }

    private float _lastAccessTime = 0f;

    public float lastAccessTime
    {
        get { return _lastAccessTime; }
    }

    // data need to be reset when reusing gameObject
    private Vector3 _orgPosition = new Vector3(1000, 0, 1000);
    private Vector3 _orgScale = Vector3.one;
    private Quaternion _orgRotation = Quaternion.identity;

    private float _lastCullTime = 0;

    // gameObject Queue
    private Queue<GameObject> _goQueue = new Queue<GameObject>();

    public bool isEmpty
    {
        get { return _goQueue.Count == 0; }
    }

    public GOContainer(string type, Transform orgTrans, float _cullInterval = 30, float expirationTime = 120)
    {
        _type = type;
        _expirationTime = expirationTime;

        _orgPosition = orgTrans.localPosition;
        _orgScale = orgTrans.localScale;
        _orgRotation = orgTrans.localRotation;

        _lastAccessTime = Time.realtimeSinceStartup;
    }

    public GameObject SpawnInstance()
    {
        /*
        GameObject inst = (from go in _goQueue
                           where go.activeSelf == false
                           select go
                           ).FirstOrDefault() as GameObject;
        */
        if (_goQueue.Count == 0)
            return null;

        GameObject inst = _goQueue.Dequeue();

        if (inst != null)
        {
            inst.transform.localPosition = _orgPosition;
            inst.transform.localScale = _orgScale;
            inst.transform.localRotation = _orgRotation;
            inst.SetActive(true);

            _lastAccessTime = Time.realtimeSinceStartup;
        }

        return inst;
    }

    public bool DespawnInstance(GameObject go)
    {
        if (_goQueue.Count <= _capacity)
        {
            go.SetActive(false);
            _goQueue.Enqueue(go);

            _lastAccessTime = Time.realtimeSinceStartup;

            return true;
        }
        else
        {
            Addressables.ReleaseInstance(go);
        }

        return false;
    }

    public void EnqueueInstance(GameObject go)
    {
        if (_goQueue.Count <= _capacity)
        {
            go.SetActive(false);
            _goQueue.Enqueue(go);

            _lastAccessTime = Time.realtimeSinceStartup;
        }
        else
        {
            Addressables.ReleaseInstance(go);
        }
    }

    // cull container size by half one time
    public void CullInstances()
    {
        float curTime = Time.realtimeSinceStartup;
        if (curTime - _lastCullTime < _cullInterval)
            return;

        _lastCullTime = curTime;

        int total = _goQueue.Count;
        if (total == 0)
            return;

        int cull = (total == 1) ? 1 : (total / 2);
        for (int index = 0; index < cull; ++index)
        {
            GameObject go = _goQueue.Dequeue();
            Addressables.ReleaseInstance(go);
        }
    }

    // ""
    public bool IsExpired()
    {
        float curTime = Time.realtimeSinceStartup;
        return curTime - _lastAccessTime > _expirationTime;
    }

    public void Clear()
    {
        var etor = _goQueue.GetEnumerator();
        while (etor.MoveNext())
        {
            //GameObject.Destroy(etor.Current);
            Addressables.ReleaseInstance(etor.Current);
        }

        _goQueue.Clear();
    }
}

public class GameObjectPool : MonoBehaviour
{
    //""
    private int kPoolCullInterval = 30;

    //""
    Dictionary<string, GOContainer> _instCache = new Dictionary<string, GOContainer>(); //key assetName  , value  ""

    //""
    //Dictionary<string, int> _assetDic = new Dictionary<string, int>(); //key : assetName , value : go id(not instance)

    //""id,  ""
    Dictionary<int, string> _cacheRecord = new Dictionary<int, string>(); //key : inst id,  value : assetName

    private float _lastCullTime = 0;

    private Transform _poolTrans = null;

    private void Start()
    {
        _poolTrans = transform;
        _lastCullTime = UnityEngine.Time.realtimeSinceStartup;
    }

    private void Update()
    {
        CullInstances();
    }

    private void OnDestroy()
    {
        Clear();
    }

    public GameObject SpawnGameObject(string assetName)
    {
        GameObject go = null;

        if (_instCache.ContainsKey(assetName))
        {
            GOContainer container = _instCache[assetName];
            go = container.SpawnInstance();
        }

        if (go != null)
        {
            int instID = go.GetInstanceID();
            _cacheRecord[instID] = assetName;

            go.SetActive(true);
            go.transform.SetParent(null);
        }

        return go;
    }

    public bool DespawnGameObject(GameObject go)
    {
        int instID = go.GetInstanceID();

        if (_cacheRecord.ContainsKey(instID))
        {
            // disable first
            go.SetActive(false);
            string assetName = _cacheRecord[instID];
            go.transform.position = new Vector3(100, 0, 100);

            GOContainer container = GetContainer(assetName);
            if (container != null)
            {
                if (container.DespawnInstance(go))
                {
                    go.transform.SetParent(_poolTrans);
                }
            }
            else
            {
                Addressables.ReleaseInstance(go);
            }

            _cacheRecord.Remove(instID);

            return true;
        }

        return false;
    }

    private GOContainer GetContainer(string assetName)
    {
        GOContainer container = null;

        if (_instCache.ContainsKey(assetName))
        {
            container = _instCache[assetName];
        }

        return container;
    }

    public GameObject MarkGameObject(string assetName, GameObject go)
    {
        if (!_instCache.ContainsKey(assetName))
        {
            GOContainer container = new GOContainer(assetName, go.transform);
            _instCache.Add(assetName, container);
        }

        int instID = go.GetInstanceID();
        _cacheRecord[instID] = assetName;
        return go;
    }

    public GameObject MarkGameObjectAsset(string assetName, int cullInterval, float expirationTime, GameObject asset)
    {
        GameObject go = UnityEngine.GameObject.Instantiate(asset, Vector3.zero, Quaternion.identity);
        if (!_instCache.ContainsKey(assetName))
        {
            GOContainer container = new GOContainer(assetName, go.transform, cullInterval, expirationTime);
            _instCache.Add(assetName, container);
        }
        
        int instID = go.GetInstanceID();
        _cacheRecord[instID] = assetName;

        return go;
    }

    public void MarkPreloadCache(string assetName, int cullInterval, float expirationTime, GameObject go)
    {
        GOContainer container;
        if (!_instCache.ContainsKey(assetName))
        {
            container = new GOContainer(assetName, go.transform, cullInterval, expirationTime);
            _instCache.Add(assetName, container);
        }

        container = GetContainer(assetName);
        if (container.DespawnInstance(go))
        {
            go.transform.SetParent(_poolTrans);
        }
    }

    private void CullInstances()
    {
        // ""
        float curTime = UnityEngine.Time.realtimeSinceStartup;
        if (curTime - _lastCullTime < kPoolCullInterval)
            return;

        _lastCullTime = curTime;

        List<string> expiration = new List<string>();

        var etor = _instCache.GetEnumerator();
        while (etor.MoveNext())
        {
            GOContainer container = etor.Current.Value;
            if (container.isEmpty && container.IsExpired())
                expiration.Add(etor.Current.Key);
            else
                container.CullInstances();
        }

        // remove expired containers
        var tmp = expiration.GetEnumerator();
        while (tmp.MoveNext())
        {
            GOContainer container = _instCache[tmp.Current];
            container.Clear();
            _instCache.Remove(tmp.Current);
        }
    }

    //public void ClearPool()
    //{
    //    var etor = _instCache.GetEnumerator();
    //    while (etor.MoveNext())
    //    {
    //        GOContainer container = etor.Current.Value;
    //        container.Clear();
    //    }
    //    _instCache.Clear();
    //}

    public void Clear()
    {
        var etor = _instCache.GetEnumerator();
        while (etor.MoveNext())
        {
            GOContainer container = etor.Current.Value;
            container.Clear();
        }

        _instCache.Clear();
        _cacheRecord.Clear();
    }
}