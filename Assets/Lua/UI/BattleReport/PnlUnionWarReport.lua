PnlUnionWarReport = class("PnlUnionWarReport", ggclass.UIBase)

PnlUnionWarReport.infomationType = ggclass.UIBase.INFOMATION_HIDE

PnlUnionWarReport.GUILDREPORT = 2
PnlUnionWarReport.MYREPORT = 4

function PnlUnionWarReport:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSetReportData", "onSetMyReport", "onChangeReportType"}
end

function PnlUnionWarReport:onAwake()
    self.view = ggclass.PnlUnionWarReportView.new(self.pnlTransform)

    self.boxTotalReportList = {} -- ""
    self.boxMyUnionReportList = {}

    self.flagCfg = cfg["flag"]
    local globalCfg = cfg["global"]
    self.leagueMakeResCD = globalCfg.LeagueMakeResCD.intValue
    self.leagueMakeHYCD = globalCfg.LeagueMakeHYCD.intValue

    self.topButtonView = BattleReportTopButton.new(self.view.topButtonView, BattleReportTopButton.OPEN_TYPE_GALAXY)

end

function PnlUnionWarReport:onShow()
    self.unionReportsContentY = 0
    self.view.contentGuild:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)
    self.view.contentMy:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)

    self:bindEvent()

    self.myReportNo = 1
    self.unionReportNo = 1
    local type = self.args or BattleData.BATTLE_TYPE_SELF

    self.topButtonView:onBtnTop(type)
end

function PnlUnionWarReport:onHide()
    self:releaseEvent()

    self:releaseBoxSingleReport()
    self:releaseBoxTotalReport()
end

function PnlUnionWarReport:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnGuild):SetOnClick(function()
        self:onBtnGuild()
    end)
    CS.UIEventHandler.Get(view.btnMy):SetOnClick(function()
        self:onBtnMy()
    end)

    self.scrollViewMy = view.scrollViewMy.transform:GetComponent(UNITYENGINE_UI_SCROLLRECT)
    self.scrollViewMy.onValueChanged:AddListener(gg.bind(self.onMyReportValueChange, self))

    self.scrollViewGuild = view.scrollViewGuild.transform:GetComponent(UNITYENGINE_UI_SCROLLRECT)
    self.scrollViewGuild.onValueChanged:AddListener(gg.bind(self.onUnionReportValueChange, self))
end

function PnlUnionWarReport:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnGuild)
    CS.UIEventHandler.Clear(view.btnMy)

    self.scrollViewMy.onValueChanged:RemoveAllListeners()
    self.scrollViewGuild.onValueChanged:RemoveAllListeners()
end

PnlUnionWarReport.warehouseBtnIconName = {
    [PnlUnionWarReport.GUILDREPORT] = "guild report_icon_",
    [PnlUnionWarReport.MYREPORT] = "my  report_icon_"
}

function PnlUnionWarReport:onChangeReportType(args, type)
    if type == PnlUnionWarReport.GUILDREPORT then
        self.view.scrollViewMy:SetActiveEx(false)
        self.view.scrollViewGuild:SetActiveEx(true)
        self:onBtnGuild()
    elseif type == PnlUnionWarReport.MYREPORT then
        self.view.scrollViewMy:SetActiveEx(true)
        self.view.scrollViewGuild:SetActiveEx(false)
        self:onBtnMy()
    end
end

function PnlUnionWarReport:onDestroy()
    local view = self.view

    self.topButtonView:release()
    self.topButtonView = nil
end

function PnlUnionWarReport:onBtnClose()
    local window = gg.uiManager:getWindow("PnlBattleReport")
    if window then
        gg.uiManager:destroyWindow("PnlBattleReport")
    end
    UnionData.unionReports = {}
    UnionData.myReports = {}
    BattleReportData.battleReport = {}
    self.destroyTime = 5
    self:close()
end

function PnlUnionWarReport:onBtnGuild()
    if #UnionData.unionReports <= 0 then
        UnionData.C2S_Player_QueryUnionStarmapCampaignReports(self.unionReportNo, 5)
        self.unionReportNo = self.unionReportNo + 1
    else
        if #self.boxTotalReportList > 0 then
            return
        end
        self:onSetReportData()
    end

end

function PnlUnionWarReport:onBtnMy()
    if #UnionData.myReports <= 0 then
        UnionData.C2S_Player_QueryStarmapCampaignReports(self.myReportNo, 5)
        self.myReportNo = self.myReportNo + 1
    else
        if #self.boxMyUnionReportList > 0 then
            return
        end
        self:onSetMyReport()
    end
end

function PnlUnionWarReport:onTxtGridPos(type, boxId)
    local dataId
    local data
    if type == BattleData.BATTLE_TYPE_RES_PLANNET then
        dataId = self.boxTotalReportList[boxId].dataId
        data = self.unionReports[dataId]
    elseif type == BattleData.BATTLE_TYPE_SELF then
        dataId = self.boxMyUnionReportList[boxId].dataId
        data = self.myReports[dataId]
    end

    if not data then
        return
    end

    local gridCfgId = data.gridCfgId
    gg.event:dispatchEvent("onAskToJumpGalaxyGrid", gridCfgId, function()
        gg.uiManager:closeWindow("PnlUnion")
        gg.uiManager:closeWindow("PnlPvp")
        gg.uiManager:closeWindow("PnlPveNew")
        self:close()
    end)
end

function PnlUnionWarReport:onBtnDeTial(type, boxId)
    local dataId
    local data
    if type == BattleData.BATTLE_TYPE_RES_PLANNET then
        dataId = self.boxTotalReportList[boxId].dataId
        data = self.unionReports[dataId]
    elseif type == BattleData.BATTLE_TYPE_SELF then
        dataId = self.boxMyUnionReportList[boxId].dataId
        data = self.myReports[dataId]
    end

    if not data then
        return
    end

    gg.uiManager:openWindow("PnlWarPlayerInfo", data)
end

function PnlUnionWarReport:onBtnInfo(type, boxId)
    local dataId
    local data
    if type == BattleData.BATTLE_TYPE_RES_PLANNET then
        dataId = self.boxTotalReportList[boxId].dataId
        data = self.unionReports[dataId]
    elseif type == BattleData.BATTLE_TYPE_SELF then
        dataId = self.boxMyUnionReportList[boxId].dataId
        data = self.myReports[dataId]
    end

    if not data then
        return
    end
    local args = {
        type = type,
        campaignId = data.campaignId
    }
    gg.uiManager:openWindow("PnlUnionWarReportInfo", args)

end

PnlUnionWarReport.REPORT_MAX_NUM = 5

function PnlUnionWarReport:onUnionReportValueChange(percent)
    local y = self.view.contentGuild.transform.localPosition.y
    local dec = y - self.unionReportsContentY

    if dec > 0 then
        -- ""
        local nextTopBoxNum = self:getNextTopNum(self.topBoxNumUnion)
        local nextTopDataId = self.boxTotalReportList[nextTopBoxNum].dataId

        if self.unionReports[nextTopDataId] and y > self.unionReports[nextTopDataId].nextY then
            local index = self.topBoxNumUnion
            local nextBottomDataId = self.boxTotalReportList[self.bottomBoxNumUnion].dataId + 1
            if self.unionReports[nextBottomDataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_RES_PLANNET, nextBottomDataId, index)
                self.bottomBoxNumUnion = index
                self.topBoxNumUnion = nextTopBoxNum
            end
        end

        local height = self.view.contentGuild.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.height
        if y > height * 0.2 and not UnionData.noUnionCampaignReportData then
            UnionData.C2S_Player_QueryUnionStarmapCampaignReports(self.unionReportNo, 5)
            self.unionReportNo = self.unionReportNo + 1
        end
    elseif dec < 0 then
        -- ""
        local nextBottomBoxNum = self:getNextBoxNum(self.bottomBoxNumUnion)
        local nextBottomDataId = self.boxTotalReportList[nextBottomBoxNum].dataId
        if self.unionReports[nextBottomDataId] and y + 548 < -self.unionReports[nextBottomDataId].posY then
            local nextTopDataId = self.boxTotalReportList[self.topBoxNumUnion].dataId - 1
            if self.unionReports[nextTopDataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_RES_PLANNET, nextTopDataId, self.bottomBoxNumUnion)
                self.topBoxNumUnion = self.bottomBoxNumUnion
                self.bottomBoxNumUnion = nextBottomBoxNum
            end
        end
    end

    self.unionReportsContentY = y
end

function PnlUnionWarReport:setUnionReport(contentSize)
    self.view.contentGuild:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, contentSize)

    for i = 1, #self.boxTotalReportList, 1 do
        if self.boxTotalReportList[i].dataId == 0 then
            local nextBottomDataId = self.boxTotalReportList[self.topBoxNumUnion].dataId + 1
            if self.unionReports[nextBottomDataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_RES_PLANNET, nextBottomDataId, i)
                self.topBoxNumUnion = i
            end
        else
            if self.unionReports[self.boxTotalReportList[i].dataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_RES_PLANNET, self.boxTotalReportList[i].dataId, i)
            end
        end
    end

    if #self.boxTotalReportList > 0 then
        return
    end

    self.boxTotalReportList = {}
    self.unionReportsContentY = 0
    self.topBoxNumUnion = 1
    self.bottomBoxNumUnion = PnlUnionWarReport.REPORT_MAX_NUM
    if #self.unionReports < PnlUnionWarReport.REPORT_MAX_NUM then
        self.bottomBoxNumUnion = #self.unionReports
    end

    self.view.contentGuild:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)
    self.view.contentGuild.gameObject:SetActiveEx(false)

    for j = 1, PnlUnionWarReport.REPORT_MAX_NUM, 1 do
        ResMgr:LoadGameObjectAsync("BoxStarmapCampaign", function(go)
            go.transform:SetParent(self.view.contentGuild, false)
            go:SetActiveEx(false)

            local data = {
                go = go,
                -- singleReportList = {},
                dataId = 0
            }

            table.insert(self.boxTotalReportList, data)
            if self.unionReports[j] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_RES_PLANNET, j, j)
            end
            if j == PnlUnionWarReport.REPORT_MAX_NUM then
                self.view.contentGuild.gameObject:SetActiveEx(true)
            end
            go.transform:Find("ButtonView/BtnDeTial").gameObject:SetActiveEx(true)

            CS.UIEventHandler.Get(go.transform:Find("TxtGridPos").gameObject):SetOnClick(function()
                self:onTxtGridPos(BattleData.BATTLE_TYPE_RES_PLANNET, j)
            end, "event:/UI_button_click", "se_UI", false)
            CS.UIEventHandler.Get(go.transform:Find("ButtonView/BtnDeTial").gameObject):SetOnClick(function()
                self:onBtnDeTial(BattleData.BATTLE_TYPE_RES_PLANNET, j)
            end, "event:/UI_button_click", "se_UI", false)
            CS.UIEventHandler.Get(go.transform:Find("ButtonView/BtnInfo").gameObject):SetOnClick(function()
                self:onBtnInfo(BattleData.BATTLE_TYPE_RES_PLANNET, j)
            end, "event:/UI_button_click", "se_UI", false)

            return true
        end, true)
    end
end

function PnlUnionWarReport:setStarmapCampaignReports(type, dataId, boxId)
    local go
    local data
    if type == BattleData.BATTLE_TYPE_RES_PLANNET then
        self.boxTotalReportList[boxId].dataId = dataId
        go = self.boxTotalReportList[boxId].go
        data = self.unionReports[dataId]
    elseif type == BattleData.BATTLE_TYPE_SELF then
        self.boxMyUnionReportList[boxId].dataId = dataId
        go = self.boxMyUnionReportList[boxId].go
        data = self.myReports[dataId]
    end

    if not data then
        return
    end

    go.transform.localPosition = Vector3(5, data.posY, 0)
    go:SetActiveEx(true)

    if data.defender.playerId == 0 and data.defender.playerId == 0 then
        go.transform:Find("TxtOwner").gameObject:SetActiveEx(false)

    else
        go.transform:Find("TxtOwner").gameObject:SetActiveEx(true)

        go.transform:Find("TxtOwner"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("Owner: %s",
            data.defender.playerName)
    end

    if data.isEnd then
        go.transform:Find("BgNoFight").gameObject:SetActiveEx(true)
        go.transform:Find("BgInFight").gameObject:SetActiveEx(false)

        go.transform:Find("ButtonView/BtnInfo/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "Info"

    else
        go.transform:Find("BgNoFight").gameObject:SetActiveEx(false)
        go.transform:Find("BgInFight").gameObject:SetActiveEx(true)

        go.transform:Find("ButtonView/BtnInfo/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "Fighting"
    end

    local gridCfgId = data.gridCfgId
    local gridCfg = gg.galaxyManager:getGalaxyCfg(gridCfgId)
    go.transform:Find("TxtGridName"):GetComponent(UNITYENGINE_UI_TEXT).text = gridCfg.name
    go.transform:Find("TxtGridPos"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("(X:%s  Y:%s)",
        gridCfg.pos.x, gridCfg.pos.y)

    local makeRes = 0
    if gridCfg.perMakeRes[1] then
        makeRes = gridCfg.perMakeRes[1][2]

        local makeResTime = self.leagueMakeResCD
        if gridCfg.belongType == 1 then
            makeResTime = self.leagueMakeHYCD
        end
        local perMakeRes = makeRes / 1000 * (3600 / makeResTime)

        if makeRes > 0 then
            go.transform:Find("TxtOutput").gameObject:SetActiveEx(true)
            local resId = gridCfg.perMakeRes[1][1]
            local resIconName = gg.getSpriteAtlasName("ResIcon_E_Atlas",
                constant.RES_2_CFG_KEY[resId].iconNameHead .. "E1")
            gg.setSpriteAsync(go.transform:Find("TxtOutput/Image"):GetComponent(UNITYENGINE_UI_IMAGE),
                constant.RES_2_CFG_KEY[resId].iconBig)
            go.transform:Find("TxtOutput/TxtOutput"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("%0.0f /h",
                perMakeRes)

        else
            go.transform:Find("TxtOutput").gameObject:SetActiveEx(false)
        end
    else
        go.transform:Find("TxtOutput").gameObject:SetActiveEx(false)
    end

end

function PnlUnionWarReport:onBtnView(boxId, reportId)
    local dataId = self.boxMyUnionReportList[boxId].dataId
    local battleId = self.myReports[dataId].reports[reportId].battleId
    -- print("battleId", battleId)
    gg.uiManager:closeWindow("PnlUnion")
    BattleData.C2S_Player_LookBattlePlayBack(battleId, CS.Appconst.BattleVersion, self)
end

function PnlUnionWarReport:releaseBoxTotalReport()
    if self.boxTotalReportList then
        for k, v in pairs(self.boxTotalReportList) do
            CS.UIEventHandler.Clear(v.go.transform:Find("TxtGridPos").gameObject)
            CS.UIEventHandler.Clear(v.go.transform:Find("ButtonView/BtnDeTial").gameObject)
            CS.UIEventHandler.Clear(v.go.transform:Find("ButtonView/BtnInfo").gameObject)
            ResMgr:ReleaseAsset(v.go)
        end

        self.boxTotalReportList = {}
    end
end

function PnlUnionWarReport:onMyReportValueChange(percent)
    local y = self.view.contentMy.transform.localPosition.y
    local dec = y - self.myReportsContentY

    if dec > 0 then
        -- ""
        local nextTopBoxNum = self:getNextTopNum(self.topBoxNum)
        local nextTopDataId = self.boxMyUnionReportList[nextTopBoxNum].dataId

        if self.myReports[nextTopDataId] and y > self.myReports[nextTopDataId].nextY then
            local index = self.topBoxNum
            local nextBottomDataId = self.boxMyUnionReportList[self.bottomBoxNum].dataId + 1
            if self.myReports[nextBottomDataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_SELF, nextBottomDataId, index)
                self.bottomBoxNum = index
                self.topBoxNum = nextTopBoxNum
            end
        end

        local height = self.view.contentMy.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.height
        if y > height * 0.2 and not UnionData.noMyCampaignReportData then
            UnionData.C2S_Player_QueryStarmapCampaignReports(self.myReportNo, 5)
            self.myReportNo = self.myReportNo + 1
        end
    elseif dec < 0 then
        -- ""
        local nextBottomBoxNum = self:getNextBoxNum(self.bottomBoxNum)
        local nextBottomDataId = self.boxMyUnionReportList[nextBottomBoxNum].dataId
        if self.myReports[nextBottomDataId] and y + 548 < -self.myReports[nextBottomDataId].posY then
            local nextTopDataId = self.boxMyUnionReportList[self.topBoxNum].dataId - 1
            if self.myReports[nextTopDataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_SELF, nextTopDataId, self.bottomBoxNum)
                self.topBoxNum = self.bottomBoxNum
                self.bottomBoxNum = nextBottomBoxNum
            end
        end
    end

    self.myReportsContentY = y
end

function PnlUnionWarReport:getNextTopNum(topBoxNum)
    local nextTopBoxNum = topBoxNum + 1
    if nextTopBoxNum > PnlUnionWarReport.REPORT_MAX_NUM then
        nextTopBoxNum = 1
    end
    return nextTopBoxNum
end

function PnlUnionWarReport:getNextBoxNum(bottomBoxNum)
    local nextBottomBoxNum = bottomBoxNum - 1
    if nextBottomBoxNum < 1 then
        nextBottomBoxNum = PnlUnionWarReport.REPORT_MAX_NUM
    end
    return nextBottomBoxNum
end

function PnlUnionWarReport:setMyReport(contentSize)
    self.view.contentMy:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, contentSize)
    for i = 1, #self.boxMyUnionReportList, 1 do
        if self.boxMyUnionReportList[i].dataId == 0 then
            local nextBottomDataId = self.boxMyUnionReportList[self.bottomBoxNum].dataId + 1
            if self.myReports[nextBottomDataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_SELF, nextBottomDataId, i)
                self.bottomBoxNum = i
            end
        else
            if self.myReports[self.boxMyUnionReportList[i].dataId] then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_SELF, self.boxMyUnionReportList[i].dataId, i)
            end
        end
    end

    if #self.boxMyUnionReportList > 0 then
        return
    end
    self.boxMyUnionReportList = {}
    self.myReportsContentY = 0
    self.topBoxNum = 1
    self.bottomBoxNum = PnlUnionWarReport.REPORT_MAX_NUM
    if #self.myReports < PnlUnionWarReport.REPORT_MAX_NUM then
        self.bottomBoxNum = #self.myReports
    end

    self.view.contentMy:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)
    self.view.contentMy.gameObject:SetActiveEx(false)
    for j = 1, PnlUnionWarReport.REPORT_MAX_NUM, 1 do
        local cueNumJ = j
        ResMgr:LoadGameObjectAsync("BoxStarmapCampaign", function(go)
            go.transform:SetParent(self.view.contentMy, false)
            local gos = {
                go = go,
                -- singleGos = {},
                dataId = 0
                -- totalGo = go,
            }

            table.insert(self.boxMyUnionReportList, gos)
            local data = self.myReports[cueNumJ]
            if data then
                self:setStarmapCampaignReports(BattleData.BATTLE_TYPE_SELF, cueNumJ, cueNumJ)
            else
                go:SetActiveEx(false)
            end
            if cueNumJ == PnlUnionWarReport.REPORT_MAX_NUM then
                self.view.contentMy.gameObject:SetActiveEx(true)
            end
            go.transform:Find("ButtonView/BtnDeTial").gameObject:SetActiveEx(false)
            CS.UIEventHandler.Get(go.transform:Find("TxtGridPos").gameObject):SetOnClick(function()
                self:onTxtGridPos(BattleData.BATTLE_TYPE_SELF, cueNumJ)
            end, "event:/UI_button_click", "se_UI", false)
            -- CS.UIEventHandler.Get(go.transform:Find("ButtonView/BtnDeTial").gameObject):SetOnClick(function()
            --     self:onBtnDeTial(BattleData.BATTLE_TYPE_SELF, cueNumJ)
            -- end, "event:/UI_button_click", "se_UI", false)
            CS.UIEventHandler.Get(go.transform:Find("ButtonView/BtnInfo").gameObject):SetOnClick(function()
                self:onBtnInfo(BattleData.BATTLE_TYPE_SELF, cueNumJ)
            end, "event:/UI_button_click", "se_UI", false)

            return true
        end, true)
    end
end

function PnlUnionWarReport:releaseBoxSingleReport()
    if self.boxMyUnionReportList then
        for k, data in pairs(self.boxMyUnionReportList) do
            CS.UIEventHandler.Clear(data.go.transform:Find("TxtGridPos").gameObject)
            --CS.UIEventHandler.Clear(data.go.transform:Find("ButtonView/BtnDeTial").gameObject)
            CS.UIEventHandler.Clear(data.go.transform:Find("ButtonView/BtnInfo").gameObject)
            ResMgr:ReleaseAsset(data.go)
        end
        self.boxMyUnionReportList = {}
    end
end

function PnlUnionWarReport:onSetReportData()
    local size = self:initUnionReportData()
    self:setUnionReport(size)
end

function PnlUnionWarReport:initUnionReportData()
    self.unionReports = {}
    local nextY = 0
    for k, v in ipairs(UnionData.unionReports) do
        local data = {}
        data, nextY = self:calcUnionReportSize(v, nextY)
        table.insert(self.unionReports, data)
    end

    return -nextY
end

function PnlUnionWarReport:calcUnionReportSize(data, nextY)
    if data then
        data.boxSize = 180
        data.posY = nextY
        nextY = nextY - data.boxSize - 10
        data.nextY = -nextY

        return data, nextY
    end
end

function PnlUnionWarReport:onSetMyReport()
    self.myReports = {}
    local nextY = 0
    for i, v in ipairs(UnionData.myReports) do
        local data = v
        data.boxSize = 180
        data.posY = nextY
        nextY = nextY - data.boxSize - 10
        data.nextY = -nextY

        table.insert(self.myReports, data)
    end
    self:setMyReport(-nextY)
end

return PnlUnionWarReport
