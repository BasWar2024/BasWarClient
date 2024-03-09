
namespace Battle
{
    using System;
    [Serializable]
    public class BuildingModel
    {
        public int cfgId;
        public string model;
        public string explosionEffect;
        public string wreckageModel;
        public float x;
        public float z;
        public int maxHp;
        public int atk;
        public int atkSpeed;
        public int atkRange;
        public int radius;
        public int atkAir;
        public int bulletCfgId;
        public int isMain;
        public int type; //1--,2--,3--,4--,8--      ---0 1: 2:
    }
}

