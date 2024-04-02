PnlUnion = class("PnlUnion", ggclass.UIBase)

PnlUnion.VIEW_NONE = 0
PnlUnion.VIEW_UNIONLIST = 1
PnlUnion.VIEW_CREATUNION = 2
PnlUnion.VIEW_UNIONINVITE = 3
PnlUnion.VIEW_UNIONMAIN = 4
PnlUnion.VIEW_UNIONMEMBER = 5
PnlUnion.VIEW_UNIONAPPLY = 6
PnlUnion.VIEW_INVITEPLAYER = 7
PnlUnion.VIEW_CHANGEFLAGS = 8
PnlUnion.VIEW_UNIONADDPOINT = 9
PnlUnion.VIEW_UNIONWAREHOUSE = 10
PnlUnion.VIEW_UNIONTECH = 11
PnlUnion.VIEW_EDITO = 12
PnlUnion.VIEW_UNIONOTHER = 13

PnlUnion.WAREHOUSE_RES = 1
PnlUnion.WAREHOUSE_SOLIDIER = 2
PnlUnion.WAREHOUSE_TOWER = 3
PnlUnion.WAREHOUSE_DAO = 4

PnlUnion.TECH_ECONOMY = 1
PnlUnion.TECH_MILITARY = 2
PnlUnion.TECH_DEFENCE = 3

PnlUnion.needFitSafeArea = true
PnlUnion.closeType = ggclass.UIBase.CLOSE_TYPE_NONE

PnlUnion.canvasBgColor = constant.COLOR_BLACK

function PnlUnion:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onShowSearchPlayer", "onUpdateUnionData", "onRedPointChange", "onVisitUnion",
                   "onSetViewWarehouseDao", "onRefreshBoxDaoArtifact"}

    self.unionData = {} -- ""

    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE

    self.boxUnionList = {}
    self.boxMemberList = {}
    self.boxApplyList = {}
    self.boxUnionInviteList = {}
    self.boxFlagList = {}
    self.boxUnionTrainList = {}
    self.boxTechList = {}
    self.boxWarehouseNft = {}
    self.boxWarehouseAddNft = {}
    self.boxAddpointList = {}
    self.BoxUpgrading = {}
    self.donateRes = {}

    self.searchPlayerId = nil -- ""ID

    self.presidentId = nil -- ""ID

    self.flagCfg = cfg["flag"]

    self.daoPositionCfg = cfg["daoPosition"]

    self.selelctTrainCfg = {} -- ""

    self.playerId = gg.playerMgr.localPlayer:getPid()

    self.isShowViewUpgrading = false

    self.quitUnionLimit = cfg["global"].QuitUnionLimit.intValue
    self.quitUnionCd = cfg["global"].RejoinUnionCD.intValue / 3600

end

function PnlUnion:onAwake()
    self.view = ggclass.PnlUnionView.new(self.pnlTransform)

    self.view.inputFieldSharing.text = 70

    self.redPointMap = {
        [RedPointUnionInvite.__name] = self.view.btnInvite,
        [RedPointUnionMember.__name] = self.view.btnMemberMian,
        [RedPointUnionApply.__name] = self.view.btnApplyList,
        [RedPointUnionMint.__name] = self.view.btnMint
    }
end

function PnlUnion:onShow()
    self:bindEvent()
    self:chooseView(PnlUnion.VIEW_NONE)
    self:initRedPoint()

    self.selelctFlag = 1
    for k, v in pairs(self.flagCfg) do
        if v.isShow == 1 then
            self.selelctFlag = v.cfgId
            break
        end
    end

    self.unionData = UnionData.unionData
    if self.unionData then
        if self.unionData.unionId and self.unionData.unionId ~= 0 then
            UnionData.C2S_Player_QueryMyUnionInfo()
        else
            UnionData.C2S_Player_QueryJoinableUnionList()
        end
    else
        UnionData.C2S_Player_QueryJoinableUnionList()
    end
    self.warehouseView = PnlUnion.WAREHOUSE_RES

    self.techType = PnlUnion.TECH_DEFENCE

    self:refreshAudit()
end

function PnlUnion:refreshAudit()
    local view = self.view
    if IsAuditVersion() then
        view.btnMint:SetActiveEx(false)
        view.btnNft:SetActiveEx(false)
        view.hyOutput:SetActiveEx(false)
        
    end
end

function PnlUnion:chooseView(viewType, isResetView)
    self.lastViewType = self.viewType
    self.viewType = viewType
    self:setView(isResetView)
end

function PnlUnion:onBtnDesc()
    gg.uiManager:openWindow("PnlDesc", {
        title = Utils.getText("guild_Rules_Title"),
        desc = Utils.getText("guild_Rules_Txt")
    })
end

function PnlUnion:onBtnDaoInfoDesc()
    gg.uiManager:openWindow("PnlDesc", {
        title = Utils.getText("guild_RewardShare_Rules_Title"),
        desc = Utils.getText("guild_RewardShare_Rules_Txt")
    })
end

function PnlUnion:setView(isResetView)
    local view = self.view
    if self.viewType == PnlUnion.VIEW_NONE then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionOther:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)
    elseif self.viewType == PnlUnion.VIEW_UNIONLIST then
        view.viewUnionList:SetActiveEx(true)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionOther:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        if isResetView then
            self:setViewUnionList()
        end
    elseif self.viewType == PnlUnion.VIEW_CREATUNION then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(true)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        self:setViewCreatUnion(1, isResetView)
    elseif self.viewType == PnlUnion.VIEW_UNIONINVITE then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(true)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        if isResetView then
            self:setViewInvite()
        end
    elseif self.viewType == PnlUnion.VIEW_UNIONMAIN or self.viewType == PnlUnion.VIEW_UNIONOTHER then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        if isResetView then
            if self.viewType == PnlUnion.VIEW_UNIONMAIN then
                view.viewUnionMain:SetActiveEx(true)
                view.viewUnionOther:SetActiveEx(false)

                self:setViewUnionMain()
            else
                view.viewUnionMain:SetActiveEx(false)
                view.viewUnionOther:SetActiveEx(true)

                self:setViewUnionOther()
            end
        end
    elseif self.viewType == PnlUnion.VIEW_UNIONMEMBER then
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(true)
        view.viewUnionMember:SetActiveEx(true)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        if isResetView then
            self:setViewMember()
        end
    elseif self.viewType == PnlUnion.VIEW_UNIONAPPLY then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(true)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        if isResetView then
            self:setViewApply()
        end
    elseif self.viewType == PnlUnion.VIEW_INVITEPLAYER then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(true)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        if isResetView then

        else
            view.viewInvitePlayer.transform:Find("BoxApply").gameObject:SetActiveEx(false)
        end
    elseif self.viewType == PnlUnion.VIEW_CHANGEFLAGS then
        view.viewChangeFlags:SetActiveEx(true)
        self:setViewFlags()
    elseif self.viewType == PnlUnion.VIEW_UNIONADDPOINT then
        view.viewUnionAddpoint:SetActiveEx(true)
        self:setViewAddpopint()

    elseif self.viewType == PnlUnion.VIEW_UNIONWAREHOUSE then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(false)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(true)
        view.ViewUnionTech:SetActiveEx(false)

        self:setViewUnionWarehouse(isResetView)
    elseif self.viewType == PnlUnion.VIEW_UNIONTECH then
        view.ViewUnionTech:SetActiveEx(true)
        self:setViewUnionTech(self.techType, isResetView)
    elseif self.viewType == PnlUnion.VIEW_EDITO then
        view.viewUnionList:SetActiveEx(false)
        view.viewCreateUnion:SetActiveEx(true)
        view.viewUnionInvite:SetActiveEx(false)
        view.viewUnionMain:SetActiveEx(false)
        view.viewUnionMember:SetActiveEx(false)
        view.viewInvitePlayer:SetActiveEx(false)
        view.viewUnionApply:SetActiveEx(false)
        view.viewChangeFlags:SetActiveEx(false)
        view.viewUnionAddpoint:SetActiveEx(false)
        view.viewUnionWarehouse:SetActiveEx(false)
        view.ViewUnionTech:SetActiveEx(false)

        self:setViewCreatUnion(2, isResetView)
    end
end

------------------------------VIEW_CHANGEFLAGS------------------------------

function PnlUnion:setViewFlags()
    self:releaseBoxFlag()

    local parent = self.view.viewChangeFlags.transform:Find("ScrollViewFlags/Viewport/Content")
    self.view.txtSetFlagName.text = ""
    for k, v in pairs(self.flagCfg) do
        if v.isShow == 1 then
            ResMgr:LoadGameObjectAsync("BoxFlag", function(go)
                go.transform:SetParent(parent, false)
                self.boxFlagList[v.cfgId] = go
                CS.UIEventHandler.Get(go):SetOnClick(function()
                    self:onBtnFlag(v.cfgId)
                end)
                local icon = gg.getSpriteAtlasName("ContryFlag_Atlas", v.icon)
                gg.setSpriteAsync(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), icon)

                return true
            end, true)
        end
    end

    self.view.boxChoose:SetActiveEx(false)
end

function PnlUnion:releaseBoxFlag()
    self.view.boxChoose.transform:SetParent(self.view.viewChangeFlags.transform, false)

    if self.boxFlagList then
        for k, go in pairs(self.boxFlagList) do
            CS.UIEventHandler.Clear(go)
            ResMgr:ReleaseAsset(go)
        end
        self.boxFlagList = {}
    end
end

function PnlUnion:onBtnFlag(cfgId)
    self.view.boxChoose:SetActiveEx(true)
    self.temporaryFlagId = cfgId
    self.view.boxChoose.transform:SetParent(self.boxFlagList[cfgId].transform, false)
    self.view.boxChoose.transform.localPosition = Vector3(0, 0, 0)
    self.view.txtSetFlagName.text = Utils.getText(self.flagCfg[self.temporaryFlagId].languageNameID)
end

function PnlUnion:onBtnCloseFlag()
    self.view.boxChoose.transform:SetParent(self.view.viewChangeFlags.transform, false)
    self:chooseView(self.lastViewType, false)
end

function PnlUnion:onBtnConfirmFlag()
    self.selelctFlag = self.temporaryFlagId
    self:chooseView(self.lastViewType, false)
end

------------------------------VIEW_UNIONLIST------------------------------
function PnlUnion:setViewUnionList()
    self.view.txtTitle.text = Utils.getText("guild_List")
    self:releaseBoxUnion()
    local boxParent = self.view.viewUnionList.transform:Find("UnionListScrollView/Viewport/Content").transform
    for k, v in pairs(UnionData.joinableUnionList) do
        ResMgr:LoadGameObjectAsync("BoxUnion", function(go)
            go.transform:SetParent(boxParent, false)
            go.transform:Find("TxtUnionName"):GetComponent(UNITYENGINE_UI_TEXT).text = v.unionName
            go.transform:Find("TxtForces"):GetComponent(UNITYENGINE_UI_TEXT).text = v.score or 0
            go.transform:Find("TxtPeople"):GetComponent(UNITYENGINE_UI_TEXT).text = v.memberCount .. "/" .. v.memberMax
            go.transform:Find("TxtSharing"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format(Utils.getText(
                "guild_PlayerTips"), (100 - v.unionSharing)) .. "%"

            go.transform:Find("ImgChain").gameObject:SetActiveEx(false)
            -- self:setChainImg(go.transform:Find("ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE), v.unionChain)

            if v.enterType == 2 then
                go.transform:Find("BtnApply").gameObject:SetActiveEx(false)
                go.transform:Find("ImgLock").gameObject:SetActiveEx(true)
            else
                go.transform:Find("BtnApply").gameObject:SetActiveEx(true)
                go.transform:Find("ImgLock").gameObject:SetActiveEx(false)
                if v.enterType == 0 then
                    gg.setSpriteAsync(go.transform:Find("BtnApply"):GetComponent(UNITYENGINE_UI_IMAGE),
                        "Button_Atlas[Button 05_button_B]")
                    go.transform:Find("BtnApply/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                        "guild_Join")
                    go.transform:Find("BtnApply/Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(1, 245 / 255,
                        79 / 255, 1)

                elseif v.enterType == 1 then
                    gg.setSpriteAsync(go.transform:Find("BtnApply"):GetComponent(UNITYENGINE_UI_IMAGE),
                        "Button_Atlas[Button 05_button_A]")
                    go.transform:Find("BtnApply/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                        "guild_Request")
                    go.transform:Find("BtnApply/Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(13 / 255,
                        221 / 255, 1, 1)

                end
                local flag = self.selelctFlag
                if self.flagCfg[v.unionFlag] then
                    flag = v.unionFlag
                end

                local icon = gg.getSpriteAtlasName("ContryFlag_Atlas", self.flagCfg[flag].icon)
                gg.setSpriteAsync(go.transform:Find("IconFlag"):GetComponent(UNITYENGINE_UI_IMAGE), icon)
                CS.UIEventHandler.Get(go):SetOnClick(function()
                    self:onBtnBoxUnion(v.unionId)
                end)

                CS.UIEventHandler.Get(go.transform:Find("BtnApply").gameObject):SetOnClick(function()
                    self:onBtnApplyUnion(v.unionId)
                end)
            end

            table.insert(self.boxUnionList, go)
            return true
        end, true)
    end
end

function PnlUnion:releaseBoxUnion()
    if self.boxUnionList then
        for k, go in pairs(self.boxUnionList) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnApply").gameObject)
            CS.UIEventHandler.Clear(go)
            ResMgr:ReleaseAsset(go)
        end
        self.boxUnionList = {}
    end
end

function PnlUnion:onBtnBoxUnion(unionId)
    UnionData.C2S_Player_QueryUnionBaseInfo(unionId)
end

function PnlUnion:onBtnSearchUnionList()
    local keyWord = self.view.inputUnionName.text
    if self.lastKeyWord ~= keyWord then
        if keyWord and keyWord ~= "" then
            UnionData.C2S_Player_SearchUnion(keyWord)
        else
            UnionData.C2S_Player_QueryJoinableUnionList()
        end
    end
    self.lastKeyWord = keyWord
end

function PnlUnion:onBtnCreate()
    self.view.inputFieldUnionName.text = ""
    self.view.inputFieldNotice.text = ""
    self.view.inputFieldSharing.text = ""
    self.view.toggleEvery.isOn = true

    -- 5.23 ""
    self:chooseView(PnlUnion.VIEW_CREATUNION, true)
    -- local chain = PlayerData.chainId
    -- local chainName = constant.getNameByChain(chain)
    -- if chainName ~= "NONE" and chainName ~= "UNKNOW" then
    --     self:chooseView(PnlUnion.VIEW_CREATUNION, true)
    -- else
    --     gg.uiManager:showTip(Utils.getText("chain_Tips_UnboundCannotCreate"))
    -- end
end

function PnlUnion:onBtnInvite()
    self:chooseView(PnlUnion.VIEW_UNIONINVITE, true)
    UnionData.C2S_Player_GetUnionInviteList()
end

function PnlUnion:onBtnApplyUnion(unionId)
    local selfChain = PlayerData.chainId
    local unionChain = UnionData.joinableUnionList[unionId].unionChain
    local selfChainName = constant.getNameByChain(selfChain)
    local unionChainName = constant.getNameByChain(unionChain)

    local isSameChain = true
    local txtTips = ""
    -- 5.23 ""
    -- if selfChainName == "NONE" then
    --     isSameChain = false
    --     txtTips = string.format(Utils.getText("chain_Ask_UnboundJoinOrNot"), unionChainName)
    -- elseif selfChain ~= unionChain then
    --     isSameChain = false
    --     txtTips = string.format(Utils.getText("chain_Ask_BoundJoinOrNot"), selfChainName, unionChainName)
    -- end

    if isSameChain then
        UnionData.C2S_Player_JoinUnion(unionId)
    else
        local args = {
            txtTitel = Utils.getText("universal_Ask_Title"),
            txtTips = txtTips,
            txtYes = Utils.getText("universal_ConfirmButton"),
            txtNo = Utils.getText("universal_Ask_BackButton"),
            callbackYes = function()
                UnionData.C2S_Player_JoinUnion(unionId)
            end
        }
        gg.uiManager:openWindow("PnlAlertNew", args)

    end
end

function PnlUnion:onVisitUnion(args, unionData)
    self.unionData = unionData
    self:chooseView(PnlUnion.VIEW_UNIONOTHER, true)
end

------------------------------VIEW_CREATUNION------------------------------
------------------------------VIEW_EDITO------------------------------
-- type: VIEW_CREATUNION = 1; VIEW_EDITO = 2
function PnlUnion:setViewCreatUnion(type, isResetView)
    self.creatOrEdito = type
    self.view.txtFlagName.text = Utils.getText(self.flagCfg[self.selelctFlag].languageNameID)
    if type == 1 then
        self.view.txtCreateTitle.text = Utils.getText("guild_Create_Title")
        self.view.btnConfirmCreare.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
            "guild_Create_Title")

        self.view.inputFieldUnionName.interactable = true
    else
        self.view.txtCreateTitle.text = Utils.getText("guild_Edit_Title")
        self.view.btnConfirmCreare.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
            "guild_Edit_EditButton")
        -- self.view.inputFieldUnionName.interactable = false

        if isResetView then
            self.view.inputFieldUnionName.text = self.unionData.unionName
            self.view.inputFieldNotice.text = self.unionData.unionNotice
            self.view.inputFieldSharing.text = self.unionData.unionSharing

            if self.unionData.enterType == 0 then
                self.view.toggleEvery.isOn = true

            elseif self.unionData.enterType == 1 then
                self.view.toggleNeed.isOn = true

            elseif self.unionData.enterType == 2 then
                self.view.toggleNot.isOn = true

            end
        end

    end

    local icon = gg.getSpriteAtlasName("ContryFlag_Atlas", self.flagCfg[self.selelctFlag].icon)
    gg.setSpriteAsync(self.view.iconFlag, icon)

    -- 5.23 ""
    -- if type == 1 then
    --     -- PlayerData.C2S_Player_QueryWallet()
    --     self:onRefreshImgChainInCreatUnion(PlayerData.chainId)
    --     local CreateDAONeedTesseract = cfg.global.CreateDAONeedTesseract.intValue / 1000
    --     self.view.txtCreatCost.text = string.format("%.0f", CreateDAONeedTesseract)
    --     self.view.txtCreatCost.gameObject:SetActiveEx(true)
    -- else
    --     self:onRefreshImgChainInCreatUnion(self.unionData.unionChain)
    --     self.view.txtCreatCost.gameObject:SetActiveEx(false)
    -- end

end

function PnlUnion:onRefreshImgChainInCreatUnion(chainId)
    self.view.imgChain.color = Color.New(1, 1, 1, 0)
    self:setChainImg(self.view.imgChain, chainId)
end

function PnlUnion:onBtnCloseCreateUnion()
    if self.creatOrEdito == 1 then
        self:chooseView(PnlUnion.VIEW_UNIONLIST)

    elseif self.creatOrEdito == 2 then
        self:chooseView(PnlUnion.VIEW_UNIONMAIN, true)

    end

end

function PnlUnion:onBtnSetFlag()
    self:chooseView(PnlUnion.VIEW_CHANGEFLAGS)
end

function PnlUnion:onBtnConfirmCreare()
    local unionName = self.view.inputFieldUnionName.text
    local unionNotice = self.view.inputFieldNotice.text
    local unionFlag = self.selelctFlag
    local enterType = 0
    local unionSharing = self.view.inputFieldSharing.text
    local globalCfg = cfg.global
    if unionName == "" then
        gg.uiManager:showTip("not DAO name")
        return
    end
    if self.view.toggleEvery.isOn then
        enterType = 0
    elseif self.view.toggleNeed.isOn then
        enterType = 1
    elseif self.view.toggleNot.isOn then
        enterType = 2
    end
    if self.creatOrEdito == 1 then
        local txtTitel = Utils.getText("universal_Ask_Title")
        local txtTips = string.format("%s\n<color=#FF0000><size=28>%s</size></color>",
            Utils.getText("guild_Create_AskText"), Utils.getText("guild_Create_TipsText"))
        local txtNo = Utils.getText("universal_Ask_BackButton")
        local txtYes = Utils.getText("universal_DetermineButton")

        local args = {
            txtTitel = txtTitel,
            txtTips = txtTips,
            txtYes = txtYes,
            callbackYes = function()
                UnionData.C2S_Player_CreateUnion(unionName, unionNotice, unionFlag, enterType, 0, unionSharing)
            end,
            txtNo = txtNo,
            yesCost = {{
                resId = constant.RES_TESSERACT,
                count = globalCfg.CreateDAONeedTesseract.intValue
            }}
        }
        gg.uiManager:openWindow("PnlAlertNew", args)

    elseif self.creatOrEdito == 2 then
        local unionId = self.unionData.unionId
        local oldName = self.unionData.unionName
        if oldName == unionName then
            UnionData.C2S_Player_ModifyUnionInfo(unionId, unionFlag, enterType, 0, unionSharing, unionNotice, unionName)
        else
            local callbackYes = function()
                UnionData.C2S_Player_ModifyUnionInfo(unionId, unionFlag, enterType, 0, unionSharing, unionNotice,
                    unionName)
            end
            local unionChangeNameCost = globalCfg.UnionChangeNameCost.tableValue
            local txt = string.format(Utils.getText("name_Change_Ask"), Utils.getShowRes(unionChangeNameCost[2]))
            gg.uiManager:openWindow("PnlAlert", {
                callbackYes = callbackYes,
                txt = txt,
                yesCostList = {{
                    cost = unionChangeNameCost[2],
                    resId = unionChangeNameCost[1]
                }}
            })

        end
    end

end

------------------------------VIEW_UNIONMAIN------------------------------

function PnlUnion:setViewUnionMain()
    self.view.txtTitle.text = Utils.getText("guild_MyDao")
    local flag = self.selelctFlag
    if self.flagCfg[self.unionData.unionFlag] then
        flag = self.unionData.unionFlag
    end
    local icon = gg.getSpriteAtlasName("ContryFlag_Atlas", self.flagCfg[flag].icon)
    gg.setSpriteAsync(self.view.iconInfoFlag, icon)

    local chain = self.unionData.unionChain
    self.view.imgChainMain.gameObject:SetActiveEx(false)
    -- 5.23 ""
    -- self:setChainImg(self.view.imgChainMain, chain)

    self.view.txtInfoUnionName.text = self.unionData.unionName
    self.view.txtInfoUnionId.text = self.unionData.unionId
    self.view.txtPresident.text = self.unionData.presidentName
    self.view.txtMember.text = self.unionData.memberCount .. "/" .. self.unionData.memberMax
    self.view.txtPlots.text = self.unionData.plots .. "/" .. cfg.global.GridUnionMax.intValue
    local unionLevel = self.unionData.unionLevel
    self.view.txtGrade.text = unionLevel

    local maxExp = cfg.daoLevel[unionLevel].levelUpNeedExp or 1
    local exp = self.unionData.exp or 0
    local expPancent = exp / maxExp

    if expPancent > 1 or expPancent < 0 then
        expPancent = 0
    end

    self.view.expSlider.fillAmount = expPancent
    -- self.view.txtArtifact.text = 0

    -- self.view.txtPower.text = self.unionData.fightPower or 0
    -- self.view.txtDistribution.text = string.format("%s%%:%s%%", self.unionData.unionSharing,
    --     100 - self.unionData.unionSharing)

    self.view.txtMainNotice.text = self.unionData.unionNotice

    -- self.view.txtStarCoin.text = Utils.scientificNotationInt(self.unionData.starCoin / 1000) .. "/" ..
    --                                  Utils.scientificNotationInt(self.unionData.starCoinLimit / 1000)
    -- self.view.txtTitanium.text = Utils.scientificNotationInt(self.unionData.titanium / 1000) .. "/" ..
    --                                  Utils.scientificNotationInt(self.unionData.titaniumLimit / 1000)
    -- self.view.txtIce.text = Utils.scientificNotationInt(self.unionData.ice / 1000) .. "/" ..
    --                             Utils.scientificNotationInt(self.unionData.iceLimit / 1000)
    -- self.view.txtGas.text = Utils.scientificNotationInt(self.unionData.gas / 1000) .. "/" ..
    --                             Utils.scientificNotationInt(self.unionData.gasLimit / 1000)

    self.view.txtPoints.text = self.unionData.score
    local txtRanking = Utils.getText("guild_NotListed")
    if self.unionData.rank ~= 0 then
        txtRanking = self.unionData.rank
    end
    self.view.txtRanking.text = txtRanking
    self.view.txtTotelHy.text = Utils.scientificNotationInt(self.unionData.carboxyl / 1000)
    self.view.txtHyHour.text = Utils.scientificNotation(self.unionData.gridOutput / 1000)

    self.view.txtNftTower.text = self.unionData.nftDefenseNum
    self.view.txtHero.text = self.unionData.nftHeroNum
    self.view.txtWarship.text = self.unionData.nftShipNum

    self.selfUnionJod = {}
    for k, v in pairs(self.daoPositionCfg) do
        if v.accessLevel == UnionData.myUnionJod then
            self.selfUnionJod = v
            break
        end
    end
    if self.selfUnionJod.isEdit == 1 then
        self.view.btnEdito:SetActiveEx(true)
        self.view.btnEditoNotice:SetActiveEx(true)
    else
        self.view.btnEdito:SetActiveEx(false)
        self.view.btnEditoNotice:SetActiveEx(false)
    end
end

function PnlUnion:onBtnCopy()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = self.unionData.unionId-
    gg.uiManager:showTip(Utils.getText("information_CopyID"))
end

function PnlUnion:onBtnEdito()
    self.selelctFlag = self.unionData.unionFlag
    self:chooseView(PnlUnion.VIEW_EDITO, true)

end

PnlUnion.NOTICEMAXBYTES = 140

function PnlUnion:onBtnEditoNotice()
    self.view.noticeInputBg:SetActiveEx(true)
    self.view.txtMainNotice:SetActiveEx(false)
    self.view.txtNoticeTips.text = string.format(Utils.getText("universal_BytesTips"), 0, PnlUnion.NOTICEMAXBYTES)

    self.view.noticeInput.onValueChanged:AddListener(gg.bind(self.checkInputNum, self))
end

function PnlUnion:checkInputNum()
    local text = self.view.noticeInput.text
    local len = string.len(text)
    if len > PnlUnion.NOTICEMAXBYTES then
        local newText = string.sub(text, 1, PnlUnion.NOTICEMAXBYTES)
        len = string.len(newText)
        self.view.noticeInput.text = newText
    end
    self.view.txtNoticeTips.text = string.format(Utils.getText("universal_BytesTips"), len, PnlUnion.NOTICEMAXBYTES)
end

function PnlUnion:onEditoNotice()
    self.view.noticeInputBg:SetActiveEx(false)
    self.view.txtMainNotice:SetActiveEx(true)
    local unionId = self.unionData.unionId
    local unionName = self.unionData.unionName
    local unionNotice = self.view.noticeInput.text
    local unionFlag = self.unionData.unionFlag
    local enterType = 0
    local unionSharing = self.unionData.unionSharing

    UnionData.C2S_Player_ModifyUnionInfo(unionId, unionFlag, enterType, 0, unionSharing, unionNotice, unionName)
    self.view.noticeInput.onValueChanged:RemoveAllListeners()
end

function PnlUnion:onBtnWarReport()
    gg.uiManager:openWindow("PnlUnionWarReport", BattleData.BATTLE_TYPE_RES_PLANNET)
    -- UnionData.C2S_Player_QueryUnionStarmapCampaignReports(1, 5)
end

function PnlUnion:onBtnWarehouse()
    UnionData.C2S_Player_QueryUnionRes()
    self.isUpdateSolidersData = true
    self.isUpdateBuildsData = true
    self.isUpdateNftsData = true
end

function PnlUnion:onBtnPlot()
    gg.uiManager:openWindow("PnlStarMapPlot", {
        type = PnlStarMapPlot.TYPE_UNION,
        jumpCloseView = self
    })
    -- gg.uiManager:openWindow("PnlStarMapPlot", {type = PnlStarMapPlot.TYPE_PERSON, jumpCloseView = self})
end

function PnlUnion:onBtnMint()
    gg.uiManager:openWindow("PnlMintInfo")
end

function PnlUnion:onBtnNft()
    gg.uiManager:openWindow("PnlUnionNft")
end

function PnlUnion:onBtnMemberMian()
    UnionData.C2S_Player_QueryUnionMembers()

end

function PnlUnion:onBtnScience()
    UnionData.C2S_Player_QueryUnionTechs()
end

function PnlUnion:onBtnFacilities()

end

------------------------------VIEW_UNIONOTHER------------------------------

function PnlUnion:setViewUnionOther()
    local flag = self.selelctFlag
    if self.flagCfg[self.unionData.unionFlag] then
        flag = self.unionData.unionFlag
    end
    local icon = gg.getSpriteAtlasName("ContryFlag_Atlas", self.flagCfg[flag].icon)
    gg.setSpriteAsync(self.view.iconOtherInfoFlag, icon)

    self.view.txtOtherInfoUnionName.text = self.unionData.unionName
    self.view.txtOtherInfoUnionId.text = self.unionData.unionId
    self.view.txtOtherPresident.text = self.unionData.presidentName
    self.view.txtOtherMember.text = self.unionData.memberCount .. "/" .. self.unionData.memberMax
    self.view.txtOtherArtifact.text = 0
    self.view.txtOtherPoints.text = self.unionData.matchScore or 0
    self.view.txtOtherPower.text = self.unionData.fightPower or 0
    self.view.txtOtherDistribution.text = string.format("%s%%:%s%%", self.unionData.unionSharing,
        100 - self.unionData.unionSharing)

    self.view.txtOtherNotice.text = self.unionData.unionNotice

    local chain = self.unionData.unionChain
    self.view.ImgChainOther.gameObject:SetActiveEx(false)
    self:setChainImg(self.view.ImgChainOther, chain)

    if self.unionData.enterType == 0 then
        gg.setSpriteAsync(self.view.btnOtherJoin.transform:GetComponent(UNITYENGINE_UI_IMAGE),
            "Button_Atlas[Button_icon_B]")
        self.view.btnOtherJoin.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
            "guild_Join")
        self.view.btnOtherJoin.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(1, 245 / 255,
            79 / 255, 1)

    elseif self.unionData.enterType == 1 then
        gg.setSpriteAsync(self.view.btnOtherJoin.transform:GetComponent(UNITYENGINE_UI_IMAGE),
            "Button_Atlas[Button_icon_C]")
        self.view.btnOtherJoin.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
            "guild_Request")
        self.view.btnOtherJoin.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(13 / 255,
            221 / 255, 1, 1)

    end
end

function PnlUnion:onBtnOtherClose()
    self:chooseView(PnlUnion.VIEW_UNIONLIST)
end

------------------------------VIEW_UNIONMEMBER------------------------------

PnlUnion.UnionJodName = constant.TXT_DAO_DUTY

function PnlUnion:setViewMember()
    self:releaseBoxMember()
    local parent = self.view.viewUnionMember.transform:Find("ScrollViewMember/Viewport/Content")
    local sortList = {}

    local selfUnionJod = 0
    for k, v in pairs(UnionData.members) do
        local playerId = v.playerId
        local sort = v.unionJob * 1000000000 + v.fightPower
        table.insert(sortList, {
            playerId = playerId,
            sort = sort
        })
        if playerId == self.playerId then
            selfUnionJod = v.unionJob
        end
    end

    QuickSort.quickSort(sortList, "sort", 1, #sortList)

    local unionJodCfg = nil

    for k, v in pairs(self.daoPositionCfg) do
        if v.accessLevel == selfUnionJod then
            selfUnionJod = v
            break
        end
    end

    if selfUnionJod.isPersonnel == 1 then
        self.view.btnApplyList:SetActiveEx(true)
        self.view.btnInviteMember:SetActiveEx(true)
    else
        self.view.btnApplyList:SetActiveEx(false)
        self.view.btnInviteMember:SetActiveEx(false)
    end

    local getOnlineType = function(online)
        if online == 0 then
            return Utils.getText("guild_Memner_Online")
        end
        local sec = Utils.getServerSec() - online
        local time = gg.time.dhms_time({
            day = 1,
            hour = 1,
            min = false,
            sec = false
        }, sec)
        if time.day <= 0 then
            if time.hour <= 0 then
                return Utils.getText("guild_Memner_OnlineOneHour")
            else
                return string.format(Utils.getText("guild_Memner_OnlineOneAnd24Hour"), time.hour)
            end
        else
            return string.format(Utils.getText("guild_Memner_Online24HourAgo"), time.day)
        end
    end

    for k, v in pairs(sortList) do
        ResMgr:LoadGameObjectAsync("BoxMember", function(go)
            go.transform:SetParent(parent, false)

            local data = UnionData.members[v.playerId]
            local member = data.playerName
            local contriDegree = data.contriDegree or 0
            local combatVal = data.combatVal / 1000
            local online = data.offline
            local land = data.grids
            local position = data.unionJob
            local chain = data.chain

            go.transform:Find("TxtMember"):GetComponent(UNITYENGINE_UI_TEXT).text = member
            go.transform:Find("TxtContri"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(
                contriDegree)
            go.transform:Find("TxtCombatVal"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(
                combatVal, true)
            go.transform:Find("Txtland"):GetComponent(UNITYENGINE_UI_TEXT).text = land
            go.transform:Find("TitelOnline"):GetComponent(UNITYENGINE_UI_TEXT).text = getOnlineType(online)
            go.transform:Find("TxtPosition"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                PnlUnion.UnionJodName[position])

            go.transform:Find("ImgChain").gameObject:SetActiveEx(false)
            self:setChainImg(go.transform:Find("ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE), chain)

            local goOptions = go.transform:Find("Options").gameObject

            if data.online then
                go.transform:Find("TxtMember"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x2d / 0xff,
                    0xbc / 0xff, 0xff / 0xff)

            else
                go.transform:Find("TxtMember"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0xff / 0xff,
                    0xff / 0xff, 0xff / 0xff)
            end

            ----------------------------------------------------------------------------------------------------------
            if data.playerId == self.playerId then
                -- ""
                go.transform:Find("TxtMember/Image").gameObject:SetActiveEx(true)
                go.transform:Find("TxtMember"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x4c / 0xff,
                    0xff / 0xff, 0x1c / 0xff)

                goOptions.transform:Find("Options/BtnVisit").gameObject:SetActiveEx(false)
                goOptions.transform:Find("Options/BtnAppoint").gameObject:SetActiveEx(false)
                goOptions.transform:Find("Options/BtnQuit").gameObject:SetActiveEx(true)

                if selfUnionJod.isOutgoing == 1 then
                    -- ""
                    goOptions.transform:Find("Options/BtnQuit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        Utils.getText("guild_Member_Alert_Outgoing")

                    CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnQuit").gameObject):SetOnClick(function()
                        self:onBtnEditUnionJob(self.selelctPlayerId, 0, 4)
                    end)
                else
                    -- ""
                    goOptions.transform:Find("Options/BtnQuit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        Utils.getText("guild_Member_Alert_Quit")

                    CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnQuit").gameObject):SetOnClick(function()
                        self:onBtnMemberQuit(self.unionData.unionId, data.playerId, data.playerName,
                            selfUnionJod.accessLevel)
                    end)
                end

                goOptions.transform:Find("BgOptions"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta =
                    Vector2.New(141, 72)
            else
                -- ""
                go.transform:Find("TxtMember/Image").gameObject:SetActiveEx(false)
                -- go.transform:Find("TxtMember"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0xff / 0xff,
                --     0xff / 0xff, 0xff / 0xff)

                goOptions.transform:Find("Options/BtnVisit").gameObject:SetActiveEx(true)
                goOptions.transform:Find("Options/BtnAppoint").gameObject:SetActiveEx(false)
                goOptions.transform:Find("Options/BtnQuit").gameObject:SetActiveEx(false)

                local sizeY = 72

                if selfUnionJod.isAppointed == 1 and position == 0 then
                    -- ""
                    sizeY = sizeY + 72

                    goOptions.transform:Find("Options/BtnAppoint").gameObject:SetActiveEx(true)
                    goOptions.transform:Find("Options/BtnAppoint/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        Utils.getText("guild_Member_Alert_Appoint")
                    CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnAppoint").gameObject):SetOnClick(
                        function()
                            self:onBtnMemberAppoint()
                        end)

                elseif selfUnionJod.isTransfer == 1 and position == 8 then
                    -- ""
                    sizeY = sizeY + 72

                    goOptions.transform:Find("Options/BtnAppoint").gameObject:SetActiveEx(true)
                    goOptions.transform:Find("Options/BtnAppoint/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        Utils.getText("guild_Member_Alert_Transfer")

                    CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnAppoint").gameObject):SetOnClick(
                        function()
                            self:onBtnEditUnionJob(self.selelctPlayerId, 9, 1)
                        end)
                end

                if selfUnionJod.isRemove == 1 and selfUnionJod.accessLevel > position and position > 0 then
                    -- ""
                    sizeY = sizeY + 72

                    goOptions.transform:Find("Options/BtnQuit").gameObject:SetActiveEx(true)
                    goOptions.transform:Find("Options/BtnQuit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        Utils.getText("guild_Member_Alert_Retire")

                    CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnQuit").gameObject):SetOnClick(function()
                        self:onBtnEditUnionJob(self.selelctPlayerId, 0, 3)
                    end)

                elseif selfUnionJod.isKickOut == 1 and selfUnionJod.accessLevel > position then
                    -- ""
                    sizeY = sizeY + 72

                    goOptions.transform:Find("Options/BtnQuit").gameObject:SetActiveEx(true)
                    goOptions.transform:Find("Options/BtnQuit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        Utils.getText("guild_Member_Alert_KickOut")

                    CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnQuit").gameObject):SetOnClick(function()
                        self:onBtnMemberQuit(self.unionData.unionId, data.playerId, data.playerName)
                    end)

                end

                goOptions.transform:Find("BgOptions"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta =
                    Vector2.New(141, sizeY)

            end

            goOptions:SetActiveEx(false)

            CS.UIEventHandler.Get(go.transform:Find("BtnMember").gameObject):SetOnClick(function()
                self:onBtnBoxMember(goOptions, data)
            end)
            CS.UIEventHandler.Get(goOptions.transform:Find("Options/BtnVisit").gameObject):SetOnClick(function()
                self:onBtnMemberVisit()
            end)

            ----------------------------------------------------------------------------------------------------------
            table.insert(self.boxMemberList, go)
            return true
        end, true)
    end
end

function PnlUnion:checkPermissions()
    for k, v in pairs(UnionData.members) do
        if v.unionJob == 9 and v.playerId == self.playerId then
            return true
        elseif v.unionJob == 8 and v.playerId == self.playerId then
            return true
        end
    end
    return false
end

function PnlUnion:releaseBoxMember()
    if self.boxMemberList then
        for k, go in pairs(self.boxMemberList) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnMember").gameObject)

            CS.UIEventHandler.Clear(go.transform:Find("Options/Options/BtnVisit").gameObject)
            CS.UIEventHandler.Clear(go.transform:Find("Options/Options/BtnAppoint").gameObject)
            CS.UIEventHandler.Clear(go.transform:Find("Options/Options/BtnQuit").gameObject)

            ResMgr:ReleaseAsset(go)
        end
        self.boxMemberList = {}
    end
end

function PnlUnion:onBtnCloseMember()
    self:chooseView(PnlUnion.VIEW_UNIONMAIN, false)
end

function PnlUnion:onBtnInviteMember()
    self:chooseView(PnlUnion.VIEW_INVITEPLAYER, false)
end

function PnlUnion:onBtnApplyList()
    self:chooseView(PnlUnion.VIEW_UNIONAPPLY, false)

    UnionData.C2S_Player_GetUnionApplyList(self.unionData.unionId)
end

function PnlUnion:onBtnInvitePlayer()
    UnionData.C2S_Player_InviteJoinUnion(self.searchPlayerId, self.unionData.unionId)

end

function PnlUnion:onBtnSearchMember()

end

function PnlUnion:onBtnCycle()

end

function PnlUnion:onBtnMember()

end

function PnlUnion:onBtnBoxMember(goOptions, memberData)
    self.selelctPlayerId = memberData.playerId
    local bool = goOptions.activeSelf

    for k, go in pairs(self.boxMemberList) do
        go.transform:Find("Options").gameObject:SetActiveEx(false)
    end

    goOptions:SetActiveEx(not bool)

end

function PnlUnion:onBtnMemberVisit()
    PlayerData.C2S_Player_UnionVisitFoundation(self.selelctPlayerId)

end

function PnlUnion:onBtnMemberAppoint()
    self:chooseView(PnlUnion.VIEW_UNIONADDPOINT, true)
end

function PnlUnion:onBtnEditUnionJob(playerId, unionJob, editType)
    local unionId = self.unionData.unionId
    local txt = ""

    if editType == 1 then
        -- ""
        txt = Utils.getText("guild_Transfer_Txt")
    elseif editType == 2 then
        -- ""
        txt = string.format(Utils.getText("guild_Appoint_Txt"), Utils.getText(PnlUnion.UnionJodName[unionJob]))
    elseif editType == 3 then
        -- ""
        txt = Utils.getText("guild_StepDown_Txt")
    elseif editType == 4 then
        -- ""
        txt = Utils.getText("guild_Outgoing_Txt")
    end

    local callbackYes = function()
        UnionData.C2S_Player_EditUnionJob(unionId, playerId, unionJob, editType)

        if editType == 2 then
            self:onBtnCloseAddpoint()

        end
    end

    local args = {
        txt = txt,
        callbackYes = callbackYes,
        txtYes = "Confirm"
    }
    gg.uiManager:openWindow("PnlAlert", args)

end

function PnlUnion:onBtnMemberQuit(unionId, playerId, playerName, accessLevel)
    if playerId == self.playerId then
        local txt = Utils.getText("guild_Quit_Txt")
        local callbackYes = function()
            if accessLevel ~= 9 then
                UnionData.C2S_Player_QuitUnion(unionId)
            end
        end
        if accessLevel == 9 then
            txt = Utils.getText("guild_PresidentLeave_Txt")
        else
            local contriDegree = UnionData.members[self.playerId].contriDegree
            local payContriDegree = contriDegree
            if contriDegree >= self.quitUnionLimit then -- self.quitUnionLimit
                payContriDegree = math.ceil(contriDegree / 2)
            end
            local txtContriDegree = string.format("%s(-%s)", Utils.scientificNotation(contriDegree),
                Utils.scientificNotation(payContriDegree))
            txt = string.format(Utils.getText("guild_MemberLeave_Txt") .. "\n" ..
                                    Utils.getText("guild_MemberLeave_ContriTxt") .. txtContriDegree, self.quitUnionCd)
        end

        local args = {
            btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
            bgType = PnlAlert.BG_TYPE_RECYCLE,
            txtYes = Utils.getText("universal_ConfirmButton"),
            txt = txt,
            callbackYes = callbackYes
        }
        gg.uiManager:openWindow("PnlAlert", args)

    else
        local txt = string.format(Utils.getText("guild_KickOut_Txt"), playerName)
        local callbackYes = function()
            UnionData.C2S_Player_TickOutUnion(unionId, playerId)
        end
        local args = {
            btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
            bgType = PnlAlert.BG_TYPE_RECYCLE,
            txtYes = Utils.getText("guild_KickOut_Confirm"),
            txt = txt,
            callbackYes = callbackYes
        }
        gg.uiManager:openWindow("PnlAlert", args)

    end
end

------------------------------VIEW_INVITEPLAYER------------------------------

function PnlUnion:onBtnCloseInvitePlayer()
    self:chooseView(PnlUnion.VIEW_UNIONMEMBER, true)
end

function PnlUnion:onBtnSearchPlayer()
    local playerId = self.view.inputPlayer.text
    UnionData.C2S_Player_SearchPlayer(playerId)
end

function PnlUnion:onShowSearchPlayer(args, playerId, playerName, baseLevel, chain)
    self.view.viewInvitePlayer.transform:Find("BoxApply").gameObject:SetActiveEx(true)
    self.view.viewInvitePlayer.transform:Find("BoxApply/TxtlPlayerName"):GetComponent(UNITYENGINE_UI_TEXT).text =
        playerName
    self.view.viewInvitePlayer.transform:Find("BoxApply/TxtBaseLevel"):GetComponent(UNITYENGINE_UI_TEXT).text =
        baseLevel
    self.view.viewInvitePlayer.transform:Find("BoxApply/ImgChain").gameObject:SetActiveEx(false)
    self:setChainImg(self.view.viewInvitePlayer.transform:Find("BoxApply/ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE),
        chain)

    self.searchPlayerId = playerId
end

------------------------------VIEW_UNIONAPPLY------------------------------

function PnlUnion:setViewApply()
    self:releaseBoxApply()
    local parent = self.view.viewUnionApply.transform:Find("ScrollViewApplyList/Viewport/Content")
    for k, v in pairs(UnionData.playerApplyList) do
        ResMgr:LoadGameObjectAsync("BoxApply", function(go)
            go.transform:SetParent(parent, false)
            local playerName = v.playerName
            local baseLevel = v.baseLevel
            local chain = v.chain
            go.transform:Find("TxtlPlayerName"):GetComponent(UNITYENGINE_UI_TEXT).text = playerName
            go.transform:Find("TxtBaseLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = baseLevel
            go.transform:Find("ImgChain").gameObject:SetActiveEx(false)
            self:setChainImg(go.transform:Find("ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE), chain)

            CS.UIEventHandler.Get(go.transform:Find("BtnAgree").gameObject):SetOnClick(function()
                self:onBtnPlayerApplyAnswer(1, v.playerId)
            end)
            CS.UIEventHandler.Get(go.transform:Find("BtnRefused").gameObject):SetOnClick(function()
                self:onBtnPlayerApplyAnswer(2, v.playerId)
            end)

            table.insert(self.boxApplyList, go)
            return true
        end, true)

    end
end

function PnlUnion:releaseBoxApply()
    if self.boxApplyList then
        for k, go in pairs(self.boxApplyList) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnAgree").gameObject)
            CS.UIEventHandler.Clear(go.transform:Find("BtnRefused").gameObject)

            ResMgr:ReleaseAsset(go)
        end
        self.boxApplyList = {}
    end
end

function PnlUnion:onBtnCloseUnionApply()
    self:chooseView(PnlUnion.VIEW_UNIONMEMBER, false)
end

function PnlUnion:onBtnClearApply()
    UnionData.C2S_Player_UnionClearAllApply()
end

function PnlUnion:onBtnPlayerApplyAnswer(answer, playerId)
    local unionId = self.unionData.unionId
    UnionData.C2S_Player_JoinUnionAnswer(answer, playerId, unionId)
end

------------------------------VIEW_UNIONINVITE------------------------------

function PnlUnion:setViewInvite()
    self:releaseBoxUnionInvite()
    if UnionData.unionInviteList then
        local parent = self.view.viewUnionInvite.transform:Find("ScrollViewUnionInvite/Viewport/Content")
        for k, v in pairs(UnionData.unionInviteList) do
            ResMgr:LoadGameObjectAsync("BoxUnionInvite", function(go)
                go.transform:SetParent(parent, false)

                go.transform:Find("TxtUnionName"):GetComponent(UNITYENGINE_UI_TEXT).text = v.union.unionName
                go.transform:Find("TxtInviter"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                    "guild_Invite_InvitePeople") .. ": " .. v.invitePlayer.playerName
                go.transform:Find("TxtForces"):GetComponent(UNITYENGINE_UI_TEXT).text = v.union.fightPower
                go.transform:Find("TxtPeople"):GetComponent(UNITYENGINE_UI_TEXT).text = v.union.memberCount .. "/" ..
                                                                                            v.union.memberMax

                local icon = gg.getSpriteAtlasName("ContryFlag_Atlas", self.flagCfg[v.union.unionFlag].icon)
                gg.setSpriteAsync(go.transform:Find("IconFlag"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

                local chain = v.union.unionChain
                go.transform:Find("ImgChain").gameObject:SetActiveEx(false)
                self:setChainImg(go.transform:Find("ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE), chain)

                CS.UIEventHandler.Get(go.transform:Find("BtnAgree").gameObject):SetOnClick(function()
                    self:onBtnPlayerInviteAnswer(1, v.union.unionId)
                end)
                CS.UIEventHandler.Get(go.transform:Find("BtnDisagree").gameObject):SetOnClick(function()
                    self:onBtnPlayerInviteAnswer(2, v.union.unionId)
                end)

                table.insert(self.boxUnionInviteList, go)
                return true
            end, true)
        end
    end
end

function PnlUnion:releaseBoxUnionInvite()
    if self.boxUnionInviteList then
        for k, go in pairs(self.boxUnionInviteList) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnAgree").gameObject)
            CS.UIEventHandler.Clear(go.transform:Find("BtnDisagree").gameObject)

            ResMgr:ReleaseAsset(go)
        end
        self.boxUnionInviteList = {}

    end
end

function PnlUnion:onBtnClearInvite()
    for k, v in pairs(UnionData.unionInviteList) do
        self:onBtnPlayerInviteAnswer(2, v.union.unionId)
    end
end

function PnlUnion:onBtnCloseInvite()
    self:chooseView(PnlUnion.VIEW_UNIONLIST)
end

function PnlUnion:onBtnPlayerInviteAnswer(answer, unionId)
    UnionData.C2S_Player_AnswerUnionInvite(unionId, answer)
end

------------------------------VIEW_UNIONADDPOINT------------------------------

function PnlUnion:setViewAddpopint()
    self:releaseViewAddpopint()
    local president = ""
    local vicePresi = {}
    local commander = {}
    local selfPos = 0

    for k, v in pairs(UnionData.members) do
        if v.unionJob == 9 then
            president = v.playerName
        elseif v.unionJob == 8 then
            table.insert(vicePresi, v.playerName)
        elseif v.unionJob == 7 then
            table.insert(commander, v.playerName)
        end

        if v.playerId == self.playerId then
            selfPos = v.unionJob
        end
    end
    local content = self.view.viewUnionAddpoint.transform:Find("ScrollView/Viewport/Content")

    for k, v in pairs(self.daoPositionCfg) do
        if v.accessLevel > 0 then
            local maxCound = v.maxCound

            for i = 1, maxCound, 1 do
                ResMgr:LoadGameObjectAsync("BoxAddpoint", function(go)
                    go.transform:SetParent(content, false)

                    go.transform:Find("TxtlPosition"):GetComponent(UNITYENGINE_UI_TEXT).text = v.name
                    if v.accessLevel == 9 then
                        go.transform:Find("TxtlPlayerName"):GetComponent(UNITYENGINE_UI_TEXT).text = president
                        go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(true)
                        go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(false)
                    elseif v.accessLevel == 8 then
                        if vicePresi[i] then
                            go.transform:Find("TxtlPlayerName"):GetComponent(UNITYENGINE_UI_TEXT).text = vicePresi[i]
                            go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(true)
                            go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(false)

                        else
                            if selfPos > v.accessLevel then
                                go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(false)
                                go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(true)
                            else
                                go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(false)
                                go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(false)

                            end
                        end
                    elseif v.accessLevel == 7 then
                        if commander[i] then
                            go.transform:Find("TxtlPlayerName"):GetComponent(UNITYENGINE_UI_TEXT).text = commander[i]
                            go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(true)
                            go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(false)

                        else
                            if selfPos > v.accessLevel then
                                go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(false)
                                go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(true)
                            else
                                go.transform:Find("TxtlPlayerName").gameObject:SetActiveEx(false)
                                go.transform:Find("BtnAddpoint").gameObject:SetActiveEx(false)

                            end
                        end
                    end

                    CS.UIEventHandler.Get(go.transform:Find("BtnAddpoint").gameObject):SetOnClick(function()
                        self:onBtnEditUnionJob(self.selelctPlayerId, v.accessLevel, 2)
                    end)

                    table.insert(self.boxAddpointList, go)
                    return true
                end, true)
            end
        end
    end

end

function PnlUnion:releaseViewAddpopint()
    if self.boxAddpointList then
        for k, go in pairs(self.boxAddpointList) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnAddpoint").gameObject)

            ResMgr:ReleaseAsset(go)
        end
        self.boxAddpointList = {}
    end
end

function PnlUnion:onBtnCloseAddpoint()
    self:chooseView(PnlUnion.VIEW_UNIONMEMBER, true)
    self:releaseViewAddpopint()
end

------------------------------VIEW_UNIONWAREHOUSE------------------------------

function PnlUnion:onBtnWarehouseDesc()
    gg.uiManager:openWindow("PnlDesc", {
        title = Utils.getText(self.WarehouseDescTitle),
        desc = Utils.getText(self.WarehouseDescContent)
    })
end

function PnlUnion:setViewUnionWarehouse()
    self:onChangeWarehouseType(self.warehouseView)
    self.donateRes = {}
end

PnlUnion.warehouseBtnIconName = {
    [PnlUnion.WAREHOUSE_RES] = "resource_icon_",
    [PnlUnion.WAREHOUSE_SOLIDIER] = "soldier_icon_",
    [PnlUnion.WAREHOUSE_TOWER] = "tower_icon_",
    [PnlUnion.WAREHOUSE_DAO] = "nft_icon_"
}

PnlUnion.warehouseTitle = {
    [PnlUnion.WAREHOUSE_RES] = "guide_ResWarehouse_Title",
    [PnlUnion.WAREHOUSE_SOLIDIER] = "guide_SoldierWarehouse_Title",
    [PnlUnion.WAREHOUSE_TOWER] = "guide_DefenseWarehouse_Title",
    [PnlUnion.WAREHOUSE_DAO] = "guild_Warehouse_DaoArtifact"
}

function PnlUnion:onChangeWarehouseType(type)
    self.view.txtUnionWarehouseTitle.text = Utils.getText(PnlUnion.warehouseTitle[type])
    self.warehouseView = type

    self.view.btnWarehouseDesc:SetActiveEx(false)

    for i = 1, #self.view.warehouseBtnIcon, 1 do
        local parentImage = self.view.warehouseBtnIcon[i].transform.parent:GetComponent(UNITYENGINE_UI_IMAGE)
        local icon = self.view.warehouseBtnIcon[i]
        icon.transform:SetActiveEx(false)
        local text = self.view.warehouseBtnText[i]
        if type == i then
            -- local iconName = gg.getSpriteAtlasName("Union_Atlas", PnlUnion.warehouseBtnIconName[i] .. "B")
            -- gg.setSpriteAsync(icon, iconName)
            text.color = Color.New(1, 1, 1, 1)
            parentImage.enabled = true
        else
            -- local iconName = gg.getSpriteAtlasName("Union_Atlas", PnlUnion.warehouseBtnIconName[i] .. "A")
            -- gg.setSpriteAsync(icon, iconName)
            text.color = Color.New(61 / 255, 151 / 255, 1, 1)
            parentImage.enabled = false
        end
    end
    if type == PnlUnion.WAREHOUSE_RES then
        self.view.sliderWarehouseResObj:SetActiveEx(false)
        self:setViewWarehouseRes()
    elseif type == PnlUnion.WAREHOUSE_SOLIDIER then
        self.view.sliderWarehouseResObj:SetActiveEx(true)
        self.isUpdateSolidersData = false
        self:setViewWarehouseTrain(1)
    elseif type == PnlUnion.WAREHOUSE_TOWER then
        self.view.sliderWarehouseResObj:SetActiveEx(true)
        self.isUpdateBuildsData = false
        self:setViewWarehouseTrain(2)
    elseif type == PnlUnion.WAREHOUSE_DAO then
        self.view.sliderWarehouseResObj:SetActiveEx(false)
        self:setViewWarehouseDao()

        self.view.btnWarehouseDesc:SetActiveEx(true)
        self.WarehouseDescTitle = "universal_RulesTitle"
        self.WarehouseDescContent = "guild_DaoArtifact_RulesTxt"
    end

    for k, v in pairs(self.view.sliderWarehouseRes) do
        v:Find("TxtCost").gameObject:SetActiveEx(false)
    end

    self.view.sliderWarehouseRes[constant.RES_STARCOIN]:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT)
        .text = Utils.scientificNotationInt(self.unionData.starCoin / 1000) .. "/" ..
                    Utils.scientificNotationInt(self.unionData.starCoinLimit / 1000)
    self.view.sliderWarehouseRes[constant.RES_STARCOIN]:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER)
        .value = self.unionData.starCoin / self.unionData.starCoinLimit
    self.view.sliderWarehouseRes[constant.RES_STARCOIN]:Find("SliderWarehouse/Slider"):GetComponent(
        UNITYENGINE_UI_SLIDER).value = self.unionData.starCoin / self.unionData.starCoinLimit

    self.view.sliderWarehouseRes[constant.RES_ICE]:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
        Utils.scientificNotationInt(self.unionData.ice / 1000) .. "/" ..
            Utils.scientificNotationInt(self.unionData.iceLimit / 1000)
    self.view.sliderWarehouseRes[constant.RES_ICE]:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER).value =
        self.unionData.ice / self.unionData.iceLimit
    self.view.sliderWarehouseRes[constant.RES_ICE]:Find("SliderWarehouse/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
        .value = self.unionData.ice / self.unionData.iceLimit

    self.view.sliderWarehouseRes[constant.RES_TITANIUM]:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT)
        .text = Utils.scientificNotationInt(self.unionData.titanium / 1000) .. "/" ..
                    Utils.scientificNotationInt(self.unionData.titaniumLimit / 1000)
    self.view.sliderWarehouseRes[constant.RES_TITANIUM]:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER)
        .value = self.unionData.titanium / self.unionData.titaniumLimit
    self.view.sliderWarehouseRes[constant.RES_TITANIUM]:Find("SliderWarehouse/Slider"):GetComponent(
        UNITYENGINE_UI_SLIDER).value = self.unionData.titanium / self.unionData.titaniumLimit

    self.view.sliderWarehouseRes[constant.RES_GAS]:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
        Utils.scientificNotationInt(self.unionData.gas / 1000) .. "/" ..
            Utils.scientificNotationInt(self.unionData.gasLimit / 1000)
    self.view.sliderWarehouseRes[constant.RES_GAS]:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER).value =
        self.unionData.gas / self.unionData.gasLimit
    self.view.sliderWarehouseRes[constant.RES_GAS]:Find("SliderWarehouse/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
        .value = self.unionData.gas / self.unionData.gasLimit

    self.view.sliderWarehouseRes[constant.RES_CARBOXYL]:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT)
        .text = Utils.scientificNotationInt(self.unionData.carboxyl / 1000)

end

function PnlUnion:setViewWarehouseRes()
    self.view.warhouseRes:SetActiveEx(true)
    self.view.warehouseTrain:SetActiveEx(false)
    self.view.warehouseDao:SetActiveEx(false)

    local unionResFree = {
        [constant.RES_STARCOIN] = self.unionData.starCoinLimit - self.unionData.starCoin,
        [constant.RES_TITANIUM] = self.unionData.titaniumLimit - self.unionData.titanium,
        [constant.RES_ICE] = self.unionData.iceLimit - self.unionData.ice,
        [constant.RES_GAS] = self.unionData.gasLimit - self.unionData.gas,
        [constant.RES_CARBOXYL] = -1
    }

    self.resScrollbarTotalNum = {}

    for k, v in pairs(self.view.resScrollbar) do
        v:Find("ResTitel/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT).text = "0"
        v:Find("Scrollbar"):GetComponent(UNITYENGINE_UI_SCROLLBAR).value = 0
        if ResData.getRes(k) <= unionResFree[k] then
            self.resScrollbarTotalNum[k] = ResData.getRes(k)
        else
            self.resScrollbarTotalNum[k] = unionResFree[k]
        end
        self.resScrollbarTotalNum[k] = self:integer(self.resScrollbarTotalNum[k])
        v:Find("TxtMax"):GetComponent(UNITYENGINE_UI_TEXT).text = self.resScrollbarTotalNum[k] .. "k"
        v:Find("TxtTip").gameObject:SetActiveEx(false)
    end

    -- self.view.txtStarCoinWarrhouse.text = Utils.scientificNotationInt(self.unionData.starCoin / 1000) .. "/" ..
    --                                           Utils.scientificNotationInt(self.unionData.starCoinLimit / 1000)
    -- self.view.txtTitaniumWarrhouse.text = Utils.scientificNotationInt(self.unionData.titanium / 1000) .. "/" ..
    --                                           Utils.scientificNotationInt(self.unionData.titaniumLimit / 1000)
    -- self.view.txtIceWarrhouse.text = Utils.scientificNotationInt(self.unionData.ice / 1000) .. "/" ..
    --                                      Utils.scientificNotationInt(self.unionData.iceLimit / 1000)
    -- self.view.txtGasWarrhouse.text = Utils.scientificNotationInt(self.unionData.gas / 1000) .. "/" ..
    --                                      Utils.scientificNotationInt(self.unionData.gasLimit / 1000)
    self.view.txtHydroxylWarrhouse.text = Utils.scientificNotationInt(self.unionData.carboxyl / 1000)

    self.view.txtContribution.text = Utils.scientificNotation(self.unionData.contriDegree)
    self.view.txtAdd.gameObject:SetActiveEx(false)
end

function PnlUnion:integer(temp)
    local int = temp / 1000000
    int = math.floor(int)
    return int
end

function PnlUnion:setViewWarehouseTrain(type)
    self.view.warhouseRes:SetActiveEx(false)
    self.view.warehouseTrain:SetActiveEx(true)
    self.view.warehouseDao:SetActiveEx(false)

    self.trainType = type

    self:releaseBoxUnionTrain()

    local trainCfg = {}
    if type == 1 then
        local myCfg = cfg["solider"]
        for k, v in pairs(myCfg) do
            if v.belong == 2 and v.level == 1 and Utils.checkUnionsloiderDefenseWhiteList(1, v.cfgId) then
                table.insert(trainCfg, v)
            end
        end
    else
        local myCfg = cfg["build"]
        for k, v in pairs(myCfg) do
            if v.belong == 2 and v.level == 1 and Utils.checkUnionsloiderDefenseWhiteList(2, v.cfgId) then
                table.insert(trainCfg, v)
            end
        end

    end

    local parent = self.view.warehouseTrain.transform:Find("ScrollView/Viewport/Content")

    self.selelctTrainId = nil

    if self.timerTrainList then
        for k, v in pairs(self.timerTrainList) do
            self:stopTimer(v)
        end
    end
    self.timerTrainList = {}

    for k, v in pairs(trainCfg) do
        ResMgr:LoadGameObjectAsync("BoxUnionTrain", function(go)
            go.transform:SetParent(parent, false)
            local icon = ""
            local trainData
            local cfgType = ""
            if type == 1 then
                icon = gg.getSpriteAtlasName("Soldier_A_Atlas", v.icon .. "_A")
                trainData = self.unionData.soliders
                cfgType = "solider"
            else
                icon = gg.getSpriteAtlasName("Build_A_Atlas", v.icon .. "_A")
                trainData = self.unionData.builds
                cfgType = "build"
                go.transform:Find("IconTop").gameObject:SetActiveEx(false)
            end
            go.transform:Find("TrainTick").gameObject:SetActiveEx(false)
            local data = trainData[v.cfgId]
            local myCfg = nil
            if data then
                myCfg = cfg.getCfg(cfgType, v.cfgId, data.level)
            end
            if data and data.level > 0 and myCfg then

                go.transform:Find("Unlock").gameObject:SetActiveEx(false)

                if data.count then -- < myCfg.unionLimit
                    -- go.transform:Find("SliderWarehouse").gameObject:SetActiveEx(true)
                    go.transform:Find("SliderWarehouse").gameObject:SetActiveEx(false)
                    go.transform:Find("Max").gameObject:SetActiveEx(false)
                    ----------------------------------------------------------------------------------------
                    -- ""
                    -- go.transform:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    --     data.count .. "/" .. myCfg.unionLimit

                    -- local percent = data.count / myCfg.unionLimit
                    -- local genPercent = (data.count + data.genCount) / myCfg.unionLimit

                    -- go.transform:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER).value = percent
                    -- go.transform:Find("SliderWarehouse/Slider"):GetComponent(UNITYENGINE_UI_SLIDER).value = genPercent
                    -- go.transform:Find("SliderWarehouse/SliderGreen"):GetComponent(UNITYENGINE_UI_SLIDER).value =
                    --     genPercent
                    -------------------------------------------------------------------------------------------------
                    local tick = data.genTick - os.time()
                    local time = (data.genCount - 1) * myCfg.trainNeedTick + (data.genTick - os.time())
                    if time > 0 then
                        -- go.transform:Find("TrainTick").gameObject:SetActiveEx(true)
                        go.transform:Find("SliderWarehouse").gameObject:SetActiveEx(false)

                        go.transform:Find("TrainTick/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = self:getFormatTick(
                            time)

                        self.timerTrainList[v.cfgId] = self:startLoopTimer(time + os.time(),
                            self.timerTrainList[v.cfgId], go.transform:Find("TrainTick/Text")
                                :GetComponent(UNITYENGINE_UI_TEXT), go.transform:Find("TrainTick").gameObject,
                            function(curTick)
                                local curCount = 0
                                if time - curTick >= tick then
                                    curCount = 1
                                    local count = (time - curTick) / myCfg.trainNeedTick
                                    local num = math.floor(count) + data.count
                                    -------------------------------------------------------------------------------------------------
                                    -- ""
                                    -- go.transform:Find("SliderWarehouse/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                                    --     num .. "/" .. myCfg.unionLimit

                                    -- local percent = num / myCfg.unionLimit

                                    -- go.transform:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER).value =
                                    --     percent
                                    -- go.transform:Find("SliderWarehouse/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
                                    --     .value = percent
                                    -------------------------------------------------------------------------------------------------

                                end
                            end)
                    end
                else
                    -------------------------------------------------------------------------------------------------
                    -- ""
                    -- go.transform:Find("SliderWarehouse").gameObject:SetActiveEx(false)
                    -- -- go.transform:Find("Max").gameObject:SetActiveEx(true)
                    -- go.transform:Find("Max").gameObject:SetActiveEx(false)

                    -- go.transform:Find("Max/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = myCfg.unionLimit .. "/" ..
                    --                                                                            myCfg.unionLimit
                    -------------------------------------------------------------------------------------------------
                end
            else
                go.transform:Find("Unlock").gameObject:SetActiveEx(true)
                go.transform:Find("SliderWarehouse").gameObject:SetActiveEx(false)
                go.transform:Find("Max").gameObject:SetActiveEx(false)

            end

            local image = go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

            gg.setSpriteAsync(image, icon)
            if self.selelctTrainId then
                if self.selelctTrainId == v.cfgId then
                    go.transform:Find("Choose").gameObject:SetActiveEx(true)
                else
                    go.transform:Find("Choose").gameObject:SetActiveEx(false)
                end
            else
                go.transform:Find("Choose").gameObject:SetActiveEx(false)
            end
            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:onBtnUnionTrain(v.cfgId, type)
            end)
            self.boxUnionTrainList[v.cfgId] = go
            if not self.selelctTrainId then
                self:onBtnUnionTrain(v.cfgId, type)
            end

            return true
        end, true)
    end
end

function PnlUnion:releaseBoxUnionTrain()
    if self.boxUnionTrainList then
        for k, go in pairs(self.boxUnionTrainList) do
            CS.UIEventHandler.Clear(go)
            ResMgr:ReleaseAsset(go)
        end
        self.boxUnionTrainList = {}
    end
end

function PnlUnion:setViewWarehouseDao()
    self.view.warhouseRes:SetActiveEx(false)
    self.view.warehouseTrain:SetActiveEx(false)
    self.view.warehouseDao:SetActiveEx(true)

    local view = self.view
    self:onSetViewWarehouseDao()

    local showData = {}
    for k, v in pairs(ItemData.itemBagData) do
        local curCfg = cfg.getCfg("item", v.cfgId)
        if curCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
            local data = {
                data = v,
                cfg = curCfg,
                sort = v.cfgId
            }

            table.insert(showData, data)
        end
    end

    QuickSort.quickSort(showData, "sort", 1, #showData, "up")
    self:releaseBoxDaoArtifact()
    self.boxDaoArtifactList = {}
    for i, v in ipairs(showData) do
        ResMgr:LoadGameObjectAsync("BoxDaoArtifact", function(go)
            go.transform:SetParent(view.daoContent, false)
            self:setBoxDaoArtifactData(go, v)
            CS.UIEventHandler.Get(go.transform:Find("Button").gameObject):SetOnClick(function()
                self:onBtnDaoArtifact(v.data.id)
            end)
            self.boxDaoArtifactList[v.data.id] = go
            return true
        end, true)
    end
end

function PnlUnion:setBoxDaoArtifactData(go, data)
    go.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(data.cfg.languageNameID)
    go.transform:Find("TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("X%d", data.data.num)
    local icon = gg.getSpriteAtlasName("Item_Atlas", data.cfg.icon)
    gg.setSpriteAsync(go.transform:Find("IconDao"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

    local exp = cfg.itemEffect[data.cfg.effect[1]].value[1]
    local con = cfg.itemEffect[data.cfg.effect[2]].value[1]

    go.transform:Find("BgInfo/TxtExp"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("+%d", exp)
    go.transform:Find("BgInfo/TxtCon"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("+%d", con)

end

function PnlUnion:onSetViewWarehouseDao()
    self.unionData = UnionData.unionData
    local view = self.view
    local unionLevel = self.unionData.unionLevel
    local daoLevelCfg = cfg.daoLevel
    local maxExp = daoLevelCfg[unionLevel].levelUpNeedExp or 1
    local exp = self.unionData.exp or 0
    local expPancent = exp / maxExp

    if expPancent > 1 or expPancent < 0 then
        expPancent = 0
    end

    view.txtLevel.text = unionLevel
    view.txtContri.text = Utils.scientificNotation(self.unionData.contriDegree)
    if unionLevel < #daoLevelCfg then
        view.levelMaxGo:SetActiveEx(false)
        view.txtExp.gameObject:SetActiveEx(true)
        view.sliderExp.gameObject:SetActiveEx(true)
        view.txtExp.text = string.format("%d/%d", exp, maxExp)
        view.sliderExp.value = expPancent
    else
        view.levelMaxGo:SetActiveEx(true)
        view.txtExp.gameObject:SetActiveEx(false)
        view.sliderExp.gameObject:SetActiveEx(false)
    end

end

function PnlUnion:onRefreshBoxDaoArtifact(args, type, id, data)
    if self.boxDaoArtifactList then
        if type == 1 then
            self.boxDaoArtifactList[id]:SetActiveEx(false)
        elseif self.boxDaoArtifactList[id] then
            local curCfg = cfg.getCfg("item", data.cfgId)
            local temp = {
                data = data,
                cfg = curCfg
            }

            self:setBoxDaoArtifactData(self.boxDaoArtifactList[id], temp)
        end
    end
end

function PnlUnion:onBtnDaoArtifact(id)
    UnionData.C2S_Player_DonateDaoItem(id, 1)
end

function PnlUnion:releaseBoxDaoArtifact()
    if self.boxDaoArtifactList then
        for k, go in pairs(self.boxDaoArtifactList) do
            CS.UIEventHandler.Clear(go.transform:Find("Button").gameObject)
            ResMgr:ReleaseAsset(go)
        end
        self.boxDaoArtifactList = nil
    end
end

function PnlUnion:onBtnCloseWarehouse()
    self:chooseView(PnlUnion.VIEW_UNIONMAIN, true)
end

function PnlUnion:onBtnConfirm()
    local unionId = self.unionData.unionId
    local starCoin = self.donateRes[constant.RES_STARCOIN] or 0
    local ice = self.donateRes[constant.RES_ICE] or 0
    local titanium = self.donateRes[constant.RES_TITANIUM] or 0
    local gas = self.donateRes[constant.RES_GAS] or 0
    local carboxyl = self.donateRes[constant.RES_CARBOXYL] or 0

    starCoin = math.floor(starCoin)
    ice = math.floor(ice)
    titanium = math.floor(titanium)
    gas = math.floor(gas)
    carboxyl = math.floor(carboxyl)

    if starCoin > 0 or ice > 0 or titanium > 0 or gas > 0 or carboxyl > 0 then
        UnionData.C2S_Player_UnionDonate(unionId, starCoin, ice, titanium, gas, carboxyl)
    end
end

function PnlUnion:onChangePlayerSharing()
    local num = self.view.inputFieldSharing.text
    if num == "" then
        num = 0
    end
    num = tonumber(num)
    if num < 0 then
        num = 0
    end
    if num > 100 then
        num = 100
    end
    -- num = tostring(num) .. "%"
    self.view.inputFieldSharing.text = num
end

function PnlUnion:onChangeRes(key)
    local max = self.resScrollbarTotalNum[key] or 0
    local value = self.view.resScrollbar[key]:Find("Scrollbar"):GetComponent(UNITYENGINE_UI_SCROLLBAR).value
    local count = max * value
    count = math.floor(count)
    self.donateRes[key] = count * 1000000
    self.view.resScrollbar[key]:Find("ResTitel/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT).text = count .. "k"
    -- if self:checkResFull(key, count) then
    --     self.view.resScrollbar[key]:Find("TxtTip").gameObject:SetActiveEx(false)
    -- else
    --     self.view.resScrollbar[key]:Find("TxtTip").gameObject:SetActiveEx(true)
    -- end

    local cont = 0

    cont = cont + (self.donateRes[constant.RES_STARCOIN] or 0) / cfg["global"].starcoinToPerContribute.intValue
    cont = cont + (self.donateRes[constant.RES_ICE] or 0) / cfg["global"].iceToPerContribute.intValue
    cont = cont + (self.donateRes[constant.RES_TITANIUM] or 0) / cfg["global"].titaniumToPerContribute.intValue
    cont = cont + (self.donateRes[constant.RES_GAS] or 0) / cfg["global"].gasToPerContribute.intValue
    cont = cont + (self.donateRes[constant.RES_CARBOXYL] or 0) / cfg["global"].carboxylToPerContribute.intValue

    if cont > 0 then
        self.view.txtAdd.gameObject:SetActiveEx(true)
        self.view.txtAdd.text = string.format("(+%s)", cont) -- Utils.scientificNotation(cont))

    else
        self.view.txtAdd.gameObject:SetActiveEx(false)

    end
end

function PnlUnion:onBtnChangeCount(temp)
    local curMaxTrainCount = 0
    if self.warehouseView == PnlUnion.WAREHOUSE_SOLIDIER then
        if self.unionData.soliders[self.selelctTrainId] then
            curMaxTrainCount = self.selelctTrainCfg.unionLimit - self.unionData.soliders[self.selelctTrainId].count -
                                   self.unionData.soliders[self.selelctTrainId].genCount
        end
    elseif self.warehouseView == PnlUnion.WAREHOUSE_TOWER then
        if self.unionData.builds[self.selelctTrainId] then
            curMaxTrainCount = self.selelctTrainCfg.unionLimit - self.unionData.builds[self.selelctTrainId].count -
                                   self.unionData.builds[self.selelctTrainId].genCount
        end
    end

    self.isTrainScrollbarValueChange = false

    self.trainCount = self.trainCount + temp
    if self.trainCount > curMaxTrainCount then
        self.trainCount = curMaxTrainCount
    end
    if self.trainCount < 0 then
        self.trainCount = 0
    end

    self.view.txtTrainCount.text = self.trainCount
    local percent = self.trainCount / curMaxTrainCount
    self.view.trainScrollbar.value = percent

end

function PnlUnion:onTrainScrollbarValueChange()
    local curMaxTrainCount = 0
    if self.warehouseView == PnlUnion.WAREHOUSE_SOLIDIER then
        if self.unionData.soliders[self.selelctTrainId] then
            curMaxTrainCount = self.selelctTrainCfg.unionLimit - self.unionData.soliders[self.selelctTrainId].count -
                                   self.unionData.soliders[self.selelctTrainId].genCount
        end
    elseif self.warehouseView == PnlUnion.WAREHOUSE_TOWER then
        if self.unionData.builds[self.selelctTrainId] then
            curMaxTrainCount = self.selelctTrainCfg.unionLimit - self.unionData.builds[self.selelctTrainId].count -
                                   self.unionData.builds[self.selelctTrainId].genCount
        end
    end

    if self.isTrainScrollbarValueChange then
        local percent = self.view.trainScrollbar.value
        local count = percent * curMaxTrainCount
        self.trainCount = math.floor(count)
        self.view.txtTrainCount.text = self.trainCount
    end
    self.isTrainScrollbarValueChange = true

    local curCount = 0
    if self.warehouseView == PnlUnion.WAREHOUSE_SOLIDIER then
        if self.unionData.soliders[self.selelctTrainId] then
            curCount = self.unionData.soliders[self.selelctTrainId].count +
                           self.unionData.soliders[self.selelctTrainId].genCount
        end
    elseif self.warehouseView == PnlUnion.WAREHOUSE_TOWER then
        if self.unionData.builds[self.selelctTrainId] then
            curCount = self.unionData.builds[self.selelctTrainId].count +
                           self.unionData.builds[self.selelctTrainId].genCount
        end
    end
    local percent = (self.trainCount + curCount) / self.selelctTrainCfg.unionLimit
    if percent > 1 then
        percent = 1
        -- self.view.txtWarning.gameObject:SetActiveEx(true)
    else
        -- self.view.txtWarning.gameObject:SetActiveEx(false)
    end
    self.boxUnionTrainList[self.selelctTrainId].transform:Find("SliderWarehouse/SliderGreen"):GetComponent(
        UNITYENGINE_UI_SLIDER).value = percent

    self:setTrainTime()
    self:setWarehouseResSlider()
end

function PnlUnion:setTrainTime()
    local trainNeedTick = self.selelctTrainCfg.trainNeedTick or 0
    local time = trainNeedTick * self.trainCount
    self.view.txtTrainTime.text = self:getFormatTick(time)
end

function PnlUnion:setWarehouseResSlider()
    local starCoin = self.selelctTrainCfg.trainNeedStarCoin or 0
    local ice = 0 -- self.selelctTrainCfg.trainNeedStarCoin or 0
    local ti = 0 -- self.selelctTrainCfg.trainNeedStarCoin or 0
    local gas = 0 -- self.selelctTrainCfg.trainNeedStarCoin or 0
    local hyl = 0 -- self.selelctTrainCfg.trainNeedStarCoin or 0

    starCoin = starCoin * self.trainCount / 1000
    ice = ice * self.trainCount / 1000
    ti = ti * self.trainCount / 1000
    gas = gas * self.trainCount / 1000
    hyl = hyl * self.trainCount / 1000

    self:setResSlider(constant.RES_STARCOIN, starCoin)
    self:setResSlider(constant.RES_ICE, ice)
    self:setResSlider(constant.RES_TITANIUM, ti)
    self:setResSlider(constant.RES_GAS, gas)
    self:setResSlider(constant.RES_CARBOXYL, hyl)

end

function PnlUnion:setResSlider(resId, count)
    local resObj = self.view.sliderWarehouseRes[resId].transform
    if count > 0 then
        resObj:Find("TxtCost").gameObject:SetActiveEx(true)
        resObj:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("(-%.0f)", count)
    else
        resObj:Find("TxtCost").gameObject:SetActiveEx(false)
    end

    local percent = (self.unionData.starCoin - count) / self.unionData.starCoinLimit
    if resId == constant.RES_ICE then
        percent = (self.unionData.ice - count) / self.unionData.iceLimit
    elseif resId == constant.RES_TITANIUM then
        percent = (self.unionData.titanium - count) / self.unionData.titaniumLimit
    elseif resId == constant.RES_GAS then
        percent = (self.unionData.gas - count) / self.unionData.gasLimit
    elseif resId == constant.RES_CARBOXYL then
        percent = 1
    end
    if percent < 0 then
        percent = 0
    end
    resObj:Find("SliderWarehouse"):GetComponent(UNITYENGINE_UI_SLIDER).value = percent
end

function PnlUnion:onBtnTrain()
    local unionId = self.unionData.unionId
    local cfgId = self.selelctTrainId
    local count = self.trainCount
    local type = self.trainType
    if type == 1 then
        UnionData.C2S_Player_UnionTrainSolider(unionId, cfgId, count)
    elseif type == 2 then
        UnionData.C2S_Player_UnionGenBuild(unionId, cfgId, count)
    end

end

function PnlUnion:onBtnUnionTrain(cfgId, type)
    for k, go in pairs(self.boxUnionTrainList) do
        go.transform:Find("Choose").gameObject:SetActiveEx(false)
    end
    self.boxUnionTrainList[cfgId].transform:Find("Choose").gameObject:SetActiveEx(true)

    self:setViewTrainInfo(cfgId, type)
end

function PnlUnion:setViewTrainInfo(cfgId, type)
    if self.boxUnionTrainList[self.selelctTrainId] then
        self.boxUnionTrainList[self.selelctTrainId].transform:Find("SliderWarehouse/SliderGreen"):GetComponent(
            UNITYENGINE_UI_SLIDER).value = self.boxUnionTrainList[self.selelctTrainId].transform:Find(
                                               "SliderWarehouse/Slider"):GetComponent(UNITYENGINE_UI_SLIDER).value
    end

    self.selelctTrainId = cfgId
    self.isTrainScrollbarValueChange = true -- ""
    self.trainCount = 0
    local view = self.view
    local trainData = {}
    local myCgf = {}
    local icon = ""
    local level = 1
    if type == 1 then
        trainData = self.unionData.soliders

        local hpAddRatio = 1
        local atkAddRatio = 1
        local atkSpeedAddRatio = 1

        if trainData[cfgId] then
            level = trainData[cfgId].level
            hpAddRatio = trainData[cfgId].hpAddRatio + 1
            atkAddRatio = trainData[cfgId].atkAddRatio + 1
            atkSpeedAddRatio = trainData[cfgId].atkSpeedAddRatio + 1
        end
        myCgf = cfg.getCfg("solider", cfgId, level, nil, 2)
        icon = gg.getSpriteAtlasName("Soldier_A_Atlas", myCgf.icon .. "_A")
        view.attrScrollView[1].text = math.floor(myCgf.maxHp * hpAddRatio)
        view.attrScrollView[2].text = math.floor(myCgf.atk / 1000 * atkAddRatio)
        view.attrScrollView[3].text = math.floor(myCgf.atkSpeed / 1000 * atkSpeedAddRatio)

        self.attrDataCount = 3
    else
        trainData = self.unionData.builds

        local hpAddRatio = 1
        local atkAddRatio = 1
        local atkSpeedAddRatio = 1

        if trainData[cfgId] then
            level = trainData[cfgId].level
            hpAddRatio = trainData[cfgId].hpAddRatio + 1
            atkAddRatio = trainData[cfgId].atkAddRatio + 1
            atkSpeedAddRatio = trainData[cfgId].atkSpeedAddRatio + 1
        end
        myCgf = cfg.getCfg("build", cfgId, level)
        icon = gg.getSpriteAtlasName("Build_A_Atlas", myCgf.icon .. "_A")
        view.iconTop.gameObject:SetActiveEx(false)
        local atkSpeed = 1 / (myCgf.atkSpeed / 1000)
        view.attrScrollView[1].text = math.floor(myCgf.maxHp * hpAddRatio)
        view.attrScrollView[2].text = math.floor(myCgf.atk / 1000 * atkAddRatio * atkSpeed)
        view.attrScrollView[3].text = Utils.scientificNotation( myCgf.atkSpeed / 1000 , true)

        self.attrDataCount = 3
    end
    self.selelctTrainCfg = myCgf

    view.txtLv.text = level
    view.txtName.text = myCgf.name
    gg.setSpriteAsync(view.iconTrain, icon)

    -- if trainData[cfgId] then
    --     view.trainScrollbar.gameObject:SetActiveEx(true)
    --     view.btnTrain.gameObject:SetActiveEx(true)
    --     view.txtTrainTime.gameObject:SetActiveEx(true)

    -- else
    --     view.trainScrollbar.gameObject:SetActiveEx(false)
    --     view.btnTrain.gameObject:SetActiveEx(false)
    --     view.txtTrainTime.gameObject:SetActiveEx(false)
    -- end
    local myJodCfg = {}
    for k, v in pairs(self.daoPositionCfg) do
        if v.accessLevel == UnionData.myUnionJod then
            myJodCfg = v
            break
        end
    end

    view.txtNoPermissions.gameObject:SetActiveEx(false)

    -- if type == 1 then
    --     if myJodCfg.isTrainTroops == 0 then
    --         view.trainScrollbar.gameObject:SetActiveEx(false)
    --         -- view.btnTrain.gameObject:SetActiveEx(false)
    --         -- view.txtTrainTime.gameObject:SetActiveEx(false)
    --         -- view.txtNoPermissions.gameObject:SetActiveEx(true)
    --         -- view.txtNoPermissions.text = Utils.getText("guild_NoPermissionsToTrain")
    --     end
    -- else
    --     if myJodCfg.isBuildTowers == 0 then
    --         view.trainScrollbar.gameObject:SetActiveEx(false)
    --         -- view.btnTrain.gameObject:SetActiveEx(false)
    --         -- view.txtTrainTime.gameObject:SetActiveEx(false)
    --         -- view.txtNoPermissions.gameObject:SetActiveEx(true)
    --         -- view.txtNoPermissions.text = Utils.getText("guild_NoPermissionsToBuild")

    --     end
    -- end

    -- view.txtWarning.gameObject:SetActiveEx(false)

    view.txtTrainCount.text = self.trainCount
    view.trainScrollbar.value = 0

    local itemCount = self.attrDataCount
    local scrollViewLenth = AttrUtil.getAttrScrollViewLenth(itemCount)

    view.attrScrollViewList.transform:SetRectSizeY(scrollViewLenth)

    self:setTrainTime()
    self:setWarehouseResSlider()
end

------------------------------VIEW_UNIONTECH------------------------------

PnlUnion.techBtnIconName = {
    [PnlUnion.TECH_ECONOMY] = "economy_icon_",
    [PnlUnion.TECH_MILITARY] = "military_icon_",
    [PnlUnion.TECH_DEFENCE] = "tower_icon_"
}

function PnlUnion:setViewUnionTech(type, isReset)
    self:releaseBoxUpgrading()

    if self.techType == type and not isReset then
        return
    end
    self.view.viewTechInfo.gameObject:SetActiveEx(false)

    self.techType = type
    for i = 1, 3, 1 do
        local parentImage = self.view.techBtnIcon[i].transform.parent:GetComponent(UNITYENGINE_UI_IMAGE)
        -- local icon = self.view.techBtnIcon[i]
        local text = self.view.techBtnText[i]
        if type == i then
            -- local iconName = gg.getSpriteAtlasName("Union_Atlas", PnlUnion.techBtnIconName[i] .. "B")
            -- gg.setSpriteAsync(icon, iconName)
            text.color = Color.New(1, 1, 1, 1)
            parentImage.enabled = true
        else
            -- local iconName = gg.getSpriteAtlasName("Union_Atlas", PnlUnion.techBtnIconName[i] .. "A")
            -- gg.setSpriteAsync(icon, iconName)
            text.color = Color.New(61 / 255, 151 / 255, 1, 1)
            parentImage.enabled = false
        end
    end

    self:loadTechContent(type)

    local upgradingList = {}
    local upgradingMax = 2
    local upgradingNum = 0

    for k, v in pairs(UnionData.techs) do
        local tick = v.levelUpTick - os.time()
        if tick > 0 then
            upgradingNum = upgradingNum + 1
            table.insert(upgradingList, v)
            if upgradingNum >= upgradingMax then
                break
            end
        end
    end
    local sizeY = upgradingNum * 78
    self.view.viewUpgradingList:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(171, sizeY)
    self.view.btnUpgrading.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("%s/%s",
        upgradingNum, upgradingMax)
    for k, v in pairs(upgradingList) do
        ResMgr:LoadGameObjectAsync("BoxUpgrading", function(go)
            go.transform:SetParent(self.view.viewUpgradingList:Find("ScrollView/Viewport/Content"), false)
            local tick = v.levelUpTick - os.time()
            go.transform:Find("Wording/TrainTick/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                self:getFormatTick(tick)
            local timer = gg.timer:startLoopTimer(1, 1, tick, function()
                tick = tick - 1
                go.transform:Find("Wording/TrainTick/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = self:getFormatTick(
                    tick)
            end)

            local curCfg = cfg.getCfg("unionTech", v.cfgId, v.level)
            local iconTop = go.transform:Find("Wording/IconBg/IconTop"):GetComponent(UNITYENGINE_UI_IMAGE)
            local icon = go.transform:Find("Wording/IconBg/Image"):GetComponent(UNITYENGINE_UI_IMAGE)
            local iconName
            if curCfg.mod == PnlUnion.TECH_ECONOMY then
                iconName = gg.getSpriteAtlasName("TechIcon_Atlas", curCfg.icon)
                iconTop.gameObject:SetActiveEx(false)
            elseif curCfg.mod == PnlUnion.TECH_MILITARY then
                iconName = gg.getSpriteAtlasName("Soldier_A_Atlas", curCfg.icon .. "_A")
                iconTop.gameObject:SetActiveEx(true)
            elseif curCfg.mod == PnlUnion.TECH_DEFENCE then
                iconName = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
                iconTop.gameObject:SetActiveEx(false)
            end

            gg.setSpriteAsync(icon, iconName)

            go.transform:Find("Wording/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(curCfg.name)

            self.BoxUpgrading[v.cfgId] = {
                go = go,
                timer = timer
            }
            return true
        end, true)
    end

    self:setViewUpgradingList(false)
end

function PnlUnion:releaseBoxUpgrading()
    if self.BoxUpgrading then
        for k, v in pairs(self.BoxUpgrading) do
            if v.timer then
                gg.timer:stopTimer(v.timer)
                v.timer = nil
            end
            ResMgr:ReleaseAsset(v.go)
        end
        self.BoxUpgrading = {}
    end
end

function PnlUnion:loadTechContent(type)
    self:releaseTechContent()
    local content = "TechEconmy"
    if type == PnlUnion.TECH_MILITARY then
        content = "TechMilitary"
    elseif type == PnlUnion.TECH_DEFENCE then
        content = "TechDefence"
    end
    if self.timerTechList then
        for k, v in pairs(self.timerTechList) do
            self:stopTimer(v)
        end
    end
    self.timerTechList = {}

    ResMgr:LoadGameObjectAsync(content, function(go)
        go.transform:SetParent(self.view.scrollViewportTech, false)
        go.transform:GetComponent(UNITYENGINE_UI_IMAGE).enabled = false
        self.view.scrollViewtTech.content = go.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM)
        local techCount = go.transform:Find("BoxTech").childCount
        for i = 0, techCount - 1, 1 do
            local child = go.transform:Find("BoxTech"):GetChild(i)
            local id = string.gsub(child.name, "[%BoxTech-]", "")
            id = tonumber(id)
            local level = 0
            if UnionData.techs[id] then
                level = UnionData.techs[id].level
            end
            local curCfg = cfg.getCfg("unionTech", id, level)

            if UnionData.techs[id] then
                child:Find("Lock").gameObject:SetActiveEx(false)

                local tick = UnionData.techs[id].levelUpTick - os.time()
                if tick > 0 then
                    child:Find("TrainTick").gameObject:SetActiveEx(true)
                    child:Find("TrainTick/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = self:getFormatTick(tick)

                    self.timerTechList[child.name] = self:startLoopTimer(UnionData.techs[id].levelUpTick,
                        self.timerTechList[child.name], child:Find("TrainTick/Text"):GetComponent(UNITYENGINE_UI_TEXT),
                        child:Find("TrainTick").gameObject, nil, function()
                            local newLv = level + 1
                            local levelText = string.format("<color=#ffffff>%s</color>/%s", newLv, curCfg.maxLevel)
                            child:Find("Slider/TxtTechLv"):GetComponent(UNITYENGINE_UI_TEXT).text = levelText
                            child:Find("Slider/Slider"):GetComponent(UNITYENGINE_UI_IMAGE).fillAmount = newLv /
                                                                                                            curCfg.maxLevel
                        end)

                else
                    child:Find("TrainTick").gameObject:SetActiveEx(false)
                end
            else
                child:Find("Lock").gameObject:SetActiveEx(true)
            end

            local iconTop = child:Find("IconBg/IconTop"):GetComponent(UNITYENGINE_UI_IMAGE)
            local icon = child:Find("IconBg/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
            local iconName
            if type == PnlUnion.TECH_ECONOMY then
                iconName = gg.getSpriteAtlasName("TechIcon_Atlas", curCfg.icon)
                iconTop.gameObject:SetActiveEx(false)
            elseif type == PnlUnion.TECH_MILITARY then
                iconName = gg.getSpriteAtlasName("Soldier_A_Atlas", curCfg.icon .. "_A")
                iconTop.gameObject:SetActiveEx(true)
            elseif type == PnlUnion.TECH_DEFENCE then
                iconName = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
                iconTop.gameObject:SetActiveEx(false)
            end

            gg.setSpriteAsync(icon, iconName)

            child:Find("TxtTech"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(curCfg.name)

            local levelText = string.format("<color=#ffffff>%s</color>/%s", level, curCfg.maxLevel)
            child:Find("Slider/TxtTechLv"):GetComponent(UNITYENGINE_UI_TEXT).text = levelText
            child:Find("Slider/Slider"):GetComponent(UNITYENGINE_UI_IMAGE).fillAmount = level / curCfg.maxLevel

            CS.UIEventHandler.Get(child.gameObject):SetOnClick(function()
                self:onBtnBoxTech(curCfg)
            end)
            self.boxTechList[id] = child.gameObject
        end
        self.curTechContent = go
        return true
    end, true)
end

function PnlUnion:releaseTechContent()
    if self.boxTechList then
        for k, v in pairs(self.boxTechList) do
            CS.UIEventHandler.Clear(v)
        end
        self.boxTechList = {}
    end
    if self.curTechContent then
        ResMgr:ReleaseAsset(self.curTechContent)
        self.curTechContent = nil
    end
end

function PnlUnion:onBtnCloseTech()
    self:chooseView(PnlUnion.VIEW_UNIONMAIN)
    self:releaseBoxUpgrading()
end

function PnlUnion:onBtnChangeTechView(type)
    self:setViewUnionTech(type, false)
end

function PnlUnion:onBtnUpgrading()
    self:setViewUpgradingList(not self.isShowViewUpgrading)
end

function PnlUnion:setViewUpgradingList(isShow)
    local num = 0
    for k, v in pairs(self.BoxUpgrading) do
        num = num + 1
    end

    if isShow and num == 0 then
        return
    end

    self.isShowViewUpgrading = isShow
    self.view.viewUpgradingList.gameObject:SetActiveEx(isShow)
end

function PnlUnion:onBtnBoxTech(curCfg)
    self:setViewTechInfo(curCfg)
end

function PnlUnion:setViewTechInfo(curCfg)
    self.selelctTechCfgId = curCfg.cfgId
    local view = self.view
    local data = UnionData.techs[curCfg.cfgId]
    view.viewTechInfo.gameObject:SetActiveEx(true)

    view.txtTechTitel.text = Utils.getText(curCfg.name)
    local hms = gg.time.dhms_time({
        day = false,
        hour = 1,
        min = 1,
        sec = 1
    }, curCfg.levelUpNeedTime)
    view.txtTrainTime.text = string.format("%02s:%02s:%02s", hms.hour, hms.min, hms.sec)

    local iconTop = view.techInfoIconTop
    local icon = view.techInfoIcon
    local iconName
    if self.techType == PnlUnion.TECH_ECONOMY then
        iconName = gg.getSpriteAtlasName("TechIcon_Atlas", curCfg.icon)
        iconTop.gameObject:SetActiveEx(false)
    elseif self.techType == PnlUnion.TECH_MILITARY then
        iconName = gg.getSpriteAtlasName("Soldier_A_Atlas", curCfg.icon .. "_A")
        iconTop.gameObject:SetActiveEx(true)
    elseif self.techType == PnlUnion.TECH_DEFENCE then
        iconName = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
        iconTop.gameObject:SetActiveEx(false)
    end

    gg.setSpriteAsync(icon, iconName)

    view.txtBrief.text = Utils.getText(curCfg.desc)

    if data then
        view.tipsUnlock:SetActiveEx(false)
    else
        view.txtCurLevel.text = curCfg.level
        view.txtNextLevel.text = curCfg.level + 1

        view.layoutPrepare:SetActiveEx(false)
        view.trainTime:SetActiveEx(false)
        view.tipsHighestLevel:SetActiveEx(false)
        view.tipsUnlock:SetActiveEx(true)
        return
    end

    view.sliderTechLevel.fillAmount = curCfg.level / curCfg.maxLevel
    view.txtTechLv.text = string.format("<color=#ffffff>%s</color>/%s", curCfg.level, curCfg.maxLevel)

    if curCfg.level < curCfg.maxLevel then
        view.levelMax:SetActiveEx(false)
        view.tipsHighestLevel:SetActiveEx(false)
        view.levelUpgrade:SetActiveEx(true)
        view.txtCurLevel.text = curCfg.level
        view.txtNextLevel.text = curCfg.level + 1
        local tick = data.levelUpTick - os.time()
        if tick > 0 then
            view.layoutPrepare:SetActiveEx(false)
            view.trainTime:SetActiveEx(true)
            view.txtTime.text = self:getFormatTick(tick)
            self:stopTimer(self.timerTechInfo)
            self.timerTechInfo = self:startLoopTimer(data.levelUpTick, self.timerTechInfo, view.txtTime, view.trainTime)
        else
            view.layoutPrepare:SetActiveEx(true)
            view.trainTime:SetActiveEx(false)

            if curCfg.levelUpNeedStarCoin > 0 then
                view.layoutPrepare.transform:Find("ViewCost/ResStarCoin").gameObject:SetActiveEx(true)
                view.layoutPrepare.transform:Find("ViewCost/ResStarCoin/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    Utils.scientificNotationInt(curCfg.levelUpNeedStarCoin / 1000)

            else
                view.layoutPrepare.transform:Find("ViewCost/ResStarCoin").gameObject:SetActiveEx(false)
            end
            if curCfg.levelUpNeedIce > 0 then
                view.layoutPrepare.transform:Find("ViewCost/ResIce").gameObject:SetActiveEx(true)
                view.layoutPrepare.transform:Find("ViewCost/ResIce/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    Utils.scientificNotationInt(curCfg.levelUpNeedIce / 1000)

            else
                view.layoutPrepare.transform:Find("ViewCost/ResIce").gameObject:SetActiveEx(false)
            end
            if curCfg.levelUpNeedTitanium > 0 then
                view.layoutPrepare.transform:Find("ViewCost/ResTi").gameObject:SetActiveEx(true)
                view.layoutPrepare.transform:Find("ViewCost/ResTi/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    Utils.scientificNotationInt(curCfg.levelUpNeedTitanium / 1000)

            else
                view.layoutPrepare.transform:Find("ViewCost/ResTi").gameObject:SetActiveEx(false)
            end
            if curCfg.levelUpNeedGas > 0 then
                view.layoutPrepare.transform:Find("ViewCost/ResGas").gameObject:SetActiveEx(true)
                view.layoutPrepare.transform:Find("ViewCost/ResGas/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    Utils.scientificNotationInt(curCfg.levelUpNeedGas / 1000)

            else
                view.layoutPrepare.transform:Find("ViewCost/ResGas").gameObject:SetActiveEx(false)
            end
            if curCfg.levelUpNeedCarboxyl > 0 then
                view.layoutPrepare.transform:Find("ViewCost/ResHyl").gameObject:SetActiveEx(true)
                view.layoutPrepare.transform:Find("ViewCost/ResHyl/Text"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    Utils.scientificNotationInt(curCfg.levelUpNeedCarboxyl / 1000)

            else
                view.layoutPrepare.transform:Find("ViewCost/ResHyl").gameObject:SetActiveEx(false)
            end

        end
    else
        view.levelMax:SetActiveEx(true)
        view.levelUpgrade:SetActiveEx(false)
        view.layoutPrepare:SetActiveEx(false)
        view.trainTime:SetActiveEx(false)
        view.tipsHighestLevel:SetActiveEx(true)
    end

    local myJodCfg = {}
    for k, v in pairs(self.daoPositionCfg) do
        if v.accessLevel == UnionData.myUnionJod then
            myJodCfg = v
            break
        end
    end

    if myJodCfg.isResearch == 1 then
        view.btnUpgrade:SetActiveEx(true)

    else
        view.btnUpgrade:SetActiveEx(false)

    end
end

function PnlUnion:onBtnUpgrade()
    local unionId = self.unionData.unionId
    local cfgId = self.selelctTechCfgId
    UnionData.C2S_Player_UnionTechLevelUp(unionId, cfgId)
end

function PnlUnion:onBtnCloseTechInfo()
    self.view.viewTechInfo.gameObject:SetActiveEx(false)
end

----------------------------------------------------------------------------------------------------

function PnlUnion:onHide()
    self:stopAllTimer()

    self:releaseEvent()

    self:releaseBoxUnion()
    self:releaseBoxMember()
    self:releaseBoxApply()
    self:releaseBoxUnionInvite()
    self:releaseViewAddpopint()
    self:releaseBoxFlag()
    self:releaseBoxUnionTrain()
    self:releaseTechContent()
    self:releaseBoxUpgrading()
    self:releaseBoxDaoArtifact()

end

function PnlUnion:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnSearchUnionList):SetOnClick(function()
        self:onBtnSearchUnionList()
    end)
    CS.UIEventHandler.Get(view.btnCreate):SetOnClick(function()
        self:onBtnCreate()
    end)
    CS.UIEventHandler.Get(view.btnInvite):SetOnClick(function()
        self:onBtnInvite()
    end)
    CS.UIEventHandler.Get(view.btnCloseCreateUnion):SetOnClick(function()
        self:onBtnCloseCreateUnion()
    end)
    CS.UIEventHandler.Get(view.btnSetFlag):SetOnClick(function()
        self:onBtnSetFlag()
    end)
    CS.UIEventHandler.Get(view.btnConfirmCreare):SetOnClick(function()
        self:onBtnConfirmCreare()
    end)
    CS.UIEventHandler.Get(view.btnClearInvite):SetOnClick(function()
        self:onBtnClearInvite()
    end)
    CS.UIEventHandler.Get(view.btnCloseInvite):SetOnClick(function()
        self:onBtnCloseInvite()
    end)
    CS.UIEventHandler.Get(view.btnCopy):SetOnClick(function()
        self:onBtnCopy()
    end)
    CS.UIEventHandler.Get(view.btnCopyOther):SetOnClick(function()
        self:onBtnCopy()
    end)
    CS.UIEventHandler.Get(view.btnEdito):SetOnClick(function()
        self:onBtnEdito()
    end)
    CS.UIEventHandler.Get(view.btnEditoNotice):SetOnClick(function()
        self:onBtnEditoNotice()
    end)
    CS.UIEventHandler.Get(view.noticeInputBg):SetOnClick(function()
        self:onEditoNotice()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnWarehouse):SetOnClick(function()
        self:onBtnWarehouse()
    end)
    CS.UIEventHandler.Get(view.btnMemberMian):SetOnClick(function()
        self:onBtnMemberMian()
    end)
    CS.UIEventHandler.Get(view.btnScience):SetOnClick(function()
        self:onBtnScience()
    end)
    CS.UIEventHandler.Get(view.btnFacilities):SetOnClick(function()
        self:onBtnFacilities()
    end)
    CS.UIEventHandler.Get(view.btnWarReport):SetOnClick(function()
        self:onBtnWarReport()
    end)

    CS.UIEventHandler.Get(view.btnCloseInvitePlayer):SetOnClick(function()
        self:onBtnCloseInvitePlayer()
    end)
    CS.UIEventHandler.Get(view.btnSearchMember):SetOnClick(function()
        self:onBtnSearchMember()
    end)
    CS.UIEventHandler.Get(view.btnInviteMember):SetOnClick(function()
        self:onBtnInviteMember()
    end)
    CS.UIEventHandler.Get(view.btnCloseMember):SetOnClick(function()
        self:onBtnCloseMember()
    end)
    CS.UIEventHandler.Get(view.btnApplyList):SetOnClick(function()
        self:onBtnApplyList()
    end)
    CS.UIEventHandler.Get(view.btnInvitePlayer):SetOnClick(function()
        self:onBtnInvitePlayer()
    end)
    CS.UIEventHandler.Get(view.btnCycle):SetOnClick(function()
        self:onBtnCycle()
    end)
    CS.UIEventHandler.Get(view.btnMember):SetOnClick(function()
        self:onBtnMember()
    end)
    CS.UIEventHandler.Get(view.btnSearchPlayer):SetOnClick(function()
        self:onBtnSearchPlayer()
    end)
    CS.UIEventHandler.Get(view.btnCloseUnionApply):SetOnClick(function()
        self:onBtnCloseUnionApply()
    end)
    CS.UIEventHandler.Get(view.btnClearApply):SetOnClick(function()
        self:onBtnClearApply()
    end)
    CS.UIEventHandler.Get(view.btnCloseFlag):SetOnClick(function()
        self:onBtnCloseFlag()
    end)
    CS.UIEventHandler.Get(view.btnConfirmFlag):SetOnClick(function()
        self:onBtnConfirmFlag()
    end)
    CS.UIEventHandler.Get(view.btnCloseAddpoint):SetOnClick(function()
        self:onBtnCloseAddpoint()
    end)
    CS.UIEventHandler.Get(view.btnCloseWarehouse):SetOnClick(function()
        self:onBtnCloseWarehouse()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
    CS.UIEventHandler.Get(view.btnRes):SetOnClick(function()
        UnionData.C2S_Player_QueryUnionRes()
        self:onChangeWarehouseType(PnlUnion.WAREHOUSE_RES)
    end)
    CS.UIEventHandler.Get(view.btnSoldier):SetOnClick(function()
        if self.isUpdateSolidersData then
            UnionData.C2S_Player_QueryUnionSoliders()
        else
            self:onChangeWarehouseType(PnlUnion.WAREHOUSE_SOLIDIER)
        end
    end)
    CS.UIEventHandler.Get(view.btnTower):SetOnClick(function()
        if self.isUpdateBuildsData then
            UnionData.C2S_Player_QueryUnionBuilds()
        else
            self:onChangeWarehouseType(PnlUnion.WAREHOUSE_TOWER)
        end
    end)
    CS.UIEventHandler.Get(view.btnDao):SetOnClick(function()
        self:onChangeWarehouseType(PnlUnion.WAREHOUSE_DAO)
    end)

    CS.UIEventHandler.Get(view.btnTrain):SetOnClick(function()
        self:onBtnTrain()
    end)
    CS.UIEventHandler.Get(view.btnReduce):SetOnClick(function()
        self:onBtnChangeCount(-1)
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnIncrease):SetOnClick(function()
        self:onBtnChangeCount(1)
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnCloseTech):SetOnClick(function()
        self:onBtnCloseTech()
    end)
    CS.UIEventHandler.Get(view.btnEconomy):SetOnClick(function()
        self:onBtnChangeTechView(PnlUnion.TECH_ECONOMY)
    end)
    CS.UIEventHandler.Get(view.btnMilitary):SetOnClick(function()
        self:onBtnChangeTechView(PnlUnion.TECH_MILITARY)
    end)
    CS.UIEventHandler.Get(view.btnDefence):SetOnClick(function()
        self:onBtnChangeTechView(PnlUnion.TECH_DEFENCE)
    end)
    CS.UIEventHandler.Get(view.btnUpgrading):SetOnClick(function()
        self:onBtnUpgrading()
    end)
    CS.UIEventHandler.Get(view.btnUpgrade):SetOnClick(function()
        self:onBtnUpgrade()
    end)
    CS.UIEventHandler.Get(view.btnCloseTechInfo):SetOnClick(function()
        self:onBtnCloseTechInfo()
    end)
    CS.UIEventHandler.Get(view.btnOtherJoin):SetOnClick(function()
        self:onBtnApplyUnion(self.unionData.unionId)
    end)
    CS.UIEventHandler.Get(view.btnOtherClose):SetOnClick(function()
        self:onBtnOtherClose()
    end)

    self.view.inputFieldSharing.onValueChanged:AddListener(gg.bind(self.onChangePlayerSharing, self))

    self.view.trainScrollbar.onValueChanged:AddListener(gg.bind(self.onTrainScrollbarValueChange, self))

    for k, v in pairs(view.resScrollbar) do
        v:Find("Scrollbar"):GetComponent(UNITYENGINE_UI_SCROLLBAR).onValueChanged:AddListener(gg.bind(self.onChangeRes,
            self, k))
    end

    self:setOnClick(view.btnPlot, gg.bind(self.onBtnPlot, self))
    self:setOnClick(view.btnMint, gg.bind(self.onBtnMint, self))
    self:setOnClick(view.btnNft, gg.bind(self.onBtnNft, self))
    self:setOnClick(view.btnWarehouseDesc, gg.bind(self.onBtnWarehouseDesc, self))
    self:setOnClick(view.btnDesc, gg.bind(self.onBtnDesc, self))
    self:setOnClick(view.btnDaoInfoDesc, gg.bind(self.onBtnDaoInfoDesc, self))
end

function PnlUnion:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSearchUnionList)
    CS.UIEventHandler.Clear(view.btnCreate)
    CS.UIEventHandler.Clear(view.btnInvite)
    CS.UIEventHandler.Clear(view.btnCloseCreateUnion)
    CS.UIEventHandler.Clear(view.btnSetFlag)
    CS.UIEventHandler.Clear(view.btnConfirmCreare)
    CS.UIEventHandler.Clear(view.btnClearInvite)
    CS.UIEventHandler.Clear(view.btnCloseInvite)
    CS.UIEventHandler.Clear(view.btnCopy)
    CS.UIEventHandler.Clear(view.btnCopyOther)
    CS.UIEventHandler.Clear(view.btnEdito)
    CS.UIEventHandler.Clear(view.btnEditoNotice)
    CS.UIEventHandler.Clear(view.noticeInputBg)
    CS.UIEventHandler.Clear(view.btnWarehouse)
    CS.UIEventHandler.Clear(view.btnMemberMian)
    CS.UIEventHandler.Clear(view.btnScience)
    CS.UIEventHandler.Clear(view.btnFacilities)
    CS.UIEventHandler.Clear(view.btnWarReport)

    CS.UIEventHandler.Clear(view.btnCloseInvitePlayer)
    CS.UIEventHandler.Clear(view.btnSearchMember)
    CS.UIEventHandler.Clear(view.btnInviteMember)
    CS.UIEventHandler.Clear(view.btnCloseMember)
    CS.UIEventHandler.Clear(view.btnApplyList)
    CS.UIEventHandler.Clear(view.btnInvitePlayer)
    CS.UIEventHandler.Clear(view.btnCycle)
    CS.UIEventHandler.Clear(view.btnMember)
    CS.UIEventHandler.Clear(view.btnSearchPlayer)
    CS.UIEventHandler.Clear(view.btnCloseUnionApply)
    CS.UIEventHandler.Clear(view.btnClearApply)
    CS.UIEventHandler.Clear(view.btnCloseFlag)
    CS.UIEventHandler.Clear(view.btnConfirmFlag)
    CS.UIEventHandler.Clear(view.btnRes)
    CS.UIEventHandler.Clear(view.btnSoldier)
    CS.UIEventHandler.Clear(view.btnTower)
    CS.UIEventHandler.Clear(view.btnNft)
    CS.UIEventHandler.Clear(view.btnDao)

    CS.UIEventHandler.Clear(view.btnTrain)
    CS.UIEventHandler.Clear(view.btnReduce)
    CS.UIEventHandler.Clear(view.btnIncrease)
    CS.UIEventHandler.Clear(view.btnCloseTech)
    CS.UIEventHandler.Clear(view.btnEconomy)
    CS.UIEventHandler.Clear(view.btnMilitary)
    CS.UIEventHandler.Clear(view.btnDefence)
    CS.UIEventHandler.Clear(view.btnUpgrading)
    CS.UIEventHandler.Clear(view.btnUpgrade)
    CS.UIEventHandler.Clear(view.btnCloseTechInfo)
    CS.UIEventHandler.Clear(view.btnCloseAddpoint)
    CS.UIEventHandler.Clear(view.btnCloseWarehouse)
    CS.UIEventHandler.Clear(view.btnConfirm)
    CS.UIEventHandler.Clear(view.btnOtherJoin)
    CS.UIEventHandler.Clear(view.btnOtherClose)

    self.view.inputFieldSharing.onValueChanged:RemoveAllListeners()

    self.view.trainScrollbar.onValueChanged:RemoveAllListeners()

    for k, v in pairs(view.resScrollbar) do
        v:Find("Scrollbar"):GetComponent(UNITYENGINE_UI_SCROLLBAR).onValueChanged:RemoveAllListeners()
    end

end

function PnlUnion:onDestroy()
    local view = self.view

    for key, value in pairs(self.redPointMap) do
        RedPointManager:releaseRedPoint(value)
    end
end

function PnlUnion:onBtnClose()
    self:close()
end

function PnlUnion:onUpdateUnionData(args, viewType, warehouseView)
    self.unionData = UnionData.unionData

    self.warehouseView = warehouseView
    if viewType then
        self:chooseView(viewType, true)
    end
end

function PnlUnion:checkResFull(key, count)
    count = count * 1000
    if key == constant.RES_STARCOIN then
        if self.unionData.starCoin + count < self.unionData.starCoinLimit then
            return true
        else
            return false
        end
    end
    if key == constant.RES_TITANIUM then
        if self.unionData.titanium + count < self.unionData.titaniumLimit then
            return true
        else
            return false
        end
    end
    if key == constant.RES_ICE then
        if self.unionData.ice + count < self.unionData.iceLimit then
            return true
        else
            return false
        end
    end
    if key == constant.RES_GAS then
        if self.unionData.gas + count < self.unionData.gasLimit then
            return true
        else
            return false
        end
    end

    return true
end

function PnlUnion:startLoopTimer(tick, curTimer, text, textObj, callback, endCallback)
    local newTimer = gg.timer:startLoopTimer(0, 1, -1, function()
        local curTick = tick - os.time()
        text.text = self:getFormatTick(curTick)
        if callback then
            callback(curTick)
        end
        if curTick <= 0 then
            curTick = 0
            textObj:SetActiveEx(false)
            if endCallback then
                endCallback()
            end
            self:stopTimer(curTimer)
        end
    end)
    return newTimer
end

function PnlUnion:stopTimer(curTimer)
    if curTimer then
        gg.timer:stopTimer(curTimer)
        curTimer = nil
    end
end

function PnlUnion:stopAllTimer()
    self:stopTimer(self.timerTechInfo)

    if self.timerTechList then
        for k, v in pairs(self.timerTechList) do
            self:stopTimer(v)
        end
        self.timerTechList = nil
    end
    if self.timerTrainList then
        for k, v in pairs(self.timerTrainList) do
            self:stopTimer(v)
        end
        self.timerTrainList = nil
    end

end

function PnlUnion:getFormatTick(tick)
    local hms = gg.time.dhms_time({
        day = false,
        hour = 1,
        min = 1,
        sec = 1
    }, tick)
    return string.format("%02s:%02s:%02s", hms.hour, hms.min, hms.sec)
end

-- redPoint

function PnlUnion:initRedPoint()
    local view = self.view
    for key, value in pairs(self.redPointMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function PnlUnion:onRedPointChange(_, name, isRed)
    local view = self.view

    if self.redPointMap[name] then
        RedPointManager:setRedPoint(self.redPointMap[name], isRed)
    end
end

function PnlUnion:setChainImg(img, chain)
    local chainName = constant.getNameByChain(chain)
    if chainName ~= "NONE" and chainName ~= "UNKNOW" then
        gg.setSpriteAsync(img, constant.CHAIN_ICON_NAME[chainName], function(image, sprite)
            image.sprite = sprite
            image.color = Color.New(1, 1, 1, 1)
            image:SetNativeSize()
            image.gameObject:SetActiveEx(true)
        end)
    end

end

return PnlUnion
