

using System;
using System.Collections.Generic;
#if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class FireRainSkill : SkillBase
    {
        private Fix64 m_Range;
        private Fix64 m_LifeTime;
        private Fix64 m_Frequency;
        private Fix64 m_High;

        private Fix64 m_Time;
        private Fix64 m_TotalTime;
        private FixVector3 m_SkillStartPos;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_Range = IntArg1;
            m_LifeTime = IntArg2;
            m_Frequency = IntArg3;
            m_High = IntArg4;
            m_TotalTime = Fix64.Zero;
            m_Time = Fix64.Zero;
            m_SkillStartPos = new FixVector3(endPos.x, m_High, endPos.z);

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });

            NewGameData._EffectFactory.CreateEffect(StringArg1, endPos, m_Range, m_LifeTime);
            NewGameData._EffectFactory.CreateEffect(StringArg2, m_SkillStartPos, m_Range, m_LifeTime, CraeteStartModelCallBack);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_Time += NewGameData._FixFrameLen;
            m_TotalTime += NewGameData._FixFrameLen;

            if (m_Time >= m_Frequency)
            {
                m_Time -= m_Frequency;

                DoSkill();
            }

            if (m_TotalTime >= m_LifeTime)
            {
                NewGameData._EntityManager.BeKill(this);
            }
        }

        private void DoSkill()
        {
            if (SkillEffectCfgId != 0)
            {
                var endPos = EndPos + GameTools.RandomTargetPos(m_Range);
                var startPos = m_SkillStartPos + GameTools.RandomTargetPos((Fix64)2);
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, OriginEntity.LockedAttackEntity,
                    startPos.x, startPos.y, startPos.z, endPos.x, endPos.y, endPos.z);
            }
        }

#if _CLIENTLOGIC_
        private void CraeteStartModelCallBack(GameObject arg1, Effect arg2)
        {
            var selfPos = arg1.transform.position;
            arg1.transform.position = new Vector3(selfPos.x, (float)m_High, selfPos.z);
        }
#endif

    }
}
