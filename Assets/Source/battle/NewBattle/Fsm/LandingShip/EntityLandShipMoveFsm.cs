


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class EntityLandShipMoveFsm : FsmState<EntityBase>
    {
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime = (Fix64)1;
        private FixVector3 m_S2e;
#if _CLIENTLOGIC_
        private LandingShip m_LandingShip;
#endif

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_S2e = owner.TargetPos - owner.OriginPos;

#if _CLIENTLOGIC_
            m_LandingShip = owner as LandingShip;
#endif
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
            m_FixMoveElpaseTime += NewGameData._FixFrameLen;
            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;
            owner.Fixv3LogicPosition = owner.OriginPos + FixMath.MoveStraight(timeScale, m_S2e);
#if _CLIENTLOGIC_
            if (owner.Trans != null)
            {
                owner.Trans.rotation = Quaternion.LookRotation(m_LandingShip.Dir.ToVector3(), Vector3.up);

                if (owner.Anim.GetInteger("anim") != (int)animStage.move)
                {
                    Transform body = owner.Trans.Find("body");
                    //Animator animator = body.GetComponent<Animator>();
                    owner.Anim?.SetInteger("anim", (int)animStage.move);
                }
            }
#endif

            if (timeScale >= Fix64.One || owner.Fixv3LogicPosition.y < 0)
                owner.Fsm.ChangeFsmState<EntityArriveFsm>();
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
#if _CLIENTLOGIC_
            m_LandingShip = null;
#endif
        }

        //---------------------------""-------------------------------
        //        private Fix64 m_FixMoveElpaseTime;
        //        private Fix64 m_FixMoveTime;
        //        private Fix64 m_EndTimeScale;
        //        private FixVector3 m_S2e;
        //        //private FixVector3 m_P1;
        //        //private FixVector3 m_arrayPos;

        //        //private Fix64 m_ArrayCorrectForward = (Fix64)10;

        //        public override void OnEnter(EntityBase owner)
        //        {
        //            base.OnEnter(owner);

        //            m_EndTimeScale = Fix64.One;
        //            m_FixMoveElpaseTime = Fix64.Zero;
        //            m_FixMoveTime = (Fix64)1;
        //            var dir = CorrectLandingDir(owner.TargetPos);
        //            m_S2e = owner.TargetPos - owner.OriginPos + dir * (Fix64)8;
        //            //m_arrayPos = owner.TargetPos + (dir * m_ArrayCorrectForward);

        //            //var dirHalf = owner.OriginPos + (m_arrayPos - owner.OriginPos) / (Fix64)2;
        //            //m_P1 = dirHalf + dir * (Fix64)30;

        //#if _CLIENTLOGIC_
        //            if (owner.Trans != null) {
        //                Transform body = owner.Trans.Find("body");
        //                //Animator animator = body.GetComponent<Animator>();
        //                owner.Anim?.SetInteger("anim", (int)animStage.move);
        //            }
        //#endif
        //        }

        //        public override void OnUpdate(EntityBase owner)
        //        {
        //            base.OnUpdate(owner);
        //            m_FixMoveElpaseTime += NewGameData._FixFrameLen;
        //            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;
        //            //owner.Fixv3LogicPosition = FixMath.BezierCurve2(timeScale, owner.OriginPos, m_arrayPos, m_P1);
        //            owner.Fixv3LogicPosition = owner.OriginPos + FixMath.MoveStraight(timeScale, m_S2e);
        //#if _CLIENTLOGIC_
        //            if (owner.Trans != null)
        //            {
        //                var forword = owner.Fixv3LogicPosition.ToVector3() - owner.Fixv3LastPosition.ToVector3();
        //                owner.CurrRotation = Quaternion.LookRotation(forword, owner.Trans.up);
        //            }
        //#endif

        //            if (timeScale >= m_EndTimeScale || owner.Fixv3LogicPosition.y < 0)
        //                owner.Fsm.ChangeFsmState<EntityArriveFsm>();
        //        }

        //        private FixVector3 CorrectLandingDir(FixVector3 targetPos)
        //        {
        //            if (targetPos.x <= (Fix64)6 && targetPos.z >= (Fix64)6)
        //            {
        //                return NewGameData._FixRight * -Fix64.One;
        //            }
        //            else if (targetPos.x >= (Fix64)52 && targetPos.z >= (Fix64)6)
        //            {
        //                return NewGameData._FixRight;
        //            }
        //            else if (targetPos.x >= (Fix64)6 && targetPos.z <= (Fix64)6)
        //            {
        //                return NewGameData._FixForword * -Fix64.One;
        //            }
        //            else
        //            {
        //                return NewGameData._FixForword;
        //            }
        //        }
    }
}
