
namespace Battle
{
    using System.Collections.Generic;

    public class EntityMoveSignalLockBuildingFsm : FsmState<EntityBase>
    {
        private List<ASPoint> m_MovePath;
        private int m_CurrMovePathId;
        private int m_MovePathCount;

        private FixVector3 m_FixMoveStartPosition;
        private FixVector3 m_FixMoveEndPosition;
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private FixVector3 m_Fixv3MoveDistance;

        private Fix64 m_FixSignalBuildingDistance;

        private Fix64 m_RandomRadius;
        //private Fix64 m_RandomRad;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_MovePath = owner.ListMovePath;
            m_CurrMovePathId = 0;
            m_MovePathCount = m_MovePath.Count;

            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = Fix64.Zero;

            m_FixSignalBuildingDistance = owner.AtkRange + NewGameData._SignalLockBuilding.Radius;// + (owner.IsInTheSky ? NewGameData.AirHigh : (Fix64)0)

            //m_RandomRad = NewGameData._Srand.Range(Fix64.Zero, 2 * Fix64.PI);
            m_RandomRadius = NewGameData._Srand.Range(Fix64.Zero, (Fix64)1);
            //""
            CalMovePoint();
            //m_FixMoveEndPosition = m_MovePath[m_CurrMovePathId].GetFixLogicPosition(owner.IsInTheSky);

            m_Fixv3MoveDistance = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
            m_FixMoveStartPosition = owner.Fixv3LogicPosition;

            m_FixMoveTime = FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed();
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (m_MovePath == null)
            {
                owner.Fsm.ChangeFsmState<EntityIdleFsm>();
                return;
            }

            if (NewGameData._SignalBomb == null || NewGameData._SignalLockBuilding == null)
            {
                owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                return;
            }

            if (FixVector3.Distance(owner.Fixv3LogicPosition, NewGameData._SignalLockBuilding.Fixv3LogicPosition) <= m_FixSignalBuildingDistance)
            {
                owner.SignalState = SignalState.ReachSignal;
                owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                return;
            }

            //if (owner.FlashMoveDistance > Fix64.Zero)
            //{
            //    if (m_CurrMovePathId >= 3)
            //    {
            //        owner.Fsm.ChangeFsmState<EntityMoveFlashFsm>();
            //        return;
            //    }
            //}


            if (FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) <= (Fix64)0.5)
            {
                m_CurrMovePathId++;

                if (m_CurrMovePathId >= m_MovePathCount)
                {
                    owner.SignalState = SignalState.ReachSignal;
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }

                //""
                m_FixMoveStartPosition = owner.Fixv3LogicPosition;
                //""
                CalMovePoint();
                //m_FixMoveEndPosition = m_MovePath[m_CurrMovePathId].GetFixLogicPosition(owner.IsInTheSky);

                //m_Fixv3MoveDistance = new FixVector3(m_MovePath[m_CurrMovePathId].X - owner.Fixv3LogicPosition.x, Fix64.Zero,
                //    m_MovePath[m_CurrMovePathId].Z - owner.Fixv3LogicPosition.z);

                m_Fixv3MoveDistance = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero,
                 m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);

                //m_FixMoveTime = FixVector3.Distance(owner.Fixv3LogicPosition, m_MovePath[m_CurrMovePathId].GetFixLogicPosition(owner.IsInTheSky)) / owner.MoveSpeed;
                m_FixMoveTime = FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed();
                m_FixMoveElpaseTime = Fix64.Zero;
            }

            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = new FixVector3(m_Fixv3MoveDistance.x * timeScale,
                m_Fixv3MoveDistance.y * timeScale, m_Fixv3MoveDistance.z * timeScale);

            owner.Fixv3LogicPosition = m_FixMoveStartPosition + elpaseDistance;

            //owner.UpdateSpineRenderRotation(AnimType.Move);
            //owner.SpineAnim.SpineAnimPlay(owner, "move", true);
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
                //tank.GunAngleY = owner.UpdateSpineRenderRotation(AnimType.Idle);
                tank.AngleY = owner.UpdateSpineRenderRotation(AnimType.Move);

#if _CLIENTLOGIC_
                tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "idle", true);
                tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "move", true);
#endif
            }
        }

        private void CalMovePoint()
        {
            FixVector3 movePoint = m_MovePath[m_CurrMovePathId].GetFixLogicPosition();
            Fix64 x = movePoint.x + m_RandomRadius * Fix64.Cos(m_RandomRadius);
            Fix64 z = movePoint.z + m_RandomRadius * Fix64.Sin(m_RandomRadius);

            m_FixMoveEndPosition = new FixVector3(x, Fix64.Zero, z);
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
