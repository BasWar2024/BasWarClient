

PnlWarShip = class("PnlWarShip", ggclass.UIBase)

PnlWarShip.VIEW_SKILL = 1
PnlWarShip.VIEW_UPGRADE = 2
PnlWarShip.VIEW_INFORMATION = 3

function PnlWarShip:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlWarShip:onAwake()
    self.view = ggclass.PnlWarShipView.new(self.transform)
    
    self:initBtnSkillTable()
end

function PnlWarShip:onShow()    
    self.view.upgradeBox.gameObject:SetActive(false)

    self:bindEvent()

    self:chooseWindowType()

    gg.event:dispatchEvent("onBgHighlighted", true)
end

--
function PnlWarShip:initBtnSkillTable()
    local view = self.view
    self.btnSkillTable = {}
    
    table.insert(self.btnSkillTable, {obj = view.btnSkill1, skillCfg = nil})
    table.insert(self.btnSkillTable, {obj = view.btnSkill2, skillCfg = nil})
    table.insert(self.btnSkillTable, {obj = view.btnSkill3, skillCfg = nil})
    table.insert(self.btnSkillTable, {obj = view.btnSkill4, skillCfg = nil})
    table.insert(self.btnSkillTable, {obj = view.btnSkill5, skillCfg = nil})
end

--
function PnlWarShip:getSkillCfg(cfgId, level)
    local allSkillCfg = cfg.get("etc.cfg.skill")
    local skillCfg = nil
    for k, v in ipairs(allSkillCfg) do
        if v.cfgId == cfgId and v.level == level then
            skillCfg = v
        end
    end
    return skillCfg
end

--
function PnlWarShip:chooseWindowType()
    local view = self.view
    local name = gg.warShip.warShipCfg.name
    local levle = gg.warShip.warShipData.level
    local life = gg.warShip.warShipData.life
    local curLife = gg.warShip.warShipData.curLife
    local durability = curLife.."/"..life
    local percent = curLife / life
    view.txtName.text = name
    view.txtLevel.text = levle
    view.txtDurability.text = durability
    view.scrollbarDurability.size = percent

    view.bgWarShip:SetActive(true)
    view.bgSkill:SetActive(false)

    if self.args == PnlWarShip.VIEW_SKILL then
        view.viewSkill:SetActive(true)
        view.viewUpgrade:SetActive(false)
        view.viewInformation:SetActive(false)
        self:setViewSkill()
    elseif self.args == PnlWarShip.VIEW_UPGRADE then
        view.viewSkill:SetActive(false)
        view.viewUpgrade:SetActive(true)
        view.viewInformation:SetActive(false)
        local warShipCfg = gg.warShip.warShipCfg
        self:setViewUpgrade(warShipCfg)
    elseif self.args == PnlWarShip.VIEW_INFORMATION then
        view.viewSkill:SetActive(false)
        view.viewUpgrade:SetActive(false)
        view.viewInformation:SetActive(true)
        self:setViewInforMation()      
    end
end

function PnlWarShip:setViewSkill()
    local warShipCfg = gg.warShip.warShipCfg
    local skillCfgId1 = warShipCfg.skill1
    local skillCfgId2 = warShipCfg.skill2
    local skillCfgId3 = warShipCfg.skill3
    local skillCfgId4 = warShipCfg.skill4
    local skillCfgId5 = warShipCfg.skill5

    if skillCfgId1 then
        local level = gg.warShip.warShipData.skillLevel1
        local skillCfg = self:getSkillCfg(skillCfgId1, level)

        self:setSkillWindow(1, level, skillCfg)
    else
        self.btnSkillTable[1].obj:SetActive(false)
    end
    if skillCfgId2 then
        local level = gg.warShip.warShipData.skillLevel2
        local skillCfg = self:getSkillCfg(skillCfgId2, level)
        self:setSkillWindow(2, level, skillCfg)
    else
        self.btnSkillTable[2].obj:SetActive(false)
    end
    if skillCfgId3 then
        local level = gg.warShip.warShipData.skillLevel3
        local skillCfg = self:getSkillCfg(skillCfgId3, level)
        self:setSkillWindow(3, level, skillCfg)
    else
        self.btnSkillTable[3].obj:SetActive(false)
    end
    if skillCfgId4 then
        local level = gg.warShip.warShipData.skillLevel4
        local skillCfg = self:getSkillCfg(skillCfgId4, level)
        self:setSkillWindow(4, level, skillCfg)
    else
        self.btnSkillTable[4].obj:SetActive(false)
    end
    if skillCfgId5 then
        local level = gg.warShip.warShipData.skillLevel5
        local skillCfg = self:getSkillCfg(skillCfgId5, level)
        self:setSkillWindow(5, level, skillCfg)
    else
        self.btnSkillTable[5].obj:SetActive(false)
    end
end 

function PnlWarShip:setSkillWindow(temp, level, skillCfg)
    local btnSkill = self.btnSkillTable[temp].obj
    btnSkill:SetActive(true)
    if not skillCfg then
        btnSkill.transform:Find("HaveSkill").gameObject:SetActive(false)
        btnSkill.transform:Find("IconQuestion").gameObject:SetActive(true)
        return
    end

    local icon = skillCfg.icon
    local iconLevel = {"Level1_icon", "Level2_icon", "Level3_icon", "Level4_icon", "Level5_icon", "Level6_icon"}
    local iconUpgrade = "Upgrade_icon"
    
    self.btnSkillTable[temp].skillCfg = skillCfg  
    btnSkill.transform:Find("HaveSkill").gameObject:SetActive(true)
    local iconLevelName = ""
    
    if level < gg.warShip.warShipData.level then      
        iconLevelName = iconUpgrade
    else
        iconLevelName = iconLevel[level]
    end
    ResMgr:LoadSpriteAsync(iconLevelName, function(sprite)
        btnSkill.transform:Find("HaveSkill/IconLevel"):GetComponent("Image").sprite = sprite
    end)  
end 

function PnlWarShip:setViewUpgrade(curCfg)
    local view = self.view
    view.commonUpgradeBox:setMessage(curCfg, gg.warShip.warShipData.lessTickEnd)
end

function PnlWarShip:setViewInforMation()
    local warShipCfg = gg.warShip.warShipCfg
    local desc = warShipCfg.desc
    self.view.txtInformation.text = desc
end 

function PnlWarShip:onHide()
    self:releaseEvent()

    gg.event:dispatchEvent("onBgHighlighted", false)
end

function PnlWarShip:bindEvent()
    local view = self.view
    
    for k, v in ipairs(self.btnSkillTable) do
        local temp = k
        CS.UIEventHandler.Get(v.obj):SetOnClick(function()
            self:onBtnSkill(temp)
        end)
        
    end
    CS.UIEventHandler.Get(view.btnSkillUpgrade):SetOnClick(function()
        self:onBtnSkillUpgrade()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    view.commonUpgradeBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))

    CS.UIEventHandler.Get(view.btnRecycle):SetOnClick(function()
        self:onBtnRecycle()
    end)
end

function PnlWarShip:releaseEvent()
    local view = self.view

    for k, v in ipairs(self.btnSkillTable) do
        CS.UIEventHandler.Clear(v.obj)
    end
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnRecycle)

end

function PnlWarShip:onDestroy()
    local view = self.view
    view.commonUpgradeBox:release()
end

function PnlWarShip:onBtnSkill(temp)
    self.view.upgradeBox.gameObject:SetActive(true)
    local pos = self.btnSkillTable[temp].obj.transform.localPosition
    self.view.upgradeBox.localPosition = pos
    self.skillIndex = temp
end

function PnlWarShip:onBtnSkillUpgrade()
    local skillCfg = self.btnSkillTable[self.skillIndex].skillCfg

    if not skillCfg then
        return
    end

    local cfgId = skillCfg.cfgId
    local level = skillCfg.level

    local callbackReturn = function()
        gg.uiManager:openWindow("PnlWarShip", PnlWarShip.VIEW_SKILL)
    end
    local callbackInstant = function()
        gg.warShip:instantUpgradeWarShipSkill(self.skillIndex)
    end
    local callbackUpgrade = function()
        gg.warShip:upgradeWarShipSkill(self.skillIndex)
    end

    local args = {callbackReturn = callbackReturn, callbackInstant = callbackInstant,
        callbackUpgrade = callbackUpgrade, cfg = HeroUtil:getSkillMap()[cfgId][level],
        nextLevelCfg = HeroUtil:getSkillMap()[cfgId][level + 1],
        lessTickEnd = gg.warShip.warShipData.skillUpLessTickEnd
        }

    gg.uiManager:openWindow("PnlUpgrade", args)
    self:close()
end

function PnlWarShip:onBtnInstant()
    gg.warShip:instantUpgradeWarShip()
    self:close()
end

function PnlWarShip:onBtnUpgrade()
    gg.warShip:upgradeWarShip()
    self:close()
end

function PnlWarShip:onBtnClose()
    self:close()
end

function PnlWarShip:onBtnRecycle()
    gg.warShip:recycleWarShip()
    --self:close()
end

return PnlWarShip