#if _CLIENTLOGIC_
using UnityEngine;

namespace Battle
{
    public class WarShipReadyFsm : FsmState<LockStepLogicMonoBehaviour>
    {
        public override void OnEnter(LockStepLogicMonoBehaviour owner)
        {
            base.OnEnter(owner);
            //var forwordLength = owner.SigninPos.name.Contains("3") ? 18 : 6;
            owner.WarShip.position = owner.WarShipSigninPos.position;//owner.SigninPos.position + (-owner.SigninPos.forward * forwordLength) + Vector3.up * (float)NewGameData.WarShipHigh;
            owner.WarShip.localRotation = owner.WarShipSigninPos.rotation;
            //for (int i = 0; i < owner.WarShip.transform.Find("Body").childCount; i++) {
            //    owner.WarShip.transform.Find("Body").GetChild(i).GetComponent<GradualChange>().enabled = true;
            //}
            //owner.WarShip.GetComponent<GradualChange>().enabled = true;
            owner.Fsm.ChangeFsmState<WarShipShowFsm>();
        }
    }
}
#endif
