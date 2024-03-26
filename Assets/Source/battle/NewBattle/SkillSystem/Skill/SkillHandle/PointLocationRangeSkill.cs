


namespace Battle
{

    public class PointLocationRangeSkill : SkillBase
    {
        private enum Stage
        {
            Wait,
            Move,
            Do,
        }

        private Stage m_Stage;
        private Fix64 m_TotalTime;
        private Fix64 m_WaitTime;
        private Fix64 m_MoveTime;
        private Fix64 m_EffectScale;
        private FixVector3 m_Start2End;
        private FixVector3 m_BulletStartPos;
        private AtkAir m_AtkAir;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_Stage = Stage.Wait;
            m_BulletStartPos = endPos + NewGameData._FixUp * (Fix64)25;
            Fixv3LogicPosition = m_BulletStartPos;
            m_Start2End = endPos - m_BulletStartPos;
            m_TotalTime = Fix64.Zero;
            m_WaitTime = IntArg3;
            m_MoveTime = IntArg4;
            m_AtkAir = (AtkAir)(int)IntArg5;

            if (IntArg2 != Fix64.Zero)
            {
                m_EffectScale = IntArg1;
            }
            else
            {
                m_EffectScale = Fix64.One / 2;
            }

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });
            NewGameData._EffectFactory.CreateEffect(StringArg3, startPos, Fix64.Zero, Fix64.Zero);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_TotalTime += NewGameData._FixFrameLen;

            if (m_Stage == Stage.Wait)
            {
                if (m_TotalTime >= m_WaitTime)
                {
                    m_TotalTime = Fix64.Zero;
                    m_Stage = Stage.Move;
#if _CLIENTLOGIC_
                    CreateFromPrefab(StringArg1, (obj) => {
                        Trans.localScale = UnityEngine.Vector3.one * (float)m_EffectScale;
                    });
#endif
                }
            }
            else if (m_Stage == Stage.Move)
            {
                Fix64 t = m_TotalTime / m_MoveTime;
                Fixv3LogicPosition = m_BulletStartPos + FixMath.MoveStraight(t, m_Start2End);
                if (t >= Fix64.One)
                {
                    m_TotalTime = Fix64.Zero;
                    m_Stage = Stage.Do;
                }
            }
            else
            {
                DoSkill();
                NewGameData._EntityManager.BeKill(this);
            }
        }

        public void DoSkill()
        {
#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, m_EffectScale, Fix64.Zero);
#endif
            GroupType selfGroup = GroupType.PlayerGroup;
            if (OriginEntity != null)
            {
                selfGroup = OriginEntity.Group;
            }

            var entityList = GameTools.GetTargetGroup(selfGroup, TargetGroup);

            foreach (var entity in entityList)
            {
                if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                    continue;

                if (FixMath.CircularRegion(entity.Fixv3LogicPosition, EndPos, IntArg1 + entity.Radius))
                {
                    TriggerSkill(OriginEntity, entity);
                }
            }
        }

        public override void Release()
        {
            base.Release();
        }
    }
}