using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class EntityDoSkillFsm : FsmState<EntityBase>
    {
        private Fix64 m_Time;
        private LandHero m_LandHero;
        private bool m_DoSkill;
#if _CLIENTLOGIC_
        private LockStepLogicMonoBehaviour m_LockStepLogicMonoBehaviour;
#endif

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_Time = Fix64.Zero;
            m_LandHero = owner as LandHero;
            m_DoSkill = false;

            if (NewGameData._HeroSkillDataDict.TryGetValue((OperOrder)m_LandHero.ArmyIndex + 5, out HeroSkillData heroSkillData))
            {
                heroSkillData.Cd = (Fix64)m_LandHero.HeroSkillModel.skillCd / 1000;
            }

#if _CLIENTLOGIC_
            if (owner.Trans != null)
            {
                if(owner.SkillAnimTime != Fix64.Zero)
                    owner.SpineAnim.timeScale = 1 / (float)owner.SkillAnimTime;

                if (owner.ModelType == ModelType.Model2D)
                {
                    owner.SpineAnim.SpineAnimPlay(owner, "skill", false, 0, "idle");
                }
            }

            m_LockStepLogicMonoBehaviour = NewGameData.BattleMono.GetComponent<LockStepLogicMonoBehaviour>();
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled)
            {
                owner.Fsm.ChangeFsmState<EntityIdleFsm>();
                return;
            }

            m_Time += NewGameData._FixFrameLen;

            if (!m_DoSkill && m_Time >= m_LandHero.SkillDelayTime)
            {
                m_DoSkill = true;
                DoSkill();
            }

            if (m_Time >= owner.SkillAnimTime)
            {
                owner.Fsm.ChangeFsmState<EntityIdleFsm>();
            }
        }

        private void DoSkill()
        {
            var heroSkillModel = m_LandHero.HeroSkillModel;

            if (heroSkillModel == null)
                return;

            //FixVector3 originPos = FixVector3.Zero;
            //FixVector3 targetPos = FixVector3.Zero;

            //originPos = m_LandHero.Fixv3LogicPosition;

            FixVector3 targetPos = m_LandHero.LockedAttackEntity.Fixv3LogicPosition;
            FixVector3 originPos = m_LandHero.Fixv3LogicPosition + m_LandHero.Center +
                    m_LandHero.AtkSkillShowRadius * FixMath.Vector3Rotate(NewGameData._FixForword, m_LandHero.AngleY);

            SkillBase skill = NewGameData._SkillFactory.CreateSkill(originPos, targetPos, m_LandHero, m_LandHero.LockedAttackEntity, heroSkillModel);
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
            if (!m_DoSkill)
            {
                if (NewGameData._HeroSkillDataDict.TryGetValue((OperOrder)m_LandHero.ArmyIndex + 5, out HeroSkillData heroSkillData))
                {
                    heroSkillData.Cd = (Fix64)1.5;
#if _CLIENTLOGIC_
                    m_LockStepLogicMonoBehaviour.ShowSkillMissTip(m_LandHero.ArmyIndex);
#endif
                }
            }

            m_LandHero = null;

#if _CLIENTLOGIC_
            owner.SpineAnim.timeScale = 1;
            m_LockStepLogicMonoBehaviour = null;
#endif
        }
    }
}
