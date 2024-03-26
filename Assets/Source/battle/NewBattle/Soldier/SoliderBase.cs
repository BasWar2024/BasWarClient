

namespace Battle
{
    using System.Collections.Generic;

    public class SoliderBase : EntityBase, IFightingUnits
    {
        public OperOrder OperOrder;
        public int IsMedical;
        public int IsDeminer;

        public override void Init()
        {
            base.Init();

            ObjType = ObjectType.Soldier;
            Group = GroupType.PlayerGroup; //""
            OperOrder = OperOrder.None;
        }
    }
}

