GalaxyMap = class("GalaxyMap")

function GalaxyMap:ctor()
    self.galaxyMapData = nil -- ""
    -- self.mapArea = nil -- ""
    self.destroyTimer = nil -- ""
    self.areaInVisual = nil -- ""

    self:loadGalaxyGround(function()
        local onLookcfgIds = gg.galaxyManager:getOnLookcfgIds()
        if onLookcfgIds then
            GalaxyData.C2S_Player_SubscribeGrids(onLookcfgIds)
        end

        self:onShow(false)
    end)

end

function GalaxyMap:onShow(isReset)
    LOAD_PERCENT = 100
    gg.event:addListener("onCameraVisualRangeInGalaxy", self)
    gg.event:addListener("onSubGalaxyGrids", self)
    gg.event:addListener("onEnterResPlanet", self)
    gg.event:addListener("onUpdateGround", self)
    gg.event:addListener("onUpdateGrounds", self)
    gg.event:addListener("onRefreshBeginGrid", self)

    local pos = gg.galaxyManager.onLookConten
    if not pos then
        pos = Vector2.New(0, 0)
    end
    local curCfg = gg.galaxyManager:getGalaxyCfg(gg.galaxyManager:pos2CfgId(pos.x, pos.y))

    gg.warCameraCtrl:setCameraPos(false, gg.warCameraCtrl.MODEL_GALAXY, curCfg.worldPos.x, curCfg.worldPos.z)

    self:stopDestroyTimer()

    self:mergeGrids()
    if isReset then
        self:UpdateGroundsStatus()
    end

    if gg.galaxyManager.isShowEnterResPlanet then
        self:showEnterResPlanet(gg.galaxyManager.isShowEnterResPlanetCfgId)
        gg.galaxyManager.isShowEnterResPlanet = false
    end
end

function GalaxyMap:onHide(callback)
    gg.event:removeListener("onCameraVisualRangeInGalaxy", self)
    gg.event:removeListener("onSubGalaxyGrids", self)
    gg.event:removeListener("onEnterResPlanet", self)
    gg.event:removeListener("onUpdateGround", self)
    gg.event:removeListener("onUpdateGrounds", self)
    gg.event:removeListener("onRefreshBeginGrid", self)

    -- self:stopDestroyTimer() 
    -- self.destroyTimer = gg.timer:startTimer(30, function()
    --     self:onDestroy(callback)
    -- end)
end

function GalaxyMap:onDestroy(callback)
    gg.warCameraCtrl:clearCameraPosInGalaxy()

    self:stopDestroyTimer()

    for k, v in pairs(self.galaxyMapData) do
        ResMgr:ReleaseAsset(v.goStatus)
        ResMgr:ReleaseAsset(v.go)
        v.goStatus = nil
        v.go = nil
        v.cellvalue = nil
    end
    self.galaxyMapData = nil
    self.lastInVisual = nil
    self.areaInVisual = nil
    -- for k, v in pairs(self.mapArea) do
    --     UnityEngine.GameObject.Destroy(v.go)
    -- end
    -- self.mapArea = nil
    if callback then
        callback()
    end
end

function GalaxyMap:stopDestroyTimer()
    if self.destroyTimer then
        gg.timer:stopTimer(self.destroyTimer)
        self.destroyTimer = nil
    end
end

function GalaxyMap:loadGalaxyGround(callback)
    self.galaxyMapData = {}
    self.lastInVisual = {}
    -- self.mapArea = {}
    local galaxyMapCfgCount = 0
    local loadGameObjecCount = 1

    local onLookMembers = gg.galaxyManager.onLookMembers

    for k, v in pairs(onLookMembers) do
        galaxyMapCfgCount = galaxyMapCfgCount + 1
    end
    local minloadPercent = LOAD_PERCENT
    self:batchLoadGalaxyGround(galaxyMapCfgCount, loadGameObjecCount, minloadPercent, callback)
end

function GalaxyMap:batchLoadGalaxyGround(galaxyMapCfgCount, loadGameObjecCount, minloadPercent, callback)
    if loadGameObjecCount >= galaxyMapCfgCount then
        return
    end
    local initCount = loadGameObjecCount
    for i = initCount, initCount + 10, 1 do
        loadGameObjecCount = i
        if loadGameObjecCount <= galaxyMapCfgCount then
            local index = loadGameObjecCount
            local curCfg = gg.galaxyManager.onLookMembers[i]
            local data = GalaxyData.galaxyBrief[curCfg.cfgId]
            ResMgr:LoadGameObjectAsync("GalaxyGround", function(go)
                ResMgr:LoadGameObjectAsync("GridStatus", function(goStatus)
                    goStatus.transform:SetParent(gg.buildingManager.galaxyStatus.transform, false)
                    goStatus.transform.position = Vector3(curCfg.worldPos.x, curCfg.worldPos.y, curCfg.worldPos.z)

                    go.transform:SetParent(gg.buildingManager.galaxy.transform, false)
                    go.transform.position = Vector3(curCfg.worldPos.x, curCfg.worldPos.y, curCfg.worldPos.z)
                    go.name = curCfg.cfgId

                    table.insert(self.lastInVisual, curCfg.cfgId)
                    local status = 0
                    local belong = 0
                    if curCfg.type == -1 then
                        go:SetActiveEx(false)
                        goStatus:SetActiveEx(false)
                    else
                        go:SetActiveEx(true)
                        goStatus:SetActiveEx(true)
                    end
                    local parentGrid = curCfg.parentGrid
                    if parentGrid == 0 then
                        if data then
                            status = data.status
                            belong = data.belong
                        end
                    else
                        local parentBrief = GalaxyData.galaxyBrief[parentGrid]
                        if parentBrief then
                            status = 0
                            belong = parentBrief.belong
                        end
                    end

                    self.galaxyMapData[curCfg.cfgId] = {
                        go = go,
                        goStatus = goStatus,
                        cfg = curCfg,
                        belong = belong,
                        status = status,
                        color = 1,
                        cellvalue = {0, 0, 0, 0, 0, 0}
                    }

                    self:setGroundBelong(self.galaxyMapData[curCfg.cfgId])
                    if index == galaxyMapCfgCount then
                        if callback then
                            callback()
                        end
                    end
                    return true
                end, true)
                return true
            end, true)
        end
    end
    loadGameObjecCount = loadGameObjecCount + 1

    if LOAD_PERCENT < 100 then
        LOAD_PERCENT = loadGameObjecCount / galaxyMapCfgCount * 100
        if LOAD_PERCENT < minloadPercent then
            LOAD_PERCENT = minloadPercent
        end
        if LOAD_PERCENT > 90 then
            LOAD_PERCENT = 90
        end
    end
    local timer = gg.timer:startTimer(0.03, function()
        self:batchLoadGalaxyGround(galaxyMapCfgCount, loadGameObjecCount, minloadPercent, callback)
    end)
end

function GalaxyMap:onUpdateGround(args, data)
    if self.galaxyMapData[data.cfgId] then
        if #self.galaxyMapData[data.cfgId].cfg.groupGrid > 0 then
            for k, v in pairs(self.galaxyMapData[data.cfgId].cfg.groupGrid) do
                if self.galaxyMapData[v] then
                    self.galaxyMapData[v].belong = data.belong
                    if v == data.cfgId then
                        self.galaxyMapData[v].status = data.status
                    end
                    self:setGroundBelong(self.galaxyMapData[v])
                end
            end
        else
            self.galaxyMapData[data.cfgId].belong = data.belong
            self.galaxyMapData[data.cfgId].status = data.status
            self:setGroundBelong(self.galaxyMapData[data.cfgId])
        end

    end
end

function GalaxyMap:onUpdateGrounds(args, datas)
    for k, data in pairs(datas) do
        self:onUpdateGround(nil, data)
    end

    self:mergeGrids()
end

function GalaxyMap:UpdateGroundsStatus()
    for k, v in pairs(self.galaxyMapData) do
        local data = GalaxyData.galaxyBrief[v.cfg.cfgId]
        if data then
            self:setGroundBelong(v)
        end
    end
end

function GalaxyMap:onRefreshBeginGrid(args, oldId, newId)
    if self.galaxyMapData[oldId] then
        self:setGroundBelong(self.galaxyMapData[oldId])
    end
    if self.galaxyMapData[newId] then
        self:setGroundBelong(self.galaxyMapData[newId])
    end
end

function GalaxyMap:setGroundStatus(goStatus, status, resIcon, parentGrid, cfgId)
    local statu = status or 0
    local resIcon = resIcon or "0"
    -- 0."" 1."" 2.""
    if statu == 0 then
        goStatus.transform:Find("Fighting").gameObject:SetActive(false)
        goStatus.transform:Find("Protecting").gameObject:SetActive(false)
    elseif statu == 1 then
        goStatus.transform:Find("Fighting").gameObject:SetActive(true)
        goStatus.transform:Find("Protecting").gameObject:SetActive(false)
    elseif statu == 2 then
        goStatus.transform:Find("Fighting").gameObject:SetActive(false)
        goStatus.transform:Find("Protecting").gameObject:SetActive(true)
    end

    local resTran = goStatus.transform:Find("Res").transform
    local childNum = resTran.childCount

    for i = 0, childNum - 1, 1 do
        resTran:GetChild(i).gameObject:SetActive(false)
    end
    if resIcon ~= "0" then
        local func = function()
            resTran.gameObject:SetActive(true)
            resTran:Find(resIcon).gameObject:SetActive(true)
        end
        if parentGrid == 0 then
            func()
            local chain = gg.galaxyManager:isSpecialGround(cfgId)
            local hyChainPos = GalaxyMap:getChainIconPos(resIcon)
            if chain ~= 0 and hyChainPos then
                local chainName = constant.getNameByChain(chain)
                resTran:Find(chainName).gameObject:SetActive(true)
                resTran:Find(chainName).transform.localPosition = hyChainPos
            end
        elseif gg.galaxyManager:isSpecialGround(parentGrid) == -1 then
            func()
        end
    end
end

function GalaxyMap:getChainIconPos(resIcon)
    local resIcons = {
        ["Hydroxyl1_icon"] = Vector3.New(0.372, 0.175, -0.929),
        ["Hydroxyl2_icon"] = Vector3.New(0.372, 0.175, -0.929),
        ["Hydroxyl3_icon"] = Vector3.New(0.372, 0.175, -0.929),
        ["Hydroxyl4_icon"] = Vector3.New(0.372, 0.175, -0.929),
        ["Hydroxyl5_icon"] = Vector3.New(0.372, 0.175, -0.929),
        ["Hydroxyl6_icon"] = Vector3.New(0.372, 0.175, -0.929),
        ["Hydroxyl7_icon"] = Vector3.New(0.372, 0.175, -0.929)
    }
    if resIcons[resIcon] then
        return resIcons[resIcon]
    else
        return Vector3.New(0.15, 0.175, -0.356)
    end
end

GalaxyMap.groundColor = {"White", "Green", "Red", "Blue", "Orange", "Black", "Gray"}

function GalaxyMap:setGroundColor(index, go)

    for i, v in ipairs(GalaxyMap.groundColor) do
        if i == index and i ~= 6 then
            go.transform:Find(v).gameObject:SetActive(true)
        else
            go.transform:Find(v).gameObject:SetActive(false)
        end
    end
end

function GalaxyMap:setGroundBelong(galaxyMapData)
    if not galaxyMapData then
        return
    end

    local go = galaxyMapData.go
    local goStatus = galaxyMapData.goStatus
    local curCfg = galaxyMapData.cfg
    local type = curCfg.type
    local cfgId = curCfg.cfgId
    local resIcon = curCfg.resIcon
    local parentGrid = curCfg.parentGrid
    local belong = galaxyMapData.belong
    local status = galaxyMapData.status
    local color = 1

    if curCfg.isBan ~= 1 or gg.galaxyManager:isSpecialGround(curCfg.cfgId) == -1 then
        self:setGroundColor(6, go)
        goStatus.transform:Find("Fighting").gameObject:SetActive(false)
        goStatus.transform:Find("Protecting").gameObject:SetActive(false)
        goStatus.transform:Find("Res").gameObject:SetActive(false)
    else
        -- "":0-"" 1-"" 2-"" 3-""
        if belong == 0 then
            if #curCfg.groupGrid == 0 then
                color = 1
            else
                if gg.galaxyManager:isSpecialGround(curCfg.cfgId) == -1 or gg.galaxyManager:isSpecialGround(curCfg.parentGrid) == -1 then
                    color = 1
                else
                    color = 7
                end
            end
        elseif belong == 1 then
            color = 2

        elseif belong == 2 then
            color = 4
        elseif belong == 3 then
            color = 3
        end

        if type == 3 then
            if UnionData.beginGridId == cfgId then
                color = 4
            else
                color = 5
            end
        end
        galaxyMapData.color = color
        self:setGroundColor(color, go)

        self:setGroundStatus(goStatus, status, resIcon, parentGrid, cfgId)
    end
end

-- function GalaxyMap:getArea(key, cfgId)
--     if self.mapArea[key] then
--         table.insert(self.mapArea[key].member, cfgId)
--         return self.mapArea[key].go.transform
--     else
--         local go = UnityEngine.GameObject(key)
--         go.transform:SetParent(gg.buildingManager.galaxy.transform, false)
--         go.transform.position = Vector3(0, 0, 0)
--         local data = {
--             go = go,
--             member = {cfgId}
--         }
--         self.mapArea[key] = data
--         return go.transform
--     end
-- end

function GalaxyMap:getAround(cfgId)
    local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
    local x = curCfg.pos.x
    local y = curCfg.pos.y

    local lookAround = function(i, j)
        local curCfg = gg.galaxyManager:pos2CfgId(i, j)
        if self.galaxyMapData[curCfg] then
            if UnionData.beginGridId == curCfg then
                return true
            end
            local cfg = gg.galaxyManager:getGalaxyCfg(curCfg)
            if cfg.parentGrid ~= 0 and gg.galaxyManager:isSpecialGround(cfg.parentGrid) ~= -1 then
                curCfg = cfg.parentGrid
            end
            local data = GalaxyData.galaxyBrief[curCfg]
            if data then
                if data.belong == 1 or data.belong == 2 then
                    return true
                end
            end
        end
        return false
    end

    -- if lookAround(x, y - 1) then
    --     return true
    -- end
    -- if lookAround(x + 1, y) then
    --     return true
    -- end
    -- if lookAround(x, y + 1) then
    --     return true
    -- end
    -- if lookAround(x - 1, y) then
    --     return true
    -- end
    local haveParent = #curCfg.groupGrid
    if haveParent == 0 then
        if lookAround(x + 1, y - 1) then
            return true
        end
        if lookAround(x + 1, y) then
            return true
        end
        if lookAround(x, y + 1) then
            return true
        end
        if lookAround(x - 1, y + 1) then
            return true
        end
        if lookAround(x - 1, y) then
            return true
        end
        if lookAround(x, y - 1) then
            return true
        end
    else
        for k, v in pairs(curCfg.groupGrid) do
            local newCfg = gg.galaxyManager:getGalaxyCfg(v)
            local x = newCfg.pos.x
            local y = newCfg.pos.y

            if lookAround(x + 1, y - 1) then
                return true
            end
            if lookAround(x + 1, y) then
                return true
            end
            if lookAround(x, y + 1) then
                return true
            end
            if lookAround(x - 1, y + 1) then
                return true
            end
            if lookAround(x - 1, y) then
                return true
            end
            if lookAround(x, y - 1) then
                return true
            end
        end
    end

    return false
end

--[[
-- ""
function GalaxyMap:onCameraVisualRangeInGalaxy()
    self.areaInVisual = {}

    local mainCamera = UnityEngine.Camera.main
    local sceneHeight = UnityEngine.Screen.height
    local sceneWidth = UnityEngine.Screen.width
    local pi = math.pi

    -- ""
    local angleA = mainCamera.transform.rotation.eulerAngles.x
    -- ""
    local angleB = mainCamera.fieldOfView / 2
    -- ""x=0""A，""，""A""
    local cameraHeight = mainCamera.transform.position.y / math.sin(angleA / 180 * pi)

    -- ""B""A""
    local midDown = Vector3(sceneWidth / 2, 0, cameraHeight)
    local vecMidDown = mainCamera:ScreenToWorldPoint(midDown)
    local lineA = math.tan((90 - angleB - angleA) / 180 * pi) * vecMidDown.y
    local lineB = math.tan(angleA / 180 * pi) * vecMidDown.y
    lineA = math.abs(lineA)
    lineB = math.abs(lineB)
    local diffdown = (lineA + lineB) * math.cos(angleA / 180 * pi)

    -- ""C""A""
    local midUp = Vector3(sceneWidth / 2, sceneHeight, cameraHeight)
    local vecMidUp = mainCamera:ScreenToWorldPoint(midUp)
    local lineC = vecMidUp.y / math.tan((angleA - angleB) / 180 * math.pi)
    local lineD = math.tan(angleA / 180 * pi) * vecMidUp.y
    lineC = math.abs(lineC)
    lineD = math.abs(lineD)
    local diffUp = (lineC + lineD) * math.cos(angleA / 180 * pi)

    -- ""，z""
    local leftDownPoint = Vector3(0, 0, cameraHeight - diffdown)
    local leftUpPoint = Vector3(0, sceneHeight, cameraHeight + diffUp)
    -- local rightDownPoint = Vector3(sceneWidth, 0, cameraHeight - diffdown)
    local rightUpPoint = Vector3(sceneWidth, sceneHeight, cameraHeight + diffUp)

    -- ""4""y""0""
    local worldPoint1 = mainCamera:ScreenToWorldPoint(leftDownPoint)
    local worldPoint2 = mainCamera:ScreenToWorldPoint(leftUpPoint)
    -- local worldPoint3 = mainCamera:ScreenToWorldPoint(rightDownPoint)
    local worldPoint4 = mainCamera:ScreenToWorldPoint(rightUpPoint)

    local galaxyList = gg.buildingManager.galaxy.transform
    local count = galaxyList.childCount

    local interval = 20

    -- ""，""
    for i = 0, count - 1, 1 do
        local go = galaxyList:GetChild(i).gameObject
        go:SetActive(false)
        local name = go.name
        local pos = string.split(name, ",")

        local x = pos[1] * interval
        local z = pos[2] * interval
        local xOther = 0
        local zOther = 0

        -- ""
        if string.match(pos[1], "-") then
            xOther = x - interval
        else
            xOther = x + interval
        end
        if string.match(pos[2], "-") then
            zOther = z - interval
        else
            zOther = z + interval
        end

        -- ""
        local goMidX = (x + xOther) / 2
        local goMidZ = (z + zOther) / 2
        local cameraMidX = (worldPoint2.x + worldPoint4.x) / 2
        local cameraMidZ = (worldPoint1.z + worldPoint2.z) / 2

        -- ""
        local goHalfWidth = math.abs(x - goMidX)
        local goHalfHeight = math.abs(z - goMidZ)
        local cameraHalfWidth = math.abs(worldPoint2.x - cameraMidX)
        local cameraHalfHeight = math.abs(worldPoint2.z - cameraMidZ)

        -- ""
        local linkPoint = Vector3(goMidX, 0, goMidZ) - Vector3(cameraMidX, 0, cameraMidZ)
        local linkX = math.abs(linkPoint.x)
        local linkZ = math.abs(linkPoint.z)

        -- ""X""Y""
        if linkX <= (goHalfWidth + cameraHalfWidth) and linkZ <= (goHalfHeight + cameraHalfHeight) then
            go:SetActive(true)
            table.insert(self.areaInVisual, self.mapArea[go.name])
        end
    end
end
]]

function GalaxyMap:onCameraVisualRangeInGalaxy(args, endCfg)
    local mainCamera = UnityEngine.Camera.main
    local sceneHeight = UnityEngine.Screen.height
    local sceneWidth = UnityEngine.Screen.width
    local pi = math.pi
    -- ""
    local angle = mainCamera.transform.rotation.eulerAngles.x
    -- ""x=0""A，""，""A""
    local cameraHeight = mainCamera.transform.position.y / math.sin(angle / 180 * pi)

    local midPoint = Vector3(sceneWidth / 2, sceneHeight / 2, cameraHeight)

    local midWorldPoint = mainCamera:ScreenToWorldPoint(midPoint)

    local minDis = -1
    local minData = nil
    local newGalaxyMap = {}
    for k, v in pairs(self.galaxyMapData) do
        if not endCfg then
            local go = v.go

            local pos = go.transform.position

            local dis = Vector3.Distance(Vector3(pos.x, 0, pos.z), Vector3(midWorldPoint.x, 0, midWorldPoint.z))

            if minDis == -1 then
                minDis = dis
                minData = v
            else
                if minDis > dis then
                    minDis = dis
                    minData = v
                end
            end
        end
        newGalaxyMap[k] = v
    end
    local curCfg = endCfg
    if minData then
        curCfg = minData.cfg
    end
    -- ""CfgId
    local areaMembers = gg.galaxyManager:getAreaMembers(curCfg.pos)
    local newMembers = {}
    self.areaInVisual = areaMembers

    -- ""
    for k, v in pairs(areaMembers) do
        if newGalaxyMap[v] then
            self:setGridGoActive(newGalaxyMap[v], true, true)
            if newGalaxyMap[v].cfg.type == -1 then
                -- ""
                self:setGridGoActive(newGalaxyMap[v], false, false)
            end

            newGalaxyMap[v] = nil
        else
            table.insert(newMembers, v)
        end
    end

    for k, v in pairs(newMembers) do
        local oldKey = {}
        for key, d in pairs(newGalaxyMap) do
            oldKey = key
            break
        end
        local go = self.galaxyMapData[oldKey].go
        local goStatus = self.galaxyMapData[oldKey].goStatus
        self:setGridGoActive(self.galaxyMapData[oldKey], true, true)

        local belong = 0
        local status = 0

        local curCfg = gg.galaxyManager:getGalaxyCfg(v)
        if not curCfg then
            curCfg = {}
            for key, data in pairs(gg.galaxyManager:getGalaxyCfg(GalaxyManager.INIT_GRID_ID)) do
                curCfg[key] = data
            end
            curCfg.cfgId = v
            curCfg.type = -1
        end

        local galaxyBrief = GalaxyData.galaxyBrief[v]

        local parentGrid = curCfg.parentGrid
        if parentGrid == 0 then
            if galaxyBrief then
                status = galaxyBrief.status
                belong = galaxyBrief.belong
            end
        else
            local parentBrief = GalaxyData.galaxyBrief[parentGrid]
            if parentBrief then
                status = 0
                belong = parentBrief.belong
            end
        end

        self.galaxyMapData[v] = {
            go = go,
            goStatus = goStatus,
            cfg = curCfg,
            belong = belong,
            status = status,
            color = 1,
            cellvalue = {0, 0, 0, 0, 0, 0}
        }

        if curCfg.type == -1 then
            self:setGridGoActive(self.galaxyMapData[oldKey], false, false)
        else
            self:setGroundBelong(self.galaxyMapData[v])
        end

        go.transform.position = Vector3(curCfg.worldPos.x, curCfg.worldPos.y, curCfg.worldPos.z)
        goStatus.transform.position = Vector3(curCfg.worldPos.x, curCfg.worldPos.y, curCfg.worldPos.z)

        go.name = curCfg.cfgId

        if curCfg.type ~= -1 and (belong ~= 0 or curCfg.type == 3) then
            if curCfg.type == 3 then
                if curCfg.cfgId == UnionData.beginGridId then
                    belong = 2
                else
                    belong = 3
                end
            end

            -- local galaxyCell = self:findGridColor(belong, go):GetComponent(GalaxyMap.GalaxyCell)
            -- for i, k in ipairs(self.galaxyMapData[v].cellvalue) do
            --     galaxyCell:SetGalaxyCell(i - 1, 0)
            -- end
        end

        newGalaxyMap[oldKey] = nil
        self.galaxyMapData[oldKey] = nil
    end

    for k, v in pairs(newGalaxyMap) do
        self.galaxyMapData[k].cellvalue = {0, 0, 0, 0, 0, 0}
        self:setGridGoActive(self.galaxyMapData[k], false, false)
    end
    newGalaxyMap = nil

end

function GalaxyMap:mergeGrids()
    for k, v in pairs(self.galaxyMapData) do
        -- self:modifyGridCell(v)
        self:mergeHyStar(v)
    end
end

GalaxyMap.GalaxyCell = "GalaxyCell"

function GalaxyMap:mergeHyStar(data)
    if data.cfg.parentGrid == 0 and data.cfg.isBan == 1 then
        if #data.cfg.groupGrid > 0 and gg.galaxyManager:isSpecialGround(data.cfg.cfgId) ~= -1 then
            for k, v in pairs(data.cfg.groupGrid) do
                local newData = self.galaxyMapData[v]
                if newData then
                    local x = newData.cfg.pos.x
                    local y = newData.cfg.pos.y

                    local cellvalue = {0, 0, 0, 0, 0, 0}
                    for k, v in pairs(data.cfg.groupGrid) do
                        if v == gg.galaxyManager:pos2CfgId(x + 1, y - 1) then
                            cellvalue[1] = 1
                        elseif v == gg.galaxyManager:pos2CfgId(x + 1, y) then
                            cellvalue[2] = 1
                        elseif v == gg.galaxyManager:pos2CfgId(x, y + 1) then
                            cellvalue[3] = 1
                        elseif v == gg.galaxyManager:pos2CfgId(x - 1, y + 1) then
                            cellvalue[4] = 1
                        elseif v == gg.galaxyManager:pos2CfgId(x - 1, y) then
                            cellvalue[5] = 1
                        elseif v == gg.galaxyManager:pos2CfgId(x, y - 1) then
                            cellvalue[6] = 1
                        end
                    end
                    self:setGalaxyCell(newData, cellvalue)
                end
            end
        else
            local cellvalue = {0, 0, 0, 0, 0, 0}
            self:setGalaxyCell(data, cellvalue)
        end
    end
end

function GalaxyMap:setGalaxyCell(data, cellvalue)
    if data then
        local color = data.color
        local galaxyCell = self:findGridColor(color, data.go):GetComponent(GalaxyMap.GalaxyCell)

        for i, v in ipairs(cellvalue) do
            galaxyCell:SetGalaxyCell(i - 1, v)
        end
    end
end

function GalaxyMap:modifyGridCell(data)
    if data.cfg.type ~= -1 and data.belong ~= 0 then
        local x = data.cfg.pos.x
        local y = data.cfg.pos.y
        local cellvalue = {0, 0, 0, 0, 0, 0}

        local adjacent = {
            [1] = self.galaxyMapData[gg.galaxyManager:pos2CfgId(x + 1, y - 1)],
            [2] = self.galaxyMapData[gg.galaxyManager:pos2CfgId(x + 1, y)],
            [3] = self.galaxyMapData[gg.galaxyManager:pos2CfgId(x, y + 1)],
            [4] = self.galaxyMapData[gg.galaxyManager:pos2CfgId(x - 1, y + 1)],
            [5] = self.galaxyMapData[gg.galaxyManager:pos2CfgId(x - 1, y)],
            [6] = self.galaxyMapData[gg.galaxyManager:pos2CfgId(x, y - 1)]
        }

        for k, v in pairs(adjacent) do
            if v.belong ~= 0 and data.belong == v.belong then
                cellvalue[k] = 1
            end
        end
        local belong = data.belong
        -- if data.cfg.type == 3 then
        --     if data.cfg.cfgId == UnionData.beginGridId then
        --         belong = 2
        --     else
        --         belong = 3
        --     end
        --     cellvalue = {0, 0, 0, 0, 0, 0}
        -- end
        -- local galaxyCell = self:findGridColor(belong, data.go):GetComponent(GalaxyMap.GalaxyCell)
        -- for i, v in ipairs(cellvalue) do
        --     galaxyCell:SetGalaxyCell(i - 1, v)
        --     data.cellvalue[i] = v

        --     -- if data.cellvalue[i] ~= v then
        --     --     galaxyCell:SetGalaxyCell(i - 1, v)
        --     --     data.cellvalue[i] = v
        --     -- end
        -- end
    end
end

function GalaxyMap:findGridColor(color, go)
    return go.transform:Find(GalaxyMap.groundColor[color])
end

function GalaxyMap:onSubGalaxyGrids()
    if self.areaInVisual then
        local newInVisual = {}
        local newInVisualCompare = {}

        local oldInVisual = nil

        for k, v in pairs(self.areaInVisual) do
            newInVisual[v] = v
            newInVisualCompare[v] = v
        end
        if self.lastInVisual then
            oldInVisual = {}

            for k, v in pairs(self.lastInVisual) do
                oldInVisual[v] = v
            end

            for k, v in pairs(self.areaInVisual) do
                if oldInVisual[v] then
                    newInVisual[v] = nil
                end
            end

            for k, v in pairs(self.lastInVisual) do
                if newInVisualCompare[v] then
                    oldInVisual[v] = nil
                end
            end

        end

        if oldInVisual then
            local unSub = {}
            for k, v in pairs(oldInVisual) do
                table.insert(unSub, v)
            end

            if #unSub > 0 then
                GalaxyData.C2S_Player_unsubscribeGrids(unSub)
            end
        end

        local sub = {}
        for k, v in pairs(newInVisual) do
            table.insert(sub, v)
        end

        if #sub > 0 then
            GalaxyData.C2S_Player_SubscribeGrids(sub)
        end

        self.lastInVisual = self.areaInVisual
    end
end

function GalaxyMap:onEnterResPlanet(args, go)
    if go then
        local name = go.transform.parent.name
        local cfgId = tonumber(name)
        if self.galaxyMapData[cfgId] then
            local parentGrid = self.galaxyMapData[cfgId].cfg.parentGrid
            local worldPos = go.transform.parent.transform.position
            if parentGrid ~= 0 and gg.galaxyManager:isSpecialGround(parentGrid) ~= -1 then
                local vec3 = gg.galaxyManager:getGalaxyCfg(parentGrid).worldPos
                worldPos = Vector3(vec3.x, vec3.y, vec3.z)
                cfgId = parentGrid
            end
            local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
            if curCfg and curCfg.isBan and curCfg.isBan == 1 then
                gg.event:dispatchEvent("onShowBoxInfomation", cfgId, worldPos)
            end
        end
    end
end

function GalaxyMap:showEnterResPlanet(cfgId)
    if cfgId then
        if self.galaxyMapData[cfgId] and self.galaxyMapData[cfgId].cfg.isBan and self.galaxyMapData[cfgId].cfg.isBan ==
            1 then
            local worldPos = Vector3(self.galaxyMapData[cfgId].cfg.worldPos.x, self.galaxyMapData[cfgId].cfg.worldPos.y,
                self.galaxyMapData[cfgId].cfg.worldPos.z)
            gg.event:dispatchEvent("onShowBoxInfomation", cfgId, worldPos, true)
        end
    end
end

function GalaxyMap:setGridGoActive(data, isGoTrue, isObjTrue)
    if isGoTrue ~= nil then
        data.go:SetActiveEx(isGoTrue)
    end
    if isObjTrue ~= nil then
        data.goStatus:SetActiveEx(isObjTrue)
    end
end

function GalaxyMap:onJumpGalaxyGrid(endCfg)
    -- local pnlMap = gg.uiManager:getOpenWindow()
    gg.event:dispatchEvent("onHideBoxInfomation")
    gg.warCameraCtrl:startMove2ResPlanet(endCfg.worldPos.x, endCfg.worldPos.z, function()
        self:onCameraVisualRangeInGalaxy(nil, endCfg)
        self:onSubGalaxyGrids()
        self:showEnterResPlanet(endCfg.cfgId)
    end)
end

return GalaxyMap
