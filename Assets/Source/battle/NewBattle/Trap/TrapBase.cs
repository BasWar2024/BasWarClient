
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

namespace Battle {
    public class TrapBase : EntityBase
    {
        public string EffectResPath;
        public Fix64 AlertRange;
        //public BuffModel BuffModel;
        public int BuffId;
        public Fix64 DelayTime;

        public override void Init()
        {
            base.Init();

            AlertRange = Fix64.Zero;
            DelayTime = Fix64.Zero;
            ObjType = ObjectType.Trap;
            Group = GroupType.EnemyGroup; //""
        }

        public override void Start()
        {
            base.Start();

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, null);
#endif
        }

        public override void Release()
        {
            base.Release();
            EffectResPath = null;
            //BuffModel = null;

        }
    }
}
