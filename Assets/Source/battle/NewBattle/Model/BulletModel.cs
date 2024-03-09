
namespace Battle
{
    using System;
    [Serializable]
    public class BulletModel
    {
        public int cfgId;
        public string model;
        public string explosionEffect;
        public int type; // 1: 2 3AOE 4AOE
        public int moveSpeed;
        public int atkRange;
    }

}
