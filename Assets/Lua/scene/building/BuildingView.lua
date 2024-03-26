local BuildingView = class("BuildingView")

BuildingView.LAYER_Land = 14
BuildingView.LAYER_HIGHLIGHTED = 30
function BuildingView:ctor(building, modelName, length, width, pos, isFirst, buildCfg, owner, isInstance)
    local offsetX = length / 2
    local offsetZ = width / 2
    self.building = building
    self.length = length -- x
    self.width = width -- z
    self.pos = pos -- ""
    self.contenPos = Vector3(pos.x + offsetX, 0, pos.z + offsetZ)
    self.buildingObj = nil
    self.buildingModel = nil
    self.buildingMaterial = nil
    self.buttonUi = nil
    self.infoUi = nil
    self.operPoint = nil
    self.spine = nil
    self.arrow = nil
    self.attackRange = nil
    self.surfaces = nil
    self.isShow = false
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
            self.localY = 0
            if buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
                self.localY = -3.5
            end
            go.transform.position = self.pos
            obj.transform:SetParent(go.transform, false)
            obj.transform.localPosition = Vector3(self.length / 2, self.localY, self.width / 2)
            self.buildingObj = go
            self.arrow = go.transform:Find("MoveArrow").gameObject
            self.attackRange = go.transform:Find("Attackrange").gameObject
            self.surfaces = go.transform:Find("Surfaces").gameObject
            self.arrow.transform:Find("MoveArrow1").localPosition = Vector3(-0.5, self.localY, self.width / 2)
            self.arrow.transform:Find("MoveArrow2").localPosition = Vector3(self.length / 2, self.localY, -0.5)
            self.arrow.transform:Find("MoveArrow3").localPosition =
                Vector3(self.length + 0.5, self.localY, self.width / 2)
            self.arrow.transform:Find("MoveArrow4").localPosition =
                Vector3(self.length / 2, self.localY, self.width + 0.5)

            self.operPoint = obj.transform:Find("OperPoint")
            self.bottomPoint = obj.transform:Find("BottomPoint")

            local range = buildCfg.atkRange / 1000 * 2
            self.attackRange.transform.localScale = Vector3(range, 1, range)
            self.attackRange.transform.localPosition = Vector3(self.length / 2, self.localY, self.width / 2)
            self.infoUi = go.transform:Find("InfoUi")
            self.commonAttrItemHp = CommonAttrItem.new(self.infoUi:Find("LayoutInfo/CommonAttrItemHp"))
            self.commonAttrItemAtk = CommonAttrItem.new(self.infoUi:Find("LayoutInfo/CommonAttrItemAtk"))

            -- ""bottomUi""BottomPoint，""building2d""
            self.bottomUi = go.transform:Find("BottomUi")
            -- self.imgAlertUpgrade = self.bottomUi.transform:Find("ImgAlertUpgrade"):GetComponent(UNITYENGINE_UI_IMAGE)
            if self.bottomPoint then
                self.bottomUi.position = self.bottomPoint.transform.position
            end

            self.gridGround = go.transform:Find("GridGround")
            self.gridGround.localScale = Vector3(self.length, 1, self.width)
            self.gridGround.localPosition = Vector3(self.length / 2, self.localY + self.localY, self.width / 2)
            self.buildingMaterial = self.gridGround:GetComponent("MeshRenderer").material
            self.buildingMaterial:SetTextureScale("_MainTex", Vector2.New(self.length, self.width))

            self.buildingModel = obj
            if buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
                obj.transform:Find("Spine").eulerAngles = Vector3(45, 45, 0)

                self.spine = obj.transform:Find("Spine"):GetComponent("SkeletonAnimation")
                self.spine:SetColor(Color.New(1, 1, 1, 1))
                if buildCfg.type ~= constant.BUILD_CLUTTER then
                    self:makePlatform(buildCfg.floor)
                else
                    self:ChangeSlots(obj, buildCfg.slot)
                end
                -- self.spine.transform:GetComponent("MeshRenderer").sortingOrder = 2
                local hpBar = obj.transform:Find("Hp")
                if hpBar then
                    hpBar.gameObject:SetActive(false)
                end
            else
                self.buildingModel.transform:Find("body"):GetComponent("Animator"):SetInteger("anim", 999);
                self.gridGround.gameObject:SetActive(false)
                -- obj.transform:Find("body"):GetComponent("Animator"):SetTrigger("standby")
                -- obj.transform:Find("body"):GetComponent("Animator"):SetInteger("anim", 2)
            end
            local type = buildCfg.type
            local contenY = (self.length + self.width) / 3
            self.buildingTimeBarBox = BuildingTimeBarBox.new(go.transform:Find("BuildingTimeBarBox"))
            self.buildingTimeBarBox.transform.localPosition =
                Vector3(self.length / 3, contenY + 1 + self.localY, self.width / 3)
            self.buildingTimeBarBox:setActive(false)

            local buildingButtonUiBoxPos = self.buildingTimeBarBox.transform.localPosition
            buildingButtonUiBoxPos.y = buildingButtonUiBoxPos.y - 5
            if buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
                buildingButtonUiBoxPos = Vector3(-1, 0, -3)
            end

            -- ""
            self.resPoint = obj.transform:Find("ResPoint")
            if not self.resPoint then
                self.resPoint = CS.UnityEngine.GameObject("ResPoint")
                self.resPoint.transform:SetParent(obj.transform)
                self.resPoint.transform.localPosition = Vector3(-self.length / 2 - 0.2, contenY + self.localY,
                    self.width / 3)
            end

            -- ""
            self.alertPoint = obj.transform:Find("AlertPoint")
            if not self.alertPoint then
                self.alertPoint = CS.UnityEngine.GameObject("AlertPoint")
                self.alertPoint.transform:SetParent(obj.transform)
                self.alertPoint.transform.localPosition = Vector3(-self.length / 2 - 0.2, contenY - 0.2 + self.localY,
                    self.width / 3)
            end

            self.alertUi = go.transform:Find("AlertUi")
            self.alertUi.position = self.alertPoint.transform.position -- self.operPoint.transform.position
            self.layoutAlert = self.alertUi:Find("LayoutAlert")
            self.bgTxtAlert = self.alertUi:Find("LayoutAlert/BgTxtAlert")

            self.bgTxtAlertLeft = self.bgTxtAlert:Find("BgTxtAlertLeft")
            self.bgTxtAlertMid = self.bgTxtAlert:Find("BgTxtAlertMid")
            self.bgTxtAlertRight = self.bgTxtAlert:Find("BgTxtAlertRight")
            self.txtAlert = self.alertUi:Find("LayoutAlert/BgTxtAlert/txtAlert"):GetComponent(UNITYENGINE_UI_TEXT)

            self.infoUi.localPosition = Vector3(self.length / 2, self.localY, self.width / 2)

            if isFirst then
                self:setMaterial(0)
                self.arrow:SetActive(false)
                self.attackRange:SetActive(false)
            else
                self:setBuildingLayer(BuildingView.LAYER_HIGHLIGHTED)

                if buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
                    self:setMaterial(1)
                    local btnMap = {
                        [PnlPlayerInformation.BTN_REFUSED] = true,
                        [PnlPlayerInformation.BTN_ACCEPT] = true
                    }
                    gg.event:dispatchEvent("onShowBuildButton", true, btnMap, self.building)
                    self.arrow:SetActive(true)

                    if type == constant.BUILD_DEFENSE then
                        self.attackRange:SetActive(true)
                    end
                else
                    gg.buildingManager:requestLoadBuilding(self.building.buildCfg.cfgId, self.pos, isInstance)
                end
            end

            self:onShow()
            return true
        end, true)
        return true
    end)
end

-- BuildingView.BUILDING_TRUN_IGNORE = {constant.BUILD_TINYBLACKHOLES, constant.BUILD_EMP, constant.BUILD_MAYFLIESRAY,
--                                      constant.BUILD_BLASTMAYFLYMINES, constant.BUILD_HIGHEXPLOSIVEMAYFLYMINES}

BuildingView.platformName = {"", "Building_platform_2x2", "Building_platform_3x3", "Building_platform_4x4",
                             "Building_platform_5x5"}

function BuildingView:makePlatform(modelName)
    local size = self.length
    if size > 1 and size <= 5 then
        local model = modelName -- BuildingView.platformName[size]
        ResMgr:LoadGameObjectAsync(model, function(obj)
            obj.transform:SetParent(gg.sceneManager.terrain.transform:Find("Platform"), false)
            self.platform = obj
            self:setPlatformPos()
            return true
        end, true)
    end
end

function BuildingView:ChangeSlots(obj, name)
    local attachmentName = "res/" .. name
    obj.transform:Find("Spine"):GetComponent("SkeletonAnimation"):ChangeSlots("bin", attachmentName)
end

function BuildingView:setPlatformPos()
    if self.platform then
        local vec3 = self.contenPos
        self.platform.transform.position = vec3
    end
end

function BuildingView:spineAnimPlay()
    if not self.buildingObj then
        return
    end

    local direction = self.building.buildCfg.direction
    if direction == 0 and self.building.buildCfg.type ~= 8 then
        if self.building.buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
            local anim = self.building:getBulidingAnim()
            if anim ~= self.spine.AnimationName then
                self.spine:SpineAnimPlay(anim, true)
            end
        end
        local eff = self.buildingModel.transform:Find("Eff")
        if eff then
            eff.gameObject:SetActive(false)
        end
        local center = self.buildingModel.transform:Find("Center")
        if center then
            center.gameObject:SetActive(false)
        end

    elseif direction == 30 then
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

    elseif self.building.buildCfg.type == 8 then
        -- self:stopStoreTimer()
        -- local delay = math.random(0, 60)
        -- delay = delay / 10
        -- self.stoneTimer = gg.timer:startTimer(delay, function()
        --     self.spine:SpineAnimPlay("animation", true)
        -- end)
    end
    -- if type == constant.BUILD_DEFENSE then
    --     local cfgId = self.building.buildCfg.cfgId
    --     local subType = self.building.buildCfg.subType
    --     local bool = false
    --     for k, v in pairs(BuildingView.BUILDING_TRUN_IGNORE) do
    --         if v == cfgId then
    --             local plane = self.buildingModel.transform:Find("Plane")
    --             if plane then
    --                 plane.gameObject:SetActive(false)
    --                 self.buildingModel.transform:Find("Center").gameObject:SetActive(false)
    --             end
    --             
    --             return
    --         end
    --     end

    --     self:stopGunTrunTimer()
    --     local modelName = self.building.buildCfg.model
    --     -- print(modelName)
    --     self.spineAnimNum = 11
    --     local max = math.random(3, 5)
    --     self.gunTrunTimer = gg.timer:startLoopTimer(0, max, -1, function()
    --         local random = math.random(0, 1)
    --         self:startTrun(random)
    --         max = math.random(3, 5)
    --     end)
    -- end
    -- if type == constant.BUILD_MINAES or type == constant.BUILD_ECONIMIC or type == constant.BUILD_DEVELOPMENT then
    --     if self.building.buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
    --         self.spine:SpineAnimPlay("idle", true)
    --     end
    -- end
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

function BuildingView:stopStoreTimer()
    if self.stoneTimer then
        gg.timer:stopTimer(self.stoneTimer)
        self.stoneTimer = nil
    end
end

-- local btnSortWeight = {
--     ["btnInformation"] = 1,
--     ["btnSpeedUp"] = 2,
--     ["btnUpgrade"] = 3,
--     ["btnRecycle"] = 4,
--     ["btnTool"] = 5
-- }

function BuildingView:getButtonUI()
end

function BuildingView:refreshButton()
    if not self.buildingButtonUiBox then
        return
    end

    local type = self.building.buildCfg.type
    local cfgId = self.building.buildCfg.cfgId

    local needBtnMap = {
        ["btnInformation"] = false,
        ["btnSpeedUp"] = false,
        ["btnUpgrade"] = false,
        ["btnRecycle"] = false,
        ["btnTool"] = false,
        ["btnTool2"] = false
    }

    if self.building.owner == BuildingManager.OWNER_OWN then
        needBtnMap.btnInformation = true
        if self.building.BUILD_2_VIEW[cfgId] and self.building.buildData.level > 0 then

            if self.building.BUILD_2_VIEW[cfgId].viewName ~= nil then
                needBtnMap.btnTool = true
            end

            if self.building.BUILD_2_VIEW[cfgId].viewName2 ~= nil then
                needBtnMap.btnTool2 = true
            end
        end

        if type == constant.BUILD_DEFENSE or type == constant.BUILD_MINAES or type == constant.BUILD_CLUTTER then
            local subType = self.building.buildCfg.subType
            if (subType == 1 or subType == 3) and gg.sceneManager.playerInScene ~= constant.SCENE_BASE then
                needBtnMap.btnRecycle = true
            end
            if type == constant.BUILD_CLUTTER then
                needBtnMap.btnInformation = false
                needBtnMap.btnRecycle = true
            end
        end

        if self.building.timeBarLessTick <= 0 then
            local isLevelMax = BuildUtil.getCurBuildCfg(cfgId, self.building.buildCfg.level + 1,
                self.building.buildCfg.quality) == nil

            if self.building.buildCfg.subType ~= 2 and self.building.buildCfg.type ~= 8 and not isLevelMax then
                needBtnMap.btnUpgrade = true
            end
        else
            -- needBtnMap.btnSpeedUp = true
            needBtnMap.btnInformation = false
            needBtnMap.btnUpgrade = false
        end

        if self.building.buildData and self.building.buildData.cfgId == constant.BUILD_LIBERATORSHIP then
            if self.building.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.BUILD then
                needBtnMap.btnTool = false
                needBtnMap.btnTool2 = false
            end
        end

    elseif self.building.owner == BuildingManager.OWNER_OTHER then
        needBtnMap.btnInformation = true
        needBtnMap.btnRecycle = true
    end

    self.buildingButtonUiBox:setNeedBtnMap(needBtnMap)
end

function BuildingView:onShow()
    self.isShow = true
    self.building:onShow(self)
    self:spineAnimPlay()
end

function BuildingView:setInBuilding(temp)
    if temp > 0 then
        if not self.inBuilding then
            local model = constant.INSTALL[self.length]
            ResMgr:LoadGameObjectAsync(model, function(go)
                go.transform:SetParent(self.buildingObj.transform, false)
                go.transform.localPosition = Vector3(self.length / 2, 0.2, self.width / 2)
                self.inBuilding = go
                self:stopGunTrunTimer()
                if self.spine then
                    self.spine:SpineAnimPlay("idle", false)
                end
                return true
            end, true)
        end
    else
        if self.inBuilding then
            ResMgr:ReleaseAsset(self.inBuilding)
            self:spineAnimPlay()
            self.inBuilding = nil
        end
    end
end

-- ""
function BuildingView:setPos(pos, isRefreshSurface)
    if not self.buildingObj then
        return
    end

    local offsetX = self.length / 2
    local offsetZ = self.width / 2
    self.pos = Vector3(pos.x, pos.y, pos.z)
    self.contenPos = Vector3(pos.x + offsetX, 0, pos.z + offsetZ)
    local sequence = CS.DG.Tweening.DOTween.Sequence()

    if self.platform then
        sequence:Join(self.platform.transform:DOMove(self.contenPos, 0.2):OnComplete(function()
            self:setPlatformPos()
        end))
    end
    sequence:Join(self.buildingObj.transform:DOLocalMove(self.pos, 0.2):OnComplete(function()
        gg.event:dispatchEvent("onMoveFollow")
        gg.event:dispatchEvent("onUpdataMove")
        self:setPlatformPos()
        if isRefreshSurface then
            self.building:refreshSurfaceData(true)
        end
    end))
end

function BuildingView:setBuildingLayer(layer)
    if layer == BuildingView.LAYER_HIGHLIGHTED then
        mainCamera.transform:Find("HighlightedCamera").gameObject:SetActive(true)
    else
        mainCamera.transform:Find("HighlightedCamera").gameObject:SetActive(false)
    end
    if self.spine then
        self.arrow.layer = layer
        -- self.gridGround.gameObject.layer = layer
        self.spine.gameObject.layer = layer
        local count = self.arrow.transform.childCount
        for i = 0, count - 1 do
            self.arrow.transform:GetChild(i).gameObject.layer = layer
        end
        if self.inBuilding then
            self.inBuilding.transform:Find("Spine").gameObject.layer = layer
        end
    end

    if self.buildingTimeBarBox then
        Utils.deepSetLayer(layer, self.buildingTimeBarBox.transform)
    end
end

-- ""
function BuildingView:onMoveBuilding(pos)
    gg.event:dispatchEvent("onMoveFollowHide")
    self.buildingTimeBarBox:setActive(false)

    self:setBuildingLayer(BuildingView.LAYER_HIGHLIGHTED)
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
        self:setPlatformPos()

        AudioFmodMgr:Play2DOneShot(constant.AUDIO_BUILDING_MOVE.event, constant.AUDIO_BUILDING_MOVE.bank, 1)
        -- AudioFmodMgr:PlaySFX(constant.AUDIO_BUILDING_MOVE.event)
        local isEx = gg.buildingManager:isExchangeBuilding(self.pos, self.length, self.width)
        -- local isSpace = gg.buildingManager:boolGridTable(self.pos, self.length, self.width)

        if isEx then
            gg.buildingManager:exchangeBuilding(true)
            self:setMaterial(1)
            if not self.building.buildData then
                gg.event:dispatchEvent("onShowBuildButtonAccept", true)
            end

            self.building.onSpace = true
            self.building:refreshAlert()
        else
            gg.buildingManager:exchangeBuilding(false)
            self:setMaterial(2)
            if not self.building.buildData then
                gg.event:dispatchEvent("onShowBuildButtonAccept", false)
            end

            self.building.onSpace = false
        end
    end
end

-- ""
function BuildingView:onMoveLiberaborShip(pos)
    self.buildingModel.transform.localPosition = Vector3(self.length / 2, 0, self.width / 2)
    -- local integerX, decimalX = math.modf(pos.x)
    -- local integerZ, decimalZ = math.modf(pos.z)

    -- if decimalX >= 0.5 then
    --     integerX = integerX + 1
    -- end
    -- if decimalZ >= 0.5 then
    --     integerZ = integerZ + 1
    -- end

    if pos.x ~= self.pos.x or pos.z ~= self.pos.z then
        local oldKey = self.building.liberaborShipTableKey
        local newPos = pos -- Vector3(integerX, 0, integerZ)
        local newKey = 0
        -- local firstPos = constant.BUILD_LIBERATORSHIPPOSLIST[newKey]
        -- local firstVec = Vector3(firstPos[1], 0, firstPos[2])
        -- local distanceMin = Vector3.Distance(newPos, firstVec)
        local liberaborShipMax = #gg.buildingManager.liberaborShipTable
        for k, v in ipairs(constant.BUILD_LIBERATORSHIPPOSLIST) do
            if k > liberaborShipMax then
                break
            end
            if newPos.x >= v[1] and newPos.x <= v[1] + self.length then
                newKey = k
                break
            end
        end
        if newKey == 0 then
            return
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
    if not self.buildingObj then
        return
    end
    if self.isShow then
        self:setMaterial(0)
        self.buildingModel.transform.localPosition = Vector3(self.length / 2, self.localY, self.width / 2)

        self.betweenShipKey = nil
    end
    self:setBuildingLayer(BuildingView.LAYER_Land)

    self.buildingTimeBarBox:setActive(self.building.timeBarLessTick and self.building.timeBarLessTick > 0)
end

-- ""
function BuildingView:setMaterial(type)
    if self.gridGround then
        if type == 0 then
            self.gridGround.gameObject:SetActive(false)
        else
            self.gridGround.gameObject:SetActive(true)
            self.buildingMaterial:SetColor("_TintColor", self.getColor(type))
        end
    end

end

function BuildingView.getColor(type)
    -- type = 0""； type = 1""；  type = 2""
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

function BuildingView:destroy()
    self:stopGunTrunTimer()
    self:stopTrunTimer()
    self:stopStoreTimer()

    self.commonAttrItemHp:release()
    self.commonAttrItemAtk:release()
    if self.inBuilding then
        ResMgr:ReleaseAsset(self.inBuilding)
    end
    if self.platform then
        ResMgr:ReleaseAsset(self.platform)
    end
    ResMgr:ReleaseAsset(self.buildingModel)
    ResMgr:ReleaseAsset(self.buildingObj)

    self.inBuilding = nil
    self.platform = nil
    self.buildingObj = nil
    self.buildingModel = nil
    self.buildingMaterial = nil
    self.buttonUi = nil
    self.operPoint = nil
    self.spine = nil
    if self.buildingTimeBarBox then
        self.buildingTimeBarBox:release()
        self.buildingTimeBarBox = nil
    end
    -- if self.summit then
    --     ResMgr:ReleaseAsset(self.summit)
    --     self.summit = nil
    -- end
    self.building = nil
    gg.event:dispatchEvent("onShowBuildButton", false)

end

return BuildingView
