
//namespace Battle
//{
//    //""
//    public class EntityInhalationAtkFsm : FsmState<EntityBase>
//    {
//        private Fix64 m_AtkElpaseTime;

//        public override void OnEnter(EntityBase owner)
//        {
//            base.OnEnter(owner);
//            m_AtkElpaseTime = owner.AtkSpeed;

//#if _CLIENTLOGIC_
//            //DrawTool.DrawCircle(owner.GameObj.transform, owner.Fixv3LogicPosition.ToVector3(), (float)owner.AttackRange);
//#endif
//        }

//        public override void OnUpdate(EntityBase owner)
//        {
//            base.OnUpdate(owner);

//            m_AtkElpaseTime += NewGameData._FixFrameLen;

//            if (m_AtkElpaseTime >= owner.AtkSpeed)
//            {
//                m_AtkElpaseTime -= owner.AtkSpeed;

//#if _CLIENTLOGIC_
//                AudioMgr.instance.PlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._AttackAudio, owner.Trans);
//#endif

//                if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled || owner.LockedAttackEntity.BuffBag.InvincibleBuff != null)
//                {
//                    owner.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
//                    return;
//                }

//#if _CLIENTLOGIC_
//                owner.SpineAnim.SpineAnimPlay(owner, "attack", true);
//#endif
//                //NewGameData._FightManager.StopAction(owner.LockedAttackEntity, null);
//                //NewGameData._FightManager.CantBeAtk(owner.LockedAttackEntity);
//                //NewGameData._BulletFactory.CreateInhalationBullet(owner, owner.LockedAttackEntity);
//            }
//        }
//        public override void OnLeave(EntityBase owner)
//        {
//            base.OnLeave(owner);
//        }
//    }

//}