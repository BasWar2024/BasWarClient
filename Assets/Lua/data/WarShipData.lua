WarShipData = {}

WarShipData.warShipData = {}
WarShipData.useData = nil

-- ""
function WarShipData.C2S_Player_WarShipLevelUp(id, speedUp)
    gg.client.gameServer:send("C2S_Player_WarShipLevelUp", {
        id = id,
        speedUp = speedUp
    })
end

-- ""
function WarShipData.C2S_Player_WarShipSkillUp(id, skillUp, speedUp)
    gg.client.gameServer:send("C2S_Player_WarShipSkillUp", {
        id = id,
        skillUp = skillUp,
        speedUp = speedUp
    })
end

--  ""
function WarShipData.C2S_Player_SetUseWarShip(id)
    gg.client.gameServer:send("C2S_Player_SetUseWarShip", {
        id = id
    })
end

-- ""
function WarShipData.C2S_Player_WarShipRepair(id)
    gg.client.gameServer:send("C2S_Player_WarShipRepair", {
        id = id
    })
end

-- ""
function WarShipData.C2S_Player_WarShipPutonSkill(id, skillIndex, itemCfgId)
    gg.client.gameServer:send("C2S_Player_WarShipPutonSkill", {
        id = id,        -- ""id
        skillIndex = skillIndex,    -- ""
        itemCfgId = itemCfgId       -- ""id
    })
end

-- ""
function WarShipData.C2S_Player_WarShipResetSkill(id, skillIndex)
    gg.client.gameServer:send("C2S_Player_WarShipResetSkill", {
        id = id, -- ""id
        skillIndex = skillIndex, -- ""
    })
end

-- ""
function WarShipData.C2S_Player_WarShipForgetSkill(id, skillIndex)
    gg.client.gameServer:send("C2S_Player_WarShipForgetSkill", {
        id = id, -- ""id
        skillIndex = skillIndex -- ""
    })
end

-- ""
function WarShipData.C2S_Player_DismantleWarShip(warShipIds)
    gg.client.gameServer:send("C2S_Player_DismantleWarShip", {
        warShipIds = warShipIds, -- ""id
    })
end

----------------------------------------S2C------------------------------------------------------

-- ""
function WarShipData.S2C_Player_WarShipData(warShipData, useId)
    WarShipData.warShipData = {}
    for _, warShip in ipairs(warShipData) do
        WarShipData.updateWarShip(warShip.id, warShip)
    end

    WarShipData.useData = WarShipData.warShipData[useId]
end

-- ""
function WarShipData.S2C_Player_WarShipAdd(warShip)
    WarShipData.refreshWarShipData(warShip.id, warShip)
end

-- ""
function WarShipData.S2C_Player_WarShipDel(id)
    WarShipData.refreshWarShipData(id, nil, true)
end

-- ""
function WarShipData.S2C_Player_WarShipUpdate(warShip)
    WarShipData.refreshWarShipData(warShip.id, warShip, true)
    gg.event:dispatchEvent("onSetViewInfo", warShip.id, warShip)
    gg.event:dispatchEvent("onUpgradeSkill", warShip)

end

-- ""
function WarShipData.S2C_Player_UseWarShipUpdate(useId)
    WarShipData.useData = {}
    WarShipData.useData = WarShipData.warShipData[useId]
    WarShipData.refreshWarShipData(useId, WarShipData.useData, true)
    gg.event:dispatchEvent("onSetSelWarship", useId)
end

-- ""
function WarShipData.refreshWarShipData(id, data, isRefresh)
    WarShipData.updateWarShip(id, data)
    if isRefresh then
        gg.event:dispatchEvent("onRefreshWarShipData", data, id, 1)
    end
end

function WarShipData.updateWarShip(id, data)
    if not data then
        WarShipData.warShipData[id] = nil
        if WarShipData.useData then
            if WarShipData.useData.id == id then
                WarShipData.useData = nil
            end
        end
        return
    end
    data.skillUpLessTickEnd = data.skillUpLessTick + os.time()
    -- data.repairLessTickEnd = data.repairLessTick + os.time()
    data.lessTickEnd = data.lessTick + os.time()
    data.repairLessTickEnd = os.time()

    WarShipData.warShipData[id] = data
    if WarShipData.useData then
        if WarShipData.useData.id == id then
            WarShipData.useData = data
        end
    end
end

return WarShipData
