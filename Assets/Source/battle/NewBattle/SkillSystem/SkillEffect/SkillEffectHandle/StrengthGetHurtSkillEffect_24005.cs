
using System;

namespace Battle
{
    public class StrengthGetHurtSkillEffect_24005 : SkillEffectBase
    {

        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.AddStrengthGetHurt(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
