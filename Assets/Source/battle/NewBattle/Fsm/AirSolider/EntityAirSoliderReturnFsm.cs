
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class EntityAirSoliderReturnFsm : FsmState<EntityBase>
    {
//        private Fix64 m_FixMoveElpaseTime;
//        private Fix64 m_FixMoveTime;
//        private FixVector3 m_P1;
//        private FixVector3 m_P2;

//        private FixVector3 m_StartPos;
//        private bool m_IsBezierCurve2;

//        public override void OnEnter(EntityBase owner)
//        {
//            base.OnEnter(owner);

//            m_FixMoveElpaseTime = Fix64.Zero;
//            m_FixMoveTime = (Fix64)8;
//            m_StartPos = owner.Fixv3LogicPosition;
//            if (owner is LandingShip)
//            {
//                m_IsBezierCurve2 = false;
//            }
//            else
//            {
//                m_IsBezierCurve2 = true;
//            }
//            m_P1 = CorrectReturnPos();
//        }

//        public override void OnUpdate(EntityBase owner)
//        {
//            base.OnUpdate(owner);

//            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

//            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;
//            owner.Fixv3LogicPosition = m_IsBezierCurve2 ? FixMath.BezierCurve2(timeScale, m_StartPos, owner.OriginPos, m_P1) :
//                FixMath.BezierCurve3(timeScale, m_StartPos, owner.OriginPos, m_P2, m_P1);

//#if _CLIENTLOGIC_
//            if (owner.Trans != null)
//            {
//                var forword = owner.Fixv3LogicPosition.ToVector3() - owner.Fixv3LastPosition.ToVector3();
//                owner.CurrRotation = Quaternion.LookRotation(forword, owner.Trans.up);
//            }
//#endif

//            if (timeScale >= Fix64.One)
//            {
//                if (owner is BomberAirSolider)
//                {
//                    BomberAirSolider airSolider = owner as BomberAirSolider;
//                    Troops troops = NewGameData._OperTroops[airSolider.OperOrder];
//                    airSolider.OperOrder = OperOrder.None;
//                    troops.SoliderDict[owner] = true;
//                    troops.CheckAllSoliderReturn();
//                }

//                NewGameData._EntityManager.BeKill(owner);
//            }
//        }

//        private FixVector3 CorrectReturnPos()
//        {
//            var createLandShipPosNoY = new FixVector3(NewGameData.CreateLandShipPos.x, Fix64.Zero, NewGameData.CreateLandShipPos.z);
//            var forword = new FixVector3(m_StartPos.x, Fix64.Zero, m_StartPos.z) - createLandShipPosNoY;
//            forword.Normalize();

//            var cross = FixVector3.Cross(NewGameData.MapMidPos - createLandShipPosNoY, forword);

//            FixVector3 offsetDir;
//            if (cross.y >= Fix64.Zero)
//            {
//                offsetDir = FixVector3.Cross(forword * -Fix64.One, NewGameData._FixUp);
//            }
//            else
//            {
//                offsetDir = FixVector3.Cross(forword, NewGameData._FixUp);
//            }

//            offsetDir.Normalize();

//            //"",""p2
//            if (!m_IsBezierCurve2)
//            {
//                m_P2 = m_StartPos + offsetDir * -(Fix64)20 + forword * (Fix64)10;
//            }

//            return m_StartPos + offsetDir * (Fix64)20 + forword * (Fix64)40;
//        }
    }
}
