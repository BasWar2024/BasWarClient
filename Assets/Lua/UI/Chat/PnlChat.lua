

PnlChat = class("PnlChat", ggclass.UIBase)

PnlChat.openTweenType = false
PnlChat.closeType = ggclass.UIBase.CLOSE_TYPE_BG
PnlChat.layer = UILayer.information

function PnlChat:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.events = {"onChatChange", "onUpdateUnionData", "onAutoPushChange", "onRedPointChange"}
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN

    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_LEFT_2_RIGHT

    self.needBlurBG = true
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlChat:onAwake()
    self.view = ggclass.PnlChatView.new(self.pnlTransform)
    self.channelScrollView = UIScrollView.new(self.view.channelScrollView, "BtnSelectChannel")
    self.channelScrollView:setRenderHandler(gg.bind(self.onRenderChannel, self))
    self.channelScrollView:setRenderFinishCallback(gg.bind(self.onRenderChannelBtnsFinish, self))
end

function PnlChat:onShow()
    self:bindEvent()
    self:initChannels()
end

function PnlChat:refreshMsg(channel)
    local channelInfo = self.channelInfoMap[channel]
    if not channelInfo then
        return
    end

    local dataCount = #ChatData.GetChannelMsgs(channel)

    channelInfo.scrollView:setDataCount(dataCount)
    channelInfo.scrollView.component:Jump2DataIndex(dataCount)
end

function PnlChat:onChatChange(event, channel)
    if channel == self.showingChannel then
        self:refreshMsg(channel)
    end
end

function PnlChat:onAutoPushChange(_, autoPushType, status)
    if status > 0 then
        if autoPushType == constant.AUTOPUSH_CFGID_CAHT_UNION_NEW and self.showingChannel == constant.CHAT_TYPE_UNION then
            ChatData.C2S_Player_QueryChatMsgs(constant.CHAT_TYPE_UNION)
        elseif autoPushType == constant.AUTOPUSH_CFGID_CAHT_WORLD_NEW and self.showingChannel == constant.CHAT_TYPE_WORLD then
            ChatData.C2S_Player_QueryChatMsgs(constant.CHAT_TYPE_WORLD)
        end
    end
end

function PnlChat:onUpdateUnionData()
    self:initChannels()
end

--channelInfo = {channel, isOpen, scrollView, scrollViewItemList}
function PnlChat:initChannels()

    local view = self.view
    self.showingChannel = constant.CHAT_TYPE_WORLD

    if UnionData.unionData and UnionData.unionData.unionId > 0 then
        self.channelDatas = {
            {name = "chat_World", channel = constant.CHAT_TYPE_WORLD, isOpen = true},
            {name = "chat_Union", channel = constant.CHAT_TYPE_UNION, isOpen = true},
        }
    else
        self.channelDatas = {
            {name = "chat_World", channel = constant.CHAT_TYPE_WORLD, isOpen = true},
            {name = "chat_Union", channel = constant.CHAT_TYPE_UNION, isOpen = false},
        }
    end

    self.channelInfoMap = self.channelInfoMap or {}
    for key, value in pairs(self.channelInfoMap) do
        value.isOpen = false
        value.scrollView.transform:SetActiveEx(false)
    end


    for index, value in ipairs(self.channelDatas) do
        self.channelInfoMap[value.channel] = self.channelInfoMap[value.channel] or {}
        local info = self.channelInfoMap[value.channel]
        info.isOpen = value.isOpen
        if not info.scrollView then
            info.scrollViewItemList = {}
            info.scrollView = UILoopScrollView.new(UnityEngine.GameObject.Instantiate(view.scrollView, view.layoutScrollView, false),
                info.scrollViewItemList)
            info.scrollView:setRenderHandler(gg.bind(self.onRenderChatItem, self, value.channel))
            info.scrollView:setRenderSizeHandler(gg.bind(self.onRenderChatItemSize, self, value.channel))
        end
    end

    self.btnChannelMap = self.btnChannelMap or {}
    self.channelScrollView:setItemCount(#self.channelDatas)
end

-- function PnlChat:refreshAllChannelRedPoint()
--     for key, value in pairs(constant.CHAT_CHANNEL_INFO) do
--         self:refreshSubChannelRedPoint(key)
--     end
-- end

function PnlChat:refreshSubChannelRedPoint(channel)
    local btn = self.btnChannelMap[channel]
    if not btn then
        return
    end
    local chatInfo = constant.CHAT_CHANNEL_INFO[channel]

    if channel == self.showingChannel then
        RedPointManager:setRedPoint(btn.obj, false)
    else
        RedPointManager:setRedPoint(btn.obj, RedPointManager:getIsRed(chatInfo.redPointKey))
    end
end

function PnlChat:onRedPointChange(_, name, isRed)
    if name == RedPointChatWorld.__name then
        self:refreshSubChannelRedPoint(constant.CHAT_TYPE_WORLD)
    elseif name == RedPointChatUnion.__name then
        self:refreshSubChannelRedPoint(constant.CHAT_TYPE_UNION)
    end
end

function PnlChat:onBtnChannel(channel, isForce)
    if not self.channelScrollView.isRenderFinish then
        return
    end

    if not self.channelInfoMap[channel].isOpen then
        gg.uiManager:showTip("channel not open")
        return
    end

    if self.showingChannel == channel and not isForce then
        return
    end

    self.showingChannel = channel
    for key, value in pairs(self.channelInfoMap) do
        if channel == key then
            value.scrollView.transform:SetActiveEx(true)
        else
            value.scrollView.transform:SetActiveEx(false)
        end
    end

    for key, value in pairs(self.btnChannelMap) do
        if channel == key then
            -- gg.setSpriteAsync(value.image, "button_select_green")
            value.imgSelect.transform:SetActiveEx(true)
            value.text.transform:SetActiveEx(false)
        else
            value.imgSelect.transform:SetActiveEx(false)
            value.text.transform:SetActiveEx(true)
            -- gg.setSpriteAsync(value.image, "button_select_gray")
        end
    end

    if ChatData.GetChannelMsgId(channel) == 0 or AutoPushData.autoPushStatus[constant.CHAT_CHANNEL_INFO[channel].autoPushKey] then
        ChatData.C2S_Player_QueryChatMsgs(channel)
    else
        self:refreshMsg(channel)
    end

    -- self:refreshMsg(channel)
end

function PnlChat:onRenderChannel(obj, index)
    CS.UIEventHandler.Clear(obj)

    local data = self.channelDatas[index]
    self.btnChannelMap[data.channel] = {}
    self.btnChannelMap[data.channel].obj = obj
    self.btnChannelMap[data.channel].text = obj.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.btnChannelMap[data.channel].image = obj.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnChannelMap[data.channel].imgSelect = obj.transform:Find("ImgSelect"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnChannelMap[data.channel].txtSelect = obj.transform:Find("ImgSelect/TxtSelect"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnChannelMap[data.channel].text.text = Utils.getText(data.name)
    self.btnChannelMap[data.channel].txtSelect.text = Utils.getText(data.name)

    if data.isOpen then
        self.btnChannelMap[data.channel].text.color = UnityEngine.Color(0x3d/0xff, 0x97/0xff, 0xfe/0xff, 1)
    else
        self.btnChannelMap[data.channel].text.color = UnityEngine.Color(0x7c/0xff, 0x8f/0xff, 0xa4/0xff, 1)
    end
    self:refreshSubChannelRedPoint(data.channel)
    self:setOnClick(obj.gameObject, gg.bind(self.onBtnChannel, self, data.channel, false), true)
end

function PnlChat:onRenderChannelBtnsFinish()
    self:onBtnChannel(self.showingChannel, true)
end

function PnlChat:onHide()
    self:releaseEvent()
end

function PnlChat:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnSend):SetOnClick(function()
        self:onBtnSend()
    end)
    CS.UIEventHandler.Get(view.btnPlus):SetOnClick(function()
        self:onBtnPlus()
    end)
    self:setOnClick(view.btnClose, gg.bind(self.close, self))

    view.inputChat.onValueChanged:AddListener(gg.bind(self.onInputChat, self))
end

function PnlChat:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnSend)
    CS.UIEventHandler.Clear(view.btnPlus)
    view.inputChat.onEndEdit:RemoveAllListeners()
end

function PnlChat:onDestroy()
    local view = self.view
    -- self.scrollView:release()
    view.chatItem:release()
    for key, value in pairs(self.channelInfoMap) do
        if value.scrollView then
            value.scrollView:release()
        end
    end
    self.channelInfoMap = {}

    for key, value in pairs(self.btnChannelMap) do
        RedPointManager:releaseRedPoint(value.obj)
    end
end

function PnlChat:onBtnSend()
    local view = self.view
    local text = string.trim(view.inputChat.text)
    -- local isSucceedSend = false

    if text == "" then
        gg.uiManager:showTip(Utils.getText("chat_Empty"))
        return
    end

    if self.showingChannel == constant.CHAT_TYPE_WORLD then
        local baseLevel = gg.buildingManager:getBaseLevel()
        if baseLevel < cfg.global.WorldChatMinBaseLevel.intValue then
            gg.uiManager:showTip(string.format(Utils.getText("chat_BaseNeed"), cfg.global.WorldChatMinBaseLevel.intValue) )
            
            return
        end
    end

    local isExistSensitiveWord, matchWord = FilterWords.isExistSensitiveWord(view.inputChat.text)
    if isExistSensitiveWord then
        gg.uiManager:showTip(string.format(Utils.getText("universal_InvalidWord"), matchWord))
        -- gg.uiManager:showTip(Utils.getText("chat_Sensitive"))
        return
    end

    -- if self.showingChannel == constant.CHAT_TYPE_WORLD and ChatData.isShowSendAlert then
    --     local callbackYes = function (isOn)
    --         if isOn then
    --             ChatData.isShowSendAlert = false
    --         end
    --         if ChatData.C2S_Player_SendChatMsg(text, self.showingChannel) then
    --             self.view.inputChat.text = ""
    --         end
    --     end
    --     local txt = string.format("Confirm to use %s MIT to send this information?", cfg.global.WorldChatNeedMit.intValue)
    --     local toggleText = "don’t remind me again today"
    --     gg.uiManager:openWindow("PnlAlert", {callbackYes = callbackYes, txt = txt, 
    --         toggleText = toggleText, toggleIsOn = false, title = "Send information"})
    -- else
    --     if ChatData.C2S_Player_SendChatMsg(text, self.showingChannel) then
    --         self.view.inputChat.text = ""
    --     end
    -- end

    if ChatData.C2S_Player_SendChatMsg(text, self.showingChannel) then
        self.view.inputChat.text = ""
    end
end

function PnlChat:onBtnPlus()
end

function PnlChat:onRenderChatItem(channel, obj, index)
    local data = ChatData.GetChannelMsgs(channel)[index]
    local info = self.channelInfoMap[channel]
    local item = ChatItem:getItem(obj, info.scrollViewItemList, self)
    item:setData(data, index)
end

function PnlChat:onRenderChatItemSize(channel, index)
    local data = ChatData.GetChannelMsgs(channel)[index]

    local type = ggclass.ChatItem.MESSAGE_TYPE_CHAT
    if data.playerId == 0 then
        type = ggclass.ChatItem.MESSAGE_TYPE_SYSTEM
    end
    return self.view.chatItem:calItemSize2(data.text, type)
end

local maxCount = 66
function PnlChat:onInputChat(text)
    local view = self.view
    local wordsCount = string.utf8len(text)

    if wordsCount > maxCount then
        text = string.utf8sub(text, 0, maxCount)
        view.inputChat.text = text
        return
    end
end

return PnlChat