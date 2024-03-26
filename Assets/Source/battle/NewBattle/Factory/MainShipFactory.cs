namespace Battle
{
    public class MainShipFactory
    {
        public MainShip CreateMainShip()
        {
            var mainShip = NewGameData._PoolManager.Pop<MainShip>();
            mainShip.Init();
            mainShip.IsHero = false;
            SetAttr(mainShip, NewGameData._InitBattleModel.mainShip);
            return mainShip;
        }

        private void SetAttr(MainShip mainShip, MainShipModel model)
        {
            mainShip.FixOriginHp = (Fix64)model.maxHp;
            mainShip.OriginFixAtk = (Fix64)model.atk / 1000;
        }
    }
}
