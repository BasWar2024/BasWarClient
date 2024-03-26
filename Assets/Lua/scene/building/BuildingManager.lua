BuildingManager = class("BuildingManager")

BuildingManager.OWNER_OWN = 1
BuildingManager.OWNER_OTHER = 2
BuildingManager.OWNER_MAP = 3

BuildingManager.IS_MAKE_SURFACE = false

function BuildingManager:ctor()
    self.isBuildModel = false -- ""
    self.buildingTable = {} -- ""
    self.otherBuilding = {} -- ""
    self.liberaborShipTable = {} -- ""
    self.selectedBuilding = nil -- ""
    self.ownBase = nil
    self.otherBase = nil
    self.resPlanet = nil
    self.screenRaycaster = nil
    self.gridTable = {} -- "" 0""；~0""
    self.otherGrid = {}
    self.buildingCfg = cfg["build"]
    self:initShopTable()
    self:bindEvent()
    self.scene = ggclass.BuildingScene.new()
    self.screenRaycaster = global:GetComponent("ScreenRaycaster")
    self.ownSurfaceData = {}
    self.otherSurfaceData = {}
end

function BuildingManager:bindEvent()
    gg.event:addListener("onUpdateBuildData", self)
    gg.event:addListener("onUpdateGalaxyBuildPos", self)
    gg.event:addListener("onRemoveBuilding", self)
    gg.event:addListener("onRemoveOtherBuilding", self)
    gg.event:addListener("onRefreshResTxt", self)
end

-- BuildingManager.BuildingWhiteList = {3000002, 3000003, 3000004, 3000005, 3000006, 3000007, 3000008, 3000009, 3000010,
--                                      3000011, 3000016, 3000017, 3000018, 3000019, 3000020, 3000029, 3000030, 3000031,
--                                      3000032, 3000033, 3000034, 3000035}

-- BuildingManager.BuildingWhiteList = {6010002, 6010003, 6010004, 6010005, 6010006, 6010007, 6010008, 6010009, 6010010,
--                                      6020001, 6020002, 6020005, 6020006, 6030001, 6030003, 6030004, 6030005,
--                                      6030006, 6030007, 6030008, 6030009, 6030010}

BuildingManager.BuildingWhiteList = {6010002, 6010003, 6010004, 6010005, 6010006, 6010007, 6010008, 6010009, 6010010,
                                     6020002, 6020005, 6020006, 6020007, 6030001, 6030003, 6030004, 6030005, 6030006,
                                     6030007, 6030008, 6030009, 6030010, constant.BUILD_SHRINE}

-- ""
function BuildingManager:initShopTable()
    self.buildingTableOfEconomic = {}
    self.buildingTableOfDevelopment = {}
    self.buildingTableOfDefense = {}

    local buildCfg = self.buildingCfg
    for k, v in pairs(buildCfg) do
        local isWhiteList = self:isInBuildingWhiteList(v.cfgId)
        if isWhiteList then
            if v.type == 1 and v.level == 0 and v.quality == 0 then
                table.insert(self.buildingTableOfEconomic, v)
            end
            if v.type == 2 and v.level == 0 and v.quality == 0 then
                if constant.BUILD_BASE ~= v.cfgId then
                    table.insert(self.buildingTableOfDevelopment, v)
                end
            end
            if v.type == 3 and v.level == 0 and v.quality == 0 then
                table.insert(self.buildingTableOfDefense, v)
            end
        end
    end
end

function BuildingManager:isInBuildingWhiteList(cfgId)
    local isWhiteList = false
    for i, v in ipairs(BuildingManager.BuildingWhiteList) do
        if cfgId == v then
            isWhiteList = true
            break
        end
    end
    return isWhiteList
end

-- ""
function BuildingManager:initGridTable()
    local gridCountMax = constant.BUILD_GRID_MAX
    -- print("aaaaainitGridTable", gridCountMax)
    for gridX = 1, gridCountMax do
        local gridZTable = {}
        for gridZ = 1, gridCountMax do
            table.insert(gridZTable, 0)
        end
        table.insert(self.gridTable, gridZTable)
    end
end

function BuildingManager:resetOtherGrid()
    self.otherGrid = {}
    local gridCountMax = constant.BUILD_GRID_MAX
    for gridX = 1, gridCountMax do
        local gridZTable = {}
        for gridZ = 1, gridCountMax do
            table.insert(gridZTable, 0)
        end
        table.insert(self.otherGrid, gridZTable)
    end

end

-- ""
function BuildingManager:setGridTable(pos, length, width, args, owner, gridTable)
    -- print("aaaaaa0000", args)

    if not gg.galaxyManager:isMyResPlanet() and owner ~= BuildingManager.OWNER_OWN then -- 
        return
    end
    -- args 0""；~0""
    local minX = pos.x
    local minZ = pos.z
    local maxX = pos.x + length - 1
    local maxZ = pos.z + width - 1

    if minX < constant.BUILD_GRID_MIN or minZ < constant.BUILD_GRID_MIN or maxX > constant.BUILD_GRID_MAX or maxZ >
        constant.BUILD_GRID_MAX then
        return false
    end
    -- print("aaaaaa", args)
    for x = minX, maxX do
        for z = minZ, maxZ do
            if gridTable then
                gridTable[x][z] = args
            else
                if owner == BuildingManager.OWNER_OWN then
                    self.gridTable[x][z] = args
                elseif owner == BuildingManager.OWNER_OTHER then
                    self.otherGrid[x][z] = args
                end
            end
        end
    end
end

-- ""`    1
function BuildingManager:boolGridTable(pos, length, width, grid)
    local minX = pos.x
    local minZ = pos.z
    local maxX = pos.x + length - 1
    local maxZ = pos.z + width - 1

    if minX < constant.BUILD_GRID_MIN or minZ < constant.BUILD_GRID_MIN or maxX > constant.BUILD_GRID_MAX or maxZ >
        constant.BUILD_GRID_MAX then
        return false
    end
    local curGrid = {}

    if grid then
        curGrid = grid
    else
        if self.baseOwner == BuildingManager.OWNER_OWN then
            curGrid = self.gridTable
        elseif self.baseOwner == BuildingManager.OWNER_OTHER then
            curGrid = self.otherGrid
        end

    end

    for x = minX, maxX do
        for z = minZ, maxZ do
            if curGrid[x][z] ~= 0 then
                return false
            end
        end
    end

    return true
end

-- ""
function BuildingManager:initBase()
    gg.sceneManager:setTerrainScenesActive(true)
    gg.warShip:loadWarShip()
    self:initGridTable()
    self.buildingTable = {}
    self.liberaborShipTable = {}
    self.buildingBaseId = nil
    self.buildCount = 1
    self.allBuildCount = 1
    self.curBuildCound = 0
    self.ownBaseId = 0

    for i, b in pairs(BuildData.buildData) do
        local myCfg = self:getCfg(b.cfgId, b.level)
        if myCfg then
            if b.cfgId == constant.BUILD_BASE then
                -- ""，""
                self:loadBuilding(myCfg, b, nil, BuildingManager.OWNER_OWN)
                self.ownBaseId = b.id
                break
            end
        end
    end
end

function BuildingManager:initAllBuilding()
    local initBuildData = {}
    local buildMaxNum = 0

    for k, v in pairs(BuildData.buildData) do
        if self.ownBaseId ~= v.id and self:chackBuildNotInBag(v) then
            table.insert(initBuildData, v)
            buildMaxNum = buildMaxNum + 1
        end
    end
    self.allBuildCount = buildMaxNum + 1

    self:batchLoadBuilding(initBuildData, BuildingManager.OWNER_OWN, 1, buildMaxNum)

    self.isBuildModel = false
    self:calculateResMax()
    self:swichOwner(BuildingManager.OWNER_OWN)
    gg.event:dispatchEvent("onShowNovice")
    gg.event:dispatchEvent("onBaseChange")
end

function BuildingManager:chackBuildNotInBag(data)
    if data.pos.x == 0 and data.pos.y == 0 and data.pos.z == 0 then
        return false
    else
        return true
    end
end

function BuildingManager:batchLoadBuilding(initBuildData, owner, curNum, buildMaxNum)
    if curNum > buildMaxNum then
        return
    end

    local initCount = curNum
    for i = initCount, initCount + 10, 1 do
        curNum = i
        if curNum <= buildMaxNum then
            local data = initBuildData[curNum]
            self:initBuilding(data, owner)
        end
    end

    curNum = curNum + 1

    if LOAD_PERCENT < 100 then
        LOAD_PERCENT = curNum / buildMaxNum * 100
        if LOAD_PERCENT < 10 then
            LOAD_PERCENT = 10
        end
        if LOAD_PERCENT > 50 then
            LOAD_PERCENT = 50
        end
    end
    local timer = gg.timer:startTimer(0.03, function()
        self:batchLoadBuilding(initBuildData, owner, curNum, buildMaxNum)
    end)

end

function BuildingManager:initOtherBase(buildDatas)
    self:resetOtherGrid()
    self.otherBuilding = {}
    self.otherBuildDatas = buildDatas
    self.buildCount = 1
    self.allBuildCount = 1
    self.curBuildCound = 0
    self.otherBaseId = 0
    local haveBase = false
    for i, b in pairs(buildDatas) do
        local myCfg = self:getCfg(b.cfgId, b.level)
        if myCfg then
            if b.cfgId == constant.BUILD_BASE then
                self:loadBuilding(myCfg, b, nil, BuildingManager.OWNER_OTHER)
                self.otherBaseId = b.id
                haveBase = true
                break
            end
        end
    end
    self:swichOwner(BuildingManager.OWNER_OTHER)
    if not haveBase then
        self:initOtherBuilding()
    end
end

function BuildingManager:initOtherBuilding()
    -- for i, b in pairs(self.otherBuildDatas) do
    --     self:initBuilding(b, BuildingManager.OWNER_OTHER)
    -- end

    local initBuildData = {}
    local buildMaxNum = 0

    for k, v in pairs(self.otherBuildDatas) do
        if self.otherBaseId ~= v.id and self:chackBuildNotInBag(v) then
            table.insert(initBuildData, v)
            buildMaxNum = buildMaxNum + 1
        end
    end
    if self.otherBaseId ~= 0 then
        self.allBuildCount = buildMaxNum + 1
    else
        self.allBuildCount = buildMaxNum
    end

    self:batchLoadBuilding(initBuildData, BuildingManager.OWNER_OTHER, 1, buildMaxNum)

end

function BuildingManager:initBuilding(data, owner)
    local myCfg = self:getCfg(data.cfgId, data.level)

    if myCfg then
        if data.cfgId ~= constant.BUILD_BASE and self:chackBuildNotInBag(data) then
            self:loadBuilding(myCfg, data, nil, owner)
            if SurfaceUtil.isHaveSurface(myCfg) then
                self.buildCount = self.buildCount + 1
            end
        end
    end
end

function BuildingManager:getBuildingBase()
    if self.baseOwner == BuildingManager.OWNER_OWN then
        return self.buildingTable[self.ownBaseId]
    elseif self.baseOwner == BuildingManager.OWNER_OTHER then
        return self.otherBuilding[self.otherBaseId]
    end
end

function BuildingManager:getOwnBase()
    return self.buildingTable[self.ownBaseId]
end

function BuildingManager:getBuildingTable()
    if self.baseOwner == BuildingManager.OWNER_OWN or self.baseOwner == BuildingManager.OWNER_MAP then
        return self.buildingTable
    elseif self.baseOwner == BuildingManager.OWNER_OTHER then
        return self.otherBuilding
    end
end

function BuildingManager:getOwnerBuildingByCfgId(cfgId)
    if not cfgId then
        return
    end

    for key, value in pairs(self.buildingTable) do
        if value.buildData and value.buildData.cfgId == cfgId then
            return value
        end
    end
end

function BuildingManager:swichOwner(owner)
    self.baseOwner = owner
    self:swichSurfaceData()
    -- if owner ~= BuildingManager.OWNER_MAP then
    --     self:createFloorTexture()
    -- end
end

function BuildingManager:swichSurfaceData()
    self.surfaceDataCount = 0
    self.surfaceData = {}
    if self.baseOwner == BuildingManager.OWNER_OWN then
        self.surfaceData = self.ownSurfaceData
    elseif self.baseOwner == BuildingManager.OWNER_OTHER then
        self.surfaceData = self.otherSurfaceData
    end
end

function BuildingManager:addBuildCound(baseOwner)
    self.curBuildCound = self.curBuildCound + 1
    -- print("addBuildCound", self.curBuildCound, self.allBuildCount)
    if self.curBuildCound == self.allBuildCount then
        -- LOAD_PERCENT = 100
        if baseOwner == BuildingManager.OWNER_OWN then
            self:createFloorTexture()
        end
        gg.sceneManager:jumpSceneAction()
    end
end

-- ""
function BuildingManager:addSurfaceData(key, data, buildId)

    if self.surfaceData[key] then
        self.surfaceData[key].data = data
        table.insert(self.surfaceData[key].idList, buildId)
    else
        local idList = {}
        table.insert(idList, buildId)
        self.surfaceData[key] = {
            data = data,
            idList = idList
        }
    end

end

-- ""
function BuildingManager:cutSurfaceData(key, buildId)
    if self.surfaceData[key] then
        if #self.surfaceData[key].idList > 1 then
            table.remove_value(self.surfaceData[key].idList, buildId)
            if #self.surfaceData[key].idList <= 0 then
                self.surfaceData[key] = nil
            else
                local id = self.surfaceData[key].idList[#self.surfaceData[key].idList]
                local data = self:getBuildingTable()[id].surfaceData[key]
                self.surfaceData[key].data = data
            end
        else
            self.surfaceData[key] = nil
        end
    end
end

-- ""
function BuildingManager:initSurface(isNewBuilding, isMakeBan)
    self.surfaceDataCount = self.surfaceDataCount + 1
    if self.surfaceDataCount == self.buildCount or isNewBuilding then
        -- ""
        self:refreshSurface(isMakeBan)
    end
end

-- ""
function BuildingManager:refreshSurface(isMakeBan)
    if not BuildingManager.IS_MAKE_SURFACE then
        self:createFloorTexture(true)
        LOAD_PERCENT = 100
        return
    end

    for k, v in pairs(self:getBuildingTable()) do
        if v.resetSurface then
            v:resetSurface(true)
        end
    end
    for k, v in pairs(self.surfaceData) do
        local buildCount = #v.idList
        if buildCount > 0 then
            local keyX = v.data.keyX
            local keyZ = v.data.keyZ
            local aroundTable = self:getAround(keyX, keyZ)
            local aroundBuildCound = #aroundTable
            if aroundBuildCound == 5 then
                self:setSurfaceArris(aroundTable, v, buildCount)
            end
        end
    end
    for k, v in pairs(self.surfaceData) do
        local buildCount = #v.idList
        if buildCount > 0 then
            local keyX = v.data.keyX
            local keyZ = v.data.keyZ
            local aroundTable = self:getAround(keyX, keyZ)
            local aroundBuildCound = #aroundTable
            if aroundBuildCound == 0 then
                self:setSurfaceFloor(v, buildCount)
            end
            if aroundBuildCound == 1 then
                self:setSurfaceInside(aroundTable, v, buildCount)
            end
            if aroundBuildCound >= 1 and aroundBuildCound < 4 then
                if aroundBuildCound == 3 then
                    if (aroundTable[1].x == aroundTable[2].x and aroundTable[2].x == aroundTable[3].x) or
                        (aroundTable[1].y == aroundTable[2].y and aroundTable[2].y == aroundTable[3].y) then
                        self:setSurfaceSidewalk(aroundTable, v, buildCount)
                    end
                elseif aroundBuildCound == 2 then
                    if aroundTable[1].x == aroundTable[2].x or aroundTable[1].y == aroundTable[2].y then
                        self:setSurfaceSidewalk(aroundTable, v, buildCount)
                    end

                else
                    self:setSurfaceSidewalk(aroundTable, v, buildCount)
                end
            end
        end
    end

    LOAD_PERCENT = 100

    self:setSurfaceLongSidewalk()
    if isMakeBan then
        self:AddBanArea()
    end

    -- self:createFloorTexture()
end

function BuildingManager:createFloorTexture(isTreeChange)
    if not isTreeChange then
        if gg.uiManager.uiRoot.FloorTextureVolume:IsMixRtNull() == false then
            gg.sceneManager:setDefaultFloorTexture()
            return
        end
    end

    local newTable = {}
    for k, v in pairs(self:getBuildingTable()) do
        if v.buildCfg.type == 8 then
            local pos = v.view.contenPos
            local size = v.view.length
            local data = {
                pos = pos,
                size = size
            }
            table.insert(newTable, data)
        end
    end
    -- UnityEngine.StaticBatchingUtility.Combine(self.ownBase)
    if #newTable > 0 then
        gg.sceneManager:createFloorTexture(newTable)
    end
end

function BuildingManager:setSurfaceLongSidewalk()
    local dire = {
        [1] = {
            x = 0,
            z = 1
        },
        [2] = {
            x = 1,
            z = 0
        },
        [3] = {
            x = 0,
            z = -1
        },
        [4] = {
            x = -1,
            z = 0
        }
    }

    for k, v in pairs(self.surfaceData) do
        if v.data.curType == SurfaceUtil.SURFACE_TYPE_ARRIS or v.data.curType == SurfaceUtil.SURFACE_TYPE_INSIDE then
            local startKeyX = v.data.keyX
            local startKeyZ = v.data.keyZ
            local keyX = startKeyX
            local keyZ = startKeyZ
            local index = {}
            for i, p in ipairs(dire) do
                local key = SurfaceUtil.getSurfaceKey(startKeyX + p.x, startKeyZ + p.z)
                if self:isComformSurface(key, SurfaceUtil.SURFACE_TYPE_SIDEWALK) then
                    table.insert(index, i)
                end
            end

            if #index > 0 then
                for i, num in ipairs(index) do
                    local count = 0
                    keyX = startKeyX
                    keyZ = startKeyZ
                    while true do
                        keyX = keyX + dire[num].x
                        keyZ = keyZ + dire[num].z
                        local key = SurfaceUtil.getSurfaceKey(keyX, keyZ)
                        if self:isComformSurface(key, SurfaceUtil.SURFACE_TYPE_SIDEWALK) then
                            count = count + 1
                        else
                            break
                        end
                    end
                    if count <= 5 then
                        self:setSidewalkType(count, startKeyX, startKeyZ, dire[num])
                    else
                        local quotient = math.floor(count / 5)
                        local remainder = count % 5
                        local x = startKeyX
                        local z = startKeyZ
                        for j = 1, quotient do
                            self:setSidewalkType(5, x, z, dire[num])
                            x = x + dire[num].x * 5
                            z = z + dire[num].z * 5
                        end
                        if remainder > 0 then
                            self:setSidewalkType(remainder, x, z, dire[num])
                        end
                    end
                end
            end
        end
    end
end

function BuildingManager:setSidewalkType(count, startKeyX, startKeyZ, dire)
    for i = 1, count do
        local x = startKeyX + (dire.x * i)
        local z = startKeyZ + (dire.z * i)
        local key = SurfaceUtil.getSurfaceKey(x, z)
        local data = self.surfaceData[key].data
        local obj = data.obj
        if i == 1 then
            local posX = x + 0.5 + (count - 1) * dire.x * 0.5
            local posZ = z + 0.5 + (count - 1) * dire.z * 0.5
            data.posX = posX
            data.posZ = posZ
            SurfaceUtil.setSidewalkType(data, count)

            -- print(string.format("startKeyX:%f, x:%f, count:%f, index:%f, posX:%f",startKeyX, x, count, index, posX))
            if obj then
                obj.transform.position = Vector3(posX, 0, posZ)
            end
        else
            SurfaceUtil.setSurfaveType(data, obj, SurfaceUtil.SURFACE_TYPE_NONE, 0, false, true)
        end
    end
end

function BuildingManager:isComformSurface(key, type)
    if self.surfaceData[key] then
        if self.surfaceData[key].data.curType == SurfaceUtil.SURFACE_TYPE_SIDEWALK and
            self.surfaceData[key].data.subType == 1 then
            return true
        else
            return false
        end
    else
        return false
    end
end

function BuildingManager:setSurfaceInside(aroundTable, value, buildCount)
    if aroundTable[1].value == 1 or aroundTable[1].value == 3 or aroundTable[1].value == 7 or aroundTable[1].value == 9 then
        for i = 1, buildCount do
            if i < buildCount then
                local obj = self:getBuildingTable()[value.idList[i]].surfaceData[value.data.key].obj
                if obj then
                    obj:SetActive(false)
                end
            elseif i == buildCount then
                local angle = 0
                if aroundTable[1].value == 1 then
                    angle = 0
                elseif aroundTable[1].value == 3 then
                    angle = 90
                elseif aroundTable[1].value == 7 then
                    angle = -90
                elseif aroundTable[1].value == 9 then
                    angle = -180
                end
                SurfaceUtil.setSurfaveType(value.data, value.data.obj, SurfaceUtil.SURFACE_TYPE_INSIDE, angle, false,
                    true)
            end
        end
    end
end

function BuildingManager:setSurfaceFloor(value, buildCount)
    for i = 1, buildCount do
        if i < buildCount then
            local obj = self:getBuildingTable()[value.idList[i]].surfaceData[value.data.key].obj
            if obj then
                obj:SetActive(false)
            end
        elseif i == buildCount then
            SurfaceUtil.setSurfaveType(value.data, value.data.obj, SurfaceUtil.SURFACE_TYPE_FLOOR, 0, false, true)
        end
    end
end

function BuildingManager:setSurfaceArris(aroundTable, value, buildCount)
    for i = 1, buildCount do
        if i < buildCount then
            local obj = self:getBuildingTable()[value.idList[i]].surfaceData[value.data.key].obj
            if obj then
                obj:SetActive(false)
            end
        elseif i == buildCount then
            local angle = 0
            local sum = aroundTable[1].value + aroundTable[2].value + aroundTable[3].value + aroundTable[4].value +
                            aroundTable[5].value
            if sum == 33 then
                angle = 0
            elseif sum == 21 then
                angle = -90
            elseif sum == 17 then
                angle = -180
            elseif sum == 29 then
                angle = 90
            end
            SurfaceUtil.setSurfaveType(value.data, value.data.obj, SurfaceUtil.SURFACE_TYPE_ARRIS, angle, false, true)
        end
    end
end

function BuildingManager:setSurfaceSidewalk(aroundTable, value, buildCount)
    local temp = 0
    for i, v in ipairs(aroundTable) do
        if v.value == 2 or v.value == 4 or v.value == 6 or v.value == 8 then
            temp = v.value
            break
        end
    end
    if temp > 0 then
        for i = 1, buildCount do
            if i < buildCount then
                local obj = self:getBuildingTable()[value.idList[i]].surfaceData[value.data.key].obj
                if obj then
                    obj:SetActive(false)
                end
            elseif i == buildCount then
                local angle = 0
                if temp == 2 then
                    angle = 0
                elseif temp == 4 then
                    angle = -90
                elseif temp == 6 then
                    angle = 90
                elseif temp == 8 then
                    angle = -180
                end
                SurfaceUtil.setSurfaveType(value.data, value.data.obj, SurfaceUtil.SURFACE_TYPE_SIDEWALK, angle, false,
                    true)
            end
        end
    end
end

function BuildingManager:AddBanArea()
    self.banAreas = {}
    local banArea = gg.sceneManager.terrain.transform:Find("BanArea").transform
    for k, v in pairs(self.surfaceData) do
        if v.data.curType ~= SurfaceUtil.SURFACE_TYPE_NONE and v.data.curType ~= SurfaceUtil.SURFACE_TYPE_OUTSIDE then
            local surfacedata = v.data
            ResMgr:LoadGameObjectAsync("SkillSelectionArea", function(go)
                go.transform:SetParent(banArea, false)
                local ang = surfacedata.curAngel or 0
                local spine = go.transform:Find("Spine").transform:GetComponent("SkeletonAnimation")
                spine.transform:GetComponent("BoxCollider").size = Vector3(0.78, 0.78, 0.4)

                if surfacedata.curType == SurfaceUtil.SURFACE_TYPE_ARRIS then
                    spine:ChangeSlots("body", "res/Arris")
                    spine.transform:GetComponent("BoxCollider").center = Vector3(0.11, 0.11, 0)
                    spine.transform:GetComponent("BoxCollider").size = Vector3(0.78, 0.78, 0.4)
                    ang = ang + 90
                elseif surfacedata.curType == SurfaceUtil.SURFACE_TYPE_FLOOR then
                    spine:ChangeSlots("body", "res/Floor_tile")
                    spine.transform:GetComponent("BoxCollider").center = Vector3(0, 0, 0)
                    spine.transform:GetComponent("BoxCollider").size = Vector3(1, 1, 0.4)
                elseif surfacedata.curType == SurfaceUtil.SURFACE_TYPE_INSIDE then
                    spine:ChangeSlots("body", "res/Inside_corner")
                    spine.transform:GetComponent("BoxCollider").center = Vector3(0, 0, 0)
                    spine.transform:GetComponent("BoxCollider").size = Vector3(1, 1, 0.4)
                    ang = ang + 90
                elseif surfacedata.curType == SurfaceUtil.SURFACE_TYPE_SIDEWALK then
                    local slotsName = "res/s" .. surfacedata.subType
                    spine:ChangeSlots("body", slotsName)
                    spine.transform:GetComponent("BoxCollider").center = Vector3(0.11, 0, 0)
                    spine.transform:GetComponent("BoxCollider").size = Vector3(0.78, tonumber(surfacedata.subType), 0.4)
                end
                go.transform.position = Vector3(surfacedata.posX, -0.18, surfacedata.posZ)
                go.transform.localRotation = UnityEngine.Quaternion.Euler(0, ang, 0)
                table.insert(self.banAreas, go)
                return true
            end, true)
        end
    end
    self.surfaceDataCount = 0
    self.otherSurfaceData = {}
    self.surfaceData = self.otherSurfaceData

    if BuildingManager.IS_MAKE_SURFACE == true then
        for k, v in pairs(self.otherBuilding) do
            SurfaceUtil.startSurface(v.buildCfg.length, v.buildCfg.width, v.buildCfg.pos, v.buildCfg.id,
                v.buildCfg.type, v.buildCfg.subType, self.buildCount, 0)
        end
    end

end

function BuildingManager:destroyBanArea()
    if self.banAreas then
        for k, v in pairs(self.banAreas) do
            ResMgr:ReleaseAsset(v)
        end
        self.banAreas = {}
    end
end

-- ""
function BuildingManager:getAround(keyX, keyZ)
    local myTable = {}
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX - 1, keyZ - 1)] then
        local data = {
            value = 1,
            x = 1,
            y = 1
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX - 1, keyZ - 1)].data.curType ==
        SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 1,
            x = 1,
            y = 1
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX - 1, keyZ)] then
        local data = {
            value = 2,
            x = 1,
            y = 2
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX - 1, keyZ)].data.curType == SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 2,
            x = 1,
            y = 2
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX - 1, keyZ + 1)] then
        local data = {
            value = 3,
            x = 1,
            y = 3
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX - 1, keyZ + 1)].data.curType ==
        SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 3,
            x = 1,
            y = 3
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX, keyZ - 1)] then
        local data = {
            value = 4,
            x = 2,
            y = 1
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX, keyZ - 1)].data.curType == SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 4,
            x = 2,
            y = 1
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX, keyZ + 1)] then
        local data = {
            value = 6,
            x = 2,
            y = 3
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX, keyZ + 1)].data.curType == SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 6,
            x = 2,
            y = 3
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX + 1, keyZ - 1)] then
        local data = {
            value = 7,
            x = 3,
            y = 1
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX + 1, keyZ - 1)].data.curType ==
        SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 7,
            x = 3,
            y = 1
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX + 1, keyZ)] then
        local data = {
            value = 8,
            x = 3,
            y = 2
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX + 1, keyZ)].data.curType == SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 8,
            x = 3,
            y = 2
        }
        table.insert(myTable, data)
    end
    if not self.surfaceData[SurfaceUtil.getSurfaceKey(keyX + 1, keyZ + 1)] then
        local data = {
            value = 9,
            x = 3,
            y = 3
        }
        table.insert(myTable, data)
    elseif self.surfaceData[SurfaceUtil.getSurfaceKey(keyX + 1, keyZ + 1)].data.curType ==
        SurfaceUtil.SURFACE_TYPE_OUTSIDE then
        local data = {
            value = 9,
            x = 3,
            y = 3
        }
        table.insert(myTable, data)
    end
    return myTable
end

-- ""
function BuildingManager:getCfg(cfgId, level)
    local buildCfg = self.buildingCfg
    local myCfg = nil
    for k, v in pairs(buildCfg) do
        if v.cfgId == cfgId and v.level == level then
            myCfg = v
            break
        end
    end
    return myCfg
end

-- ""
function BuildingManager:requestLoadBuilding(cfgId, pos, isInstance)
    BuildData.C2S_Player_BuildCreate(cfgId, pos.x, pos.z, nil, isInstance)
    self.isWaitBuild = false
end

-- ""
function BuildingManager:buildSuccessful(buildData, isNotCreateFloor)
    if self.selectedBuilding then
        if self.baseOwner == BuildingManager.OWNER_OWN then
            self:setBuildingTable(buildData.id, self.selectedBuilding)
        elseif self.baseOwner == BuildingManager.OWNER_OTHER then
            self:setOtherBuilding(buildData.id, self.selectedBuilding)
        end
        self.selectedBuilding:buildSuccessful(buildData)
        self:releaseBuilding(true, true)
        self.isWaitBuild = false
    else
        self:initBuilding(buildData, self.baseOwner)

        if not isNotCreateFloor then
            self:createFloorTexture()
        end
    end
end

-- ""
-- buildCfg = ""
-- buildData = ""
-- isItem = ""
-- owner = ""
-- pos""
function BuildingManager:loadBuilding(buildCfg, buildData, isItem, owner, pos, isInstance)
    -- local pos = nil
    if buildData then
        pos = Vector3(buildData.pos.x, buildData.pos.y, buildData.pos.z)
    else
        if buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
            pos = self:getNextLiberatorshopPos()
            -- local i = 1
            -- for k, v in pairs(self.liberaborShipTable) do
            --     i = i + 1
            -- end
            -- local vec = constant.BUILD_LIBERATORSHIPPOSLIST[i]
            -- pos = Vector3(vec[1], 0, vec[2])
        else
            if pos == nil then
                local center = Vector3(UnityEngine.Screen.width / 2, UnityEngine.Screen.height / 2)
                pos = self:getWorldPointInt(center)
                pos = self:searchSpace(pos, buildCfg.length, buildCfg.width)
            else
                pos = Vector3(pos[1], pos[2], pos[3])
            end
        end
    end
    -- ""
    if pos then
        local building = ggclass.Building.new(buildCfg, pos, buildData, isItem, owner, isInstance)

        if buildData then
            if owner == BuildingManager.OWNER_OWN then
                self:setBuildingTable(buildData.id, building)
            elseif owner == BuildingManager.OWNER_OTHER then
                self:setOtherBuilding(buildData.id, building)
            end
        else
            self.isBuildModel = true
            self.selectedBuilding = building
            if buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
                gg.sceneManager:setGridGroundAlpna(false)
            end
        end
    end
end

function BuildingManager:getBuildPos(buildCfg, grid)
    -- local grid = grid or self.otherGrid
    -- grid = gg.deepcopy(grid)

    local center = Vector3(UnityEngine.Screen.width / 2, UnityEngine.Screen.height / 2)
    local pos = self:getWorldPointInt(center)
    pos = self:searchSpace(pos, buildCfg.length, buildCfg.width, grid)
    BuildingManager:setGridTable(pos, buildCfg.length, buildCfg.width, 1, nil, grid)

    return pos --, grid
end

function BuildingManager:getBuildsPos(buildCfgList, grid)
    local grid = grid or self.otherGrid
    grid = gg.deepcopy(grid)

    local dataList = {}
    for k, v in pairs(buildCfgList) do
        local pos = self:getBuildPos(v, grid)
        table.insert(dataList, {buildCfg = v, pos = pos})
    end

    return dataList
end

function BuildingManager:getNextLiberatorshopPos()
    local i = 1
    for k, v in pairs(self.liberaborShipTable) do
        i = i + 1
    end
    local vec = constant.BUILD_LIBERATORSHIPPOSLIST[i]
    return Vector3(vec[1], 0, vec[2])
end

-- ""buildingTable
function BuildingManager:setBuildingTable(id, build)
    self.buildingTable[id] = build
    if build.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
        local key = 0
        local pos = build.view.pos
        -- print("pos", table.dump(pos))
        for k, v in ipairs(constant.BUILD_LIBERATORSHIPPOSLIST) do
            if v[1] >= pos.x - 0.1 and v[1] <= pos.x + 0.1 and v[2] >= pos.z - 0.1 and v[2] <= pos.z + 0.1 then
                key = k
                break
            end
        end
        local data = {
            id = id,
            key = key
        }
        build:setLiberaborShipTableKey(key)
        self.liberaborShipTable[key] = data
    end
end

function BuildingManager:setOtherBuilding(id, build)
    self.otherBuilding[id] = build
end

-- ""
function BuildingManager:searchSpace(pos, length, width, grid)
    local newPos = pos
    for i = 0, constant.BUILD_GRID_MAX do
        local args = i
        local isBreak = false
        for z = 0, args do
            local argsZ = z
            newPos = self:searchSpaceX(pos, length, width, args, argsZ, grid)
            if newPos then
                isBreak = true
                break
            end
            argsZ = -z
            newPos = self:searchSpaceX(pos, length, width, args, argsZ, grid)
            if newPos then
                isBreak = true
                break
            end
        end
        if isBreak then
            break
        end
    end
    return newPos
end

function BuildingManager:searchSpaceX(pos, length, width, args, argsZ, grid)
    local newPos = pos
    for x = 0, args do
        local argsX = x
        newPos = Vector3(pos.x + argsX, pos.y, pos.z + argsZ)
        if self:boolGridTable(newPos, length, width, grid) then
            return newPos
        end
        newPos = Vector3(pos.x - argsX, pos.y, pos.z + argsZ)
        if self:boolGridTable(newPos, length, width, grid) then
            return newPos
        end
    end
    return nil
end

-- ""
function BuildingManager:loadBuildingListObj(onScene, callback)
    if not self.otherBase then
        ResMgr:LoadGameObjectAsync("BuildingList", function(go)
            go.transform.position = Vector3(0, 0, 0)
            go.name = string.format("OtherBase")
            self.otherBase = go
            self.otherBase:SetActive(false)
            return true
        end)
    end
    if not self.ownBase then
        ResMgr:LoadGameObjectAsync("BuildingList", function(go)
            go.transform.position = Vector3(0, 0, 0)
            go.name = string.format("OwnBase")
            self.ownBase = go
            -- ""
            if onScene == constant.SCENE_BASE then
                self:initBase()
            else
                gg.sceneManager:jumpSceneAction()
            end
            if callback then
                callback()
            end
            return true
        end)
    else
        self.ownBase:SetActiveEx(true)
        self.otherBase:SetActiveEx(false)

        -- ""
        if onScene == constant.SCENE_BASE then
            self:initBase()
        else
            gg.sceneManager:jumpSceneAction()
        end
        if callback then
            callback()
        end
    end

end

function BuildingManager:loadGalaxyList()
    ResMgr:LoadGameObjectAsync("BuildingList", function(go)
        go.transform.position = Vector3(0, 0, 0)
        go.name = string.format("Galaxy")
        self.galaxy = go
        self.galaxy:SetActive(false)
        ResMgr:LoadGameObjectAsync("BuildingList", function(obj)
            obj.transform:SetParent(self.galaxy.transform, false)
            obj.transform.position = Vector3(0, 0, 0)
            obj.name = string.format("GalaxyStatus")
            self.galaxyStatus = obj
            self.galaxyStatus:SetActive(true)
            return true
        end)

        return true
    end)
end

function BuildingManager:onClickGround()
    gg.event:dispatchEvent("onShowButtonUi", -1)
    gg.event:dispatchEvent("onClickStellar")
    gg.event:dispatchEvent("onClickPlanet")

end

-- ""
function BuildingManager:moveBuilding(pos)
    if self.selectedBuilding then
        if (self.selectedBuilding.buildCfg.type == constant.BUILD_CLUTTER or not gg.galaxyManager:isMyResPlanet()) and
            not EditData.isEditMode then
            return
        end
        local worldPos = self:getWorldPoint(pos)
        if self.selectedBuilding.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
            self.selectedBuilding:onMoveLiberaborShip(worldPos)
        else
            gg.sceneManager:setGridGroundAlpna(false)
            if worldPos then
                self.selectedBuilding:onMoveBuilding(worldPos)
            end
        end
    end
end

-- ""
function BuildingManager:isExchangeBuilding(pos, length, width)
    -- ""A""；""B""
    if self.exBuilding then
        -- ""B，""A""
        local minX = self.exBuilding.lastPos.x
        local minZ = self.exBuilding.lastPos.z
        local maxX = minX + self.exBuilding.buildCfg.length - 1
        local maxZ = minZ + self.exBuilding.buildCfg.width - 1

        local posX = pos.x + length / 2
        local posZ = pos.z + width / 2

        if posX < minX or posX > maxX or posZ < minZ or posZ > maxZ then
            self:returnBuilding()
        end
    end

    local bool = false
    local startX = pos.x
    local startZ = pos.z
    local endX = pos.x + length - 1
    local endZ = pos.z + width - 1
    if startX < constant.BUILD_GRID_MIN or startZ < constant.BUILD_GRID_MIN or endX > constant.BUILD_GRID_MAX or endZ >
        constant.BUILD_GRID_MAX then
        -- ""A""，""
        if self.exBuilding then
            self:returnBuilding()
        end
        return false
    end

    local nowTable = self.gridTable
    if self.selectedBuilding.owner == BuildingManager.OWNER_OTHER then
        nowTable = self.otherGrid
    end

    local key = 0
    local value = 0
    for x = startX, endX do
        local isBreak = false
        for z = startZ, endZ do
            if nowTable[x][z] ~= 0 then
                if key == 0 then
                    key = nowTable[x][z]
                end
                if key == nowTable[x][z] then
                    value = value + 1
                else
                    isBreak = true
                    break
                end
            end
        end
        if isBreak then
            key = -1
            break
        end
    end

    if key > 0 then
        if self.exBuilding then
            self:returnBuilding()
        end

        local newTable = self.buildingTable
        if self.selectedBuilding.owner == BuildingManager.OWNER_OTHER then
            newTable = self.otherBuilding
        end

        local maxV = value
        local maxK = key

        if not newTable[maxK] then
            return false
        end

        local selectedLenght = length
        local selectedwidth = width
        local selectedArea = selectedLenght * selectedwidth

        local exLenght = newTable[maxK].view.length
        local exwidth = newTable[maxK].view.width
        local exArea = exLenght * exwidth
        local accounted = 0

        if selectedArea >= exArea then
            accounted = maxV / exArea
        else
            accounted = maxV / selectedArea
        end
        if accounted >= 0.5 then
            self.exBuilding = newTable[maxK]
        end

        if self.exBuilding then
            local isSpace = self:boolGridTable(self.selectedBuilding.lastPos, self.exBuilding.view.length,
                self.exBuilding.view.width)
            if isSpace and self.exBuilding.buildCfg.type ~= constant.BUILD_CLUTTER then
                local newMinX = self.selectedBuilding.lastPos.x
                local newMinZ = self.selectedBuilding.lastPos.z
                local newMaxX = newMinX + self.exBuilding.view.length - 1
                local newMaxZ = newMinZ + self.exBuilding.view.width - 1

                local notInclude = true
                if newMinX >= startX and newMinX <= endX then
                    if newMinZ >= startZ and newMinZ <= endZ then
                        notInclude = false
                    elseif newMaxZ >= startZ and newMaxZ <= endZ then
                        notInclude = false
                    end
                elseif newMaxX >= startX and newMaxX <= endX then
                    if newMinZ >= startZ and newMinZ <= endZ then
                        notInclude = false
                    elseif newMaxZ >= startZ and newMaxZ <= endZ then
                        notInclude = false
                    end
                elseif startX >= newMinX and startX <= newMaxX then
                    if startZ >= newMinZ and startZ <= newMaxZ then
                        notInclude = false
                    elseif endZ >= newMinZ and endZ <= newMaxZ then
                        notInclude = false
                    end
                elseif endX >= newMinX and endX <= newMaxX then
                    if startZ >= newMinZ and startZ <= newMaxZ then
                        notInclude = false
                    elseif endZ >= newMinZ and endZ <= newMaxZ then
                        notInclude = false
                    end
                end

                if notInclude then
                    self:setGridTable(self.exBuilding.lastPos, self.exBuilding.view.length, self.exBuilding.view.width,
                        0, self.exBuilding.owner)
                    bool = true
                end
            end
        end
    elseif key == 0 then
        bool = true
    end

    return bool
end

function BuildingManager:returnBuilding()
    if self.isExchange then
        self.exBuilding:backLastPos()
        self:setGridTable(self.selectedBuilding.lastPos, self.exBuilding.view.length, self.exBuilding.view.width, 0,
            self.exBuilding.owner)
        self:setGridTable(self.exBuilding.lastPos, self.exBuilding.view.length, self.exBuilding.view.width,
            self.exBuilding.buildData.id, self.exBuilding.owner)
        self.exBuilding = nil
        self.isExchange = false
    end
end

function BuildingManager:exchangeBuilding(bool)
    if self.exBuilding then
        if bool then
            self.isExchange = true
            self.exBuilding.view:setPos(self.selectedBuilding.lastPos)
            self:setGridTable(self.selectedBuilding.lastPos, self.exBuilding.view.length, self.exBuilding.view.width,
                self.exBuilding.buildData.id, self.exBuilding.owner)
        else
            self:returnBuilding()
            self.exBuilding = nil
            self.isExchange = false
        end
    end
end

-- ""
function BuildingManager:exchangeLiberaborShip(newKey, oldKey, betweenShipKey)
    local id = self.liberaborShipTable[newKey].id
    local newShip = self.buildingTable[id]
    self.exchangeLiberaborShipId = id
    local newPos = constant.BUILD_LIBERATORSHIPPOSLIST[oldKey]
    local newVec = Vector3(newPos[1], 0, newPos[2])
    self.buildingTable[id].temporaryKey = oldKey
    -- ""
    newShip.view:setPos(newVec)
    -- ""
    if betweenShipKey then
        if betweenShipKey ~= oldKey and betweenShipKey ~= newKey then
            local betweenShipId = self.liberaborShipTable[betweenShipKey].id
            local betweenShip = self.buildingTable[betweenShipId]
            local betweenShipPos = constant.BUILD_LIBERATORSHIPPOSLIST[betweenShipKey]
            local betweenShipVec = Vector3(betweenShipPos[1], 0, betweenShipPos[2])
            betweenShip.view:setPos(betweenShipVec)
        end
    end
end

-- ""
function BuildingManager:getWorldPoint(pos)
    if not self.screenRaycaster then
        return nil
    end
    local worldPos = self.screenRaycaster:luaRaycast(pos)
    if worldPos.isTrue then
        return Vector3(worldPos.posX, worldPos.posY, worldPos.posZ), worldPos.gameObject
    end
    return nil
end

-- ""
function BuildingManager:getWorldPointInt(pos)
    local newPos = self:getWorldPoint(pos)
    if not newPos then
        return nil
    end

    local integerX, decimalX = math.modf(newPos.x)
    local integerZ, decimalZ = math.modf(newPos.z)

    if decimalX >= 0.5 then
        integerX = integerX + 1
    end
    if decimalZ >= 0.5 then
        integerZ = integerZ + 1
    end

    return Vector3(integerX, 0, integerZ)

end

-- ""
function BuildingManager:checkBuilding(pos)
    if not self.isBuildModel and self.baseOwner ~= BuildingManager.OWNER_MAP then
        self.exBuilding = nil
        self.isExchange = false

        local isNewBuild = true
        local worldPos, hitObj = self:getWorldPoint(pos)

        -- print(hitObj.name)

        if hitObj then
            if hitObj.name == "BuildingWarShipCube" then
                return false
            else
                gg.event:dispatchEvent("onHideUi")
            end
        end

        if EditData.isEditMode then
            for k, v in pairs(self.buildingTable) do
                v.view:setMaterial(2)
            end
        end

        local newBuild = nil
        if self:checkFingerOnBuilding(pos) then
            isNewBuild = false
            newBuild = self.selectedBuilding
        else
            isNewBuild = true
            self:moveComplete()
        end

        if isNewBuild then
            local newTable = {}
            if self.baseOwner == BuildingManager.OWNER_OWN then
                newTable = self.buildingTable
            elseif self.baseOwner == BuildingManager.OWNER_OTHER then
                newTable = self.otherBuilding
            end
            for k, v in pairs(newTable) do
                if v:contrastPos(worldPos) then
                    newBuild = v
                    break
                end
            end
        end
        if newBuild then
            if self.selectedBuilding == newBuild then
                if self.selectedBuilding.onSpace then
                    return false
                else
                    return true
                end
            else
                self.selectedBuilding = newBuild
                self.selectedBuilding.lastPos = self.selectedBuilding.view.pos
                -- AudioFmodMgr:PlaySFX(constant.AUDIO_BUILDING_CLICK.event)
                AudioFmodMgr:Play2DOneShot(constant.AUDIO_BUILDING_CLICK.event, constant.AUDIO_BUILDING_CLICK.bank)
                self.selectedBuilding:showBuildUi(true, false, true)
                self.selectedBuilding:onHideRes(false)
                self.selectedBuilding.isMoveFirst = true
                self:setGridTable(self.selectedBuilding.view.pos, self.selectedBuilding.view.length,
                    self.selectedBuilding.view.width, 0, self.selectedBuilding.owner)
                return true
            end
        end
    end
end

-- ""
function BuildingManager:releaseFinger()
    if self.exBuilding then
        self.exBuilding.isMoved = true
        self.exBuilding:refreshSurfaceData(false)
    end
    self.exBuilding = nil
    self.isExchange = false
    if self.selectedBuilding then
        if self.selectedBuilding.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
            if self.exchangeLiberaborShipId then
                if self.exchangeLiberaborShipId ~= self.selectedBuilding.buildData.id then
                    local selectedBuilding = self.selectedBuilding
                    local exchangeLiberaborShip = self.buildingTable[self.exchangeLiberaborShipId]

                    selectedBuilding:setLiberaborShipTableKey()
                    exchangeLiberaborShip:setLiberaborShipTableKey()
                    -- ""liberaborShipTable""id
                    self.liberaborShipTable[selectedBuilding.liberaborShipTableKey].id = selectedBuilding.buildData.id
                    self.liberaborShipTable[exchangeLiberaborShip.liberaborShipTableKey].id =
                        exchangeLiberaborShip.buildData.id

                    BuildData.C2S_Player_BuildExchange(self.selectedBuilding.buildData.id, self.exchangeLiberaborShipId)
                end
            end
            self.exchangeLiberaborShipId = nil
            self.selectedBuilding:onReleaseFinger()
        else
            if self.selectedBuilding.buildData and self.selectedBuilding.onSpace then
                local id = self.selectedBuilding.buildData.id
                local x = self.selectedBuilding.view.pos.x
                local z = self.selectedBuilding.view.pos.z
                if self.selectedBuilding.lastPos ~= self.selectedBuilding.view.pos then
                    if self.baseOwner == BuildingManager.OWNER_OWN then
                        BuildData.C2S_Player_BuildMove(id, x, z)
                    elseif self.baseOwner == BuildingManager.OWNER_OTHER then
                        if gg.galaxyManager.curPlanet then
                            -- local index = gg.galaxyManager.curPlanet.index
                            -- ResPlanetData.C2S_Player_ResPlanetMoveBuild(index, id, x, z)
                            local cfgId = gg.galaxyManager.curPlanet.cfgId
                            GalaxyData.C2S_Player_moveBuildOnGrid(cfgId, id, x, z)
                        end
                    end
                    self.selectedBuilding.lastPos = self.selectedBuilding.view.pos
                end

                gg.sceneManager:setGridGroundAlpna(true)
                self.selectedBuilding:onReleaseFinger()
            end
        end
        self.selectedBuilding:showBuildUi(true)
    end
end

-- ""
function BuildingManager:releaseBuilding(successful, isNotPlayAudio)
    if self.selectedBuilding then
        gg.sceneManager:setGridGroundAlpna(true)
        self.selectedBuilding.view:onReleaseFinger()
        if successful then
            self:setGridTable(self.selectedBuilding.view.pos, self.selectedBuilding.view.length,
                self.selectedBuilding.view.width, self.selectedBuilding.buildData.id, self.selectedBuilding.owner)
        end

        if not isNotPlayAudio then
            -- AudioFmodMgr:PlaySFX(constant.AUDIO_BUILDING_CLICK.event)
            AudioFmodMgr:Play2DOneShot(constant.AUDIO_BUILDING_CLICK.event, constant.AUDIO_BUILDING_CLICK.bank)
        end

        self.selectedBuilding:showBuildUi(false)
        self.selectedBuilding:onHideRes(true)
        self.selectedBuilding = nil
        self.isBuildModel = false
    end
end

-- ""
function BuildingManager:moveComplete()
    if self.selectedBuilding and not self.isBuildModel then
        if not self.selectedBuilding.onSpace then
            self.selectedBuilding:backLastPos(true)
        else
            self.selectedBuilding:refreshSurfaceData(true)
        end
        self:releaseBuilding(true)
    end
end

-- ""
function BuildingManager:checkFingerOnBuilding(pos)
    if self.selectedBuilding then
        local worldPos = self:getWorldPoint(pos)
        if self.selectedBuilding:contrastPos(worldPos) then
            return true
        end
    end
    return false
end

-- ""，""，""
function BuildingManager:cancelBuildOrMove()
    if not self.isWaitBuild then
        if self.isBuildModel and self.selectedBuilding then
            self.selectedBuilding:destroy()
        else
            if self.selectedBuilding then
                self.selectedBuilding.onSpace = false
                self:moveComplete()
            end
        end
    end
end

-- ""
function BuildingManager:buildCollectRes(buildingId)
    local sameBuilding = {}
    table.insert(sameBuilding, self.buildingTable[buildingId])
    local cfgId = self.buildingTable[buildingId].buildCfg.cfgId
    for k, v in pairs(self.buildingTable) do
        if v.buildCfg.cfgId == cfgId and v.buildData.id ~= buildingId then
            table.insert(sameBuilding, v)
        end
    end
    for k, v in pairs(sameBuilding) do
        local curStarCoin = v.buildData.curStarCoin
        local curIce = v.buildData.curIce
        local curCarboxyl = v.buildData.curCarboxyl
        local curTitanium = v.buildData.curTitanium
        local curGas = v.buildData.curGas
        local bool = false

        if curStarCoin + ResData.getStarCoin() > self.resMax[constant.RES_STARCOIN] then
            bool = true
        end
        if curIce + ResData.getIce() > self.resMax[constant.RES_ICE] then
            bool = true
        end
        if curCarboxyl + ResData.getCarboxyl() > self.resMax[constant.RES_CARBOXYL] then
            bool = true
        end
        if curTitanium + ResData.getTitanium() > self.resMax[constant.RES_TITANIUM] then
            bool = true
        end
        if curGas + ResData.getGas() > self.resMax[constant.RES_GAS] then
            bool = true
        end

        if bool then
            gg.event:dispatchEvent("onSetCanNotCollect", v.buildData.id, true)
        end

        BuildData.C2S_Player_BuildGetRes(v.buildData.id)
    end
end

function BuildingManager:buildGetResMsg(msg)
    if self.buildingTable[msg.buildId] then
        self.buildingTable[msg.buildId]:buildGetResMsg(msg)
    end
end

-- ""
function BuildingManager:onUpdateBuildData(args, data)
    if self.baseOwner == BuildingManager.OWNER_OWN or self.baseOwner == BuildingManager.OWNER_MAP then
        if self.buildingTable[data.id] then
            self.buildingTable[data.id]:onUpdateBuildData(data)
        end
        self:refreshAllAlert()
        gg.event:dispatchEvent("onShowNovice")

    elseif self.baseOwner == BuildingManager.OWNER_OTHER then
        if self.otherBuilding[data.id] then
            self.otherBuilding[data.id]:onUpdateBuildData(data)
        end
    end
    self:calculateResMax()
end

-- ""
function BuildingManager:onUpdateGalaxyBuildPos(args, buildId, pos)
    if self.otherBuilding[buildId] then
        self.otherBuilding[buildId].view:setPos(pos)
        self.otherBuilding[buildId].lastPos = pos
    end
end

function BuildingManager:onRefreshResTxt()
    self:refreshAllAlert()
end

function BuildingManager:refreshAllAlert()
    for key, value in pairs(self.buildingTable) do
        value:refreshAlert()
    end
end

function BuildingManager:calculateResMax()
    self.resMax = {
        [constant.RES_STARCOIN] = 0,
        [constant.RES_ICE] = 0,
        [constant.RES_CARBOXYL] = 0,
        [constant.RES_TITANIUM] = 0,
        [constant.RES_GAS] = 0
    }
    self.perMakeRes = {
        [constant.RES_STARCOIN] = 0,
        [constant.RES_ICE] = 0,
        [constant.RES_CARBOXYL] = 0,
        [constant.RES_TITANIUM] = 0,
        [constant.RES_GAS] = 0
    }
    for k, v in pairs(BuildData.buildData) do
        local cfgId = v.cfgId
        local level = v.level
        local myCfg = self:getCfg(cfgId, level)
        if myCfg then
            if myCfg.storeStarCoin then
                self.resMax[constant.RES_STARCOIN] = self.resMax[constant.RES_STARCOIN] + myCfg.storeStarCoin
            end
            if myCfg.storeIce then
                self.resMax[constant.RES_ICE] = self.resMax[constant.RES_ICE] + myCfg.storeIce
            end
            if myCfg.storeCarboxyl then
                self.resMax[constant.RES_CARBOXYL] = self.resMax[constant.RES_CARBOXYL] + myCfg.storeCarboxyl
            end
            if myCfg.storeTitanium then
                self.resMax[constant.RES_TITANIUM] = self.resMax[constant.RES_TITANIUM] + myCfg.storeTitanium
            end
            if myCfg.storeGas then
                self.resMax[constant.RES_GAS] = self.resMax[constant.RES_GAS] + myCfg.storeGas
            end

            if myCfg.perMakeStarCoin then
                self.perMakeRes[constant.RES_STARCOIN] = self.perMakeRes[constant.RES_STARCOIN] + myCfg.perMakeStarCoin
            end
            if myCfg.perMakeIce then
                self.perMakeRes[constant.RES_ICE] = self.perMakeRes[constant.RES_ICE] + myCfg.perMakeIce
            end
            if myCfg.perMakeCarboxyl then
                self.perMakeRes[constant.RES_CARBOXYL] = self.perMakeRes[constant.RES_CARBOXYL] + myCfg.perMakeCarboxyl
            end
            if myCfg.perMakeTitanium then
                self.perMakeRes[constant.RES_TITANIUM] = self.perMakeRes[constant.RES_TITANIUM] + myCfg.perMakeTitanium
            end
            if myCfg.perMakeGas then
                self.perMakeRes[constant.RES_GAS] = self.perMakeRes[constant.RES_GAS] + myCfg.perMakeGas
            end
        end
    end

    gg.event:dispatchEvent("onRefreshResTxt", constant.RES_STARCOIN, -1)
    gg.event:dispatchEvent("onRefreshResTxt", constant.RES_GAS, -1)
    gg.event:dispatchEvent("onRefreshResTxt", constant.RES_ICE, -1)
    gg.event:dispatchEvent("onRefreshResTxt", constant.RES_TITANIUM, -1)
    gg.event:dispatchEvent("onRefreshResTxt", constant.RES_CARBOXYL, -1)

end

-- ""
function BuildingManager:releaseAllResources()
    self:releaseOwnerBuilding()
    self:destroyOtherBuilding()

    ResMgr:ReleaseAsset(self.ownBase)
    ResMgr:ReleaseAsset(self.otherBase)
    self.ownBase = nil
    self.otherBase = nil

    -- print("aaaaaaareleaseAllResources")
end

function BuildingManager:releaseOwnerBuilding()
    gg.event:dispatchEvent("onUnLoadDrone", BuildingManager.OWNER_OWN)
    self.exBuilding = nil
    self.surfaceData = {}
    if self.buildingTable then
        for k, v in pairs(self.buildingTable) do
            v:destroy()
        end
        self.buildingTable = {}
    end
    self.ownSurfaceData = {}
    self.liberaborShipTable = {}
    self.selectedBuilding = nil
    if self.gridTable then
        for k, v in pairs(self.gridTable) do
            v = nil
        end
    end
    self.gridTable = {}
    gg.areaManager:release()
end

function BuildingManager:calcOtherBuilding()
    local a = 0
    for k, v in pairs(self.otherBuilding) do
        a = a + 1
        print("aaaaadestroyOtherBuilding444444")
    end
    print("aaaaacalcOtherBuilding", a)
end

-- ""
function BuildingManager:destroyOtherBuilding()
    gg.event:dispatchEvent("onUnLoadDrone", BuildingManager.OWNER_OTHER)
    self.exBuilding = nil
    if self.otherBuilding then
        -- self:calcOtherBuilding()
        for k, v in pairs(self.otherBuilding) do
            v:destroy()
        end
        self.otherBuilding = {}
    end
    self.otherSurfaceData = {}
    self.selectedBuilding = nil
    if self.otherGrid then
        for k, v in pairs(self.otherGrid) do
            v = nil
        end
    end
    self.otherGrid = {}

end

function BuildingManager:releaseGalaxy()
    ResMgr:ReleaseAsset(self.galaxyStatus)
    ResMgr:ReleaseAsset(self.galaxy)
    self.galaxyStatus = nil
    self.galaxy = nil
end

-- ""
function BuildingManager:onRemoveBuilding(args, id)
    if self.buildingTable[id] then
        self.buildingTable[id]:readyMove()
        self.buildingTable[id]:destroy()
        self.buildingTable[id] = nil
        self:refreshSurface()
    end
end

-- ""
function BuildingManager:onRemoveOtherBuilding(args, id)
    if self.otherBuilding[id] then
        self.otherBuilding[id]:readyMove()
        self.otherBuilding[id]:destroy()
        self.otherBuilding[id] = nil
        self:refreshSurface()
    end
end

function BuildingManager:getBuildLevel(cfgId)
    local level = -1
    for key, value in pairs(self.buildingTable) do
        local buildCfg = value.buildCfg
        if buildCfg.cfgId == cfgId and buildCfg.level > level then
            level = buildCfg.level
        end
    end
    return level
end

-- ""
function BuildingManager:checkResources(buildCfg)
    if buildCfg.levelUpNeedStarCoin > ResData.getStarCoin() then
        return false
    end
    if buildCfg.levelUpNeedIce > ResData.getIce() then
        return false
    end
    if buildCfg.levelUpNeedCarboxyl > ResData.getCarboxyl() then
        return false
    end
    if buildCfg.levelUpNeedGas > ResData.getGas() then
        return false
    end
    if buildCfg.levelUpNeedTitanium > ResData.getTitanium() then
        return false
    end
    return true
end

function BuildingManager.getBuildWorkSpeedUpInfo()
    local workingCount = 0
    local cost = nil
    local buildId = nil

    for key, value in pairs(BuildData.buildData) do
        if value.lessTick > 0 and value.chain <= 0 then
            workingCount = workingCount + 1
            local time = value.lessTickEnd - os.time()
            local temCost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue
            if cost == nil then
                cost = temCost
                buildId = value.id
            else
                if temCost < cost then
                    cost = temCost
                    buildId = value.id
                end
            end
        end
    end
    return workingCount, buildId, cost
end

function BuildingManager:checkWorkers(isAlertWorker, yesCallBack)
    local count, buildId, cost = BuildingManager.getBuildWorkSpeedUpInfo()
    local isEnoughtWorker = count < BuildData.buildQueueCount
    if not isEnoughtWorker and isAlertWorker then
        -- gg.uiManager:showTip("Not enough builders available")
        local args = {
            btnType = PnlAlert.BTN_TYPE_SINGLE
        }

        args.txt = string.format(Utils.getText("universal_Ask_NotEnoughtWorker"), Utils.getShowRes(cost),
            Utils.getText(constant.RES_2_CFG_KEY[constant.RES_TESSERACT].languageKey))
        -- if yesCallBack then
        --     args.txt = string.format(Utils.getText("universal_Ask_NotEnoughtWorker"), Utils.getShowRes(cost), Utils.getText(constant.RES_2_CFG_KEY[constant.RES_TESSERACT].languageKey))
        -- else
        --     args.txt = string.format(Utils.getText("universal_Ask_NotEnoughtWorker"), Utils.getShowRes(cost), constant.RES_2_CFG_KEY[constant.RES_TESSERACT].languageKey)
        -- end

        args.callbackYes = function()
            if yesCallBack then
                yesCallBack()
            else
                BuildData.C2S_Player_BuildLevelUp(buildId, 1)
            end
        end
        args.yesCostList = {{
            cost = cost,
            resId = constant.RES_TESSERACT
        }}
        args.callbackNo = function()
        end
        gg.uiManager:openWindow("PnlAlert", args)
    end
    return isEnoughtWorker
end

function BuildingManager:chenkLiberatorShip()
    local i = 1
    for k, v in pairs(self.liberaborShipTable) do
        i = i + 1
    end
    if i <= constant.BUILD_LIBERATORSHIPMAXNUM then
        return true
    else
        return false
    end
end

-- ""levelUpNeedBuilds
function BuildingManager:checkNeedBuild(needBuilds)
    local isUnlock = true
    local lockMap = {}
    local lockList = {}

    if needBuilds and next(needBuilds) then
        for key, value in pairs(needBuilds) do
            lockMap[value[1]] = {
                isUnlock = false,
                cfgId = value[1],
                level = value[2],
                needCount = value[3] or 1,
                count = 0,
                notEnoughtLevelBuildCount = 0,
                quality = 0
            }
        end

        for key, value in pairs(self.buildingTable) do
            if lockMap[value.buildCfg.cfgId] then
                local lock = lockMap[value.buildCfg.cfgId]
                if value.buildCfg.level >= lock.level then
                    lock.count = lock.count + 1
                else
                    lock.notEnoughtLevelBuildCount = lock.notEnoughtLevelBuildCount + 1
                end
                if lock.count >= lock.needCount then
                    lock.isUnlock = true
                end
            end
        end

        for key, value in pairs(lockMap) do
            if value.isUnlock == false then
                isUnlock = false
                table.insert(lockList, value)
            end
        end
    end
    return isUnlock, lockMap, lockList
end

function BuildingManager:checkUpgradeLock(curCfg)
    return self:checkNeedBuild(curCfg.levelUpNeedBuilds)
end

function BuildingManager:checkBuildCountEnought(cfgId, quality)
    -- if cfgId == constant.BUILD_LIBERATORSHIP then
    --     return true
    -- end
    quality = quality or 0

    local baseBuildCfg = nil
    local buildCfg = BuildUtil.getCurBuildCfg(cfgId, 0, quality)
    local builtCount = 0

    local lockMap = {}

    for key, value in pairs(buildCfg.levelUpNeedBuilds) do
        lockMap[value[1]] = {
            isUnlock = false,
            cfgId = value[1],
            level = value[2],
            quality = value[3] or 0
        }
    end

    for key, value in pairs(BuildData.buildData) do
        if value.cfgId == constant.BUILD_BASE then
            if not baseBuildCfg or baseBuildCfg.level < value.level then
                baseBuildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality) -- value.buildCfg
            end
        end
        if value.cfgId == cfgId then
            builtCount = builtCount + 1
            -- elseif value.buildCfg.buildCountType == buildCfg.buildCountType and value.buildCfg.buildCountType ~= -1 then
            --     builtCount = builtCount + 1
        end

        if lockMap[value.cfgId] then
            local lock = lockMap[value.cfgId]
            if value.level >= lock.level then
                lock.isUnlock = true
            end
        end
    end

    for key, value in pairs(lockMap) do
        if not value.isUnlock then
            return {
                isCanBuild = false,
                count = builtCount,
                canBuildCount = 0,
                baseLevel = 0,
                nextBaseLevel = 0,
                lockInfo = value
            }
        end
    end

    if not baseBuildCfg then
        return {
            isCanBuild = false,
            count = builtCount,
            canBuildCount = 0,
            baseLevel = 0,
            nextBaseLevel = 0
        }
    end

    local buildCountCfg = cfg.buildCount[buildCfg.buildCountType]
    local canBuildCount = 1
    local nextBaseLevel = -1
    if buildCountCfg then
        if #buildCountCfg.buildCount > baseBuildCfg.level then
            canBuildCount = buildCountCfg.buildCount[baseBuildCfg.level]
        else
            canBuildCount = buildCountCfg.buildCount[#buildCountCfg.buildCount]
        end
        for index, value in ipairs(buildCountCfg.buildCount) do
            if value > builtCount then
                nextBaseLevel = index
                break
            end
        end
    end
    return {
        isCanBuild = canBuildCount > builtCount,
        count = builtCount,
        canBuildCount = canBuildCount,
        baseLevel = baseBuildCfg.level,
        nextBaseLevel = nextBaseLevel
    }
end

function BuildingManager:getBlackHoleVaultProtect()
    local build = nil
    for k, v in pairs(self.buildingTable) do
        if v.buildCfg.cfgId == constant.BUILD_BLACKHOLEVAULT then
            build = v
            break
        end
    end
    if build then
        return build.buildCfg.resProtectRatio
    else
        return 0
    end
end

function BuildingManager:getBaseLevel()
    if BuildData.buildData[self:getBaseId()] then
        return BuildData.buildData[self:getBaseId()].level
    else
        return 0
    end
end

function BuildingManager:getBaseId()

    if not self.ownBaseId then
        for key, value in pairs(BuildData.buildData) do
            if value.cfgId == constant.BUILD_BASE then
                self.ownBaseId = value.id
            end
        end
    end

    return self.ownBaseId
end

return BuildingManager
