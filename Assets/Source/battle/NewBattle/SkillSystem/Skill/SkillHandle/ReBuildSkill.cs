
using System;
#if _CLIENTLOGIC_
using UnityEngine;
using Spine.Unity;
using Spine;
#endif

namespace Battle
{
    //""skilleffect""，""，""。
    public class ReBuildSkill : SkillBase
    {
        private bool m_IsRebuild;
        private Fix64 m_DelayTime;
        private Fix64 m_LiftTime; //""
        private Fix64 m_Time;
        private FixVector3 m_ReBuildPos;
#if _CLIENTLOGIC_
        private SkeletonAnimation m_Anim;
#endif

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            //""
            if (originEntity.RebuildAction != null || originEntity.BKilled)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            originEntity.RebuildAction += ReBuildCallBack;
            m_IsRebuild = false;
            m_DelayTime = IntArg1;
            m_LiftTime = IntArg2;
            m_Time = Fix64.Zero;

            Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition;

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, CreateFromPrefabCallBack);
#endif
        }

#if _CLIENTLOGIC_
        private void CreateFromPrefabCallBack(GameObject obj)
        {
            Transform spine = Trans.Find("Spine");
            if (spine != null)
            {
                m_Anim = spine.GetComponent<SkeletonAnimation>();
                m_Anim.SpineAnimPlay("start", false);
                m_Anim.AnimationState.Complete += LoopAnim;
            }
            if (m_IsRebuild)
            {
                GameObj.SetActive(false);
            }
        }

        private void LoopAnim(TrackEntry gameObject)
        {
            m_Anim.AnimationState.Complete -= LoopAnim;
            m_Anim.SpineAnimPlay("loop", true);
        }

        private void EndAnim(TrackEntry gameObject)
        {
            m_Anim.AnimationState.Complete -= EndAnim;
            if (GameObj != null)
            {
                GameObj.SetActive(false);
            }
        }
#endif

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_Time += NewGameData._FixFrameLen;
            if (m_IsRebuild)
            {
                if (m_Time >= m_DelayTime)
                {
                    ReBuild();
                }
            }
            else
            {
                if (OriginEntity != null)
                {
                    Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition;
                }

                if (m_Time >= m_LiftTime)
                {
                    NewGameData._EntityManager.BeKill(this);
                }
            }
        }

        private void ReBuild()
        {
            TriggerSkill(OriginEntity, OriginEntity);
#if _CLIENTLOGIC_
            OriginEntity.UpdateHpSprite();

            NewGameData._EffectFactory.CreateEffect(StringArg2, new FixVector3(m_ReBuildPos.x, Fix64.Zero, m_ReBuildPos.z), Fix64.Zero,
                    Fix64.Zero);

            OriginEntity.GameObj.SetActive(true);
#endif
            OriginEntity?.Fsm?.ChangeFsmState<EntityBirthFsm>();
            NewGameData._EntityManager.BeKill(this);
        }

        private void ReBuildCallBack(FixVector3 pos)
        {
            m_IsRebuild = true;
            m_ReBuildPos = pos;
            m_Time = Fix64.Zero;

            if (OriginEntity != null)
            {
                OriginEntity.RebuildAction -= ReBuildCallBack;

#if _CLIENTLOGIC_

                NewGameData._EffectFactory.CreateEffect(OriginEntity.DeadEffect, new FixVector3(m_ReBuildPos.x, Fix64.Zero, m_ReBuildPos.z), Fix64.Zero,
                   Fix64.Zero);

                NewGameData._EffectFactory.CreateEffect(StringArg3, new FixVector3(m_ReBuildPos.x, Fix64.Zero, m_ReBuildPos.z), Fix64.Zero,
                    m_DelayTime);

                if (m_Anim != null)
                {
                    m_Anim.AnimationState.Complete += EndAnim;
                    m_Anim.SpineAnimPlay("end", false);
                }
#endif
                OriginEntity.Fsm.ChangeFsmState<EntityDisappearFsm>();

                Buff buff = NewGameData._BuffFactory.CreateTempBuff();
                buff.LifeTime = m_DelayTime;
                OriginEntity.AddBuff(buff);
                NewGameData._BuffManager.Invincible(buff, null, OriginEntity);
            }
        }

        public override void Release()
        {
            if (OriginEntity != null)
            {
                OriginEntity.RebuildAction -= ReBuildCallBack;
            }

#if _CLIENTLOGIC_
            if (m_Anim != null)
            {
                m_Anim.AnimationState.Complete -= LoopAnim;
                m_Anim.AnimationState.Complete -= EndAnim;
                m_Anim = null;
            }
#endif

            base.Release();
        }

    }
}
