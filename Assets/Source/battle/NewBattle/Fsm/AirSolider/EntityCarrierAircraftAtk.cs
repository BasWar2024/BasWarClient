

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    //""，""FSM，""，""
    public class EntityCarrierAircraftAtk : FsmState<EntityBase>
    {
        private enum State
        {
            Atk = 1,
            Move = 2
        }

        private State m_State;
        private Fix64 m_Time;
        private Fix64 m_MoveTime;
        private FixVector3 m_S2e;
        private FixVector3 m_TargetCenter;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            owner.LockedAttackEntity = null;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null)
            {
                FindBuild(owner);

                if (owner.LockedAttackEntity == null)
                    return;

                m_State = State.Move;
                m_Time = Fix64.Zero;
                owner.OriginPos = owner.Fixv3LogicPosition;
                owner.TargetPos = new FixVector3(owner.LockedAttackEntity.Fixv3LogicPosition.x, NewGameData.AirHigh,
                    owner.LockedAttackEntity.Fixv3LogicPosition.z);

                m_S2e = owner.TargetPos - owner.OriginPos;
                m_MoveTime = owner.OriginAtkSpeed;
                m_TargetCenter = owner.LockedAttackEntity.Fixv3LogicPosition;

            }

#if _CLIENTLOGIC_
            if (owner.Trans != null)
                owner.CurrRotation = Quaternion.LookRotation(m_S2e.ToVector3(), owner.Trans.up);
#endif


            if (m_State == State.Move)
            {
                m_Time += NewGameData._FixFrameLen;
                var t = m_Time / m_MoveTime;
                owner.Fixv3LogicPosition = owner.OriginPos + FixMath.MoveStraight(t, m_S2e);

                if (t >= Fix64.One)
                {
                    m_State = State.Atk;
                }
            }

            if (m_State == State.Atk)
            {
                FixVector3 entityCenter = owner.Fixv3LogicPosition - NewGameData._FixUp;
                //NewGameData._BulletFactory.CreateBullet(owner, owner.LockedAttackEntity, entityCenter, m_TargetCenter);
                NewGameData._SkillFactory.CreateSkill(entityCenter, m_TargetCenter, owner,
                    owner.LockedAttackEntity, NewGameData._SkillModelDict[owner.AtkSkillId]);
                m_State = State.Move;
                owner.OriginPos = owner.Fixv3LogicPosition;
                var center = new FixVector3(owner.LockedAttackEntity.Fixv3LogicPosition.x, NewGameData.AirHigh,
                    owner.LockedAttackEntity.Fixv3LogicPosition.z);
                owner.TargetPos = FindCircleRandomPos(owner.AtkRange, center, owner.OriginPos);//center + FixMath.FindCircleRandomPos(owner.AtkRange);
                m_S2e = owner.TargetPos - owner.OriginPos;
                m_Time = Fix64.Zero;

                m_MoveTime = owner.OriginAtkSpeed;
            }
        }

        private FixVector3 FindCircleRandomPos(Fix64 atkRange, FixVector3 center, FixVector3 originPos)
        {
            var targetPos = center + FixMath.FindCircleRandomPos(atkRange);

            if (targetPos == originPos)
            {
                return FindCircleRandomPos(atkRange, center, originPos);
            }
            else
            {
                return targetPos;
            }
        }

        private void FindBuild(EntityBase owner)
        {
            var building = GameTools.FindNearestBuilding(new FixVector3(owner.Fixv3LogicPosition.x, Fix64.Zero, owner.Fixv3LogicPosition.z));
            NewGameData._FightManager.EntityLockEntity(owner, building);
        }
    }
}
