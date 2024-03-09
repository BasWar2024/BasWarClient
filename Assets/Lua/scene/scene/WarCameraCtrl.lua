local WarCameraCtrl = class("WarCameraCtrl")

function WarCameraCtrl:ctor()
    self.minY = 68
    self.maxY = 148

    self.cameraFieldOfViewMin = 4
    self.cameraFieldOfViewMax = 20
end

function WarCameraCtrl:startMoving(pos, deltaPos)
    if not UnityEngine.Camera.main then
        return
    end
    local pos = UnityEngine.Camera.main.transform.position
    local posVector = Vector3(pos.x, pos.y, pos.z)
    local speed = Vector3.zero
    local delte = deltaPos
    local moveSpeed = posVector.y / self.maxY * posVector.y / self.maxY
    speed = -Vector3(delte.x + delte.y, 0, delte.y - delte.x) * 0.07 * moveSpeed
    local newPos = posVector + speed
    self:clampCameraPos(posVector, newPos, speed)
    -- gg.event:dispatchEvent("onMoveFollow")
    -- gg.event:dispatchEvent("onUpdataMove")
    gg.event:dispatchEvent("onMoveFollowHide")
end

function WarCameraCtrl:clampCameraPos(oldPos, newPos, speed)
    local posVector = newPos
    local max = -50 + (self.maxY - posVector.y) --* 1.5
    local min = -80
    local conten = (max + min) / 2
    local distance = max - min

    if posVector.x > conten and posVector.z > conten then
        if posVector.x > conten + distance then
            posVector.x = conten + distance
        end
        if posVector.z + posVector.x > max + max then
            local dis = posVector.z + posVector.x - max - max
            posVector.x = posVector.x - dis / 2
            posVector.z = posVector.z - dis / 2
        end
    end
    if posVector.x < conten and posVector.z > conten then
        if posVector.x < conten - distance then
            posVector.x = conten - distance
        end
        if posVector.z - posVector.x > max - min then
            local dis = posVector.z - posVector.x - max + min
            posVector.x = posVector.x + dis / 2
            posVector.z = posVector.z - dis / 2
        end
    end
    if posVector.x < conten and posVector.z < conten then
        if posVector.x < conten - distance then
            posVector.x = conten - distance
        end
        if posVector.z + posVector.x < min + min then
            local dis = min + min - posVector.z - posVector.x
            posVector.x = posVector.x + dis / 2
            posVector.z = posVector.z + dis / 2 
        end
    end
    if posVector.x > conten and posVector.z < conten then
        if posVector.x > conten + distance then
            posVector.x = conten + distance
        end
        if posVector.z - posVector.x < min - max then
            local dis = min - max - posVector.z + posVector.x
            posVector.x = posVector.x - dis / 2
            posVector.z = posVector.z + dis / 2
        end
    end
    
    UnityEngine.Camera.main.transform.position = posVector

end

function WarCameraCtrl:zoomCamera(delta)
    if not UnityEngine.Camera.main then
        return
    end
    local pos = UnityEngine.Camera.main.transform.position
    local posVector = Vector3(pos.x, pos.y, pos.z)
    local speed = Vector3(-0.5, 1, -0.5) * -delta * 0.05
    local newPos = posVector + speed
    if newPos.y > self.maxY then
        newPos.y = self.maxY
        return
    end
    if newPos.y < self.minY then
        newPos.y = self.minY
        return
    end
    local proportion = (newPos.y - self.minY) / (self.maxY - self.minY)
    UnityEngine.Camera.main.fieldOfView = (self.cameraFieldOfViewMax - self.cameraFieldOfViewMin) * proportion + self.cameraFieldOfViewMin
    self.tiltCamera.fieldOfView = (self.cameraFieldOfViewMax - self.cameraFieldOfViewMin) * proportion + self.cameraFieldOfViewMin
    
    --UnityEngine.Camera.main.transform.position = newPos
    self:clampCameraPos(posVector, newPos, speed)
    -- gg.event:dispatchEvent("onMoveFollow")
    -- gg.event:dispatchEvent("onUpdataMove")
    gg.event:dispatchEvent("onMoveFollowHide")
end

function WarCameraCtrl:setCameraPos(pos, bool)
    local cameraPos = pos  

    cameraPos.x = -75

    cameraPos.y = self.maxY

    cameraPos.z = -75

    --
    if UnityEngine.Camera.main then
        self.tiltCamera = UnityEngine.Camera.main.transform:Find("TiltCamera"):GetComponent("Camera")
        local ani = nil
        if bool then
            ani = UnityEngine.Camera.main:GetComponent("Animator")
        end
        if ani then
            ani.enabled = true
            ani:SetTrigger("move")
            local temp = 0
            local stopCameraMove = ani:GetComponent("StopCameraMove")
            self.timer = gg.timer:startLoopTimer(0, 0.01, -1, function()
                gg.event:dispatchEvent("onMoveFollow")
                if not stopCameraMove.enabled  and temp > 5 then
                    gg.event:dispatchEvent("onIsCanBattle")
                    gg.timer:stopTimer(self.timer)
                end
                temp = temp + 1
            end)
        else
            self.tiltCamera.fieldOfView = self.cameraFieldOfViewMax
            UnityEngine.Camera.main.fieldOfView = self.cameraFieldOfViewMax
            UnityEngine.Camera.main.transform.rotation = Quaternion.Euler(45, 45, 0)
            UnityEngine.Camera.main.transform.position = cameraPos
        end
    end
end


return WarCameraCtrl