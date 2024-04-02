

PnlPledge = class("PnlPledge", ggclass.UIBase)

function PnlPledge:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.information
    self.events = { }
end

function PnlPledge:onAwake()
    self.view = ggclass.PnlPledgeView.new(self.pnlTransform)
    self.pledgeBox = PledgeBox.new(self.view.pledgeBox)
end

function PnlPledge:onShow()
    self:bindEvent()

    self.pledgeBox:open()
end

function PnlPledge:onHide()
    self:releaseEvent()
    self.pledgeBox:close()
end

function PnlPledge:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlPledge:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlPledge:onDestroy()
    self.pledgeBox:release()
end

function PnlPledge:onBtnClose()
    self:close()
end

return PnlPledge