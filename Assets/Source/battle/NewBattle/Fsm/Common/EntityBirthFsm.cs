


namespace Battle
{
#if _CLIENTLOGIC_
    using Spine.Unity;
#endif

    public class EntityBirthFsm : FsmState<EntityBase>
    {
        private Fix64 m_Birth = (Fix64)0.667;
        private Fix64 m_Time;
#if _CLIENTLOGIC_
        private bool m_IsPlayAnim;
#endif

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            var buff = NewGameData._BuffFactory.CreateTempBuff();
            buff.LifeTime = m_Birth;
            owner.AddBuff(buff);
            NewGameData._BuffManager.Invincible(buff, null, owner);

            owner.CanUseSkill = false;
            m_Time = Fix64.Zero;

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._BeginAudio, owner.Trans);
            m_IsPlayAnim = false;
            owner.ChangeHpColor(owner.FixHp / owner.FixOriginHp);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
            m_Time += NewGameData._FixFrameLen;
            if (m_Time >= m_Birth)
            {
                owner.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
            }

#if _CLIENTLOGIC_

            if (m_IsPlayAnim)
                return;

            if (owner.Trans != null)
            {
                if (owner.ModelType == ModelType.Model2D)
                {
                    owner.SpineAnim.SpineAimPlayAuto0Turn("birth", false, 0, "idle");
                }
                else if (owner.ModelType == ModelType.Model2D_Tank)
                {
                    Tank tank = owner as Tank;
                    tank.GunSpineAnim.SpineAimPlayAuto0Turn("birth", false, 0, "idle");
                    tank.SpineAnim.SpineAimPlayAuto0Turn("birth", false, 0, "idle");
                }

                owner.Trans.Find("Eff/Eff_birth").gameObject.SetActive(true);

                m_IsPlayAnim = true;
            }
#endif
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
            owner.CanUseSkill = true;
#if _CLIENTLOGIC_
            owner.Trans?.Find("Eff/Eff_birth").gameObject.SetActive(false);
#endif
        }
    }
}
