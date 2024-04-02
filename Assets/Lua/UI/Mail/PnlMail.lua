PnlMail = class("PnlMail", ggclass.UIBase)

function PnlMail:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onPlayResAnimation", "onRefreshMail"}
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlMail:onAwake()
    self.view = ggclass.PnlMailView.new(self.pnlTransform)

end

function PnlMail:onShow()
    self:bindEvent()
    self:initView()

end

function PnlMail:onInitView(args, isRefresh)
    self:initView(isRefresh)
end

function PnlMail:initView(isRefresh)
    if isRefresh then
        self:refreshMail()
    else
        self.curData = nil
        self.view.layoutMail:SetActiveEx(false)
        self:refreshMail()

        -- local haveData = false
        -- for k, v in pairs(MailData.mailBriefData) do
        --     haveData = true
        --     MailData.C2S_Player_GetMail(v.id)
        --     break
        -- end
        -- if not haveData then
        --     self:refreshMail()
        -- end
    end
end

function PnlMail:onHide()
    gg.event:dispatchEvent("onShowPlayerInformation", true)

    self:releaseEvent()
    self:releaseBoxMail()
    self:releaseBoxMailReceive()

end

function PnlMail:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnDelAll):SetOnClick(function()
        self:onBtnDelAll()
    end)
    CS.UIEventHandler.Get(view.btnGetAll):SetOnClick(function()
        self:onBtnGetAll()
    end)
    CS.UIEventHandler.Get(view.btnDel):SetOnClick(function()
        self:onBtnDel()
    end)
    CS.UIEventHandler.Get(view.btnReceive):SetOnClick(function()
        self:onBtnReceive()
    end)

    gg.event:addListener("onRefreshContent", self)
    gg.event:addListener("onInitView", self)

end

function PnlMail:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnDelAll)
    CS.UIEventHandler.Clear(view.btnGetAll)
    CS.UIEventHandler.Clear(view.btnDel)
    CS.UIEventHandler.Clear(view.btnReceive)

    gg.event:removeListener("onRefreshContent", self)
    gg.event:removeListener("onInitView", self)

end

function PnlMail:onDestroy()
    local view = self.view
end

function PnlMail:onBtnClose()
    self:close()
end

function PnlMail:onBtnDelAll()

    local haveReadMail = false
    for key, value in pairs(MailData.mailBriefData) do
        if value.read and not value.canGet then
            haveReadMail = true
            break
        end
    end

    if haveReadMail then
        gg.uiManager:showTip(Utils.getText("email_Tips_ClaimAllDel"))
        MailData.C2S_Player_OneKeyDelMails()
    else
        gg.uiManager:showTip(Utils.getText("email_Tips_AlreadyDeleted"))
    end
end

function PnlMail:onBtnGetAll()
    MailData.C2S_Player_OneKeyReadMails()

    -- local rewardList = {}
    -- for _, value in ipairs(self.mailDataList) do
    --     gg.printData(value)
    --     -- if value.canGet and value.attachment and next(value.attachment) then
    --     if  value.attachment and next(value.attachment) then
    --         for _, attach in pairs(self.curData.attachment) do
    --             if attach.type == 0 then
    --                 table.insert(rewardList, {rewardType = PnlReward.TYPE_RES, resId = value.cfgId, count = value.count})
    --             elseif attach.type == 1 then
    --                 table.insert(rewardList, {rewardType = PnlReward.TYPE_ITEM, cfgId = value.cfgId, count = value.count})
    --             end
    --         end
    --     end
    -- end
    -- gg.uiManager:openWindow("PnlReward", {rewards = rewardList})

    -- 
    -- for key, value in pairs(self.curData.attachment) do
    --     if value.type == 0 then
    --         table.insert(rewardList, {rewardType = PnlReward.TYPE_RES, resId = value.cfgId, count = value.count})
    --     elseif value.type == 1 then
    --         table.insert(rewardList, {rewardType = PnlReward.TYPE_ITEM, cfgId = value.cfgId, count = value.count})
    --     end
    -- end
    -- gg.uiManager:openWindow("PnlReward", {rewards = rewardList})
end

function PnlMail:onBtnDel()
    MailData.C2S_Player_DelMail(self.curData.id)
end

function PnlMail:onBtnReceive()
    -- local args = self.curData.attachment
    -- gg.uiManager:openWindow("PnlAcquisition", args)
    MailData.C2S_Player_ReceiveMailAttach(self.curData.id)
    local rewardList = {}
    for key, value in pairs(self.curData.attachment) do
        if value.type == 0 then
            table.insert(rewardList, {rewardType = PnlReward.TYPE_RES, resId = value.cfgId, count = value.count})
        elseif value.type == 1 then
            table.insert(rewardList, {rewardType = PnlReward.TYPE_ITEM, cfgId = value.cfgId, count = value.count})
        end
    end
    gg.uiManager:openWindow("PnlReward", {rewards = rewardList})
end

function PnlMail:refreshMail()
    self:releaseBoxMail()

    self.boxMail = {}

    self.mailDataList = {}
    for key, value in pairs(MailData.mailBriefData) do
        table.insert(self.mailDataList, value)
    end
    table.sort(self.mailDataList, function(a, b)
        if a.read ~= b.read then
            return b.read
        end
        return a.sendTime > b.sendTime
    end)

    for index, v in ipairs(self.mailDataList) do
        local temp = index - 1
        ResMgr:LoadGameObjectAsync("BoxMail", function(obj)
            obj.transform:SetParent(self.view.scrollViewContent.transform, false)
            local id = nil
            if self.curData then
                id = self.curData.id
            end
            local boxMail = ggclass.BoxMail.new(v, obj, id)
            self.boxMail[v.id] = boxMail
            return true
        end, true)
    end

    local itemCount = #self.mailDataList

    if itemCount == 0 then
        self.view.txtNoMail.gameObject:SetActive(true)
        self.view.txtNoContent.gameObject:SetActive(true)
        self.view.layoutMail:SetActiveEx(false)
    else
        self.view.txtNoMail.gameObject:SetActive(false)
        self.view.txtNoContent.gameObject:SetActive(false)
    end

end

function PnlMail:releaseBoxMail()
    if self.boxMail then
        for k, v in pairs(self.boxMail) do
            v:releaseBoxMail()
        end
        self.boxMail = nil
    end
end

function PnlMail:onRefreshMail()
    if self.curMail then
        local haveItem = false

        for k, v in pairs(self.curMail.attachment) do
            haveItem = true
            break
        end

        self.view.txtReceivedTips.gameObject:SetActiveEx(false)
        if haveItem and MailData.mailBriefData[self.curMail.id] and MailData.mailBriefData[self.curMail.id].canGet then
            self.view.btnReceive:SetActiveEx(true)
        else
            self.view.btnReceive:SetActiveEx(false)

            if haveItem then
                self.view.txtReceivedTips.gameObject:SetActiveEx(true)
            end
        end
    end
end

function PnlMail:onRefreshContent(args, mail)
    self.curMail = mail
    local sendDate = os.date("%Y-%m-%d", mail.sendTime)

    self.curData = mail
    self.view.layoutMail:SetActiveEx(true)
    self.view.txtMailTitle.text = mail.title
    self.view.txtMailDate.text = sendDate
    self.view.txtMailSender.text = mail.sendName
    self.view.txtMailContent.text = mail.content

    self:releaseBoxMailReceive()
    self.boxMailReceiveList = {}

    local haveItem = false

    for k, v in pairs(mail.attachment) do
        ResMgr:LoadGameObjectAsync("BoxMailReceive", function(go)
            go.transform:SetParent(self.view.mailReceiveContent, false)

            local type = v.type
            local cfgId = v.cfgId
            local count = v.count
            local icon
            if type == 0 then
                icon = constant.RES_2_CFG_KEY[cfgId].icon
                count = count / 1000
            elseif type == 1 then
                local curCfg = cfg.getCfg("item", cfgId)
                icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)

            end
            gg.setSpriteAsync(go.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE), icon)
            go.transform:Find("TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(count)

            table.insert(self.boxMailReceiveList, go)
            return true
        end, true)

        haveItem = true
    end

    self.view.mailRewardScrollView:SetActiveEx(next(mail.attachment))

    if haveItem and MailData.mailBriefData[mail.id].canGet then
        self.view.btnReceive:SetActiveEx(true)
    else
        self.view.btnReceive:SetActiveEx(false)
    end

    self:refreshContentSize()
end

function PnlMail:refreshContentSize()
    local view = self.view

    local topContentHeight = -view.txtMailContent.transform.anchoredPosition.y + view.txtMailContent.preferredHeight

    local bottomPos = view.layoutMailBottom.transform.anchoredPosition
    bottomPos.y = -topContentHeight - 50
    view.layoutMailBottom.transform.anchoredPosition = bottomPos

    if next(self.curMail.attachment) then
        view.layoutMailBottom.transform:SetRectSizeY(467)
    else
        view.layoutMailBottom.transform:SetRectSizeY(233)
    end

    local h = -bottomPos.y + view.layoutMailBottom.transform.sizeDelta.y
    view.bgContent:SetRectSizeY(h)
end

function PnlMail:releaseBoxMailReceive()
    if self.boxMailReceiveList then
        for k, go in pairs(self.boxMailReceiveList) do
            ResMgr:ReleaseAsset(go)
        end
        self.boxMailReceiveList = nil
    end
end

function PnlMail:onPlayResAnimation(args, cfgId, count)
    -- local iconName = "Res/" .. PnlMail.RES_ICON_NAME[cfgId].icon
    -- gg.resEffectManager:fly3dRes2TargetOnPnlPlayerInformation(self.view.bgMail.transform:Find(iconName).gameObject, cfgId,
    -- count, true)
end

return PnlMail
