SurfaceUtil = SurfaceUtil or {}

SurfaceUtil.SURFACE_TYPE_ARRIS = "Arris"
SurfaceUtil.SURFACE_TYPE_FLOOR = "Floor_tile"
SurfaceUtil.SURFACE_TYPE_INSIDE = "Inside_corner"
SurfaceUtil.SURFACE_TYPE_SIDEWALK = "Sidewalk"
SurfaceUtil.SURFACE_TYPE_NONE = "NONE"
SurfaceUtil.SURFACE_TYPE_OUTSIDE = "OUTSIDE"

function SurfaceUtil.isHaveSurface(cfg)
    if cfg.type ~= 8 and cfg.subType ~= 4 then
        return true
    end
    return false
end

function SurfaceUtil.getSurfaceKey(keyX, keyZ)
    keyX = math.floor(keyX)
    keyZ = math.floor(keyZ)
    return string.format("x:%s;z:%s", keyX, keyZ)
end

-- ""
function SurfaceUtil.makeSurface(buildCfg, pos, tran, id, isReset, callback, isNewBuilding, extension)
    if not SurfaceUtil.isHaveSurface(buildCfg) then
        return
    end
    extension = extension or 0
    local surfaceData = {}
    local surfaceLength = buildCfg.length + 2 + extension
    local surfaceWide = buildCfg.width + 2 + extension
    local startLocalPosX = -0.5 - extension / 2
    local startLocalPosZ = -0.5 - extension / 2
    local startPosX = pos.x - 0.5 - extension / 2
    local startPosZ = pos.z - 0.5 - extension / 2
    local startKeyX = pos.x - 1 - extension / 2
    local startKeyZ = pos.z - 1 - extension / 2

    for l = 1, surfaceLength do
        for w = 1, surfaceWide do
            local localPosX = startLocalPosX + l - 1
            local localPosZ = startLocalPosZ + w - 1
            local posX = startPosX + l - 1
            local posZ = startPosZ + w - 1
            local keyX = startKeyX + l - 1
            local keyZ = startKeyZ + w - 1
            local type = nil
            local len = l
            local wid = w
            local angel = 0
            if len == 1 then
                if wid == 1 then
                    angel = 180
                    type = SurfaceUtil.SURFACE_TYPE_ARRIS
                elseif wid == surfaceWide then
                    angel = 270
                    type = SurfaceUtil.SURFACE_TYPE_ARRIS
                else
                    angel = 0
                    type = SurfaceUtil.SURFACE_TYPE_SIDEWALK
                end
            elseif len == surfaceLength then
                if wid == 1 then
                    angel = 90
                    type = SurfaceUtil.SURFACE_TYPE_ARRIS
                elseif wid == surfaceWide then
                    angel = 0
                    type = SurfaceUtil.SURFACE_TYPE_ARRIS
                else
                    angel = 180
                    type = SurfaceUtil.SURFACE_TYPE_SIDEWALK
                end
            elseif wid == 1 and len ~= 1 and len ~= surfaceLength then
                angel = 270
                type = SurfaceUtil.SURFACE_TYPE_SIDEWALK
            elseif wid == surfaceWide and len ~= 1 and len ~= surfaceLength then
                angel = 90
                type = SurfaceUtil.SURFACE_TYPE_SIDEWALK
            else
                angel = 0
                type = SurfaceUtil.SURFACE_TYPE_FLOOR
            end
            if extension == 0 then
                ResMgr:LoadGameObjectAsync("surface", function(obj)
                    obj.transform:SetParent(tran, false)

                    local data = SurfaceUtil.addSurfaceData(obj, keyX, keyZ, type, angel, posX, posZ, localPosX,
                        localPosZ, id, isReset)
                    surfaceData[data.key] = data

                    if len == surfaceLength and wid == surfaceWide then
                        local index = 0
                        for k, v in pairs(surfaceData) do
                            index = index + 1
                        end
                        if callback then
                            callback(surfaceData)
                        end
                        gg.buildingManager:initSurface(isNewBuilding, false)
                    end
                    return true
                end, true)
            else
                local obj = nil
                local data = SurfaceUtil.addSurfaceData(obj, keyX, keyZ, type, angel, posX, posZ, localPosX, localPosZ,
                    id, isReset)
                surfaceData[data.key] = data

                if len == surfaceLength and wid == surfaceWide then
                    local index = 0
                    for k, v in pairs(surfaceData) do
                        index = index + 1
                    end
                    if callback then
                        callback(surfaceData)
                    end
                    gg.buildingManager:initSurface(isNewBuilding, true)
                end
            end
        end
    end
end

function SurfaceUtil.addSurfaceData(obj, keyX, keyZ, type, angel, posX, posZ, localPosX, localPosZ, id, isReset,
    isOutSide)
    if posX then
        if obj then
            obj.transform.position = Vector3(posX, 0, posZ)
        end
    end
    local key = SurfaceUtil.getSurfaceKey(keyX, keyZ)
    local data = {
        obj = obj, -- ""
        keyX = keyX, -- ""X
        keyZ = keyZ, -- ""Y
        localPosX = localPosX, -- ""X
        localPosZ = localPosZ, -- ""Y
        type = type, -- ""
        curType = type, -- ""
        subType = 1, -- "" 1-5
        angel = angel, -- ""
        curAngel = angel, -- ""
        key = key, -- ""
        posX = posX, -- ""X
        posZ = posZ -- ""Z
    }
    SurfaceUtil.setSurfaveType(data, obj, type, angel, isReset, isOutSide)
    gg.buildingManager:addSurfaceData(key, data, id)
    return data
end

function SurfaceUtil.setSurfaveType(data, obj, type, angle, isReset, isOutSide)
    if obj then
        if isOutSide then
            local posX = obj.transform.position.x
            local posZ = obj.transform.position.z

            if posX < 6 or posX > 52 or posZ < 6 or posZ > 52 then
                type = SurfaceUtil.SURFACE_TYPE_OUTSIDE
            end
        end

        local childCount = obj.transform.childCount - 1
        if type ~= SurfaceUtil.SURFACE_TYPE_NONE and type ~= SurfaceUtil.SURFACE_TYPE_OUTSIDE then
            obj.gameObject:SetActive(true)
            for i = 0, childCount do
                obj.transform:GetChild(i).gameObject:SetActive(false)
            end
            obj.transform:Find(type).gameObject:SetActive(true)

            local ang = angle or 0
            obj.transform.localRotation = Quaternion.Euler(0, ang, 0)
        else
            obj.gameObject:SetActive(false)
        end
        if isReset then
            obj.transform.localPosition = Vector3(data.localPosX, 0, data.localPosZ)
            if data.type == SurfaceUtil.SURFACE_TYPE_SIDEWALK then
                SurfaceUtil.setSidewalkType(data, 1)
            end
        end
        obj.name = type .. data.key
    else
        local posX = data.posX
        local posZ = data.posZ

        if posX < 6 or posX > 52 or posZ < 6 or posZ > 52 then
            type = SurfaceUtil.SURFACE_TYPE_OUTSIDE
        end

    end
    data.curType = type
    data.subType = 1
    data.curAngel = angle or data.curAngel
    -- SurfaceUtil.setObjStatic(obj, not isReset)
end

function SurfaceUtil.setObjStatic(obj, isStatic)
    if obj then
        obj.isStatic = isStatic
        obj.transform:Find(SurfaceUtil.SURFACE_TYPE_ARRIS).gameObject.isStatic = isStatic
        obj.transform:Find(SurfaceUtil.SURFACE_TYPE_FLOOR).gameObject.isStatic = isStatic
        obj.transform:Find(SurfaceUtil.SURFACE_TYPE_INSIDE).gameObject.isStatic = isStatic
        local sidewalk = obj.transform:Find(SurfaceUtil.SURFACE_TYPE_SIDEWALK)
        sidewalk.gameObject.isStatic = isStatic
        for i = 1, 5 do
            sidewalk.transform:Find("s" .. tostring(i)).gameObject.isStatic = isStatic
        end

    end
end

function SurfaceUtil.setSidewalkType(data, type)
    data.subType = type
    if data.obj then
        local sidewalk = data.obj.transform:Find(SurfaceUtil.SURFACE_TYPE_SIDEWALK)
        for i = 1, 5 do
            sidewalk.transform:Find("s" .. tostring(i)).gameObject:SetActive(false)
        end
        sidewalk.transform:Find("s" .. tostring(type)).gameObject:SetActive(true)
    end

end

function SurfaceUtil.startSurface(length, width, pos, id, type, subType, count, extension)
    gg.buildingManager.buildCount = count
    local vec = Vector3(pos[0], pos[1], pos[2])
    local contenPos = Vector3(pos[0] + length / 2, 0, pos[2] + length / 2)
    local tran = gg.sceneManager.terrain.transform:Find("Surfaces").transform
    local data = {
        length = length,
        width = width,
        type = type,
        pos = pos,
        id = id,
        subType = subType
    }
    local view = {
        contenPos = contenPos,
        length = length
    }
    SurfaceUtil.makeSurface(data, vec, tran, id, false, function(temp)
        gg.buildingManager.otherBuilding[id] = {
            surfaceData = temp,
            buildCfg = data,
            view = view,
            destroy = function()
                
            end
        }
    end, false, extension)
end

function SurfaceUtil.endSueface()
    for k, v in pairs(gg.buildingManager.otherBuilding) do
        for l, d in pairs(v.surfaceData) do
            if d.obj then
                ResMgr:ReleaseAsset(d.obj)
            end
        end
    end
    gg.buildingManager.otherBuilding = {}
    gg.buildingManager.otherSurfaceData = {}
    gg.buildingManager:destroyBanArea()
end
