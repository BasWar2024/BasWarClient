
namespace Battle
{
    using System;
    using System.Collections.Generic;

#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class EntityBase : GameObjectBase
    {
        public FsmCompent<EntityBase> Fsm;

        public int CfgId;
        public int Race;
        public long Id;
        public int Quality;
        public int ArmyIndex;
        public bool IsHero;
        public Fix64 SkillAnimTime;

        public GroupType Group = GroupType.None;

        public Fix64 FixOriginHp = Fix64.Zero;
        public Fix64 FixHp = Fix64.Zero;
        public Fix64 PassiveSkillMaxHp = Fix64.Zero; //""

        public Fix64 OriginFixAtk = Fix64.Zero;
        public Fix64 PassiveSkillFixAtk = Fix64.Zero; //""

        public Fix64 OriginMoveSpeed = Fix64.Zero;
        public Fix64 PassiveSkillMoveSpeed = Fix64.Zero; //""

        public Fix64 OriginAtkSpeed = Fix64.Zero;
        public Fix64 PassiveSkillAtkSpeed = Fix64.Zero; //""

        public Fix64 FixNoBuffAtk = Fix64.Zero; //""BUFF""

        //public Fix64 AroundDamageReduction = Fix64.Zero; //""

        //public Fix64 FixShield = Fix64.Zero; //""

        public FixVector3 Center; //""，""+Center""BUFF""

        public Fix64 AtkElpaseTime; //""，""AtkSpeed""。""stopAction""

        public Fix64 AtkRange = Fix64.Zero;
        public Fix64 InAtkRange = Fix64.Zero; //""

        public Fix64 AtkSkillShowRad; //"" 0：""，>0""

        public int AtkSkillId;
        public int AtkSkill1Id;
        public int BornSkillId;
        public int DeadSkillId;
        public int AroundSkillId;
        public Fix64 AtkSkillShowRadius;

        public int FirstAtk;

        public int AtkType;
        public Fix64 AtkReadyTime; //""

        public SignalState SignalState = SignalState.None;

        //""
        public List<EntityBase> ListAttackMe;

        //""
        public EntityBase LockedAttackEntity = null;
        public BattlePos BattlePos;

        //""
        public List<ASPoint> ListMovePath;

        //""
        public FixVector3 TargetPos;
        //""
        public FixVector3 OriginPos;

        //""
        public string DeadEffect;

        public bool IsInTheSky = false; //""
        public Fix64 FlashMoveDelayTime = Fix64.Zero; //""，"" 0：""； ""0：""；
        public bool IsDetonate = false; //""
        public AtkAir AtkAir = AtkAir.AtkBoth; //""
        public BuildingAroundPoint BuildAroundPoint; //""
        public Fix64 VanishTime; //0：""， ""0，""
        public SkillBase AtkLaserSkill; //""（""skillBase）
        public bool ImmuneBuff = false; //""buff
        public bool CanUseSkill = true; //""

        //------------------""
        public BuffBag BuffBag;

        public Action AtkAction; //""
        public Action BeforeAtkAction; //""
        public Action ChangeAtkTargetAction; //""
        public Action DeadAction; //""
        public Action<FixVector3> RebuildAction; //""，""
        public Action<EntityBase, Fix64> BeAtkAction; //""
        public Action<Fix64> LowHpAction; //""

#if _CLIENTLOGIC_
        public Fix64 HurtColorTime; //""
#endif

        public bool IsSummonSoldier; //""

        public Fix64 GetFixAtk()
        {
            Fix64 value = OriginFixAtk;
            value += BuffBag.GetSoloBuffAttrValue(BuffAttr.AddAtk);
            value -= BuffBag.GetSoloBuffAttrValue(BuffAttr.MinusAtk);
            value += BuffBag.GetSoloBuffAttrValue(BuffAttr.AddFixValueAtk);
            value += BuffBag.GetMultBuffAttrValue(BuffAttr.StrengthenAtk);
            value += FixNoBuffAtk;
            value += PassiveSkillFixAtk;
            return value;
        }
        
        public Fix64 GetFixAtkSpeed()
        {
            Fix64 value = Fix64.Zero;
            value += BuffBag.GetSoloBuffAttrValue(BuffAttr.AddAtkSpeed);
            value -= BuffBag.GetSoloBuffAttrValue(BuffAttr.MinusAtkSpeed);
            value += PassiveSkillAtkSpeed;

            if (value <= -(Fix64)1)
                value = -(Fix64)0.99;

            value = OriginAtkSpeed / (1 + value);
            //Fix64 value = OriginAtkSpeed;
            //value -= BuffBag.GetSoloBuffAttrValue(BuffAttr.AddAtkSpeed);
            //value += BuffBag.GetSoloBuffAttrValue(BuffAttr.MinusAtkSpeed);
            //value -= PassiveSkillAtkSpeed;
            return value;
        }

        public Fix64 GetFixMoveSpeed()
        {
            Fix64 value = OriginMoveSpeed;
            value += BuffBag.GetSoloBuffAttrValue(BuffAttr.AddMoveSpeed);
            value -= BuffBag.GetSoloBuffAttrValue(BuffAttr.MinusMoveSpeed);
            value += PassiveSkillMoveSpeed;
            return value;
        }

 		public Fix64 AtkShield(Fix64 atkValue)
        {
            if (atkValue <= Fix64.Zero) {
                return atkValue;
            }

            if (BuffBag.BuffAttrDict.TryGetValue(BuffAttr.Shield, out List<BuffValue> buffValues))
            {
                if (buffValues.Count == 0)
                    return atkValue;

                Fix64 afterShieldAtkValue = atkValue;
                foreach (BuffValue buffValue in buffValues)
                {
                    Fix64 shield = buffValue.GetValue();
                    afterShieldAtkValue = afterShieldAtkValue - shield;

                    if (afterShieldAtkValue > 0)
                    {
                        buffValue.SetValue(Fix64.Zero);
                        buffValue.GetBuff().IsEnd = true;
                    }
                    else
                    {
                        buffValue.SetValue(Fix64.Abs(afterShieldAtkValue));
                        afterShieldAtkValue = Fix64.Zero;
                        break;
                    }
                }
#if _CLIENTLOGIC_
                if (NewGameData._IsShowBattleDetail)
                {
                    EntityHpChange.ShowShield(this, atkValue - afterShieldAtkValue);
                }
#endif

                return afterShieldAtkValue;
            }
            else
            {
                return atkValue;
            }
        }

        public void GetHurt(Fix64 atkValue)
        {
            atkValue += BuffBag.GetMultBuffAttrValue(BuffAttr.StrengthenGetHurt) * atkValue;

            Fix64 afterShieldHurt = AtkShield(atkValue);
#if _CLIENTLOGIC_
            Fix64 oldHp = FixHp;
#endif

            FixHp -= Fix64.Max(afterShieldHurt, Fix64.Zero);

#if _CLIENTLOGIC_
            if (oldHp > FixHp && !IsCloak())
            {
                if (ModelType == ModelType.Model2D)
                {
                    Color color = SpineAnim.GetColor();
                    SpineAnim?.SetColor(new Color(NewGameData.HurtColor.r, NewGameData.HurtColor.g, NewGameData.HurtColor.b, color.a));
                    HurtColorTime = NewGameData.HoldHurtColorTime + NewGameData.ResetColorTime;
                }
            }

            if (ObjType == ObjectType.Soldier)
            {
                ChangeHpColor(FixHp / FixOriginHp);
            }

            UpdateHpSprite();

            if (NewGameData._IsShowBattleDetail) {
                EntityHpChange.ShowHp(this, -afterShieldHurt);
            }
            UpdateEntityMessage();

#endif
        }

        public Fix64 GetFixMaxHp()
        {
            return FixOriginHp;
        }

        public void Cure(Fix64 count)
        {
            FixHp += count;
            FixHp = Fix64.Min(FixHp, GetFixMaxHp());

#if _CLIENTLOGIC_
            if (ObjType == ObjectType.Soldier)
            {
                ChangeHpColor(FixHp / FixOriginHp);
            }

            UpdateHpSprite();

            if (NewGameData._IsShowBattleDetail)
            {
                EntityHpChange.ShowHp(this, count);
            }
            UpdateEntityMessage();
#endif
        }

        public bool IsInvisible()
        {
            if (BuffBag.GetSoloBuffAttrValue(BuffAttr.Invincible) == Fix64.One)
                return true;
            else
                return false;
        }

        public bool IsCloak()
        {
            if (BuffBag.GetSoloBuffAttrValue(BuffAttr.Cloak) == Fix64.One)
                return true;
            else
                return false;
        }

        public bool IsStopAction()
        {
            if (BuffBag.GetSoloBuffAttrValue(BuffAttr.StopAction) == Fix64.One)
                return true;
            else
                return false;
        }

        public bool IsSmoke()
        {
            if (BuffBag.GetSoloBuffAttrValue(BuffAttr.Smoke) == Fix64.One)
                return true;
            else
                return false;
        }

        public void AddBuff(Buff buff)
        {
            if (!BKilled)
            {
                BuffBag.PushBag(buff);
            }
        }

        public virtual void Release()
        {
            BuffBag?.Release();
            ReleaseGameObj();

            ListAttackMe?.Clear();
            LockedAttackEntity = null;
            ListMovePath = null;
            BuildAroundPoint = null;
            DeadEffect = null;
            AtkAction = null;
            BeforeAtkAction = null;
            ChangeAtkTargetAction = null;
            BattlePos = null;
            AtkLaserSkill = null;
            DeadAction = null;
            RebuildAction = null;
            AtkSkillId = 0;
            BornSkillId = 0;
            DeadSkillId = 0;
            AroundSkillId = 0;
            SkillAnimTime = Fix64.Zero;
            BeAtkAction = null;
            LowHpAction = null;

            NewGameData._PoolManager.Push(this);
        }

        public override void Init()
        {
            base.Init();

            if (ListAttackMe == null)
                ListAttackMe = new List<EntityBase>();

            if (BuffBag == null)
                BuffBag = new BuffBag();

            CfgId = 0;
            TargetPos = FixVector3.Zero;
            OriginPos = FixVector3.Zero;
            IsInTheSky = false;
            FlashMoveDelayTime = Fix64.Zero;
            IsDetonate = false;
            AtkAir = AtkAir.AtkBoth;
            AtkType = 0;
            AtkReadyTime = Fix64.Zero;
            BuildAroundPoint = null;
            DeadEffect = null;
            LockedAttackEntity = null;
            Group = GroupType.None;
            FixOriginHp = Fix64.Zero;
            FixHp = Fix64.Zero;
            OriginFixAtk = Fix64.Zero;
            OriginMoveSpeed = Fix64.Zero;
            OriginAtkSpeed = Fix64.Zero;
            AtkAction = null;
            Center = FixVector3.Zero;
            AtkRange = Fix64.Zero;
            VanishTime = Fix64.Zero;
            AtkSkillShowRadius = Fix64.Zero;
            AtkSkillId = 0;
            AtkSkill1Id = 0;
            SignalState = SignalState.None;
            AtkElpaseTime = Fix64.Zero;
            AtkLaserSkill = null;
            FirstAtk = 0;
            InAtkRange = Fix64.Zero;
            AtkSkillShowRad = Fix64.Zero;
            BornSkillId = 0;
            DeadSkillId = 0;
            AroundSkillId = 0;
            PassiveSkillMaxHp = Fix64.Zero;
            PassiveSkillFixAtk = Fix64.Zero;
            PassiveSkillMoveSpeed = Fix64.Zero;
            PassiveSkillAtkSpeed = Fix64.Zero;
            DeadAction = null;
            RebuildAction = null;
            SkillAnimTime = Fix64.Zero;
            ImmuneBuff = false;
            BeAtkAction = null;
            FixNoBuffAtk = Fix64.Zero;
            LowHpAction = null;
            CanUseSkill = true;
            //AroundDamageReduction = Fix64.Zero;

#if _CLIENTLOGIC_
            HurtColorTime = Fix64.Zero;
#endif
            IsSummonSoldier = false;
            BattlePos = null;
            BuffBag.Init(this);
        }

        public virtual void Dead()
        {
            Fsm?.ChangeFsmState<EntityDeadFsm>();
        }

        public override void Start()
        {
            base.Start();

            UpdateRenderPosition(0);
            RecordLastPos();
#if _CLIENTLOGIC_
            RecordLastRotation();
#endif

            if (NewGameData._SkillModelDict.TryGetValue(BornSkillId, out SkillModel skillModel))
            {
                NewGameData._SkillFactory.CreateSkill(Fixv3LogicPosition, Fixv3LogicPosition, this, null, skillModel);
            }

            TriggerPassiveSkillAttr();
        }

        private void TriggerPassiveSkillAttr()
        {
            foreach (PassiveSkillAttr passiveSkillAttr in NewGameData._PassiveSkillList)
            {
                bool boolValue1 = false;
                if ((passiveSkillAttr.Range == 1 && !IsHero && passiveSkillAttr.ArmyIndex == ArmyIndex) ||
                    (passiveSkillAttr.Range == 2 && IsHero && passiveSkillAttr.ArmyIndex == ArmyIndex) ||
                    (passiveSkillAttr.Range == 3 && passiveSkillAttr.ArmyIndex == ArmyIndex) ||
                    (passiveSkillAttr.Range == 4 && !IsHero) ||
                    (passiveSkillAttr.Range == 5 && IsHero) ||
                    (passiveSkillAttr.Range == 6))
                {
                    boolValue1 = true;
                }

                if (boolValue1)
                {
                    if (passiveSkillAttr.Race == -1 ||
                        passiveSkillAttr.Race == Race)
                    {
                        AddPassiveSkillAttr(passiveSkillAttr);
                    }
                }
            }

            FixOriginHp += PassiveSkillMaxHp;
            FixHp += PassiveSkillMaxHp;
        }

        private void AddPassiveSkillAttr(PassiveSkillAttr attr)
        {
            switch (attr.AttrType)
            {
                case Attr.Atk:
                    PassiveSkillFixAtk += OriginFixAtk * attr.Value;
                    break;
                case Attr.MoveSpeed:
                    PassiveSkillMoveSpeed += OriginMoveSpeed * attr.Value;
                    break;
                case Attr.AtkSpeed:
                    PassiveSkillAtkSpeed += attr.Value;
                    break;
                case Attr.Hp:
                    PassiveSkillMaxHp += FixOriginHp * attr.Value;
                    break;
            }
        }

        public virtual void UpdateLogic()
        {
            BuffBag.UpdateLogic();

            AtkElpaseTime += NewGameData._FixFrameLen;

#if _CLIENTLOGIC_
            if (HurtColorTime > Fix64.Zero)
            {
                HurtColorTime -= NewGameData._FixFrameLen;

                if (HurtColorTime >= NewGameData.ResetColorTime) //""
                {

                }
                else if (HurtColorTime > Fix64.Zero) //""
                {
                    Color color = Color.Lerp(NewGameData.OriginColor, NewGameData.HurtColor, (float)(HurtColorTime / NewGameData.ResetColorTime));
                    SpineAnim.SetColor(color);
                }
                else
                {
                    SpineAnim.SetColor(NewGameData.OriginColor);
                    HurtColorTime = Fix64.Zero;
                }
            }
#endif
        }

        public void UpdateRenderPosition(float interpolation)
        {
#if _CLIENTLOGIC_
            if (BKilled || GameObj == null)
            {
                return;
            }

            if (Fixv3LastPosition == FixVector3.Zero)
                return;

            if (interpolation != 0)
            {
                Trans.localPosition = Vector3.Lerp(Fixv3LastPosition.ToVector3(), Fixv3LogicPosition.ToVector3(), interpolation);

                //UpdateRenderRotation(interpolation);
            }
            else
            {
                Trans.localPosition = Fixv3LogicPosition.ToVector3();
            }
#endif
        }

//#if _CLIENTLOGIC_
//        public virtual void UpdateRenderRotation(float interpolation)
//        {
//            if (IsInTheSky && this.ModelType == ModelType.Model3D && LastRotation != CurrRotation)
//            {
//                Trans.rotation = Quaternion.Slerp(LastRotation, CurrRotation, interpolation);
//            }
//        }
//#endif

        public Fix64 SetAngleY(FixVector3 self2lock)
        {
            self2lock.Normalize();
            Fix64 model = FixVector3.Model(self2lock);
            Fix64 dot = FixVector3.Dot(self2lock, NewGameData._FixForword);
            if (model == Fix64.Zero)
                model = (Fix64)0.01;
            Fix64 cos = dot / model;
            Fix64 angle = Fix64.ACos(cos) * 180 / Fix64.PI;
            Fix64 dotRight = FixVector3.Dot(self2lock, NewGameData._FixRight);

            if (dotRight > 0)
            {
                angle = 360 - angle;
            }

            return angle;
        }

        //""
        public Fix64 UpdateSoliderCos(AnimType animType)
        {
            var self2lock = animType == AnimType.Atk || animType == AnimType.FlashIdle ? LockedAttackEntity.Fixv3LogicPosition - Fixv3LogicPosition : Fixv3LogicPosition - Fixv3LastPosition;
            if (self2lock == FixVector3.Zero)
                return AngleY;
            return SetAngleY(self2lock);
        }

        //""
        public Fix64 UpdateBuildingCos()
        {
            var self2lock = LockedAttackEntity.Fixv3LogicPosition - Fixv3LogicPosition;
            if (self2lock == FixVector3.Zero)
                return AngleY;
            return SetAngleY(self2lock);
        }

        // ""Spine""，""rad""
        public Fix64 UpdateSpineRenderRotation(AnimType animType)
        {
            if (LockedAttackEntity == null)
                return Fix64.Zero;

            if (Direction == 0)
                return Fix64.Zero;

            if (ObjType == ObjectType.Soldier)
                return UpdateSoliderCos(animType);
            else if (ObjType == ObjectType.Tower)
                return UpdateBuildingCos();

            return Fix64.Zero;
        }

#if _CLIENTLOGIC_

        public void UpdateHpSprite()
        {
            if (HpSprite == null)
                return;

            HpSprite.size = new Vector2(0.75f * (float)FixHp / (float)GetFixMaxHp(), HpSprite.size.y);
        }

        public void UpdateHpSprite(Fix64 maxHp)
        {
            if (HpSprite == null)
                return;

            HpSprite.size = new Vector2(0.75f * (float)FixHp / (float)maxHp, HpSprite.size.y);
        }

        protected override void OnCreateFromPrefab()
        {
            UpdateEntityMessage();
        }

        public void UpdateEntityMessage()
        {
            if (!NewGameData._IsShowBattleDetail || MessageText == null) {
                return;
            }

            string text = "";
            if (EditModel.EditBattleTools.IsShowHp)
            {
                text += $"<color=#ffffff>{Math.Round((float)FixHp, 2)}/{Math.Round((float)GetFixMaxHp(), 2)}</color> \n";
            }
            text += $"<color=#FFE42D>{Math.Round((float)GetFixAtk(), 2)}</color> ";
            text += $"<color=#FFB22D>{Math.Round((float)GetFixAtkSpeed(), 2)}</color> ";
            text += $"<color=#000000>{Math.Round((float)GetFixMoveSpeed(), 2)}</color> ";

            Fix64 shield = BuffBag.GetMultBuffAttrValue(BuffAttr.Shield);
            text += $"<color=#1FDCF1>{Math.Round((float)shield, 2)}</color> ";

            MessageText.text = text;
            //HpSprite.size = new Vector2(0.75f * (float)FixHp / (float)maxHp, HpSprite.size.y);
        }
#endif

        /// <summary>
        /// ""
        /// </summary>
        public virtual void LoadProperties()
        {

        }

        //- ""
        // 
        // @return none.
        public void RecordLastPos()
        {
            Fixv3LastPosition = Fixv3LogicPosition;
        }

#if _CLIENTLOGIC_
        //""，""3D""
        public void RecordLastRotation()
        {
            LastRotation = CurrRotation;
        }


        public virtual void RefreshAtkRange()
        {
            if (this is BuildingBase) {
                if (EditModel.EditBattleTools.IsTowerAtkRange)
                {
                    DrawTool.DrawCircle(Trans, Trans.position + Center.ToVector3(), (float)AtkRange);

                }
                else {
                    DrawTool.DrawCircle(Trans, Trans.position + Center.ToVector3(), 0);
                }
            }

        }
#endif
    }
}
