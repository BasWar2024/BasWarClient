
namespace Battle
{
    using System;
    [Serializable]
    public class HeroSkillModel
    {
        public int cfgId;
        public string model;
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
        public int type; //1: 
        //public int ApplyTo;
    }

}
