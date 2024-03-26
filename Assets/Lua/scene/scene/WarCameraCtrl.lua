local WarCameraCtrl = class("WarCameraCtrl")

WarCameraCtrl.MODEL_BASE = 1
WarCameraCtrl.MODEL_BATTLE = 2
WarCameraCtrl.MODEL_GALAXY = 3
WarCameraCtrl.MODEL_PLANET = 4

WarCameraCtrl.maxYInBase = 125

WarCameraCtrl.cameraFieldOfViewMin = 4
WarCameraCtrl.cameraFieldOfViewMax = 15
WarCameraCtrl.cameraFieldOfViewReset = 8.5
WarCameraCtrl.cameraFieldOfViewBattle = 9.2

WarCameraCtrl.minZInGalaxy = -100
WarCameraCtrl.maxZInGalaxy = -10

WarCameraCtrl.landPointNorth = 1
WarCameraCtrl.landPointEast = 2
WarCameraCtrl.landPointSouth = 3
WarCameraCtrl.landPointWest = 4

function WarCameraCtrl:ctor()
    self.curCameraFieldOfView = WarCameraCtrl.cameraFieldOfViewReset
    self.isStopZoom = false
end

function WarCameraCtrl:startMoving(deltaPos)
    if self.isGuideStopCamera then
        return
    end
    if self.model == WarCameraCtrl.MODEL_BASE or self.model == WarCameraCtrl.MODEL_BATTLE then
        self:moveInBase(deltaPos)
    elseif self.model == WarCameraCtrl.MODEL_GALAXY or self.model == WarCameraCtrl.MODEL_PLANET then
        self:moveInGalaxy(deltaPos)
    end
end

function WarCameraCtrl:moveInBase(deltaPos)
    if not UnityEngine.Camera.main or not self.canMove then
        return
    end
    local pos = UnityEngine.Camera.main.transform.position
    local posVector = Vector3(pos.x, pos.y, pos.z)
    local speed = Vector3.zero
    local delte = deltaPos
    local moveSpeed = self.curCameraFieldOfView * 0.04
    speed = -Vector3(delte.x + delte.y, 0, delte.y - delte.x) * 0.05 * moveSpeed
    local newPos = posVector + speed
    self:clampCameraPosInBase(newPos)
    -- gg.event:dispatchEvent("onMoveFollow")
    -- gg.event:dispatchEvent("onUpdataMove")
    gg.event:dispatchEvent("onMoveFollowHide")

end

WarCameraCtrl.posEndRight = 150
WarCameraCtrl.posEndLeft = -150
WarCameraCtrl.posEndUp = 117
WarCameraCtrl.posEndDown = -147

function WarCameraCtrl:moveInGalaxy(deltaPos)
    if not UnityEngine.Camera.main then
        return
    end
    local pos = UnityEngine.Camera.main.transform.position
    local posVector = Vector3(pos.x, pos.y, pos.z)
    local speed = Vector3.zero
    local delte = deltaPos
    local moveSpeed = Vector3(self.curCameraFieldOfView * 0.07, 0, self.curCameraFieldOfView * 0.1) * 0.005
    speed = -Vector3(delte.x * moveSpeed.x, 0, delte.y * moveSpeed.z)
    local newPos = posVector + speed

    if newPos.x > WarCameraCtrl.posEndRight then
        newPos.x = WarCameraCtrl.posEndRight
    end
    if newPos.x < WarCameraCtrl.posEndLeft then
        newPos.x = WarCameraCtrl.posEndLeft
    end
    if newPos.z > WarCameraCtrl.posEndUp then
        newPos.z = WarCameraCtrl.posEndUp
    end
    if newPos.z < WarCameraCtrl.posEndDown then
        newPos.z = WarCameraCtrl.posEndDown
    end

    UnityEngine.Camera.main.transform.position = newPos

    gg.event:dispatchEvent("onCameraVisualRangeInGalaxy")
    self:saveCameraPosInGalaxy()
end

function WarCameraCtrl:clampCameraPosInBase(newPos)
    local posVector = newPos
    local max = -40 + (WarCameraCtrl.cameraFieldOfViewMax - self.curCameraFieldOfView - 1)
    local min = -80 - (WarCameraCtrl.cameraFieldOfViewMax - self.curCameraFieldOfView - 1)
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

function WarCameraCtrl:clampCameraPosInGalaxy(newPos)
    local posVector = newPos

    if posVector.z > WarCameraCtrl.maxZInGalaxy then
        posVector.z = WarCameraCtrl.maxZInGalaxy
    end
    if posVector.z < WarCameraCtrl.minZInGalaxy then
        posVector.z = WarCameraCtrl.minZInGalaxy
    end
    UnityEngine.Camera.main.transform.position = posVector

end

function WarCameraCtrl:zoomCamera(delta)
    if self.isGuideStopCamera then
        return
    end

    if self.model == WarCameraCtrl.MODEL_BASE or self.model == WarCameraCtrl.MODEL_BATTLE then
        self:zoomCameraInBase(delta)
    elseif self.model == WarCameraCtrl.MODEL_GALAXY or self.model == WarCameraCtrl.MODEL_PLANET then
        -- self:zoomCameraInGalaxy(delta)
    end
end

function WarCameraCtrl:setGuideStopCamera(isStop)
    self.isGuideStopCamera = isStop
end

function WarCameraCtrl:zoomCameraInBase(delta)
    if not UnityEngine.Camera.main or not self.tiltCamera or not self.highlightedCamera or not self.canMove then
        return
    end

    self.curCameraFieldOfView = UnityEngine.Camera.main.fieldOfView
    self.curCameraFieldOfView = self.curCameraFieldOfView - delta * 0.01
    if self.curCameraFieldOfView > WarCameraCtrl.cameraFieldOfViewMax then
        self.curCameraFieldOfView = WarCameraCtrl.cameraFieldOfViewMax
    end
    if self.curCameraFieldOfView < WarCameraCtrl.cameraFieldOfViewMin then
        self.curCameraFieldOfView = WarCameraCtrl.cameraFieldOfViewMin
    end

    -- ""
    UnityEngine.Camera.main.fieldOfView = self.curCameraFieldOfView

    -- tilt""
    self.tiltCamera.fieldOfView = self.curCameraFieldOfView
    self.highlightedCamera.fieldOfView = self.curCameraFieldOfView

    local newPos = UnityEngine.Camera.main.transform.position
    self:clampCameraPosInBase(newPos)
    gg.event:dispatchEvent("onMoveFollow")
    gg.event:dispatchEvent("onUpdataMove")
    -- gg.event:dispatchEvent("onMoveFollowHide")

end

function WarCameraCtrl:zoomCameraInGalaxy(delta)
    if not UnityEngine.Camera.main then
        return
    end
    -- local pos = UnityEngine.Camera.main.transform.position
    -- local posVector = Vector3(pos.x, pos.y, pos.z)
    -- local speed = Vector3(0, 1, 0) * delta * 0.05
    -- local newPos = posVector + speed

    -- if newPos.z < -55 then
    --     gg.event:dispatchEvent("onShowName", false)
    -- else
    --     gg.event:dispatchEvent("onShowName", true)
    -- end

    -- self:clampCameraPosInGalaxy(newPos)

    self.curCameraFieldOfView = self.curCameraFieldOfView - delta * 0.01
    if self.curCameraFieldOfView > WarCameraCtrl.cameraFieldOfViewMax then
        self.curCameraFieldOfView = WarCameraCtrl.cameraFieldOfViewMax
    end
    if self.curCameraFieldOfView < WarCameraCtrl.cameraFieldOfViewMin then
        self.curCameraFieldOfView = WarCameraCtrl.cameraFieldOfViewMin
    end

    -- ""
    UnityEngine.Camera.main.fieldOfView = self.curCameraFieldOfView

    self.tiltCamera.fieldOfView = self.curCameraFieldOfView
    self.highlightedCamera.fieldOfView = self.curCameraFieldOfView

    -- gg.event:dispatchEvent("onCameraVisualRangeInGalaxy")
    self:saveCameraPosInGalaxy()
end

function WarCameraCtrl:setCameraPos(bool, model, x, z)
    UnityEngine.Camera.main:DOPause()

    self.model = model
    self.canMove = true
    if model == WarCameraCtrl.MODEL_BATTLE then
        self.canMove = false
    end
    if model == WarCameraCtrl.MODEL_BASE or model == WarCameraCtrl.MODEL_BATTLE then
        self:setCameraPosInBase(bool)
    elseif model == WarCameraCtrl.MODEL_GALAXY or model == WarCameraCtrl.MODEL_PLANET then
        self:setCameraPosInGalaxy(x, z)
    end
end

WarCameraCtrl.CAMERACLEARFLAGS_SKYBOX = 1
WarCameraCtrl.CAMERACLEARFLAGS_DEPTH = 3

function WarCameraCtrl:setCameraPosInGalaxy(x, z)
    local pos = Vector3(x, 15, z - 15)
    local field = 12
    if self.cameraPosInGalaxy then
        pos = self.cameraPosInGalaxy
        field = self.cameraFieldInGalaxy
    end
    UnityEngine.Camera.main.fieldOfView = field
    UnityEngine.Camera.main.transform.rotation = Quaternion.Euler(45, 0, 0)
    UnityEngine.Camera.main.transform.position = pos
    UnityEngine.Camera.main.clearFlags = WarCameraCtrl.CAMERACLEARFLAGS_SKYBOX
    gg.event:dispatchEvent("onCameraVisualRangeInGalaxy")

end

function WarCameraCtrl:saveCameraPosInGalaxy()
    self.cameraPosInGalaxy = UnityEngine.Camera.main.transform.position
    self.cameraFieldInGalaxy = UnityEngine.Camera.main.fieldOfView
end

function WarCameraCtrl:clearCameraPosInGalaxy()
    self.cameraPosInGalaxy = nil
end

WarCameraCtrl.intiPosInBaseX = -77
WarCameraCtrl.intiPosInBaseZ = -69


function WarCameraCtrl:setCameraPosInBase(isMoveCamera, isFieldOfViewResetMax)
    local cameraPos = Vector3.zero

    cameraPos.x = WarCameraCtrl.intiPosInBaseX

    cameraPos.y = WarCameraCtrl.maxYInBase

    cameraPos.z = WarCameraCtrl.intiPosInBaseZ
    
    UnityEngine.Camera.main.transform.rotation = Quaternion.Euler(45, 45, 0)

    local resetFieldOfView = WarCameraCtrl.cameraFieldOfViewReset
    if isFieldOfViewResetMax then
        resetFieldOfView = WarCameraCtrl.cameraFieldOfViewMax
    end

    -- ""
    if UnityEngine.Camera.main then
        UnityEngine.Camera.main.clearFlags = WarCameraCtrl.CAMERACLEARFLAGS_DEPTH
        self.tiltCamera = UnityEngine.Camera.main.transform:Find("TiltCamera"):GetComponent("Camera")
        self.highlightedCamera = UnityEngine.Camera.main.transform:Find("HighlightedCamera"):GetComponent("Camera")

        if isMoveCamera then
            local ani = nil
            ani = UnityEngine.Camera.main:GetComponent("Animator")
            if ani then
                ani.enabled = false
            end
            self:moveCamera(Vector3(WarCameraCtrl.intiPosInBaseX - 30, 168, WarCameraCtrl.intiPosInBaseZ - 30), Vector3(WarCameraCtrl.intiPosInBaseX, 125, WarCameraCtrl.intiPosInBaseZ), 40, WarCameraCtrl.cameraFieldOfViewReset, true, 23)
        else
            if self.model == WarCameraCtrl.MODEL_BATTLE then
                self.curCameraFieldOfView = WarCameraCtrl.cameraFieldOfViewBattle
                cameraPos.x = -77.5
                cameraPos.z = -65.5
            else
                self.curCameraFieldOfView = resetFieldOfView
            end

            self.tiltCamera.fieldOfView = self.curCameraFieldOfView
            self.highlightedCamera.fieldOfView = self.curCameraFieldOfView

            UnityEngine.Camera.main.fieldOfView = self.curCameraFieldOfView
            
            UnityEngine.Camera.main.transform.position = cameraPos

        end
    end
end

function WarCameraCtrl:move2LandPoint(direction)
    local pos = UnityEngine.Camera.main.transform.position
    local endXY = Vector3(0, 0, 0)

    if direction == WarCameraCtrl.landPointNorth then
        endXY = Vector3(-77.5, 125, -65.5)
    elseif direction == WarCameraCtrl.landPointEast then
        endXY = Vector3(-77.5, 125, -65.5)
    elseif direction == WarCameraCtrl.landPointSouth then
        endXY = Vector3(-77.5, 125, -65.5)
    elseif direction == WarCameraCtrl.landPointWest then
        endXY = Vector3(-77.5, 125, -65.5)
    end
    self:moveCamera(pos, endXY, 1, WarCameraCtrl.cameraFieldOfViewBattle)
end

-- 76 125 -92.34

function WarCameraCtrl:moveCamera(pos, endXY, time, fieldOfView, isMoveFollow, maxFieldOfView)
    self:stopMoveTimer()
    UnityEngine.Camera.main.transform.position = pos
    local viewSpeed
    local maxField = maxFieldOfView or WarCameraCtrl.cameraFieldOfViewBattle
    if fieldOfView then
        viewSpeed = (maxField - fieldOfView) / time
    else
        viewSpeed = (maxField - WarCameraCtrl.cameraFieldOfViewMax) / time
    end
    self.curCameraFieldOfView = maxField
    local dir = endXY - pos
    local speed = UnityEngine.Mathf.Pow((dir.x * dir.x + dir.y * dir.y + dir.z * dir.z), 0.5)
    local dirNormalize = Vector3(dir.x, dir.y, dir.z)
    dirNormalize = dirNormalize:Normalize()
    dirNormalize = dirNormalize * speed / time

    local index = 0
    self.moveTimer = gg.timer:startLoopTimer(0, 0.02, time, function()
        pos = pos + dirNormalize
        self.curCameraFieldOfView = self.curCameraFieldOfView - viewSpeed

        index = index + 1
        if index == time then
            pos = endXY
            self.curCameraFieldOfView = fieldOfView or WarCameraCtrl.cameraFieldOfViewMax
            self.canMove = true
        end

        UnityEngine.Camera.main.transform.position = pos
        self.tiltCamera.fieldOfView = self.curCameraFieldOfView
        self.highlightedCamera.fieldOfView = self.curCameraFieldOfView
        UnityEngine.Camera.main.fieldOfView = self.curCameraFieldOfView

        if isMoveFollow then
            gg.event:dispatchEvent("onMoveFollow")
        end
    end)
end

function WarCameraCtrl:startMove2ResPlanet(x, z, callback)
    self:stopMoveTimer()
    local pos = Vector3(x, 15, z - 15)

    local endXY = pos
    local cameraZ = UnityEngine.Camera.main.transform.position.z
    local time = 15 -- time * 0.03 ""
    local index = time
    self.moveTimer = gg.timer:startLoopTimer(0, 0.03, time, function()
        self:move2ResPlanet(endXY, index)
        index = index - 1
        if index <= 0 then
            UnityEngine.Camera.main.transform.position = endXY
            if callback then
                callback()
            end
        end
    end)
end

function WarCameraCtrl:move2ResPlanet(endXY, index)
    local cameraPos = UnityEngine.Camera.main.transform.position

    local newPos = cameraPos

    local speedX = (endXY.x - cameraPos.x) / index
    local speedY = (endXY.y - cameraPos.y) / index
    local speedZ = (endXY.z - cameraPos.z) / index

    local speed = Vector3(speedX, speedY, speedZ)

    newPos = newPos + speed
    UnityEngine.Camera.main.transform.position = newPos
end

function WarCameraCtrl:stopMoveTimer()
    if self.moveTimer then
        gg.timer:stopTimer(self.moveTimer)
        self.moveTimer = nil
    end
end

function WarCameraCtrl:resetMoveAnim()
    if self.tiltCamera then
        self.tiltCamera.fieldOfView = 24
        self.highlightedCamera.fieldOfView = 24
        UnityEngine.Camera.main.fieldOfView = 24
        UnityEngine.Camera.main.transform.position = Vector3(-90, 168, -90)
    end
end

return WarCameraCtrl
