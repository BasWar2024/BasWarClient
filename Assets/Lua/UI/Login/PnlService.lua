

PnlService = class("PnlService", ggclass.UIBase)

function PnlService:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlService:onAwake()
    self.view = ggclass.PnlServiceView.new(self.pnlTransform)

end

-- self.args = {hideViewName}
function PnlService:onShow()
    self:bindEvent()

    self.hideWindow = self:getHideWindow()
    if self.hideWindow then
        self.hideWindow.transform:SetActiveEx(false)
    end

end

function PnlService:getHideWindow()
    if self.args and self.args.hideViewName then
        return gg.uiManager:getWindow(self.args.hideViewName)
    end
end

function PnlService:onHide()
    self:releaseEvent()

    if self.hideWindow then
        self.hideWindow.transform:SetActiveEx(true)
    end
end

function PnlService:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlService:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlService:onDestroy()
    local view = self.view

end

function PnlService:onBtnClose()
    self:close()
end

return PnlService