

using System.Collections.Generic;

namespace Battle
{
    public struct PassiveSkillAttr
    {
        public int Range;
        public int Race;
        public Attr AttrType;
        public Fix64 Value;
        public int ArmyIndex;

        public void Init(int range, int race, Attr attrType, Fix64 value, int index)
        {
            Range = range;
            Race = race;
            AttrType = attrType;
            Value = value;
            ArmyIndex = index;
        }
    }

    //""。
    //""1""2""3""4
    public class PassiveSkillAttrSkillEffect_25003 : SkillEffectBase
    {
        private Fix64 m_ArmyIndex;
        public override void Init(SkillEffectModel model, EntityBase originEntity, EntityBase targetEntity, Buff buff, params Fix64[] args)
        {
            base.Init(model, originEntity, targetEntity, buff, args);

            m_ArmyIndex = args[0];
        }

        public override void Start()
        {
            base.Start();

            int range = (int)Args[0];
            int race = (int)Args[1];
            Attr attrType = (Attr)(int)Args[2];
            Fix64 value = Args[3] / 10000;

            PassiveSkillAttr attr = new PassiveSkillAttr();
            attr.Init(range, race, attrType, value, (int)m_ArmyIndex);

            NewGameData._PassiveSkillList.Add(attr);
        }
    }
}
