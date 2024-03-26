
#if _CLIENTLOGIC_
using UnityEngine;
#endif
namespace Battle
{
    public class EntityMoveFlashFsm : FsmState<EntityBase>
    {
        private FixVector3 m_FixMoveEndPosition;
        private FixVector3 m_Start2End;
        private FixVector3 m_StartPos;

        private bool m_Move2BuildAroundPoint;

        private Fix64 m_FixWaitElpaseTime;
        private Fix64 m_MoveTime = (Fix64)0.01;
        private Fix64 m_FixWaitTime;

        private bool m_IsMove;
        private EntityBase m_Owner;
        private float m_MaxShadowCount = 5;

#if _CLIENTLOGIC_
        private Fix64 m_ShadowCount;
        private FixVector3 m_StartPos2Now;
#endif

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_Owner = owner;
            m_FixWaitElpaseTime = Fix64.Zero;
            m_IsMove = false;
            m_FixWaitTime = NewGameData._FixFrameLen * m_MaxShadowCount;
#if _CLIENTLOGIC_
            m_StartPos2Now = FixVector3.Zero;
            m_ShadowCount = Fix64.Zero;
#endif

            m_StartPos = owner.Fixv3LogicPosition;
            m_Move2BuildAroundPoint = owner.BuildAroundPoint == null ? false : true;
            m_FixMoveEndPosition = m_Move2BuildAroundPoint ? owner.BuildAroundPoint.FixV3 : owner.LockedAttackEntity.Fixv3LogicPosition;
            m_Start2End = new FixVector3(m_FixMoveEndPosition.x - owner.Fixv3LogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - owner.Fixv3LogicPosition.z);
            m_Start2End.Normalize();
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixWaitElpaseTime += NewGameData._FixFrameLen;

            if (!m_IsMove)
            {
                if (m_FixWaitElpaseTime >= m_MoveTime)
                {
                    m_IsMove = true;
                    FlashMove(owner);
                    m_FixWaitElpaseTime = Fix64.Zero;
#if _CLIENTLOGIC_
                    m_StartPos2Now = owner.Fixv3LogicPosition - m_StartPos;
#endif
                }
            }
            else
            {
#if _CLIENTLOGIC_

                //""
                NewGameData._GameObjFactory.CreateGameObj("NinjaShadow",
                    m_StartPos2Now * (m_ShadowCount / m_MaxShadowCount) + m_StartPos, ShadowCallBack);

                m_ShadowCount += Fix64.One;
#endif

                if (m_FixWaitElpaseTime >= m_FixWaitTime)
                {
                    owner.Fsm.ChangeFsmState<EntityIdleFlashFsm>();
                }
            }
        }

#if _CLIENTLOGIC_
        private void ShadowCallBack(GameObject obj)
        {
            if (m_Owner.ObjType == ObjectType.Soldier)
            {
                var turn = obj.GetComponent<Turn8Shadow>();
                turn.Init((float)m_Owner.FlashMoveDelayTime / 3);
                turn.Turn(m_Owner);
            }
        }
#endif

        private void FlashMove(EntityBase owner)
        {
#if _CLIENTLOGIC_
            owner.SpineAnim.SpineAnimPlay(owner, "move", true);
#endif

            var newLogicPosition = owner.Fixv3LogicPosition + m_Start2End * owner.GetFixMoveSpeed();
            var newLogicPos2End = new FixVector3(m_FixMoveEndPosition.x - newLogicPosition.x, Fix64.Zero, m_FixMoveEndPosition.z - newLogicPosition.z);

            if (FixVector3.Distance(newLogicPosition, owner.LockedAttackEntity.Fixv3LogicPosition) <= owner.AtkRange + owner.LockedAttackEntity.Radius)
            {
                m_Start2End.Reverse();
                owner.Fixv3LogicPosition = owner.LockedAttackEntity.Fixv3LogicPosition + m_Start2End * (owner.AtkRange + owner.LockedAttackEntity.Radius);
                owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                return;
            }

            if (m_Move2BuildAroundPoint)
            {
                if (FixVector3.Distance(owner.Fixv3LogicPosition, m_FixMoveEndPosition) <= owner.GetFixMoveSpeed() ||
                    FixVector3.Dot(newLogicPos2End, m_Start2End) < 0)
                {
                    owner.Fixv3LogicPosition = m_FixMoveEndPosition;
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }
            }

            owner.Fixv3LogicPosition = newLogicPosition;

            owner.Fsm.ChangeFsmState<EntityIdleFlashFsm>();
        }
    }
}
