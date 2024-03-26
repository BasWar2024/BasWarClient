
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class ThundercloundSkill : SkillBase
    {
        private Fix64 m_Range;
        private Fix64 m_LifeTime;
        private Fix64 m_Frequency;

        private Fix64 m_TotalTime;
        private FixVector3 m_High;
        private Fix64 m_Time;
        private bool m_IsLink;
        private Fix64 m_MaxLinkTime = (Fix64)0.2;
        private Fix64 m_LinkTime;

        private EntityBase m_LockTarget;

#if _CLIENTLOGIC_
        private ParticleSystemRenderer m_ParticleSystemRenderer;
        private Transform m_LaserStart;
        private Transform m_LaserEnd;

        private Effect m_Thunderclound;
#endif

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_LifeTime = IntArg1;
            m_Frequency = IntArg2;
            m_Range = IntArg3;

            m_TotalTime = Fix64.Zero;
            m_High = NewGameData._FixUp * (Fix64)6;
            m_Time = Fix64.Zero;
            m_IsLink = false;
            m_LinkTime = Fix64.Zero;


#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });

            NewGameData._EffectFactory.CreateEffect(StringArg1, originEntity.Fixv3LogicPosition, Fix64.One, m_LifeTime, (obj, eff) => {
                m_Thunderclound = eff;
            });

            GG.ResMgr.instance.LoadGameObjectAsync(StringArg2, (obj) =>
            {
                if (BKilled)
                {
                    GG.ResMgr.instance.ReleaseAsset(obj);
                    return true;
                }

                m_ParticleSystemRenderer = obj.GetComponent<ParticleSystemRenderer>();
                m_LaserStart = obj.transform.Find("start");
                m_LaserEnd = obj.transform.Find("end");

                obj.SetActive(false);

                return true;
            }, true, null, NewGameData._AssetOriginPos);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (m_TotalTime >= m_LifeTime || OriginEntity == null || OriginEntity.BKilled)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;

            Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition + m_High;

#if _CLIENTLOGIC_
            if (m_Thunderclound != null)
            {
                m_Thunderclound.Trans.position = Fixv3LogicPosition.ToVector3();
            }
#endif

            if (m_IsLink)
            {
                Link();
            }
            else
            {
                m_Time += NewGameData._FixFrameLen;
                if (m_Time >= m_Frequency)
                {
                    m_IsLink = true;
                    m_Time -= m_Frequency;
                    DoSkill();
#if _CLIENTLOGIC_
                    if (m_ParticleSystemRenderer != null)
                    {
                        m_ParticleSystemRenderer.gameObject.SetActive(true);
                    }
#endif
                }
            }
        }

        private void Link()
        {
            m_LinkTime += NewGameData._FixFrameLen;

            if (m_LinkTime >= m_MaxLinkTime)
            {
                m_IsLink = false;
                m_LinkTime = Fix64.Zero;
#if _CLIENTLOGIC_
                if (m_ParticleSystemRenderer != null)
                {
                    m_ParticleSystemRenderer.gameObject.SetActive(false);
                }
#endif
                return;
            }

#if _CLIENTLOGIC_
            UpdateLaserPos();
#endif
        }

#if _CLIENTLOGIC_
        private void UpdateLaserPos()
        {
            if (m_ParticleSystemRenderer != null && m_LockTarget != null)
            {
                var trans = m_ParticleSystemRenderer.transform;
                Vector3 atkPos = (OriginEntity.Fixv3LogicPosition + m_High).ToVector3();
                Vector3 endPos = (m_LockTarget.Fixv3LogicPosition + m_LockTarget.Center).ToVector3();
                var startToEnd = endPos - atkPos;
                m_ParticleSystemRenderer.lengthScale = -startToEnd.magnitude;
                trans.position = atkPos;
                trans.LookAt(endPos);
                m_LaserStart.position = atkPos;
                m_LaserEnd.position = endPos;
            }
        }
#endif

        private void DoSkill()
        {
            if (m_LockTarget == null || m_LockTarget.BKilled)
            {
                m_LockTarget = GameTools.FindNearestAtkRangeBuilding(OriginEntity.Fixv3LogicPosition, m_Range);
            }

            if (m_LockTarget != null)
            {
                TriggerSkill(OriginEntity, m_LockTarget);
#if _CLIENTLOGIC_
                NewGameData._EffectFactory.CreateEffect(StringArg3, m_LockTarget.Fixv3LogicPosition, Fix64.One, Fix64.Zero);
#endif
            }
        }

        public override void Release()
        {
            m_LockTarget = null;
#if _CLIENTLOGIC_

            if (m_ParticleSystemRenderer != null)
            {
                GG.ResMgr.instance.ReleaseAsset(m_ParticleSystemRenderer.gameObject);
            }

            if (m_Thunderclound != null)
            {
                m_Thunderclound.BeKill();
            }

            m_ParticleSystemRenderer = null;
            m_LaserStart = null;
            m_LaserEnd = null;
            m_Thunderclound = null;
#endif
            base.Release();
        }
    }
}
