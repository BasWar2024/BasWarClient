local BuildingView = class("BuildingView")

BuildingView.onePos = {{
    pos = Vector3(0, 0, 0),
    rot = Vector3(0, 0, 0)
}}

BuildingView.twoPos = {{
    pos = Vector3(-0.7, 0, 0),
    rot = Vector3(0, 0, 40)
}, {
    pos = Vector3(0.7, 0, 0),
    rot = Vector3(0, 0, -40)
}}

BuildingView.threePos = {{
    pos = Vector3(-1, 0, 0),
    rot = Vector3(0, 0, 60)
}, {
    pos = Vector3(0, 0.5, 0),
    rot = Vector3(0, 0, 0)
}, {
    pos = Vector3(1, 0, 0),
    rot = Vector3(0, 0, -60)
}}

BuildingView.fourPos = {{
    pos = Vector3(-1.5, 0, 0),
    rot = Vector3(0, 0, 90)
}, {
    pos = Vector3(-0.6, 0.8, 0),
    rot = Vector3(0, 0, 30)
}, {
    pos = Vector3(0.6, 0.8, 0),
    rot = Vector3(0, 0, -30)
}, {
    pos = Vector3(1.5, 0, 0),
    rot = Vector3(0, 0, -90)
}}

function BuildingView:ctor(building, modelName, length, width, pos, isFirst, buildCfg, owner)
    local offsetX = length / 2
    local offsetZ = width / 2
    self.building = building
    self.length = length -- x
    self.width = width -- z
    self.pos = pos -- 
    self.contenPos = Vector3(pos.x + offsetX, 0, pos.z + offsetZ)
    self.buildingObj = nil
    self.buildingModel = nil
    self.buildingMaterial = nil
    self.topUi = nil
    self.buttonUi = nil
    self.infoUi = nil
    self.barTime = nil
    self.operPoint = nil
    self.spine = nil
    self:loadGameObject(isFirst, modelName, buildCfg, owner)
end

function BuildingView:loadGameObject(isFirst, modelName, buildCfg, owner)
    ResMgr:LoadGameObjectAsync("Building2D", function(go)
        ResMgr:LoadGameObjectAsync(modelName, function(obj)
            go.name = modelName
            if owner == BuildingManager.OWNER_OWN then
                go.transform:SetParent(gg.buildingManager.ownBase.transform, false)
            else
                go.transform:SetParent(gg.buildingManager.otherBase.transform, false)
            end
            go.transform.position = self.pos
            obj.transform:SetParent(go.transform, false)
            obj.transform.localPosition = Vector3(self.length / 2, 0, self.width / 2)

            self.buildingObj = go
            self.topUi = go.transform:Find("TopUi")
            self.infoUi = go.transform:Find("InfoUi")
            self.buttonUi = go.transform:Find("ButtonUi")
            self.btnTool = self.buttonUi:Find("BtnTool").gameObject

            self.buttonOnBuild = go.transform:Find("TimeBar/ButtonOnBuild").gameObject
            self.btnBuildSpeedUp = self.buttonOnBuild.transform:Find("BtnBuildSpeedUp").gameObject
            self.txtBuildSpeedUpCost = self.btnBuildSpeedUp.transform:Find("TxtBuildSpeedUpCost"):GetComponent(
                "TextMesh")

            self.gridGround = go.transform:Find("GridGround")
            self.gridGround.localScale = Vector3(self.length, 1, self.width)
            self.gridGround.localPosition = Vector3(self.length / 2, 0, self.width / 2)
            self.buildingMaterial = self.gridGround:GetComponent("MeshRenderer").material

            self.buildingMaterial:SetTextureScale("_MainTex", Vector2.New(self.length, self.width))

            self.buildingModel = obj
            self.operPoint = obj.transform:Find("OperPoint")
            if buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
                obj.transform:Find("Spine").eulerAngles = Vector3(45, 45, 0)
                self.spine = obj.transform:Find("Spine"):GetComponent("SkeletonAnimation")
                local hpBar = obj.transform:Find("Hp")
                if hpBar then
                    hpBar.gameObject:SetActive(false)
                end
            else
                self.gridGround.gameObject:SetActive(false)
                obj.transform:Find("body"):GetComponent("Animator"):SetTrigger("standby")
            end

            if buildCfg.type ~= constant.BUILD_CLUTTER then
                local contenY = (self.length + self.width) / 3
                go.transform:Find("TimeBar").localPosition = Vector3(self.length / 3, contenY, self.width / 3)
                self.barTime = go.transform:Find("TimeBar/TimeBar")
                self.barTime.gameObject:SetActive(false)
                self.barTimeIconUp = go.transform:Find("TimeBar/TimeBar/BgBar/IconUp"):GetComponent("SpriteRenderer")
            end
            if isFirst then
                self:setMaterial(0)
                self.topUi.gameObject:SetActive(false)

            else
                if buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
                    self:setMaterial(1)
                    self.topUi.gameObject:SetActive(true)
                else
                    gg.buildingManager:requestLoadBuilding(self.building.buildCfg.cfgId, self.pos)

                end
            end

            self.topUi.position = self.operPoint.transform.position
            self.buttonUi.position = self.operPoint.transform.position
            self.infoUi.localPosition = Vector3(self.length / 2, 0, self.width / 2)
            self:onShow()
            return true
        end, true)
        return true
    end)
end

function BuildingView:spineAnimPlay()
    local type = self.building.buildCfg.type
    if type == constant.BUILD_DEFENSE then
        local subType = self.building.buildCfg.subType
        if subType == 2 then
            self.spine:SpineAnimPlay("idle", true)
            return
        end
        self:stopGunTrunTimer()
        local modelName = self.building.buildCfg.model
        -- print(modelName)
        self.spineAnimNum = 11
        local max = math.random(3, 5)
        self.gunTrunTimer = gg.timer:startLoopTimer(0, max, -1, function()
            local random = math.random(0, 1)
            self:startTrun(random)
            max = math.random(3, 5)
        end)
    end
    if type == constant.BUILD_MINAES or type == constant.BUILD_ECONIMIC or type == constant.BUILD_DEVELOPMENT then
        if self.building.buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
            self.spine:SpineAnimPlay("idle", true)
        end
    end
end

function BuildingView:startTrun(direction)
    local max = math.random(3, 5)
    self:stopTrunTimer()
    self.trunTimer = gg.timer:startLoopTimer(0, 0.1, max, function()
        if direction == 0 then
            self.spineAnimNum = self.spineAnimNum + 1
        else
            self.spineAnimNum = self.spineAnimNum - 1
        end
        if self.spineAnimNum < 0 then
            self.spineAnimNum = 29
        end
        if self.spineAnimNum > 29 then
            self.spineAnimNum = 0
        end
        local animName = "idle_" .. self.spineAnimNum
        self.spine:SpineAnimPlay(animName, true)
    end)
end

function BuildingView:stopTrunTimer()
    if self.trunTimer then
        gg.timer:stopTimer(self.trunTimer)
        self.trunTimer = nil
    end
end

function BuildingView:stopGunTrunTimer()
    if self.gunTrunTimer then
        gg.timer:stopTimer(self.gunTrunTimer)
        self.gunTrunTimer = nil
    end
end

function BuildingView:refreshButton()
    local type = self.building.buildCfg.type
    local cfgId = self.building.buildCfg.cfgId
    local btnPos = nil
    local needBtn = {"BtnInformation", "BtnUpgrade", "BtnRecycle", "BtnTool"}

    if self.building.owner == BuildingManager.OWNER_OWN then
        if type == constant.BUILD_ECONIMIC then
            needBtn = {"BtnInformation", "BtnUpgrade"}
        end
        if type == constant.BUILD_DEVELOPMENT then
            if cfgId == constant.BUILD_BASE or cfgId == constant.BUILD_STARALLIANCESHIPS or cfgId ==
                constant.BUILD_ENERGYRUBIKSCUBE or cfgId == constant.BUILD_PLANETARYEYE then
                needBtn = {"BtnInformation", "BtnUpgrade"}
            else
                needBtn = {"BtnInformation", "BtnUpgrade", "BtnTool"}
            end
        end
        if type == constant.BUILD_DEFENSE or type == constant.BUILD_MINAES then
            needBtn = {"BtnInformation", "BtnUpgrade", "BtnRecycle"}
        end
        if type == constant.BUILD_CLUTTER then
            needBtn = {"BtnInformation", "BtnRecycle"}
        end
    elseif self.building.owner == BuildingManager.OWNER_OTHER then
        needBtn = {"BtnInformation", "BtnRecycle"}
    end

    local num = 0

    for k, v in ipairs(needBtn) do
        if v then
            num = num + 1
        end
    end

    if num == 1 then
        btnPos = BuildingView.onePos
    end
    if num == 2 then
        btnPos = BuildingView.twoPos
    end
    if num == 3 then
        btnPos = BuildingView.threePos
    end
    if num == 4 then
        btnPos = BuildingView.fourPos
    end
    local max = self.buttonUi.transform.childCount
    for i = 1, max do
        self.buttonUi.transform:GetChild(i - 1).gameObject:SetActive(false)
    end
    for i = 1, #needBtn do
        self.buttonUi.transform:Find(needBtn[i]).gameObject:SetActive(true)
        self.buttonUi.transform:Find(needBtn[i]).localPosition = btnPos[i].pos
        self.buttonUi.transform:Find(needBtn[i]).localEulerAngles = btnPos[i].rot
    end

end

function BuildingView:onShow()
    self.building:onShow()
    self:spineAnimPlay()
end

-- 
function BuildingView:setPos(pos)
    local offsetX = self.length / 2
    local offsetZ = self.width / 2
    self.pos = pos
    self.contenPos = Vector3(pos.x + offsetX, 0, pos.z + offsetZ)
    self.buildingObj.transform.position = self.pos
end

-- 
function BuildingView:onMoveBuilding(pos)
    local offsetX = self.length / 2
    local offsetZ = self.width / 2
    local integerOffsetX, decimalOffsetX = math.modf(offsetX)
    local integerOffsetZ, decimalOffsetZ = math.modf(offsetZ)
    if decimalOffsetX ~= 0 then
        pos.x = pos.x + 0.5
        pos.z = pos.z + 0.5
        offsetX = offsetX + 0.5
    end
    if decimalOffsetZ ~= 0 then
        pos.x = pos.x + 0.5
        pos.z = pos.z + 0.5
        offsetZ = offsetZ + 0.5
    end

    local integerX, decimalX = math.modf(pos.x)
    local integerZ, decimalZ = math.modf(pos.z)

    if decimalX >= 0.5 then
        integerX = integerX + 1
    end
    if decimalZ >= 0.5 then
        integerZ = integerZ + 1
    end

    if integerX - offsetX ~= self.pos.x or integerZ - offsetZ ~= self.pos.z then
        self.pos = Vector3(integerX - offsetX, 0, integerZ - offsetZ)
        local addX = 0
        local addZ = 0
        if decimalOffsetX ~= 0 then
            addX = 0.5
        end
        if decimalOffsetZ ~= 0 then
            addZ = 0.5
        end
        self.contenPos = Vector3(integerX - addX, 0, integerZ - addZ)
        self.buildingObj.transform.position = self.pos
        if gg.buildingManager:boolGridTable(self.pos, self.length, self.width) then
            self:setMaterial(1)
            self.topUi:Find("BtnTick").gameObject:SetActive(true)
            self.building.onSpace = true
        else
            self:setMaterial(2)
            self.topUi:Find("BtnTick").gameObject:SetActive(false)
            self.building.onSpace = false
        end
    end
end

-- 
function BuildingView:onMoveLiberaborShip(pos)
    self.buildingModel.transform.localPosition = Vector3(self.length / 2, 1, self.width / 2)

    local integerX, decimalX = math.modf(pos.x)
    local integerZ, decimalZ = math.modf(pos.z)

    if decimalX >= 0.5 then
        integerX = integerX + 1
    end
    if decimalZ >= 0.5 then
        integerZ = integerZ + 1
    end

    if integerX ~= self.pos.x or integerZ ~= self.pos.z then
        local oldKey = self.building.liberaborShipTableKey
        local newPos = Vector3(integerX, 0, integerZ)
        local newKey = 1
        local firstPos = constant.BUILD_LIBERATORSHIPPOSLIST[newKey]
        local firstVec = Vector3(firstPos[1], 0, firstPos[2])
        local distanceMin = Vector3.Distance(newPos, firstVec)
        local liberaborShipMax = #gg.buildingManager.liberaborShipTable
        for k, v in ipairs(constant.BUILD_LIBERATORSHIPPOSLIST) do
            if k > liberaborShipMax then
                break
            end
            local vec = Vector3(v[1], 0, v[2])
            local distance = Vector3.Distance(newPos, vec)
            if distance <= distanceMin then
                newKey = k
                distanceMin = distance
            end
        end
        local endPos = constant.BUILD_LIBERATORSHIPPOSLIST[newKey]
        local endVec = Vector3(endPos[1], 0, endPos[2])
        self:setPos(endVec)
        self.building.temporaryKey = newKey
        gg.buildingManager:exchangeLiberaborShip(newKey, oldKey, self.betweenShipKey)
        self.betweenShipKey = newKey

    end
end

function BuildingView:onReleaseFinger()
    self:setMaterial(0)
    self.buildingModel.transform.localPosition = Vector3(self.length / 2, 0, self.width / 2)
    self.betweenShipKey = nil
end

-- 
function BuildingView:setMaterial(type)
    if type == 0 then
        self.gridGround.gameObject:SetActive(false)
    else
        self.gridGround.gameObject:SetActive(true)
        self.buildingMaterial:SetColor("_Color", self.getColor(type))
    end
end

function BuildingView.getColor(type)
    -- type = 0 type = 1  type = 2
    local colorR = 0
    local colorG = 0
    local colorB = 0
    local colorA = 0
    if type == 0 then
        colorR = 128 / 255
        colorG = 128 / 255
        colorB = 128 / 255
        colorA = 0 / 255
    end
    if type == 1 then
        colorR = 40 / 255
        colorG = 243 / 255
        colorB = 64 / 255
        colorA = 200 / 255
    end
    if type == 2 then
        colorR = 243 / 255
        colorG = 44 / 255
        colorB = 40 / 255
        colorA = 200 / 255
    end

    return Color.New(colorR, colorG, colorB, colorA)
end

function BuildingView:setTimeBar(args, sec)
    -- args 0~1
    if not self.barTime then
        return
    end
    self.barTime:GetComponent("SpriteRenderer").size = Vector2.New(args * 1.48, 0.21)
    local str = gg.time:hms_string(sec)
    self.barTime:Find("BgBar/TxtTime"):GetComponent("TextMesh").text = str
end

function BuildingView:setTimeBarIcon(spriteName)
    if not self.barTimeIconUp then
        return
    end
    local defaultLenth = 0.2
    ResMgr:LoadSpriteAsync(spriteName, function(sprite)
        local persent = defaultLenth / sprite.bounds.size.y
        if self.barTimeIconUp.gameObject then
            self.barTimeIconUp.sprite = sprite
            self.barTimeIconUp.transform.localScale = Vector3(persent, persent, 1)
        end
    end)
end

function BuildingView:destroy()
    ResMgr:ReleaseAsset(self.buildingModel)
    ResMgr:ReleaseAsset(self.buildingObj)
    self:stopGunTrunTimer()
    self:stopTrunTimer()
    self.buildingObj = nil
    self.buildingModel = nil
    self.buildingMaterial = nil
    self.topUi = nil
    self.buttonUi = nil
    self.barTime = nil
    self.operPoint = nil
    self.spine = nil
end

return BuildingView
