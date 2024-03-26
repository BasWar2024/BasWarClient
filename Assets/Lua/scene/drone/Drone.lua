local Drone = class("Drone")

Drone.MODEL_GET = 1
Drone.MODEL_PLACE = 2

function Drone:ctor(building)
    self.building = building
    self.height = 1.5
    self.upHeight = 1
    self.moveSpeedMax = 3
    self.moveSpeedMin = 1
    self.heightSpeedMax = 3
    self.heightSpeedMin = 0.1

    self.droneModel = Drone.MODEL_GET
    self.tagerTable = {}

    self:loadDrone()

end

-- ""
function Drone:loadDrone()
    self.buildingBase = gg.buildingManager:getBuildingBase()
    if not self.buildingBase then
        return
    end

    ResMgr:LoadGameObjectAsync("Drone", function(obj)
        local owner = self.building.owner
        if owner == BuildingManager.OWNER_OWN then
            obj.transform:SetParent(gg.buildingManager.ownBase.transform, false)
        else
            obj.transform:SetParent(gg.buildingManager.otherBase.transform, false)
        end

        obj.transform.position = Vector3(self.buildingBase.view.operPoint.transform.position.x,
            self.buildingBase.view.operPoint.transform.position.y + self.height,
            self.buildingBase.view.operPoint.transform.position.z)

        self.drone = obj
        self:setShadowPos(obj.transform.localPosition.y)
        self.resType = 1
        local cfgId = self.building.buildCfg.cfgId
        -- ""
        if cfgId == constant.BUILD_ICEMININGTOWER then
            self.resType = 2
        elseif cfgId == constant.BUILD_TITANIUMMININGTOWER then
            self.resType = 6
        elseif cfgId == constant.BUILD_GASMININGTOWER then
            self.resType = 1
        elseif cfgId == constant.BUILD_CARBOXYLMININGTOWER then
            self.resType = 3
        elseif cfgId == constant.BUILD_MININGMACHINE then
            self.resType = 4
        end
        self:setResType(self.resType)
        self.myDire = 15
        self:changeDirection(self.myDire)
        self:bindEvent()
        self:startUp(self.building, self.buildingBase)
        return true
    end, true)
end

function Drone:bindEvent()
    gg.event:addListener("onUnLoadDrone", self)
    gg.event:addListener("onUpData", self)
    gg.event:addListener("onSetActive", self)
    gg.event:addListener("onDroneSetActive", self)
end

function Drone:onUnLoadDrone(args, owner)
    if owner == self.building.owner then
        self:unLoadDrone()
    end
end

function Drone:unLoadDrone()
    self.isMove = false

    gg.event:removeListener("onUnLoadDrone", self)
    gg.event:removeListener("onUpData", self)
    gg.event:removeListener("onSetActive", self)
    gg.event:removeListener("onDroneSetActive", self)

    self:stopTrunTimer()
    self:stopPlaceTimer()
    self:stopGetTimer()

    if self.drone then
        ResMgr:ReleaseAsset(self.drone)
        self.drone = nil
    end

    self.tagerTable = nil
    self.building = nil
    self.tableBuild = nil
end

-- ""
function Drone:changeDirection(temp)
    temp = string.format("%02d", temp)
    local attachmentName = "res/Drone/ufo00" .. temp
    self.drone.transform:Find("Spine"):GetComponent("SkeletonAnimation"):ChangeSlots("body", attachmentName)
end

function Drone:setShadowPos(y)
    self.drone.transform:Find("Shadow").localPosition = Vector3(-1, -y, -1)
end

--  resType 0~6; 0 == ""
function Drone:setResType(resType)
    resType = string.format("%02d", resType)
    local attachmentName = "res/res/" .. resType
    self.drone.transform:Find("Spine"):GetComponent("SkeletonAnimation"):ChangeSlots("res", attachmentName)
end

function Drone:showRes(bool)
    self.drone.transform:Find("Spine"):GetComponent("SkeletonAnimation"):setActive("res", bool)
end

function Drone:spineAnimPlay(animName, loop)
    self.drone.transform:Find("Spine"):GetComponent("SkeletonAnimation"):SpineAnimPlay(animName, loop)
    self:changeDirection(self.myDire)

end

function Drone:onUpData()
    if self.isMove then
        -- ""
        local curPos = Vector3(self.drone.transform.position.x, self.drone.transform.position.y - self.parabolicY,
            self.drone.transform.position.z)
        local newPos = UnityEngine.Vector3.MoveTowards(curPos, self.targetPos,
            self.moveSpeed * UnityEngine.Time.deltaTime)
        local firstHalfDis = self:calcDistance(curPos, self.startPos)
        local secondhalfDis = self:calcDistance(curPos, self.targetPos)

        if firstHalfDis < secondhalfDis then
            local percent = firstHalfDis / (firstHalfDis + secondhalfDis) * 2
            local speed = (self.heightSpeedMax - self.heightSpeedMin) * (1 - percent) + self.heightSpeedMin
            self.parabolicY = self.parabolicY + speed * UnityEngine.Time.deltaTime
        else
            if self.parabolicY > 0 then
                local percent = secondhalfDis / (firstHalfDis + secondhalfDis) * 2
                local speed = (self.heightSpeedMax - self.heightSpeedMin) * (1 - percent) + self.heightSpeedMin
                self.parabolicY = self.parabolicY - speed * UnityEngine.Time.deltaTime
            else
                self.parabolicY = 0
            end

        end
        local height = newPos.y + self.parabolicY

        newPos = Vector3(newPos.x, height, newPos.z)
        self.drone.transform.position = newPos

        self:setShadowPos(self.drone.transform.localPosition.y)
        if self.moveSpeed < self.moveSpeedMax then
            self.moveSpeed = self.moveSpeed + 0.2
        end

        if self:arriveTarget(self.drone.transform.position, self.targetPos) then
            self.drone.transform.position = self.targetPos
            self:droneUpDown(15)
            self.isMove = false
        end
    end
end

function Drone:calcDistance(fromPos, toPos)
    local powX = (toPos.x - fromPos.x) ^ 2
    local powZ = (toPos.z - fromPos.z) ^ 2
    local dis = math.sqrt(powX + powZ)
    return dis
end

function Drone:arriveTarget(curPos, targetPos)
    if curPos.x >= targetPos.x - 0.1 and curPos.x <= targetPos.x + 0.1 and curPos.y >= targetPos.y - 0.1 and curPos.y <=
        targetPos.y + 0.1 and curPos.z >= targetPos.z - 0.1 and curPos.z <= targetPos.z + 0.1 then
        return true
    end
    return false
end

function Drone:startUp(targetBuilding, curBuilding)
    local targetPos = targetBuilding.view.operPoint.transform.position
    local curPos = curBuilding.view.operPoint.transform.position
    self.targetPos = Vector3(targetPos.x, targetPos.y + self.upHeight + self.height, targetPos.z)
    local curNor = Vector3(curPos.x, 0, curPos.z)
    local targetNor = Vector3(targetPos.x, 0, targetPos.z)
    local dire = targetNor - curNor
    local angleY = UnityEngine.Quaternion.FromToRotation(dire.normalized, UnityEngine.Vector3.forward).eulerAngles.y
    local endY = math.floor(angleY / 12)
    endY = endY + 4
    if endY > 29 then
        endY = endY - 30
    end
    self:showRes(false)
    self:setResType(0)
    self:spineAnimPlay("move", true)
    self:droneUpDown(endY, true)
end

function Drone:droneUpDown(endY, isUp)
    local temp = self.myDire

    local clockwise = endY - temp

    local isAdd = true

    if clockwise > 0 then
        isAdd = true
    else
        isAdd = false
    end

    local curX = self.drone.transform.localPosition.x
    local curZ = self.drone.transform.localPosition.z

    local curHeight = self.drone.transform.localPosition.y
    local height = self.upHeight
    if not isUp then
        height = -height
    end
    local sec = 1
    local frame = math.floor(sec / 0.03)
    local upSpeed = height / frame
    local trunSpeed = math.abs(clockwise) / frame
    local index = 0
    self:stopTrunTimer()
    self.trunTimer = gg.timer:startLoopTimer(0, 0.03, frame, function()
        if clockwise ~= 0 then
            if isAdd then
                temp = temp + trunSpeed
            else
                temp = temp - trunSpeed
            end
            local args = math.ceil(temp)
            if args > 29 then
                args = 0
            end
            if args < 0 then
                args = 29
            end
            self.myDire = args
            self:changeDirection(args)
        end
        curHeight = curHeight + upSpeed
        self.drone.transform.localPosition = Vector3.New(curX, curHeight, curZ)
        self:setShadowPos(curHeight)
        index = index + 1
        if index == frame then
            if isUp then
                self.isMove = true
                self.parabolicY = 0
                self.startPos = self.drone.transform.position
                self.moveSpeed = self.moveSpeedMin
            else
                if self.droneModel == Drone.MODEL_GET then
                    self:startGetRes()
                elseif self.droneModel == Drone.MODEL_PLACE then
                    self:startPlaceRes()
                end

            end
        end
    end)
end

function Drone:stopTrunTimer()
    if self.trunTimer then
        gg.timer:stopTimer(self.trunTimer)
        self.trunTimer = nil
    end
end

function Drone:startGetRes()
    self:spineAnimPlay("get", true)
    self:showRes(true)
    self:setResType(self.resType)

    if #self.tagerTable == 0 then
        local targetCfgID = 0
        if self.building.buildCfg.cfgId == constant.BUILD_ICEMININGTOWER then
            targetCfgID = constant.BUILD_ICECORELIBRARY
        elseif self.building.buildCfg.cfgId == constant.BUILD_TITANIUMMININGTOWER then
            targetCfgID = constant.BUILD_TITANIUMDEPOSIT
        elseif self.building.buildCfg.cfgId == constant.BUILD_GASMININGTOWER then
            targetCfgID = constant.BUILD_GASLIBRARY
        elseif self.building.buildCfg.cfgId == constant.BUILD_CARBOXYLMININGTOWER then
            targetCfgID = constant.BUILD_CARBOXYLLIDRARY
        elseif self.building.buildCfg.cfgId == constant.BUILD_MININGMACHINE then
            targetCfgID = constant.BUILD_INTERSTWLLARBANK
        end
        for k, v in pairs(gg.buildingManager:getBuildingTable()) do
            if v.buildCfg.cfgId == targetCfgID and v.owner == self.building.owner then
                table.insert(self.tagerTable, v)
            end
        end
    end

    local index = 0
    if #self.tagerTable > 0 then
        index = math.random(1, #self.tagerTable)
    end

    self:stopGetTimer()
    self.getTimer = gg.timer:startTimer(2, function()
        if index > 0 then
            self.tableBuild = self.tagerTable[index]
        else
            self.tableBuild = self.buildingBase
        end
        self.droneModel = Drone.MODEL_PLACE
        self:startUp(self.tableBuild, self.building)
    end)
end

function Drone:stopGetTimer()
    if self.getTimer then
        gg.timer:stopTimer(self.getTimer)
        self.getTimer = nil
    end

end

function Drone:startPlaceRes()
    self:spineAnimPlay("place", true)
    self:showRes(true)
    self:setResType(self.resType)
    self:stopPlaceTimer()
    self.placeTimer = gg.timer:startTimer(2, function()
        self.droneModel = Drone.MODEL_GET
        self:startUp(self.building, self.tableBuild)
    end)

end

function Drone:stopPlaceTimer()
    if self.placeTimer then
        gg.timer:stopTimer(self.placeTimer)
        self.placeTimer = nil
    end

end

function Drone:droneSetActive(bool)
    self:stopTrunTimer()
    self:stopPlaceTimer()
    self:stopGetTimer()
    self.isMove = false
    self.drone:SetActive(bool)
    if bool then
        self.myDire = 15
        self:changeDirection(self.myDire)
        self.drone.transform.position = Vector3(self.building.view.operPoint.transform.position.x,
            self.building.view.operPoint.transform.position.y + self.height,
            self.building.view.operPoint.transform.position.z)
        self:startGetRes()
    end

end

Drone.buildTwinning = {
    [constant.BUILD_ICECORELIBRARY] = constant.BUILD_ICEMININGTOWER,
    [constant.BUILD_TITANIUMDEPOSIT] = constant.BUILD_TITANIUMMININGTOWER,
    [constant.BUILD_GASLIBRARY] = constant.BUILD_GASMININGTOWER,
    [constant.BUILD_CARBOXYLLIDRARY] = constant.BUILD_CARBOXYLMININGTOWER,
    [constant.BUILD_INTERSTWLLARBANK] = constant.BUILD_MININGMACHINE
}

function Drone:onDroneSetActive(args, bool, id, cfgId)
    if id == self.building.buildData.id then
        self:droneSetActive(bool)
    end
    if Drone.buildTwinning[cfgId] then
        if Drone.buildTwinning[cfgId] == self.building.buildCfg.cfgId then
            self:droneSetActive(bool)
        end
    end
    if cfgId == constant.BUILD_BASE then
        if self.tableBuild then
            if self.tableBuild.buildCfg.cfgId == constant.BUILD_BASE then
                self:droneSetActive(bool)
            end
        end
    end
end

return Drone
