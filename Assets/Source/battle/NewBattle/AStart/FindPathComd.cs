
namespace Battle
{
    using System;
    using System.Collections.Generic;

    public class FindPathComd //
    {
        public EntityBase Entity;
        public FindPathType FindPathType;
        public Action<List<ASPoint>> CallBack;
        public FindPathComd(EntityBase entity, FindPathType findPathType, Action<List<ASPoint>> callBack)
        {
            Entity = entity;
            FindPathType = findPathType;
            CallBack = callBack;
        }

        public void Release()
        {
            Entity = null;
            CallBack = null;
        }
    }
}
