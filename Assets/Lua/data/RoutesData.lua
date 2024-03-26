RoutesData = {}
RoutesData.routesData = {}

--""
function RoutesData.C2S_Player_AirwaySetWarShip(cfgId, warShipId)
    gg.client.gameServer:send("C2S_Player_AirwaySetWarShip", {
        cfgId = cfgId,
        warShipId = warShipId
    })
end

--""
function RoutesData.C2S_Player_AirwayAddFreight(cfgId, freight)
    gg.client.gameServer:send("C2S_Player_AirwayAddFreight", {
        cfgId = cfgId,
        warShipId = freight
    })
end

--""
function RoutesData.C2S_Player_AirwaySetOut(cfgId, warShipId, currencies, freights)
    gg.client.gameServer:send("C2S_Player_AirwaySetOut", {
        cfgId = cfgId,
        warShipId = warShipId,
        currencies = currencies, 
        freights = freights
    })
end

--""
function RoutesData.C2S_Player_AirwayClickFinish(cfgId)
    gg.client.gameServer:send("C2S_Player_AirwayClickFinish", {
        cfgId = cfgId
    })
end

--""
function  RoutesData.S2C_Player_AirwayData(airways)
    RoutesData.routesData = {}
    for k, v in pairs(airways) do
        RoutesData.routesData[v.cfgId] = v
    end
    gg.event:dispatchEvent("onShowTradingRouteView")
end

--""
function RoutesData.S2C_Player_AirwayUpdate(airway)
    RoutesData.routesData[airway.cfgId] = airway
    gg.event:dispatchEvent("onShowTradingRouteView")
end

return RoutesData