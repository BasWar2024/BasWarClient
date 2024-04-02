

PnlServiceSmall = class("PnlServiceSmall", ggclass.UIBase)

function PnlServiceSmall:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlServiceSmall:onAwake()
    self.view = ggclass.PnlServiceSmallView.new(self.pnlTransform)

end

function PnlServiceSmall:onShow()
    self:bindEvent()

end

function PnlServiceSmall:onHide()
    self:releaseEvent()

end

function PnlServiceSmall:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlServiceSmall:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlServiceSmall:onDestroy()
    local view = self.view

end

function PnlServiceSmall:onBtnClose()
    self:close()
end

return PnlServiceSmall