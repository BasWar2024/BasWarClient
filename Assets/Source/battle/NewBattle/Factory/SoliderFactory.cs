
namespace Battle
{
    public class SoliderFactory
    {

        //- ""
        // 
        // @return "".
        public SoliderBase CreateSolider(SoliderType type, FixVector3 targetPos, SoliderModel model)
        {
            SoliderBase solider;
            switch (type)
            {
                case SoliderType.LandSolider:
                    solider = NewGameData._PoolManager.Pop<LandSolider>();
                    break;
                //case SoliderType.LandingShip:
                //    solider = NewGameData._PoolManager.Pop<LandingShip>();
                //    break;
                case SoliderType.Tank:
                    solider = NewGameData._PoolManager.Pop<Tank>();
                    break;
                case SoliderType.Arsenal:
                    solider = NewGameData._PoolManager.Pop<Arsenal>();
                    break;
                case SoliderType.LandSolider16Dir:
                    solider = NewGameData._PoolManager.Pop<LandSolider16Dir>();
                    break;
                default:
                    solider = NewGameData._PoolManager.Pop<SoliderBase>();
                    break;
            }

            solider.Init();
            solider.IsHero = false;
            solider.Fixv3LogicPosition = targetPos;
            SetAttr(solider, model);
            solider.Start();
            NewGameData._SoldierList.Add(solider);

            return solider;
        }

        public SoliderBase CreateAirSolider(SoliderType type, FixVector3 originPos, FixVector3 targetPos, SoliderModel model)
        {
            SoliderBase solider;
            switch (type)
            {
                case SoliderType.BomberAirSolider:
                    solider = NewGameData._PoolManager.Pop<BomberAirSolider>();
                    break;
                case SoliderType.SuicideAirSolider:  //"" ""
                    solider = NewGameData._PoolManager.Pop<SuicideAirSolider>();
                    break;
                case SoliderType.CarrierAircraft:
                    solider = NewGameData._PoolManager.Pop<CarrierAircraftSolider>();
                    break;
                case SoliderType.SuicideMonAirSolider:
                    solider = NewGameData._PoolManager.Pop<SuicideMonAirSolider>();
                    break;
                case SoliderType.AirSolider:
                    solider = NewGameData._PoolManager.Pop<AirSolider>();
                    break;
                case SoliderType.SuicideChildAirSolider:
                    solider = NewGameData._PoolManager.Pop<SuicideChildAirSolider>();
                    break;
                default:
                    solider = NewGameData._PoolManager.Pop<SoliderBase>();
                    break;
            }

            solider.Init();
            solider.IsHero = false;
            solider.Fixv3LogicPosition = originPos;
            solider.TargetPos = targetPos;
            solider.OriginPos = originPos;
            SetAttr(solider, model);
            solider.Start();
            NewGameData._SoldierList.Add(solider);

            return solider;
        }

        private void SetAttr(SoliderBase solider, SoliderModel model)
        {
            solider.CfgId = model.cfgId;
            solider.Id = model.id;
            solider.FixOriginHp = (Fix64)model.maxHp;
            solider.FixHp = solider.FixOriginHp;
            solider.OriginFixAtk = (Fix64)model.atk / 1000;
            solider.OriginMoveSpeed = (Fix64)model.moveSpeed / 1000;
            solider.AtkRange = (Fix64)model.atkRange / 1000;
            solider.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            solider.AtkElpaseTime = solider.OriginAtkSpeed;
            solider.Radius = (Fix64)model.radius / 1000;
            solider.ResPath = model.model;
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
        }

        private FixVector3 CorrectLandingDir(FixVector3 targetPos)
        {
            if (targetPos.x <= (Fix64)6 && targetPos.z >= (Fix64)6)
            {
                return NewGameData._FixRight;
            }
            else if (targetPos.x >= (Fix64)52 && targetPos.z >= (Fix64)6)
            {
                return NewGameData._FixRight * -Fix64.One;
            }
            else if (targetPos.x >= (Fix64)6 && targetPos.z <= (Fix64)6)
            {
                return NewGameData._FixForword;
            }
            else
            {
                return NewGameData._FixForword * -Fix64.One;
            }
        }
    }
}

