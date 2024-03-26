
using System;

namespace Battle
{
    public class StrengthenAtkSkillEfect_24004 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.AddStrengthAtk(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
