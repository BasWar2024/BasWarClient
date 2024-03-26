
namespace Battle
{
    using System;
    using System.Collections.Generic;

    public class FindPathComd //""
    {
        public EntityBase Entity;
        public EntityBase Building;
        public Action<List<ASPoint>> CallBack;
        public FindPathComd(EntityBase entity, EntityBase build, Action<List<ASPoint>> callBack)
        {
            Entity = entity;
            Building = build;
            CallBack = callBack;
        }

        public void Release()
        {
            Entity = null;
            CallBack = null;
        }
    }
}
