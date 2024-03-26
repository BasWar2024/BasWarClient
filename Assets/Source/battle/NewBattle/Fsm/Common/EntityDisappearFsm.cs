
namespace Battle
{
    //""，""BUFF
    public class EntityDisappearFsm : FsmState<EntityBase>
    {
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            owner.ImmuneBuff = true;

            if (owner.BattlePos != null && owner.LockedAttackEntity != null && owner.LockedAttackEntity is BuildingBase build)
            {
                var building = owner.LockedAttackEntity as BuildingBase;
                var solider = owner as SoliderBase;
                NewGameData._FightManager.RemoveBuildingAroundPoint(solider, building);
            }

            owner.BuffBag.Release();

#if _CLIENTLOGIC_
            owner.GameObj.SetActive(false);
#endif
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
            owner.ImmuneBuff = false;

#if _CLIENTLOGIC_
            if (owner.GameObj != null)
            {
                owner.GameObj.SetActive(true);
            }
#endif
        }
    }
}
