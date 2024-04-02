using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class EntityManager
    {
        public void BeKill(EntityBase entity)
        {
            entity.BKilled = true;
            NewGameData._DeadList.Add(entity);
        }

        public void BeKill(SkillBase skill)
        {
            skill.BKilled = true;
            NewGameData._SkillDeadList.Add(skill);
        }

        //public void BeKill(Effect effect)
        //{
        //    effect.BKilled = true;
        //    NewGameData._EffectDeadList.Add(effect);
        //}
    }
}
