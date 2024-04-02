PnlItemResolve = class("PnlItemResolve", ggclass.UIBase)

function PnlItemResolve:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlItemResolve:onAwake()
    self.view = ggclass.PnlItemResolveView.new(self.pnlTransform)

end

function PnlItemResolve:onShow()
    self:bindEvent()
    self:setInfo()
end

function PnlItemResolve:setInfo()
    self.resolveNum = 1
    self.view.txtNum.text = self.resolveNum
    local value = self.resolveNum / self.args.data.num
    self.view.Scrollbar.value = value
    local curCfg = cfg.getCfg("item", self.args.data.cfgId)

    local bgName = gg.getSpriteAtlasName("Item_Bg_Atlas", string.format("Item_Bg_%s", curCfg.quality))
    gg.setSpriteAsync(self.view.iconBg, bgName)

    local icon
    if curCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
        icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)
    elseif curCfg.itemType == constant.ITEM_ITEMTYPE_PROP then
        icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)
    elseif curCfg.itemType == constant.ITEM_ITEMTYPE_NFT_ITEM then
        icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)
    elseif curCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES then
        icon = gg.getSpriteAtlasName("Skill_A1_Atlas", curCfg.icon .. "_A1")
    end

    gg.setSpriteAsync(self.view.iconItem, icon)

    self.view.txtItemName.text = Utils.getText(curCfg.languageNameID)
    self.view.txtItemNum.text = Utils.getText("bag_Number") .. self.args.data.num

end

function PnlItemResolve:onHide()
    self:releaseEvent()

end

function PnlItemResolve:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnReduce):SetOnClick(function()
        self:onBtnReduce()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnIncrease):SetOnClick(function()
        self:onBtnIncrease()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnDetermine):SetOnClick(function()
        self:onBtnDetermine()
    end)

    self.view.Scrollbar.onValueChanged:AddListener(gg.bind(self.onChangeScrollbar, self))
end

function PnlItemResolve:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnReduce)
    CS.UIEventHandler.Clear(view.btnIncrease)
    CS.UIEventHandler.Clear(view.btnDetermine)
    self.view.Scrollbar.onValueChanged:RemoveAllListeners()
end

function PnlItemResolve:onDestroy()
    local view = self.view

end

function PnlItemResolve:onChangeScrollbar()
    if not self.afterBtn then
        local value = self.view.Scrollbar.value
        local num = self.args.data.num * value
        self.resolveNum = math.floor(num)
        self:calcResolveNum(0)
    end
    self.afterBtn = false
end

function PnlItemResolve:onBtnClose()
    self:close()
end

function PnlItemResolve:onBtnReduce()
    self:calcResolveNum(-1)
    self:setScrollbar()
end

function PnlItemResolve:onBtnIncrease()
    self:calcResolveNum(1)
    self:setScrollbar()
end

function PnlItemResolve:calcResolveNum(temp)
    self.resolveNum = self.resolveNum + temp
    if self.resolveNum < 1 then
        self.resolveNum = 1
    end
    if self.resolveNum > self.args.data.num then
        self.resolveNum = self.args.data.num
    end
    self.view.txtNum.text = self.resolveNum
end

function PnlItemResolve:setScrollbar()
    local value = self.resolveNum / self.args.data.num
    self.view.Scrollbar.value = value
    self.afterBtn = true
end

function PnlItemResolve:onBtnDetermine()
    local id = self.args.data.id
    local count = self.resolveNum

    if self.args.type == 1 then
        ItemData.C2S_Player_UseItem(id, count)
    else
        ItemData.C2S_Player_ResolveItem(id, count)
    end

    self:close()

end

return PnlItemResolve
