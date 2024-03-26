
namespace Battle
{
    public class RangeMoreTargetSkill : SkillBase
    {
        private Fix64 m_TotalTime;
        private int m_Count;
        private int m_MaxCount;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_TotalTime = Fix64.Zero;
            m_Count = 0;
            m_MaxCount = (int)IntArg2;

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

            if (m_TotalTime >= IntArg3)
            {
                m_TotalTime -= IntArg3;

                DoSkill();
                m_Count++;
            }

            if (m_Count >= m_MaxCount)
            {
                NewGameData._EntityManager.BeKill(this);
            }
        }

        private void DoSkill()
        {
            var pos = EndPos + (IntArg4 == Fix64.Zero ? FixVector3.Zero : GameTools.RandomTargetPos(IntArg4));
            StartPos = OriginEntity.Fixv3LogicPosition + OriginEntity.Center +
                OriginEntity.AtkSkillShowRadius * FixMath.Vector3Rotate(NewGameData._FixForword, OriginEntity.AngleY);

            if (SkillEffectCfgId != 0)
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity,
                    StartPos.x, StartPos.y, StartPos.z, pos.x, pos.y, pos.z);
            }
        }
    }
}
