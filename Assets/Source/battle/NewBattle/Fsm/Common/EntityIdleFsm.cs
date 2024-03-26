
namespace Battle
{
    public class EntityIdleFsm : FsmState<EntityBase>
    {
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            owner.CanUseSkill = true;
            if (owner.ModelType == ModelType.Model2D)
            {
                //owner.AngleY = owner.UpdateSpineRenderRotation(AnimType.Idle);
#if _CLIENTLOGIC_
                owner.SpineAnim.SpineAnimPlay(owner, "idle", true);
#endif
            }
            else if (owner.ModelType == ModelType.Model2D_Tank)
            {
                Tank tank = owner as Tank;
#if _CLIENTLOGIC_
                tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "idle", true);
                tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "idle", true);
#endif
            }

#if _CLIENTLOGIC_
            if (owner.GameObj != null)
            {
                owner.GameObj.SetActive(true);
            }
#endif

        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
            if (owner.Group == GroupType.PlayerGroup)
            {
                owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
