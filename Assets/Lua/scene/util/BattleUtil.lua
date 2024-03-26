BattleUtil = BattleUtil or {}

function BattleUtil.returnFromResult()
    gg.battleManager.newBattleData:Release()
    gg.sceneManager:returnFormBatter()
end
