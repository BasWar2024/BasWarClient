ResData = {}

ResData.resources = {}

function ResData.getRes(resCfgId)
    return ResData.resources[resCfgId] or 0
end

--
function ResData.C2S_Player_Exchange_Rate()
    gg.client.gameServer:send("C2S_Player_Exchange_Rate")
end

--
function ResData.C2S_Player_Exchange_Res(mit, cfgId)
    gg.client.gameServer:send("C2S_Player_Exchange_Res",{
        mit = mit,
        cfgId = cfgId,
    })
end

function ResData.S2C_Player_ResData(resData)
    ResData.resources = {}
    for k, v in pairs(resData) do
        ResData.resources[v.resCfgId] = v.count
    end
end

function ResData.S2C_Player_ResChange(resCfgId, count, change)
    ResData.resources[resCfgId] = count
    gg.event:dispatchEvent("onRefreshResTxt", resCfgId, count)
    --change >0--,<=0--
end

function ResData.S2C_Player_Exchange_Rate(args)
    gg.uiManager:openWindow("PnlExchange", args)
end

--MIT
function ResData.getMit()
    return ResData.getRes(constant.RES_MIT)
end

--
function ResData.getStarCoin()
    return ResData.getRes(constant.RES_STARCOIN)
end

--
function ResData.getIce()
    return ResData.getRes(constant.RES_ICE)
end

--
function ResData.getCarboxyl()
    return ResData.getRes(constant.RES_CARBOXYL)
end

--
function ResData.getTitanium()
    return ResData.getRes(constant.RES_TITANIUM)
end

--
function ResData.getGas()
    return ResData.getRes(constant.RES_GAS)
end

--
function ResData.getBadge()
    return ResData.getRes(constant.RES_BADGE)
end

return ResData