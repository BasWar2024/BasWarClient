

namespace Battle
{
    //""
    public class MineralBuilding : BuildingBase
    {
        public override void Init()
        {
            base.Init();
            Direction = 0;
        }

        public override void Start()
        {
            base.Start();
            LoadProperties();
        }

#if _CLIENTLOGIC_
        public override void CreatePrefabCallBack()
        {
            base.CreatePrefabCallBack();
            NewGameData.BattleMono.GetComponent<LockStepLogicMonoBehaviour>().ChangeSlot?.Invoke(this);
        }
#endif
    }
}