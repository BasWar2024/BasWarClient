DrawCardData = {}
DrawCardData.cardPoolData = {}
DrawCardData.discount = 1
function DrawCardData.C2S_Player_Draw_Card(cfgId, drawCount)
    gg.client.gameServer:send("C2S_Player_Draw_Card", {
        cfgId = cfgId,
        drawCount = drawCount
    })
    gg.uiManager:onOpenPnlLink("C2S_Player_Draw_Card", true)
end

function DrawCardData.C2S_Player_GetDrawCardRecord()
    gg.client.gameServer:send("C2S_Player_GetDrawCardRecord", {})
end

function DrawCardData.S2C_Player_DrawCardData(args)
    local op_type = args.op_type
    local cardData = args.cardData
    local discount = math.floor(args.discount * 100)
    DrawCardData.discount = discount / 100

    local nowTime = os.time()
    if op_type == 1 then
        DrawCardData.cardPoolData = {}
        for k, v in pairs(cardData) do
            -- v.freeTimeEnd = v.freeTime + nowTime
            DrawCardData.cardPoolData[v.cfgId] = v
        end
    else
        for k, v in pairs(cardData) do
            -- v.freeTimeEnd = v.freeTime + nowTime
            DrawCardData.cardPoolData[v.cfgId] = v
        end
    end

    gg.event:dispatchEvent("onDrawCardDataChange")
end

function DrawCardData.S2C_Player_DrawCardResult(args)
    gg.uiManager:onClosePnlLink("C2S_Player_Draw_Card")
    gg.event:dispatchEvent("onShowViewResult", args)
end

function DrawCardData.S2C_Player_DrawCardRecords(args)
    local records = args.records
    local data = {}
    for i = #records, 1, -1 do
        table.insert(data, records[i])
    end

    gg.event:dispatchEvent("onLoadBoxCardRecord", data)
end

return DrawCardData
