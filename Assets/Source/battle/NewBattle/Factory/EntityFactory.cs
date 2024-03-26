



using System;

namespace Battle
{
    public class EntityFactory
    {
        //""entity，""entity
        public T CreateEntity<T>(string path, FixVector3 startPos, bool isAutoCreatePrefab = true, Action callBack = null) where T : EntityBase 
        {
            T entity = NewGameData._PoolManager.Pop<T>();

#if _CLIENTLOGIC_
            if(isAutoCreatePrefab)
                entity.CreateFromPrefab(path, callBack);
#endif

            entity.Init();
            //entity.CanRelease = true;
            entity.ResPath = path;
            entity.OriginPos = startPos;
            entity.Fixv3LogicPosition = startPos;
            if (isAutoCreatePrefab)
                entity.Start();

            NewGameData._EntityList.Add(entity);
            return entity;
        }
    }
}
