

namespace Battle
{
    public class TornadoSkill : SkillBase
    {
        private Fix64 m_Range;
        private Fix64 m_Distance;
        private Fix64 m_OriginSpeed; //-at
        private Fix64 m_MoveTime;
        private FixVector3 m_Forword;
        private Fix64 m_Frequency;

        private Fix64 m_TotalTime;
        private Fix64 m_Time;
        private Fix64 m_A; //"": a=(v-v0)/t 2s/tt
        private Fix64 m_LifeTime;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_Range = IntArg1;
            m_Distance = IntArg2;
            m_MoveTime = IntArg3;
            m_Frequency = IntArg4;
            m_Time = Fix64.Zero;
            m_TotalTime = Fix64.Zero;
            m_A = m_Distance * 2 / (m_MoveTime / 2 * m_MoveTime / 2);
            m_OriginSpeed = -m_A * m_MoveTime / 2;
            m_LifeTime = m_MoveTime;
            m_Forword = (targetEntity.Fixv3LogicPosition - originEntity.Fixv3LogicPosition).GetNormalized();

            //""
            OriginEntity.Fsm.ChangeFsmState<EntityDisappearFsm>();
            Buff buff = NewGameData._BuffFactory.CreateTempBuff();
            buff.LifeTime = m_LifeTime;
            OriginEntity.AddBuff(buff);
            NewGameData._BuffManager.Invincible(buff, null, OriginEntity);

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, (obj) => {
                obj.transform.localScale = new UnityEngine.Vector3((float)m_Range, (float)m_Range, (float)m_Range);
            });
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (OriginEntity == null || OriginEntity.BKilled)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            if (m_TotalTime >= m_LifeTime)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;
            Fixv3LogicPosition = StartPos + m_Forword * -MoveDistance(m_TotalTime);

            m_Time += NewGameData._FixFrameLen;
            if (m_Time >= m_Frequency)
            {
                DoSkill();
                m_Time -= m_Frequency;
            }
        }

        private void DoSkill()
        {
            var entityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);
            foreach (var entity in entityList)
            {
                if (!GameTools.RangeSkillAirDefenseDetected(entity, AtkAir.AtkLand))
                    continue;

                if (FixMath.CircularRegion(Fixv3LogicPosition, entity.Fixv3LogicPosition, m_Range + entity.Radius))
                {
                    TriggerSkill(OriginEntity, entity);
                }
            }
        }

        //"": s= v0t+ 1/2att
        private Fix64 MoveDistance(Fix64 time)
        {
            return m_OriginSpeed * time + m_A * time * time / 2;
        }

        public override void Release()
        {
            if (OriginEntity != null)
            {
                if (OriginEntity.Fsm != null)
                {
                    OriginEntity.Fsm.ChangeFsmState<EntityIdleFsm>();
                }
            }

            base.Release();
        }
    }
}
