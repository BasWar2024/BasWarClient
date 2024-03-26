
namespace Battle
{
    public class EntityDeadFsm : FsmState<EntityBase>
    {

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            if (owner.BuildAroundPoint != null)
                owner.BuildAroundPoint.Use = false;

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._DieAudio, owner.Trans);
#endif

            if (owner is BuildingBase)
            {
                BuildingBase building = (BuildingBase)owner;
#if _CLIENTLOGIC_

                NewGameData._GameObjFactory.CreateGameObj(building.DeadResPath, building.Fixv3LogicPosition);
                NewGameData._EffectFactory.CreateEffect(building.EffectResPath, building.Fixv3LogicPosition, Fix64.Zero,
                    Fix64.Zero, null);
#endif

                if (building.IsMain)
                {
                    NewGameData._Victory = true;
                }
            }
            else if (owner is SoliderBase)
            {
                //if (owner.IsInTheSky)
                //    return;

#if _CLIENTLOGIC_
                SoliderBase solider = (SoliderBase)owner;
                NewGameData._EffectFactory.CreateEffect(solider.DeadEffect, solider.Fixv3LogicPosition, solider.Radius,
                    Fix64.Zero, null);
#endif
            }
            owner.CanRelease = true;
        }
    }
}

