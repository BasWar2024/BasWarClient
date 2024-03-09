
using UnityEngine;

namespace Battle
{
    public class SkillMoveStraightFsm : FsmState<SkillBase>
    {
        private Fix64 m_FixMoveElpaseTime = Fix64.Zero;
        private Fix64 m_FixMoveTime = Fix64.Zero;
        private FixVector3 m_Fixv3MoveDistance;
        private float time;

        public override void OnInit(SkillBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(SkillBase owner)
        {
            base.OnEnter(owner);
            if (owner.TargetPos == FixVector3.Zero)
            {
                owner.Fsm.ChangeFsmState<SkillCommonDoGroupFsm>();
                return;
            }

            time = Time.time;

            m_FixMoveElpaseTime = Fix64.Zero;
            m_Fixv3MoveDistance = owner.TargetPos - owner.OriginPos;
            m_FixMoveTime = FixVector3.Model(m_Fixv3MoveDistance) / owner.MoveSpeed;
        }

        public override void OnUpdate(SkillBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = owner.OriginPos + elpaseDistance;

            if (FixVector3.Distance(owner.Fixv3LogicPosition, owner.TargetPos) <= (Fix64)1 || owner.Fixv3LogicPosition.y < 0)
            {
                if (owner is SignalBombSkill)
                {
                    owner.Fsm.ChangeFsmState<SkillSignalBoobFsm>();
                }
                else
                {
                    owner.Fsm.ChangeFsmState<SkillCommonDoGroupFsm>();
                }

#if _CLIENTLOGIC_
                if (owner.GameObj != null)
                    owner.SetGameObjectPosition(owner.TargetPos);
#endif
            }
        }
        public override void OnLeave(SkillBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
