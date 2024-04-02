
using System;
using System.Collections.Generic;

namespace Battle
{
    [Serializable]
    public class InitBattleModel
    {
        public List<BuildingModel> builds;
        public List<TrapModel> traps;
        public List<SoliderModel> soliders;
        public List<HeroModel> heros;
        public MainShipModel mainShip;
        public List<SkillModel> skills;
        public List<SkillModel> heroSkills;
        //public List<BulletModel> bullets;
        public List<BuffModel> buffs;
        public List<SoliderModel> summonSoliders;
        public List<SkillEffectModel> skillEffects;
        public MapModel map;
        
        public void Release()
        {
            builds?.Clear();
            soliders?.Clear();
            skills?.Clear();
            //bullets?.Clear();
            buffs?.Clear();
            traps?.Clear();
            //summonSoliders?.Clear();
            skillEffects?.Clear();
            heros?.Clear();
            heroSkills?.Clear();
            //hero = null;
            mainShip = null;
            builds = null;
            soliders = null;
            skills = null;
            //heroSkill = null;
            heroSkills = null;
            //bullets = null;
            buffs = null;
            traps = null;
            //summonSoliders = null;
            skillEffects = null;
            map = null;
        }
    }
}
