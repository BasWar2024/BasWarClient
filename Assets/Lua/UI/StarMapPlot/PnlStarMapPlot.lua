PnlStarMapPlot = class("PnlStarMapPlot", ggclass.UIBase)

function PnlStarMapPlot:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.information
    self.events = {"onUnionUnionGridsChange", "onUnionPersonGridsChange", "OnGridDel"}
end

function PnlStarMapPlot:onAwake()
    self.view = ggclass.PnlStarMapPlotView.new(self.pnlTransform)

    -- self.plotItemList = {}
    -- self.plotScrollView = UILoopScrollView.new(self.view.plotScrollView, self.plotItemList)
    -- self.plotScrollView:setRenderHandler(gg.bind(self.onRenderPlotItem, self))

    self.isSortUp = true

    local globalCfg = cfg["global"]
    self.starMakePointCD = globalCfg.StarMakePointCD.intValue
end

PnlStarMapPlot.TYPE_UNION = 1
PnlStarMapPlot.TYPE_PERSON = 2

-- args = {type = , jumpCloseView = ,}
function PnlStarMapPlot:onShow()
    self:bindEvent()
    self.haveDaoData = false
    self.havePersonalData = false

    PnlStarMapPlot.DAO_SEL_NAME = {Utils.getText("league_MyPlot_Initial"), "Lv.1", "Lv.2", "Lv.3", "Lv.4", "Lv.5",
                                   "Lv.6", "Lv.7"}
    PnlStarMapPlot.MY_SEL_NAME = {Utils.getText("league_MyPlot_Initial"), "Lv.1", "Lv.2", "Lv.3", "Lv.4", "Lv.5",
                                  Utils.getText("league_MyPlot_Empty")}

    self.daoSelList = {}
    self.mySelList = {}
    for i, v in ipairs(self.view.toggle) do
        v.isOn = true
        table.insert(self.daoSelList, true)
        table.insert(self.mySelList, true)
    end
    table.insert(self.daoSelList, true)
    self.showingType = self.args.type
    self:setLeftButton()
    if self.showingType == PnlStarMapPlot.TYPE_UNION then
        UnionData.C2S_Player_StarmapMatchUnionGrids()
        self.view.txtTitle.text = Utils.getText("guild_DaoPlot_Title")
    elseif self.showingType == PnlStarMapPlot.TYPE_PERSON then
        UnionData.C2S_Player_StarmapMatchPersonalGrids()
        self.view.txtTitle.text = Utils.getText("league_DaoPlot_Title")
    end
end

-- PnlStarMapPlot.LEVEL_SORT_UP = 1
-- PnlStarMapPlot.LEVEL_SORT_DOWN = 2
PnlStarMapPlot.BUTTON_TXT_COLOR = {Color.New(1, 1, 1, 1), Color.New(0x3d / 0xff, 0x97 / 0xff, 1, 1)}

function PnlStarMapPlot:setLeftButton()
    local btnDao = self.view.btnDao
    local btnMy = self.view.btnMy

    local unionBool = true
    local myBool = false
    local unionColor = 1
    local myColor = 2

    if self.showingType == PnlStarMapPlot.TYPE_PERSON then
        unionBool = false
        myBool = true
        unionColor = 2
        myColor = 1
    end

    btnDao.transform:Find("Bg").gameObject:SetActiveEx(unionBool)
    -- btnDao.transform:Find("Sel").gameObject:SetActiveEx(unionBool)
    -- btnDao.transform:Find("NoSel").gameObject:SetActiveEx(not unionBool)
    btnDao.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = PnlStarMapPlot.BUTTON_TXT_COLOR[unionColor]

    btnMy.transform:Find("Bg").gameObject:SetActiveEx(myBool)
    -- btnMy.transform:Find("Sel").gameObject:SetActiveEx(myBool)
    -- btnMy.transform:Find("NoSel").gameObject:SetActiveEx(not myBool)
    btnMy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = PnlStarMapPlot.BUTTON_TXT_COLOR[myColor]

end

function PnlStarMapPlot:refresh()
    self.dataList = {}

    local getInin = function(cfg, bool)
        if bool and cfg.type == 3 then
            return true
        end
        return false
    end

    local getLevel = function(cfg, bool, level)
        if bool and cfg.level == level then
            return true
        end
        return false
    end

    local getEmpty = function(cfg, bool)
        if bool and cfg.subType == 0 then
            return true
        end
        return false
    end

    if self.showingType == PnlStarMapPlot.TYPE_UNION then
        self.haveDaoData = true
        for i, v in ipairs(self.view.toggle) do
            v.transform:Find("Label"):GetComponent(UNITYENGINE_UI_TEXT).text = PnlStarMapPlot.DAO_SEL_NAME[i]
            v.isOn = self.daoSelList[i]
            v.gameObject:SetActiveEx(true)
        end
        for k, data in pairs(UnionData.starmapMatchUnionGrids.list) do
            local cfg = gg.galaxyManager:getGalaxyCfg(data.gridCfgId)
            if getInin(cfg, self.daoSelList[1]) or getLevel(cfg, self.daoSelList[2], 1) or
                getLevel(cfg, self.daoSelList[3], 2) or getLevel(cfg, self.daoSelList[4], 3) or
                getLevel(cfg, self.daoSelList[5], 4) or getLevel(cfg, self.daoSelList[6], 5) or
                getLevel(cfg, self.daoSelList[7], 6) or getLevel(cfg, self.daoSelList[8], 7) then
                table.insert(self.dataList, data)
            end
        end

    elseif self.showingType == PnlStarMapPlot.TYPE_PERSON then
        self.havePersonalData = true
        for i, v in ipairs(self.view.toggle) do
            if PnlStarMapPlot.MY_SEL_NAME[i] then
                v.transform:Find("Label"):GetComponent(UNITYENGINE_UI_TEXT).text = PnlStarMapPlot.MY_SEL_NAME[i]
                v.isOn = self.mySelList[i]
                v.gameObject:SetActiveEx(true)
            else
                v.gameObject:SetActiveEx(false)
            end

        end

        for k, data in pairs(UnionData.starmapMatchPersonalGrids.list) do
            local cfg = gg.galaxyManager:getGalaxyCfg(data.gridCfgId)
            if getInin(cfg, self.mySelList[1]) or getLevel(cfg, self.mySelList[2], 1) or
                getLevel(cfg, self.mySelList[3], 2) or getLevel(cfg, self.mySelList[4], 3) or
                getLevel(cfg, self.mySelList[5], 4) or getLevel(cfg, self.mySelList[6], 5) or
                getEmpty(cfg, self.mySelList[7]) then
                table.insert(self.dataList, data)
            end
        end
    end

    self:setLeftButton()
    table.sort(self.dataList, function(a, b)
        local CfgA = gg.galaxyManager:getGalaxyCfg(a.gridCfgId)
        local CfgB = gg.galaxyManager:getGalaxyCfg(b.gridCfgId)

        if CfgA.level ~= CfgB.level then
            return (CfgA.level > CfgB.level) == self.isSortUp
        end
        return a.gridCfgId < b.gridCfgId
    end)

    if self.isSortUp then
        self.view.imgLevelSort.transform.localScale = Vector3(1, -1, 1)
    else
        self.view.imgLevelSort.transform.localScale = Vector3(1, 1, 1)
    end
    -- self.plotScrollView:setDataCount(#self.dataList)
    self:releaseStarMapPlotItemList()
    self.starMapPlotItemList = {}
    for k, v in pairs(self.dataList) do
        ResMgr:LoadGameObjectAsync("StarMapPlotItem", function(go)
            go.transform:SetParent(self.view.content, false)
            local item = StarMapPlotItem.new(go, self)
            item:setData(v)
            table.insert(self.starMapPlotItemList, item)
            return true
        end, true)
    end
end

function PnlStarMapPlot:releaseStarMapPlotItemList()
    if self.starMapPlotItemList then
        for k, v in pairs(self.starMapPlotItemList) do
            v:release()
        end
        self.starMapPlotItemList = nil
    end
end

function PnlStarMapPlot:refreshScore()
    local view = self.view

    local score = 0

    for key, value in pairs(self.dataList) do
        local cfg = gg.galaxyManager:getGalaxyCfg(value.gridCfgId)
        score = score + cfg.point
    end
    score = score * 3600 / self.starMakePointCD
    if self.showingType == PnlStarMapPlot.TYPE_UNION then
        local personalScore = UnionData.starmapMatchUnionGrids.personScore

        view.txtLandCount.text = string.format("<size=40><color=#ffae00>%s</color></size>/%s", #self.dataList - 1,
            cfg.global.GridUnionMax.intValue)

        view.textScoreDesc.text = string.format("%s:<color=#ffae00>%s /h</color>",
            Utils.getText("guild_DaoPlot_TotalScore"), score)
        view.textScoreDesc:SetActiveEx(true)
    elseif self.showingType == PnlStarMapPlot.TYPE_PERSON then
        local vipLevel = VipData.vipData.vipLevel
        local vipCfg = cfg.vip[vipLevel]
        self.dataList = UnionData.starmapMatchPersonalGrids.list

        view.txtLandCount.text = string.format("<size=40><color=#ffae00>%s</color></size>/%s", #self.dataList - 1,
            vipCfg.gridPlayerMax)
        view.textScoreDesc.text = string.format("%s<color=#ffae00>%s /h</color>",
            Utils.getText("league_DaoPlot_TotalScore"), score)
        view.textScoreDesc:SetActiveEx(false)

    end
end

function PnlStarMapPlot:onRenderPlotItem(obj, index)
    local item = StarMapPlotItem:getItem(obj, self.plotItemList, self)
    item:setData(self.dataList[index])
end

function PnlStarMapPlot:onUnionUnionGridsChange()
    if self.showingType == PnlStarMapPlot.TYPE_UNION then
        self:refresh()
        self:refreshScore()
    end
end

function PnlStarMapPlot:onUnionPersonGridsChange()
    if self.showingType == PnlStarMapPlot.TYPE_PERSON then
        self:refresh()
        self:refreshScore()
    end
end

function PnlStarMapPlot:OnGridDel()
    if self.showingType == PnlStarMapPlot.TYPE_UNION then
        UnionData.C2S_Player_StarmapMatchUnionGrids()
    elseif self.showingType == PnlStarMapPlot.TYPE_PERSON then
        UnionData.C2S_Player_StarmapMatchPersonalGrids()
    end
end

function PnlStarMapPlot:onHide()
    self:releaseEvent()
    self:releaseStarMapPlotItemList()

end

function PnlStarMapPlot:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnDao):SetOnClick(function()
        self:onBtnChangeShowingType(PnlStarMapPlot.TYPE_UNION)
    end)
    CS.UIEventHandler.Get(view.btnMy):SetOnClick(function()
        self:onBtnChangeShowingType(PnlStarMapPlot.TYPE_PERSON)
    end)

    for i, v in ipairs(view.toggle) do
        CS.UIEventHandler.Get(v.gameObject):SetOnClick(function()
            self:onToggle(i)
        end)

        -- v.onValueChanged:AddListener(gg.bind(self.onToggle, self, i))
    end

    self:setOnClick(self.view.btnLevelSort, gg.bind(self.onBtnLevelSort, self))

end

function PnlStarMapPlot:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnDao)
    CS.UIEventHandler.Clear(view.btnMy)

    for i, v in ipairs(view.toggle) do
        CS.UIEventHandler.Clear(v.gameObject)

        -- v.onValueChanged:RemoveAllListeners()
    end

end

function PnlStarMapPlot:onToggle(index)
    if self.showingType == PnlStarMapPlot.TYPE_UNION then
        self.daoSelList[index] = not self.daoSelList[index]
        self.view.toggle[index].isOn = self.daoSelList[index]
    elseif self.showingType == PnlStarMapPlot.TYPE_PERSON then
        self.mySelList[index] = not self.mySelList[index]
        self.view.toggle[index].isOn = self.mySelList[index]
    end

    self:refresh()
    self:refreshScore()
end

function PnlStarMapPlot:onBtnChangeShowingType(type)
    if type == PnlStarMapPlot.TYPE_UNION then
        if PlayerData.myInfo.unionId == 0 then
            gg.uiManager:showTip("You haven't joined any DAOs")
            return
        end
        self.showingType = type
        self.view.txtTitle.text = Utils.getText("guild_DaoPlot_Title")
        if self.haveDaoData then
            self:refresh()
            self:refreshScore()
        else
            UnionData.C2S_Player_StarmapMatchUnionGrids()
        end
    elseif type == PnlStarMapPlot.TYPE_PERSON then
        self.showingType = type
        self.view.txtTitle.text = Utils.getText("league_DaoPlot_Title")
        if self.havePersonalData then
            self:refresh()
            self:refreshScore()
        else
            UnionData.C2S_Player_StarmapMatchPersonalGrids()
        end
    end
end

function PnlStarMapPlot:onBtnLevelSort()
    self.isSortUp = not self.isSortUp
    self:refresh()
end

function PnlStarMapPlot:onDestroy()
    local view = self.view
    -- self.plotScrollView:release()
end

function PnlStarMapPlot:onBtnClose()
    self:close()
end

-------------------------------------------------------
StarMapPlotItem = StarMapPlotItem or class("StarMapPlotItem", ggclass.UIBaseItem)

function StarMapPlotItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData

    local globalCfg = cfg["global"]
    self.starMakePointCD = globalCfg.StarMakePointCD.intValue
end

function StarMapPlotItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtLevel = self:Find("TxtLevel", UNITYENGINE_UI_TEXT)
    self.txtScore = self:Find("TxtScore", UNITYENGINE_UI_TEXT)
    self.txtReward = self:Find("TxtReward", UNITYENGINE_UI_TEXT)
    self.txtLessTime = self:Find("TxtLessTime", UNITYENGINE_UI_TEXT)
    self.txtLocation = self:Find("TxtLocation", UNITYENGINE_UI_TEXT)

    self.btnWaive = self:Find("BtnWaive")
    self:setOnClick(self.btnWaive, gg.bind(self.onBtnWaive, self))
    self:setOnClick(self.txtLocation.gameObject, gg.bind(self.onClickLocation, self))
end

StarMapPlotItem.TYPE_NAME = {
    [0] = "league_MyPlot_Empty",
    [1] = "league_MyPlot_Resource",
    [2] = "league_MyPlot_Resource",
    [3] = "league_MyPlot_Initial"
}

function StarMapPlotItem:setData(data)
    self.data = data
    self.plotCfg = gg.galaxyManager:getGalaxyCfg(data.gridCfgId)

    self.txtName.text = self.plotCfg.name
    local type = Utils.getText(StarMapPlotItem.TYPE_NAME[3])
    if self.plotCfg.type ~= 3 then
        type = Utils.getText(StarMapPlotItem.TYPE_NAME[self.plotCfg.subType])
    end
    self.txtLevel.text = type

    self.txtScore.text = self.plotCfg.point * 3600 / self.starMakePointCD

    local hourGet = self.plotCfg.perMakeCarboxyl / self.plotCfg.makeResTime * 60 * 60
    self.txtReward.text = Utils.getShowRes(hourGet) .. "/h"

    self.txtLocation.text = string.format("(%s.%s)", self.plotCfg.pos.x, self.plotCfg.pos.y)

    gg.timer:stopTimer(self.timer)
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local lessTime = data.leftTime - Utils.getServerSec()
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, lessTime)
        self.txtLessTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    end)
end

function StarMapPlotItem:onRelease()
    gg.timer:stopTimer(self.timer)
    ResMgr:ReleaseAsset(self.gameObject)
end

function StarMapPlotItem:onClickLocation()

    local args = {
        title = Utils.getText("universal_Ask_Title"),
        txt = string.format(Utils.getText("universal_JumpPlot_Ask_Txt"), self.plotCfg.name),
        btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
        txtYes = Utils.getText("universal_ConfirmButton")
    }

    args.callbackYes = function()
        if self.initData.args.jumpCloseView and self.initData.args.jumpCloseView:isShow() then
            self.initData.args.jumpCloseView:close()
        end
        self.initData:close()
        -- GalaxyData.C2S_Player_EnterStarmap(gg.galaxyManager:getAreaMembers(Vector2.New(self.plotCfg.pos.x, self.plotCfg.pos.y), true))
        gg.event:dispatchEvent("onJumpGalaxyGrid", self.plotCfg, true)
    end

    gg.uiManager:openWindow("PnlAlert", args)
end

function StarMapPlotItem:onBtnWaive()
    local txt = string.format(Utils.getText("league_GiveUp_AskText"), self.plotCfg.name)
    local callbackYes = function()
        GalaxyData.C2S_Player_GiveUpMyGrid(self.data.gridCfgId)
    end
    local args = {
        txt = txt,
        callbackYes = callbackYes
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

-------------------------------------------------------
return PnlStarMapPlot
