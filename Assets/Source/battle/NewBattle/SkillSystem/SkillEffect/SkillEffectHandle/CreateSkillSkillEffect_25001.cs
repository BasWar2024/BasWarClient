
namespace Battle
{
    public class CreateSkillSkillEffect_25001 : SkillEffectBase
    {
        private Fix64[] m_PosArgs;

        public override void Init(SkillEffectModel model, EntityBase originEntity, EntityBase targetEntity, Buff buff, params Fix64[] args)
        {
            base.Init(model, originEntity, targetEntity, buff, args);

            m_PosArgs = args;
        }


        public override void Start()
        {
            base.Start();

            CreateSkill();
        }

        public override void Update()
        {
            base.Update();

            CreateSkill();
        }

        private void CreateSkill()
        {
            if (OriginEntity == null || OriginEntity.BKilled)
                return;

            FixVector3 startPos = OriginEntity.Fixv3LogicPosition;
            FixVector3 endPos = OriginEntity.Fixv3LogicPosition;

            if (m_PosArgs != null && m_PosArgs.Length == 6)
            {
                startPos = new FixVector3(m_PosArgs[0], m_PosArgs[1], m_PosArgs[2]);
                endPos = new FixVector3(m_PosArgs[3], m_PosArgs[4], m_PosArgs[5]);
            }
            NewGameData._SkillFactory.CreateSkill(startPos, endPos, OriginEntity, TargetEntity, NewGameData._SkillModelDict[skillCfgId]);
        }

        public override void Leave()
        {
            base.Leave();

            m_PosArgs = null;
        }
    }
}
