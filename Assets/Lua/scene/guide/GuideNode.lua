local GuideNode = class("GuideNode")

function GuideNode:ctor(guideId, isExtra)
    self.guideStage = GuideManager.GUIDE_STAGE_PAUSE
    self.guideCfg = nil
    self.guideCfgMap = nil
    self.guidingView = nil
    self.guidingBuild = nil
    self.softGuide = nil

-- ""
    self.otherGuideType = nil

    gg.event:addListener("onBattleFingerUp", self)
    self:initData(guideId, isExtra)
end

function GuideNode:initData(guideId, isExtra)
    self.initGuideId = guideId
    self:setGuide(guideId, 1)
    self.isExtra = isExtra
end

function GuideNode:setGuideCfg(guideCfg)
    self.guideStage = GuideManager.GUIDE_STAGE_WAITING
    self.guideCfg = guideCfg

    if guideCfg then
        self.guideId = guideCfg.guideId
        self.stepId = guideCfg.stepId
    else
        self.guideId = -1
        self.stepId = -1
    end

    if self.guideId == 2001 and self.stepId == 2 then
        PlayerData.C2S_Player_CleanAllArmy()
    end
end

function GuideNode:setOtherGuide(otherGuideType, guideCfg)
    self.otherGuideType = otherGuideType
    self:setGuideCfg(guideCfg)
end

function GuideNode:setGuide(guideId, stepId)
    self:setGuideCfg(GuideUtil.getGuideCfg(guideId, stepId))
end

function GuideNode:Update(isCanGuide)
    if not self.guideCfg or self.guideStage == GuideManager.GUIDE_STAGE_PAUSE then
        return
    end

    -- local isCanGuide = GuideUtil.checkIsCanGuide(self.guideCfg)
    if self.guideStage == GuideManager.GUIDE_STAGE_GUIDING then
        if not isCanGuide then
            if self.guideCfg.isSoft ~= 1 then
                gg.uiManager:closeWindow("PnlGuide")
            end
            if self.softGuide then
                self.softGuide:close()
            end

            gg.warCameraCtrl:setGuideStopCamera(false)
            -- self:setGuide(self.guideId, 1)
            self:setGuide(self.guideId, self.stepId)

        else
            if self.guideCfg.isSoft == 1 and self.softGuide then
                self.softGuide:update()
            end
        end

        return
    end

    if not isCanGuide then
        return
    end

    self:guide()
end

function GuideNode:guide()
    local isImmediateTrigger = false

    if self.guideCfg.targetType == GuideManager.TARGET_TYPE_ONLY_TALK then
        self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
        gg.uiManager:openWindow("PnlGuide", {isPlayAnim = false, guideCfg = self.guideCfg, guideNode = self})

    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_VIEW then
        local uiView = gg.uiManager:getWindow(self.guideCfg.pnlName)
        if not uiView:isShow() then
            return
        end

        local obj = uiView:getGuideRectTransform(self.guideCfg)
        --if obj and obj.gameObject.activeInHierarchy then
        if obj then
            self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
            self.guidingView = uiView

            if self.guideCfg.isSoft == 1 then
                self.softGuide = self.softGuide or SoftGuide.new()
                self.softGuide:setData(self)
            else
                gg.uiManager:openWindow("PnlGuide", {isPlayAnim = self.guideCfg.isPlayAnim == 1, guideCfg = self.guideCfg, guideNode = self})
            end
        end

    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BUILDING or self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
        local building = nil

        if self.guideCfg.otherArgs and self.guideCfg.otherArgs[1] == "selectedBuilding" then
            building = gg.buildingManager.selectedBuilding
        else
            if self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
                if self.guideCfg.otherArgs and self.guideCfg.otherArgs[2] == "deployArea" then
                    building = {}
                    building.buildCfg = {
                        pos = gg.sceneManager:getDeployArea().transform.position,
                        width = 0,
                        length = 0,
                    }
                elseif self.guideCfg.otherArgs and self.guideCfg.otherArgs[2] == "SigninPos" then
                    -- local signinPos1 = CS.NewGameData._SigninPos1
                    local signinPos = Vector3(11, 5, 29)
                    building = {}
                    building.buildCfg = {
                        -- pos = Vector3(signinPos1.x, signinPos1.y, signinPos1.z),
                        pos = signinPos,
                        width = 0,
                        length = 0,
                    }

                elseif self.guideCfg.otherArgs and self.guideCfg.otherArgs[2] == "findHurtBuild" then
                    local hp = self.guideCfg.otherArgs[3].hp or 5000
                    local cfgId = self.guideCfg.otherArgs[3].cfgId or 0
                    local pos = CS.LockStepLogicMonoBehaviour.FindHurtBuilding(hp, cfgId)

                    if pos ~= CS.UnityEngine.Vector3.zero then
                        self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
                        building = {}
                        building.buildCfg = {
                            pos = pos,
                            width = 0,
                            length = 0,
                        }
                    end

                elseif self.guideCfg.otherArgs and self.guideCfg.otherArgs[2] == "needCureSoldier" then
                    local pos = CS.LockStepLogicMonoBehaviour.GetNeedCureSoldierPos()
                    if pos ~= CS.UnityEngine.Vector3.zero then
                        building = {}
                        building.buildCfg = {
                            pos = pos,
                            width = 0,
                            length = 0,
                        }
                    end

                else
                    for key, value in pairs(gg.buildingManager:getBuildingTable()) do
                        building = value
                    end
                end
            elseif  self.guideCfg.targetType == GuideManager.TARGET_TYPE_BUILDING then
                for key, value in pairs(gg.buildingManager:getBuildingTable()) do
                    if value.buildCfg.cfgId == self.guideCfg.buildingCfgId then

                        if self.guideCfg.buildingSelectArgs then
                            -- if self.guideCfg.buildingSelectArgs.levelLessThen and  then
                            -- end
                            local isSelect = true
                            for k, v in pairs(self.guideCfg.buildingSelectArgs) do
                                if k == "levelLessThen" and v <= value.buildCfg.level then
                                    isSelect = false
                                end
                            end

                            if isSelect then
                                building = value
                            end

                        else
                            building = value
                        end
                    end
                end
            end
        end

        if not building then
            return
        end
        self.guidingBuild = building

        if self.guideCfg.targetType == GuideManager.TARGET_TYPE_BUILDING then
            if building.view.buildingObj then
                self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
                gg.uiManager:openWindow("PnlGuide", {isPlayAnim = self.guideCfg.isPlayAnim == 1, guideCfg = self.guideCfg, guideNode = self})
            end
            
        elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
            self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
            gg.warCameraCtrl:setGuideStopCamera(true)
            gg.uiManager:openWindow("PnlGuide", {isPlayAnim = self.guideCfg.isPlayAnim == 1, guideCfg = self.guideCfg, guideNode = self})
        end

        if self.guideStage == GuideManager.GUIDE_STAGE_GUIDING then
            if self.guideCfg.isCameraCenter then
                gg.warCameraCtrl:setCameraPosInBase(false, true)
                gg.event:dispatchEvent("onMoveFollow")
                gg.event:dispatchEvent("onUpdataMove")
            end
            if self.guideCfg.cameraArgs then
                local cameraArgs = self.guideCfg.cameraArgs
                gg.warCameraCtrl:moveCamera(UnityEngine.Camera.main.transform.position,
                Vector3(cameraArgs[1][1], cameraArgs[1][2], cameraArgs[1][3]), 30, 9.9, true)
            end
        end
    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_CONDITION then
        if self.guideCfg.otherArgs then
            if self.guideCfg.otherArgs[1] == "findCureSoldier" then
                local pos = CS.LockStepLogicMonoBehaviour.GetNeedCureSoldierPos()
                if pos ~= CS.UnityEngine.Vector3.zero then
                    self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
                    gg.warCameraCtrl:setGuideStopCamera(true)
                    if self.guideCfg.pauseBattleOnStart == 1 then
                        gg.battleManager.battleMono.BattleLogic:ChangeBattleSpeed(0)
                    end
                    isImmediateTrigger = true
                end

            elseif self.guideCfg.otherArgs[1] == "findHurtBuild" then

                local hp = self.guideCfg.otherArgs[2].hp or 5000
                local cfgId = self.guideCfg.otherArgs[2].cfgId or 0
                local pos = CS.LockStepLogicMonoBehaviour.FindHurtBuilding(hp, cfgId)

                if pos ~= CS.UnityEngine.Vector3.zero then
                    self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
                    isImmediateTrigger = true
                end
            end
        end

    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_REPLAY then
        self.guideStage = GuideManager.GUIDE_STAGE_GUIDING
        gg.sceneManager.enemyData = {
            playerName = PlayerData.myInfo.name,
            score = PlayerData.myInfo.badge,
        }

        GuideManager.replayData.bVersion = CS.Appconst.BattleVersion
        gg.battleManager:lookBattlePlayBack(GuideManager.replayData, self)
    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_OPEN_VIEW then
        gg.uiManager:openWindow(self.guideCfg.otherArgs[1], gg.unPackArgs(self.guideCfg.otherArgs[2]))
        isImmediateTrigger = true
    end

    if self.guideStage == GuideManager.GUIDE_STAGE_GUIDING or isImmediateTrigger then
        if self.guideCfg.pauseBattleOnStart == 1 then
            gg.battleManager.battleMono.BattleLogic:ChangeBattleSpeed(0)
        end

        if self.guideCfg.startDispatchEvent then
            gg.event:dispatchEvent(self.guideCfg.startDispatchEvent[1], gg.unPackArgs(self.guideCfg.startDispatchEvent[2]))
        end
    end

    if isImmediateTrigger then
        self:triggerGuide()
    end
end

-- --"" ""pnlGuide
function GuideNode:triggerGuide()
    if not self.isExtra and not PlayerData.guidesMap[self.initGuideId] then
        return
    end

    if self.guideCfg.targetType == GuideManager.TARGET_TYPE_ONLY_TALK then

    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_VIEW then
        self.guidingView:triggerGuideClick(self.guideCfg)

    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BUILDING then
        self.guidingBuild:triggerGuideClick(self.guideCfg)
    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_REPLAY then

    elseif self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
        if self.guideCfg.otherArgs[2] == "needCureSoldier" then
            gg.battleManager.battleMono:AddCurOper2NeedCureSoldier()
        elseif self.guideCfg.otherArgs[2] == "findHurtBuild" then
            local hp = self.guideCfg.otherArgs[3].hp or 5000
            local cfgId = self.guideCfg.otherArgs[3].cfgId or 0
            gg.battleManager.battleMono:AddCurOper2HurtBuilding(hp, cfgId)
        end
    end

    if self.guideCfg.endDispatchEvent then
        gg.event:dispatchEvent(self.guideCfg.endDispatchEvent[1], gg.unPackArgs(self.guideCfg.endDispatchEvent[2]))
    end

    gg.warCameraCtrl:setGuideStopCamera(false)

    -- if self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
    --     gg.warCameraCtrl:setGuideStopCamera(false)
    -- end

    if self.guideCfg.continueBattleOnEnd == 1 then
        -- CS.Battle.UnityTools.SetTimeScale(1)
        gg.battleManager.battleMono.BattleLogic:ChangeBattleSpeed(1)
    end

    gg.uiManager:closeWindow("PnlGuide")

    if self.guideCfg.extraGuideId then
        gg.guideManager:addGuide(self.guideCfg.extraGuideId, true)
    end

    if self.otherGuideType then
        local nextGuideCfg
        -- if self.otherGuideType == GuideManager.OTHER_GUIDE_TYPE_PNLBUILD_BUILD then
        --     nextGuideCfg = gg.guideManager:getBuildGuideCfg()
        -- end

        if self.otherGuideType == GuideManager.OTHER_GUIDE_UPGRADE_BUILD then
            nextGuideCfg = GuideManager:getBuildUpgradeGuideCfg(self.guideCfg.buildingCfgId, self.stepId + 1, self.initGuideId, self.guideCfg.buildingSelectArgs)
        end

        if nextGuideCfg then
            self:setGuideCfg(nextGuideCfg)
        else
            self:pauseGuide()
            gg.guideManager:removeGuide(self.initGuideId)
        end
        return
    end

    if GuideUtil.getGuideCfg(self.guideId, self.stepId + 1) ~= nil then
        self:setGuide(self.guideId, self.stepId + 1)
    else
        self:pauseGuide()
        gg.guideManager:removeGuide(self.initGuideId)

        local firstGuideCfg = GuideUtil.getGuideCfg(self.initGuideId, 1)
        if firstGuideCfg.nextGuideIds then
            for key, value in pairs(firstGuideCfg.nextGuideIds) do
                gg.guideManager:addGuide(value, self.isExtra)
            end
        end

        if self.isExtra then
            -- local firstGuideCfg = GuideUtil.getGuideCfg(self.initGuideId, 1)
            -- if firstGuideCfg.nextGuideIds then
            --     for key, value in pairs(firstGuideCfg.nextGuideIds) do
            --         gg.guideManager:addGuide(value, true)
            --     end
            -- end
        else
            PlayerData.C2S_Player_finishGuides({{guideId = self.guideId, skipOthers = 0}})
        end
    end
end

function GuideNode:skipGuide()
    gg.buildingManager:cancelBuildOrMove()

    if self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
        gg.warCameraCtrl:setGuideStopCamera(false)
        gg.battleManager.battleMono.BattleLogic:ChangeBattleSpeed(1)
    end

    if self.isExtra then
        self:pauseGuide()
        gg.guideManager:removeGuide(self.initGuideId)
    else
        self:pauseGuide()
        PlayerData.C2S_Player_finishGuides({{guideId = self.initGuideId, skipOthers = 1}})
    end
    self:setGuide(-1, -1)
end

function GuideNode:pauseGuide()
    if self.guideStage == GuideManager.GUIDE_STAGE_GUIDING then
        if self.guideCfg.isSoft == 1 then
            if self.softGuide then
                self.softGuide:close()
            end
        else
            gg.uiManager:closeWindow("PnlGuide")
        end
    end
    self.guideStage = GuideManager.GUIDE_STAGE_PAUSE
end

function GuideNode:onBattleFingerUp()
    if self.guideStage == GuideManager.GUIDE_STAGE_GUIDING and self.guideCfg.targetType == GuideManager.TARGET_TYPE_BATTLE_BUILDING then
        self:triggerGuide()
    end
end

function GuideNode:release()
    if self.softGuide then
        self.softGuide:release()
        self.softGuide = nil
    end
end
