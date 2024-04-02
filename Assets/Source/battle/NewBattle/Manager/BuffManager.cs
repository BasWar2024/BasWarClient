
namespace Battle
{
    public class BuffManager
    {

        //""，""cfgid,""
        public void AddAtk(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (value == Fix64.Zero || buff == null || injured == null)
            {
                return;
            }

            Fix64 changeValue = injured.OriginFixAtk * value;
            PushBuffValue(injured, BuffAttr.AddAtk, buff, changeValue, BuffType.Sole_MaxValue);
#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""，""cfgid,""
        public void AddMoveSpeed(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (value == Fix64.Zero || buff == null || injured == null)
            {
                return;
            }

            Fix64 changeValue = injured.OriginMoveSpeed * value;
            PushBuffValue(injured, BuffAttr.AddMoveSpeed, buff, changeValue, BuffType.Sole_MaxValue);

#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""，""cfgid,""
        public void AddAtkSpeed(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (value == Fix64.Zero || buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.AddAtkSpeed, buff, value, BuffType.Sole_MaxValue);

#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""，""cfgid,""
        public void MinusAtk(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (value == Fix64.Zero || buff == null || injured == null)
            {
                return;
            }

            Fix64 changeValue = injured.OriginFixAtk * value;
            PushBuffValue(injured, BuffAttr.MinusAtk, buff, changeValue, BuffType.Sole_MinValue);

#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""，""cfgid,""
        public void MinusMoveSpeed(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (value == Fix64.Zero || buff == null || injured == null)
            {
                return;
            }

            Fix64 changeValue = injured.OriginMoveSpeed * value;
            PushBuffValue(injured, BuffAttr.MinusMoveSpeed, buff, changeValue, BuffType.Sole_MinValue);

#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""，""cfgid,""
        public void MinusAtkSpeed(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (value == Fix64.Zero || buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.MinusAtkSpeed, buff, value, BuffType.Sole_MinValue);

#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""
        public void StopAction(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null || injured.ImmuneBuff)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.StopAction, buff, Fix64.One, BuffType.Sole_Cover);

            FsmCompent<EntityBase> fsm = injured.Fsm;

            if (fsm != null && fsm.GetFsmState<EntityStopActionFsm>() != null)
            {
                fsm.ChangeFsmState<EntityStopActionFsm>();
            }
        }

        //""
        public void Invincible(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }
            PushBuffValue(injured, BuffAttr.Invincible, buff, Fix64.One, BuffType.Sole_Cover);
            NewGameData._FightManager.ReSetAttackMe(injured);
        }

        //"" ""
        public void Cloak(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }
            PushBuffValue(injured, BuffAttr.Cloak, buff, Fix64.One, BuffType.Sole_Cover);

            //injured.BeforeAtkAction += injured.RemoveCloakWhileAtk;
            NewGameData._FightManager.ReSetAttackMe(injured);
        }

        //Cfgid"",""，""
        public void Burn(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {

            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.Burn, buff, value, BuffType.SoleCfgid_MaxValue);
        }

        //""
        public void Shield(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.Shield, buff, value, BuffType.Sole);

#if _CLIENTLOGIC_
            injured.UpdateEntityMessage();
#endif
        }

        //""
        public void Bloodthirsty(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.Bloodthirsty, buff, Fix64.One, BuffType.Sole_Cover);
        }
        #region "" 
        //""，""cfgid,""
        //        public void AddMaxHp(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        //        {
        //            if (value == Fix64.Zero || buff == null || injured == null)
        //            {
        //                return;
        //            }
        //            BuffValue buffValue = GetAndSetEntityBuffValue(injured, BuffAttr.AddMaxHp, null, Fix64.Zero);
        //            Buff subBuff = buffValue.GetBuff();
        //            Fix64 changeValue = injured.FixOriginHp * value;

        //            if (subBuff != null)
        //            {
        //                Fix64 subValue = buffValue.GetValue();
        //                if (subValue <= changeValue)
        //                {
        //                    subBuff.TargetEntity = null;
        //                    if (subBuff.SkillEffect != null)
        //                    {
        //                        subBuff.SkillEffect.TargetEntity = null;
        //                    }

        //                    buffValue.Init(buff, changeValue);

        //                }
        //            }
        //            else
        //            {
        //                buffValue.Init(buff, changeValue);
        //            }

        //            injured.Cure(changeValue);
        //#if _CLIENTLOGIC_
        //            if (buff != null)
        //            {
        //                injured.AddBuffEffect(BuffAttr.AddMaxHp, buff.Model, Fix64.One);
        //            }
        //#endif
        //        }

        //""，""cfgid,""
        //public void MinusMaxHp(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        //{

        //}

        #endregion

        //"" ""
        public void AddStrengthAtk(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            Fix64 changeValue = injured.OriginFixAtk * value;
            PushBuffValue(injured, BuffAttr.StrengthenAtk, buff, changeValue, BuffType.Sole);
        }

        //"" ""
        public void AddStrengthGetHurt(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }
            PushBuffValue(injured, BuffAttr.StrengthenGetHurt, buff, value, BuffType.Sole);
        }


        //""
        public void Smoke(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }
            PushBuffValue(injured, BuffAttr.Smoke, buff, Fix64.One, BuffType.Sole_Cover);

            NewGameData._FightManager.ReSetAttackMe(injured);
        }

        //""
        public void Cure(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (injured == null)
            {
                return;
            }

            if (buff == null)
            {
                NewGameData._FightManager.Cure(value, injured);
            }
            else
            {
                PushBuffValue(injured, BuffAttr.Cure, buff, Fix64.Zero, BuffType.Sole);
            }
        }

        //""cfgid,""
        public void AddFixValueAtk(Fix64 value, Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.AddFixValueAtk, buff, value, BuffType.Sole_MaxValue);
        }

        //"" ""
        public void Sneer(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.Sneer, buff, Fix64.One, BuffType.Sole_Cover);

        }

        //"" ""
        public void BounceAtk(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.BounceAtk, buff, Fix64.One, BuffType.Sole_Cover);
        }

        //""buff""
        public void AddNoBuffAtk(Fix64 value, EntityBase releaser, EntityBase injured)
        {
            if (injured == null)
                return;

            injured.FixNoBuffAtk += value;
        }


        public void AddOrderBuff(Buff buff, EntityBase releaser, EntityBase injured)
        {
            if (buff == null || injured == null)
            {
                return;
            }

            PushBuffValue(injured, BuffAttr.Order, buff, Fix64.One, BuffType.Sole);
        }

        private void PushBuffValue(EntityBase entity, BuffAttr attrType, Buff buff, Fix64 value, BuffType buffType)
        {
            entity.BuffBag.PushBuffValue(attrType, buff, value, buffType);
        }

        public void Release()
        {

        }
    }
}
