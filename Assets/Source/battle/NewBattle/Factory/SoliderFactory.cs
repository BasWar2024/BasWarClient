
namespace Battle
{
    public class SoliderFactory
    {

        //- 
        // 
        // @return .
        public SoliderBase CreateSolider(SoliderType type, FixVector3 targetPos, SoliderModel model)
        {
            SoliderBase solider;
            switch (type)
            {
                case SoliderType.LandSolider:

                    if (model.flashMoveDelayTime == 0)
                        solider = new LandSolider();
                    else
                        solider = new LandFlashSolider();

                    solider.Fixv3LogicPosition = targetPos;
                    SetAttr(solider, model);
                    break;
                //case SoliderType.AirSolider:
                //    solider = new AirSolider();
                //    solider.IsInTheSky = true;
                //    solider.Fixv3LogicPosition = NewGameData.CreateLandShipPos;
                //    solider.TargetPos = targetPos;
                //    solider.OriginPos = NewGameData.CreateLandShipPos;
                //    SetAttr(solider, model);
                //    break;
                case SoliderType.LandingShip:
                    solider = new LandingShip();
                    solider.uuid = model.uuid;
                    solider.TargetPos = targetPos;
                    solider.OriginPos = NewGameData.CreateLandShipPos;
                    solider.IsInTheSky = true;
                    solider.Fixv3LogicPosition = NewGameData.CreateLandShipPos;
                    LandingShip ship = (LandingShip)solider;
                    ship.SoliderModel = model;
                    break;
                //case SoliderType.LandHero:
                //    solider = new LandHero();
                //    solider.Fixv3LogicPosition = targetPos;
                //    SetAttr(solider, model);
                //    break;
                default:
                    solider = new SoliderBase();
                    solider.Fixv3LogicPosition = targetPos;
                    break;
            }

            solider.Init();
            NewGameData._SoldierList.Add(solider);

            return solider;
        }

        public SoliderBase CreateAirSolider(SoliderType type, FixVector3 originPos, FixVector3 targetPos, SoliderModel model)
        {
            AirSolider solider = new AirSolider();
            solider.uuid = model.uuid;
            solider.IsInTheSky = true;
            solider.Fixv3LogicPosition = originPos;
            solider.TargetPos = targetPos;
            solider.OriginPos = originPos;
            SetAttr(solider, model);

            solider.Init();
            NewGameData._SoldierList.Add(solider);

            return solider;
        }

        public SoliderBase CreateSolider(SoliderType type, FixVector3 targetPos, HeroModel model)
        {
            LandingShip ship = new LandingShip();
            ship.TargetPos = targetPos;
            ship.OriginPos = NewGameData.CreateLandShipPos;
            //ship.IsInTheSky = true;
            ship.Fixv3LogicPosition = NewGameData.CreateLandShipPos;
            ship.HeroModel = model;
            ship.Init();
            NewGameData._SoldierList.Add(ship);
            return ship;
        }

        private void SetAttr(SoliderBase solider, SoliderModel model)
        {
            solider.uuid = model.uuid;
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
            //solider.IsAtkAndReturn = model.IsAtkAndReturn;
            solider.FlashMoveDelayTime = (Fix64)model.flashMoveDelayTime / 1000;
            solider.ResPath = model.model;
            solider.BulletId = model.bulletCfgId;
        }
    }
}

