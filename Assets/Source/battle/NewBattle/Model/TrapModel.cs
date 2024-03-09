using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    [Serializable]
    public class TrapModel
    {
        public int cfgId;
        public string model;
        public string explosionEffect; //
        public float x;
        public float z;
        public int buffCfgId; //BuffId
        public int alertRange; //
        public int atkRange; //
        public int radius; //
        public int delayExplosionTime; //
    }
}
