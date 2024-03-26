local BuildingSolider = class("BuildingSolider")

function BuildingSolider:ctor()

end

function BuildingSolider:refreshSolider(buildingObj, buildData)
    self:ReleaseSolider()

    ResMgr:LoadGameObjectAsync("BuildingList", function(go)
        go.transform:SetParent(buildingObj.transform, false)
        go.transform.localPosition = Vector3(-1.2, 0, 9)
        go.name = string.format("Solider")
        self.soliderList = go
        local soliderCfgId = buildData.soliderCfgId
        local soliderCount = buildData.soliderCount
        if soliderCfgId ~= 0 and soliderCount > 0 then
            local level = BuildData.soliderLevelData[soliderCfgId].level
            local cfgData = cfg.getCfg("solider", soliderCfgId, level)
            local name = cfgData.showModel
            local trainSpace = cfgData.trainSpace
            local type = cfgData.type
            self.soliderTable = {}
            for i = 1, soliderCount, 1 do
                local temp = i
                ResMgr:LoadGameObjectAsync("parade_spine", function(obj)
                    obj.transform:SetParent(go.transform, false)
                    local pos = self:soliderQueue(obj, trainSpace, soliderCount, temp)

                    -- self:setSpine(obj, type)
                    self:changeSoldier(obj, name)
                    table.insert(self.soliderTable, obj)
                    return true
                end, true)
            end
        end
        return true
    end)
end

function BuildingSolider:changeSoldier(obj, name)
    local attachmentName = "bin/" .. name
    obj.transform:Find("Spine"):GetComponent("SkeletonAnimation"):ChangeSlots("bin", attachmentName)
end

-- function BuildingSolider:setSpine(obj, type)
--     if type == 1 then -- ""
--         local spine = obj.transform:Find("Spine"):GetComponent("SkeletonAnimation")
--         spine:SpineAnimPlay("idle_2", true)
--         spine.transform.localScale = Vector3(-1, 1, 1)
--         obj.transform:Find("Buff").gameObject:SetActive(false)
--         obj.transform:Find("Hp").gameObject:SetActive(false)
--         obj.transform:Find("Eff").gameObject:SetActive(false)
--     elseif type == 2 or type == 5 then -- ""
--         obj.transform.rotation = Quaternion.Euler(0, 180, 0)
--     elseif type == 4 then -- ""
--         local spine1 = obj.transform:Find("Gun/Spine"):GetComponent("SkeletonAnimation")
--         spine1:SpineAnimPlay("idle_8", true)
--         spine1.transform.localScale = Vector3(1, 1, 1)
--         local spine2 = obj.transform:Find("Body/Spine"):GetComponent("SkeletonAnimation")
--         spine2:SpineAnimPlay("idle_8", true)
--         spine2.transform.localScale = Vector3(1, 1, 1)
--         obj.transform:Find("Buff").gameObject:SetActive(false)
--         obj.transform:Find("Hp").gameObject:SetActive(false)
--         obj.transform:Find("Eff").gameObject:SetActive(false)
--     end
-- end

function BuildingSolider:soliderQueue(obj, trainSpace, total, temp)
    temp = temp - 1
    local columns = 1
    local startPosX = 2.5
    local startPosZ = 1
    local nextX = 1
    local nextZ = 1
    if total > 20 then
        columns = 5
    elseif total <= 20 and total > 15 then
        columns = 4
    elseif total <= 15 then
        columns = 3
    end
    if trainSpace == 1 then
        nextX = 0.5
        nextZ = 0.8
    elseif trainSpace == 2 then
        columns = 3
        nextX = 1
        nextZ = 1
    elseif trainSpace == 3 then
        columns = 3
        nextX = 1
        nextZ = 1
    elseif trainSpace == 4 then
        columns = 3
        nextX = 1
        nextZ = 2
    elseif trainSpace == 6 then
        columns = 3
        nextX = 1
        nextZ = 3
    end

    local row = temp / columns
    row = math.floor(row)
    local line = temp % columns
    line = line + 1
    local dis = line % 2
    if dis == 0 then
        line = -line / 2
    else
        line = line / 2
    end
    line = math.floor(line)

    local x = startPosX + nextX * line
    local z = startPosZ + nextZ * row
    if total >= 20 then
        obj.transform.localScale = Vector3(0.5, 0.5, 0.5)
    else
        obj.transform.localScale = Vector3(1, 1, 1)
    end
    obj.transform.localPosition = Vector3(x, 0, z)
end

function BuildingSolider:ReleaseSolider()
    if self.soliderTable then
        local soliderTable = {}
        soliderTable = self.soliderTable
        self.soliderTable = nil
        for k, v in pairs(soliderTable) do
            ResMgr:ReleaseAsset(v)
        end
        soliderTable = nil
    end
    if self.soliderList then
        local soliderList = {}
        soliderList = self.soliderList
        self.soliderList = nil
        ResMgr:ReleaseAsset(soliderList)
        soliderList = nil
    end
end

return BuildingSolider
