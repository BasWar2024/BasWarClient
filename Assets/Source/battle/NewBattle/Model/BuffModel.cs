


namespace Battle
{
    using System;
    [Serializable]
    public class BuffModel
    {
        public int cfgId;
        public string model; //Buff
        //public string EffectResPath; //Buff
        public int atk; //
        public int cure; //
        public int addAtk; //,
        public int addAtkSpeed; //,
        public int addMoveSpeed; //,
        public int stopAction; //0 1
        public int lifeTime; //(0 -1  -)
        public int frequency; // (-1)
        public int lifeType; // 0: 1
    }
}
