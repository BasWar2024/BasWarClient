using System;
using System.Collections.Generic;
using UniRx;

namespace GG {
    /// <summary>
    /// 
    /// StringTag  key
    /// </summary>
    public class ManagerAttribute : Attribute {
        public string StringTag { get; private set; } = null;
        public ManagerAttribute (string tag) {
            this.StringTag = tag;
        }

    }
    // -> 
    public class ClassData {
        public ManagerAttribute Attribute;
        public Type Type;
    }
    public class ExecutionStatus {
        public Type _type;
        public bool _hasFinish;
        public string _strTag;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <typeparam name="V"> </typeparam>
    public class ManagerBase<T, V> : IManager where T : IManager, new () where V : ManagerAttribute {
        #region ------------------------------
        static T _inst;
        public static T Inst {
            get {
                if (_inst == null) {
                    _inst = new T ();
                }
                return _inst;
            }
        }
        public static T getInstance () {
            if (_inst == null) {
                _inst = new T ();
            }
            return _inst;
        }
        #endregion
        // public ReadOnlyReactiveProperty<bool> 
        #region --------------------------
        Dictionary<string, ClassData> ClassDataMap_StringKey { get; set; }
        protected ManagerBase () {
            ClassDataMap_StringKey = new Dictionary<string, ClassData> ();
        }
        #endregion
        #region --------------------------------
        /// <summary>
        /// tag class
        /// </summary>
        /// <param name="tag"></param>
        /// <returns></returns>
        public ClassData GetClassData (string tag) {
            ClassData classData = null;
            this.ClassDataMap_StringKey.TryGetValue (tag, out classData);
            return classData;
        }

        /// <summary>
        /// class
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public ClassData GetClassData<TN> () {
            return GetClassData (typeof (TN));
        }

        /// <summary>
        /// class
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public ClassData GetClassData (Type type) {
            var classDatas = GetAllClassDatas ();
            foreach (var value in classDatas) {
                if (value.Type == type) {
                    return value;
                }
            }
            return null;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public int GetClassDataCount () {
            return ClassDataMap_StringKey.Count;
        }
        /// <summary>
        /// ClassData
        /// </summary>
        /// <returns></returns>
        protected IEnumerable<ClassData> GetAllClassDatas () {
            IEnumerable<ClassData> classDatas = new List<ClassData> ();
            if (this.ClassDataMap_StringKey.Count > 0) {
                classDatas = this.ClassDataMap_StringKey.Values;
            }
            return classDatas;
        }
        #endregion
        #region --------------  ------------------

        Type vtype = null; //
        /// <summary>
        /// 
        /// </summary>
        /// <param name="targetType"></param>
        virtual public void CheckNeedClassType (Type targetType) {
            if (vtype == null) {
                vtype = typeof (V);
            }
            //
            //
            if (targetType.IsDefined (vtype, false)) {
                var attrs = targetType.GetCustomAttributes (vtype, false);
                if (attrs.Length > 0) {
                    var attr = attrs[0];
                    if (attr is V) {
                        var _attr = (V) attr;
                        if (_attr.StringTag != null) {
                            //
                            SaveAttribute (_attr.StringTag, new ClassData () { Attribute = _attr, Type = targetType });
                        }
                    }
                }
            }
        }

        /// <summary>
        ///   new
        /// </summary>
        /// <param name="tag"></param>
        /// <param name="args"></param>
        /// <typeparam name="T2"></typeparam>
        /// <returns></returns>
        public T2 CreateInstances<T2> (ClassData cd, params object[] args) where T2 : class {
            if (cd.Type != null) {
                if (args.Length == 0) {
                    return Activator.CreateInstance (cd.Type) as T2;
                } else {
                    return Activator.CreateInstance (cd.Type, args) as T2;
                }
            } else {
                return null;
            }
        }
        /// <summary>
        ///   new
        /// </summary>
        /// <param name="tag"></param>
        /// <param name="args"></param>
        /// <typeparam name="T2"></typeparam>
        /// <returns></returns>
        public T2 CreateInstances<T2> (string tag, params object[] args) where T2 : class {
            var cd = GetClassData (tag);
            if (cd == null) {
                UnityEngine.Debug.LogError (":" + tag + " -" + typeof (T2).Name);
                return null;
            }
            return CreateInstances<T2> (cd, args);
        }
        #endregion

        virtual public void Init () { }
        virtual public IObservable<ExecutionStatus> BroadcastingStation () {
            return Observable.Create<ExecutionStatus> (subscribe => { subscribe.OnCompleted (); return Disposable.Empty; });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="type"></param>
        /// <param name="hasFinish"></param>
        /// <returns></returns>
        public virtual ExecutionStatus CreateExecutionStatus (Type type, bool hasFinish, string tag = "") {
            return new ExecutionStatus { _type = type, _hasFinish = hasFinish, _strTag = tag };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tag"></param>
        /// <param name="data"></param>
        public void SaveAttribute (string tag, ClassData data) {
            this.ClassDataMap_StringKey[tag] = data;
        }
    }
}