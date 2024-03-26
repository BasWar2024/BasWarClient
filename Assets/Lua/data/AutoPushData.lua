AutoPushData = {}

AutoPushData.autoPushStatus = {} -- autoPushCfgId -> "", int int

AutoPushData.baseUrl  = ""
AutoPushData.marketUrl  = ""

function AutoPushData.clear()
    AutoPushData.autoPushStatus = {}
end

function AutoPushData.getVipUrl()
    if AutoPushData.baseUrl ~= "" and #AutoPushData.baseUrl > 2 then
        return AutoPushData.baseUrl .. "personal/VIPStrey"
    end
    return ""
end

function AutoPushData.getMarketUrl()
    if AutoPushData.marketUrl ~= "" and #AutoPushData.marketUrl > 2 then
        return AutoPushData.marketUrl
    end
    return ""
end

function AutoPushData.getInvitUrl(code)
    if AutoPushData.baseUrl ~= "" and #AutoPushData.baseUrl > 2 then
        return string.format("%siv?code=%s", AutoPushData.baseUrl, code)
    end
    return ""
end

function AutoPushData.S2C_Player_AutoPushStatus(args)
    local data = args.data or {}
    for k, v in pairs(data) do
        if v.status > 0 then
            AutoPushData.autoPushStatus[v.autoPushCfgId] = v.status
        else
            AutoPushData.autoPushStatus[v.autoPushCfgId] = nil
        end
        gg.event:dispatchEvent("onAutoPushChange", v.autoPushCfgId, v.status)
    end
end

function AutoPushData.S2C_Player_Url_Config(args)
    AutoPushData.baseUrl = args.baseUrl or ""
    AutoPushData.marketUrl = args.marketUrl or ""
end

function AutoPushData.getAutoPushStatus(autoPushCfgId)
    return AutoPushData.autoPushStatus[autoPushCfgId]
end

function AutoPushData.C2S_Player_AutoPushStatus_Del(autoPushCfgId)
    gg.client.gameServer:send("C2S_Player_AutoPushStatus_Del", {
        autoPushCfgId = autoPushCfgId
    })
end

return AutoPushData
