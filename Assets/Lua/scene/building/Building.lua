local Building = class("Building")

Building.BUILD_2_VIEW = {
    [constant.BUILD_FIX] = {
        viewName = "PnlFix",
        btnToolIcon = "Main_Atlas[Repair_icon]",
        cfgId = constant.BUILD_FIX,
        eventList = {"onItemRepareChange"}
    },
    [constant.BUILD_HERO_HUT] = {
        viewName = "PnlHeroHut",
        btnToolIcon = "Main_Atlas[Hero_icon]",
        cfgId = constant.BUILD_HERO_HUT,
        eventList = {"onHeroChange"}
    },
    [constant.BUILD_HYPERSPACERESEARCH] = {
        viewName = "PnlInstitute",
        btnToolIcon = "Main_Atlas[Research_icon]",
        viewName2 = "PnlNFTTower",
        btnToolIcon2 = "Main_Atlas[Tower_icon_A]",
        cfgId = constant.BUILD_HYPERSPACERESEARCH,
        eventList = {"onSoliderChange", "onMineChange"}
    },
    [constant.BUILD_LIBERATORSHIP] = {
        viewName = "PnlSoldier",
        btnToolIcon = "Main_Atlas[Supplementary force_icon]",
        cfgId = constant.BUILD_LIBERATORSHIP,
        eventList = {}
    },
    [constant.BUILD_BLACKMARKET] = {
        viewName = "PnlRoutes",
        btnToolIcon = "Main_Atlas[Trade_icon]",
        cfgId = constant.BUILD_BLACKMARKET,
        eventList = {}
    },

    [constant.BUILD_ICEMININGTOWER] = {
        viewName = nil,
        cfgId = constant.BUILD_ICEMININGTOWER,
        eventList = {"onRefreshResTxt"},
        makeRes = constant.RES_ICE,
        workAniName = "working"
    },
    [constant.BUILD_TITANIUMMININGTOWER] = {
        viewName = nil,
        cfgId = constant.BUILD_TITANIUMMININGTOWER,
        eventList = {"onRefreshResTxt"},
        makeRes = constant.RES_TITANIUM,
        workAniName = "working"
    },
    [constant.BUILD_GASMININGTOWER] = {
        viewName = nil,
        cfgId = constant.BUILD_GASMININGTOWER,
        eventList = {"onRefreshResTxt"},
        makeRes = constant.RES_GAS,
        workAniName = "working"
    },
    [constant.BUILD_CARBOXYLMININGTOWER] = {
        viewName = nil,
        cfgId = constant.BUILD_CARBOXYLMININGTOWER,
        eventList = {"onRefreshResTxt"},
        makeRes = constant.RES_CARBOXYL
    },
    [constant.BUILD_MININGMACHINE] = {
        viewName = nil,
        cfgId = constant.BUILD_MININGMACHINE,
        eventList = {"onRefreshResTxt"},
        makeRes = constant.RES_STARCOIN,
        workAniName = "working"
    },
    [constant.BUILD_DRAFT] = {
        viewName = "PnlDraft",
        btnToolIcon = "Main_Atlas[Repair_icon]",
        cfgId = constant.BUILD_DRAFT,
        eventList = {"onSetPnlDraftView"}
    }
}

function Building:ctor(buildCfg, pos, buildData, itemId, owner, isInstance)
    self.lastPos = Vector3(0, 0, 0)
    self.buildCfg = buildCfg
    self.buildData = buildData
    self.onSpace = true
    self.itemId = itemId
    self.eventList = {}
    self.lessTick = 999
    self.speedUpCallback = nil
    self.owner = owner
    self.timeBarLessTick = 0
    self.isMoveFirst = false
    self.surfaceData = nil
    self.isMoved = false
    self.drone = nil

    if buildData then
        self.view = ggclass.BuildingView.new(self, self.buildCfg.model, self.buildCfg.length, self.buildCfg.width,
            Vector3(pos.x, pos.y, pos.z), true, self.buildCfg, owner, isInstance)
        gg.buildingManager:setGridTable(pos, self.buildCfg.length, self.buildCfg.width, self.buildData.id, self.owner)
    else
        self.view = ggclass.BuildingView.new(self, self.buildCfg.model, self.buildCfg.length, self.buildCfg.width,
            Vector3(pos.x, pos.y, pos.z), false, self.buildCfg, owner, isInstance)
    end

end

Building.BUILDOFPRODUCTION = {constant.BUILD_ICEMININGTOWER, constant.BUILD_TITANIUMMININGTOWER,
                              constant.BUILD_GASMININGTOWER, constant.BUILD_CARBOXYLMININGTOWER,
                              constant.BUILD_MININGMACHINE}

function Building:onShow(view)
    self.view = view
    self:bindEvent()
    -- if self.buildCfg.cfgId == constant.BUILD_LIBERATORSHIP then
    --     self.buildingSolider = nil
    --     self.buildingSolider = ggclass.BuildingSolider.new()
    -- end

    if self.buildData then
        self:onUpdateBuildData(self.buildData)

        if self.buildData.cfgId == constant.BUILD_BASE then
            if self.owner == BuildingManager.OWNER_OWN then
                gg.buildingManager:initAllBuilding()
            elseif self.owner == BuildingManager.OWNER_OTHER then
                gg.buildingManager:initOtherBuilding()
            end
        end
        if BuildingManager.IS_MAKE_SURFACE then
            self:makeSurface()
        else
            gg.buildingManager:addBuildCound(self.owner)
        end

    end

    self:refreshAlert()
    self:excuteViewEvent()
end

function Building:excuteViewEvent()
    if Building.BUILD_2_VIEW[self.buildCfg.cfgId] and self.buildData then
        local eventList = Building.BUILD_2_VIEW[self.buildCfg.cfgId].eventList
        if next(eventList) then
            self.eventList = eventList
            for key, value in pairs(eventList) do
                self[value](self)
                gg.event:addListener(value, self)
            end
        end
    end
end

function Building:bindEvent()
    local view = self.view

    view.buildingTimeBarBox:setBtnSpeedUpCallBack(gg.bind(self.onBtnBuildSpeedUp, self))

    gg.event:addListener("onResetSurface", self)
    gg.event:addListener("onShowPlatform", self)
    gg.event:addListener("onLanguageChange", self)
end

function Building:onHeroChange()
    if not HeroData.ChooseingHero then
        return
    end
    if self.buildCfg.cfgId == constant.BUILD_HERO_HUT then
        local heroCfg = HeroUtil.getChooseHeroCfg()
        local data = HeroData.ChooseingHero

        if data.lessTick > 0 then
            local icon = gg.getSpriteAtlasName("Hero_A_Atlas", heroCfg.icon .. "_A")

            self:setTimeBar(data.lessTickEnd, data.lessTick, icon, constant.BUILD_TIME_PROGRESS_TYPE.HERO)

            self.speedUpCallback = function()
                HeroData.C2S_Player_HeroLevelUp(data.id, 1)
            end

        elseif data.skillUpLessTick > 0 then
            local skillCfg = HeroUtil.getSkillMap()[heroCfg["skill" .. data.skillUp][1]][data["skillLevel" ..
                                 data.skillUp]]
            local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")
            self:setTimeBar(data.skillUpLessTickEnd, data.skillUpLessTick, icon,
                constant.BUILD_TIME_PROGRESS_TYPE.HERO_SKILL)

            self.speedUpCallback = function()

            end
        else
            self:setTimeBar(-1, nil, nil, constant.BUILD_TIME_PROGRESS_TYPE.HERO)
            self:setTimeBar(-1, nil, nil, constant.BUILD_TIME_PROGRESS_TYPE.HERO_SKILL)
        end
        self.view:spineAnimPlay()
    end
end

function Building:onItemRepareChange()
    if self.buildData.cfgId == constant.BUILD_FIX then
        local item = nil
        for key, value in pairs(ItemData.repairData) do
            if not item then
                item = value
            elseif value.endTime < item.endTime then
                item = value
            end
        end

        if item then
            local totalTime = (item.life - item.curLife) * cfg.global.RepairTimePerLife.intValue

            local cfgId = item.cfgId
            -- ""cfgId"" 1："" 2："" 3：""
            local head = string.sub(tostring(cfgId), 1, 1)
            local cfgData = {}
            local atlas = ""
            local suffix = "_A"
            if head == '1' then
                atlas = "Warship_A_Atlas"
                cfgData = cfg.getCfg("warShip", cfgId)
            elseif head == '2' then
                atlas = "Hero_A_Atlas"
                cfgData = cfg.getCfg("hero", cfgId)
            elseif head == '3' then
                atlas = "Icon_E_Atlas"
                suffix = "_E"
                cfgData = cfg.getCfg("build", cfgId)
            end

            local icon = gg.getSpriteAtlasName(atlas, cfgData.icon .. suffix)

            self:setTimeBar(item.endTime, totalTime, icon, constant.BUILD_TIME_PROGRESS_TYPE.FIX)
            self.speedUpCallback = function()

            end
        else
            self:setTimeBar(-1, nil, nil, constant.BUILD_TIME_PROGRESS_TYPE.FIX)
            -- elseif self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.FIX then
            --     self:setTimeBar(0, 0, nil, nil)
        end
        self.view:spineAnimPlay()
    end
end

function Building:onSoliderChange()
    local isSet = false
    if self.buildData.cfgId == constant.BUILD_HYPERSPACERESEARCH then
        for key, value in pairs(BuildData.soliderLevelData) do
            if value.lessTickEnd > os.time() then
                isSet = true
                local curCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][value.level]
                local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", curCfg.icon .. "_A")
                self:setTimeBar(value.lessTickEnd, curCfg.levelUpNeedTick, icon,
                    constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_SOLIDER)
                self.speedUpCallback = function()
                    if value.level > 0 then
                        BuildData.C2S_Player_SoliderLevelUp(value.cfgId, 1)
                    else
                        BuildData.C2S_Player_SoliderQualityUpgrade(value.cfgId, 1)
                    end
                end
                break
            end
        end

        if not isSet then
            self:setTimeBar(-1, nil, nil, constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_SOLIDER)
            self:refreshLevelUpTimeBar()
            -- self:onUpdateBuildData(self.buildData)
        end
        self.view:spineAnimPlay()
    end
end

function Building:onRefreshResTxt(args, resCfgId, count)
    if not self.buildData or not self.view.buildingObj then
        return
    end

    -- ""
    if Building.BUILD_2_VIEW[self.buildData.cfgId] and Building.BUILD_2_VIEW[self.buildData.cfgId].makeRes then
        self.view:spineAnimPlay()
    end
end

function Building:onSetPnlDraftView()
    if not self.buildData or not self.view.buildingObj then
        return
    end

    if self.buildData.cfgId == constant.BUILD_DRAFT then
        self:refreshAlert()
    end
end

function Building:getBulidingAnim()
    local anim = "idle"
    if not self.buildData then
        return anim
    end

    -- ""
    local lessTickEnd = self.buildData.lessTickEnd or 0
    if (lessTickEnd - os.time()) > 0 then
        anim = "idle"
    elseif Building.BUILD_2_VIEW[self.buildData.cfgId] and Building.BUILD_2_VIEW[self.buildData.cfgId].makeRes then
        local makeRes = Building.BUILD_2_VIEW[self.buildData.cfgId].makeRes
        if gg.buildingManager.resMax[makeRes] >= ResData.getRes(makeRes) then

            local isWorking = false
            if makeRes == constant.RES_CARBOXYL then
                local vipCfg = cfg.vip[VipData.vipData.vipLevel]
                if vipCfg.carboxylRatio > 0 then
                    isWorking = true
                end
            else
                isWorking = true
            end

            if isWorking and Building.BUILD_2_VIEW[self.buildData.cfgId].workAniName then
                anim = Building.BUILD_2_VIEW[self.buildData.cfgId].workAniName
            end
        end
    elseif self.buildData.cfgId == constant.BUILD_HERO_HUT then
        if self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.HERO or self.runningTimeBarType ==
            constant.BUILD_TIME_PROGRESS_TYPE.HERO_SKILL then
            anim = "working"
        end
    elseif self.buildData.cfgId == constant.BUILD_HYPERSPACERESEARCH then
        if self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_SOLIDER or self.runningTimeBarType ==
            constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_MINE then
            anim = "working"
        end
    elseif self.buildData.cfgId == constant.BUILD_FIX then
        if self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.FIX then
            anim = "using"
        end
    elseif self.buildData.cfgId == constant.BUILD_LIBERATORSHIP then
        if self.runningTimeBarType == constant.BUILD_TIME_PROGRESS_TYPE.SOLDIER_TRAIN then
            if self.buildData.cfgId == constant.BUILD_MININGMACHINE then
                anim = "working"
            elseif self.buildData.cfgId == constant.BUILD_TITANIUMMININGTOWER then
                anim = "work"
            else
                -- anim = "moveTTTT"
            end
        end
    end
    return anim
end

function Building:onMineChange()
    local isSet = false
    if self.buildData.cfgId == constant.BUILD_HYPERSPACERESEARCH then
        for key, value in pairs(BuildData.mineLevelData) do
            if value.lessTickEnd > os.time() then
                isSet = true
                local curCfg = MineUtil.getMineCfgMap()[value.cfgId][value.level]
                self:setTimeBar(value.lessTickEnd, curCfg.levelUpNeedTick, "Mayfliesray_icon",
                    constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_MINE)
                self.speedUpCallback = function()
                    BuildData.C2S_Player_MineLevelUp(value.cfgId, 1)
                end
                break
            end
        end

        if not isSet then
            self:setTimeBar(-1, nil, nil, constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_MINE)
        end
        self.view:spineAnimPlay()
    end
end

function Building:destroy()
    -- print("aaaaaadestroy")
    self.drone = nil
    gg.buildingManager:releaseBuilding(false, true)
    if self.buildData then
        gg.buildingManager:setGridTable(self.view.pos, self.view.length, self.view.width, 0, self.owner)
    end
    self:releaseEvent()
    if self.surfaceData then
        for k, v in pairs(self.surfaceData) do
            ResMgr:ReleaseAsset(v.obj)
        end
    end
    self.surfaceData = nil
    self.view:destroy()
    self.speedUpCallback = nil
    self.view = nil
    self.buildData = nil
    self.buildCfg = nil
    -- if self.buildingSolider then
    --     self.buildingSolider:ReleaseSolider()
    --     self.buildingSolider = nil
    -- end
end

function Building:releaseEvent()
    local view = self.view

    for i, eventName in ipairs(self.eventList) do
        gg.event:removeListener(eventName, self)
    end

    gg.event:removeListener("onResetSurface", self)
    gg.event:removeListener("onShowPlatform", self)
    gg.event:removeListener("onLanguageChange", self)
end

-- ""
function Building:onMoveBuilding(pos)
    if self.isMoveFirst then
        self:readyMove()
        self.isMoveFirst = false
    end

    self:showBuildUi(false, true)
    self.view:onMoveBuilding(pos)
    if self.buildData then
        gg.event:dispatchEvent("onDroneSetActive", false, self.buildData.id, self.buildCfg.cfgId)
    end
end

function Building:onReleaseFinger()
    if self.buildData then
        gg.event:dispatchEvent("onDroneSetActive", true, self.buildData.id, self.buildCfg.cfgId)
    end
    self.view:onReleaseFinger()
end

-- ""
function Building:onMoveLiberaborShip(pos)
    self.view:onMoveLiberaborShip(pos)
    self:showBuildUi(false, true)
end

function Building:setLiberaborShipTableKey(key)
    if key then
        self.liberaborShipTableKey = key
    else
        self.liberaborShipTableKey = self.temporaryKey
    end
end

-- ""
function Building:backLastPos(isRefreshSurface)
    self.view:setPos(self.lastPos, isRefreshSurface)
    self.onSpace = true
end

-- ""
function Building:contrastPos(pos)
    if not pos or not self.buildCfg or not self.buildData then
        return
    end
    -- if self.buildCfg.type == constant.BUILD_CLUTTER and self.buildData.level > gg.areaManager.unlockArea then
    --     return false
    -- end
    local cfgId = self.buildCfg.cfgId
    local locPos = self.view.pos
    local minX = locPos.x
    local maxX = locPos.x + self.view.length
    local minZ = locPos.z
    local maxZ = locPos.z + self.view.width
    -- print("pos.y", pos.x, pos.z)
    if cfgId == constant.BUILD_LIBERATORSHIP then
        minX = minX - 2.5
        maxX = maxX - 2.5
        minZ = minZ - 2.5
        maxZ = maxZ - 2.5
        if pos.x >= minX and pos.x <= maxX and pos.z >= minZ and pos.z <= maxZ then
            return true
        end
    else
        if pos.x >= minX and pos.x <= maxX and pos.z >= minZ and pos.z <= maxZ then
            return true
        end
    end

    return false
end

function Building:onBtnFork()
    self:destroy()
end

function Building:onBtnTick(isInstance)
    if self.itemId then
        local itemId = self.itemId
        local pos = self.view.pos
        if self.owner == BuildingManager.OWNER_OWN then

        elseif self.owner == BuildingManager.OWNER_OTHER then
            if gg.galaxyManager.curPlanet then
                local cfgId = gg.galaxyManager.curPlanet.cfgId

                GalaxyData.C2S_Player_putBuildOnGrid(cfgId, itemId, pos)
            end
        end
    else
        if self.onSpace then
            if self.owner == BuildingManager.OWNER_OWN then
                local yesCallback = function()
                    gg.buildingManager:requestLoadBuilding(self.buildCfg.cfgId, self.view.pos, isInstance)
                end

                local exchangeFailedCallback = function()
                    self:destroy()
                end

                BuildUtil.afterBuildingBuild(self.buildCfg, yesCallback, exchangeFailedCallback)
            elseif self.owner == BuildingManager.OWNER_OTHER then
                if gg.galaxyManager.curPlanet then
                    local cfgId = gg.galaxyManager.curPlanet.cfgId

                    GalaxyData.C2S_Player_PutUnionBuildOnGrid(cfgId, self.buildCfg.cfgId, self.view.pos)
                end
            end

        end
    end
end

function Building:onBtnRecycle()
    if self.buildCfg.type == constant.BUILD_CLUTTER then
        gg.printData(self.buildCfg)
        local isLock, lockMap, lockList = gg.buildingManager:checkNeedBuild(self.buildCfg.removeNeedBuilds)
        if isLock then
            gg.uiManager:openWindow("PnlAlertRemoveBuilding", {
                buildData = self.buildData,
                buildCfg = self.buildCfg
            })
        else
            local needBuild = BuildUtil.getCurBuildCfg(lockList[1].cfgId, lockList[1].level, lockList[1].quality)
            gg.uiManager:showTip(string.format("Upgrade %s to level %s to remove", needBuild.name, needBuild.level))
        end
    else
        local txt = "Are you sure you want to recycle this " .. self.buildCfg.name
        if self.buildData.chain <= 0 then
            txt = "Are you sure you want to delete this " .. self.buildCfg.name
        end
        local callbackYes = function()
            local id = self.buildData.id
            if self.owner == BuildingManager.OWNER_OWN then

            elseif self.owner == BuildingManager.OWNER_OTHER then
                if gg.galaxyManager.curPlanet then
                    local cfgId = gg.galaxyManager.curPlanet.cfgId
                    local quality = self.buildData.quality
                    local buildId = self.buildData.id
                    local chain = self.buildData.chain
                    if chain <= 0 then
                        txt = "Are you sure you want to delete this " .. self.buildCfg.name
                        GalaxyData.C2S_Player_delBuildOnGrid(cfgId, buildId)
                    else
                        GalaxyData.C2S_Player_storeBuildOnGrid(cfgId, buildId)
                    end
                end
            end
        end
        local args = {
            txt = txt,
            callbackYes = callbackYes
        }
        gg.uiManager:openWindow("PnlAlert", args)
    end
end

function Building:onBtnTool(index)
    local buildViewData = Building.BUILD_2_VIEW[self.buildCfg.cfgId]
    local data = {
        buildData = self.buildData,
        buildCfg = self.buildCfg,
        totalTrainTime = self.totalTrainTime
    }
    if buildViewData then
        if index == 1 then
            gg.uiManager:openWindow(buildViewData.viewName, data)
        elseif index == 2 then
            gg.uiManager:openWindow(buildViewData.viewName2, data)
        end
    end
end

function Building:onBtnBuildSpeedUp()
    if self.speedUpCallback then
        if self.speedUpCost then
            local callbackYes = function()
                self.speedUpCallback()
            end
            local txt = string.format(Utils.getText("res_FinishNow_AskText"), Utils.getShowRes(self.speedUpCost))
            gg.uiManager:openWindow("PnlAlert", {
                callbackYes = callbackYes,
                txt = txt,
                yesCostList = {{
                    cost = self.speedUpCost,
                    resId = constant.RES_TESSERACT
                }},
                autoCloseLessTick = self.timeBarLessTick

            })
        else
            self.speedUpCallback()
        end
    end
end

-- ""ui
function Building:showBuildUi(bool, isMove, isPlayAni)
    if not self.buildData then
        return
    end
    local view = self.view

    if not view.buildingObj then
        return
    end
    local isShowRangev = bool
    if bool then
        gg.event:dispatchEvent("onMoveFollowHide", true)
    else
        gg.event:dispatchEvent("onMoveFollow", true)
        gg.event:dispatchEvent("onUpdataMove", true)
    end
    if not self.onSpace then
        bool = false
    end

    local type = self.buildCfg.type
    local cfgId = self.buildCfg.cfgId
    local btnMap = {}

    if (self.owner == BuildingManager.OWNER_OWN or gg.galaxyManager:isMyResPlanet()) then
        -- ""
        if bool then
            if self.owner == BuildingManager.OWNER_OWN then
                btnMap[PnlPlayerInformation.BTN_INFORMATION] = true

                if cfgId == constant.BUILD_DRAFT then
                    btnMap[PnlPlayerInformation.BTN_EDIT_ARMY] = true
                end
                if cfgId == constant.BUILD_BASE then
                    btnMap[PnlPlayerInformation.BTN_REBACK] = true
                end

                -- if cfgId == constant.BUILD_DRAFT then
                --     btnMap[PnlPlayerInformation.BTN_EDIT_ARMY] = true
                -- end

                if self.buildData.level > 0 then
                    if cfgId == constant.BUILD_BLACKMARKET then
                        btnMap[PnlPlayerInformation.BTN_EXCHANGE] = true
                        if IsAuditVersion() then
                            btnMap[PnlPlayerInformation.BTN_EXCHANGE] = false
                            btnMap[PnlPlayerInformation.BTN_INFORMATION] = false

                        end
                    elseif cfgId == constant.BUILD_DRAFT then
                        btnMap[PnlPlayerInformation.BTN_FARMING] = true
                    elseif cfgId == constant.BUILD_HYPERSPACERESEARCH then
                        btnMap[PnlPlayerInformation.BTN_RESEARCH] = true
                    elseif cfgId == constant.BUILD_SHRINE then
                        btnMap[PnlPlayerInformation.BTN_SHRINE] = true
                    end
                end
                if type == constant.BUILD_DEFENSE or type == constant.BUILD_MINAES or type == constant.BUILD_CLUTTER then
                    local subType = self.buildCfg.subType
                    if (subType == 1 or subType == 3) and gg.sceneManager.playerInScene ~= constant.SCENE_BASE then
                        btnMap[PnlPlayerInformation.BTN_RECYCLE] = true
                    end
                    if type == constant.BUILD_CLUTTER then
                        btnMap[PnlPlayerInformation.BTN_INFORMATION] = false
                        btnMap[PnlPlayerInformation.BTN_SHOVEL] = true
                    end
                end

                if self.timeBarLessTick <= 0 then
                    local isLevelMax =
                        BuildUtil.getCurBuildCfg(cfgId, self.buildCfg.level + 1, self.buildCfg.quality) == nil
                    if self.buildCfg.subType ~= 2 and self.buildCfg.type ~= 8 and not isLevelMax then
                        btnMap[PnlPlayerInformation.BTN_UPGRAD] = true
                    end
                else
                    btnMap[PnlPlayerInformation.BTN_INFORMATION] = false
                    btnMap[PnlPlayerInformation.BTN_UPGRAD] = false

                end
            elseif self.owner == BuildingManager.OWNER_OTHER then
                btnMap[PnlPlayerInformation.BTN_INFORMATION] = true
                if self.buildData.isNormal or self.buildData.chain > 0 then
                    btnMap[PnlPlayerInformation.BTN_RECYCLE] = true
                end
            end
        end
        gg.event:dispatchEvent("onShowBuildButton", bool, btnMap, self)
        view.alertUi:SetActiveEx(not bool and not isMove)

        if not isMove then
            self.view.arrow:SetActive(bool)

            if self.buildCfg.type == constant.BUILD_DEFENSE then
                self.view.attackRange:SetActive(isShowRangev)
            end
        end

    else
        -- ""
        if gg.warShip:getButtonUiActive() then
            bool = false
        end
        self.view.infoUi.gameObject:SetActive(bool)
        if self.buildCfg.type == constant.BUILD_DEFENSE then
            self.view.attackRange:SetActive(isShowRangev)
        end
        if bool then
            local type = self.buildCfg.type
            local level = string.format("LV.%s", self.buildCfg.level)

            self.view.infoUi:Find("LayoutInfo/LayoutTitle/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text =
                Utils.getText(self.buildCfg.languageNameID)
            self.view.infoUi:Find("LayoutInfo/LayoutTitle/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = level

            if type == constant.BUILD_DEFENSE or type == constant.BUILD_MINAES then
                -- local atk = self.buildCfg.atk / 1000
                -- damge = string.format("damge:%s", atk)
                local attrList = {cfg.attribute.maxHp, cfg.attribute.atk}
                view.commonAttrItemHp:setActive(true)
                view.commonAttrItemAtk:setActive(true)
                view.commonAttrItemHp:setData(1, attrList, self.buildCfg, nil, CommonAttrItem.TYPE_SINGLE_TEXT)
                view.commonAttrItemAtk:setData(2, attrList, self.buildCfg, nil, CommonAttrItem.TYPE_SINGLE_TEXT)
            else
                local attrList = {cfg.attribute.maxHp}
                view.commonAttrItemHp:setActive(true)
                view.commonAttrItemAtk:setActive(false)
                view.commonAttrItemHp:setData(1, attrList, self.buildCfg, nil, CommonAttrItem.TYPE_SINGLE_TEXT)
            end

            local layoutAir = view.infoUi:Find("LayoutInfo/LayoutAir")
            layoutAir:SetActiveEx(self.buildCfg.atkAir == 0 or self.buildCfg.atkAir == 2)
        end
    end

    if bool and isPlayAni then
        self:playUiAni()
    elseif self.sequence then
        self:completeAni()
    end

    if self.buildCfg.type == 8 then
        view.arrow.transform:SetActiveEx(false)
    end
end

local aniTime = 0.3
function Building:playUiAni()
    self:completeAni()

    local view = self.view
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence = sequence

    local sequenceBuildingModel = CS.DG.Tweening.DOTween.Sequence()
    local buildingModel = self.view.buildingModel.transform
    sequenceBuildingModel:Join(buildingModel:DOScale(Vector3(1.2, 1.2, 1.2), aniTime / 2))
    sequenceBuildingModel:Append(buildingModel:DOScale(Vector3(1, 1, 1), aniTime / 2))

    for i = 1, 4 do
        local arrow = view.arrow.transform:Find("MoveArrow" .. i)
        arrow.localScale = Vector3(0.001, 0.001, 0)
        sequence:Join(arrow:DOScale(Vector3(1, 1, 1), aniTime))
        local arrowTargetPos = arrow.localPosition
        if i == 1 then
            arrow.localPosition = Vector3(arrowTargetPos.x + 2, arrowTargetPos.y, arrowTargetPos.z)
        elseif i == 2 then
            arrow.localPosition = Vector3(arrowTargetPos.x, arrowTargetPos.y, arrowTargetPos.z + 2)
        elseif i == 3 then
            arrow.localPosition = Vector3(arrowTargetPos.x - 2, arrowTargetPos.y, arrowTargetPos.z)
        elseif i == 4 then
            arrow.localPosition = Vector3(arrowTargetPos.x, arrowTargetPos.y, arrowTargetPos.z - 2)
        end
        sequence:Join(arrow:DOLocalMove(arrowTargetPos, aniTime))
    end
end

function Building:completeAni()
    if self.sequence then
        self.sequence:Complete()
    end
end

function Building:onHideRes(bool)
    if self.buildData then
        gg.event:dispatchEvent("onHideRes", self.buildData.id, bool)
    end
end

-- ""
function Building:buildSuccessful(buildData)
    self.buildData = buildData
    self.lastPos = self.buildData.pos
    self:makeSurface(true)

end

-- ""
function Building:onUpdateBuildData(buildData)
    -- if self.buildCfg.type == constant.BUILD_CLUTTER then
    --     return
    -- end
    local view = self.view
    self.buildData = buildData
    self.lastPos = self.buildData.pos
    view:setPos(self.buildData.pos)
    self:showRes(self.buildData)
    self.buildCfg = gg.buildingManager:getCfg(self.buildData.cfgId, self.buildData.level)

    if self.owner == BuildingManager.OWNER_OWN and not self.haveDrone and self.buildData.level > 0 then
        for k, v in pairs(Building.BUILDOFPRODUCTION) do
            if self.buildData.cfgId == v then
                self.drone = gg.droneManager:loadDrone(self)
                break
            end
        end
        self.haveDrone = true
    end

    -- local buildViewData = Building.BUILD_2_VIEW[self.buildCfg.cfgId]
    if self.buildCfg.cfgId ~= constant.BUILD_LIBERATORSHIP then
        view:setInBuilding(buildData.lessTick)
    end
    local totalTime = self.buildCfg.levelUpNeedTick

    self.speedUpCallback = function()
        if self.buildCfg.subType == 2 then
            BuildData.C2S_Player_MineLevelUp(self.buildData.id, 1)
        else
            BuildData.C2S_Player_BuildLevelUp(self.buildData.id, 1)
            self.autoCloseRequirement = {PnlAlert.CLOSE_REQUIREMENT_TYPE_BUILD, self.buildData.id}
        end
    end

    self.lessTick = buildData.lessTick
    local progressType = constant.BUILD_TIME_PROGRESS_TYPE.BUILD
    local timeBarIcon = nil -- "Ungrade arrow_icon"
    if self.lessTick == 0 then
        self.lessTick = buildData.lessTrainTick
        if self.lessTick > 0 then
            progressType = constant.BUILD_TIME_PROGRESS_TYPE.SOLDIER_TRAIN

            local soldierCfgId = buildData.trainCfgId
            local soldierLevel = 1
            for k, v in pairs(BuildData.soliderLevelData) do
                if soldierCfgId == v.cfgId then
                    soldierLevel = v.level
                end
            end
            local soldierCfg = cfg.getCfg("solider", soldierCfgId, soldierLevel)
            local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", soldierCfg.icon .. "_A")
            timeBarIcon = icon
            totalTime = buildData.trainCount * soldierCfg.trainNeedTick
            self.totalTrainTime = totalTime
            self.speedUpCallback = function()
                BuildData.C2S_Player_SpeedUp_SoliderTrain(self.buildData.id)
            end
        end
    end

    if self.lessTick > 0 then
        if self.buildCfg.level == 0 then
            -- ""
        else
            -- ""
        end
        self:setTimeBar(self.lessTick + os.time(), totalTime, timeBarIcon, progressType)
    else
        if view.buildingTimeBarBox then
            view.buildingTimeBarBox:setActive(false)
        end

        self:setTimeBar(-1, 0, nil, constant.BUILD_TIME_PROGRESS_TYPE.BUILD)
        self:setTimeBar(-1, 0, nil, constant.BUILD_TIME_PROGRESS_TYPE.SOLDIER_TRAIN)
        self:excuteViewEvent()
    end
    self.view:spineAnimPlay()
    -- self:showBuildUi(false, false, false, true)
    local name = self.buildCfg.name
    local level = self.buildData.level
    local id = self.buildData.id
    gg.event:dispatchEvent("onRefreshBuildMsg", name, level, id)
    local data = {
        buildData = self.buildData,
        buildCfg = self.buildCfg
    }
    gg.event:dispatchEvent("onRefreshPnlSoldier", data)

    -- self:refreshButtonUIIcon()

    -- if self.buildingSolider then
    --     self.buildingSolider:refreshSolider(self.view.buildingObj, self.buildData)
    -- end
end

function Building:refreshLevelUpTimeBar()
    if self.buildData and self.buildData.lessTickEnd and self.buildData.lessTickEnd > os.time() then
        self:setTimeBar(self.buildData.lessTickEnd, self.buildData.lessTick, nil,
            constant.BUILD_TIME_PROGRESS_TYPE.BUILD)
        self.speedUpCallback = function()
            if self.buildCfg.subType == 2 then
                BuildData.C2S_Player_MineLevelUp(self.buildData.id, 1)
            else
                BuildData.C2S_Player_BuildLevelUp(self.buildData.id, 1)
                self.autoCloseRequirement = {PnlAlert.CLOSE_REQUIREMENT_TYPE_BUILD, self.buildData.id}
            end
        end
    end
end

function Building:refreshButtonUIIcon()

end

-- type = constant.BUILD_TIME_PROGRESS_TYPE.
function Building:setTimeBar(endTime, totalTime, icon, type)
    local view = self.view
    self.timeBarLessTick = 0
    if not view.buildingTimeBarBox then
        self:refreshAlert()
        return
    end

    if endTime == -1 then
        if type == self.runningTimeBarType then
            self.runningTimeBarType = nil
            view.buildingTimeBarBox:setMessage(0, 0, self.buildData.id)
            -- self:onUpdateBuildData(self.buildData)
        end
        self:refreshAlert()
        return
    end
    self.runningTimeBarType = type

    local runCallback = function(time)
        self.timeBarLessTick = time
        self.speedUpCost = cfg.global.SpeedUpPerMinute.intValue * math.ceil(time / 60)
    end
    local finishCallback = function()
        self:refreshAlert()
    end
    self.timeBarLessTick = endTime - os.time()
    view.buildingTimeBarBox:setMessage(totalTime, endTime, self.buildData.id, runCallback, finishCallback)
    -- icon = icon or "Ungrade arrow_icon"
    view.buildingTimeBarBox:setIcon(icon)
    self:refreshAlert()
end

function Building:refreshAlert()
    local view = self.view

    if not self.view.buildingObj then
        return
    end

    if self.owner == BuildingManager.OWNER_OTHER or not self.buildData then
        self.view.bottomUi:SetActiveEx(false)
        self.view.layoutAlert.transform:SetActiveEx(false)
        return
    end

    if self.timeBarLessTick <= 0 and self.buildCfg.subType ~= 2 and self.buildCfg.type ~= 8 then
        self.view.bottomUi:SetActiveEx(BuildUtil.checkIsCanLevelUp(self.buildCfg))
    else
        self.view.bottomUi:SetActiveEx(false)
    end

    local showingTxtAlert = nil

    -- if self.buildCfg.cfgId == constant.BUILD_HYPERSPACERESEARCH and 
    --     self.runningTimeBarType ~= constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_SOLIDER and
    --     self.runningTimeBarType ~= constant.BUILD_TIME_PROGRESS_TYPE.INSTITUTE_MINE 

    if self.buildCfg.cfgId == constant.BUILD_HYPERSPACERESEARCH and not self.runningTimeBarType then
        local isCanResarch = false

        for key, value in pairs(BuildData.soliderLevelData) do
            local soliderCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][value.level]
            local nextLevelCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][value.level + 1]

            if soliderCfg.belong == 1 and SoliderUtil.isInSoldierWhiteList(soliderCfg.cfgId) and nextLevelCfg then
                local isUnlock, lockMap, lockList = gg.buildingManager:checkNeedBuild(soliderCfg.levelUpNeedBuilds)
                if isUnlock then
                    isCanResarch = true
                    break
                end
            end
        end

        if isCanResarch then
            showingTxtAlert = Utils.getText("main_ResarchTips")
        end
    elseif self.buildCfg.cfgId == constant.BUILD_DRAFT then

        local drafData = DraftData.reserveArmys[self.buildData.id]

        if drafData.trainCount > 0 then
            showingTxtAlert = Utils.getText("main_InTrainingTips")
        else
            local maxTrainSpace = self.buildCfg.maxTrainSpace
            local soldierCount = drafData.count + drafData.trainCount

            if soldierCount < maxTrainSpace then
                showingTxtAlert = Utils.getText("main_TrainTips")
            end
        end

        -- elseif Building.BUILD_2_VIEW[self.buildData.cfgId] and Building.BUILD_2_VIEW[self.buildData.cfgId].makeRes then
        --     local resId = Building.BUILD_2_VIEW[self.buildData.cfgId].makeRes
        --     local curDes = self.buildData[constant.RES_2_CFG_KEY[resId].BuildDataCurResKey]
        --     if ResData.getRes(resId) + curDes > gg.buildingManager.resMax[resId] then
        --         showingTxtAlert = "Max"
        --     end
    end

    if showingTxtAlert then
        if self.showingTxtAlert ~= showingTxtAlert then
            self.showingTxtAlert = showingTxtAlert
            self.view.layoutAlert.transform:SetActiveEx(true)
            self.view.txtAlert.text = showingTxtAlert
            Utils.setMultipleBgSize(view.bgTxtAlert, view.bgTxtAlertLeft, view.bgTxtAlertMid, view.bgTxtAlertRight,
                view.txtAlert.preferredWidth + 30)
        end
    else
        self.view.layoutAlert.transform:SetActiveEx(false)
        self.showingTxtAlert = nil
    end
end

function Building:onLanguageChange()
    self:refreshAlert()
end

-- ""
function Building:showRes(buildData)
    if self.owner == BuildingManager.OWNER_OTHER then
        return
    end
    local point = self.view.operPoint
    if self.view.resPoint then
        point = self.view.resPoint
    end
    if not point then
        return
    end

    local type = 0
    local resId = 0

    if buildData.curStarCoin > 0 then
        type = 1
        resId = constant.RES_STARCOIN
    end
    if buildData.curIce > 0 then
        type = 2
        resId = constant.RES_ICE
    end
    if buildData.curCarboxyl > 0 then
        type = 3
        resId = constant.RES_CARBOXYL
    end
    if buildData.curTitanium > 0 then
        type = 4
        resId = constant.RES_TITANIUM
    end
    if buildData.curGas > 0 then
        type = 5
        resId = constant.RES_GAS
    end
    if type ~= 0 then
        gg.event:dispatchEvent("onShowRes", buildData.id, point.gameObject, type, resId)
    else
        gg.event:dispatchEvent("onDestroyRes", buildData.id)
    end

    -- gg.event:dispatchEvent("onShowRes", buildData.id, point.gameObject, 2)
end

-- ""
function Building:buildGetResMsg(msg)
    local beginObj = self.view.operPoint.transform
    gg.resEffectManager:fly3dRes2TargetOnPnlPlayerInformation(beginObj, msg.resCfgId, msg.change)

    -- for key, value in pairs(constant.RES_2_CFG_KEY) do
    --     if msg[value.protoGetResKey] and msg[value.protoGetResKey] > 0 then
    --         gg.resEffectManager:fly3dRes2TargetOnPnlPlayerInformation(beginObj, key, msg[value.protoGetResKey])
    --     end
    -- end
end

-- ""
function Building:makeSurface(isNewBuilding)
    if not BuildingManager.IS_MAKE_SURFACE then
        return -- ""
    end
    if not SurfaceUtil.isHaveSurface(self.buildCfg) then
        return
    end

    SurfaceUtil.makeSurface(self.buildCfg, self.view.pos, self.view.surfaces.transform, self.buildData.id, true,
        function(data)
            self.surfaceData = {}
            self.surfaceData = data
        end, isNewBuilding, 0)

    self.dataPos = self.view.pos
end

function Building:refreshSurfaceData(isRefresh)
    if not self.surfaceData or not self.isMoved then
        return
    end
    self.isMoved = false
    local pos = self.view.pos
    local moveDistance = Vector3(pos.x - self.dataPos.x, 0, pos.z - self.dataPos.z)
    self.dataPos = pos
    local newSurfaceData = {}
    if not isRefresh then
        for k, v in pairs(self.surfaceData) do
            gg.buildingManager:cutSurfaceData(v.key, self.buildData.id)
        end
    end

    for k, v in pairs(self.surfaceData) do
        local data = v
        local keyX = data.keyX + moveDistance.x
        local keyZ = data.keyZ + moveDistance.z
        local key = SurfaceUtil.getSurfaceKey(keyX, keyZ)
        data.keyX = keyX
        data.keyZ = keyZ
        data.key = key
        newSurfaceData[key] = data

        gg.buildingManager:addSurfaceData(key, data, self.buildData.id)
    end
    self.surfaceData = {}
    self.surfaceData = newSurfaceData

    if isRefresh then
        gg.buildingManager:refreshSurface()
    end
end

function Building:resetSurface(isOutSide)
    if not self.surfaceData then
        return
    end
    self.view.surfaces:SetActive(true)
    for k, v in pairs(self.surfaceData) do
        v.obj:SetActive(true)
        SurfaceUtil.setSurfaveType(v, v.obj, v.type, v.angel, true, isOutSide)
    end
end

function Building:onResetSurface()
    self:resetSurface(false)
end

function Building:readyMove()
    if not self.isMoved then
        self.isMoved = true
        if not self.surfaceData then
            return
        end
        for k, v in pairs(self.surfaceData) do
            gg.buildingManager:cutSurfaceData(v.key, self.buildData.id)
        end
        gg.event:dispatchEvent("onResetSurface")
    end
end

function Building:onShowPlatform(args, isShow, owner)
    if self.view.platform then
        if owner == self.owner then
            self.view.platform:SetActive(isShow)
        end
    end
end

-- guide
function Building:getGuideGameObject(guideCfg)
    local eventType = guideCfg.buildingEvent
    local window = gg.uiManager:getWindow("PnlPlayerInformation")

    if eventType == gg.guideManager.BUILDING_EVENT_SELF then

        if guideCfg.buildingCfgId == constant.BUILD_BASE then
            return self.view.buildingObj, UnityEngine.Vector2(300, 300)
        end
        return self.view.buildingObj, UnityEngine.Vector2(250, 250)

    elseif eventType == gg.guideManager.BUILDING_EVENT_MESSAGE then
        return window.view.btnBuildToolList[PnlPlayerInformation.BTN_INFORMATION], UnityEngine.Vector2(50, 50)

    elseif eventType == gg.guideManager.BUILDING_EVENT_UPGRADE then
        return window.view.btnBuildToolList[PnlPlayerInformation.BTN_UPGRAD], UnityEngine.Vector2(50, 50)

    elseif eventType == gg.guideManager.BUILDING_EVENT_BUILD then
        return window.btnBuildToolList[PnlPlayerInformation.BTN_UPGRAD], UnityEngine.Vector2(50, 50)

    elseif eventType == gg.guideManager.BUILDING_EVENT_BUILDING_VIEW then -- aaaaa
        return window.view.btnTool, UnityEngine.Vector2(50, 50)

    elseif eventType == GuideManager.BUILDING_EVENT_SPEED_UP then
        return self.view.buildingTimeBarBox.btnSpeedUp, UnityEngine.Vector2(70, 40)

    elseif eventType == GuideManager.BUILDING_EVENT_SELF_OPEN_UPGRADE_VIEW then
        if guideCfg.buildingCfgId == constant.BUILD_BASE then
            return self.view.buildingObj, UnityEngine.Vector2(300, 300)
        end
        return self.view.buildingObj, UnityEngine.Vector2(250, 250)
    end
end

function Building:triggerGuideClick(guideCfg)
    local eventType = guideCfg.buildingEvent
    local window = gg.uiManager:getWindow("PnlPlayerInformation")
    if eventType == gg.guideManager.BUILDING_EVENT_SELF then
        for key, value in pairs(gg.buildingManager:getBuildingTable()) do
            if value == self then
                value:showBuildUi(true, false, true)
                gg.buildingManager.selectedBuilding = value
            else
                value:showBuildUi(false, false, false)
            end
        end

    elseif eventType == gg.guideManager.BUILDING_EVENT_MESSAGE then
        window:onBtnInformation()

    elseif eventType == gg.guideManager.BUILDING_EVENT_UPGRADE then
        window:onBtnUpgrade()

    elseif eventType == gg.guideManager.BUILDING_EVENT_BUILD then
        self.view.topUi.gameObject:SetActiveEx(false)
        self.view.buildingTimeBarBox:setStatickMessage(self.buildCfg.levelUpNeedTick)
        self.view.buildingTimeBarBox.transform:SetActiveEx(true)

    elseif eventType == gg.guideManager.BUILDING_EVENT_BUILDING_VIEW then -- aaaaa
        window:onBtnTool()

    elseif eventType == GuideManager.BUILDING_EVENT_SPEED_UP then
        if guideCfg.otherGuideId == GuideManager.OTHER_GUIDE_UPGRADE_BUILD then
            self.view.buildingTimeBarBox:onClickSpeedUp()
        else
            self:onBtnTick(true)
        end
    elseif eventType == GuideManager.BUILDING_EVENT_SELF_OPEN_UPGRADE_VIEW then
        window:onBtnUpgrade()
    end
end

return Building
