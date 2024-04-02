PnlBattleReport = class("PnlBattleReport", ggclass.UIBase)

function PnlBattleReport:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onLoadBattleReport"}
end
PnlBattleReport.FILTER_TYPE_ALL = 1
PnlBattleReport.FILTER_TYPE_ATTACK = 2
PnlBattleReport.FILTER_TYPE_DEFENSIVE = 3

PnlBattleReport.FILTER_NAME = {
    [PnlBattleReport.FILTER_TYPE_ALL] = "replay_Filter_All",
    [PnlBattleReport.FILTER_TYPE_ATTACK] = "replay_Filter_Attack",
    [PnlBattleReport.FILTER_TYPE_DEFENSIVE] = "replay_Filter_Defence"
}

function PnlBattleReport:onAwake()
    self.view = ggclass.PnlBattleReportView.new(self.pnlTransform)

    self.boxReport = nil -- ""

    self.leftBtnViewBgBtnsBox = ItemBagOptionBtns.new(self.view.leftBtnViewBgBtnsBox)

    self.leftBtnDataList = {{
        name = Utils.getText(PnlBattleReport.FILTER_NAME[PnlBattleReport.FILTER_TYPE_ALL]),
        callback = gg.bind(self.onBtnFilter, self, PnlBattleReport.FILTER_TYPE_ALL)
    }, {
        name = Utils.getText(PnlBattleReport.FILTER_NAME[PnlBattleReport.FILTER_TYPE_ATTACK]),
        callback = gg.bind(self.onBtnFilter, self, PnlBattleReport.FILTER_TYPE_ATTACK)
    }, {
        name = Utils.getText(PnlBattleReport.FILTER_NAME[PnlBattleReport.FILTER_TYPE_DEFENSIVE]),
        callback = gg.bind(self.onBtnFilter, self, PnlBattleReport.FILTER_TYPE_DEFENSIVE)
    }}

    self.leftBtnViewBgBtnsBox:setBtnDataList(self.leftBtnDataList)

    self.topButtonView = BattleReportTopButton.new(self.view.topButtonView, BattleReportTopButton.OPEN_TYPE_BASE)
end

function PnlBattleReport:onShow()
    self:bindEvent()
    local type = self.args or BattleData.BATTLE_TYPE_PVE
    self.topButtonView:onBtnTop(type)
    self.leftBtnViewBgBtnsBox.gameObject:SetActiveEx(false)
    self.leftBtnViewBgBtnsBox:setBtnStageWithoutNotify(1)

    self.filterType = PnlBattleReport.FILTER_TYPE_ALL
    self.view.txtFilter.text = Utils.getText(PnlBattleReport.FILTER_NAME[PnlBattleReport.FILTER_TYPE_ALL])
end

function PnlBattleReport:onHide()
    self:releaseEvent()
    self:unLoadBoxReport()

end

function PnlBattleReport:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnOpenFilter):SetOnClick(function()
        self:onBtnOpenFilter()
    end)

end

function PnlBattleReport:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnOpenFilter)

end

function PnlBattleReport:onDestroy()
    local view = self.view
    self.leftBtnViewBgBtnsBox:release()
    self.topButtonView:release()
    self.topButtonView = nil

end

function PnlBattleReport:onBtnClose()
    local window = gg.uiManager:getWindow("PnlUnionWarReport")
    if window then
        gg.uiManager:destroyWindow("PnlUnionWarReport")
    end
    UnionData.unionReports = {}
    UnionData.myReports = {}
    BattleReportData.battleReport = {}
    self.destroyTime = 5
    self:close()
end

function PnlBattleReport:onBtnOpenFilter()
    self.leftBtnViewBgBtnsBox.gameObject:SetActiveEx(not self.leftBtnViewBgBtnsBox.gameObject.activeSelf)
end

function PnlBattleReport:onBtnFilter(filterType, isForce)
    if not isForce and self.filterType == filterType then
        return
    end

    self.filterType = filterType
    self.view.txtFilter.text = Utils.getText(PnlBattleReport.FILTER_NAME[filterType])
    self.leftBtnViewBgBtnsBox.gameObject:SetActiveEx(false)

    self:loadBattleReport(self.battleType)
end

function PnlBattleReport:onBtnBattle(battleId)
    if battleId then
        -- gg.sceneManager:addEnterSceneOpenWindows(constant.SCENE_BASE, "PnlPvp")
        BattleData.C2S_Player_LookBattlePlayBack(battleId, CS.Appconst.BattleVersion, gg.uiManager:getWindow("PnlPvp"))
    end
end

function PnlBattleReport:onLoadBattleReport(args, battleType)
    self:loadBattleReport(battleType)
end

function PnlBattleReport:loadBattleReport(battleType)
    self:unLoadBoxReport()
    self.battleType = battleType
    self.boxReport = {}
    local newTable = BattleReportData.battleReport[battleType]
    if self.filterType == PnlBattleReport.FILTER_TYPE_ATTACK then
        newTable = {}
        for k, v in pairs(BattleReportData.battleReport[battleType]) do
            if v.isAttacker then
                table.insert(newTable, v)
            end
        end
    elseif self.filterType == PnlBattleReport.FILTER_TYPE_DEFENSIVE then
        newTable = {}
        for k, v in pairs(BattleReportData.battleReport[battleType]) do
            if not v.isAttacker then
                table.insert(newTable, v)
            end
        end
    end

    local conten = self.view.content.transform
    UIUtil.loadScrollView(newTable, 0, 0, 0, -270, 1, 0, conten, "BoxReport", function(obj, data)
        self:setReportData(obj, data)
        CS.UIEventHandler.Get(obj.transform:Find("BtnBattle").gameObject):SetOnClick(function()
            self:onBtnBattle(data.fightId)
        end)
        table.insert(self.boxReport, obj)
    end)
end

-- PnlBattleReport.REPORT_RESULT = {"replay_AtkFail", "replay_AtkSuccess", "replay_DefFail", "replay_DefSuccess"}

PnlBattleReport.REPORT_RESOBJ = {
    [constant.RES_STARCOIN] = "IconStarCoin",
    [constant.RES_ICE] = "IconIce",
    [constant.RES_TITANIUM] = "IconTitanium",
    [constant.RES_GAS] = "IconGas",
    [constant.RES_CARBOXYL] = "IconHydroxyl",
    [constant.RES_TESSERACT] = "IconTesseract"
}

function PnlBattleReport:setReportData(obj, data)
    local brief = self:getBrief(data)
    local isAttacker = data.isAttacker
    local result = data.result
    local battleName = ""

    local playerName = data.enemyPlayerName
    if isAttacker then
        playerName = PlayerData.getName()
    end

    battleName = Utils.getText("replay_Attacker") .. " - " .. playerName
    obj.transform:Find("TxtPlayerType"):GetComponent(UNITYENGINE_UI_TEXT).text = battleName

    gg.setSpriteAsync(obj.transform:Find("TopBg"):GetComponent(UNITYENGINE_UI_IMAGE), PnlBattleReport.TOP_BG_NAME[brief])

    local bottomBgName = "BattleReport_Atlas[Defeat_icon]"
    local resultIconName = "BattleReport_Atlas[defeat01_icon]"
    if result == 1 then
        bottomBgName = "BattleReport_Atlas[Victory_icon]"
        resultIconName = "BattleReport_Atlas[victory01]"
    end
    gg.setSpriteAsync(obj.transform:Find("BottomBg"):GetComponent(UNITYENGINE_UI_IMAGE), bottomBgName)
    gg.setSpriteAsync(obj.transform:Find("ImgResult"):GetComponent(UNITYENGINE_UI_IMAGE), resultIconName)

    for k, v in pairs(PnlBattleReport.REPORT_RESOBJ) do
        local path = "Res/" .. v
        obj.transform:Find(path).gameObject:SetActive(false)
    end

    for k, v in pairs(data.currencies) do
        if v.count and v.count > 0 then
            local path = "Res/" .. PnlBattleReport.REPORT_RESOBJ[v.resCfgId]
            local temp = Utils.scientificNotationInt(v.count / 1000)
            obj.transform:Find(path .. "/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = temp
            obj.transform:Find(path).gameObject:SetActive(true)
            if brief == 3 then
                obj.transform:Find(path .. "/Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0xfe / 0xff,
                    0x2f / 0xff, 0x2f / 0xff)
            else
                obj.transform:Find(path .. "/Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0xff / 0xff,
                    0xd7 / 0xff, 0x42 / 0xff)
            end
        end
    end

    local txtScore = obj.transform:Find("Res/IconScore/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    txtScore.color = Color.New(0xff / 0xff, 0xd7 / 0xff, 0x42 / 0xff)

    local textScore = 0
    if isAttacker then
        textScore = data.atkBadge
        if data.atkBadge > 0 then
            obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(true)

            textScore = "+" .. textScore
        elseif data.atkBadge < 0 then
            obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(true)
        else

            obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(false)
        end
    else
        textScore = data.defenBadge
        if data.defenBadge > 0 then
            obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(true)

            textScore = "+" .. textScore
        elseif data.defenBadge < 0 then
            obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(true)
        else
            obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(false)
        end
    end

    txtScore.text = textScore

    if not isAttacker then
        obj.transform:Find("Res/IconScore").gameObject:SetActiveEx(false)
    end

    for i = 1, 5, 1 do
        local path = "BattleReportHeroList/BattleReportHeroItem" .. i
        obj.transform:Find(path).gameObject:SetActive(false)
    end

    if data.heros then
        for k, v in pairs(data.heros) do
            local path = "BattleReportHeroList/BattleReportHeroItem" .. k
            local heroGo = obj.transform:Find(path).gameObject
            local cfgId = v.cfgId
            local quality = v.quality
            local level = v.level

            local myCfg = cfg.getCfg("hero", cfgId, level, quality)

            UIUtil.setQualityBg(heroGo.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)

            local headIcon = gg.getSpriteAtlasName("Hero_A_Atlas", myCfg.icon .. "_A")

            gg.setSpriteAsync(heroGo.transform:Find("Mask/ImgHero"):GetComponent(UNITYENGINE_UI_IMAGE), headIcon)

            heroGo.transform:Find("Image/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "lv." .. level

            heroGo:SetActive(true)
        end
    end

    obj.transform:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = gg.time.utcDate(data.fightTime)

end

PnlBattleReport.TOP_BG_NAME = {
    [1] = "BattleReport_Atlas[fightdefeat_icon]",
    [2] = "BattleReport_Atlas[fightvictory_icon]",
    [3] = "BattleReport_Atlas[defenddefeat_icon]",
    [4] = "BattleReport_Atlas[defendvictory_icon]"
}

function PnlBattleReport:getBrief(data)
    local isAttacker = data.isAttacker
    local fightType = data.resPlanetIndex
    local result = data.result
    local brief = 1

    if isAttacker then
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

function PnlBattleReport:unLoadBoxReport()
    if self.boxReport then
        for k, v in pairs(self.boxReport) do
            CS.UIEventHandler.Clear(v.transform:Find("BtnBattle").gameObject)
            ResMgr:ReleaseAsset(v)
        end
        self.boxReport = {}
    end
end

return PnlBattleReport
