local net = {}
local infoText=""

function net.S2C_Msg_GM(args)
    local content = args.content
    local window = gg.uiManager:getWindow("PnlGMTool")
    --logger.print("[gm]",content)
    infoText=infoText..content   
    if window then
        window:receiveInfo(infoText)       
        infoText =""
    end    
end

function net.S2C_Msg_Error(args)
    MsgData.S2C_Msg_Error(args)
end

function net.S2C_Msg_Say(args)
    MsgData.S2C_Msg_Say(args)
end

return net