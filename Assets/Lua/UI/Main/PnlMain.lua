PnlMain = class("PnlMain", ggclass.UIBase)

PnlMain.infomationType = ggclass.UIBase.INFOMATION_NORMAL

function PnlMain:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.main
    self.events = {"onSoliderChange", "onUpdateBuildData", "onRedPointChange", "onEditModeChange", "onLanguageChange", "onLoginActivityInfoChange", "onActivityClose"}
end

function PnlMain:onAwake()
    self.view = ggclass.PnlMainView.new(self.transform)
    local view = self.view
    self.shopType = 1
    self.resTable = {}

    -- RedPointManager:setRedPoint(view.btnBuild, RedPointManager:getIsRed(RedPointPnlBuild.__name))

    self.redPointBtnMap = {
        [RedPointPnlBuild.__name] = view.btnBuild,
        [RedPointTask.__name] = view.btnTask,
        [RedPointChat.__name] = view.btnChat,
        [RedPointActivity.__name] = view.btnActivity,
        [RedPointNewPlayerLogin.__name] = view.btnNewPlayerDay7Act,
    }

    self.taskItemList = {}
    self.taskItemMap = {}
    self.scrollViewTask = UIScrollView.new(self.view.scrollViewTask, "BoxTask", self.taskItemList)
    self.scrollViewTask:setRenderHandler(gg.bind(self.onRenderTaskBox, self))
    self.muneButton = MuneButton.new(self.view.muneButton)
end

function PnlMain:onShow()
    self:bindEvent()
    gg.galaxyManager:resetPlayerId()
    gg.uiManager:openWindow("PnlPlayerInformation")
    self:creatBoat()
    self:refreshQuickTrain()
    -- self.spineList = {self.view.buildSpine, self.view.shopSpine, self.view.matchSpine, self.view.mapSpine,
    --                   self.view.pveSpine}
    -- self:StartSpineTimer()
    self:initRedPoint()
    self:onEditModeChange()

    self:onShowBoxTasks(AchievementData.chapterState ~= 1)

    self:refreshActOpen()
end

function PnlMain:onActivityClose(_, actType)
    if actType == constant.NEW_PLAYER_LOGIN then
        self.view.btnNewPlayerDay7Act:SetActiveEx(false)
    end
end

function PnlMain:refreshActOpen()
    -- print("refreshActOpenfffffffffffffffffffffff", ActivityUtil.checkGiftActivitiesOpen(constant.NEW_PLAYER_LOGIN) )

    self.view.btnNewPlayerDay7Act:SetActiveEx(ActivityUtil.checkGiftActivitiesOpen(constant.NEW_PLAYER_LOGIN))

    -- if ActivityData.loginActivityInfo and next(ActivityData.loginActivityInfo) then
    --     self.view.btnNewPlayerDay7Act:SetActiveEx(ActivityData.loginActivityInfo.endTime - Utils.getServerSec() > 0)
    -- else
    --     self.view.btnNewPlayerDay7Act:SetActiveEx(false)
    -- end
end

function PnlMain:onLoginActivityInfoChange()
    self:refreshActOpen()
end

function PnlMain:onHide()
    -- self:stopSpineTimer()
    -- self.spineList = {}
    self:releaseEvent()

    self:onShowBoxTasks(false)
    RedPointManager:releaseAllRedPoint()
end

function PnlMain:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnActivity):SetOnClick(function()
        self:onBtnActivity()
    end)
    CS.UIEventHandler.Get(view.btnRankingList):SetOnClick(function()
        self:onBtnRankingList()
    end)
    CS.UIEventHandler.Get(view.btnChat):SetOnClick(function()
        self:onBtnChat()
    end)
    CS.UIEventHandler.Get(view.btnBuild):SetOnClick(function()
        self:onBtnBuild()
    end)
    CS.UIEventHandler.Get(view.btnMap):SetOnClick(function()
        self:onBtnMap()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.bubbleBoatRes.gameObject):SetOnClick(function()
        self:onBubbleBoatRes()
    end)
    CS.UIEventHandler.Get(view.btnTaskSmall):SetOnClick(function()
        self:onBtnTaskSmall()
    end)
    CS.UIEventHandler.Get(view.btnHyList):SetOnClick(function()
        self:onBtnHyList()
    end)

    self:setOnClick(view.btnQuickTrain, gg.bind(self.onBtnQuickTrain, self))
    self:setOnClick(view.btnInstantTrain, gg.bind(self.onBtnInstantTrain, self))
    self:setOnClick(view.btnTask, gg.bind(self.onBtnTask, self))
    self:setOnClick(view.btnEdit, gg.bind(self.onBtnEdit, self))
    self:setOnClick(view.btnNewPlayerDay7Act, gg.bind(self.onBtnNewPlayerDay7Act, self))
    self:setOnClick(view.btnShop, gg.bind(self.onBtnShop, self))

    gg.event:addListener("onShowRes", self)
    gg.event:addListener("onSetCanNotCollect", self)
    gg.event:addListener("onSetCanNotCollectBoat", self)
    gg.event:addListener("onDestroyRes", self)
    gg.event:addListener("onHideRes", self)
    gg.event:addListener("onShowBuildMsg", self)
    gg.event:addListener("onRefreshBuildMsg", self)

    gg.event:addListener("onCollectBoatResSuccessful", self)
    gg.event:addListener("onShowBoatRes", self)
    gg.event:addListener("onRefreshBoatData", self)
    -- gg.event:addListener("onReturnSpineAni", self)
end

function PnlMain:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnActivity)
    CS.UIEventHandler.Clear(view.btnRankingList)
    CS.UIEventHandler.Clear(view.btnChat)
    CS.UIEventHandler.Clear(view.btnBuild)
    CS.UIEventHandler.Clear(view.btnMap)
    CS.UIEventHandler.Clear(view.bubbleBoatRes.gameObject)
    CS.UIEventHandler.Clear(view.btnTaskSmall)
    CS.UIEventHandler.Clear(view.btnHyList)
    gg.event:removeListener("onShowRes", self)
    gg.event:removeListener("onSetCanNotCollect", self)
    gg.event:removeListener("onSetCanNotCollectBoat", self)
    gg.event:removeListener("onDestroyRes", self)
    gg.event:removeListener("onHideRes", self)
    gg.event:removeListener("onShowBuildMsg", self)
    gg.event:removeListener("onRefreshBuildMsg", self)
    gg.event:removeListener("onCollectBoatResSuccessful", self)
    gg.event:removeListener("onShowBoatRes", self)
    gg.event:removeListener("onRefreshBoatData", self)
    -- gg.event:removeListener("onReturnSpineAni", self)

    if self.msgMoveFollow then
        self:onShowBuildMsg(nil, false)
    end
    self:destroyAllRes()
end

function PnlMain:onDestroy()
    local view = self.view
    if self.taskItemMap then
        for k, v in pairs(self.taskItemMap) do
            ResMgr:ReleaseAsset(v.go)
        end
        self.taskItemMap = {}
    end
    self:destroyBoatRes()
    self.scrollViewTask:release()
    self.muneButton:release()
    self.scrollViewTask = nil
    self.muneButton = nil
end

-- ""
function PnlMain:onBtnCollectRes(temp)
    -- gg.buildingManager:buildGetResMsg({buildId = temp, resCfgId = constant.RES_ICE, change = 50000})
    gg.buildingManager:buildCollectRes(temp)
end

function PnlMain:onBtnActivity()
    -- gg.uiManager:showTip("currently unavailable")
    -- gg.uiManager:openWindow("PnlCard")
    gg.buildingManager:cancelBuildOrMove()
    gg.uiManager:openWindow("PnlActivity")
end

function PnlMain:onBtnNewPlayerDay7Act()
    gg.buildingManager:cancelBuildOrMove()
    gg.uiManager:openWindow("PnlNewPlayerLoginAct")
end

function PnlMain:onBtnShop()
    gg.buildingManager:cancelBuildOrMove()
    gg.uiManager:openWindow("PnlShop")
end

function PnlMain:onBtnTask()
    gg.uiManager:openWindow("PnlTask")
    gg.buildingManager:cancelBuildOrMove()

    -- gg.uiManager:showTip("currently unavailable")
end

function PnlMain:onBtnEdit()
    gg.uiManager:openWindow("PnlEdit")
    gg.buildingManager:cancelBuildOrMove()

end

function PnlMain:onBtnRankingList()
    -- gg.uiManager:showTip("currently unavailable")
    gg.uiManager:openWindow("PnlRank")
    gg.buildingManager:cancelBuildOrMove()

end

function PnlMain:onBtnChat()
    gg.uiManager:openWindow("PnlChat")
    gg.buildingManager:cancelBuildOrMove()

    -- gg.uiManager:showTip("currently unavailable")
    -- gg.uiManager:showTipsNode("currently unavailable", "main", self.view.btnChat.transform.position)
end

function PnlMain:onBtnBuild()
    -- self.view.bulidShop:SetActive(true)
    gg.buildingManager:cancelBuildOrMove()
    gg.uiManager:openWindow("PnlBuild")
end

function PnlMain:onBtnMap()
    -- 5.23 ""

    -- if not gg.galaxyManager.onLookContenCfgId and UnionData.beginGridId == 0 then
    --     gg.uiManager:openWindow("PnlMapEntrance")
    --     return
    -- end

    gg.uiManager:openWindow("PnlLoading", nil, function()
        self:mapCallBack()
    end)
end

function PnlMain:onBtnHyList()
    gg.uiManager:openWindow("PnlHyList")
end

function PnlMain:mapCallBack()
    gg.warCameraCtrl:stopMoveTimer()

    gg.buildingManager:cancelBuildOrMove()
    LOAD_PERCENT = 5
    local timer = gg.timer:startTimer(0.01, function()
        LOAD_PERCENT = 10
        if gg.galaxyManager.onLookContenCfgId then
            local curCfg = gg.galaxyManager:getOnLookContenCfg()
            GalaxyData.C2S_Player_EnterStarmap(gg.galaxyManager:getAreaMembers(Vector2.New(curCfg.pos.x, curCfg.pos.y)))
        else
            if UnionData.beginGridId == 0 then
                -- 5.23 ""

                --gg.uiManager:openWindow("PnlMapEntrance")
                GalaxyData.C2S_Player_EnterStarmap(gg.galaxyManager:getAreaMembers(Vector2.New(0, 0)))
            else
                -- print("UnionData.beginGridId", UnionData.beginGridId)
                local gridId = UnionData.beginGridId
                local curCfg = gg.galaxyManager:getGalaxyCfg(gridId)
                GalaxyData.C2S_Player_EnterStarmap(gg.galaxyManager:getAreaMembers(Vector2.New(curCfg.pos.x,
                    curCfg.pos.y)))
            end
        end
    end)
end

function PnlMain:onBtnLoadBuilding(index)
    local buildingTable = self.buildingTable

    local canBuild = true
    if buildingTable[index].cfgId == constant.BUILD_LIBERATORSHIP then
        if not BuildUtil.checkIsCanLevelUp(buildingTable[index], true, true) then
            canBuild = false
        end
    end
    if canBuild then
        local buildCountResult = gg.buildingManager:checkBuildCountEnought(buildingTable[index].cfgId,
            buildingTable[index].quality)

        if not buildCountResult.isCanBuild then
            if buildCountResult.lockInfo then
                local lockBuildCfg = BuildUtil.getCurBuildCfg(buildCountResult.lockInfo.cfgId,
                    buildCountResult.lockInfo.level, buildCountResult.lockInfo.quality)
                gg.uiManager:showTip(string.format("%s level not enought", lockBuildCfg.name))
            else
                gg.uiManager:showTip("The building is fully built")
            end
            return
        end
        gg.buildingManager:loadBuilding(buildingTable[index], nil, nil, BuildingManager.OWNER_OWN)
        self.view.bulidShop:SetActive(false)
    end
    -- print(buildingTable[index].cfgId)
end

-- ""
function PnlMain:onShowBuildMsg(args, bool, buildingObj, name, level, id, buildCfg)
    local obj = self.view.msgBuilding.gameObject
    self.buildMsgId = id
    obj:SetActive(bool)

    if self.msgMoveFollow then
        self.msgMoveFollow:releaseEvent()
        self.msgMoveFollow = nil
    end
    if bool then
        -- obj.transform:GetComponent(UNITYENGINE_UI_TEXT).text = name
        local txtBuildName = obj.transform:Find("Layout/TxtBuildName"):GetComponent(UNITYENGINE_UI_TEXT_YPU_YU)
        txtBuildName:SetLanguageKey(buildCfg.languageNameID)
        -- txtBuildName.text = buildCfg.name

        local namePreferredWidth = txtBuildName.preferredWidth

        local txtBuildLevel = obj.transform:Find("Layout/TxtBuildLevel"):GetComponent(UNITYENGINE_UI_TEXT)
        if buildCfg and buildCfg.type == constant.BUILD_CLUTTER then
            txtBuildLevel.text = ""
        else
            txtBuildLevel.text = level
        end

        local levelPreferredWidth = txtBuildLevel.preferredWidth
        local interval = 7

        txtBuildName.transform.anchoredPosition = CS.UnityEngine.Vector2(levelPreferredWidth / 2,
            txtBuildName.transform.anchoredPosition.y)

        txtBuildLevel.transform.anchoredPosition = CS.UnityEngine.Vector2(
            txtBuildName.transform.anchoredPosition.x - namePreferredWidth / 2 - interval,
            txtBuildLevel.transform.anchoredPosition.y)

        local width = namePreferredWidth + levelPreferredWidth + levelPreferredWidth / 2 + interval + 5
        obj.transform:Find("Layout/bg").transform:SetRectSizeX(width)
        self.msgMoveFollow = ggclass.MoveFollow.new(obj, buildingObj, nil, true)
    end
end

function PnlMain:onRefreshBuildMsg(args, name, level, id)
    if self.buildMsgId then
        if self.buildMsgId == id then
            local obj = self.view.msgBuilding.gameObject

            obj.transform:Find("Layout/TxtBuildName"):GetComponent(UNITYENGINE_UI_TEXT).text = name
            obj.transform:Find("Layout/TxtBuildLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = level
        end
    end
end

-- ""
function PnlMain:onShowRes(args, buildingId, buildingObj, type, resId)
    local haveData = false
    if self.resTable[buildingId] then
        haveData = true
    end
    if not haveData then
        ResMgr:LoadGameObjectAsync("BubbleRes", function(obj)
            obj.transform:SetParent(self.view.listRes, false)
            obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).localScale = Vector3(1, 1, 1)
            obj.transform:Find("BgRed").gameObject:SetActive(false)
            obj.transform:Find("Bg").gameObject:SetActive(true)
            obj.transform:Find("Res").gameObject:SetActive(true)
            local moveFollow = ggclass.MoveFollow.new(obj, buildingObj, nil, false, true)
            local res = {
                obj = obj,
                moveFollow = moveFollow,
                buildingId = buildingId,
                resId = resId
            }
            self.resTable[buildingId] = res
            CS.UIEventHandler.Get(self.resTable[buildingId].obj):SetOnClick(function()
                self:onBtnCollectRes(buildingId)
            end)
            local max = obj.transform:Find("Res").childCount
            for i = 1, max do
                local iconObj = obj.transform:Find("Res"):GetChild(i - 1)
                iconObj.gameObject:SetActive(false)
            end
            obj.transform:Find("Res"):GetChild(type - 1).gameObject:SetActive(true)
            return true
        end, true)
    end
end

function PnlMain:onSetCanNotCollect(args, buildingId, bool)
    -- ""(""Max)
    if self.resTable[buildingId] then
        self.resTable[buildingId].obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).pivot = Vector2.New(0.5, 0.5)
        self.resTable[buildingId].obj.transform:Find("BgRed").gameObject:SetActive(bool)
        self.resTable[buildingId].obj.transform:Find("Bg").gameObject:SetActive(not bool)
        self.resTable[buildingId].obj.transform:Find("Res").gameObject:SetActive(not bool)
        self.resTable[buildingId].moveFollow.overScreen = true
    end
end

function PnlMain:onDestroyRes(args, buildingId)
    if self.resTable[buildingId] then
        self.resTable[buildingId].moveFollow:releaseEvent()
        CS.UIEventHandler.Clear(self.resTable[buildingId].obj)
        ResMgr:ReleaseAsset(self.resTable[buildingId].obj)
        self.resTable[buildingId] = nil
    end
end

function PnlMain:onHideRes(args, buildingId, bool)
    if not self.resTable[buildingId] then
        return
    end
    self.resTable[buildingId].moveFollow:showRes(bool)
    if bool then
        self.resTable[buildingId].moveFollow:onMoveFollow()
    end
end

function PnlMain:destroyAllRes()
    for k, v in pairs(self.resTable) do
        v.moveFollow:releaseEvent()
        CS.UIEventHandler.Clear(v.obj)
        ResMgr:ReleaseAsset(v.obj)
    end
    self.resTable = {}
end

-- ""
function PnlMain:onRefreshBoatData()
    -- self:creatBoat()
    -- self:setBoatRes(ResPlanetData.resBoatDatas)
end

function PnlMain:creatBoat()
    -- if not self.resBoat then
    --     self.resBoat = ggclass.ResBoat.new(ResPlanetData.resBoatDatas)
    --     self:setBoatRes()
    -- end

    -- if not self.resBoat then
    --     local max = 0
    --     for k, v in pairs(ResPlanetData.resBoatDatas) do
    --         max = max + 1
    --     end
    --     --if max > 0 then
    --         self.resBoat = nil
    --         self.resBoat = ggclass.ResBoat.new(ResPlanetData.resBoatDatas)
    --         self:setBoatRes(ResPlanetData.resBoatDatas)
    --     --end
    -- else
    --     self.resBoat:setBoatData(ResPlanetData.resBoatDatas)
    --     self:setBoatRes(ResPlanetData.resBoatDatas)
    -- end
end

PnlMain.RES_IOCN_NAME = {
    [200] = "IconGun",
    [102] = "IconStartCoin",
    [103] = "IconIce",
    [104] = "IconCarboxyl",
    [105] = "IconTitanium",
    [106] = "IconGas"
}

function PnlMain:setBoatRes(datas)
    if not self.bubbleBoatResTargetObj or not self.resBoat then
        return
    end
    local view = self.view
    local resCfgIds = {}
    for k, v in pairs(self.resBoat.boatRes) do
        table.insert(resCfgIds, v.key)
    end

    for k, v in pairs(PnlMain.RES_IOCN_NAME) do
        view.bubbleBoatRes:Find(v).gameObject:SetActive(false)
    end

    local max = #resCfgIds
    local interval = 55
    local sizeWidth = max * interval + 14
    local bgWidth = 25 * max
    view.bubbleBoatRes:Find("Bg").gameObject:SetActive(true)
    view.bubbleBoatRes:Find("BgRed").gameObject:SetActive(false)
    view.bubbleBoatRes:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(sizeWidth, 84)
    view.bubbleBoatRes:Find("Bg/Bg1"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bgWidth, 84)
    view.bubbleBoatRes:Find("Bg/Bg2"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bgWidth, 84)
    view.bubbleBoatRes:Find("BgRed/Bg1"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bgWidth, 84)
    view.bubbleBoatRes:Find("BgRed/Bg2"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bgWidth, 84)
    local startPsoX = 34.5

    if max > 0 then
        view.bubbleBoatRes.gameObject:SetActive(true)
        if not self.boatResMoveFollow and self.bubbleBoatResTargetObj then
            self.boatResMoveFollow = ggclass.MoveFollow.new(self.view.bubbleBoatRes.gameObject,
                self.bubbleBoatResTargetObj, nil, false, true)
        end
    else
        self:releaseBoatRes()
        view.bubbleBoatRes.gameObject:SetActive(false)
    end

    for k = 1, max do
        local posX = startPsoX + interval * (k - 1)
        local name = PnlMain.RES_IOCN_NAME[resCfgIds[k]]
        if not name then
            return
        end
        view.bubbleBoatRes:Find(name).gameObject:SetActive(true)
        view.bubbleBoatRes:Find(name):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition =
            Vector2.New(posX, 48)
    end
end

function PnlMain:onShowBoatRes(args, targetObj)
    -- self.view.bubbleBoatRes.gameObject:SetActive(true)
    self.bubbleBoatResTargetObj = targetObj
    self:setBoatRes()
end

function PnlMain:onBubbleBoatRes()
    gg.event:dispatchEvent("onCollectRes")
end

function PnlMain:onBtnQuickTrain()
    gg.uiManager:openWindow("PnlSoldierQuickTrain")
    gg.buildingManager:cancelBuildOrMove()

end

function PnlMain:onBtnInstantTrain()
    gg.uiManager:openWindow("PnlSoldierInstantTrain")
    gg.buildingManager:cancelBuildOrMove()

end

function PnlMain:onCollectBoatResSuccessful()
    -- self:releaseBoatRes()
    -- self.resBoat = nil
    -- self.view.bubbleBoatRes.gameObject:SetActive(false)
end

function PnlMain:releaseBoatRes()
    if self.boatResMoveFollow then
        self.boatResMoveFollow:releaseEvent()
        self.boatResMoveFollow = nil
    end
end

function PnlMain:destroyBoatRes()
    -- gg.event:dispatchEvent("onDestroyResBoat")

    if self.resBoat then
        self.resBoat:onDestroyResBoat()
        self.resBoat = nil
    end

    self:releaseBoatRes()
end

function PnlMain:onSetCanNotCollectBoat()
    -- ""
    if self.boatResMoveFollow then
        self.boatResMoveFollow.overScreen = true
        self.view.bubbleBoatRes:Find("Bg").gameObject:SetActive(false)
        self.view.bubbleBoatRes:Find("BgRed").gameObject:SetActive(true)
    end
end

function PnlMain:onSoliderChange()
    self:refreshQuickTrain()
end

function PnlMain:onUpdateBuildData()
    self:refreshQuickTrain()
end

function PnlMain:initRedPoint()
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function PnlMain:onRedPointChange(_, name, isRed)
    if self.redPointBtnMap[name] then
        RedPointManager:setRedPoint(self.redPointBtnMap[name], isRed)
    end
end

function PnlMain:refreshQuickTrain()
    local isCanTrain, isTraining = SoliderUtil.checkTrainStage()
    -- self.view.btnQuickTrain.transform:SetActiveEx(isCanTrain or isTraining)
    self.view.btnQuickTrain.transform:SetActiveEx(isCanTrain)
    self.view.btnInstantTrain.transform:SetActiveEx(isTraining)
end

-- function PnlMain:stopSpineTimer()
--     if self.spineTimer then
--         gg.timer:stopTimer(self.spineTimer)
--         self.spineTimer = nil
--     end
-- end

-- PnlMain.SpineRestCount = {3, 2, 1, 1, 1}

-- function PnlMain:StartSpineTimer()
--     self:stopSpineTimer()
--     local spinePool = {1, 2, 3, 4, 5}
--     self.spineTimer = gg.timer:startLoopTimer(0, 10, -1, function()
--         local r = math.random(1, #spinePool)
--         local p = spinePool[r]
--         local spine = self.spineList[p]
--         table.remove(spinePool, r)
--         if #spinePool == 0 then
--             spinePool = {1, 2, 3, 4, 5}
--         end
--         if spine then
--             local aniNum = math.random(1, PnlMain.SpineRestCount[p])
--             local aniName = "rest" .. aniNum
--             if spine.AnimationState:ToString() == "idle" then
--                 local uiSpineAni = ggclass.UISpineAni.new(spine, aniName)
--             end
--         end
--     end)
-- end

-- function PnlMain:onReturnSpineAni(args, spineNum)
--     local spine = self.spineList[spineNum]
--     local aniName = "back"
--     local uiSpineAni = ggclass.UISpineAni.new(spine, aniName)
-- end

function PnlMain:onEditModeChange()
    self.view.btnEdit:SetActiveEx(EditData.isEditMode)
end

-- guide
-- ""ui
-- override
function PnlMain:getGuideRectTransform(guideCfg)
    if guideCfg.otherArgs and guideCfg.otherArgs[1] == "finishTask" then
        for index, value in ipairs(self.showTaskDatas) do
            if value.stage == 1 then
                for k, v in pairs(self.taskItemMap) do
                    if v.data == value then
                        self.guidingTask = v
                        return k
                    end
                end
            end
        end
        return
    end

    if guideCfg.gameObjectName == "btnQuickTrain" then
        if self.view.btnQuickTrain.gameObject.activeSelf then
            return self.view.btnQuickTrain
        end
        return
    elseif guideCfg.gameObjectName == "resBubble" then
        local resId = guideCfg.otherArgs[1]
        for key, value in pairs(self.resTable) do
            if value.resId == resId then
                self.guidingBubble = value
                return value.obj
            end
        end
        local building = gg.buildingManager:getOwnerBuildingByCfgId(constant.RES_2_CFG_KEY[resId].makeResBuild)
        if building then
            BuildData.C2S_Player_ReapGuideRes(building.buildData.id, resId)
        end
        return
    elseif guideCfg.gameObjectName == "btnMenu" then
        return self.muneButton.btnMenu

    elseif guideCfg.gameObjectName == "btnPVE" then
        return self.muneButton.btnPVE

        
    end
    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlMain:triggerGuideClick(guideCfg)

    if guideCfg.otherArgs and guideCfg.otherArgs[1] == "finishTask" then
        self.guidingTask.clickCallBack()
        return
    end

    if guideCfg.gameObjectName == "resBubble" then
        if self.guidingBubble then
            self:onBtnCollectRes(self.guidingBubble.buildingId)
        end
        return
    elseif guideCfg.gameObjectName == "btnMenu" then
        self.muneButton:onBtnMenu()
        return

    elseif guideCfg.gameObjectName == "btnPVE" then
        self.muneButton:onBtnPVE()
        return

    end
    return ggclass.UIBase.triggerGuideClick(self, guideCfg)
end

function PnlMain:onBtnTaskSmall()
    local bool = self.view.boxTasks.activeSelf
    self:onShowBoxTasks(not bool)
end

function PnlMain:onShowBoxTasks(isShow)
    self.view.boxTasks:SetActiveEx(isShow)

    self.isShowingTask = isShow
    if isShow then
        self.view.btnTaskSmall.transform.localPosition = Vector3(180, -36.2, 0)
        self.view.btnTaskSmall.transform.rotation = Quaternion.Euler(0, 0, 0)
        self:loadBoxTask()
        gg.event:addListener("onLoadBoxTask", self)
    else
        self.view.btnTaskSmall.transform.localPosition = Vector3(99, -36.2, 0)
        self.view.btnTaskSmall.transform.rotation = Quaternion.Euler(0, 0, 180)
        -- self:releaseBoxTask()
        gg.event:removeListener("onLoadBoxTask", self)
    end
end

function PnlMain:onLanguageChange()
    if self.isShowingTask then
        self:onShowBoxTasks(true)
    end
end

function PnlMain:onDrawTask(index, stage, jumpOpenView)
    gg.buildingManager:cancelBuildOrMove()
    if stage == 1 then
        if index then
            AchievementData.C2S_Player_DrawTask(index)
            local subTask = cfg.subTask[index]
            local rewardList = TaskUtil.parseSubTaskReward(subTask.cfgId)
            gg.uiManager:openWindow("PnlTaskReward", {
                reward = rewardList
            })
        else
            AchievementData.C2S_Player_DrawChapterTask()
            local chapterCfg = cfg.chapterTask[AchievementData.taskChapterId]
            local rewardList = TaskUtil.parseReawrd(chapterCfg)
            gg.uiManager:openWindow("PnlTaskReward", {
                reward = rewardList
            })
        end
    elseif jumpOpenView then
        gg.uiManager:openWindow(jumpOpenView)
    end
end

function PnlMain:onLoadBoxTask()
    self:loadBoxTask()
end

function PnlMain:loadBoxTask()
    -- self:releaseBoxTask()
    self.boxTaskList = {}
    local showTaskDatas = {}

    local taskChapterId = AchievementData.taskChapterId -- ""id

    local completeTasksMap = AchievementData.completeTasksMap -- ""

    local taskChapterCfg = cfg.getCfg("chapterTask", taskChapterId)

    local totalTaskNum = 0
    local completeTaskNum = 0
    local completeMainTaskCfgid = {}
    local noCompleteMainTaskCfgid = {}
    for k, v in pairs(taskChapterCfg.mainTaskList) do
        totalTaskNum = totalTaskNum + 1
        if completeTasksMap[v] then
            if completeTasksMap[v].stage == 1 then
                table.insert(completeMainTaskCfgid, v)
            elseif completeTasksMap[v].stage == 2 then
                completeTaskNum = completeTaskNum + 1
            end
        else
            table.insert(noCompleteMainTaskCfgid, v)
        end
    end

    for k, v in ipairs(completeMainTaskCfgid) do
        local curCfg = cfg.getCfg("subTask", v)
        if curCfg.available == 1 then
            local data = {
                desc = Utils.getText(curCfg.desc),
                stage = 1,
                cfgId = v,
                curCfg = curCfg
            }

            table.insert(showTaskDatas, data)
        end
    end

    for i, cfgId in ipairs(noCompleteMainTaskCfgid) do
        local curCfg = cfg.getCfg("subTask", cfgId)
        if curCfg.available == 1 then
            local curNum = 0
            if AchievementData.taskTargetsMap[curCfg.targetType] then
                for k, value in pairs(AchievementData.taskTargetsMap[curCfg.targetType].targetConds) do
                    if value.condId == cfgId then
                        curNum = value.curVal
                        break
                    end
                end
                local totalNum = curCfg.targetArgs[1]
                local data = {
                    desc = string.format("(%s/%s) %s", curNum, totalNum, Utils.getText(curCfg.desc)),
                    stage = 0,
                    cfgId = cfgId,
                    curCfg = curCfg
                }

                table.insert(showTaskDatas, data)
            end
        end
    end

    table.sort(showTaskDatas, function(a, b)
        if a.stage == b.stage and a.curCfg and b.curCfg then
            return TaskUtil.getSortWeight(a.curCfg) > TaskUtil.getSortWeight(b.curCfg)
        end

        return a.stage > b.stage
    end)

    if AchievementData.chapterState ~= 1 then
        local chapterDesc = string.format("(%s/%s) %s", completeTaskNum, totalTaskNum,
            Utils.getText(taskChapterCfg.desc))
        local chapterStage = 0
        if completeTaskNum >= totalTaskNum then
            chapterDesc = Utils.getText(taskChapterCfg.desc)
            chapterStage = 1
        end

        local taskChapterData = {
            name = Utils.getText(taskChapterCfg.name),
            desc = chapterDesc,
            stage = chapterStage
        }
        table.insert(showTaskDatas, 1, taskChapterData)
    end

    self.showTaskDatas = showTaskDatas
    self.scrollViewTask:setItemCount(#self.showTaskDatas)
    self.view.txtTaskFinish.transform:SetActiveEx(#self.showTaskDatas <= 0)
end

function PnlMain:onRenderTaskBox(go, index)
    local data = self.showTaskDatas[index]
    self.taskItemMap[go] = {
        data = data,
        go = go
    }

    if data.name then
        go.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(300, 121)
        go.transform:Find("TxtTaskName").gameObject:SetActiveEx(true)
        go.transform:Find("TxtTaskName"):GetComponent(UNITYENGINE_UI_TEXT).text = data.name
        go.transform:Find("TxtTask"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(265, 80)
    else
        go.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(300, 78)

        go.transform:Find("TxtTaskName").gameObject:SetActiveEx(false)
        go.transform:Find("TxtTask"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(200, 72)
    end
    go.transform:Find("TxtTask"):GetComponent(UNITYENGINE_UI_TEXT).text = data.desc

    if data.stage == 1 then
        go.transform:Find("BtnTreasure").gameObject:SetActiveEx(true)
    else
        go.transform:Find("BtnTreasure").gameObject:SetActiveEx(false)
    end
    local jumpOpenView = "PnlTask"

    if data.curCfg then
        local taskTypeMessage = constant.TASK_TYPE_MESSAGE[data.curCfg.targetType]

        if taskTypeMessage then
            if taskTypeMessage.jumpView then
                jumpOpenView = taskTypeMessage.jumpView

            elseif taskTypeMessage.type == "BUILD_BUILDING" then
                if data.curCfg.targetArgs[3] == 1 then
                    jumpOpenView = "PnlBuild"
                end
            end
        end
    end
    if data.stage == 1 or jumpOpenView then
        self.taskItemMap[go].clickCallBack = gg.bind(self.onDrawTask, self, data.cfgId, data.stage, jumpOpenView)

        CS.UIEventHandler.Get(go):SetOnClick(self.taskItemMap[go].clickCallBack)
        CS.UIEventHandler.Get(go.transform:Find("BtnTreasure").gameObject):SetOnClick(self.taskItemMap[go].clickCallBack)

        -- CS.UIEventHandler.Get(go):SetOnClick(function()
        --     self:onDrawTask(data.cfgId, data.stage, jumpOpenView)
        -- end)
        -- CS.UIEventHandler.Get(go.transform:Find("BtnTreasure").gameObject):SetOnClick(function()
        --     self:onDrawTask(data.cfgId, data.stage, jumpOpenView)
        -- end)
    end
end

-- function PnlMain:releaseBoxTask()
--     if self.boxTaskList then
--         for k, go in pairs(self.boxTaskList) do
--             CS.UIEventHandler.Clear(go)
--             CS.UIEventHandler.Clear(go.transform:Find("BtnTreasure").gameObject)
--             ResMgr:ReleaseAsset(go)
--         end
--         self.boxTaskList = nil
--     end
-- end

return PnlMain
