

namespace Battle
{
    using System;
    using System.Collections.Generic;
    public class SoliderBase : EntityBase, IFightingUnits
    {
        public int IsAtkAndReturn = 0;
        public Int64 uuid = 0; 

        public new virtual void Init()
        {
            base.Init();

            ObjType = ObjectType.Soldier;
            Group = GroupType.PlayerGroup; //

            ListMovePath = new List<ASPoint>();
        }
    }
}

