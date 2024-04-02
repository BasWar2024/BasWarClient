

PnlDailyCheck = class("PnlDailyCheck", ggclass.UIBase)

function PnlDailyCheck:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlDailyCheck:onAwake()
    self.view = ggclass.PnlDailyCheckView.new(self.pnlTransform)

    self.activityDailyCheckInBox = ActivityDailyCheckInBox.new(self.view.activityDailyCheckInBox)
end

function PnlDailyCheck:onShow()
    self:bindEvent()
    self.activityDailyCheckInBox:open()
end

function PnlDailyCheck:onHide()
    self:releaseEvent()
    self.activityDailyCheckInBox:close()
end

function PnlDailyCheck:bindEvent()
    local view = self.view
end

function PnlDailyCheck:releaseEvent()
    local view = self.view
end

function PnlDailyCheck:onDestroy()
    local view = self.view

    if self.activityDailyCheckInBox then
        self.activityDailyCheckInBox:release()
        self.activityDailyCheckInBox = nil
    end
    
end

return PnlDailyCheck