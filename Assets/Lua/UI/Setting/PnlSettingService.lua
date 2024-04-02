

PnlSettingService = class("PnlSettingService", ggclass.UIBase)

function PnlSettingService:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlSettingService:onAwake()
    self.view = ggclass.PnlSettingServiceView.new(self.pnlTransform)

end

function PnlSettingService:onShow()
    self:bindEvent()

end

function PnlSettingService:onHide()
    self:releaseEvent()

end

function PnlSettingService:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlSettingService:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlSettingService:onDestroy()
    local view = self.view

end

function PnlSettingService:onBtnClose()
    self:close()
end

return PnlSettingService