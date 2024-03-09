

PnlForceUpgrade = class("PnlForceUpgrade", ggclass.UIBase)

function PnlForceUpgrade:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
    self.attrItemList = {}
end

function PnlForceUpgrade:onAwake()
    self.view = ggclass.PnlForceUpgradeView.new(self.transform)
end

PnlForceUpgrade.TYPE_SOLIDER = 1
PnlForceUpgrade.TYPE_MINE = 2

--args = {cfg, type, data}
function PnlForceUpgrade:onShow()
    self:bindEvent()
    local view = self.view
    view.txtName.text = self.args.cfg.name

    self.nextLevelCfg = nil
    if self.args.type == PnlForceUpgrade.TYPE_SOLIDER then
        view.imgEnoughtUpgrade.transform:SetActiveEx(SoliderUtil:checkIsEnoughtUpgrade(self.args.cfg.cfgId, self.args.cfg.level))
        self.nextLevelCfg = SoliderUtil:getSoliderCfgMap()[self.args.cfg.cfgId][self.args.cfg.level + 1]
    elseif self.args.type == PnlForceUpgrade.TYPE_MINE then
        view.imgEnoughtUpgrade.transform:SetActiveEx(MineUtil:checkIsEnoughtUpgrade(self.args.cfg.cfgId, self.args.cfg.level))
        self.nextLevelCfg = MineUtil:getMineCfgMap()[self.args.cfg.cfgId][self.args.cfg.level + 1]
    else
        view.imgEnoughtUpgrade.transform:SetActiveEx(false)
    end

    self.attrScrollView:setItemCount(#PnlForceUpgrade.ATTR_MAP[self.args.type])
    view.commonUpgradeBox:setMessage(self.args.cfg, self.args.data.lessTickEnd)
    view.txtLevel.text = self.args.cfg.level
end

function PnlForceUpgrade:onHide()
    self:releaseEvent()

    for key, value in pairs(self.attrItemList) do
        value:release()
    end
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

    view.commonUpgradeBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))

    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem")
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))
end

PnlForceUpgrade.ATTR_MAP = {
    [PnlForceUpgrade.TYPE_SOLIDER] = {
        cfg.attribute[1],
        {isProperty = 0, cfgKey = "trainNeedStarCoin", name = "Training costs", icon = "Icon_HeroHud_2"},
        cfg.attribute[2],
    },
    [PnlForceUpgrade.TYPE_MINE] = {
        cfg.attribute[1],
        cfg.attribute[2],
    },
}

function PnlForceUpgrade:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, PnlForceUpgrade.ATTR_MAP[self.args.type], self.args.cfg, self.nextLevelCfg)
end

function PnlForceUpgrade:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnLevel)
end

function PnlForceUpgrade:onDestroy()
    local view = self.view
    view.commonUpgradeBox:release()
end

function PnlForceUpgrade:onBtnClose()
    self:close()
end

function PnlForceUpgrade:onBtnLevel()

end

function PnlForceUpgrade:onBtnInstant()
    if self.args.type == PnlForceUpgrade.TYPE_SOLIDER then
        if self.args.data.lessTickEnd - os.time() < 0 then
            BuildData.C2S_Player_SoliderLevelUp(self.args.cfg.cfgId, 1)
        else
            BuildData.C2S_Player_SpeedUp_SoliderLevelUp(self.args.cfg.cfgId)
        end
        
    elseif self.args.type == PnlForceUpgrade.TYPE_MINE then
        if self.args.data.lessTickEnd - os.time() < 0 then
            BuildData.C2S_Player_MineLevelUp(self.args.cfg.cfgId, 1)
        else
            BuildData.C2S_Player_SpeedUp_MineLevelUp(self.args.cfg.cfgId)
        end
    end
    self:close()
end

function PnlForceUpgrade:onBtnUpgrade()
    if self.args.type == PnlForceUpgrade.TYPE_SOLIDER then
        BuildData.C2S_Player_SoliderLevelUp(self.args.cfg.cfgId, 0)
    elseif self.args.type == PnlForceUpgrade.TYPE_MINE then
        BuildData.C2S_Player_MineLevelUp(self.args.cfg.cfgId, 0)
    end
    self:close()
end

return PnlForceUpgrade