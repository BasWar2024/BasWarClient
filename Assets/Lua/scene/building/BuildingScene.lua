local BuildingScene = class("BuildingScene")

function BuildingScene:ctor()
    self.fingerOnBuilding = false
    self.longPass = false
    self.afterLongPass = false
    self.fingerDrag = 0
end

--  
function BuildingScene:onTap(pos, go)
    if self.afterLongPass then
        self.afterLongPass = false
    else
        if gg.buildingManager:checkBuilding(pos) then
        else
            gg.buildingManager:moveComplete()
        end
    end 
end

--  
function BuildingScene:onPinch(pos, go, delta, gap, phase)
    gg.warCameraCtrl:zoomCamera(delta)
    self.fingerDrag = 0
end

--  
function BuildingScene:onFirstFingerDrag(pos, go, deltaMove, phase)
    if self.fingerDrag < 1 then
        self.fingerDrag = self.fingerDrag + 1
        return
    end
    if self.fingerOnBuilding then
        gg.buildingManager:moveBuilding(pos)
        self.longPass = false
    else
        gg.warCameraCtrl:startMoving(pos, deltaMove)
    end
end

--  
function BuildingScene:onFingerDown(pos, go)
    if gg.buildingManager:checkFingerOnBuilding(pos) then
        self.fingerOnBuilding = true
    end
    self.fingerDrag = 0
end

--  
function BuildingScene:onFingerUp(pos, go)
    self.fingerOnBuilding = false
    gg.buildingManager:releaseFinger()
    if self.longPass then
        self.longPass = false
        self.afterLongPass = true
        gg.buildingManager:moveComplete()
    end
    gg.event:dispatchEvent("onMoveFollow")
    gg.event:dispatchEvent("onUpdataMove")
    self.fingerDrag = 0
end

--  
function BuildingScene:onLongPress(pos, go)
    if gg.buildingManager:checkBuilding(pos) then
        self.fingerOnBuilding = true
        self.longPass = true
    end
end

return BuildingScene