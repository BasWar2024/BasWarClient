
namespace Battle
{
    public class HeroFactory
    {
        public SoliderBase CreateHero(SoliderType type, FixVector3 targetPos, HeroModel model)
        {
            LandHero hero = new LandHero();
            NewGameData._Hero = hero;
            hero.Fixv3LogicPosition = targetPos;
            SetAttr(hero, model);

            hero.Init();

            return hero;
        }

        private void SetAttr(LandHero solider, HeroModel model)
        {
            solider.FixOriginHp = (Fix64)model.maxHp;
            solider.FixHp = solider.FixOriginHp;
            solider.FixOriginAtk = (Fix64)model.atk;
            solider.FixAtk = solider.FixOriginAtk;
            solider.OriginMoveSpeed = (Fix64)model.moveSpeed / 1000;
            solider.MoveSpeed = solider.OriginMoveSpeed;
            solider.AtkRange = (Fix64)model.atkRange / 1000;
            solider.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            solider.AtkSpeed = solider.OriginAtkSpeed;
            solider.Radius = (Fix64)model.radius / 1000;
            solider.ResPath = model.model;
            solider.FlashMoveDelayTime = (Fix64)model.flashMoveDelayTime / 1000;
            solider.BulletId = model.bulletCfgId;
        }
    }
}


