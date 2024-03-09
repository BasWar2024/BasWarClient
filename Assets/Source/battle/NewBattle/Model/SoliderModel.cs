
namespace Battle
{
    using System;
    [Serializable]
    public class SoliderModel
    {
        public int cfgId;
        public Int64 uuid;
        public string model;
        public string icon;
        public int amount;
        public int moveSpeed;
        public int maxHp;
        public int atk;
        public int atkSpeed;
        public int atkRange;
        public int radius;
        public int originCost;
        public int addCost;
        public int bulletCfgId; //BulletModelID ,0
        //public int IsAtkAndReturn; // 0 1
        public int flashMoveDelayTime; // 0 0
        public int type; //1 2 3
    }
}
