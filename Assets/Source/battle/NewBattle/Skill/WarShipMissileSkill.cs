

namespace Battle
{
    using System.Collections.Generic;
    public class WarShipMissileSkill : SkillBase
    {
        public override void Init(FixVector3 targetPos, EntityBase origin)
        {
            base.Init(targetPos, origin);

            LoadProperties();

            ApplyTo = 1;

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, LookAtTarget);
#endif
            AffectEntity = new Dictionary<EntityBase, bool>();
            Fsm = new FsmCompent<SkillBase>();
            Fsm.CreateFsm(this, new SkillMoveStraightFsm(), new SkillCommonDoGroupFsm(), new SkillOverFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}

