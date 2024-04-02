
namespace Battle
{
    using System;
    [Serializable]
    public class BuildingModel
    {
        public long id;
        public int cfgId;
        public string model;
        public string explosionEffect;
        public string wreckageModel;
        public float x;
        public float z;
        public int maxHp;
        public int hp; //""
        public int atk;
        public int atkSpeed;
        public int atkRange;
        public int inAtkRange;
        public int radius;
        public int atkAir;
        public int atkSkillId;
        public int isMain;
        public int type; //1--"",2--"",3--"",4--"",8--""
        public int subType; //""(0--"",1--"",2--"",3--"")
        public FixVector3 center; //""
        public int isConstruct; //"" 1"" 0""
        public int direction; //"" 1""30""
        public int atkType; //"" 0"" 1"" 2""
        public int atkReadyTime; //""
        public int atkSkillShowRadius; //""
        public string floor; //""
        public int deadSkillId; //""
        public int bornSkillId; //""
        public int Race; //""
        public int atkSkill1Id; //""1
        public int firstAtk; //"" 0""，1""，2""
        public int intArgs1;
        public int intArgs2;
        public int intArgs3;
        public int Level;
    }
}

