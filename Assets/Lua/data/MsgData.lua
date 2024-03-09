MsgData = {}

function MsgData.S2C_Msg_Error(info)
    gg.uiManager:openWindow("PnlPromptMsg", info.err)
end

function MsgData.S2C_Msg_GM(info)

end

function MsgData.S2C_Msg_Say(info)
    gg.uiManager:showTip(info.content)
end

return MsgData