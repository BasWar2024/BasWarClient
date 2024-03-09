
namespace Battle
{

    using System.Collections.Generic;

    public class HeroSkill : SkillBase
    {
        public override void Init(FixVector3 targetPos, EntityBase origin)
        {
            base.Init(targetPos, origin);

            LoadProperties();


#if _CLIENTLOGIC_
            IsLoopEffect = true;
            CreateFromPrefab(ResPath, UpdateSize);
            //if(SizeEqualRange)
            //    CreateFromPrefab(ResPath, UpdateSize);
            //else
            //    CreateFromPrefab(ResPath, LookAtTarget);
#endif

            Fixv3LogicPosition = targetPos;
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

