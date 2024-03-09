

namespace Battle
{
    public class BuffFactory
    {

        public BuffBase CreateBuff(SkillBase originSkill, EntityBase target)
        {
            var model = originSkill.BuffModel;

            if (model == null)
                return null;

            Buff buff = new Buff();
            SetAttr(buff, model);
            buff.Init(originSkill, target);
            NewGameData._BuffList.Add(buff);
            return buff;
        }

        public BuffBase CreateBuff(BuffModel model, EntityBase target)
        {
            if (model == null)
                return null;

            Buff buff = new Buff();
            SetAttr(buff, model);
            buff.Init(null, target);
            NewGameData._BuffList.Add(buff);
            return buff;
        }

        private void SetAttr(Buff buff, BuffModel model)
        {
            //buff.SId = NewGameData._SId;
            buff.ResPath = model.model;
            //buff.EffectResPath = model.;
            buff.Hurt = (Fix64)model.atk;
            buff.Cure = (Fix64)model.cure;
            buff.AddAtk = (Fix64)model.addAtk / 1000;
            buff.AddAtkSpeed = (Fix64)model.addAtkSpeed / 1000;
            buff.AddMoveSpeed = (Fix64)model.addMoveSpeed / 1000;
            buff.StopAction = (Fix64)model.stopAction;
            buff.LifeTime = (Fix64)model.lifeTime / 1000;
            buff.Frequency = (Fix64)model.frequency / 1000;
            buff.LifeType = model.lifeType;
        }
    }
}
