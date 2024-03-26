
namespace Battle
{
    public class CreateBuffSkillEffect_25000 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            CreateBuff();
        }

        public override void Update()
        {
            base.Update();
            CreateBuff();
        }

        private void CreateBuff()
        {
            if (TargetEntity.ImmuneBuff || TargetEntity.BKilled)
                return;

            var addBuff = NewGameData._BuffFactory.CreateBuff(SkillEffModel.buffCfgId, OriginEntity, TargetEntity);
            TargetEntity.AddBuff(addBuff);
        }
    }
}
