
namespace Battle
{
    public class SignalBombSkill : SkillBase
    {
        public override void Init(FixVector3 targetPos, EntityBase origin)
        {
            base.Init(targetPos, origin);

            LoadProperties();

#if _CLIENTLOGIC_
            IsLoopEffect = true;
            CreateFromPrefab(ResPath, null);
            //if(SizeEqualRange)
            //    CreateFromPrefab(ResPath, UpdateSize);
            //else
            //    CreateFromPrefab(ResPath, LookAtTarget);
#endif

            Fsm = new FsmCompent<SkillBase>();
            Fsm.CreateFsm(this, new SkillMoveStraightFsm(), new SkillSignalBoobFsm(), new SkillOverFsm());
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Fsm.OnUpdate(this);
        }
    }
}
