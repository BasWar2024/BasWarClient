using System;

namespace GG {
    public interface IManager {
        //
        void Init ();
        //
        IObservable<ExecutionStatus> BroadcastingStation ();
        //
        void CheckNeedClassType (Type type);
        // new
        //new
        T2 CreateInstances<T2> (ClassData cd, params object[] args) where T2 : class;
        //
        ClassData GetClassData (string tagKey);
        ClassData GetClassData<TN> ();
        ClassData GetClassData (Type type);
        void SaveAttribute (string tag, ClassData data);
        //key string  int 
    }
}