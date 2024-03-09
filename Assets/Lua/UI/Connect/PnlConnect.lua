

PnlConnect = class("PnlConnect", ggclass.UIBase)

function PnlConnect:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlConnect:onAwake()
    self.view = ggclass.PnlConnectView.new(self.transform)
end

function PnlConnect:onShow()
    self:bindEvent()
end

function PnlConnect:onHide()
    self:releaseEvent()
end

function PnlConnect:bindEvent()
    local view = self.view

end

function PnlConnect:releaseEvent()
    local view = self.view

end

function PnlConnect:onDestroy()
    local view = self.view
    
end

return PnlConnect