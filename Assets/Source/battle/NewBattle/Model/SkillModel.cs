
namespace Battle
{
    using System;
    [Serializable]
    public class SkillModel
    {
        public int cfgId;
        public string model; //
        public string icon;
        public string effectModel; //buff
        public int buffCfgId; //0BUFF
        public int moveSpeed; //
        public int lifeTime; //
        public int frequency; //
        public int range; // 0 0
        public int originCost; //
        public int addCost; //
        public int followSelf; // 0 1
        public int type; //2 3.BUFF 4: 5:1model
        //public int ApplyTo; //0 1
    }
}
