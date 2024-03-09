
namespace Battle
{
    public class SkillOverFsm : FsmState<SkillBase>
    {
        public override void OnInit(SkillBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(SkillBase owner)
        {
            base.OnEnter(owner);

            owner.CanRelease = true;

#if _CLIENTLOGIC_
            if (owner.EffectGameObj != null)
                NewGameData._EffectFactory.ReleaseEffect(owner.EffectGameObj);
#endif
        }

        public override void OnLeave(SkillBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
