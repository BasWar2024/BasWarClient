

namespace Battle
{
    using System.Collections.Generic;

    public class EntityAStarMoveFsm : FsmState<EntityBase>
    {
        private enum MoveType
        {
            AStarMove = 0,
            SiegeMove = 1,
        }

        private List<ASPoint> m_MovePath;
        private int m_CurrMovePathId;
        private int m_MovePathCount;
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private Fix64 m_Distance;
        private Fix64 m_RandomRadius;
        private FixVector3 m_FixMoveStartPosition;
        private FixVector3 m_FixMoveEndPosition;
        private FixVector3 m_Fixv3MoveDistance;
        private Fix64 m_RandomRad;
        private Fix64 m_LastMoveSpeed;
        private MoveType m_MoveType;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_MovePath = owner.ListMovePath;
            m_CurrMovePathId = 0;
            m_FixMoveElpaseTime = Fix64.Zero;
            m_Distance = owner.AtkRange + owner.LockedAttackEntity.Radius;
            m_MovePathCount = m_MovePath.Count;
            m_RandomRadius = NewGameData._Srand.Range(Fix64.Zero, (Fix64)1.5);
            m_RandomRad = NewGameData._Srand.Range(Fix64.Zero, 2 * Fix64.PI);
            m_FixMoveEndPosition = m_MovePath[m_CurrMovePathId].GetFixLogicPosition();
            m_FixMoveStartPosition = owner.Fixv3LogicPosition;
            m_FixMoveTime = FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed();
            m_LastMoveSpeed = owner.GetFixMoveSpeed();
            if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.LockedAttackEntity.Fixv3LogicPosition) - m_Distance <= (Fix64)4)
            {
                //m_Fixv3MoveDistance = owner.LockedAttackEntity.Fixv3LogicPosition - owner.Fixv3LogicPosition;
                FindFiegePos(owner);
                m_MoveType = MoveType.SiegeMove;
            }
            else
            {
                m_Fixv3MoveDistance = m_FixMoveEndPosition - owner.Fixv3LogicPosition;
                m_MoveType = MoveType.AStarMove;
            }

            if (m_FixMoveTime <= Fix64.Zero)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null)
            {
                owner.Fsm.ChangeFsmState<EntityIdleFsm>();
                return;
            }

            if (owner.GetFixMoveSpeed() != m_LastMoveSpeed) //""
            {
                m_FixMoveTime = Fix64.Max(FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed(), (Fix64)0.1);
                m_FixMoveElpaseTime = Fix64.Zero;
                m_Fixv3MoveDistance = m_FixMoveEndPosition - owner.Fixv3LogicPosition; 
                m_FixMoveStartPosition = owner.Fixv3LogicPosition;
                m_LastMoveSpeed = owner.GetFixMoveSpeed();

                if (m_FixMoveTime <= Fix64.Zero)
                {
                    m_FixMoveTime = (Fix64)0.1;
                }
            }

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;
            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;
            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;
            owner.Fixv3LogicPosition = m_FixMoveStartPosition + elpaseDistance;

            if (m_MoveType == MoveType.AStarMove)
            {
                if (timeScale >= Fix64.One)
                {
                    //var sqrDist = FixVector3.SqrMagnitude(owner.LockedAttackEntity.Fixv3LogicPosition - owner.Fixv3LogicPosition);
                    var distance = FixVector3.Distance(owner.LockedAttackEntity.Fixv3LogicPosition, owner.Fixv3LogicPosition);

                    if (distance - m_Distance <= (Fix64)4)
                    {
                        FindFiegePos(owner);
                        
                        return;
                    }

                    m_CurrMovePathId++;

                    if (m_CurrMovePathId >= m_MovePathCount)
                    {
                        owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                        return;
                    }

                    //""
                    m_FixMoveStartPosition = owner.Fixv3LogicPosition;
                    //""
                    CalMovePoint();
                    m_Fixv3MoveDistance = m_FixMoveEndPosition - m_FixMoveStartPosition;
                    m_FixMoveTime = FixVector3.Distance(m_FixMoveStartPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed();
                    m_FixMoveElpaseTime = Fix64.Zero;
                    if (m_FixMoveTime <= Fix64.Zero)
                    {
                        m_FixMoveTime = (Fix64)0.1;
                    }
                }
            }
            else
            {
                if (timeScale >= Fix64.One)
                {
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }
            }

            if (owner.ModelType == ModelType.Model2D)
            {
                owner.AngleY = owner.SetAngleY(m_Fixv3MoveDistance);//owner.UpdateSpineRenderRotation(AnimType.Move);
#if _CLIENTLOGIC_
                owner.SpineAnim.SpineAnimPlay(owner, "move", true);
#endif
            }
            else if (owner.ModelType == ModelType.Model2D_Tank)
            {
                Tank tank = owner as Tank;
                //tank.GunAngleY = owner.UpdateSpineRenderRotation(AnimType.Idle);
                //tank.AngleY = owner.UpdateSpineRenderRotation(AnimType.Move);
                owner.AngleY = owner.SetAngleY(m_Fixv3MoveDistance);
#if _CLIENTLOGIC_
                tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "idle", true);
                tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "move", true);
#endif
            }
        }

        private void CalMovePoint()
        {
            FixVector3 movePoint = m_MovePath[m_CurrMovePathId].GetFixLogicPosition();
            Fix64 x = movePoint.x + m_RandomRadius * Fix64.Cos(m_RandomRad);
            Fix64 z = movePoint.z + m_RandomRadius * Fix64.Sin(m_RandomRad);

            m_FixMoveEndPosition = new FixVector3(x, Fix64.Zero, z);
        }

        private void FindFiegePos(EntityBase owner)
        {
            BuildingAroundPoint aroundPoint = NewGameData._PoolManager.Pop<BuildingAroundPoint>();
            BuildingBase build = owner.LockedAttackEntity as BuildingBase;
            var targetPos = NewGameData._FightManager.SetBuildingAroundPoint(build, owner, build.Radius + owner.AtkRange);
            targetPos = GameTools.BoundaryMap(targetPos);

            aroundPoint.FixV3 = targetPos;
            owner.BuildAroundPoint = aroundPoint;
            m_FixMoveEndPosition = owner.BuildAroundPoint.FixV3;
            m_MoveType = MoveType.SiegeMove;
            m_FixMoveStartPosition = owner.Fixv3LogicPosition;
            m_Fixv3MoveDistance = m_FixMoveEndPosition - m_FixMoveStartPosition;
            m_FixMoveTime = FixVector3.Distance(m_FixMoveStartPosition, m_FixMoveEndPosition) / owner.GetFixMoveSpeed();
            m_FixMoveElpaseTime = Fix64.Zero;

            if (m_FixMoveTime == Fix64.Zero)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
            m_MovePath = null;
        }
    }
}
