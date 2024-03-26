DraftData = {}

DraftData.reserveArmys = {}
DraftData.curBuildId = 0
-- ""
function DraftData.C2S_Player_GetReserveArmy(id)
    DraftData.curBuildId = id
    gg.client.gameServer:send("C2S_Player_GetReserveArmy", {id = id})
end

-- ""
function DraftData.C2S_Player_ReserveArmyTrain(id, soliderCfgId, soliderCount)
    gg.client.gameServer:send("C2S_Player_ReserveArmyTrain", {
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount
    })
end

-- ""
function DraftData.C2S_Player_SpeedupReserveArmy(id, soliderCfgId, soliderCount)
    gg.client.gameServer:send("C2S_Player_SpeedupReserveArmy", {
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount,
    })
end

-- message ReserveArmy {
--     int64 buildId = 1;                  // ""id
--     int32 trainCfgId = 2;          // ""id
--     int32 trainCount = 3;          // ""
--     int32 trainTick = 4;           // ""
--     int32 count = 5;               // ""
-- }

-- ""
function DraftData.S2C_Player_ReserveArmyUpdate(args)
    local op_type = args.op_type -- "" 1"",2"",3""
    local armys = args.armys -- ""

    DraftData.reserveArmys = {}

    for k, v in pairs(armys) do
        DraftData.reserveArmys[v.buildId] = v
        -- DraftData.reserveArmys[v.buildId].trainTick = v.trainTick + os.time()
    end

    gg.event:dispatchEvent("onSetPnlDraftView")

end

return DraftData
