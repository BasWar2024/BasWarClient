local WarShip = class("WarShip")

WarShip.UPGRADE_TYPE_NIL = 0
WarShip.UPGRADE_TYPE_WARSHIP = 1
WarShip.UPGRADE_TYPE_SKILL = 2

function WarShip:ctor()
    self.allWarShipCfg = cfg.get("etc.cfg.warShip")
    self.warShipData = nil
    self.warShipCfg = nil
end

--base
function WarShip:loadWarShip()
    gg.event:addListener("onRefreshWarShipData", self)
    for _, data in pairs(WarShipData.warShipData) do
        self.warShipData = data
    end
    if not self.warShipData then
        return
    end
    self:getCfg()
    self:onLoadWarShip()
end

--
function WarShip:onLoadWarShip()
    if self.warShipData then
        local name = self.warShipCfg.name
        if not self.view then
            self.view = ggclass.WarShipView.new()
            self.view:loadGameObject("01", function()
                self:onShow()
            end)
        else
            self.view:loadWarShipObj("01", function()
                self:onShow()
            end)
        end
    end
end

function WarShip:getCfg()
    if self.warShipData then
        local cfgId = self.warShipData.cfgId
    local level = self.warShipData.level
    local cfgData = nil
    self.warShipCfg = {}
    for k, v in ipairs(self.allWarShipCfg) do
        if v.cfgId == cfgId and v.level == level then
            cfgData = v
        end
    end
    self.warShipCfg = cfgData
    end  
end

function WarShip:onShow()
    self:bindEvent()
    self:onRefreshWarShipData(nil, self.warShipData)
end

function WarShip:bindEvent()
    CS.UIEventHandler.Get(self.view.obj):SetOnClick(function()
        self:onClickWarShip()
    end)
    CS.UIEventHandler.Get(self.view.buttonUi:Find("BtnInformation").gameObject):SetOnClick(function()
        self:onBtnInformation()
    end)
    CS.UIEventHandler.Get(self.view.buttonUi:Find("BtnUpgrade").gameObject):SetOnClick(function()
        self:onBtnUpgrade()
    end)
    CS.UIEventHandler.Get(self.view.buttonUi:Find("BtnRecycle").gameObject):SetOnClick(function()
        self:onBtnRecycle()
    end)
    CS.UIEventHandler.Get(self.view.buttonUi:Find("BtnTool").gameObject):SetOnClick(function()
        self:onBtnTool()
    end)

    CS.UIEventHandler.Get(self.view.btnBuildSpeedUp):SetOnClick(function()
        self:onBtnBuildSpeedUp()
    end)

    gg.event:addListener("onHideUi", self)
end

function WarShip:releaseEvent()
    CS.UIEventHandler.Clear(self.view.obj) 
    CS.UIEventHandler.Clear(self.view.buttonUi:Find("BtnInformation").gameObject) 
    CS.UIEventHandler.Clear(self.view.buttonUi:Find("BtnUpgrade").gameObject) 
    CS.UIEventHandler.Clear(self.view.buttonUi:Find("BtnRecycle").gameObject) 
    CS.UIEventHandler.Clear(self.view.buttonUi:Find("BtnTool").gameObject)
    CS.UIEventHandler.Clear(self.view.btnBuildSpeedUp.gameObject)

    gg.event:removeListener("onHideUi", self)
end

--
function WarShip:releaseAllResources()
    gg.event:removeListener("onRefreshWarShipData", self)
    self:onDestory()
end

--
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
            self.view.buttonUi.gameObject:SetActive(true)
            local operPoint = self.view.operPoint
            local name = self.warShipCfg.name 
            local level = self.warShipCfg.level 
            gg.event:dispatchEvent("onShowBuildMsg", true, operPoint, name, level)  
        end
    end
end

function WarShip:onBtnInformation()
    gg.uiManager:openWindow("PnlWarShip", PnlWarShip.VIEW_INFORMATION)
    self:onHideUi()
end

function WarShip:onBtnUpgrade()
    gg.uiManager:openWindow("PnlWarShip", PnlWarShip.VIEW_UPGRADE)
    self:onHideUi()
end

function WarShip:onBtnRecycle()
    self:recycleWarShip()
    self:onHideUi()
end

function WarShip:onBtnTool()
    gg.uiManager:openWindow("PnlWarShip", PnlWarShip.VIEW_SKILL)
    self:onHideUi()
end

function WarShip:onBtnBuildSpeedUp()
    if self.upgradeType == WarShip.UPGRADE_TYPE_WARSHIP then
        WarShipData.C2S_Player_SpeedUp_WarShipLevelUp(gg.warShip.warShipData.id)
    else
        WarShipData.C2S_Player_SpeedUp_WarShipSkillUp(gg.warShip.warShipData.id)
    end
end

function WarShip:onHideUi()
    if self:getButtonUiActive() then
        self.view.buttonUi.gameObject:SetActive(false)
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

function WarShip:instantUpgradeWarShip()
    if self.upgradeType == WarShip.UPGRADE_TYPE_NIL or self.upgradeType == WarShip.UPGRADE_TYPE_WARSHIP then
        if self.warShipData.lessTick > 0 then
            WarShipData.C2S_Player_SpeedUp_WarShipLevelUp(gg.warShip.warShipData.id)
        else
            WarShipData.C2S_Player_WarShipLevelUp(gg.warShip.warShipData.id, 1)
        end
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
            WarShipData.C2S_Player_SpeedUp_WarShipSkillUp(gg.warShip.warShipData.id)
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

function WarShip:recycleWarShip()
    local name = self.warShipCfg.name
    local txt = "Are you sure you want to recycle this "..name
    local callbackYes = function()
        ItemData.C2S_Player_Move2ItemBag(gg.warShip.warShipData.id, 9)
    end

    local args = {txt = txt, callbackYes = callbackYes}
    gg.uiManager:openWindow("PnlAlert", args)   
end

function WarShip:getButtonUiActive()
    if self.view then
        return self.view.buttonUi.gameObject.activeSelf
    else
        return false
    end
end

--
function WarShip:onRefreshWarShipData(args, data)
    if data then
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
        if self.lessTick > 0 then
            local percent = self.lessTick / self.needTick
            view:showTimeBar(true)
            view:setTimeBar(percent, self.lessTick)
            self:stopLessTick()
            self.lessTickTimer = gg.timer:startLoopTimer(1, 1, self.lessTick, function()
                self.lessTick = self.lessTick - 1
                self.view.txtBuildSpeedUpCost.text = cfg.global.SpeedUpPerMinute.intValue * math.ceil(self.lessTick / 60)
                if self.lessTick <= 0 then
                    view:showTimeBar(false)
                    self:stopLessTick()
                end
                local percent = self.lessTick / self.needTick
                view:setTimeBar(percent, self.lessTick)
            end)
        end
    else
        self:onHideUi()
        self:onDestory()
    end
end

function WarShip:setUpgradeType(data)
    self.upgradeType = WarShip.UPGRADE_TYPE_NIL
    if data.lessTick ~= 0 then
        self.upgradeType = WarShip.UPGRADE_TYPE_WARSHIP
        self.lessTick = data.lessTick
        self.needTick = self.warShipCfg.levelUpNeedTick
    elseif data.skillUpLessTick ~= 0 then
        self.upgradeType = WarShip.UPGRADE_TYPE_SKILL
        self.lessTick = data.skillUpLessTick
        local skillUp = self.warShipCfg.skillUp
        local skillLevel = 0
        local skillId = 0
        if skillUp == 1 then
            skillLevel = self.warShipCfg.skillLevel1
            skillId = self.warShipData.skill1
        elseif skillUp == 2 then
            skillLevel = self.warShipCfg.skillLevel2
            skillId = self.warShipData.skill2
        elseif skillUp == 3 then
            skillLevel = self.warShipCfg.skillLevel3
            skillId = self.warShipData.skill3
        elseif skillUp == 4 then
            skillLevel = self.warShipCfg.skillLevel4
            skillId = self.warShipData.skill4
        elseif skillUp == 5 then
            skillLevel = self.warShipCfg.skillLevel5
            skillId = self.warShipData.skill5
        end
        local skillCfg = cfg:getCfg("skill", skillId, skillLevel)
        self.needTick = self.warShipCfg.levelUpNeedTick
    end
end 

--
function WarShip:getSkillCfg(cfgId, level)
    local allSkillCfg = cfg.get("etc.cfg.skill")
    local skillCfg = nil
    for k, v in ipairs(allSkillCfg) do
        if v.cfgId == cfgId and v.level == level then
            skillCfg = v
        end
    end
    return skillCfg
end

function WarShip:stopLessTick()
    if self.lessTickTimer then
        gg.timer:stopTimer(self.lessTickTimer)
        self.lessTickTimer = nil
    end
end

return WarShip