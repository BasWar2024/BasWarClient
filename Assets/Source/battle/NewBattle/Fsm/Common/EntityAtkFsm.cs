
namespace Battle
{
    public class EntityAtkFsm : FsmState<EntityBase>
    {
        private Fix64 m_AtkElpaseTime;

        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_AtkElpaseTime = owner.AtkSpeed;

#if _CLIENTLOGIC_
            //DrawTool.DrawCircle(owner.GameObj.transform, owner.Fixv3LogicPosition.ToVector3(), (float)owner.AttackRange);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled)
            {
                if (owner is SoliderBase)
                {
                    owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                }
                else if (owner is BuildingBase)
                {
                    owner.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
                }

                return;
            }

            if (NewGameData._SignalBomb != null && owner.SignalState == SignalState.NoReachSignal)
            {
                owner.Fsm.ChangeFsmState<EntityFindSignalFsm>();
                return;
            }

            if (FixVector3.Distance(owner.LockedAttackEntity.Fixv3LogicPosition, owner.Fixv3LogicPosition) > owner.AtkRange + owner.LockedAttackEntity.Radius)
            {
                owner.LockedAttackEntity = null;
                return;
            }

            m_AtkElpaseTime += NewGameData._FixFrameLen;

            if (m_AtkElpaseTime >= owner.AtkSpeed)
            {
                m_AtkElpaseTime -= owner.AtkSpeed;

#if _CLIENTLOGIC_
                owner.UpdateSpineRenderRotation(AnimType.Atk);
                if(owner.ObjType == ObjectType.Soldier)
                    owner.SpineAnim.SpineAnimPlayAuto8Turn(owner, "attack", false);
                else if (owner.ObjType == ObjectType.Tower)
                    owner.SpineAnim.SpineAnimPlayAuto30Turn(owner, "attack", false);
#endif

                if (owner.BulletId != 0)
                {
                    FixVector3 entityCenter = new FixVector3(owner.Fixv3LogicPosition.x, owner.Fixv3LogicPosition.y + owner.Radius, owner.Fixv3LogicPosition.z);
                    var target = owner.LockedAttackEntity;
                    FixVector3 targetCenter = new FixVector3(target.Fixv3LogicPosition.x, target.Fixv3LogicPosition.y, target.Fixv3LogicPosition.z);
                    NewGameData._BulletFactory.CreateBullet(owner, owner.LockedAttackEntity, entityCenter, targetCenter);
                }
                else
                {
                    NewGameData._FightManager.Attack(owner.FixAtk, owner.LockedAttackEntity);
                }

                if (owner.IsDetonate)
                {
                    NewGameData._EntityManager.BeKill(owner);
                }
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }

}