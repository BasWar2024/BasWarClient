using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class TrapFactory
    {
        public TrapBase CreateTrap(TrapModel model)
        {
            NormalTrap trap = NewGameData._PoolManager.Pop<NormalTrap>(); //new NormalTrap();

            trap.Init();
            trap.CfgId = model.cfgId;
            trap.ResPath = model.model;
            trap.EffectResPath = model.explosionEffect;
            trap.Fixv3LogicPosition = new FixVector3((Fix64)model.x, (Fix64)0, (Fix64)model.z);
            //trap.BuffModel = model.buffCfgId == 0 ? null : NewGameData._OperBuffDict[model.buffCfgId];
            trap.BuffId = model.buffCfgId;
            trap.AlertRange = (Fix64)model.alertRange / 1000;
            trap.AtkRange = (Fix64)model.atkRange / 1000;
            trap.Radius = (Fix64)model.radius / 1000;
            trap.DelayTime = (Fix64)model.delayExplosionTime / 1000;
            trap.Start();

            //NewGameData._TrapList.Add(trap);

            return trap;
        }
    }
}
