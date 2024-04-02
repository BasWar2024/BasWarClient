PnlHyList = class("PnlHyList", ggclass.UIBase)

PnlHyList.INDIVDUAL = 5
PnlHyList.GUILD = 6

function PnlHyList:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onRankChange"}
end

function PnlHyList:onAwake()
    self.view = ggclass.PnlHyListView.new(self.pnlTransform)

    self.flagCfg = cfg["flag"]

    self.leftButtonType = PnlHyList.INDIVDUAL

    self.viewLists = {
        [PnlHyList.INDIVDUAL] = self.view.viewListI,
        [PnlHyList.GUILD] = self.view.viewListG
    }

    self.contents = {
        [PnlHyList.INDIVDUAL] = self.view.contentI,
        [PnlHyList.GUILD] = self.view.contentG
    }

    self.boxHyLists = {
        [PnlHyList.INDIVDUAL] = {},
        [PnlHyList.GUILD] = {}
    }
    self.version = {}

    self.showTypeInfo = {
        [PnlHyList.SHOW_TYPE_PERSONAL] = {
            view = self.view.viewList,
            func = gg.bind(self.onBtnIndividual, self),
            funcClose = nil,
        },

        [PnlHyList.SHOW_TYPE_UNION] = {
            view = self.view.viewList,
            func = gg.bind(self.onBtnGuild, self),
            funcClose = nil,
        },

        [PnlHyList.SHOW_TYPE_FIRST_SLOT] = {
            view = self.view.layoutFirstPlot,
            func = gg.bind(self.openFirstSlot, self),
            funcClose = gg.bind(self.closeFirstSlot, self),
        },

        [PnlHyList.SHOW_TYPE_OPEN_SERVER_UNION] = {
            view = self.view.layoutOpenServerUnionRank,
            func = gg.bind(self.openOpenServerUnion, self),
            funcClose = gg.bind(self.closeOpenServerUnion, self),
        },

        [PnlHyList.SHOW_TYPE_OPEN_PVP] = {
            view = self.view.layoutOpenServerPVPRank,
            func = gg.bind(self.openOpenServerPVPRank, self),
            funcClose = gg.bind(self.closeOpenServerPVPRank, self),
        },
    }

    self.leftBtnViewBgBtnsBox = ViewOptionBtnBox.new(self.view.leftBtnViewBgBtnsBox)

    self.hyListFirstPlotBox = HyListFirstPlotBox.new(self.view.hyListFirstPlotBox)
    self.openServerUnionRankBox = OpenServerUnionRankBox.new(self.view.openServerUnionRankBox)

    self.openServerPVPRankBox = OpenServerPVPRankBox.new(self.view.openServerPVPRankBox)
end

function PnlHyList:onShow()
    self:bindEvent()
    self.isLoading = false
    self:setLeftButton(self.leftButtonType)

    self.leftBtnViewBgBtnsBox:setBtnDataList({
        {
            nemeKey = "hyRank_Left_Personal",
            callback = gg.bind(self.refresh, self, PnlHyList.SHOW_TYPE_PERSONAL),
        },

        {
            nemeKey = "hyRank_Left_Dao",
            callback = gg.bind(self.refresh, self, PnlHyList.SHOW_TYPE_UNION),
        },

        {
            nemeKey = "hyRank_Left_OccupyPlotSprint",
            callback = gg.bind(self.refresh, self, PnlHyList.SHOW_TYPE_FIRST_SLOT),
            activityCfgId = constant.FIRST_GET_GRID,
        },

        {
            nemeKey = "hyRank_Left_DaoCompetition",
            callback = gg.bind(self.refresh, self, PnlHyList.SHOW_TYPE_OPEN_SERVER_UNION),
            activityCfgId = constant.OPEN_UNION,
        },

        {
            nemeKey = "hyRank_Left_PvpRankingSprint",
            callback = gg.bind(self.refresh, self, PnlHyList.SHOW_TYPE_OPEN_PVP),
            activityCfgId = constant.OPEN_PVP,
        },

    }, 1)

    self.leftBtnViewBgBtnsBox:open()
end

PnlHyList.SHOW_TYPE_PERSONAL = 1
PnlHyList.SHOW_TYPE_UNION = 2
PnlHyList.SHOW_TYPE_FIRST_SLOT = 3
PnlHyList.SHOW_TYPE_OPEN_SERVER_UNION = 4
PnlHyList.SHOW_TYPE_OPEN_PVP = 5

function PnlHyList:refresh(showType)
    self.showType = showType

    print("showType", showType)

    for key, value in pairs(self.showTypeInfo) do
        value.view:SetActiveEx(false)

        if key ~= showType then
            if value.funcClose then
                value.funcClose()
            end
        end
    end

    local info = self.showTypeInfo[showType]
    info.view:SetActiveEx(true)
    info.func()
end

----------SHOW_TYPE_FIRST_SLOT
function PnlHyList:openFirstSlot()
    self.hyListFirstPlotBox:open()
end

function PnlHyList:closeFirstSlot()
    self.hyListFirstPlotBox:close()

end

------SHOW_TYPE_OPEN_SERVER_UNION

function PnlHyList:openOpenServerUnion()
    self.openServerUnionRankBox:open()
end

function PnlHyList:closeOpenServerUnion()
    self.openServerUnionRankBox:close()
end

--------SHOW_TYPE_OPEN_PVP
function PnlHyList:openOpenServerPVPRank()
    self.openServerPVPRankBox:open()
end

function PnlHyList:closeOpenServerPVPRank()
    self.openServerPVPRankBox:close()
end

-------------------------------------------

function PnlHyList:onHide()
    self:releaseEvent()
    self.leftBtnViewBgBtnsBox:close()
end

function PnlHyList:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnRule):SetOnClick(function()
        self:onBtnRule()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlHyList:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnRule)
    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlHyList:onDestroy()
    local view = self.view

    for k, v in pairs(self.boxHyLists) do
        self:releaseBoxHyList(k)
    end
    self.flagCfg = nil
    self.boxHyLists = nil
    self.viewLists = nil
    self.contents = nil
    self.version = nil

    self.leftBtnViewBgBtnsBox:release()
    self.hyListFirstPlotBox:release()
    self.openServerUnionRankBox:release()
    self.openServerPVPRankBox:release()
end

-------------------------------------------------
function PnlHyList:onBtnRule()

end

function PnlHyList:onBtnClose()
    self:close()
end

function PnlHyList:onBtnIndividual()
    if self.leftButtonType ~= PnlHyList.INDIVDUAL then
        self:setLeftButton(PnlHyList.INDIVDUAL)
    end
end

function PnlHyList:onBtnGuild()
    if self.leftButtonType ~= PnlHyList.GUILD then
        self:setLeftButton(PnlHyList.GUILD)
    end
end

function PnlHyList:setLeftButton(type)
    self.leftButtonType = type
    local titelName = {
        [PnlHyList.INDIVDUAL] = "hyRank_PersonNameTag",
        [PnlHyList.GUILD] = "hyRank_DaoNameTag"
    }
    self.view.titelName.text = Utils.getText(titelName[type])

    for k, v in pairs(self.viewLists) do
        v:SetActiveEx(false)
    end
    self.view.boxHyList:SetActiveEx(false)
    self.viewLists[type]:SetActiveEx(true)
    self.rankType = type
    if RankData.rankMap[type] then
        if self.version[type] ~= RankData.rankMap[type].version then
            self:loadBoxHyList()
        else
            self:setMyBoxHyList()
        end
    end

    RankData.C2S_Player_Rank_Info(type)
end

function PnlHyList:onRankChange(args, type, version)
    if type == RankData.RANK_TYPE_HY_INDIVDUAL or type == RankData.RANK_TYPE_HY_GUILD then
        self.rankType = type
        if not self.isLoading then
            self:loadBoxHyList()
        else
            self:setMyBoxHyList()
        end
    end
end

PnlHyList.BGRANKNAME = {
    [1] = "HyList_Atlas[first baseboard_icon]",
    [2] = "HyList_Atlas[second baseboard_icon]",
    [3] = "HyList_Atlas[third baseboard_icon]"
}

PnlHyList.ICONRANKNAME = {
    [1] = "HyList_Atlas[first_icon_A]",
    [2] = "HyList_Atlas[first_icon_B]",
    [3] = "HyList_Atlas[first_icon_C]"
}
function PnlHyList:setMyBoxHyList()
    local selfRank = RankData.rankMap[self.rankType].selfRank
    if selfRank then
        if selfRank.headIcon == "" or selfRank.index == 0 then
            self.view.boxHyList:SetActiveEx(false)
            self.view.txtTips:SetActiveEx(true)
        else
            self.view.boxHyList:SetActiveEx(true)
            self.view.txtTips:SetActiveEx(false)

            self.view.txtRank.text = selfRank.index
            self.view.txtName.text = selfRank.name
            self.view.txtHy.text = math.floor(selfRank.value / 1000) -- Utils.scientificNotationInt(selfRank.value / 1000)
            local atlas = "Head_Atlas"
            local iconName = selfRank.headIcon
            if not iconName or iconName == "" then
                iconName = "profile phpto 20_icon"
            end
            if self.rankType == PnlHyList.GUILD then
                atlas = "ContryFlag_Atlas"
                local num = tonumber(selfRank.headIcon)
                iconName = self.flagCfg[num].icon
            end

            local iconName = gg.getSpriteAtlasName(atlas, iconName)
            gg.setSpriteAsync(self.view.iconHead, iconName)
        end
    else
        self.view.boxHyList:SetActiveEx(false)
        self.view.txtTips:SetActiveEx(true)
    end

end

function PnlHyList:loadBoxHyList()
    self.viewLists[self.rankType]:SetActiveEx(true)
    self.version[self.rankType] = RankData.rankMap[self.rankType].version
    self:releaseBoxHyList(self.rankType)
    self.boxHyLists[self.rankType] = {}
    local dataList = RankData.rankMap[self.rankType].dataList
    local dataListCound = #dataList
    self.isLoading = false
    self:setMyBoxHyList()

    if dataListCound > 0 then
        self.isLoading = true
        local num = 0
        for k, v in pairs(dataList) do
            ResMgr:LoadGameObjectAsync("BoxHyList", function(go)
                go.transform:SetParent(self.contents[self.rankType], false)

                if v.index < 4 then
                    go.transform:Find("BgRank").gameObject:SetActiveEx(true)
                    go.transform:Find("TxtRank").gameObject:SetActiveEx(false)
                    local bgRank = go.transform:Find("BgRank"):GetComponent(UNITYENGINE_UI_IMAGE)
                    local iconRank = go.transform:Find("BgRank/IconRank"):GetComponent(UNITYENGINE_UI_IMAGE)
                    gg.setSpriteAsync(bgRank, PnlHyList.BGRANKNAME[v.index])
                    gg.setSpriteAsync(iconRank, PnlHyList.ICONRANKNAME[v.index])

                else
                    go.transform:Find("BgRank").gameObject:SetActiveEx(false)
                    go.transform:Find("TxtRank").gameObject:SetActiveEx(true)
                    go.transform:Find("TxtRank"):GetComponent(UNITYENGINE_UI_TEXT).text = v.index
                end

                go.transform:Find("BgHead/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = v.name
                go.transform:Find("TxtHy"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    string.format("%.0f", v.value / 1000)

                local iconHead = go.transform:Find("BgHead/Mask/IconHead"):GetComponent(UNITYENGINE_UI_IMAGE)
                local atlas = "Head_Atlas"
                local iconName = v.headIcon
                if not iconName or iconName == "" then
                    iconName = "profile phpto 20_icon"
                end
                if self.rankType == PnlHyList.GUILD then
                    atlas = "ContryFlag_Atlas"
                    local num = tonumber(v.headIcon)
                    iconName = self.flagCfg[num].icon
                end

                local iconName = gg.getSpriteAtlasName(atlas, iconName)

                gg.setSpriteAsync(iconHead, iconName)
                table.insert(self.boxHyLists[self.rankType], go)
                num = num + 1
                if num == dataListCound then
                    self.isLoading = false
                end
                return true
            end, true)
        end

    end
end

function PnlHyList:releaseBoxHyList(type)
    if self.boxHyLists[type] then
        for k, go in pairs(self.boxHyLists[type]) do
            ResMgr:ReleaseAsset(go)
        end
        self.boxHyLists[type] = nil
    end
end

-------------------------------------------------------------------------------

return PnlHyList
