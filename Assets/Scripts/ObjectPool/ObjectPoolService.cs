using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.EventSystems;
using UnityEngine.ResourceManagement.AsyncOperations;

namespace GG {
    public class PoolNormalFactory : IObjectFactory<IPoolable> {

        public AsyncOperationHandle handle { get; set; }
        public Transform _rootTrans;
        GameObject perfabObj;
        ReactiveProperty<bool> isHasHandle;
        public PoolNormalFactory (string assetString, Transform rootTrans) {
            this._rootTrans = rootTrans;
            isHasHandle = new ReactiveProperty<bool> ();

            //
            handle = ResMgr.instance.LoadAssetAsync<GameObject> (assetString, (PerfabObj) => {
                perfabObj = PerfabObj;
                isHasHandle.Value = true;
            });
        }
        public void Create (Callback<IPoolable> finish) {
            CompositeDisposable comp = new CompositeDisposable ();
            isHasHandle
                .Where (_ => _)
                .Subscribe (_ => {
                    comp.Dispose ();
                    var go = GameObject.Instantiate (perfabObj, Vector3.zero * 5000, Quaternion.identity);
                    go.transform.SetParent (_rootTrans, false);
                    if (go.GetComponent<RectTransform> () != null) {
                        go.GetComponent<RectTransform> ().anchoredPosition = Vector2.zero;
                    }
                    if (finish != null) {
                        // var res = go.GetComponent<MonoBehaviour> () as IPoolable;
                        var res = go.GetComponent<IPoolable> ();
                        finish (res);
                    }
                }).AddTo (comp);
        }

        public void CreateArray (int InstanceCount, Callback<IPoolable[]> finish) {
            CompositeDisposable comp = new CompositeDisposable ();
            isHasHandle
                .Where (_ => _)
                .Subscribe (_ => {
                    comp.Dispose ();
                    List<IPoolable> temp = new List<IPoolable> ();

                    for (int i = 0; i < InstanceCount; i++) {
                        var go = GameObject.Instantiate (perfabObj,
                            Vector3.zero * 5000,
                            Quaternion.identity);
                        go.transform.SetParent (_rootTrans, false);
                        var mono = go.GetComponent<MonoBehaviour> () as IPoolable;
                        temp.Add (mono);
                    }
                    if (finish != null) {
                        finish (temp.ToArray ());
                    }
                }).AddTo (comp);
        }
    }

    [ResService ("ObjectPoolService")]
    public class ObjectPoolService : IResService, IPoolService {

        Dictionary<string, SingleTypeObjPool<IPoolable>> PoolDic;
        Dictionary<string, Transform> PoolRootTrans;
        Queue<MonoBehaviour> MonoDestoryQueue; //
        int poolPerLoadingCount, currentSinglePoolCount;
        Callback _finishCB;
        public void Init () {
            PoolDic = new Dictionary<string, SingleTypeObjPool<IPoolable>> ();
            MonoDestoryQueue = new Queue<MonoBehaviour> ();
            PoolRootTrans = new Dictionary<string, Transform> ();
            poolPerLoadingCount = 0;
        }
        public void OnStart (Callback finishCB) {
            _finishCB = finishCB;
            //
            Observable
                .EveryLateUpdate ()
                .Subscribe (PoolCleaning);

            //perLoadingPerfabs
            // CreateNewTypePool<ProductionUIItem_Mono> (GetAdressEnum.Entries.ProductionUIItem, 10, 10, true, false, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<Shop_Collection_Item_Mono> (GetAdressEnum.Entries.Shop_Collection_Item, 8, 32, true, false, CheckAllSinglePoolFinishCB);
            // // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.HumanItem, 12, 12, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.StationHuman, 5, 12, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.StationHuman_Woman, 5, 12, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.NormalHumanItem, 12, 35, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.NormalHumanItem_Woman, 12, 35, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.HumanChild_Boy, 5, 10, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.HumanChild_Girl, 5, 10, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<HumanItem> (GetAdressEnum.Entries.AdviserHumanItem, 1, 10, false, true, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<DollarText> (GetAdressEnum.Entries.DollarText, 10, 15, true, false, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<FameEffectItem> (GetAdressEnum.Entries.prestigeEffect, 3, 5, true, false, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<UFOBurstText> (GetAdressEnum.Entries.UFOBurstText, 1, 2, true, false, CheckAllSinglePoolFinishCB);
            // CreateNewTypePool<MultipleCell> (GetAdressEnum.Entries.Shop_Multiplier_Item, 4, 5, false, false, CheckAllSinglePoolFinishCB);

        }
        void CheckAllSinglePoolFinishCB () {
            poolPerLoadingCount++;
            if (_finishCB != null && poolPerLoadingCount >= currentSinglePoolCount) {
                _finishCB ();
            }
        }

        public void OnServiceDisable () { }
        /// <summary>
        ///  
        /// </summary>
        /// <param name="obj"></param>
        /// <typeparam name="T"></typeparam>
        public void RecycleMono<T> (T obj, string poolName = "") where T : IPoolable {
            var typeName = poolName.Length > 0 ? poolName : typeof (T).Name;
            if (PoolDic.ContainsKey (typeName)) {
                var isMonoObj = obj as MonoBehaviour;
                // Debug.LogError("name: "+isMonoObj.name);
                if (PoolDic[typeName].Recycle (obj)) {
                    //
                    if (isMonoObj != null)
                        // Debug.LogError ("");
                        isMonoObj.transform.SetParent (PoolRootTrans[typeName], false);
                } else {
                    //
                    if (isMonoObj != null)
                        MonoDestoryQueue.Enqueue (isMonoObj);
                }
            } else {
                Debug.LogError ("===========   ===========  " + typeName);
            }
        }

        public void RecycleMono (MonoBehaviour obj, string poolName) {
            var typeName = poolName;
            if (PoolDic.ContainsKey (typeName)) {
                var isMonoObj = obj;
                // Debug.LogError("name: "+isMonoObj.name);
                if (PoolDic[typeName].Recycle (obj.GetComponent<IPoolable> ())) {
                    //
                    if (isMonoObj != null)
                        // Debug.LogError ("");
                        isMonoObj.transform.SetParent (PoolRootTrans[typeName], false);
                } else {
                    //
                    if (isMonoObj != null)
                        MonoDestoryQueue.Enqueue (isMonoObj);
                }
            } else {
                Debug.LogError ("===========   ===========  " + typeName);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="index"></param>
        void PoolCleaning (long index) {
            if (MonoDestoryQueue.Count > 0) {
                GameObject.Destroy (MonoDestoryQueue.Dequeue ());
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="assetEnum"></param>
        /// <param name="initCapacity"></param>
        /// <param name="maxCapacity"></param>
        /// <param name="isUISuite">UI</param>
        /// <param name="useNameSetKey"></param>
        /// <param name="rootTrans">trans  null trans</param>
        /// <param name="autoCreate">  </param>
        public void CreateNewTypePool<T> (
            string assetEnum,
            int initCapacity,
            int maxCapacity,
            bool isUISuite = false,
            bool useNameSetKey = false,
            Callback CreatePoolFinish = null,
            bool autoCreate = true
        ) where T : class {
            //

            currentSinglePoolCount++;

            var tempTrans = new GameObject ();
            if (isUISuite) {
                // tempTrans.transform.SetParent (UIWindowManager.Inst.uiSuiteTran.transform, false);
                tempTrans.AddComponent<RectTransform> ().anchoredPosition = Vector2.one * 5000;
            } else {
                tempTrans.transform.position = new Vector3 (5000, 5000, 0);
            }
            tempTrans.name = assetEnum + "_pool";

            var typeName = useNameSetKey ? assetEnum : typeof (T).Name;

            var pool = new SingleTypeObjPool<IPoolable> (maxCapacity, initCapacity, new PoolNormalFactory (assetEnum, tempTrans.transform), CreatePoolFinish, autoCreate);
            PoolDic.Add (typeName, pool);
            PoolRootTrans.Add (typeName, tempTrans.transform);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public IObservable<T> AllocateMono<T> (string assetsName = "") where T : class, IPoolable {
            return Observable.Create<T> (sever => {
                var typeName = assetsName.Length > 0 ? assetsName : typeof (T).Name;
                if (PoolDic.ContainsKey (typeName)) {
                    var pool = PoolDic[typeName];
                    CompositeDisposable comp = new CompositeDisposable ();
                    pool.AllocateAsyc ()
                        .Subscribe (_ => {
                            var obj = _ as T;
                            sever.OnNext (obj);
                            sever.OnCompleted ();
                            comp.Dispose ();
                        }).AddTo (comp);
                } else {
                    sever.OnCompleted ();
                    Debug.LogError ("===========   ===========  " + typeName);
                }
                return Disposable.Empty;
            });

        }

        public IObservable<MonoBehaviour> AllocateMono (string assetsName) {
            return Observable.Create<MonoBehaviour> (sever => {
                var typeName = assetsName;
                if (PoolDic.ContainsKey (typeName)) {
                    var pool = PoolDic[typeName];
                    CompositeDisposable comp = new CompositeDisposable ();
                    pool.AllocateAsyc ()
                        .Subscribe (_ => {
                            var obj = _ as MonoBehaviour;
                            sever.OnNext (obj);
                            sever.OnCompleted ();
                            comp.Dispose ();
                        }).AddTo (comp);
                } else {
                    sever.OnCompleted ();
                    Debug.LogError ("===========   ===========  " + typeName);
                }
                return Disposable.Empty;
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="Num"></param>
        public IObservable<T> AllocateMono<T> (int Num, string assetsName = "") where T : class, IPoolable {

            return Observable.Create<T> (sever => {
                var typeName = assetsName.Length > 0 ? assetsName : typeof (T).Name;
                if (PoolDic.ContainsKey (typeName)) {
                    var pool = PoolDic[typeName];
                    CompositeDisposable comp = new CompositeDisposable ();
                    int curIndex = 0; //
                    //N 
                    for (int i = 0; i < Num; i++) {
                        pool.AllocateAsyc ()
                            .Subscribe (_ => {
                                var obj = _ as T;
                                sever.OnNext (obj);
                                //
                                curIndex++;
                                if (curIndex >= Num) {
                                    sever.OnCompleted ();
                                    comp.Dispose ();
                                }
                            }).AddTo (comp);
                    }

                } else {
                    sever.OnCompleted ();
                    Debug.LogError ("===========   ===========  " + typeName);
                }
                return Disposable.Empty;
            });

        }

        public IObservable<List<T>> AllocateMonos<T> (int Num, string assetsName = "") where T : class, IPoolable {

            return Observable.Create<List<T>> (sever => {
                var typeName = assetsName.Length > 0 ? assetsName : typeof (T).Name;
                if (PoolDic.ContainsKey (typeName)) {
                    var pool = PoolDic[typeName];
                    CompositeDisposable comp = new CompositeDisposable ();
                    int curIndex = 0; //
                    //N 
                    var objs = new List<T> ();
                    for (int i = 0; i < Num; i++) {
                        pool.AllocateAsyc ()
                            .Subscribe (_ => {
                                var obj = _ as T;
                                objs.Add (obj);
                                //
                                curIndex++;
                                if (curIndex >= Num) {
                                    sever.OnNext (objs);
                                    sever.OnCompleted ();
                                    comp.Dispose ();
                                }
                            }).AddTo (comp);
                    }

                } else {
                    sever.OnCompleted ();
                    Debug.LogError ("===========   ===========  " + typeName);
                }
                return Disposable.Empty;
            });

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="typeName"></param>
        public void RemovePool (string typeName) {
            if (PoolDic.ContainsKey (typeName)) {
                var pool = PoolDic[typeName];
                PoolDic.Remove (typeName);
                PoolRootTrans.Remove (typeName);
                foreach (var item in pool.GetAllObjArray ()) {
                    var isMonoObj = item as MonoBehaviour;
                    if (isMonoObj != null)
                        MonoDestoryQueue.Enqueue (isMonoObj);
                }
                ResMgr.instance.ReleaseAsset (pool.Factory.handle);
            }
        }
    }
}