

PnlLoading = class("PnlLoading", ggclass.UIBase)

LOAD_PERCENT = 0

function PnlLoading:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.popup
    self.events = { }
end

function PnlLoading:onAwake()
    self.view = ggclass.PnlLoadingView.new(self.transform)

end

function PnlLoading:onShow()
    self:removeTimer()
    LOAD_PERCENT = 0
    self.curPercent = 0
    self.updateTimer = gg.timer:startLoopTimer(0, 0.05, -1, function ()
        self:update()
    end)
end

function PnlLoading:onHide()
    self:removeTimer()
    LOAD_PERCENT = 0
    self.curPercent = 0
end

function PnlLoading:update()
    self.curPercent = self.curPercent + math.random(1, 5)
    if self.curPercent > LOAD_PERCENT then
        self.curPercent = LOAD_PERCENT
    end
    self.view.sliderProgress.value = self.curPercent / 100
    self.view.txtProgress.text =string.format( "%0.2f", 1 * self.curPercent) .."%"
    if self.curPercent >= 100 then
        self:close()      
    end
end

function PnlLoading:removeTimer()
    if self.updateTimer then
        gg.timer:stopTimer(self.updateTimer)
    end
    self.updateTimer = nil
end

function PnlLoading:onDestroy()
    self:removeTimer()
end

return PnlLoading