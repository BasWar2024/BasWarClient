
namespace Battle
{
    using System;
    [Serializable]
    public class SoliderModel
    {
        public long id;
        public int cfgId;
        public string model;
        public string icon;
        public int amount;
        public int moveSpeed;
        public int maxHp;
        public int atk;
        public int shield; //""
        public int atkSpeed;
        public int atkRange;
        public int inAtkRange;
        public int radius;
        public int atkSkillId; //""
        public int type; //""，1"" 2"" 3"" 4"" 5"" 
        public FixVector3 center; //""
        public string deadEffect; //""
        public int atkType; //"" 0"" 1"" 2""
        public int atkReadyTime; //""
        public int atkSkillShowRadius; //""
        public int isMedical;
        public int isDeminer;
        public int deadSkillId; //""
        public int bornSkillId; //""
        public int Race; //""
        public int ArmyIndex; //""
    }
}
