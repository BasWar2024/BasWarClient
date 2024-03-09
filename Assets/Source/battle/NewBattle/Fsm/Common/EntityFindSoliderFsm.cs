
namespace Battle
{
    public class EntityFindSoliderFsm : FsmState<EntityBase>
    {
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            if (owner is BuildingBase)
            {
                var building = owner as BuildingBase;
                if (building.Type == BuildingType.NorDevelop || building.Type == BuildingType.NorEconomy)
                {
                    owner.Fsm.ChangeFsmState<EntityIdleFsm>();
                    return;
                }
            }
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.FixAtk == Fix64.Zero)
                return;

#if _CLIENTLOGIC_
            owner.UpdateSpineRenderRotation(AnimType.Atk);
            if (owner.ObjType == ObjectType.Soldier)
                owner.SpineAnim.SpineAnimPlayAuto8Turn(owner, "idle", true);
            else if (owner.ObjType == ObjectType.Tower)
                owner.SpineAnim.SpineAnimPlayAuto30Turn(owner, "idle", true);
#endif

            foreach (var solider in NewGameData._SoldierList)
            {
                if (solider.IsInTheSky && owner.AtkType == AtkType.AtkLand)
                    continue;

                if (!solider.IsInTheSky && owner.AtkType == AtkType.AtkAir)
                    continue;

                if (FixVector3.Distance(solider.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + solider.Radius)
                {
                    NewGameData.EntityLockEntity(owner, solider);
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }
            }

            if(NewGameData._Hero != null)
            {
                if (FixVector3.Distance(NewGameData._Hero.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + NewGameData._Hero.Radius)
                {
                    NewGameData.EntityLockEntity(owner, NewGameData._Hero);
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                }
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}

