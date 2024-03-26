local WarShip = class("WarShip")

WarShip.UPGRADE_TYPE_NIL = 0
WarShip.UPGRADE_TYPE_WARSHIP = 1
WarShip.UPGRADE_TYPE_SKILL = 2

function WarShip:ctor()
    self.allWarShipCfg = cfg["warShip"]
    self.warShipData = nil
    self.warShipCfg = nil
    self.upgradeType = WarShip.UPGRADE_TYPE_NIL
end

-- ""base""
function WarShip:loadWarShip()
    gg.event:addListener("onRefreshWarShipData", self)

    self.warShipData = WarShipData.useData
    -- for _, data in pairs(WarShipData.warShipData) do
    --     self.warShipData = data
    -- end
    if not self.warShipData then
        return
    end
    self:getCfg()
    self:onLoadWarShip()

end

-- ""
function WarShip:onLoadWarShip()
    if self.warShipData then
        local cfg = self.warShipCfg
        if not self.view then
            self.view = ggclass.WarShipView.new()
            self.view:loadGameObject(cfg, function()
                self:onShow()
            end)
        else
            self.view:loadWarShipObj(cfg, function()
                self:onShow()
            end)
        end
    end
end

function WarShip:getCfg()
    if self.warShipData then

        local cfgId = self.warShipData.cfgId
        local level = self.warShipData.level
        local quality = self.warShipData.quality
        -- local forgeLevel = self.warShipData.forgeData.level

        for k, v in ipairs(self.allWarShipCfg) do
            if v.cfgId == cfgId and v.level == level and v.quality == quality then
                self.warShipCfg = v
                break
            end
        end
        if not self.warShipCfg then
            self.warShipCfg = self.allWarShipCfg[1]
        end

        -- for k, v in ipairs(cfg.warShipForge) do
        --     if v.cfgId == cfgId and v.level == forgeLevel and v.quality == quality then
        --         self.warshipForgeCfg = v
        --         break
        --     end
        -- end
    end
end

function WarShip:onShow()
    self:bindEvent()
    self:onRefreshWarShipData(nil, self.warShipData)
end

function WarShip:bindEvent()
    local view = self.view
    -- CS.UIEventHandler.Get(view.cubeCollider):SetOnClick(function()
    --     self:onClickWarShip()
    -- end)

    view.buildingButtonUiBox:setBtnInfomationCallBack(gg.bind(self.onBtnInformation, self))
    view.buildingButtonUiBox:setBtnUpgradeCallBack(gg.bind(self.onBtnUpgrade, self))
    view.buildingButtonUiBox:setBtnRecycleCallBack(gg.bind(self.onBtnRecycle, self))
    view.buildingButtonUiBox:setBtnToolCallBack(gg.bind(self.onBtnTool, self))
    view.buildingButtonUiBox:setBtnSpeedUpCallBack(gg.bind(self.onBtnBuildSpeedUp, self))
    gg.event:addListener("onHideUi", self)
end

function WarShip:releaseEvent()
    -- CS.UIEventHandler.Clear(self.view.cubeCollider)
    gg.event:removeListener("onHideUi", self)
end

-- ""
function WarShip:releaseAllResources()
    gg.event:removeListener("onRefreshWarShipData", self)
    self:onDestory()
end

-- ""
function WarShip:onDestory()
    if self.warShipData then
        self:releaseEvent()
        self.view:onDestory()
        self.view = nil
        self.warShipData = nil
        self.warShipCfg = nil
    end
end

function WarShip:onClickWarShip()
    if self.warShipData then
        if self:getButtonUiActive() then
            self:onHideUi()
        else
            self.view.buildingButtonUiBox:showButtonUi(true)
            self.view.buildingButtonUiBox:playUiAni(true)
            local operPoint = self.view.operPoint
            local name = self.warShipCfg.name
            local level = self.warShipData.level
            local id = self.warShipData.id
            gg.event:dispatchEvent("onShowBuildMsg", true, operPoint, name, level, id, self.warShipCfg)
        end
    end
end

function WarShip:onBtnInformation()
    local args = {
        showingType = PnlWarShip.VIEW_INFORMATION
    }

    gg.uiManager:openWindow("PnlWarShip", args)
    self:onHideUi()
end

function WarShip:onBtnUpgrade()
    local args = {
        showingType = PnlWarShip.VIEW_UPGRADE
    }

    gg.uiManager:openWindow("PnlWarShip", args)
    self:onHideUi()
end

function WarShip:onBtnRecycle()
    -- self:recycleWarShip()
    -- self:onHideUi()
end

function WarShip:onBtnTool()
    local args = {
        showingType = PnlWarShip.VIEW_INFORMATION
    }
    gg.uiManager:openWindow("PnlWarShip", args)
    self:onHideUi()
end

function WarShip:onBtnBuildSpeedUp()
    if self.upgradeType == WarShip.UPGRADE_TYPE_WARSHIP then
        WarShipData.C2S_Player_WarShipLevelUp(gg.warShip.warShipData.id, 1)
    else

    end
end

function WarShip:onHideUi()
    if self:getButtonUiActive() then
        self.view.buildingButtonUiBox:showButtonUi(false)
        gg.event:dispatchEvent("onShowBuildMsg", false)
    end
end

function WarShip:upgradeWarShip()
    if self.upgradeType == WarShip.UPGRADE_TYPE_NIL or self.upgradeType == WarShip.UPGRADE_TYPE_WARSHIP then
        WarShipData.C2S_Player_WarShipLevelUp(gg.warShip.warShipData.id, 0)
    else
        self:showUpgradeTips()
    end
end

function WarShip:instantUpgradeWarShip(id)
    if self.upgradeType == WarShip.UPGRADE_TYPE_NIL or self.upgradeType == WarShip.UPGRADE_TYPE_WARSHIP then
        WarShipData.C2S_Player_WarShipLevelUp(id, 1)
    else
        self:showUpgradeTips()
    end
end

function WarShip:upgradeWarShipSkill(index)
    if self.upgradeType == WarShip.UPGRADE_TYPE_NIL or self.upgradeType == WarShip.UPGRADE_TYPE_SKILL then
        WarShipData.C2S_Player_WarShipSkillUp(gg.warShip.warShipData.id, index, 0)
    else
        self:showUpgradeTips()
    end
end

function WarShip:instantUpgradeWarShipSkill(index)
    if self.upgradeType == WarShip.UPGRADE_TYPE_NIL or self.upgradeType == WarShip.UPGRADE_TYPE_SKILL then
        if gg.warShip.warShipData.skillUpLessTick > 0 then
            
        else
            WarShipData.C2S_Player_WarShipSkillUp(gg.warShip.warShipData.id, index, 1)
        end
    else
        self:showUpgradeTips()
    end
end

function WarShip:showUpgradeTips()
    local tips = ""
    if self.upgradeType == WarShip.UPGRADE_TYPE_WARSHIP then
        tips = "Upgrading the battleship, please wait!"
    end
    if self.upgradeType == WarShip.UPGRADE_TYPE_SKILL then
        tips = "Upgrading skills, please wait!"
    end
    gg.uiManager:showTip(tips)
end

function WarShip:getButtonUiActive()
    if self.view then
        return self.view.buildingButtonUiBox:getButtonUIActive()
    else
        return false
    end
end

-- ""
function WarShip:onRefreshWarShipData(args, data, id, type)
    if data and type == 1 then
        if data.id == WarShipData.useData.id then
            local isLoadNewShip = false
            if self.warShipData then
                if self.warShipData.id ~= data.id then
                    isLoadNewShip = true
                end
            else
                isLoadNewShip = true
            end
            self.warShipData = data
            self:getCfg()
            if isLoadNewShip then
                self:onLoadWarShip()
            end
            self.lessTick = 0
            self:setUpgradeType(data)

            local view = self.view
            if view.buildingButtonUiBox then
                if self.lessTick > 0 then
                    local runCallback = function(time)
                        view.buildingButtonUiBox.txtBuildSpeedUpCost.text =
                            cfg.global.SpeedUpPerMinute.intValue * math.ceil(time / 60)
                    end
                    view.buildingTimeBarBox:setMessage(self.needTick, self.lessTick + os.time(), self.warShipData.id,
                        runCallback)
                    -- view.buildingTimeBarBox:setIcon("Upgrade_icon")
                    -- local icon = 
                    view.buildingTimeBarBox:setIcon(self.upgradeIcon)

                    view.buildingButtonUiBox:setNeedBtnMap({
                        ["btnInformation"] = true,
                        ["btnSpeedUp"] = false,
                        ["btnUpgrade"] = false,
                        ["btnRecycle"] = false,
                        ["btnTool"] = false
                    })
                else
                    view.buildingTimeBarBox:setActive(false)
                    view.buildingTimeBarBox:setMessage(0, 0)
                    view.buildingButtonUiBox:setNeedBtnMap({
                        ["btnInformation"] = true,
                        ["btnSpeedUp"] = false,
                        ["btnUpgrade"] = true,
                        ["btnRecycle"] = false,
                        ["btnTool"] = false
                    })
                end
            end

            local name = self.warShipCfg.name
            local level = self.warShipData.level
            local id = self.warShipData.id

            gg.event:dispatchEvent("onRefreshBuildMsg", name, level, id)

        end
    else
        if id == self.warShipData.id then
            self:onHideUi()
            self:onDestory()
        end
    end
end

function WarShip:setUpgradeType(data)
    self.upgradeIcon = nil
    self.upgradeType = WarShip.UPGRADE_TYPE_NIL
    if data.lessTick ~= 0 then
        self.upgradeType = WarShip.UPGRADE_TYPE_WARSHIP
        self.lessTick = data.lessTick
        self.needTick = self.warShipCfg.levelUpNeedTick
        self.upgradeIcon = gg.getSpriteAtlasName("Warship_A_Atlas", self.warShipCfg.icon .. "_A")
    elseif data.skillUpLessTick ~= 0 then
        self.upgradeType = WarShip.UPGRADE_TYPE_SKILL
        self.lessTick = data.skillUpLessTick
        local skillUp = self.warShipData.skillUp
        local skillLevel = 0
        local skillId = 0
        if skillUp == 1 then
            skillLevel = self.warShipData.skillLevel1
            skillId = self.warShipData.skill1
        elseif skillUp == 2 then
            skillLevel = self.warShipData.skillLevel2
            skillId = self.warShipData.skill2
        elseif skillUp == 3 then
            skillLevel = self.warShipData.skillLevel3
            skillId = self.warShipData.skill3
        elseif skillUp == 4 then
            skillLevel = self.warShipData.skillLevel4
            skillId = self.warShipData.skill4
        elseif skillUp == 5 then
            skillLevel = self.warShipData.skillLevel5
            skillId = self.warShipData.skill5
        end
        local skillCfg = cfg.getCfg("skill", skillId, skillLevel)
        self.needTick = skillCfg.levelUpNeedTick
        self.upgradeIcon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")
    end
end

-- ""
function WarShip:getSkillCfg(cfgId, level)
    local allSkillCfg = cfg["skill"]
    local skillCfg = nil
    for k, v in ipairs(allSkillCfg) do
        if v.cfgId == cfgId and v.level == level then
            skillCfg = v
        end
    end
    return skillCfg
end

function WarShip:checkAlertLife()
    if not self.warShipData then
        return false, 0
    end
    return self.warShipData.life < 10, self.warShipData.life
end

return WarShip
