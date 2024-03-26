

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class EntityMoveFsm : FsmState<EntityBase>
    {
        private FixVector3 m_FixMoveStartPosition;
        private FixVector3 m_FixMoveEndPosition;
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private FixVector3 m_Fixv3MoveDistance;

        //private Fix64 m_FixTargetPointAtkDistance;
        private Fix64 m_LastMoveSpeed;


        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = Fix64.Zero;

            //m_FixTargetPointAtkDistance = owner.AtkRange + owner.LockedAttackEntity.Radius;// + (owner.IsInTheSky ? NewGameData.AirHigh : (Fix64)0)

            //""
            m_FixMoveEndPosition = owner.BuildAroundPoint == null ? owner.LockedAttackEntity.Fixv3LogicPosition : owner.BuildAroundPoint.FixV3; //m_MovePath[m_CurrMovePathId].GetFixLogicPosition(owner.IsInTheSky);

            m_Fixv3MoveDistance = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
            m_FixMoveStartPosition = owner.Fixv3LogicPosition;

            m_FixMoveTime = Fix64.Max(FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed(), (Fix64)0.1);
            m_LastMoveSpeed = owner.GetFixMoveSpeed();
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled)
            {
                owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                return;
            }

            if(owner.GetFixMoveSpeed() != m_LastMoveSpeed) //""
            {
                m_FixMoveTime = Fix64.Max(FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed(), (Fix64)0.1);
                m_FixMoveElpaseTime = Fix64.Zero;
                m_Fixv3MoveDistance = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
                m_FixMoveStartPosition = owner.Fixv3LogicPosition;
                m_LastMoveSpeed = owner.GetFixMoveSpeed();
            }

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = new FixVector3(m_Fixv3MoveDistance.x * timeScale,
                m_Fixv3MoveDistance.y * timeScale, m_Fixv3MoveDistance.z * timeScale);

            owner.Fixv3LogicPosition = m_FixMoveStartPosition + elpaseDistance;

            if (timeScale >= Fix64.One)
            {
                owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                return;
            }

            if (owner.ModelType == ModelType.Model2D)
            {
                owner.AngleY = owner.UpdateSpineRenderRotation(AnimType.Move);
#if _CLIENTLOGIC_
                owner.SpineAnim.SpineAnimPlay(owner, "move", true);
#endif
            }
            else if (owner.ModelType == ModelType.Model2D_Tank)
            {
                Tank tank = owner as Tank;
                tank.AngleY = owner.UpdateSpineRenderRotation(AnimType.Move);

#if _CLIENTLOGIC_
                tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "idle", true);
                tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "move", true);
#endif
            }
            else if (owner.ModelType == ModelType.Model3D)
            {
#if _CLIENTLOGIC_
                if (owner.Trans != null)
                    owner.CurrRotation = Quaternion.LookRotation(m_Fixv3MoveDistance.ToVector3(), owner.Trans.up);
#endif
            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
