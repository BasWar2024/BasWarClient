

namespace Battle
{
    using System.Collections.Generic;

    public class EntityMoveFsm : FsmState<EntityBase>
    {
        private FixVector3 m_FixMoveStartPosition;
        private FixVector3 m_FixMoveEndPosition;
        private Fix64 m_FixMoveElpaseTime = Fix64.Zero;
        private Fix64 m_FixMoveTime = Fix64.Zero;
        private FixVector3 m_Fixv3MoveDistance = new FixVector3(Fix64.Zero, Fix64.Zero, Fix64.Zero);

        private Fix64 m_FixTargetPointAtkDistance;
        private Fix64 m_LastMoveSpeed;


        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = Fix64.Zero;

            m_FixTargetPointAtkDistance = owner.AtkRange + owner.LockedAttackEntity.Radius + (owner.IsInTheSky ? NewGameData.AirHigh : (Fix64)0);

            //
            m_FixMoveEndPosition = owner.BuildAroundPoint == null ? owner.LockedAttackEntity.Fixv3LogicPosition : owner.BuildAroundPoint.FixV3; //m_MovePath[m_CurrMovePathId].GetFixLogicPosition(owner.IsInTheSky);

            m_Fixv3MoveDistance = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
            m_FixMoveStartPosition = owner.Fixv3LogicPosition;

            m_FixMoveTime = FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.MoveSpeed;
            m_LastMoveSpeed = owner.MoveSpeed;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled)
            {
                owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                return;
            }

            if (NewGameData._SignalBomb != null && owner.SignalState == SignalState.NoReachSignal)
            {
                owner.Fsm.ChangeFsmState<EntityFindSignalFsm>();
                return;
            }

            if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.LockedAttackEntity.Fixv3LogicPosition) <= m_FixTargetPointAtkDistance) //
            {
                owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                return;
            }

            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }

            if(owner.MoveSpeed != m_LastMoveSpeed) //
            {
                m_FixMoveTime = FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.MoveSpeed;
                m_FixMoveElpaseTime = Fix64.Zero;
                m_Fixv3MoveDistance = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
                m_FixMoveStartPosition = owner.Fixv3LogicPosition;
                m_LastMoveSpeed = owner.MoveSpeed;
            }

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = new FixVector3(m_Fixv3MoveDistance.x * timeScale,
                m_Fixv3MoveDistance.y * timeScale, m_Fixv3MoveDistance.z * timeScale);

            owner.Fixv3LogicPosition = m_FixMoveStartPosition + elpaseDistance;

#if _CLIENTLOGIC_
            owner.UpdateSpineRenderRotation(AnimType.Move);
            owner.SpineAnim.SpineAnimPlayAuto8Turn(owner, "move", true);
#endif
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
