PnlUnionWarReportInfo = class("PnlUnionWarReportInfo", ggclass.UIBase)
PnlUnionWarReportInfo.REPORT_MAX_NUM = 5

function PnlUnionWarReportInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"setUnionWarReportInfo"}
end

function PnlUnionWarReportInfo:onAwake()
    self.view = ggclass.PnlUnionWarReportInfoView.new(self.pnlTransform)
    self.boxMyUnionReportList = {}

end

function PnlUnionWarReportInfo:onShow()
    self.view.contentMy:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)
    self.topBoxNum = 1
    self.bottomBoxNum = PnlUnionWarReportInfo.REPORT_MAX_NUM

    self:bindEvent()

    if self.args.type == BattleData.BATTLE_TYPE_RES_PLANNET then
        UnionData.C2S_Player_QueryUnionStarmapBattleReports(self.args.campaignId, 1, 5)
    elseif self.args.type == BattleData.BATTLE_TYPE_SELF then
        UnionData.C2S_Player_QueryStarmapBattleReports(self.args.campaignId, 1, 5)
    end
    self.myReportNo = 2
end

function PnlUnionWarReportInfo:onHide()
    self:releaseEvent()

    self:releaseBoxSingleReport()

    UnionData.unionCamReports = {}
    UnionData.myCamReports = {}
end

function PnlUnionWarReportInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    self.scrollViewMy = view.scrollViewMy.transform:GetComponent(UNITYENGINE_UI_SCROLLRECT)
    self.scrollViewMy.onValueChanged:AddListener(gg.bind(self.onMyReportValueChange, self))
end

function PnlUnionWarReportInfo:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    self.scrollViewMy.onValueChanged:RemoveAllListeners()

end

function PnlUnionWarReportInfo:onDestroy()
    local view = self.view

end

function PnlUnionWarReportInfo:onBtnClose()
    self:close()
end

function PnlUnionWarReportInfo:onBtnView(boxId, reportId)
    local dataId = self.boxMyUnionReportList[boxId].dataId
    local battleId = self.myReports[dataId].battleId
    BattleData.C2S_Player_LookBattlePlayBack(battleId, CS.Appconst.BattleVersion, self)
end

function PnlUnionWarReportInfo:getNextTopNum(topBoxNum)
    local nextTopBoxNum = topBoxNum + 1
    if nextTopBoxNum > PnlUnionWarReportInfo.REPORT_MAX_NUM then
        nextTopBoxNum = 1
    end
    return nextTopBoxNum
end

function PnlUnionWarReportInfo:getNextBoxNum(bottomBoxNum)
    local nextBottomBoxNum = bottomBoxNum - 1
    if nextBottomBoxNum < 1 then
        nextBottomBoxNum = PnlUnionWarReportInfo.REPORT_MAX_NUM
    end
    return nextBottomBoxNum
end

function PnlUnionWarReportInfo:onMyReportValueChange(percent)
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
                self:setStarmapCampaignReports(nextBottomDataId, index)
                self.bottomBoxNum = index
                self.topBoxNum = nextTopBoxNum
            end
        end

        local height = self.view.contentMy.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.height
        if y > height * 0.2 and not UnionData.noMyBattleReportData then
            if self.args.type == BattleData.BATTLE_TYPE_RES_PLANNET then
                UnionData.C2S_Player_QueryUnionStarmapBattleReports(self.args.campaignId, self.myReportNo, 5)
            elseif self.args.type == BattleData.BATTLE_TYPE_SELF then
                UnionData.C2S_Player_QueryStarmapBattleReports(self.args.campaignId, self.myReportNo, 5)
            end
            self.myReportNo = self.myReportNo + 1
        end
    elseif dec < 0 then
        -- ""
        local nextBottomBoxNum = self:getNextBoxNum(self.bottomBoxNum)
        local nextBottomDataId = self.boxMyUnionReportList[nextBottomBoxNum].dataId
        if self.myReports[nextBottomDataId] and y + 548 < -self.myReports[nextBottomDataId].posY then
            local nextTopDataId = self.boxMyUnionReportList[self.topBoxNum].dataId - 1
            if self.myReports[nextTopDataId] then
                self:setStarmapCampaignReports(nextTopDataId, self.bottomBoxNum)
                self.topBoxNum = self.bottomBoxNum
                self.bottomBoxNum = nextBottomBoxNum
            end
        end
    end

    self.myReportsContentY = y
end

function PnlUnionWarReportInfo:setMyReport(contentSize)
    self.view.contentMy:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, contentSize)
    for i = 1, #self.boxMyUnionReportList, 1 do
        if self.boxMyUnionReportList[i].dataId == 0 then
            local nextBottomDataId = self.boxMyUnionReportList[self.bottomBoxNum].dataId + 1
            if self.myReports[nextBottomDataId] then
                self:setStarmapCampaignReports(nextBottomDataId, i)
                self.bottomBoxNum = i
            end
        else
            if self.myReports[self.boxMyUnionReportList[i].dataId] then
                self:setStarmapCampaignReports(self.boxMyUnionReportList[i].dataId, i)
            end
        end
    end

    if #self.boxMyUnionReportList > 0 then
        return
    end
    self.boxMyUnionReportList = {}
    self.myReportsContentY = 0
    self.topBoxNum = 1
    self.bottomBoxNum = PnlUnionWarReportInfo.REPORT_MAX_NUM

    if #self.myReports < PnlUnionWarReportInfo.REPORT_MAX_NUM then
        self.bottomBoxNum = #self.myReports
    end
    self.view.contentMy:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)

    self.view.contentMy.gameObject:SetActiveEx(false)
    for j = 1, PnlUnionWarReportInfo.REPORT_MAX_NUM, 1 do
        local cueNumJ = j
        ResMgr:LoadGameObjectAsync("BoxStarmapReport", function(go)
            go.transform:SetParent(self.view.contentMy, false)
            local gos = {
                go = go,
                dataId = 0
            }

            table.insert(self.boxMyUnionReportList, gos)
            local data = self.myReports[cueNumJ]
            if data then
                self:setStarmapCampaignReports(cueNumJ, cueNumJ)
            else
                go:SetActiveEx(false)
            end
            if cueNumJ == PnlUnionWarReportInfo.REPORT_MAX_NUM then
                self.view.contentMy.gameObject:SetActiveEx(true)
            end
            CS.UIEventHandler.Get(go.transform:Find("BtnBattle").gameObject):SetOnClick(function()
                self:onBtnView(cueNumJ)
            end)

            return true
        end, true)
    end

end

PnlUnionWarReportInfo.TOP_BG_NAME = {
    [1] = "BattleReport_Atlas[fightdefeat_icon]",
    [2] = "BattleReport_Atlas[fightvictory_icon]",
    [3] = "BattleReport_Atlas[defenddefeat_icon]",
    [4] = "BattleReport_Atlas[defendvictory_icon]"
}

function PnlUnionWarReportInfo:setStarmapCampaignReports(dataId, boxId)
    local go
    local data
    self.boxMyUnionReportList[boxId].dataId = dataId
    go = self.boxMyUnionReportList[boxId].go
    data = self.myReports[dataId]

    if not data then
        return
    end

    go.transform.localPosition = Vector3(0, data.posY, 0)
    go:SetActiveEx(true)
    local brief = self:getBrief(data)
    local result = data.result

    go.transform:Find("TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = dataId

    local battleName = Utils.getText("replay_Attacker") .. " - " .. data.playerName
    go.transform:Find("TxtPlayerType"):GetComponent(UNITYENGINE_UI_TEXT).text = battleName

    go.transform:Find("TxtHp"):GetComponent(UNITYENGINE_UI_TEXT).text = "HP: " .. data.leftHp
    go.transform:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = gg.time.utcDate(data.battleTime)

    gg.setSpriteAsync(go.transform:Find("TopBg"):GetComponent(UNITYENGINE_UI_IMAGE),
        PnlUnionWarReportInfo.TOP_BG_NAME[brief])

    local bottomBgName = "BattleReport_Atlas[Defeat_icon]"
    local resultIconName = "BattleReport_Atlas[defeat01_icon]"
    if result == 1 then
        bottomBgName = "BattleReport_Atlas[Victory_icon]"
        resultIconName = "BattleReport_Atlas[victory01]"
    end
    gg.setSpriteAsync(go.transform:Find("BottomBg"):GetComponent(UNITYENGINE_UI_IMAGE), bottomBgName)
    gg.setSpriteAsync(go.transform:Find("ImgResult"):GetComponent(UNITYENGINE_UI_IMAGE), resultIconName)

    for i = 1, 5, 1 do
        local path = "BattleReportHeroList/BattleReportHeroAndSoliderItem" .. i
        go.transform:Find(path).gameObject:SetActive(false)
    end

    if data.heros then
        for k, v in pairs(data.heros) do
            local path = "BattleReportHeroList/BattleReportHeroAndSoliderItem" .. k
            local heroGo = go.transform:Find(path).gameObject
            local cfgId = v.cfgId
            local quality = v.quality
            local level = v.level

            local myCfg = cfg.getCfg("hero", cfgId, level, quality)

            UIUtil.setQualityBg(heroGo.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)

            local headIcon = gg.getSpriteAtlasName("Hero_A_Atlas", myCfg.icon .. "_A")

            gg.setSpriteAsync(heroGo.transform:Find("Mask/ImgHero"):GetComponent(UNITYENGINE_UI_IMAGE), headIcon)

            heroGo.transform:Find("Image/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "lv." .. level

            heroGo:SetActive(true)
            local solider = data.soliders[v.index]
            if solider then
                heroGo.transform:Find("SoliderBg").gameObject:SetActiveEx(true)
                local soliderCfg = cfg.getCfg("solider", solider.cfgId, solider.level)
                local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", soliderCfg.icon .. "_A")
                gg.setSpriteAsync(heroGo.transform:Find("SoliderBg/Mask/Image"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

            else
                heroGo.transform:Find("SoliderBg").gameObject:SetActiveEx(false)
            end
        end
    end

end

function PnlUnionWarReportInfo:getBrief(data)
    local playerId = data.playerId
    local unionId = data.unionId
    local result = data.result
    local brief = 1

    if playerId == gg.playerMgr.localPlayer:getPid() or unionId == UnionData.unionData.unionId then
        if result == 0 then
            -- ""
            brief = 1
        elseif result == 1 then
            -- ""
            brief = 2
        elseif result == 2 then
        end

    else
        if result == 0 then
            -- ""
            brief = 3
        elseif result == 1 then
            -- ""
            brief = 4
        elseif result == 2 then
        end
    end
    return brief
end

function PnlUnionWarReportInfo:releaseBoxSingleReport()
    if self.boxMyUnionReportList then
        for k, data in pairs(self.boxMyUnionReportList) do
            CS.UIEventHandler.Clear(data.go.transform:Find("BtnBattle").gameObject)
            ResMgr:ReleaseAsset(data.go)
        end
        self.boxMyUnionReportList = {}
    end
end

function PnlUnionWarReportInfo:setUnionWarReportInfo(args, battleReport)
    self.myReports = {}
    local nextY = -10
    for i, v in ipairs(battleReport) do
        local data = v
        data.boxSize = 224.4
        data.posY = nextY
        nextY = nextY - data.boxSize - 10
        data.nextY = -nextY

        table.insert(self.myReports, data)
    end
    self:setMyReport(-nextY)
end

return PnlUnionWarReportInfo
