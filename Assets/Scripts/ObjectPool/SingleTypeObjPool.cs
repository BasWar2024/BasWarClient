using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;
using UnityEngine.ResourceManagement.AsyncOperations;

namespace GG {

    public interface IPoolService {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="assetString"></param>
        /// <param name="maxCapacity"></param>
        /// <typeparam name="T"></typeparam>
        void CreateNewTypePool<T> (string assetString, int initCapacity, int maxCapacity, bool isUISuite = false, bool useNameSetKey = false, Callback CreatePoolFinish = null, bool autoCreate = true) where T : class;
        // void CreateNewTypePool<T> (int maxCapacity, int cleanUpInterval) where T : class;
        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        IObservable<T> AllocateMono<T> (string assetsName = "") where T : class, IPoolable;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="obj"></param>
        /// <typeparam name="T"></typeparam>
        void RecycleMono<T> (T obj, string poolName = "") where T : IPoolable;
    }
    //ObjectPoolService 
    public interface IPool<T> {
        IObservable<T> AllocateAsyc ();
        bool Recycle (T obj);
        int CurCount { get; }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IObjectFactory<T> { //Spwan
        void Create (Callback<T> finish);
        void CreateArray (int InstanceCount, Callback<T[]> finish);
        AsyncOperationHandle handle { get; set; }
    }

    public abstract class Pool<T> : IPool<T> {
        /// <summary>
        /// 
        /// </summary>
        /// <value></value>
        public int CurCount {
            get { return mCacheStack.Count; }
        }

        public IObjectFactory<T> Factory { get => mFactory; }
        protected IObjectFactory<T> mFactory;
        protected Stack<T> mCacheStack = new Stack<T> ();
        protected int mMaxCapacity = 5;

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public T[] GetAllObjArray () {
            return mCacheStack.ToArray ();
        }
        public abstract bool Recycle (T obj);

        public virtual IObservable<T> AllocateAsyc () {
            return null;
        }
    }
    /// <summary>
    /// pool
    /// </summary>
    public interface IPoolable {
        /// <summary>
        /// 
        /// </summary>
        void OnActive ();
        /// <summary>
        ///  / 
        /// </summary>
        void OnRelease ();
        /// <summary>
        /// 
        /// </summary>
        void OnRecycled ();
        bool IsInPool { get; set; }
    }
    public class SingleTypeObjPool<T> : Pool<T> where T : IPoolable {

        /// <summary>
        /// 
        /// </summary>
        /// <param name="maxCount"></param>
        /// <param name="initCount"></param>
        /// <param name="customFactory"></param>
        /// <param name="Create"></param>
        public SingleTypeObjPool (int maxCount, int initCount, IObjectFactory<T> customFactory, Callback CreatePoolFinish, bool autoCreate = true) {

            mFactory = customFactory;
            if (maxCount > 0) {
                initCount = Math.Min (maxCount, initCount);

                mMaxCapacity = maxCount;
            }

            //
            if (autoCreate) {
                int finishCount = 0;
                if (CurCount < initCount) {
                    for (int i = CurCount; i < initCount; ++i) {
                        // Recycle (mFactory.Create ());
                        mFactory.Create (resObj => {
                            Recycle (resObj);
                            finishCount++;
                            if (finishCount >= initCount) {
                                if (CreatePoolFinish != null) CreatePoolFinish ();
                            }
                        });
                    }
                }
            } else {
                if (CreatePoolFinish != null) CreatePoolFinish ();
            }
        }
        /// <summary>
        /// 
        ///  
        /// </summary>
        /// <value></value>
        public int MaxCacheCount {
            get { return mMaxCapacity; }
            set {
                mMaxCapacity = value;

                if (mCacheStack != null) {
                    if (mMaxCapacity > 0) {
                        if (mMaxCapacity < mCacheStack.Count) {
                            int removeCount = mMaxCapacity - mCacheStack.Count;
                            while (removeCount > 0) {
                                mCacheStack.Pop ().OnRelease ();
                                --removeCount;
                            }
                        }
                    }
                }
            }
        }
        /// <summary>
        ///  
        /// </summary>
        /// <returns></returns>
        public override IObservable<T> AllocateAsyc () {
            return Observable.Create<T> (server => {
                if (mCacheStack.Count == 0) {
                    mFactory.Create (_ => {
                        server.OnNext (_);
                        _.IsInPool = false;
                        _.OnActive ();
                        server.OnCompleted ();
                    });
                } else {
                    var temp = mCacheStack.Pop ();
                    server.OnNext (temp);
                    temp.IsInPool = false;
                    temp.OnActive ();
                    server.OnCompleted ();
                }

                return Disposable.Empty;
            });

        }
        /// <summary>
        ///  
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        public override bool Recycle (T t) {
            if (t == null || t.IsInPool) {
                return false;
            }

            if (mMaxCapacity > 0) {
                if (mCacheStack.Count >= mMaxCapacity) {
                    t.OnRelease ();
                    return false;
                }
            }
            t.IsInPool = true;
            t.OnRecycled ();
            mCacheStack.Push (t);
            return true;
        }

    }

}