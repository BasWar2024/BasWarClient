MintData = {}

MintData.mintList = {}

-- // ""
function MintData.C2S_Player_GetMints()
    gg.client.gameServer:send("C2S_Player_GetMints")
end

-- // ""
function MintData.C2S_Player_AddMint(nftId1, nftId2, nftType)
    gg.client.gameServer:send("C2S_Player_AddMint", {
        nftId1 = nftId1,
        nftId2 = nftId2,
        nftType = nftType,
    })
end

-- // ""
function MintData.C2S_Player_ReceiveMintItem(index)
    gg.client.gameServer:send("C2S_Player_ReceiveMintItem", {
        index = index,
    })
end

-- // ""
function MintData.S2C_Player_MintsUpdate(args)
    if args.op_type == 0 then
        MintData.mintList = args.list
    end

    if args.op_type == 1 then
        for index, value in ipairs(args.list) do
            table.insert(MintData.mintList, value)
        end
    end

    if args.op_type == 2 then
        for i = #MintData.mintList, 1, -1 do
            if #args.list <= 0 then
                break
            end

            for j = #args.list, 1, -1 do
                if args.list[j].nftId1 == MintData.mintList[i].nftId1 then
                    table.remove(MintData.mintList, i)
                    table.remove(args.list, j)
                    break
                end
            end
        end
    end

    if args.op_type == 3 then
        for i = #MintData.mintList, 1, -1 do
            if #args.list <= 0 then
                break
            end
            for j = #args.list, 1, -1 do
                if args.list[j].nftId1 == MintData.mintList[i].nftId1 then
                    MintData.mintList[i] = args.list[j]
                    table.remove(args.list, j)
                    break
                end
            end
        end
    end

    gg.event:dispatchEvent("onMintChange", true)
end

-- //""
-- // @id=1313
-- message C2S_Player_GetStarmapScore {
-- }

-- // ""
-- // @id=11353
-- message S2C_Player_StarmapScore {
--     int32 starScore = 1;            //""
-- }

-- message C2S_Player_GetMints {
    
-- }
-- // ""
-- // @id=1365
-- message C2S_Player_AddMint {
--     int64 nftId1 = 1;                      //nft1
--     int64 nftId2 = 2;                      //nft2
-- }

-- // ""
-- // @id=1355
-- message C2S_Player_ReceiveMintItem {
--     int32 index = 1;
-- }
-- 10:54:06
-- // ""
-- // @id=11352
-- message S2C_Player_MintsUpdate {
--     int32 op_type = 1;              //"" 1"",2"",3""
--     repeated Mint list = 2;
-- }