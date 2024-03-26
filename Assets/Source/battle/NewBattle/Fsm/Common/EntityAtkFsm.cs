
namespace Battle
{
    public class EntityAtkFsm : FsmState<EntityBase>
    {
        //private Fix64 m_AtkElpaseTime;

        private bool m_IsAtk; //true:""atk false:return
        private Fix64 m_ReadyAtkElpaseTime; //""
        private FixVector3 m_TargetCenter;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            //if (CheckIsInSmoke(owner)) {
            //    return;
            //}

            m_IsAtk = false;
            m_ReadyAtkElpaseTime = Fix64.Zero;

#if _CLIENTLOGIC_
            SetSpineAnimTimeScale(owner);
#endif
            InitAtkAnim(owner);
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            //if (CheckIsInSmoke(owner)) {
            //    return;
            //}

            if (owner.AtkElpaseTime >= owner.GetFixAtkSpeed())
            {
                if (!CheckLockTarget(owner))
                    return;

                owner.AtkElpaseTime = Fix64.Zero;

#if _CLIENTLOGIC_
                SetSpineAnimTimeScale(owner);
#endif
                if (owner.ModelType == ModelType.Model2D)
                {
                    if (owner is SoliderBase || owner is BuildingBase)
                    {
                        owner.AngleY = owner.UpdateSpineRenderRotation(AnimType.Atk);
#if _CLIENTLOGIC_
                        owner.SpineAnim.SpineAnimPlay(owner, "attack", false, 0, "idle_attack");
#endif
                    }
                }
                else if (owner.ModelType == ModelType.Model2D_Tank)
                {
                    Tank tank = owner as Tank;
                    tank.GunAngleY = owner.UpdateSpineRenderRotation(AnimType.Atk);
#if _CLIENTLOGIC_
                    tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "attack", false, 0, "idle_attack");
                    tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "idle", true, 0, "idle");
#endif
                }

                m_IsAtk = true;
            }


            if(m_IsAtk)
            {
                m_ReadyAtkElpaseTime += NewGameData._FixFrameLen;

                if (!CheckLockTarget(owner))
                    return;

                var atkSpeed = owner.GetFixAtkSpeed();
                if (m_ReadyAtkElpaseTime >= (atkSpeed >= Fix64.One ? owner.AtkReadyTime : owner.AtkReadyTime * owner.GetFixAtkSpeed()))
                {
                    m_IsAtk = false;
                    m_ReadyAtkElpaseTime = Fix64.Zero;
                    owner.BeforeAtkAction?.Invoke();

#if _CLIENTLOGIC_
                    AudioFmodMgr.instance.ActionPlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._AttackAudio, owner.Trans);
#endif
                    if (owner is SoliderBase)
                    {
                        var i = (int)NewGameData._Srand.Range(0, 10);
                        m_TargetCenter = owner.LockedAttackEntity.Fixv3LogicPosition + NewGameData._RandomAtkPoint[i];
                    }
                    else
                    {
                        m_TargetCenter = owner.LockedAttackEntity.Fixv3LogicPosition + owner.LockedAttackEntity.Center;
                    }

                    var angle = owner.AngleY;
                    if (owner.ModelType == ModelType.Model2D_Tank)
                    {
                        Tank tank = owner as Tank;
                        angle = tank.GunAngleY;
                    }

                    var model = NewGameData._SkillModelDict[owner.AtkSkillId];
                    if ((SkillType)model.type == SkillType.Laser)
                    {
                        if (owner.AtkLaserSkill == null)
                        {
                            var skill = CreateSkill(owner, angle, model);
                            owner.AtkLaserSkill = skill;
                        }
                    }
                    else
                    {
                        CreateSkill(owner, angle, model);
                    }

                    if (owner.IsDetonate)
                    {
                        NewGameData._EntityManager.BeKill(owner);
                        return;
                    }

                }
            }
        }

        private SkillBase CreateSkill(EntityBase owner, Fix64 angle, SkillModel model)
        {
            FixVector3 entityCenter = owner.Fixv3LogicPosition + owner.Center +
                owner.AtkSkillShowRadius * FixMath.Vector3Rotate(NewGameData._FixForword, angle);

            return NewGameData._SkillFactory.CreateSkill(entityCenter, m_TargetCenter, owner, owner.LockedAttackEntity, model);
        }

        private bool CheckLockTarget(EntityBase owner)
        {
            if (owner.LockedAttackEntity == null || owner.LockedAttackEntity.BKilled)
            {
                if (owner is SoliderBase)
                {
                    owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                }
                else if (owner is BuildingBase)
                {
                    owner.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
                }

                return false;
            }

            Fix64 distance = FixVector3.SqrMagnitude(owner.LockedAttackEntity.Fixv3LogicPosition - owner.Fixv3LogicPosition);
            if (distance > Fix64.Square(owner.AtkRange + owner.LockedAttackEntity.Radius))
            {
                if (owner is BuildingBase)
                {
                    owner.LockedAttackEntity = null;
                    return false;
                }
            }

            if (owner.InAtkRange != Fix64.Zero)
            {
                if (distance < Fix64.Square(owner.InAtkRange))
                {
                    owner.LockedAttackEntity = null;
                    return false;
                }
            }

            return true;
        }

        //private bool CheckIsInSmoke(EntityBase owner)
        //{
        //    if (owner.BuffBag.BuffAttrDict.TryGetValue(BuffAttr.Smoke, out BuffValueBag buffValueBag))
        //    {
        //        owner.Fsm.ChangeFsmState<EntityIdleFsm>();
        //        return true;
        //    }
        //    return false;
        //}
#if _CLIENTLOGIC_
        private void SetSpineAnimTimeScale(EntityBase owner)
        {
            if (owner.SpineAnim == null)
                return;

            if (owner.GetFixAtkSpeed() < Fix64.One)
            {
                owner.SpineAnim.timeScale = 1 / (float)owner.GetFixAtkSpeed();
            }
            else
            {
                owner.SpineAnim.timeScale = 1;
            }
        }
#endif

        private void InitAtkAnim(EntityBase owner)
        {

            if (owner.ModelType == ModelType.Model2D)
            {
                if (owner is SoliderBase || owner is BuildingBase)
                {
                    owner.AngleY = owner.UpdateSpineRenderRotation(AnimType.Atk);
#if _CLIENTLOGIC_
                    if (owner.SpineAnim != null)
                        owner.SpineAnim.SpineAnimPlay(owner, "idle_attack", true, 0);
#endif
                }
            }
            else if (owner.ModelType == ModelType.Model2D_Tank)
            {
                Tank tank = owner as Tank;
                tank.GunAngleY = owner.UpdateSpineRenderRotation(AnimType.Atk);
#if _CLIENTLOGIC_
                if (tank.GunSpineAnim != null)
                    tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "idle_attack", false, 0);
                if (tank.SpineAnim != null)
                    tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "idle", true, 0);
#endif
            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);

            if (owner.AtkLaserSkill != null)
            {
                NewGameData._EntityManager.BeKill(owner.AtkLaserSkill);
                owner.AtkLaserSkill = null;
            }

#if _CLIENTLOGIC_
            if (owner.SpineAnim != null)    
                owner.SpineAnim.timeScale = 1;
#endif
            if (owner.ModelType == ModelType.Model2D)
            {
                if (owner is SoliderBase || owner is BuildingBase)
                {
                    //owner.AngleY = owner.UpdateSpineRenderRotation(AnimType.Atk);
#if _CLIENTLOGIC_
                    owner.SpineAnim.SpineAnimPlay(owner, "idle", true, 0);
#endif
                }
            }
            else if (owner.ModelType == ModelType.Model2D_Tank)
            {
                Tank tank = owner as Tank;
#if _CLIENTLOGIC_
                if (tank.GunSpineAnim != null)
                    tank.GunSpineAnim.SpineTankAnimPlay((float)tank.GunAngleY, "idle_attack", false, 0);
                if (tank.SpineAnim != null)
                    tank.SpineAnim.SpineTankAnimPlay((float)tank.AngleY, "idle", true, 0);
#endif
            }
        }
    }
}