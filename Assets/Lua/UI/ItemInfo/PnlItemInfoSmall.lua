

PnlItemInfoSmall = class("PnlItemInfoSmall", ggclass.UIBase)

PnlItemInfoSmall.closeType = ggclass.UIBase.CLOSE_TYPE_BG

function PnlItemInfoSmall:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlItemInfoSmall:onAwake()
    self.view = ggclass.PnlItemInfoSmallView.new(self.pnlTransform)

    self.commonNormalItem = CommonNormalItem.new(self.view.commonNormalItem)
end

-- args = {itemCfgId = , count = ,}
function PnlItemInfoSmall:onShow()
    self:bindEvent()

    local itemCfg = cfg.item[self.args.itemCfgId]

    self.commonNormalItem:setQuality(itemCfg.quality)
    self.commonNormalItem:setIcon(ItemUtil.getItemIcon(self.args.itemCfgId))

    local count = self.args.count or 1
    self.view.txtCount.text = "Number:" .. count

    
    self.view.txtDesc.text = Utils.getText(itemCfg.languageDescID)
    self.view.txtTitle.text = Utils.getText(itemCfg.languageNameID)
end

function PnlItemInfoSmall:onHide()
    self:releaseEvent()

end

function PnlItemInfoSmall:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlItemInfoSmall:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlItemInfoSmall:onDestroy()
    local view = self.view
    self.commonNormalItem:release()
end

function PnlItemInfoSmall:onBtnClose()
    self:close()
end

return PnlItemInfoSmall