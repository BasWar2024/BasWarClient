
namespace Battle
{
    public class MoveSpeedSkillEffect_21000 : SkillEffectBase
    {
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.AddMoveSpeed(Args[0] / 1000, Buff, null, TargetEntity);
        }
    }
}
