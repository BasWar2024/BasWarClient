MsgData = {}
MsgData.systemNotice = {}

function MsgData.S2C_Msg_Error(info)
    gg.uiManager:openWindow("PnlPromptMsg", info.err)
end

function MsgData.S2C_Msg_GM(info)

end

function MsgData.S2C_Msg_Say(info)
    gg.uiManager:showTip(info.content)
    if info.errcode == 526 or info.errcode == 509 then
        
    else
        gg.uiManager:onClosePnlLink("ClearAll")
    end
end

function MsgData.S2C_Player_SystemNotice(args)
    MsgData.systemNotice = args.notices
end

-- mit""
function MsgData.S2C_Player_MitNotEnoughTips(args)
    -- Utils.checkAndAlertEnoughtMit()
end

return MsgData