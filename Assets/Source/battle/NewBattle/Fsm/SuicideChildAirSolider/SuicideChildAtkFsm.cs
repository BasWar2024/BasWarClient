
namespace Battle
{
    public class SuicideChildAtkFsm : FsmState<EntityBase>
    {
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            var model = NewGameData._SkillModelDict[owner.AtkSkillId];

            NewGameData._SkillFactory.CreateSkill(owner.Fixv3LogicPosition, owner.Fixv3LogicPosition, owner, owner.LockedAttackEntity, model);

            NewGameData._FightManager.Attack((Fix64)9999999, null, owner);
        }
    }
}
