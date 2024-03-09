BattleManager = class("BattleManager")

function BattleManager:ctor()
    self.battleMono = nil
    self.newBattleData = nil
    self.isInBattle = false
    self.scene = ggclass.BattleScene.new()
end

function BattleManager:initBattleLogic(battleId, battleInfo)
    --gg.warCameraCtrl:setCameraPos(Vector3.zero)
    print(battleId)
    self.battleMono:InitBattleLogic(battleId, battleInfo)
    self.newBattleData = CS.NewGameData
    self.isInBattle = true
end

function BattleManager:setBattleMono(battleMono)
    self.battleMono = battleMono
end
function BattleManager:readyBattle()
    self.battleMono.BattleLogic.Stage = 1
end

function BattleManager:onFingerUp(pos)
    self.battleMono:OnFingerUp(UnityEngine.Vector3(pos.x, pos.y, 0))
end