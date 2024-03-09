

namespace Battle
{
    using System;
    [Serializable]
    public class HeroModel
    {
        public int cfgId;
        public string model;
        public string icon;
        public int moveSpeed;
        public int maxHp;
        public int atk;
        public int atkSpeed;
        public int atkRange;
        public int radius;
        public int flashMoveDelayTime; // 0 0
        public int bulletCfgId; //BulletModelID
       
    }

}