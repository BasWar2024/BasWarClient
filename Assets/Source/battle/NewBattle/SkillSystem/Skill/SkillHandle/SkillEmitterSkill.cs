
//""
namespace Battle
{
    public class SkillEmitterSkill : SkillBase
    {
        private int m_LaunchCount;
        private int m_MaxLaunchCount;
        private EntityBase m_LockTarget;
        private GroupType m_GroupType;
        private Fix64 m_AtkRange;
        private Fix64 m_InAtkRange;
        private Fix64 m_TotalTime;
        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_MaxLaunchCount = (int)IntArg1;
            m_LaunchCount = 0;
            m_LockTarget = targetEntity;
            m_GroupType = originEntity.Group;
            m_AtkRange = originEntity.AtkRange;
            m_InAtkRange = originEntity.InAtkRange;
            m_TotalTime = Fix64.Zero;
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (OriginEntity == null || OriginEntity.BKilled)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;

            if (m_TotalTime >= IntArg2)
            {
                m_TotalTime -= IntArg2;
                DoSkill();
            }
        }

        private void DoSkill()
        {
            if (m_LockTarget == null)
            {
                ChangeTarget();
            }

            if (SkillEffectCfgId != 0)
            {
                StartPos = OriginEntity.Fixv3LogicPosition + OriginEntity.Center +
                OriginEntity.AtkSkillShowRadius * FixMath.Vector3Rotate(NewGameData._FixForword, OriginEntity.AngleY);

                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, m_LockTarget,
                    StartPos.x, StartPos.y, StartPos.z, EndPos.x, EndPos.y, EndPos.z);
            }

            m_LaunchCount++;

            if (m_LaunchCount >= m_MaxLaunchCount)
            {
                NewGameData._EntityManager.BeKill(this);
            }
        }

        private void ChangeTarget()
        {
            var entityList = GameTools.GetTargetGroup(m_GroupType, TargetGroup);
            Fix64 minDistance = (Fix64)999999999;
            EntityBase nearestObj = null;
            foreach (var entity in entityList)
            {
                if (!GameTools.AirDefenseDetected(entity, OriginEntity))
                    continue;

                var distance = FixVector3.SqrMagnitude(entity.Fixv3LogicPosition - StartPos);
                if (distance <= Fix64.Square(m_AtkRange + entity.Radius))
                {
                    if (m_InAtkRange != Fix64.Zero && distance < Fix64.Square(m_InAtkRange))
                    {
                        continue;
                    }

                    if (distance < minDistance)
                    {
                        minDistance = distance;
                        nearestObj = entity;
                    }
                }
            }

            if (nearestObj != null)
            {
                m_LockTarget = nearestObj;
            }
        }

        public override void Release()
        {
            base.Release();
            m_LockTarget = null;
        }
    }
}
