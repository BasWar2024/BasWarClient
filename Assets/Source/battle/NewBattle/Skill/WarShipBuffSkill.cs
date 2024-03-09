
namespace Battle
{
    using System.Collections.Generic;

    public class WarShipBuffSkill : SkillBase
    {
        public override void Init(FixVector3 targetPos, EntityBase origin)
        {
            base.Init(targetPos, origin);

            LoadProperties();

            ApplyTo = 0;

#if _CLIENTLOGIC_
            IsLoopEffect = true;
            CreateFromPrefab(ResPath, null);
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

