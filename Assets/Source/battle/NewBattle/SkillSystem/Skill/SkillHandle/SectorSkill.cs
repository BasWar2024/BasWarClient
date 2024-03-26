


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class SectorSkill : SkillBase
    {
        private Fix64 m_Range;
        private Fix64 m_Angle;
        private AtkAir m_AtkAir;
        private Fix64 m_DelayTime;

        private Fix64 m_TotalTime;
        private GroupType selfGroup;
        private FixVector3 m_Forword;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_Range = IntArg1;
            m_Angle = IntArg2;
            m_AtkAir = (AtkAir)(int)IntArg3;
            m_DelayTime = IntArg4;
            m_TotalTime = Fix64.Zero;
            selfGroup = originEntity.Group;
            m_Forword = (targetEntity.Fixv3LogicPosition - originEntity.Fixv3LogicPosition).GetNormalized();

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });

            NewGameData._EffectFactory.CreateEffect(StringArg1, originEntity.Fixv3LogicPosition, Fix64.One, Fix64.Zero, (obj, eff) => {
                obj.transform.forward = m_Forword.ToVector3();
            });
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (m_TotalTime >= m_DelayTime)
            {
                DoSkill();
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;
        }

        private void DoSkill()
        {
            var entityList = GameTools.GetTargetGroup(selfGroup, TargetGroup);

            foreach (var entity in entityList)
            {
                if (entity == null || entity.BKilled)
                    continue;

                if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                    continue;

                bool inSector = FixMath.InSector(m_Forword, StartPos, entity.Fixv3LogicPosition, m_Range, entity.Radius, m_Angle);
                if (inSector && SkillEffectCfgId != 0)
                {
                    NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, entity);
#if _CLIENTLOGIC_
                    NewGameData._EffectFactory.CreateEffect(StringArg2, entity.Fixv3LogicPosition, Fix64.Zero, Fix64.Zero);
#endif
                }

            }
        }
    }
}
