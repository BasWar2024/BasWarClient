

namespace Battle
{
    public class BuildingFactory
    {
        //- ""
        // 
        // @return "".
        public BuildingBase CreateBuilding(BuildingModel model)
        {
            BuildingBase building;
            switch ((BuildingType)model.type)
            {
                case BuildingType.DefenseTower:
                    building = NewGameData._PoolManager.Pop<DefenseTower>();
                    break;
                case BuildingType.NorEconomy:
                    building = NewGameData._PoolManager.Pop<NormalBuilding>(); 
                    break;
                case BuildingType.NorDevelop:
                    building = NewGameData._PoolManager.Pop<NormalBuilding>(); 
                    break;
                case BuildingType.Mineral:
                    building = NewGameData._PoolManager.Pop<MineralBuilding>();
                    break;
                default:
                    building = NewGameData._PoolManager.Pop<BuildingBase>(); 
                    break;
            }

            building.Init();
            building.Id = model.id;
            building.CfgId = model.cfgId;
            building.EffectResPath = model.explosionEffect;
            building.DeadResPath = model.wreckageModel;
            building.Fixv3LogicPosition = new FixVector3((Fix64)model.x, (Fix64)0, (Fix64)model.z);
            building.AtkRange = (Fix64)model.atkRange / 1000;
            //building.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            building.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            building.AtkElpaseTime = building.OriginAtkSpeed;
            building.Type = (BuildingType)model.type;
            building.SubType = (BuildingSubType)model.subType;
            //building.FixOriginAtk = (building.Type == BuildingType.NorEconomy || building.Type == BuildingType.NorDevelop) ? Fix64.Zero : (Fix64)model.atk / 1000;
            building.OriginFixAtk = (building.Type == BuildingType.NorEconomy || building.Type == BuildingType.NorDevelop) ? Fix64.Zero : (Fix64)model.atk / 1000;
            building.FixOriginHp = (Fix64)model.maxHp;
            building.FixHp = (Fix64)model.hp;
            building.AtkSkillId = model.atkSkillId;
            building.ResPath = model.model;
            building.Radius = (Fix64)model.radius / 1000;
            building.AtkAir = (AtkAir)model.atkAir;
            building.IsMain = model.isMain == 0 ? false : true;
            building.Center = model.center;
            building.IsConstruct = model.isConstruct == 0 ? false : true;
            building.Direction = model.direction; //""
            building.AtkType = model.atkType;
            building.AtkReadyTime = (Fix64)model.atkReadyTime / 1000;
            building.AtkSkillShowRadius = (Fix64)model.atkSkillShowRadius / 1000;
            building.InAtkRange = (Fix64)model.inAtkRange / 1000;
            building.Floor = model.floor;
            building.DeadSkillId = model.deadSkillId;
            building.BornSkillId = model.bornSkillId;
            building.Race = model.Race;
            building.AtkSkill1Id = model.atkSkill1Id;
            building.FirstAtk = model.firstAtk;
            building.IntArgs1 = model.intArgs1;
            building.IntArgs2 = model.intArgs2;
            building.IntArgs3 = model.intArgs3;
            building.Level = model.Level;
            building.Start();

            if (building.Type == BuildingType.Mineral)
                NewGameData._MineralBuildingList.Add(building);
            else
                NewGameData._BuildingList.Add(building);

            return building;
        }
    }
}

