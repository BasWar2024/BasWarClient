using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    internal class MinusAtkSpeedSkillEffect_20003 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.MinusAtkSpeed(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
