

PnlPromptMsg = class("PnlPromptMsg", ggclass.UIBase)

PnlPromptMsg.ctor = function(self, args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.tips
end

PnlPromptMsg.onAwake = function(self)
    self.view = ggclass.PnlPromptMsgView.new(self.transform)

end

PnlPromptMsg.onShow = function(self)

    self:refresh()
end

PnlPromptMsg.refresh = function(self)
    if (not self:isShow()) then
        return
    end

    self:removeTimer()
    self.closeTimer = gg.timer:addTimer(2, function ()
        self:close()
    end)
    self.view.txtTips.text = self.args
end


PnlPromptMsg.removeTimer = function(self)
    if (self.closeTimer) then
        gg.timer:stopTimer(self.closeTimer)
    end
end

PnlPromptMsg.onDestroy = function(self)
    local view = self.view

    self:removeTimer()
end

return PnlPromptMsg