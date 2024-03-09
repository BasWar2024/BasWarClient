WarShipData = {}

WarShipData.warShipData = {}

--
function WarShipData.C2S_Player_WarShipLevelUp(id,speedUp)
    gg.client.gameServer:send("C2S_Player_WarShipLevelUp",{
        id = id,
        speedUp = speedUp,
    })
end

--
function WarShipData.C2S_Player_SpeedUp_WarShipLevelUp(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_WarShipLevelUp",{
        id = id,
    })
end

--
function WarShipData.C2S_Player_WarShipSkillUp(id, skillUp, speedUp)
    gg.client.gameServer:send("C2S_Player_WarShipSkillUp",{
        id = id,
        skillUp = skillUp,
        speedUp = speedUp,
    })
end

--
function WarShipData.C2S_Player_SpeedUp_WarShipSkillUp(id)
    gg.client.gameServer:send("C2S_Player_SpeedUp_WarShipSkillUp",{
        id = id,
    })
end

function WarShipData.S2C_Player_WarShipData(warShipData)
    WarShipData.warShipData = {}
    for _, warShip in ipairs(warShipData) do
        WarShipData.updateWarShip(warShip.id, warShip)
    end
end

function WarShipData.S2C_Player_WarShipAdd(warShip)
    WarShipData.refreshWarShipData(warShip.id, warShip)
end

function WarShipData.S2C_Player_WarShipDel(id)
    WarShipData.refreshWarShipData(id, nil)
end

function WarShipData.S2C_Player_WarShipUpdate(warShip)
    WarShipData.refreshWarShipData(warShip.id, warShip)
end

function WarShipData.refreshWarShipData(id, data)
    WarShipData.updateWarShip(id, data)
    gg.event:dispatchEvent("onRefreshWarShipData", data)
end

function WarShipData.updateWarShip(id, data)
    if not data then
        WarShipData.warShipData[id] = nil
        return
    end
    data.skillUpLessTickEnd = data.skillUpLessTick + os.time()
    data.lessTickEnd = data.lessTick + os.time()
    WarShipData.warShipData[id] = data
end

return WarShipData