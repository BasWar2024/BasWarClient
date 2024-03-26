
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class EntityCarpetAtkFsm : FsmState<EntityBase>
    {
        private Fix64 m_FixMoveElpaseTime;
        //private Fix64 m_FixMoveTime = (Fix64)2;
        private FixVector3 m_Fixv3MoveDistance;
        private FixVector3 m_OriginPos;
        private Fix64 m_TotalTime;

        private Fix64 m_AtkElpaseTime;
        private Fix64 m_AtkSpeed;
        private FixVector3 m_Dir;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_TotalTime = Fix64.Zero;
            m_OriginPos = owner.Fixv3LogicPosition;
            //var dir = owner.Fixv3LogicPosition - owner.TargetPos;
            m_Dir = owner.TargetPos - owner.OriginPos;
            m_Dir.Normalize();
            m_Fixv3MoveDistance = m_Dir * NewGameData._CarpetMoveTime * owner.GetFixMoveSpeed();
            m_AtkSpeed = owner.GetFixAtkSpeed();
            m_AtkElpaseTime = m_AtkSpeed;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;
            m_AtkElpaseTime += NewGameData._FixFrameLen;
            m_TotalTime += NewGameData._FixFrameLen;

#if _CLIENTLOGIC_
            if (owner.ModelType == ModelType.Model3D && owner.Trans != null)
            {
                owner.CurrRotation = Quaternion.LookRotation(m_Dir.ToVector3(), Vector3.up);
            }
#endif
            if (m_AtkElpaseTime >= m_AtkSpeed)
            {
                m_AtkElpaseTime -= m_AtkSpeed;

                FixVector3 targetPos = new FixVector3(owner.Fixv3LogicPosition.x, Fix64.Zero, owner.Fixv3LogicPosition.z);
                NewGameData._SkillFactory.CreateSkill(owner.Fixv3LogicPosition, targetPos, owner,
                    owner.LockedAttackEntity, NewGameData._SkillModelDict[owner.AtkSkillId]);
#if _CLIENTLOGIC_

                AudioFmodMgr.instance.ActionPlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._AttackAudio, owner.Trans);
#endif
            }

            Fix64 timeScale = m_FixMoveElpaseTime / NewGameData._CarpetMoveTime;

            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;

            owner.Fixv3LogicPosition = m_OriginPos + elpaseDistance;

            if (m_TotalTime >= NewGameData._CarpetMoveTime)
            {
                owner.Fsm.ChangeFsmState<EntityAirSoliderReturnFsm>();
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
