

PnlUpgrade = class("PnlUpgrade", ggclass.UIBase)


-- args = {callbackReturn =, callbackInstant =, callbackUpgrade =, cfg = , 
    -- nextLevelCfg = , attrCfg =, lessTickEnd = , type = }
function PnlUpgrade:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.attrItemList = {}
    self.events = { }
end

function PnlUpgrade:onAwake()
    self.view = ggclass.PnlUpgradeView.new(self.transform)

    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem2", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))
end

function PnlUpgrade:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem2:getItem(obj, self.attrItemList)
    item:setData(index, self.attrCfg, self.args.cfg, self.args.nextLevelCfg)
    -- item:setAddAttrActive(self.SHOWING_TYPE == self.SHOWING_TYPE.upgrade)
end

function PnlUpgrade:onShow()
    self:bindEvent()
    self:refreshView()
end

PnlUpgrade.DEFAULT_ATTR_CFG = {
    cfg.attribute[1],
    cfg.attribute[22],
    cfg.attribute[23],
    cfg.attribute[24],
    cfg.attribute[25],
    cfg.attribute[26],
}

function PnlUpgrade:refreshAttr()
    self.attrCfg = {}
    local index2Attr = self.args.attrCfg or PnlUpgrade.DEFAULT_ATTR_CFG

    for index, value in ipairs(index2Attr) do
        local attr = self:getAttr(value, self.args.cfg)
        local upAttr = self:getAttr(value, self.args.nextLevelCfg)
        if attr and upAttr and attr ~= upAttr then
            table.insert(self.attrCfg, value)
        end
    end
    self.attrScrollView:setItemCount(#self.attrCfg)
end

function PnlUpgrade:getAttr(attrCfg, config)
    if not config or not attrCfg then
        return
    end

    local attr = nil
    if attrCfg.isProperty == 1 and config.property then
        attr = config.property[attrCfg.cfgKey]
    else
        attr = config[attrCfg.cfgKey]
    end

    return attr
end

function PnlUpgrade:refreshView()
    self:refreshCost()
    self:refreshAttr()
    self.view.txtName.text = self.args.cfg.name
    self.view.txtLevel.text = self.args.cfg.level
    -- gg.setSpriteAsync(self.view.iconSkill, self.args.cfg.icon)
    gg.setSpriteAsync(self.view.iconLevel, "Level_icon_" .. self.args.cfg.level)
end

function PnlUpgrade:refreshCost()
    local view = self.view
    view.commonUpgradeBox:setMessage(self.args.cfg, self.args.lessTickEnd)
end

function PnlUpgrade:onHide()
    self:releaseEvent()
end

function PnlUpgrade:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)

    view.commonUpgradeBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
end

function PnlUpgrade:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnReturn)
end

function PnlUpgrade:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    view.commonUpgradeBox:release()
end

function PnlUpgrade:onBtnReturn()
    if self.args.callbackReturn then
        self.args.callbackReturn()
    end
    self:close()
end

function PnlUpgrade:onBtnUpgrade()
    if self.args.callbackUpgrade then
        self.args.callbackUpgrade()
    end
    self:close()
end

function PnlUpgrade:onBtnInstant()
    if self.args.callbackInstant then
        self.args.callbackInstant()
    end
    self:close()
end

return PnlUpgrade