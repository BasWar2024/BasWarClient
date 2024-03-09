local BattleScene = class("BattleScene")

function BattleScene:ctor()
    self.fingerDrag = 0
end

--  
function BattleScene:onTap(pos, go)
    gg.battleManager:onFingerUp(pos)
end

--  
function BattleScene:onPinch(pos, go, delta, gap, phase)
    gg.warCameraCtrl:zoomCamera(delta)
    self.fingerDrag = 0
end

--  
function BattleScene:onFirstFingerDrag(pos, go, deltaMove, phase)
    if self.fingerDrag < 1 then
        self.fingerDrag = self.fingerDrag + 1
        return
    end
    gg.warCameraCtrl:startMoving(pos, deltaMove)               
end

--  
function BattleScene:onFingerDown(pos, go)
    self.fingerDrag = 0
end

--  
function BattleScene:onFingerUp(pos, go)
    self.fingerDrag = 0
end

--  
function BattleScene:onLongPress(pos, go)
    
end

return BattleScene