

namespace Battle
{
    using System;
    [Serializable]
    public class HeroModel
    {
        public long id;
        public int cfgId;
        public string model;
        public string icon;
        public int moveSpeed;
        public int maxHp;
        public int atk;
        public int shield; //""
        public int atkSpeed;
        public int atkRange;
        public int inAtkRange;
        public int radius;
        public int flashMoveDelayTime; //""，"" 0：""； ""0：""；
        public int atkSkillId; 
        public FixVector3 center; //""
        public string deadEffect; //""
        public int atkType; //"" 0"" 1"" 2""
        public int atkReadyTime; //""
        public int level;
        public int atkSkillShowRadius; //""
        public int isMedical;
        public int isDeminer;
        public int deadSkillId; //""
        public int bornSkillId; //""
        public int Race; //""
        public int ArmyIndex; //""
        public long skill1;
        public long skill2;
        public long skill3;
        public int quality;
    }
}