ResData = {}

ResData.resources = {}
ResData.bindResources = {}
ResData.unBindResources = {}

ResData.exchangeData = {}

function ResData.getRes(resCfgId)
    return ResData.resources[resCfgId] or 0
end

ResData.TIP_TYPE_INFO_ONLY = 0

ResData.TIP_TYPE_EXCHANGE_CARBOXYL = 1
ResData.TIP_TYPE_EXCHANGE_TESSERACT = 2

ResData.TIP_TYPE_QUICK_EXCHANGE = 3

--""
function ResData.C2S_Player_Exchange_Rate(tipType)
    gg.client.gameServer:send("C2S_Player_Exchange_Rate", {
        tipType = tipType,
    })
end

--""
--resList = {{resCfgId = , mit = ,carboxyl =},}
function ResData.C2S_Player_Exchange_Res(from, fromCount, to)
    gg.client.gameServer:send("C2S_Player_Exchange_Res",{
        from = from,
        fromCount = fromCount,
        to = to,
    })
end

function ResData.S2C_Player_ResData(resData)
    ResData.resources = {}
    for k, v in pairs(resData) do
        if v.bind then
            ResData.bindResources[v.resCfgId] = v.count
        else
            ResData.unBindResources[v.resCfgId] = v.count
        end
        ResData.resources[v.resCfgId] = ResData.resources[v.resCfgId] or 0
        ResData.resources[v.resCfgId] = ResData.resources[v.resCfgId] + v.count
    end
end

-- ""id,1"",2"",3""，4""
function ResData.S2C_Player_ResAnimation(args)
    if args.animationId == 1 then
        -- gg.event:dispatchEvent("onResAnimation", args)
        -- gg.event:dispatchEvent("onPlayResAnimation", args.resCfgId, args.change)
    elseif args.animationId == 2 or args.animationId == 3 then
        gg.event:dispatchEvent("onPlayTaskResAnimation", args)
    elseif args.animationId == 4 then
        gg.event:dispatchEvent("onPlayDailyActivationAnimation", args)

    else
        gg.event:dispatchEvent("onResAnimation", args)
        gg.buildingManager:buildGetResMsg(args)
    end
end

function ResData.S2C_Player_ResChange(resCfgId, count, change, isBind)
    if isBind then
        ResData.bindResources[resCfgId] = count
    else
        ResData.unBindResources[resCfgId] = count
    end
    ResData.bindResources[resCfgId] = ResData.bindResources[resCfgId] or 0
    ResData.unBindResources[resCfgId] = ResData.unBindResources[resCfgId] or 0

    local totalRes = ResData.bindResources[resCfgId] + ResData.unBindResources[resCfgId]
    ResData.resources[resCfgId] = ResData.resources[resCfgId] or 0
    change = totalRes - ResData.resources[resCfgId]
    ResData.resources[resCfgId] = totalRes

    gg.event:dispatchEvent("onRefreshResTxt", resCfgId, totalRes, change)
    gg.event:dispatchEvent("onSetTopRes")

    --change >0--"",<=0--""
end

ResData.TIP_TYPE_EXCHANGE_CARBOXYL = 1
ResData.TIP_TYPE_EXCHANGE_TESSERACT = 2

function ResData.S2C_Player_Exchange_Rate(args)
    for key, value in pairs(args.rates) do
        ResData.exchangeData[value.from] = value.to
        for k,v in pairs(value.to) do
            if tonumber(v) then
                value.to[k] = tonumber(v)
            else
                value.to[k] = 0
            end
        end
    end
    
    gg.event:dispatchEvent("onExchangeRateChange")
end

--MIT
function ResData.getMit()
    return ResData.getRes(constant.RES_MIT)
end

--""
function ResData.getStarCoin()
    return ResData.getRes(constant.RES_STARCOIN)
end

--""
function ResData.getIce()
    return ResData.getRes(constant.RES_ICE)
end

--""
function ResData.getCarboxyl()
    return ResData.getRes(constant.RES_CARBOXYL)
end

--""
function ResData.getTitanium()
    return ResData.getRes(constant.RES_TITANIUM)
end

--""
function ResData.getGas()
    return ResData.getRes(constant.RES_GAS)
end

--""
function ResData.getTesseract()
    return ResData.getRes(constant.RES_TESSERACT)
end

--""
function ResData.getBadge()
    return ResData.getRes(constant.RES_BADGE)
end

return ResData