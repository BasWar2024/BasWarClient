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
    }
}
