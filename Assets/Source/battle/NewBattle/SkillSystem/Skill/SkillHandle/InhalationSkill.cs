


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class InhalationSkill : SkillBase
    {
        private FixVector3 m_S2e;
        private Fix64 m_Time;
        private Fix64 m_TotalTime;

#if _CLIENTLOGIC_
        private ParticleSystemRenderer m_ParticleSystemRenderer;
        private Transform m_LaserStart;
        private Transform m_LaserEnd;
#endif

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            TargetEntity.SignalState = SignalState.None;

            //""BUFF ""+""
            if (NewGameData._SkillEffectModelDict.TryGetValue(SkillEffectCfgId, out SkillEffectModel model))
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(model.skillEffectCfgId, null, OriginEntity, TargetEntity);
            }

            m_S2e = originEntity.Fixv3LogicPosition + originEntity.Center - (endPos + targetEntity.Center);
            m_Time = Fix64.Zero;
            m_TotalTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_S2e)) / IntArg1;

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });
            //CreateFromPrefab(EffectModel, CreateObjCallBack);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (TargetEntity == null || TargetEntity.BKilled)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_Time += NewGameData._FixFrameLen;
            var t = m_Time / m_TotalTime;

            if (t >= Fix64.One)
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity);
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            TargetEntity.Fixv3LogicPosition = EndPos + FixMath.MoveStraight(t, m_S2e);

//#if _CLIENTLOGIC_
//            UpdateLaserPos();
//#endif
        }

#if _CLIENTLOGIC_

        private void CreateObjCallBack(GameObject gameObject)
        {
            m_ParticleSystemRenderer = GameObj.GetComponent<ParticleSystemRenderer>();
            m_LaserStart = GameObj.transform.Find("start");
            m_LaserEnd = GameObj.transform.Find("end");

            UpdateLaserPos();
        }

        private void UpdateLaserPos()
        {
            if (m_ParticleSystemRenderer != null)
            {
                Vector3 atkPos = (Fixv3LogicPosition + OriginEntity.Center).ToVector3();
                Vector3 endPos = (TargetEntity.Fixv3LogicPosition + TargetEntity.Center).ToVector3();

                Vector3 startToEnd = endPos - atkPos;

                m_ParticleSystemRenderer.lengthScale = -startToEnd.magnitude;
                m_ParticleSystemRenderer.transform.position = atkPos;
                m_ParticleSystemRenderer.transform.LookAt(endPos);

                m_LaserStart.position = atkPos;
                m_LaserEnd.position = endPos;

            }
        }
#endif

        public override void Release()
        {
#if _CLIENTLOGIC_
            m_ParticleSystemRenderer = null;
            m_LaserStart = null;
            m_LaserEnd = null;
#endif
            base.Release();
        }
    }
}
