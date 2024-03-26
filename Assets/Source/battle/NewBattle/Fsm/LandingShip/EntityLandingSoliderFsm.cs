

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
#endif
    public class EntityLandingSoliderFsm : FsmState<EntityBase>
    {
        private LandingShip m_Ship;
        private Fix64 m_ElpaseTime;
        private Fix64 m_Frequency = (Fix64)0.15;
        private Fix64 m_LandingRadius = (Fix64)2.3;
        private Fix64 m_StopSwitchTime = (Fix64)1;

        private Fix64 m_LandingTime;
        private Fix64 m_TotalTime;
        private bool m_IsLanding;
        private bool m_StartLandSoldier;
        private OperOrder m_OperOrder;
        private LandingShip m_LandingShip;

#if _CLIENTLOGIC_
        //private Animator shipAnimator;
#endif

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_Ship = owner as LandingShip;
            //m_Ship.IsLanding = true;
            m_ElpaseTime = Fix64.Zero;
            m_LandingTime = Fix64.Zero;
            m_TotalTime = Fix64.Zero;
            m_IsLanding = true;
            m_StartLandSoldier = false;
            if (m_Ship.SoliderModel != null)
            {
                m_LandingTime = m_Ship.SoliderModel.amount * m_Frequency + 2 + m_StopSwitchTime;
            }
            else if (m_Ship.HeroModel != null)
            {
                m_LandingTime = (Fix64)2 + m_StopSwitchTime;
            }

            m_LandingShip = owner as LandingShip;
            m_OperOrder = m_LandingShip.LandingSoliderOperOrder;
#if _CLIENTLOGIC_

            //m_LandingShip.LandHalo.gameObject.SetActive(true);
            //shipAnimator = owner.Trans.Find("body").GetComponent<Animator>();
            owner.Anim?.SetInteger("anim", (int)animStage.standby);
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_ElpaseTime += NewGameData._FixFrameLen;
            m_TotalTime += NewGameData._FixFrameLen;

            if (m_ElpaseTime >= m_StopSwitchTime) {
                m_StartLandSoldier = true;
                m_ElpaseTime -= m_StopSwitchTime;
#if _CLIENTLOGIC_
                owner.Anim?.SetInteger("anim", (int)animStage.exit);
#endif
            }

            if (m_IsLanding)
            {
                if (!m_StartLandSoldier) {
                    return;
                }

                if (m_ElpaseTime >= m_Frequency)
                {
                    m_ElpaseTime -= m_Frequency;

                    //var targetPos = new FixVector3(owner.Fixv3LogicPosition.x, Fix64.Zero, owner.Fixv3LogicPosition.z) + GameTools.RandomTargetPos(m_LandingRadius);
                    var targetPos = new FixVector3(m_LandingShip.LandPos.x, Fix64.Zero, m_LandingShip.LandPos.z) + GameTools.RandomTargetPos(NewGameData._LandingRadius);

                    if (m_Ship.SoliderModel != null)
                    {
                        if (m_Ship.Amount <= 0)
                            return;

                        SoliderType soliderType = m_Ship.SoliderModel.type == 1 ? SoliderType.LandSolider :
                            (m_Ship.SoliderModel.type == 8 ? SoliderType.LandSolider16Dir : SoliderType.Tank);
                        var solider = NewGameData._SoliderFactory.CreateSolider(soliderType, targetPos, m_Ship.SoliderModel);

                        solider.OperOrder = m_OperOrder;
                        m_Ship.Amount--;
                    }
                    else if (m_Ship.HeroModel != null)
                    {
                        if (m_Ship.Amount <= 0)
                            return;

                        m_Ship.Amount--;

                        HeroModel model = m_Ship.HeroModel;
                        var solider = NewGameData._HeroFactory.CreateHero(SoliderType.LandHero, targetPos, model);
                    }
                }

                if (m_TotalTime >= m_LandingTime)
                {
                    m_IsLanding = false;
                    m_TotalTime = Fix64.Zero;

                    //NewGameData._LandingShipPosDict.Remove(owner);
#if _CLIENTLOGIC_
                    m_Ship.LandHaloSkeletonAnim?.SpineAimPlayAuto0Turn("dead", false);
#endif
                }
            }
            else
            {
                if (m_TotalTime >= (Fix64)1)
                {
//#if _CLIENTLOGIC_
//                    owner.Anim?.SetInteger("anim", (int)animStage.move);
//#endif
                    owner.Fsm.ChangeFsmState<EntityLandingShipIdle>();
                    //owner.Fsm.ChangeFsmState<EntityAirSoliderReturnFsm>();
                }
            }

        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);

            m_LandingShip = null;
#if _CLIENTLOGIC_
            m_Ship.LandHaloPs.gameObject.SetActive(false);
            m_Ship.ReleaseLandHalo();
#endif
            m_Ship = null;
        }


    }
}
