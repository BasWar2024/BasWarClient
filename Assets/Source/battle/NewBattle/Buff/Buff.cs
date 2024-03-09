

namespace Battle
{
    public class Buff : BuffBase
    {
        public override void Init(SkillBase originSkill, EntityBase target)
        {
            base.Init(originSkill, target);
            ElpaseTime = Fix64.Zero;
            TotalTime = Fix64.Zero;
            DoBuff();
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if (BKilled)
                return;

            if (TargetEntity.BKilled)
            {
                KillBuff();
            }

            if (LifeType == 1)
            {
                if (FixVector3.Distance(TargetEntity.Fixv3LogicPosition, SkillEntity.Fixv3LogicPosition) > SkillEntity.AtkRange + TargetEntity.Radius)
                {
                    KillBuff();
                }
            }

            ElpaseTime += NewGameData._FixFrameLen;
            TotalTime += NewGameData._FixFrameLen;

            if (ElpaseTime >= Frequency)
            {
                ElpaseTime -= Frequency;

                DoBuff();
            }

            if (TotalTime >= LifeTime)
            {
                KillBuff();
            }
        }

        private void DoBuff()
        {
            if (Hurt > 0)
            {
                NewGameData._FightManager.Attack(Hurt, TargetEntity);
            }

            if (Cure > 0)
            {
                NewGameData._FightManager.Cure(Cure, TargetEntity);
            }

            if (AddAtk != Fix64.Zero)
            {
                NewGameData._FightManager.ChangeAtk(TargetEntity, AddAtk);
            }

            if (AddAtkSpeed != Fix64.Zero)
            {
                NewGameData._FightManager.ChangeAtkSpeed(TargetEntity, AddAtkSpeed);
            }

            if (AddMoveSpeed != Fix64.Zero)
            {
                NewGameData._FightManager.ChangeMoveSpeed(TargetEntity, AddMoveSpeed);
            }

            if (StopAction == Fix64.Zero)
            {
                NewGameData._FightManager.StopAction(TargetEntity);
            }
        }

        private void KillBuff()
        {
            if (AddAtk != Fix64.Zero)
            {
                NewGameData._FightManager.ResetAtk(TargetEntity);
            }

            if (AddAtkSpeed != Fix64.Zero)
            {
                NewGameData._FightManager.ResetAtkSpeed(TargetEntity);
            }

            if (AddMoveSpeed != Fix64.Zero)
            {
                NewGameData._FightManager.ResetMoveSpeed(TargetEntity);
            }

            if (StopAction == Fix64.Zero)
            {
                NewGameData._FightManager.ResetStopAction(TargetEntity);
            }

            NewGameData._EntityManager.BeKill(this);
            //BKilled = true;
            CanRelease = true;
        }
    }
}
