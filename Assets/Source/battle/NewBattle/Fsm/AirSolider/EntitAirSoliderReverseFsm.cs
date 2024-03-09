
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class EntitAirSoliderReverseFsm : FsmState<EntityBase>
    {
        private FixVector3 m_OriginPos; //
        private FixVector3 m_Center; //
        private Fix64 m_R = (Fix64)5; //

        private Fix64 m_FixMoveElpaseTime = Fix64.Zero;
        private Fix64 m_FixMoveTime = (Fix64)2;
        private Fix64 m_OriginRad;

        private bool m_Is1_4; //
        private bool m_IsOriginInSky; //

#if _CLIENTLOGIC_
        private float m_OriginY;
        private float m_StepY = 0;
#endif

        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_OriginPos = owner.Fixv3LogicPosition;
            FixVector3 cross = FixVector3.Cross(m_OriginPos - NewGameData.CreateLandShipPos, new FixVector3(Fix64.Zero, (Fix64)1, Fix64.Zero)); //

            cross.Normalize();
            m_Center = m_OriginPos + cross * m_R; //

            var sin = (m_OriginPos.z - m_Center.z) / m_R;

            m_OriginRad = Fix64.Asin(sin);

            m_FixMoveElpaseTime = Fix64.Zero;
            m_Is1_4 = NewGameData.CreateLandShipPos == NewGameData._SigninPos1 || NewGameData.CreateLandShipPos == NewGameData._SigninPos4 ? true : false;
            m_IsOriginInSky = m_OriginPos.y == NewGameData.AirHigh ? true : false;

#if _CLIENTLOGIC_
            m_OriginY = owner.Trans.eulerAngles.y;
#endif

        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            m_FixMoveElpaseTime += NewGameData._FixFrameLen;

            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;

            Fix64 rad = m_Is1_4 ? -(Fix64.PI * (1 - timeScale) + m_OriginRad) : Fix64.PI * timeScale + m_OriginRad;

            Fix64 x = m_Center.x + m_R * Fix64.Cos(rad);
            Fix64 y = m_IsOriginInSky ? NewGameData.AirHigh : NewGameData.AirHigh * timeScale;
            Fix64 z = m_Center.z + m_R * Fix64.Sin(rad);

            owner.Fixv3LogicPosition = new FixVector3(x, y, z);

#if _CLIENTLOGIC_
            var newangle = Quaternion.Euler(0, m_OriginY + m_StepY * -7, 0);
            owner.Trans.rotation = Quaternion.Lerp(owner.Trans.rotation, newangle, (float)m_FixMoveElpaseTime);
            m_StepY++;
#endif

            if (m_Is1_4 ? rad >= -m_OriginRad : rad >= Fix64.PI + m_OriginRad)
            {
                owner.Fsm.ChangeFsmState<EntityReturnStraighFsm>();
            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}
