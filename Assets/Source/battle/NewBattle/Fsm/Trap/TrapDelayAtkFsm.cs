

namespace Battle
{
    public class TrapDelayAtkFsm : FsmState<EntityBase>
    {
        private Fix64 m_DelayTime;
        private Fix64 m_ElpaseTime;
        private TrapBase trap;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            trap = owner as TrapBase;
            m_DelayTime = trap.DelayTime;
            m_ElpaseTime = Fix64.Zero;

#if _CLIENTLOGIC_
            owner.SpineAnim.SpineAnimPlay(owner, "attack", true);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_ElpaseTime += NewGameData._FixFrameLen;

//            if (m_ElpaseTime >= m_DelayTime)
//            {
//                if (trap.BuffId != 0)
//                {
//                    foreach (var solider in NewGameData._SoldierList)
//                    {
//                        if (solider.IsInvisible())
//                            continue;

//                        if (solider is LandingShip) //""buff
//                            continue;

//                        if (FixVector3.Distance(solider.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + solider.Radius)
//                        {
//                            var newBuff = NewGameData._BuffFactory.CreateBuff(trap.BuffId, null, solider);
//                            solider.AddBuff(newBuff);
//                        }
//                    }

//                    //if (NewGameData._Hero != null)
//                    //{
//                    //    if (!NewGameData._Hero.CantBeAtk)
//                    //    {
//                    //        if (FixVector3.Distance(NewGameData._Hero.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + NewGameData._Hero.Radius)
//                    //        {
//                    //            NewGameData._BuffFactory.CreateBuff((BuffType)trap.BuffModel.type, trap.BuffModel, NewGameData._Hero);
//                    //        }
//                    //    }
//                    //}

//#if _CLIENTLOGIC_
//                    if (!string.IsNullOrEmpty(trap.EffectResPath))
//                        NewGameData._EffectFactory.CreateEffect(trap.EffectResPath, owner.Fixv3LogicPosition, Fix64.Zero,
//                            Fix64.Zero, null);

//                    AudioFmodMgr.instance.ActionPlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._AttackAudio, owner.Trans);
//#endif
//                }
//                NewGameData._EntityManager.BeKill(owner);
//            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
