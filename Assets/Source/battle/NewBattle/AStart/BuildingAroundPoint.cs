

namespace Battle
{
    //
    public class BuildingAroundPoint
    { 
        public FixVector3 FixV3;
        public bool Use = false;
        //public Fix64 Cos = Fix64.Zero;

        public BuildingAroundPoint(FixVector3 fixV3, bool use)
        {
            FixV3 = fixV3;
            Use = use;
        }
    }
}
