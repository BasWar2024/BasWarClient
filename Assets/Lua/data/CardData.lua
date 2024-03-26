CardData = {}
CardData.attaCardGroupsMap = {}
CardData.defCardGroupsMap = {}
CardData.cardList = {}
CardData.useGrpIdx = {}

-- ""
function CardData.C2S_Player_setUseCardGroup(cgType, index)
    gg.client.gameServer:send("C2S_Player_setUseCardGroup", {
        cgType = cgType,
        index = index,
    })
end

-- ""
function CardData.C2S_Player_setCardGroup(cgType, index, cardIds, gname)
    gg.client.gameServer:send("C2S_Player_setCardGroup", {
        cgType = cgType,
        index = index,
        cardIds = cardIds,
        gname = gname,
    })
end

-- ""
function CardData.C2S_Player_renameCardGroup(cgType, index, gname)
    gg.client.gameServer:send("C2S_Player_renameCardGroup", {
        cgType = cgType,
        index = index,
        gname = gname,
    })
end

-- ""
function CardData.C2S_Player_delCardGroup(cgType, index)
    gg.client.gameServer:send("C2S_Player_delCardGroup", {
        cgType = cgType,
        index = index,
    })
end

-- ""
function CardData.C2S_Player_drawCard(dType)
    gg.client.gameServer:send("C2S_Player_drawCard", {
        dType = dType,
    })
end
-----------------------------------
-- ""
function CardData.S2C_Player_CardUpdate(args)
    for key, value in pairs(args.attaCardGroups) do
        CardData.attaCardGroupsMap[value.index] = value
    end

    for key, value in pairs(args.defCardGroups) do
        CardData.defCardGroupsMap[value.index] = value
    end

    for key, value in pairs(args.cards) do
        table.insert(CardData.cardList, value)
    end

    if next(args.useGrpIdx) then
        CardData.useGrpIdx = args.useGrpIdx
    end

    gg.event:dispatchEvent("onCardUpdate")
end

-- ""
function CardData.S2C_Player_drawCardResult(args)
    gg.uiManager:openWindow("PnlDrawCardResult", args)
end
