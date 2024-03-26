
namespace Battle
{
    public class SuicideChildMoveFsm : FsmState<EntityBase>
    {
        private enum Stage
        {
            Move = 0,
            Wait = 1,
            AtkMove = 2,
        }

        private Fix64 m_TotalTime;
        private Fix64 m_Time;
        private Fix64 m_WaitTime = Fix64.Zero;
        private Fix64 m_MoveDistance = (Fix64)1;
        private Stage m_Stage;
        private FixVector3 m_MoveS2e;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_Stage = Stage.Move;
            m_MoveS2e = new FixVector3(owner.TargetPos.x, Fix64.Zero, owner.TargetPos.z) -
                new FixVector3(owner.OriginPos.x, Fix64.Zero, owner.OriginPos.z);
            m_MoveS2e.Normalize();
            m_MoveS2e = m_MoveS2e * m_MoveDistance;
            m_TotalTime = FixVector3.Model(m_MoveS2e) / owner.GetFixMoveSpeed();
            m_Time = Fix64.Zero;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_Time += NewGameData._FixFrameLen;

            if (m_Stage == Stage.Move)
            {
                Fix64 timeScale = m_Time / m_TotalTime;
                owner.Fixv3LogicPosition = owner.OriginPos + FixMath.MoveStraight(timeScale, m_MoveS2e);

                if (timeScale >= Fix64.One)
                {
                    m_Stage = Stage.Wait;
                    m_Time = Fix64.Zero;
                    return;
                }
            }
            else if (m_Stage == Stage.Wait)
            {
                if (m_Time > m_WaitTime)
                {
                    m_Stage = Stage.AtkMove;
                    m_Time = Fix64.Zero;
                    m_MoveS2e = owner.TargetPos - owner.Fixv3LogicPosition;
                    m_TotalTime = FixVector3.Model(m_MoveS2e) / owner.GetFixMoveSpeed();
                    owner.OriginPos = owner.Fixv3LogicPosition;

#if _CLIENTLOGIC_
                    SuicideChildAirSolider soldier = owner as SuicideChildAirSolider;
                    soldier.TurnForword(owner, m_MoveS2e);
#endif
                    return;
                }
            }
            else if (m_Stage == Stage.AtkMove)
            {
                Fix64 timeScale = m_Time / m_TotalTime;
                owner.Fixv3LogicPosition = owner.OriginPos + FixMath.MoveStraight(timeScale, m_MoveS2e);

                if (timeScale >= Fix64.One)
                {
                    owner.Fsm.ChangeFsmState<SuicideChildAtkFsm>();
                    return;
                }
            }
        }
    }
}
