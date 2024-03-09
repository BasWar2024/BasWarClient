

namespace Battle
{
    public class BuildingBase : EntityBase, IFightingUnits
    {
        public bool IsMain = false;
        public string EffectResPath;
        public string DeadResPath;
        public BuildingType Type; //1--,2--,3--,4--,8--

        public new virtual void Init()
        {
            base.Init();

            ObjType = ObjectType.Tower;
            Group = GroupType.EnemyGroup; //

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, null);
#endif
        }
    }

}