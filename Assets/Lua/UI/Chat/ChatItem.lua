ChatItem = ChatItem or class("ChatItem", ggclass.UIBaseItem)

function ChatItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ChatItem:onInit()
    self.txtTime = self:Find("TxtTime", "Text")

    self.layoutChat = self:Find("LayoutChat")
    self.bg = self:Find("Bg")
    self.bgHead = self:Find("LayoutChat/BgHead", "Image")
    self.imgHead = self:Find("LayoutChat/BgHead/MaskHead/ImgHead", "Image")
    self.txtName = self:Find("LayoutChat/TxtName", "Text")
    self.bgText = self:Find("LayoutChat/BgText")
    self.txtChat = self:Find("LayoutChat/TxtChat", "Text")
    self.tmpChat = self:Find("LayoutChat/TmpChat", typeof(CS.TMPro.TextMeshProUGUI))

    self:setOnClick(self.txtChat.gameObject, gg.bind(self.onClickTxtChat, self))
    -- self.txtChat = self:Find("LayoutChat/TxtChat", "Text")
    -- TxtChat

    self.imgVip = self:Find("LayoutChat/ImgVip", "Image")
    self.txtJob = self:Find("LayoutChat/TxtJob", "Text")
    self.txtChatTime = self:Find("LayoutChat/TxtChatTime", "Text")
    self:setOnClick(self.imgHead.gameObject, gg.bind(self.onBtnHead, self))
    self:setOnClick(self.imgVip.gameObject, gg.bind(self.onBtnVip, self))

    self.layoutSystem = self:Find("LayoutSystem")
    self.txtSystem = self:Find("LayoutSystem/TxtSystem", "Text")
    self:setOnClick(self.txtSystem.gameObject, gg.bind(self.onClickTxtChat, self))
    self.setDataCount = 0
    self.txtSystemTime = self:Find("LayoutSystem/TxtSystemTime", "Text")

    self.imgChain = self.txtName.transform:Find("ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE)
    -- self.isUseTmpChat = true
end

ChatItem.MESSAGE_TYPE_CHAT = 1
ChatItem.MESSAGE_TYPE_SYSTEM = 2

function ChatItem:setData(data, index)

    self.setDataCount = self.setDataCount + 1
    self.data = data

    if self.isUseTmpChat then
        self.txtChat.transform:SetActiveEx(false)
        self.tmpChat.transform:SetActiveEx(true)
    else
        self.txtChat.transform:SetActiveEx(true)
        self.tmpChat.transform:SetActiveEx(false)
    end
    self.imgVip.gameObject:SetActiveEx(false)
    self.txtTime.text = gg.time.utcDate(data.time)
    self.txtJob.text = ""

    if data.playerId == 0 then
        self.messageType = ChatItem.MESSAGE_TYPE_SYSTEM
        self.bg:SetActiveEx(false)
    else
        self.messageType = ChatItem.MESSAGE_TYPE_CHAT
        self.bg:SetActiveEx(index % 2 > 0)
    end
    if self.messageType == ChatItem.MESSAGE_TYPE_CHAT then
        self.layoutChat:SetActiveEx(true)
        self.layoutSystem:SetActiveEx(false)
        self.txtChat.text = data.text
        self.tmpChat.text = data.text
        -- self.txtChatTime.text = gg.time.utcDate(t)
        self.txtChatTime.text = gg.time.utcDate(data.time)
        local vipIcon = "iconvip" .. data.vip
        local icon = gg.getSpriteAtlasName("Pledge_Atlas", vipIcon)

        if not IsAuditVersion() then
            gg.setSpriteAsync(self.imgVip, icon)
        end
        
        if data.channelType == constant.CHAT_TYPE_UNION then
            self.txtName.text = string.format("%s[%s]", data.playerName,
                Utils.getText(constant.TXT_DAO_DUTY[data.unionJob]))
        else
            if data.unionName and data.unionName ~= "" then
                self.txtName.text = string.format("%s[%s]", data.playerName, data.unionName)
            else
                self.txtName.text = data.playerName
            end
        end

        self.txtName.transform:SetRectSizeX(self.txtName.preferredWidth)

        local headIcon = ""
        if data.playerId == gg.playerMgr.localPlayer:getPid() then
            self:refreshUIPos(ChatItem.UI_POS_SELF)
            headIcon = PlayerData.myInfo.headIcon
        else
            self:refreshUIPos(ChatItem.UI_POS_OTHER)
            headIcon = PlayerData.playerInfoMap[data.playerId].headIcon -- data.headIcon
        end

        headIcon = Utils.getHeadIcon(headIcon)
        gg.setSpriteAsync(self.imgHead, headIcon, function(image, sprite, param)
            if param == self.setDataCount then
                image.sprite = sprite
            end
        end, self.setDataCount)

        self:refreshUISize()

        -- self.data.chain = 97
        local chainName = constant.getNameByChain(self.data.chain)
        print(chainName)
        self.chainIcon = constant.CHAIN_ICON_NAME[chainName]

        -- self.chainIcon = constant.CHAIN_ICON_NAME["CFX"]
        -- self.chainIcon = nil

        if self.chainIcon then
            self.imgChain.transform:SetActiveEx(true)
            gg.setSpriteAsync(self.imgChain, self.chainIcon)
        else
            self.imgChain.transform:SetActiveEx(false)
        end

    elseif self.messageType == ChatItem.MESSAGE_TYPE_SYSTEM then
        if self.data.hasHyperLink == 1 then
            self.txtSystem.color = constant.COLOR_RED
        else
            self.txtSystem.color = constant.COLOR_GREEN
        end

        self.layoutChat:SetActiveEx(false)
        self.layoutSystem:SetActiveEx(true)
        self.txtSystem.text = data.text
        self.txtSystemTime.text = gg.time.utcDate(data.time)
        self.txtSystemTime.transform.anchoredPosition = UnityEngine.Vector2(0, self.txtSystem.transform.anchoredPosition
            .y - self.txtSystem.preferredHeight)
        self.bg.transform.localScale = CS.UnityEngine.Vector3(-1, 1, 1)
    end
end

function ChatItem:onClickTxtChat()
    if self.data.hasHyperLink == 1 then
        gg.event:dispatchEvent("onChatHyperLink2Grid", self.data)
    end
end

function ChatItem:onBtnVip()
    gg.uiManager:openWindow("PnlPledge")
end

function ChatItem:onBtnHead()
    if self.data.playerId == gg.playerMgr.localPlayer:getPid() then
        return
    end

    local optionList = {{
        name = "Visit",
        clickCallback = gg.bind(self.onBtnVisit, self),
        color = PnlOptions.BTN_TYPE_BLUE
    }}

    if self.data.channelType ~= constant.CHAT_TYPE_UNION then
        if not self.data.unionId or self.data.unionId <= 0 then
            for k, v in pairs(cfg["daoPosition"]) do
                if v.accessLevel == UnionData.myUnionJod then
                    if v.isPersonnel == 1 then
                        table.insert(optionList, {
                            name = "Invite",
                            clickCallback = gg.bind(self.onBtnInvite, self),
                            color = PnlOptions.BTN_TYPE_YELLOW
                        })
                        break
                    end
                end
            end
        end
    end

    gg.uiManager:openWindow("PnlOptions", {
        optionList = optionList,
        worldPosition = self.imgHead.transform.position,
        alignmentX = ggclass.PnlOptions.LEFT,
        alignmentY = ggclass.PnlOptions.MIDDLE,
        offset = UnityEngine.Vector2(-60, 0),
        bgDir = ggclass.PnlOptions.BG_DIR_RIGHT
    })
end

function ChatItem:onBtnVisit()
    PlayerData.C2S_Player_ChatVisitFoundation(self.data.playerId)
    self.initData:close()
end

function ChatItem:onBtnInvite()
    UnionData.C2S_Player_InviteJoinUnion(self.data.playerId, UnionData.unionData.unionId)
end

ChatItem.UI_POS_SELF = 1
ChatItem.UI_POS_OTHER = -1

local headX = 47
local nameX = 3
local txtchatX = 136
local bgTextX = 105

function ChatItem:refreshUIPos(type)
    if type == ChatItem.UI_POS_OTHER then
        self.bgHead.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.bgHead.transform.anchorMax = CS.UnityEngine.Vector2(0, 1)
        self.bgHead.transform.pivot = CS.UnityEngine.Vector2(0.5, 0.5)
        self.bgHead.transform.anchoredPosition = CS.UnityEngine.Vector2(headX, self.bgHead.transform.anchoredPosition.y)

        self.txtName.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.txtName.transform.anchorMax = CS.UnityEngine.Vector2(0, 1)
        self.txtName.transform.pivot = CS.UnityEngine.Vector2(0, 1)
        self.txtName.transform.anchoredPosition = CS.UnityEngine.Vector2(nameX,
            self.txtName.transform.anchoredPosition.y)
        self.txtName.alignment = CS.UnityEngine.TextAnchor.MiddleLeft

        self.txtJob.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.txtJob.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.txtJob.transform.pivot = CS.UnityEngine.Vector2(1, 1)
        self.txtJob.transform.anchoredPosition = CS.UnityEngine.Vector2(-110, self.txtJob.transform.anchoredPosition.y)
        self.txtJob.alignment = CS.UnityEngine.TextAnchor.MiddleRight

        self.imgVip.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.imgVip.transform.anchorMax = CS.UnityEngine.Vector2(1, 1)
        self.imgVip.transform.pivot = CS.UnityEngine.Vector2(1, 1)
        self.imgVip.transform.anchoredPosition = CS.UnityEngine.Vector2(24, self.imgVip.transform.anchoredPosition.y)

        self.txtChatTime.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.txtChatTime.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.txtChatTime.transform.pivot = CS.UnityEngine.Vector2(1, 1)
        self.txtChatTime.alignment = CS.UnityEngine.TextAnchor.MiddleRight

        if self.isUseTmpChat then
            self.tmpChat.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
            self.tmpChat.transform.anchorMax = CS.UnityEngine.Vector2(0, 1)
            self.tmpChat.transform.pivot = CS.UnityEngine.Vector2(0, 1)
            self.tmpChat.transform.anchoredPosition = CS.UnityEngine.Vector2(txtchatX,
                self.tmpChat.transform.anchoredPosition.y)
        else
            self.txtChat.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
            self.txtChat.transform.anchorMax = CS.UnityEngine.Vector2(0, 1)
            self.txtChat.transform.pivot = CS.UnityEngine.Vector2(0, 1)
            self.txtChat.transform.anchoredPosition = CS.UnityEngine.Vector2(txtchatX,
                self.txtChat.transform.anchoredPosition.y)
            -- self.txtChat.alignment = CS.UnityEngine.TextAnchor.UpperLeft
        end

        self.bgText.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.bgText.transform.anchorMax = CS.UnityEngine.Vector2(0, 1)
        self.bgText.transform.pivot = CS.UnityEngine.Vector2(1, 1)
        self.bgText.transform.anchoredPosition = CS.UnityEngine.Vector2(bgTextX,
            self.bgText.transform.anchoredPosition.y)
        self.bgText.transform.localScale = CS.UnityEngine.Vector3(-1, 1, 1)

        self.bg.transform.localScale = CS.UnityEngine.Vector3(-1, 1, 1)

    elseif type == ChatItem.UI_POS_SELF then
        self.bgHead.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.bgHead.transform.anchorMax = CS.UnityEngine.Vector2(1, 1)
        self.bgHead.transform.pivot = CS.UnityEngine.Vector2(0.5, 0.5)
        self.bgHead.transform.anchoredPosition = CS.UnityEngine
                                                     .Vector2(-headX, self.bgHead.transform.anchoredPosition.y)

        self.txtName.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.txtName.transform.anchorMax = CS.UnityEngine.Vector2(1, 1)
        self.txtName.transform.pivot = CS.UnityEngine.Vector2(1, 1)

        local curNameX = -nameX
        if self.chainIcon then
            curNameX = curNameX - 50
        end
        self.txtName.transform.anchoredPosition = CS.UnityEngine.Vector2(curNameX,
            self.txtName.transform.anchoredPosition.y)
        self.txtName.alignment = CS.UnityEngine.TextAnchor.MiddleRight

        self.txtJob.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.txtJob.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.txtJob.transform.pivot = CS.UnityEngine.Vector2(0, 1)
        self.txtJob.transform.anchoredPosition = CS.UnityEngine.Vector2(110, self.txtJob.transform.anchoredPosition.y)
        self.txtJob.alignment = CS.UnityEngine.TextAnchor.MiddleLeft

        self.imgVip.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.imgVip.transform.anchorMax = CS.UnityEngine.Vector2(0, 1)
        self.imgVip.transform.pivot = CS.UnityEngine.Vector2(0, 1)
        self.imgVip.transform.anchoredPosition = CS.UnityEngine.Vector2(-24, self.imgVip.transform.anchoredPosition.y)

        self.txtChatTime.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.txtChatTime.transform.anchorMin = CS.UnityEngine.Vector2(0, 1)
        self.txtChatTime.transform.pivot = CS.UnityEngine.Vector2(0, 1)
        self.txtChatTime.alignment = CS.UnityEngine.TextAnchor.MiddleLeft

        if self.isUseTmpChat then
            self.tmpChat.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
            self.tmpChat.transform.anchorMax = CS.UnityEngine.Vector2(1, 1)
            self.tmpChat.transform.pivot = CS.UnityEngine.Vector2(1, 1)
            self.tmpChat.transform.anchoredPosition = CS.UnityEngine.Vector2(-txtchatX,
                self.tmpChat.transform.anchoredPosition.y)
        else
            self.txtChat.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
            self.txtChat.transform.anchorMax = CS.UnityEngine.Vector2(1, 1)
            self.txtChat.transform.pivot = CS.UnityEngine.Vector2(1, 1)
            self.txtChat.transform.anchoredPosition = CS.UnityEngine.Vector2(-txtchatX,
                self.txtChat.transform.anchoredPosition.y)
            -- self.txtChat.alignment = CS.UnityEngine.TextAnchor.UpperRight
        end

        self.bgText.transform.anchorMin = CS.UnityEngine.Vector2(1, 1)
        self.bgText.transform.anchorMax = CS.UnityEngine.Vector2(1, 1)
        self.bgText.transform.pivot = CS.UnityEngine.Vector2(1, 1)
        self.bgText.transform.anchoredPosition = CS.UnityEngine.Vector2(-bgTextX,
            self.bgText.transform.anchoredPosition.y)
        self.bgText.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)

        self.bg.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
    end
end

local textChatMaxWidth = 298
local bgChatMaxWidth = 349

local txtChatTimeX = -1.7

function ChatItem:refreshUISize()
    if self.isUseTmpChat then
        self.tmpChat.transform:SetRectSizeX(math.min(self.tmpChat.preferredWidth, textChatMaxWidth))
        self.bgText.transform.sizeDelta = CS.UnityEngine.Vector2(math.min(bgChatMaxWidth,
            self.tmpChat.preferredWidth + 51), self.tmpChat.preferredHeight + 18)
    else
        self.txtChat.transform:SetRectSizeX(math.min(self.txtChat.preferredWidth, textChatMaxWidth))
        self.bgText.transform.sizeDelta = CS.UnityEngine.Vector2(math.min(bgChatMaxWidth,
            self.txtChat.preferredWidth + 51), self.txtChat.preferredHeight + 18)
    end

    local bgTextTransform = self.bgText.transform
    self.txtChatTime.transform.anchoredPosition = UnityEngine.Vector2(txtChatTimeX, bgTextTransform.anchoredPosition.y -
        bgTextTransform.rect.height + 30)
end

local defaultItemLenthSystem = 137
local perSystemLineHight = 39
local systemLineWidth = 300

local defaultItemLenthChat = 130
local perLineLenth = 36
local lineWidth = 288

-- function ChatItem:calItemSize(text, type)
--     if type == ChatItem.MESSAGE_TYPE_CHAT then
--         local addLenth = math.ceil(self.txtChat:GetTextRenderWidth(text) / lineWidth) * perLineLenth - perLineLenth
--         return CS.UnityEngine.Vector2(384, defaultItemLenthChat + addLenth)

--     elseif type == ChatItem.MESSAGE_TYPE_SYSTEM then
--         local addLenth = math.ceil(self.txtSystem:GetTextRenderWidth(text) / systemLineWidth) * perSystemLineHight - perSystemLineHight
--         return CS.UnityEngine.Vector2(384, defaultItemLenthSystem + addLenth)
--     end
-- end

function ChatItem:calItemSize2(text, type)
    local width = self.transform.rect.width
    if type == ChatItem.MESSAGE_TYPE_CHAT then

        if self.isUseTmpChat then
            self.tmpChat.text = text
            return CS.UnityEngine
                       .Vector2(width, defaultItemLenthChat + self.tmpChat.preferredHeight - perLineLenth + 10)
        else
            self.txtChat.text = text
            return CS.UnityEngine
                       .Vector2(width, defaultItemLenthChat + self.txtChat.preferredHeight - perLineLenth + 10)
        end

    elseif type == ChatItem.MESSAGE_TYPE_SYSTEM then
        self.txtSystem.text = text
        return CS.UnityEngine.Vector2(width,
            defaultItemLenthSystem + self.txtSystem.preferredHeight - perSystemLineHight + 10)
    end
end
