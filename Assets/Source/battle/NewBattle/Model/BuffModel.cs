


namespace Battle
{
    using SimpleJson;
    using System;
    using System.Collections.Generic;

    [Serializable]
    public class BuffModel
    {
        public int cfgId;
        public string name;
        public string model;
        //public int type;

        public int lifeTime;
        public int frequency;

        public int skillEffectCfgId;
    }
}
