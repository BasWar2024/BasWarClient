

namespace Battle
{
    public class TrapDelayAtkFsm : FsmState<EntityBase>
    {
        private Fix64 m_DelayTime;
        private Fix64 m_ElpaseTime;
        private TrapBase trap;
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            trap = owner as TrapBase;
            m_DelayTime = trap.DelayTime;
            m_ElpaseTime = Fix64.Zero;

#if _CLIENTLOGIC_
            owner.SpineAnim.SpineAnimPlay("attack", true);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_ElpaseTime += NewGameData._FixFrameLen;

            if (m_ElpaseTime >= m_DelayTime)
            {
                foreach (var solider in NewGameData._SoldierList)
                {
                    if (FixVector3.Distance(solider.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + solider.Radius)
                    {
                        NewGameData._BuffFactory.CreateBuff(trap.BuffModel, solider);
                    }
                }

                if (NewGameData._Hero != null)
                {
                    if (FixVector3.Distance(NewGameData._Hero.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + NewGameData._Hero.Radius)
                    {
                        NewGameData._BuffFactory.CreateBuff(trap.BuffModel, NewGameData._Hero);
                    }
                }

#if _CLIENTLOGIC_
                if(!string.IsNullOrEmpty(trap.EffectResPath))
                    NewGameData._EffectFactory.CreateEffect(trap.EffectResPath, owner.Fixv3LogicPosition);
#endif
                NewGameData._EntityManager.BeKill(owner);
            }

        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
