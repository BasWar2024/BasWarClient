#if _CLIENTLOGIC_
namespace Battle
{
    using UnityEngine;

    public class WarShipMoveFsm : FsmState<LockStepLogicMonoBehaviour>
    {
        private Transform m_WarShip;
        private Vector3 m_NewSigninPos;
        public override void OnInit(LockStepLogicMonoBehaviour owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(LockStepLogicMonoBehaviour owner)
        {
            base.OnEnter(owner);
            m_WarShip = owner.WarShip;

            m_WarShip.position = owner.SigninPos.position + (-owner.SigninPos.forward) * m_WarShip.localScale.z + Vector3.up * (float)NewGameData.WarShipHigh;
            m_WarShip.localRotation = owner.SigninPos.rotation;
            m_NewSigninPos = owner.SigninPos.position + (-owner.SigninPos.forward * m_WarShip.localScale.z / 2.5f) + Vector3.up * (float)NewGameData.WarShipHigh;
            NewGameData._SigninPosId = owner.SigninId;
        }

        public override void OnUpdate(LockStepLogicMonoBehaviour owner)
        {
            base.OnUpdate(owner);

            m_WarShip.position += m_WarShip.forward * 0.5f;

            if (Vector3.Distance(m_WarShip.position, m_NewSigninPos) <= 0.1f)
            {
                owner.Fsm.ChangeFsmState<WarShipFightWallFsm>();
            }
        }
        public override void OnLeave(LockStepLogicMonoBehaviour owner)
        {
            base.OnLeave(owner);
        }
    }
}
#endif