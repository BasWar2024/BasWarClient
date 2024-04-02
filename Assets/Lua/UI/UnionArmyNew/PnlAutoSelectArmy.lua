

PnlAutoSelectArmy = class("PnlAutoSelectArmy", ggclass.UIBase)

function PnlAutoSelectArmy:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlAutoSelectArmy:onAwake()
    self.view = ggclass.PnlAutoSelectArmyView.new(self.pnlTransform)

    self.view.slider.onValueChanged:AddListener(gg.bind(self.onSliderValueChanged, self))

    self.commonAddCountBox = CommonAddCountBox.new(self.view.commonAddCountBox)
    self.commonAddCountBox:setChangeCallback(gg.bind(self.onCountChange, self))
end

function PnlAutoSelectArmy:onShow()
    self:bindEvent()

    self.minCount = 1
    self.maxCount = cfg.global.UnionArmyTeamsLimit.intValue

    self.view.slider.minValue = self.minCount
    self.view.slider.maxValue = self.maxCount

    self.view.txtAlert.text = string.format("You can from up to <color=#ffa312>%s</color> teams", self.maxCount)
end

function PnlAutoSelectArmy:onSliderValueChanged(val)
    self.count = math.floor(val)
    self:refreshShowCount()
end

function PnlAutoSelectArmy:onCountChange(count)
    self.count = self.count + count

    if self.count > self.maxCount then
        self.count = self.maxCount
    end

    if self.count < self.minCount then
        self.count = self.minCount
    end

    self.view.slider:SetValueWithoutNotify(self.count)
    
    self:refreshShowCount()
end

function PnlAutoSelectArmy:refreshShowCount()
    self.view.txtCount.text = self.count .. "/" .. self.maxCount

end

function PnlAutoSelectArmy:onHide()
    self:releaseEvent()

end

function PnlAutoSelectArmy:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
end

function PnlAutoSelectArmy:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnYes)
end

function PnlAutoSelectArmy:onDestroy()
    local view = self.view
    self.commonAddCountBox:release()
end

function PnlAutoSelectArmy:onBtnClose()
    self:close()
end

function PnlAutoSelectArmy:onBtnYes()
    -- UnionArmyUtil.autoSetArmy(self.count)
    UnionData.autoSelectArmy(self.count)
    self:close()
end

return PnlAutoSelectArmy