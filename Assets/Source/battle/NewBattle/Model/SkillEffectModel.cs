
namespace Battle
{
    using System;
    [Serializable]
    public class SkillEffectModel
    {
        public int cfgId;
        //public string targetRelation;
        public int type;
        public string args;
        public int rangeType;
        public int range;
        public int skillEffectCfgId;
        public int buffCfgId;
        public int entityCfgId;
        public int skillCfgId;
    }
}
