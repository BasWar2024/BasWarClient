

PnlPledgeSet = class("PnlPledgeSet", ggclass.UIBase)

function PnlPledgeSet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlPledgeSet:onAwake()
    self.view = ggclass.PnlPledgeSetView.new(self.transform)

end

--args = {pledgeId =  }
function PnlPledgeSet:onShow()
    self:bindEvent()
    local view = self.view
    self.pledgeCfg = cfg.pledge[self.args.pledgeId]
    self.expressionFunc = load(self.pledgeCfg.expression)()
    self.pledgeData = BuildData.pledgeData[self.pledgeCfg.cfgId]

    self.pledgeingMit = 0
    if self.pledgeData then
        self.pledgeingMit = self.pledgeData.mit
    end
    view.slider.minValue = 0
    view.slider.maxValue = self.pledgeCfg.maxMit - self.pledgeingMit
    self.view.slider.value = 0

    view.txtBefore.text = self:getSetBeforeStr(self.pledgeingMit)
    view.txtAfter.text = self:getSetBeforeStr(self.pledgeingMit)
end

function PnlPledgeSet:getSetBeforeStr(mit)
    return self.expressionFunc(mit) * 100 .. "%"
end

function PnlPledgeSet:onSliderChange(value)
    local val = math.floor(value)
    self.view.txtSet.text = val
    self.view.txtAfter.text = self:getSetBeforeStr(val + self.pledgeingMit)
end

function PnlPledgeSet:onHide()
    self:releaseEvent()
end

function PnlPledgeSet:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)
    view.slider.onValueChanged:AddListener(gg.bind(self.onSliderChange, self))
end

function PnlPledgeSet:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnYes)
    CS.UIEventHandler.Clear(view.btnNo)
    view.slider.onValueChanged:RemoveAllListeners()
end

function PnlPledgeSet:onDestroy()
    local view = self.view

end

function PnlPledgeSet:onBtnYes()
    BuildData.C2S_Player_Pledge(self.pledgeCfg.cfgId, math.floor(self.view.slider.value))
    self:close()
end

function PnlPledgeSet:onBtnNo()
    self:close()
end

return PnlPledgeSet