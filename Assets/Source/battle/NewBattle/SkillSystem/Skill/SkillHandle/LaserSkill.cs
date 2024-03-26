
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class LaserSkill : SkillBase
    {
        private Fix64 m_Time;
        private Fix64 m_HurtTime;

#if _CLIENTLOGIC_
        private FixVector3 m_Forword;
        private ParticleSystemRenderer m_ParticleSystemRenderer;
        private Transform m_LaserStart;
        private Transform m_LaserEnd;
#endif
        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_HurtTime = IntArg1;
            m_Time = Fix64.Zero;
#if _CLIENTLOGIC_
            m_Forword = (endPos - (originEntity.Fixv3LogicPosition + originEntity.Center)).GetNormalized();
            CreateFromPrefab(StringArg1, CreateObjCallBack);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            Link();
        }

        private void Link()
        {
            m_Time += NewGameData._FixFrameLen;

            if (m_Time >= m_HurtTime)
            {
                m_Time -= m_HurtTime;

                if (SkillEffectCfgId != 0)
                {
                    NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity);
                }
            }

#if _CLIENTLOGIC_
            UpdateLaserPos();
#endif
        }

#if _CLIENTLOGIC_
        private void CreateObjCallBack(GameObject gameObject)
        {
            m_ParticleSystemRenderer = GameObj.GetComponent<ParticleSystemRenderer>();
            m_LaserStart = GameObj.transform.Find("start");
            m_LaserEnd = GameObj.transform.Find("end");

            var mainParticle = GameObj.GetComponent<ParticleSystem>();
            mainParticle.Clear();
            mainParticle.time = 0;
            mainParticle.Play();
            var startChildCount = m_LaserStart.childCount;
            for (int i = 0; i < startChildCount; i++)
            {
                ParticleSystem ps = m_LaserStart.GetChild(i).GetComponent<ParticleSystem>();
                ps.Clear();
                ps.time = 0;
                ps.Play();
            }

            var endChildCount = m_LaserEnd.childCount;
            for (int i = 0; i < endChildCount; i++)
            {
                ParticleSystem ps = m_LaserEnd.GetChild(i).GetComponent<ParticleSystem>();
                ps.Clear();
                ps.time = 0;
                ps.Play();
            }

            UpdateLaserPos();
        }

        private void UpdateLaserPos()
        {
            if (m_ParticleSystemRenderer != null && TargetEntity != null)
            {
                Vector3 atkPos = (OriginEntity.Fixv3LogicPosition + OriginEntity.Center + OriginEntity.AtkSkillShowRadius * m_Forword).ToVector3();
                Vector3 endPos = (TargetEntity.Fixv3LogicPosition + TargetEntity.Center).ToVector3();
                var startToEnd = endPos - atkPos;
                m_ParticleSystemRenderer.lengthScale = -startToEnd.magnitude;
                Trans.position = atkPos;
                Trans.LookAt(endPos);
                m_LaserStart.position = atkPos;
                m_LaserEnd.position = endPos;
            }
        }
#endif

        public override void Release()
        {
            base.Release();
#if _CLIENTLOGIC_
            m_ParticleSystemRenderer = null;
            m_LaserStart = null;
            m_LaserEnd = null;
#endif
        }
    }
}
