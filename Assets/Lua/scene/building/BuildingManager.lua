BuildingManager = class("BuildingManager")

BuildingManager.OWNER_OWN = 1
BuildingManager.OWNER_OTHER = 2
BuildingManager.OWNER_MAP = 3

function BuildingManager:ctor()
    self.isBuildModel = false -- 
    self.buildingTable = {} -- 
    self.otherBuilding = {} -- 
    self.liberaborShipTable = {} -- 
    self.selectedBuilding = nil -- 
    self.ownBase = nil
    self.otherBase = nil
    self.resPlanet = nil
    self.screenRaycaster = nil
    self.gridTable = {} --  01
    self.buildingCfg = cfg.get("etc.cfg.build")
    self:initShopTable()
    self:bindEvent()
    self.scene = ggclass.BuildingScene.new()
    self.screenRaycaster = global:GetComponent("ScreenRaycaster")

end

function BuildingManager:bindEvent()
    gg.event:addListener("onUpdateBuildData", self)
    gg.event:addListener("onRemoveBuilding", self)
end

-- 
function BuildingManager:initShopTable()
    self.buildingTableOfEconomic = {}
    self.buildingTableOfDevelopment = {}
    self.buildingTableOfDefense = {}
    local buildCfg = self.buildingCfg
    for k, v in ipairs(buildCfg) do
        if v.type == 1 and v.level == 0 and v.quality == 1 then
            table.insert(self.buildingTableOfEconomic, v)
        end
        if v.type == 2 and v.level == 0 and v.quality == 1 then
            table.insert(self.buildingTableOfDevelopment, v)
        end
        if (v.type == 3 or v.type == 4) and v.level == 0 and v.quality == 1 then
            table.insert(self.buildingTableOfDefense, v)
        end
    end

    -- print("buildingTableOfEconomic",table.dump(self.buildingTableOfEconomic))
    -- print("buildingTableOfDevelopment",table.dump(self.buildingTableOfDevelopment))
    -- print("buildingTableOfDefense",table.dump(self.buildingTableOfDefense))
    -- local i = 0
    -- for k,v in ipairs(self.buildingTableOfEconomic) do
    --     print(v.model)
    --     i = i + 1
    -- end
    -- for k,v in ipairs(self.buildingTableOfDevelopment) do
    --     print(v.model)
    --     i = i + 1
    -- end
    -- for k,v in ipairs(self.buildingTableOfDefense) do
    --     print(v.model)
    --     i = i + 1
    -- end
    -- print("jjjjjjjjjjjjjjjj"..i)
end

-- 
function BuildingManager:initGridTable()
    local gridCountMax = constant.BUILD_GRID_MAX
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

-- 
function BuildingManager:setGridTable(pos, length, width, args, owner)
    if not gg.resPlanetManager:isMyResPlanet() then
        return
    end
    -- args 01

    local minX = pos.x
    local minZ = pos.z
    local maxX = pos.x + length - 1
    local maxZ = pos.z + width - 1
    for x = minX, maxX do
        for z = minZ, maxZ do
            if owner == BuildingManager.OWNER_OWN then
                self.gridTable[x][z] = args
            elseif owner == BuildingManager.OWNER_OTHER then
                self.otherGrid[x][z] = args
            end
        end
    end
end

-- 
function BuildingManager:boolGridTable(pos, length, width)
    local minX = pos.x
    local minZ = pos.z
    local maxX = pos.x + length - 1
    local maxZ = pos.z + width - 1

    if minX < constant.BUILD_GRID_MIN or minZ < constant.BUILD_GRID_MIN or maxX > constant.BUILD_GRID_MAX or maxZ >
        constant.BUILD_GRID_MAX then
        return false
    end
    local curGrid = {}

    if self.baseOwner == BuildingManager.OWNER_OWN then
        curGrid = self.gridTable
    elseif self.baseOwner == BuildingManager.OWNER_OTHER then
        curGrid = self.otherGrid
    end

    for x = minX, maxX do
        for z = minZ, maxZ do
            if curGrid[x][z] == 1 then
                return false
            end
        end
    end

    return true
end

-- 
function BuildingManager:initAllBuilding()
    self:initGridTable()
    self.buildingTable = {}
    self.liberaborShipTable = {}
    for i, b in pairs(BuildData.buildData) do
        local cfg = self:getCfg(b.cfgId, b.level)
        if cfg then
            self:loadBuilding(cfg, b, nil, BuildingManager.OWNER_OWN)
        end
    end
    self.isBuildModel = false
    self:calculateResMax()
    self.baseOwner = BuildingManager.OWNER_OWN
end

function BuildingManager:initOtherBuilding(buildDatas)
    self:resetOtherGrid()
    self.otherBuilding = {}
    for i, b in pairs(buildDatas) do
        local cfg = self:getCfg(b.cfgId, b.level)
        if cfg then
            self:loadBuilding(cfg, b, nil, BuildingManager.OWNER_OTHER)
        end
    end
end

-- 
function BuildingManager:getCfg(cfgId, level)
    local buildCfg = self.buildingCfg
    local cfg = nil
    for k, v in ipairs(buildCfg) do
        if v.cfgId == cfgId and v.level == level then
            cfg = v
            break
        end
    end
    return cfg
end

-- 
function BuildingManager:requestLoadBuilding(cfgId, pos)
    BuildData.C2S_Player_BuildCreate(cfgId, pos.x, pos.z)
end

-- 
function BuildingManager:buildSuccessful(buildData)
    self:setBuildingTable(buildData.id, self.selectedBuilding)
    self.selectedBuilding:buildSuccessful(buildData)
    self:releaseBuilding(true)
end

-- 
-- buildCfg = 
-- buildData = 
-- isItem = 
-- owner = 
function BuildingManager:loadBuilding(buildCfg, buildData, isItem, owner)
    local pos = nil
    if buildData then
        pos = buildData.pos
    else
        if buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
            local i = 1
            for k, v in pairs(self.liberaborShipTable) do
                i = i + 1
            end
            local vec = constant.BUILD_LIBERATORSHIPPOSLIST[i]
            pos = Vector3(vec[1], 0, vec[2])
        else
            local center = Vector3(UnityEngine.Screen.width / 2, UnityEngine.Screen.height / 2)
            pos = self:getWorldPointInt(center)
            pos = self:searchSpace(pos, buildCfg.length, buildCfg.width)
        end
    end

    local building = ggclass.Building.new(buildCfg, pos, buildData, isItem, owner)

    if buildData then
        if owner == BuildingManager.OWNER_OWN then
            self:setBuildingTable(buildData.id, building)
        else
            self.otherBuilding[buildData.id] = building
        end
    else
        self.selectedBuilding = building
        self.isBuildModel = true
        if buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
            gg.sceneManager:setGridGroungAlpna(130)
        end
    end
end

-- buildingTable
function BuildingManager:setBuildingTable(id, build)
    self.buildingTable[id] = build
    if build.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
        local key = 0
        local pos = build.view.pos
        for k, v in ipairs(constant.BUILD_LIBERATORSHIPPOSLIST) do
            if v[1] == pos.x and v[2] == pos.z then
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

-- 
function BuildingManager:searchSpace(pos, length, width)
    local newPos = pos
    for i = 0, constant.BUILD_GRID_MAX do
        local args = i
        local isBreak = false
        for z = 0, args do
            local argsZ = z
            newPos = self:searchSpaceX(pos, length, width, args, argsZ)
            if newPos then
                isBreak = true
                break
            end
            argsZ = -z
            newPos = self:searchSpaceX(pos, length, width, args, argsZ)
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

function BuildingManager:searchSpaceX(pos, length, width, args, argsZ)
    local newPos = pos
    for x = 0, args do
        local argsX = x
        newPos = Vector3(pos.x + argsX, pos.y, pos.z + argsZ)
        if self:boolGridTable(newPos, length, width) then
            return newPos
        end
        newPos = Vector3(pos.x - argsX, pos.y, pos.z + argsZ)
        if self:boolGridTable(newPos, length, width) then
            return newPos
        end
    end
    return nil
end

-- 
function BuildingManager:loadBuildingListObj(callback)
    ResMgr:LoadGameObjectAsync("BuildingList", function(go)
        go.transform.position = Vector3(0, 0, 0)
        go.name = string.format("OwnBase")
        self.ownBase = go
        -- self.screenRaycaster =  go.transform:GetComponent("ScreenRaycaster") 
        self:initAllBuilding()
        gg.warShip:loadWarShip()
        local window = gg.uiManager:getWindow("PnlMain")
        window:creatBoat()

        if callback then
            callback()
        end

        return true
    end)
    ResMgr:LoadGameObjectAsync("BuildingList", function(go)
        go.transform.position = Vector3(0, 0, 0)
        go.name = string.format("OtherBase")
        self.otherBase = go

        return true
    end)
    ResMgr:LoadGameObjectAsync("BuildingList", function(go)
        go.transform.position = Vector3(0, 0, 0)
        go.name = string.format("ResPlanet")
        self.resPlanet = go

        return true
    end)
end

-- 
function BuildingManager:moveBuilding(pos)
    if self.selectedBuilding then
        if self.selectedBuilding.buildCfg.type == constant.BUILD_CLUTTER or not gg.resPlanetManager:isMyResPlanet() then
            return
        end
        local worldPos = self:getWorldPoint(pos)
        if self.selectedBuilding.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
            self.selectedBuilding:onMoveLiberaborShip(worldPos)
        else
            gg.sceneManager:setGridGroungAlpna(130)
            if worldPos then
                self.selectedBuilding:onMoveBuilding(worldPos)
            end
        end
    end
end

-- 
function BuildingManager:exchangeLiberaborShip(newKey, oldKey, betweenShipKey)
    local id = self.liberaborShipTable[newKey].id
    local newShip = self.buildingTable[id]
    self.exchangeLiberaborShipId = id
    local newPos = constant.BUILD_LIBERATORSHIPPOSLIST[oldKey]
    local newVec = Vector3(newPos[1], 0, newPos[2])
    self.buildingTable[id].temporaryKey = oldKey
    -- 
    newShip.view:setPos(newVec)
    -- 
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

-- 
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

-- 
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

-- 
function BuildingManager:checkBuilding(pos)
    if not self.isBuildModel then
        local isNewBuild = true
        local worldPos, hitObj = self:getWorldPoint(pos)
        if hitObj then
            if hitObj.name == "BuildingWarShip" then
                return false
            else
                gg.event:dispatchEvent("onHideUi")
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
                self.selectedBuilding:showBuildUi(true)
                self.selectedBuilding:onHideRes(false)
                self:setGridTable(self.selectedBuilding.view.pos, self.selectedBuilding.view.length,
                    self.selectedBuilding.view.width, 0, self.selectedBuilding.owner)
                return true
            end
        end
    end
end

-- 
function BuildingManager:releaseFinger()
    if self.selectedBuilding then
        if self.selectedBuilding.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
            if self.exchangeLiberaborShipId then
                if self.exchangeLiberaborShipId ~= self.selectedBuilding.buildData.id then
                    local selectedBuilding = self.selectedBuilding
                    local exchangeLiberaborShip = self.buildingTable[self.exchangeLiberaborShipId]

                    selectedBuilding:setLiberaborShipTableKey()
                    exchangeLiberaborShip:setLiberaborShipTableKey()
                    -- liberaborShipTableid
                    self.liberaborShipTable[selectedBuilding.liberaborShipTableKey].id = selectedBuilding.buildData.id
                    self.liberaborShipTable[exchangeLiberaborShip.liberaborShipTableKey].id =
                        exchangeLiberaborShip.buildData.id

                    BuildData.C2S_Player_BuildExchange(self.selectedBuilding.buildData.id, self.exchangeLiberaborShipId)
                end
            end
            self.exchangeLiberaborShipId = nil
            self.selectedBuilding.view:onReleaseFinger()
        else
            if self.selectedBuilding.buildData and self.selectedBuilding.lastPos ~= self.selectedBuilding.view.pos and
                self.selectedBuilding.onSpace then
                local id = self.selectedBuilding.buildData.id
                local x = self.selectedBuilding.view.pos.x
                local z = self.selectedBuilding.view.pos.z
                if self.baseOwner == BuildingManager.OWNER_OWN then
                    BuildData.C2S_Player_BuildMove(id, x, z)
                elseif self.baseOwner == BuildingManager.OWNER_OTHER then
                    local index = gg.resPlanetManager.curPlanet.index
                    ResPlanetData.C2S_Player_ResPlanetMoveBuild(index, id, x, z)
                end

                self.selectedBuilding.lastPos = self.selectedBuilding.view.pos
                gg.sceneManager:setGridGroungAlpna(0)
                self.selectedBuilding.view:onReleaseFinger()
            end
        end
        self.selectedBuilding:showBuildUi(true)
    end
end

-- 
function BuildingManager:releaseBuilding(successful)
    if self.selectedBuilding then
        gg.sceneManager:setGridGroungAlpna(0)
        self.selectedBuilding.view:onReleaseFinger()
        if successful then
            self:setGridTable(self.selectedBuilding.view.pos, self.selectedBuilding.view.length,
                self.selectedBuilding.view.width, 1, self.selectedBuilding.owner)
        end
        self.selectedBuilding:showBuildUi(false)
        self.selectedBuilding:onHideRes(true)
        self.selectedBuilding = nil

        self.isBuildModel = false
    end
end

-- 
function BuildingManager:moveComplete()
    if self.selectedBuilding and not self.isBuildModel then
        if not self.selectedBuilding.onSpace then
            self.selectedBuilding:backLastPos()
        end
        self:releaseBuilding(true)
    end
end

-- 
function BuildingManager:checkFingerOnBuilding(pos)
    if self.selectedBuilding then
        local worldPos = self:getWorldPoint(pos)
        if self.selectedBuilding:contrastPos(worldPos) then
            return true
        end
    end
    return false
end

-- 
function BuildingManager:cancelBuildOrMove()
    if self.isBuildModel and self.selectedBuilding then
        self.selectedBuilding:destroy()
    else
        if self.selectedBuilding then
            self.selectedBuilding.onSpace = false
            self:moveComplete()
        end
    end
end

-- 
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
        local bool = true
        if curStarCoin + ResData.getStarCoin() > self.resMax.storeStarCoin then
            bool = false
        end
        if curIce + ResData.getIce() > self.resMax.storeIce then
            bool = false
        end
        if curCarboxyl + ResData.getCarboxyl() > self.resMax.storeCarboxyl then
            bool = false
        end
        if curTitanium + ResData.getTitanium() > self.resMax.storeTitanium then
            bool = false
        end
        if curGas + ResData.getGas() > self.resMax.storeGas then
            bool = false
        end
        if bool then
            BuildData.C2S_Player_BuildGetRes(v.buildData.id)
        else
            gg.event:dispatchEvent("onSetCanNotCollect", v.buildData.id, true)
            local window = gg.uiManager:getWindow("PnlTip")
            if not window then
                gg.uiManager:showTip("Resources is full, please upgrade the warehouse.")
            end
        end
    end
end

function BuildingManager:buildGetResMsg(msg)
    self.buildingTable[msg.id]:buildGetResMsg(msg)
end

-- 
function BuildingManager:onUpdateBuildData(args, data)
    if self.buildingTable then
        self.buildingTable[data.id]:onUpdateBuildData(data)
    end
    self:calculateResMax()
end

function BuildingManager:calculateResMax()
    self.resMax = {
        storeStarCoin = 0,
        storeIce = 0,
        storeCarboxyl = 0,
        storeTitanium = 0,
        storeGas = 0
    }
    for k, v in pairs(BuildData.buildData) do
        local cfgId = v.cfgId
        local level = v.level
        local cfg = self:getCfg(cfgId, level)
        if cfg.storeStarCoin then
            self.resMax.storeStarCoin = self.resMax.storeStarCoin + cfg.storeStarCoin
        end
        if cfg.storeIce then
            self.resMax.storeIce = self.resMax.storeIce + cfg.storeIce
        end
        if cfg.storeCarboxyl then
            self.resMax.storeCarboxyl = self.resMax.storeCarboxyl + cfg.storeCarboxyl
        end
        if cfg.storeTitanium then
            self.resMax.storeTitanium = self.resMax.storeTitanium + cfg.storeTitanium
        end
        if cfg.storeGas then
            self.resMax.storeGas = self.resMax.storeGas + cfg.storeGas
        end
    end
end

-- 
function BuildingManager:releaseAllResources()
    if self.buildingTable then
        for k, v in pairs(self.buildingTable) do
            v:destroy()
        end
        self.buildingTable = {}
    end
    self:destroyOtherBuilding()
    gg.resPlanetManager:destoryAllResPlanet()
    self.liberaborShipTable = {}
    self.selectedBuilding = nil
    ResMgr:ReleaseAsset(self.ownBase)
    ResMgr:ReleaseAsset(self.otherBase)
    ResMgr:ReleaseAsset(self.resPlanet)
    self.ownBase = nil
    self.otherBase = nil
    self.resPlanet = nil
    -- self.screenRaycaster = nil
end

-- 
function BuildingManager:destroyOtherBuilding()
    if self.otherBuilding then
        for k, v in pairs(self.otherBuilding) do
            v:destroy()
        end
        self.otherBuilding = {}
    end
end

-- 
function BuildingManager:onRemoveBuilding(args, id)
    self.buildingTable[id]:destroy()
    self.buildingTable[id] = nil
end

-- 
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

function BuildingManager:chenckWorkers()
    -- TODO 
    return true
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

return BuildingManager
