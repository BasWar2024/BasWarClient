
using System;
using System.Collections.Generic;

namespace Battle
{
    [Serializable]
    public class InitBattleModel
    {
        public List<BuildingModel> BuildingList;
        public List<TrapModel> TrapList;
        public List<SoliderModel> SoliderList;
        public HeroModel Hero;
        public MainShipModel MainShip;
        public List<SkillModel> SkillList;
        public HeroSkillModel HeroSkill;
        public List<BulletModel> BulletList;
        public List<BuffModel> BuffList;

        public void Release()
        {
            BuildingList?.Clear();
            SoliderList?.Clear();
            SkillList?.Clear();
            BulletList?.Clear();
            BuffList?.Clear();
            TrapList?.Clear();
            Hero = null;
            MainShip = null;
            BuildingList = null;
            SoliderList = null;
            SkillList = null;
            HeroSkill = null;
            BulletList = null;
            BuffList = null;
            TrapList = null;
        }
    }
}
