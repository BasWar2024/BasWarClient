ChatData = {}

ChatData.chatMsgMap = {}           --""
ChatData.chatMsgIdMap = {}         --""Id
ChatData.channelCdMap = {}

-- ChatData.isShowSendAlert = true


ChatData.CHANNEL2CD = {
    [constant.CHAT_TYPE_WORLD] = 30
}
----------------------------------
function ChatData.GetChannelMsgId(channelType)
    return ChatData.chatMsgIdMap[channelType] or 0
end

function ChatData.GetChannelMsgs(channelType)
    return ChatData.chatMsgMap[channelType] or {}
end

--""
function ChatData.C2S_Player_SendChatMsg(text, channelType, hasHyperLink)

    ChatData.channelCdMap[channelType] = ChatData.channelCdMap[channelType] or {}
    ChatData.channelCdMap[channelType].cdLessEnd = ChatData.channelCdMap[channelType].cdLessEnd or 0
    local channelCdInfo = ChatData.channelCdMap[channelType]
    local nowTime = os.time()

    if channelCdInfo.cdLessEnd <= nowTime then
        gg.client.gameServer:send("C2S_Player_SendChatMsg", {
            channelType = channelType,
            text = text,
            hasHyperLink = hasHyperLink
        })

        if ChatData.CHANNEL2CD[channelType] and ChatData.CHANNEL2CD[channelType] > 0 then
            channelCdInfo.cdLessEnd = ChatData.CHANNEL2CD[channelType] + nowTime
        end

        return true
    else
        gg.uiManager:showTip(string.format(Utils.getText("chat_CD"), channelCdInfo.cdLessEnd - nowTime))
    end
end

--""
function ChatData.C2S_Player_QueryChatMsgs(channelType)
    gg.client.gameServer:send("C2S_Player_QueryChatMsgs", {
        channelType = channelType,
        cMsgId = ChatData.GetChannelMsgId(channelType),
    })
end
------------------------------------------------

--""
function ChatData.S2C_Player_ChatMsgs(args)
    local channelType = args.channelType
    local sMsgId = args.sMsgId
    local msgs = args.msgs

    if next(msgs) then
        ChatData.chatMsgIdMap[channelType] = sMsgId
        local curMsgs = ChatData.GetChannelMsgs(channelType)
        for k, v in pairs(msgs) do
            table.insert(curMsgs, v)
        end
        ChatData.chatMsgMap[channelType] = curMsgs
        for index, value in ipairs(curMsgs) do
            PlayerData.setPlayerHeadIcon(value.playerId, value.headIcon)
        end
    end
    gg.event:dispatchEvent("onChatChange", channelType)
end

---------------------------------------------------

function ChatData.clearChannel(channel)
    ChatData.chatMsgIdMap[channel] = 0
    ChatData.chatMsgMap[channel] = {}
    gg.event:dispatchEvent("onChatChange", channel)
end

function ChatData.filterChatData(msgs)

end
