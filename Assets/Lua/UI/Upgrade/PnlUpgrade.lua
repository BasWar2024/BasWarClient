PnlUpgrade = class("PnlUpgrade", ggclass.UIBase)

-- args = {callbackReturn =, callbackInstant =, callbackUpgrade =, exchangeInfoFunc, cfg = , 
-- nextLevelCfg = , attrCfg =, lessTickEnd = , type = }
function PnlUpgrade:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.attrItemList = {}
    self.events = {}
    self.needBlurBG = false
end

function PnlUpgrade:onAwake()
    self.view = ggclass.PnlUpgradeView.new(self.transform)

    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))
end

function PnlUpgrade:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    --item:setData(index, self.attrCfg, self.args.cfg, self.args.nextLevelCfg, CommonAttrItem.TYPE_ICON_UPGRADE)
    item:setData(index, self.attrCfg, self.args.cfg, self.args.nextLevelCfg, CommonAttrItem.TYPE_NORMAL)
    
    -- item:setAddAttrActive(self.SHOWING_TYPE == self.SHOWING_TYPE.upgrade)
end

-- local args = {
--     callbackReturn = nil,
--     callbackInstant = callbackInstant,
--     exchangeInfoFunc = gg.bind(self.exchangeInfoFunc, self),
--     callbackUpgrade = callbackUpgrade,
--     cfg = SkillUtil.getSkillCfgMap()[cfgId][level],
--     nextLevelCfg = SkillUtil.getSkillCfgMap()[cfgId][level + 1],
--     lessTickEnd = self.warshipData.skillUpLessTickEnd
-- }

function PnlUpgrade:onShow()
    self:bindEvent()
    self:refreshView()
end

PnlUpgrade.DEFAULT_ATTR_CFG = {cfg.attribute.maxHp, cfg.attribute.addAtk, cfg.attribute.addAtkSpeed,
                               cfg.attribute.addMoveSpeed, cfg.attribute.cure, cfg.attribute.lifeTime}

function PnlUpgrade:refreshAttr()
    self.attrCfg = {}
    local index2Attr = self.args.attrCfg or PnlUpgrade.DEFAULT_ATTR_CFG

    for index, value in ipairs(index2Attr) do
        local attr = AttrUtil.getAttrByCfg(value, self.args.cfg)
        local upAttr = AttrUtil.getAttrByCfg(value, self.args.nextLevelCfg)
        if attr and upAttr and attr ~= upAttr then
            table.insert(self.attrCfg, value)
        end
    end
    --print(#self.attrCfg)
    self.attrScrollView:setItemCount(#self.attrCfg)
end

function PnlUpgrade:refreshView()
    self:refreshCost()
    self:refreshAttr()
    self.view.txtName.text = Utils.getText(self.args.cfg.languageNameID)
    local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", self.args.cfg.icon .. "_A1")
    self.view.commonItemItem:setIcon(icon)
    self.view.commonItemItem:setLevel(self.args.cfg.level)

    self.view.txtDesc.text = Utils.getText(self.args.cfg.desc)

    local nextCfg = self.args.nextLevelCfg

    if nextCfg then
        self.view.levelMax:SetActiveEx(false)
        self.view.levelUpgrade:SetActiveEx(true)
        self.view.txtCurLevle.text = self.args.cfg.level
        self.view.txtNextLevel.text = self.args.nextLevelCfg.level
        self.view.commonUpgradeNewBox.obj:SetActive(true)
    else
        self.view.levelMax:SetActiveEx(true)
        self.view.levelUpgrade:SetActiveEx(false)
        self.view.txtMaxLevel.text = self.args.cfg.level
        self.view.commonUpgradeNewBox.obj:SetActive(false)
    end

end

function PnlUpgrade:refreshCost()
    local view = self.view
    view.commonUpgradeNewBox:setMessage(self.args.cfg, self.args.lessTickEnd)
end

function PnlUpgrade:onHide()
    self:releaseEvent()
end

function PnlUpgrade:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)

    view.commonUpgradeNewBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeNewBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
    view.commonUpgradeNewBox:setExchangeInfoFunc(gg.bind(self.exchangeInfoFunc, self))
end

function PnlUpgrade:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnReturn)
end

function PnlUpgrade:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    view.commonUpgradeNewBox:release()
    view.commonItemItem:release()
end

function PnlUpgrade:onBtnReturn()
    if self.args.callbackReturn then
        self.args.callbackReturn()
    end
    self:close()
end

function PnlUpgrade:onBtnUpgrade(isOnExchange)
    if self.args.callbackUpgrade then
        self.args.callbackUpgrade(isOnExchange)
    end
    self:close()
end

function PnlUpgrade:exchangeInfoFunc()
    if self.args.exchangeInfoFunc then
        return self.args.exchangeInfoFunc()
    end
end

function PnlUpgrade:onBtnInstant()
    if self.args.callbackInstant then
        self.args.callbackInstant()
    end
    self:close()
end

return PnlUpgrade
