PnlPlayerDetailed = class("PnlPlayerDetailed", ggclass.UIBase)

function PnlPlayerDetailed:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onPlayerInfoChange"}
    self.needBlurBG = true
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlPlayerDetailed:onAwake()
    self.view = ggclass.PnlPlayerDetailedView.new(self.pnlTransform)

    self.playerDetailedSelectHeadBox = PlayerDetailedSelectHeadBox.new(self.view.PlayerDetailedSelectHeadBox, self)
    self.playerDetailedSelectHeadBox:SetBtnSetCallBack(function(selectIcon)
        PlayerData.C2S_Player_ModifyPlayerInfo(PlayerData.myInfo.canInvite, PlayerData.myInfo.canVisit,
            PlayerData.myInfo.text, selectIcon)
        self.playerDetailedSelectHeadBox:close()
    end)
end

-- args = info
function PnlPlayerDetailed:onShow()
    self:bindEvent()
    self.args = self.args or PlayerData.myInfo
    self:initView()
    if not self.args then
        -- PlayerData.C2S_Player_QueryPlayerInfo()
        return
    end
    self:refresh()
    self.playerDetailedSelectHeadBox:close()
    self.isMyInfo = self.args.pid == PlayerData.myInfo.pid

    self:refreshAudit()
end

function PnlPlayerDetailed:refreshAudit()
    local view = self.view
    if IsAuditVersion() then
        view.txtInvitCode:SetActiveEx(false)
        view.btnShareCode:SetActiveEx(false)
        view.txtInvitUrl:SetActiveEx(false)
        view.btnShareInvitUrl:SetActiveEx(false)

        view.btnVip:SetActiveEx(false)
    end
end

function PnlPlayerDetailed:initView()
    local view = self.view
    view.inputContent.transform:SetActiveEx(false)
end

function PnlPlayerDetailed:refresh()
    local view = self.view

    view.txtName.text = Utils.getText("information_Name") .. self.args.name
    view.txtId.text = "ID:" .. self.args.pid
    view.txtInvitCode.text = Utils.getText("information_InvitationCodeTips") .. self.args.inviteCode
    view.txtInvitUrl.text = Utils.getText("information_InvitationLinks") .. "\n" .. self:getInvitUrl()
    view.txtMedal.text = self.args.badge

    if self.args.text == "" then
        view.txtContent.text = Utils.getText("information_EnterTips")
    else
        view.txtContent.text = self.args.text
    end
    -- view.txtContent.text = self.args.text

    if self.args.unionId and self.args.unionId > 0 then
        view.layoutDao:SetActiveEx(true)
        view.txtDaoName.text = self.args.unionName
        view.txtDaoId.text = self.args.unionId
    else
        view.layoutDao:SetActiveEx(false)
    end
    -- view.toggleDaoInvite:SetIsOnWithoutNotify(self.args.canInvite)
    -- view.toggleVisit:SetIsOnWithoutNotify(self.args.canVisit)
    view.toggleDaoInvite.isOn = self.args.canInvite
    view.toggleVisit.isOn = self.args.canVisit

    view.txtVip.text = self.args.vipLevel
    self:selectHeadIcon(self.args.headIcon)
    self:refreshImgChain()
end

function PnlPlayerDetailed:refreshImgChain()
    self.view.imgChain.gameObject:SetActiveEx(false)
    local chain = PlayerData.chainId
    local chainName = constant.getNameByChain(chain)
    if chainName ~= "NONE" and chainName ~= "UNKNOW" then
        gg.setSpriteAsync(self.view.imgChain, constant.CHAIN_ICON_NAME[chainName], function(image, sprite)
            image.sprite = sprite
            image.color = Color.New(1, 1, 1, 1)
            image:SetNativeSize()
            image.gameObject:SetActiveEx(true)
        end)
    end
end


function PnlPlayerDetailed:onHide()
    self:modifyPlayerInfo()
    self:releaseEvent()
end

function PnlPlayerDetailed:modifyPlayerInfo()
    local view = self.view
    if self.args.pid == gg.playerMgr.localPlayer:getPid() then
        if self.args.canInvite ~= view.toggleDaoInvite.isOn or self.args.canVisit ~= view.toggleVisit.isOn or
            view.txtContent.text ~= self.args.text or self.args.headIcon ~= self.selectIcon then
            PlayerData.C2S_Player_ModifyPlayerInfo(view.toggleDaoInvite.isOn, view.toggleVisit.isOn,
                view.txtContent.text, self.selectIcon)
        end
    end
end

function PnlPlayerDetailed:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnShare):SetOnClick(function()
        self:onBtnShare()
    end)
    CS.UIEventHandler.Get(view.btnShareCode):SetOnClick(function()
        self:onBtnShareCode()
    end)
    CS.UIEventHandler.Get(view.btnShareInvitUrl):SetOnClick(function()
        self:onBtnShareInvitUrl()
    end)
    CS.UIEventHandler.Get(view.btnShareName):SetOnClick(function()
        self:onBtnShareName()
    end)

    self:setOnClick(view.btnSetName, gg.bind(self.onBtnSetName, self))
    self:setOnClick(view.txtContent.gameObject, gg.bind(self.onClickContent, self))
    self:setOnClick(view.btnHead, gg.bind(self.onBtnHead, self))
    view.toggleDaoInvite.onValueChanged:AddListener(gg.bind(self.onDaoToggleValChange, self, 1))
    view.toggleVisit.onValueChanged:AddListener(gg.bind(self.onDaoToggleValChange, self, 2))

    view.inputContent.onValueChanged:AddListener(gg.bind(self.onInputContent, self))
    view.inputContent.onEndEdit:AddListener(gg.bind(self.onInputContentEnd, self))
end

function PnlPlayerDetailed:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnShare)
    CS.UIEventHandler.Clear(view.btnShareCode)
    CS.UIEventHandler.Clear(view.btnShareInvitUrl)
    CS.UIEventHandler.Clear(view.btnShareName)

    view.toggleDaoInvite.onValueChanged:RemoveAllListeners()
    view.toggleVisit.onValueChanged:RemoveAllListeners()

    view.inputContent.onValueChanged:RemoveAllListeners()
    view.inputContent.onEndEdit:RemoveAllListeners()
end

function PnlPlayerDetailed:onDestroy()
    local view = self.view
    self.playerDetailedSelectHeadBox:release()
end

function PnlPlayerDetailed:onBtnClose()

end

function PnlPlayerDetailed:onBtnShare()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = gg.playerMgr.localPlayer:getPid()
    gg.uiManager:showTip(Utils.getText("information_CopyID"))
end

function PnlPlayerDetailed:onBtnShareCode()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = self.args.inviteCode
    -- gg.uiManager:showTip("invitatiom code copy succeed")
    gg.uiManager:showTip(Utils.getText("information_CopyInvitCode"))
end

function PnlPlayerDetailed:onBtnShareInvitUrl()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = self:getInvitUrl()
    -- gg.uiManager:showTip("invitatiom code copy succeed")
    gg.uiManager:showTip(Utils.getText("information_CopyInvitCode"))
end

function PnlPlayerDetailed:onBtnShareName()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = self.args.name
    -- gg.uiManager:showTip("invitatiom code copy succeed")
    gg.uiManager:showTip(Utils.getText("information_CopyInvitCode"))
end


function PnlPlayerDetailed:onBtnSetName()
    gg.uiManager:openWindow("PnlChangeName")
end

function PnlPlayerDetailed:onClickContent()
    local view = self.view

    view.inputContent.transform:SetActiveEx(true)
    view.txtContent.transform:SetActiveEx(false)
    view.inputContent.text = view.txtContent.text
    view.inputContent:ActivateInputField()
end

function PnlPlayerDetailed:onBtnHead()
    self.playerDetailedSelectHeadBox:open(self.args)
end

local maxCount = 60
function PnlPlayerDetailed:onInputContent(text)
    local view = self.view
    local wordsCount = string.utf8len(text)

    if wordsCount > maxCount then
        text = string.utf8sub(text, 0, maxCount)
        view.inputContent.text = text
        view.txtContentInputCount.text = string.format(Utils.getText("information_BytesTips"), 0, maxCount)
        return
    end
    view.txtContentInputCount.text = string.format(Utils.getText("information_BytesTips"), maxCount - wordsCount,
        maxCount)
end

function PnlPlayerDetailed:onInputContentEnd(text)
    local view = self.view
    text = FilterWords.filterWords(text)

    if text == "" then
        view.txtContent.text = Utils.getText("information_EnterTips")
    else
        view.txtContent.text = text
    end
    view.inputContent.transform:SetActiveEx(false)
    view.txtContent.transform:SetActiveEx(true)
    self:modifyPlayerInfo()
end

function PnlPlayerDetailed:onDaoToggleValChange(index, isOn)
    if index == 1 then
        self:setDaoToggleStage(isOn, self.view.imgDaoInviteSelect)
    else
        self:setDaoToggleStage(isOn, self.view.imgDaoVisitSelect)
    end
    self:modifyPlayerInfo()
end

function PnlPlayerDetailed:setDaoToggleStage(isOn, imgSelect)
    if isOn then
        imgSelect.transform.anchoredPosition = UnityEngine.Vector2(-55.5, imgSelect.transform.anchoredPosition.y)
        imgSelect.transform:Find("TextSelect"):GetComponent(UNITYENGINE_UI_TEXT).text = "ON"
    else
        imgSelect.transform.anchoredPosition = UnityEngine.Vector2(55.5, imgSelect.transform.anchoredPosition.y)
        imgSelect.transform:Find("TextSelect"):GetComponent(UNITYENGINE_UI_TEXT).text = "OFF"
    end
end

function PnlPlayerDetailed:onPlayerInfoChange(event, info)
    if self.args and self.args.pid == info.pid then
        self.args = info
        self:refresh()
    end
end

function PnlPlayerDetailed:selectHeadIcon(icon)
    local newIcon = Utils.getHeadIcon(icon)
    gg.setSpriteAsync(self.view.imgHead, newIcon)
    self.selectIcon = icon
end

function PnlPlayerDetailed:getInvitUrl()
    return AutoPushData.getInvitUrl(self.args.inviteCode)
end

return PnlPlayerDetailed
