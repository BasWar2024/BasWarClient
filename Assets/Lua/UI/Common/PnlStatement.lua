

PnlStatement = class("PnlStatement", ggclass.UIBase)

function PnlStatement:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.tips
    self.events = { }
end

function PnlStatement:onAwake()
    self.view = ggclass.PnlStatementView.new(self.transform)

end

function PnlStatement:onShow()
    self:bindEvent()

end

function PnlStatement:onHide()
    self:releaseEvent()

end

function PnlStatement:bindEvent()
    local view = self.view

end

function PnlStatement:releaseEvent()
    local view = self.view


end

function PnlStatement:onDestroy()
    local view = self.view

end

return PnlStatement