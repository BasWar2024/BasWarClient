

PnlCardDesc = class("PnlCardDesc", ggclass.UIBase)

function PnlCardDesc:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlCardDesc:onAwake()
    self.view = ggclass.PnlCardDescView.new(self.pnlTransform)

end

-- args = {cfgId}
function PnlCardDesc:onShow()
    self:bindEvent()

    local cardCfg = cfg.card[self.args.cfgId]

    self.view.txtDesc.text = cardCfg.desc

    self.view.txtTitle.text = cardCfg.name
end

function PnlCardDesc:onHide()
    self:releaseEvent()

end

function PnlCardDesc:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlCardDesc:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlCardDesc:onDestroy()
    local view = self.view

end

function PnlCardDesc:onBtnClose()
    self:close()
end

return PnlCardDesc