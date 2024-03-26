

namespace Battle
{
    public class TrapIdleFsm : FsmState<EntityBase>
    {
        private TrapBase m_Trap;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_Trap = owner as TrapBase;
#if _CLIENTLOGIC_
            owner.SpineAnim.SpineAnimPlay(owner, "idle", true);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            foreach (var solider in NewGameData._SoldierList)
            {
                if (solider.IsInvisible())
                    continue;

                if (solider.IsInTheSky)
                    continue;

                if (FixVector3.Distance(solider.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= m_Trap.AlertRange + solider.Radius)
                {
                    owner.Fsm.ChangeFsmState<TrapDelayAtkFsm>();
                    return;
                }
            }

            //if (NewGameData._Hero != null)
            //{
            //    if (NewGameData._Hero.CantBeAtk)
            //        return;

            //    if (FixVector3.Distance(NewGameData._Hero.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= m_Trap.AlertRange + NewGameData._Hero.Radius)
            //    {
            //        owner.Fsm.ChangeFsmState<TrapDelayAtkFsm>();
            //    }
            //}

        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
