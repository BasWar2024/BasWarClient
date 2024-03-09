
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

namespace Battle {
    public class TrapBase : EntityBase
    {
        public string EffectResPath;
        public Fix64 AlertRange;
        public BuffModel BuffModel;
        public Fix64 DelayTime = Fix64.Zero;

        public new virtual void Init()
        {
            base.Init();

            ObjType = ObjectType.Trap;
            Group = GroupType.EnemyGroup; //

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, null);
#endif
        }
    }
}
