

PnlForceUpgrade = class("PnlForceUpgrade", ggclass.UIBase)

function PnlForceUpgrade:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSoliderForgeChange", "onForgeResultAnimateFinish" }
    self.attrItemList = {}
end

function PnlForceUpgrade:onAwake()
    self.view = ggclass.PnlForceUpgradeView.new(self.transform)
    self.view.commonAddCountBox:setChangeCallback(gg.bind(self.onAddCount, self))
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem")
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))
end

PnlForceUpgrade.TYPE_SOLIDER = constant.INSTITUE_TYPE_SOLDIER
PnlForceUpgrade.TYPE_MINE = constant.INSTITUE_TYPE_MINE

--args = {cfg, type, upgradeType ,  data}
function PnlForceUpgrade:onShow()
    self:bindEvent()
    local view = self.view
    self.upgradeType = self.args.upgradeType or constant.INSTITUE_UPGRADE_TYPE_LEVEL
    view.txtName.text = self.args.cfg.name
    self.cfg = self.args.cfg
    self.nextLevelCfg = nil
    view.txtLevel.text = self.args.cfg.level

    if self.upgradeType == constant.INSTITUE_UPGRADE_TYPE_LEVEL then
        self:refreshUpgrade()
    elseif self.upgradeType == constant.INSTITUE_UPGRADE_TYPE_FORGE then
        self:refreshForge()
    end
end

function PnlForceUpgrade:refreshUpgrade()
    local view = self.view
    self.nextQualitySoldierData = nil
    view.layoutForge:SetActiveEx(false)
    view.layoutUpgrade:SetActiveEx(true)
    view.commonUpgradeBox:setActive(false)

    if self.args.type == PnlForceUpgrade.TYPE_SOLIDER then
        view.imgEnoughtUpgrade.transform:SetActiveEx(SoliderUtil.checkIsEnoughtUpgrade(self.args.cfg.cfgId, self.args.cfg.level))
        self.nextLevelCfg = SoliderUtil.getSoliderCfgMap()[self.args.cfg.cfgId][self.args.cfg.level + 1]
        self.isLevelMax = self.nextLevelCfg == nil
        if self.isLevelMax then
            local quality = SoliderUtil.getSoldierQuality(self.cfg.cfgId)
            local nextQualityCfg = SoliderUtil.getSoliderStudyCfgMap()[self.cfg.studyId][quality + 1]

            if nextQualityCfg then
                if BuildData.soliderLevelData[nextQualityCfg[0].cfgId].level <= 0 then
                    view.commonUpgradeBox:setBtnText(2, "Up quality")
                    local nextQualitySoldierData = BuildData.soliderLevelData[nextQualityCfg[0].cfgId]
                    self.nextQualitySoldierData = nextQualitySoldierData
                    if nextQualitySoldierData then
                        view.commonUpgradeBox:setActive(true)
                        view.commonUpgradeBox:setMessage(nextQualityCfg[0], nextQualitySoldierData.lessTickEnd)
                    end
                end
            end
        else
            view.commonUpgradeBox:setActive(true)
            view.commonUpgradeBox:setMessage(self.args.cfg, self.args.data.lessTickEnd)
            view.commonUpgradeBox:setBtnText(2, "Upgrade")
        end

    elseif self.args.type == PnlForceUpgrade.TYPE_MINE then
        self.isLevelMax = false
        view.commonUpgradeBox:setBtnText(2, "Upgrade")
        view.imgEnoughtUpgrade.transform:SetActiveEx(MineUtil.checkIsEnoughtUpgrade(self.args.cfg.cfgId, self.args.cfg.level))
        self.nextLevelCfg = MineUtil.getMineCfgMap()[self.args.cfg.cfgId][self.args.cfg.level + 1]
    end

    self.attrScrollView:setItemCount(#PnlForceUpgrade.ATTR_MAP[self.args.type])
end

function PnlForceUpgrade:refreshForge()
    local view = self.view
    view.layoutForge:SetActiveEx(true)
    view.layoutUpgrade:SetActiveEx(false)
    local forgeData = BuildData.soliderForgeData[self.cfg.cfgId]

    -- forgeData = forgeData or {level = 0, cfgId = self.cfg.cfgId}
    if not forgeData then
        return
    end

    local level = forgeData.level
    local forgeCfg = SoliderUtil.getSoliderForgeCfgMap()[self.cfg.cfgId][level]
    self.forgeCfg = forgeCfg
    self.nextForgeCfg = SoliderUtil.getSoliderForgeCfgMap()[self.cfg.cfgId][level + 1]
    self.forgeAttrCfg = AttrUtil.getAttrList(forgeCfg.showAttr[1])
    for key, value in pairs(view.forgeCostMap) do
        value.TxtCost.text = forgeCfg[key]
    end

    view.txtForgeMitPer.text = forgeCfg.mitPerRatio
    view.inputForgeRaiot.text = forgeCfg.startRatio

    view.sliderForge.minValue = 0
    view.sliderForge.maxValue = 100
    view.sliderForge.value = forgeCfg.startRatio

    self:refreshForgeMistCost()
    self.attrScrollView:setItemCount(#self.forgeAttrCfg)
    view.imgEnoughtUpgrade.transform:SetActiveEx(SoliderUtil.checkIsEnoughtForge(self.cfg.cfgId))
end

function PnlForceUpgrade:onInputForgeRatio(text)
    self:refreshForgeMistCost()
end

function PnlForceUpgrade:refreshForgeMistCost()
    local view = self.view
    local choooseRatio = tonumber(self.view.inputForgeRaiot.text)
    if not choooseRatio then
        choooseRatio = 0
    end
    -- choooseRatio = 
    choooseRatio = math.min(self.forgeCfg.maxRatio, math.max(self.forgeCfg.startRatio, choooseRatio))
    view.txtForgeMitCost.text = (choooseRatio - self.forgeCfg.startRatio) * self.forgeCfg.mitPerRatio
end

function PnlForceUpgrade:onInputForgeRatioEnd(text)
    local ratio = tonumber(text)
    if not ratio then
        ratio = 0
        self.view.inputForgeRaiot.text = 0
    end

    if ratio > tonumber(self.forgeCfg.maxRatio) then
        self.view.inputForgeRaiot.text = self.forgeCfg.maxRatio
    elseif ratio < self.forgeCfg.startRatio then
        self.view.inputForgeRaiot.text = self.forgeCfg.startRatio
    end

    self.view.sliderForge.value = ratio

    self:refreshForgeMistCost()
end

function PnlForceUpgrade:onHide()
    self:releaseEvent()

    -- for key, value in pairs(self.attrItemList) do
    --     value:release()
    -- end
    self.attrItemList = {}
end

function PnlForceUpgrade:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnLevel):SetOnClick(function()
        self:onBtnLevel()
    end)
    self:setOnClick(view.btnForge, gg.bind(self.onBtnForge, self))

    view.commonUpgradeBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
    view.sliderForge.onValueChanged:AddListener(gg.bind(self.onSliderForgeChange, self))

    view.inputForgeRaiot.onValueChanged:AddListener(gg.bind(self.onInputForgeRatio, self))
    view.inputForgeRaiot.onEndEdit:AddListener(gg.bind(self.onInputForgeRatioEnd, self))
end

function PnlForceUpgrade:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnLevel)
    view.inputForgeRaiot.onValueChanged:RemoveAllListeners()
    view.inputForgeRaiot.onEndEdit:RemoveAllListeners()
    view.sliderForge.onValueChanged:RemoveAllListeners()
end

PnlForceUpgrade.ATTR_MAP = {
    [PnlForceUpgrade.TYPE_SOLIDER] = {
        cfg.attribute.maxHp,
        cfg.attribute.atk,
        cfg.attribute.trainNeedStarCoin,
    },
    [PnlForceUpgrade.TYPE_MINE] = {
        cfg.attribute.maxHp,
        cfg.attribute.atk,
    },
}

function PnlForceUpgrade:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    if self.upgradeType == constant.INSTITUE_UPGRADE_TYPE_LEVEL then
        item:setData(index, PnlForceUpgrade.ATTR_MAP[self.args.type], self.args.cfg, self.nextLevelCfg)
    elseif self.upgradeType == constant.INSTITUE_UPGRADE_TYPE_FORGE then
        -- item:setData(index, self.forgeAttrCfg, self.args.cfg, self.forgeCfg)
        local attrCfg = self.forgeAttrCfg[index]

        if self.nextForgeCfg then
            item:setInfo(attrCfg.icon, attrCfg.name, self.cfg[attrCfg.cfgKey], "+" .. self.nextForgeCfg[attrCfg.cfgKey])
        else
            item:setInfo(attrCfg.icon, attrCfg.name, self.cfg[attrCfg.cfgKey], "")
        end
    end
end

function PnlForceUpgrade:onDestroy()
    local view = self.view
    view.commonUpgradeBox:release()
    view.commonAddCountBox:release()
    self.attrScrollView:release()
end

function PnlForceUpgrade:onBtnClose()
    self:close()
end

function PnlForceUpgrade:onBtnLevel()

end

function PnlForceUpgrade:onBtnInstant()
    if self.args.type == PnlForceUpgrade.TYPE_SOLIDER then
        if self.isLevelMax then
            if self.nextQualitySoldierData then
                BuildData.C2S_Player_SoliderQualityUpgrade(self.args.cfg.cfgId, 1)
            end
        else
            BuildData.C2S_Player_SoliderLevelUp(self.args.cfg.cfgId, 1)
        end
    elseif self.args.type == PnlForceUpgrade.TYPE_MINE then
        BuildData.C2S_Player_MineLevelUp(self.args.cfg.cfgId, 1)
    end
    self:close()
end

function PnlForceUpgrade:onBtnUpgrade()
    if self.args.type == PnlForceUpgrade.TYPE_SOLIDER then
        if self.isLevelMax then
            BuildData.C2S_Player_SoliderQualityUpgrade(self.args.cfg.cfgId, 0)
        else
            BuildData.C2S_Player_SoliderLevelUp(self.args.cfg.cfgId, 0)
        end

    elseif self.args.type == PnlForceUpgrade.TYPE_MINE then
        BuildData.C2S_Player_MineLevelUp(self.args.cfg.cfgId, 0)
    end
    self:close()
end

function PnlForceUpgrade:onBtnForge()
    BuildData.C2S_Player_SoliderForge(self.cfg.cfgId, tonumber(self.view.inputForgeRaiot.text) - self.forgeCfg.startRatio)
end

function PnlForceUpgrade:onSliderForgeChange(value)
    -- self.view.txtForgeRaiot.text = math.ceil(value) .. "%"

    if value < self.forgeCfg.startRatio then
        self.view.sliderForge.value = self.forgeCfg.startRatio
        return
    elseif value > self.forgeCfg.maxRatio then
        self.view.sliderForge.value = self.forgeCfg.maxRatio
        return
    end

    self.view.inputForgeRaiot.text = math.ceil(value)
end

function PnlForceUpgrade:onAddCount(value)
    self.view.sliderForge.value = self.view.sliderForge.value + value
end

function PnlForceUpgrade:onSoliderForgeChange(event, result)
    if result == nil and self.args.upgradeType == constant.INSTITUE_UPGRADE_TYPE_FORGE then
        self:refreshForge()
    end

    gg.uiManager:openWindow("PnlForgeResult", {result = result})
end

function PnlForceUpgrade:onForgeResultAnimateFinish(event, result)
    if result and self.args.upgradeType == constant.INSTITUE_UPGRADE_TYPE_FORGE then
        self:refreshForge()
    end
end

return PnlForceUpgrade
