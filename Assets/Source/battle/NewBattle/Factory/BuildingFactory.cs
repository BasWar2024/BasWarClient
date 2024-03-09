

namespace Battle
{
#if _CLIENTLOGIC_
    using System.Collections.Generic;
    using UnityEngine;
#endif

    public class BuildingFactory
    {
        //- 
        // 
        // @return .
        public BuildingBase CreateBuilding(BuildingModel model)
        {
            BuildingBase building;
            switch ((BuildingType)model.type)
            {
                case BuildingType.DefenseTower:
                    building = new DefenseTower();
                    break;
                case BuildingType.NorEconomy:
                    building = new NormalBuilding();
                    break;
                case BuildingType.NorDevelop:
                    building = new NormalBuilding();
                    break;
                //case BuildingType.Trap:
                //    building = new Trap();
                //    break;
                default:
                    building = new BuildingBase();
                    break;
            }

            building.EffectResPath = model.explosionEffect;
            building.DeadResPath = model.wreckageModel;
            building.Fixv3LogicPosition = new FixVector3((Fix64)model.x, (Fix64)0, (Fix64)model.z);
            building.AtkRange = (Fix64)model.atkRange / 1000;
            building.OriginAtkSpeed = (Fix64)model.atkSpeed / 1000;
            building.AtkSpeed = building.OriginAtkSpeed;
            building.Type = (BuildingType)model.type;
            building.FixOriginAtk = (building.Type == BuildingType.NorEconomy || building.Type == BuildingType.NorDevelop) ? Fix64.Zero : (Fix64)model.atk;
            building.FixAtk = building.FixOriginAtk;
            building.FixOriginHp = (Fix64)model.maxHp;
            building.FixHp = building.FixOriginHp;
            building.BulletId = model.bulletCfgId;
            building.ResPath = model.model;
            building.Radius = (Fix64)model.radius / 1000;
            building.AtkType = (AtkType)model.atkAir;
            building.IsMain = model.isMain == 0 ? false : true;
            building.Init();

            NewGameData._BuildingList.Add(building);

            return building;
        }
    }
}

