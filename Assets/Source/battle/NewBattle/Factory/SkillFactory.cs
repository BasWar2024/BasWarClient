
namespace Battle
{
    public class SkillFactory
    {
        public SkillBase CreateSkill(FixVector3 targetPos, SkillModel model)
        {
            SkillBase skill;
            EntityBase originEntity;
            switch ((SkillType)model.type)
            {
                case SkillType.WarShipBuffSkill:
                    skill = new WarShipBuffSkill();
#if _CLIENTLOGIC_
                    skill.EffectSizeEqualRange = true;
#endif
                    break;
                case SkillType.WarShipMissileSkill:
                    skill = new WarShipMissileSkill();
                    break;
                case SkillType.SignalBomb:
                    skill = new SignalBombSkill();
                    break;
                case SkillType.SmokeBomb:
                    skill = new SmokeBombSkill();
                    break;
                default:
                    skill = new SkillBase();
                    break;
            }

            originEntity = null; //entity
            SetAttr(skill, model);
            skill.Init(targetPos, originEntity);
            NewGameData._SkillList.Add(skill);
            return skill;
        }

        public SkillBase CreateHeroSkill()
        {
            HeroSkill skill = new HeroSkill();
            var heroSkillModel = NewGameData._OperHeroSkill;
#if _CLIENTLOGIC_
            skill.EffectSizeEqualRange = true; //BUFF
#endif
            SetAttr(skill, heroSkillModel);
            skill.Init(NewGameData._Hero.Fixv3LogicPosition, NewGameData._Hero);
            NewGameData._SkillList.Add(skill);
            return skill;
        }

        private void SetAttr(SkillBase skill, SkillModel model)
        {
            skill.LifeTime = (Fix64)model.lifeTime / 1000;
            skill.Frequency = (Fix64)model.frequency / 1000;
            skill.AtkRange = (Fix64)model.range / 1000;
            skill.FollowSelf = (Fix64)model.followSelf == Fix64.Zero ? false : true;
            skill.ResPath = model.model;
            skill.EffectResPath = model.effectModel;
            skill.MoveSpeed = (Fix64)model.moveSpeed / 1000;
            skill.BuffModel = model.buffCfgId == 0 ? null : NewGameData._OperBuffDict[model.buffCfgId];
            //skill.ApplyTo = model.ApplyTo;
        }

        private void SetAttr(SkillBase skill, HeroSkillModel model)
        {
            skill.LifeTime = (Fix64)model.lifeTime / 1000;
            skill.Frequency = (Fix64)model.frequency / 1000;
            skill.AtkRange = (Fix64)model.range / 1000;
            skill.FollowSelf = (Fix64)model.followSelf == Fix64.Zero ? false : true;
            skill.ResPath = model.model;
            skill.EffectResPath = model.effectModel;
            skill.MoveSpeed = (Fix64)model.moveSpeed / 1000;
            skill.BuffModel = model.buffCfgId == 0 ? null : NewGameData._OperBuffDict[model.buffCfgId];
            //skill.ApplyTo = model.ApplyTo;
        }
    }
}
