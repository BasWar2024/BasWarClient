
namespace Battle
{
    public class HeroFactory
    {
        public SoliderBase CreateHero(SoliderType type, FixVector3 targetPos, HeroModel model)
        {
            LandHero hero = NewGameData._PoolManager.Pop<LandHero>(); //new LandHero();
            //NewGameData._Hero = hero;

            hero.Init();
            hero.IsHero = true;
            hero.Fixv3LogicPosition = targetPos;
            SetAttr(hero, model);
            hero.Start();

            NewGameData._SoldierList.Add(hero);

            return hero;
        }

        private void SetAttr(LandHero solider, HeroModel model)
        {
            solider.Id = model.id;
            solider.CfgId = model.cfgId;
            solider.FixOriginHp = (Fix64)model.maxHp;
            solider.FixHp = solider.FixOriginHp;
            //solider.FixOriginAtk = (Fix64)model.atk / 1000;
            solider.OriginFixAtk = (Fix64)model.atk / 1000;
            //solider.OriginMoveSpeed = (Fix64)model.moveSpeed / 1000;
            solider.OriginMoveSpeed = (Fix64)model.moveSpeed / 1000;
            solider.AtkRange = (Fix64)model.atkRange / 1000;
            //solider.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            solider.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            solider.AtkElpaseTime = solider.OriginAtkSpeed;
            solider.Radius = (Fix64)model.radius / 1000;
            solider.ResPath = model.model;
            solider.FlashMoveDelayTime = (Fix64)model.flashMoveDelayTime / 1000;
            solider.AtkSkillId = model.atkSkillId;
            solider.Center = model.center;
            solider.DeadEffect = model.deadEffect;
            solider.AtkType = model.atkType;
            solider.AtkReadyTime = (Fix64)model.atkReadyTime / 1000;
            solider.AtkSkillShowRadius = (Fix64)model.atkSkillShowRadius / 1000;
            solider.IsDeminer = model.isDeminer;
            solider.IsMedical = model.isMedical;
            solider.InAtkRange = (Fix64)model.inAtkRange / 1000;
            solider.DeadSkillId = model.deadSkillId;
            solider.BornSkillId = model.bornSkillId;
            solider.Race = model.Race;
            solider.ArmyIndex = model.ArmyIndex;
            solider.Quality = model.quality;
            solider.Level = model.level;
        }
    }
}


