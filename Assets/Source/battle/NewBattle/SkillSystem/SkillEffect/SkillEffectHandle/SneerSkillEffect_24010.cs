

using System;
using System.Collections.Generic;

namespace Battle
{
    public class SneerSkillEffect_24010 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.Sneer(Buff, OriginEntity, TargetEntity);
            NewGameData._FightManager.EntityLockEntity(TargetEntity, OriginEntity);

            InhalationMove();
            if (TargetEntity is SoliderBase solider)
            {
                solider.Fsm.ChangeFsmState<EntityAtkFsm>();
            }
            else if (TargetEntity is BuildingBase build)
            {
                build.Fsm.ChangeFsmState<Entity2AtkFsm>();
            }
        }

        private void InhalationMove()
        {
            var build2Entity = TargetEntity.Fixv3LogicPosition - OriginEntity.Fixv3LogicPosition;
            build2Entity.Normalize();

            TargetEntity.Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition + build2Entity * OriginEntity.Radius;
        }

        public override void Leave()
        {
            if (TargetEntity != null)
            {
                TargetEntity.Fsm.ChangeFsmState<EntityIdleFsm>();
            }
            base.Leave();
        }
    }
}
