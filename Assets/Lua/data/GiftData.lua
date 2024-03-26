GiftData = {}

--""
function GiftData.C2S_Player_UseGiftCode(code)
    gg.client.gameServer:send("C2S_Player_UseGiftCode",{
        code = code,
    })
end

function GiftData.S2C_Player_UseGiftCode(args)
    local code = args.code
    local ret = args.ret
    local cfgId = args.cfgId
    local itemCfgId = args.itemCfgId

    print("ssssssss args:")
    print(table.dump(args))

    gg.event:dispatchEvent("onGetGift")
end

return GiftData