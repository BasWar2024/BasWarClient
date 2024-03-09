

PnlDrawSet = class("PnlDrawSet", ggclass.UIBase)

function PnlDrawSet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlDrawSet:onAwake()
    self.view = ggclass.PnlDrawSetView.new(self.transform)
end

-- self.args = {item = }
function PnlDrawSet:onShow()
    local view = self.view
    self:bindEvent()
    local itemCfg = cfg.item[self.args.item.cfgId]
    self.minHour = math.ceil(itemCfg.minComposeTime / 60 / 60)
    self.maxHour = math.floor(itemCfg.maxComposeTime / 60 / 60)
    view.slider.minValue = self.minHour
    view.slider.maxValue = self.maxHour
    self.view.slider.value = 0

    -- self.sliderInterval = 1 / (self.maxHour - self.minHour)
    -- self.sliderValue = 0
    -- self.view.slider.value = self.sliderValue
end

function PnlDrawSet:onHide()
    self:releaseEvent()
end

function PnlDrawSet:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)

    self:setOnClick(view.btnClose, function ()
        self:close()
    end)
    view.slider.onValueChanged:AddListener(gg.bind(self.onSliderChange, self))
end

function PnlDrawSet:onSliderChange(value)
    -- print(value)
    -- self:setSliderValue(value)
    local val = math.floor(value)
    self.view.txtTimeSet.text = string.format("%.2f%%\n%dh", (val - self.minHour) / (self.maxHour - self.minHour) * 100, val)
end

function PnlDrawSet:setSliderValue(value)
    -- if math.abs(value - self.sliderValue) < self.sliderInterval / 2 then
    --     return
    -- end
    -- if value > self.sliderValue then
    --     self.sliderValue = self.sliderValue + self.sliderInterval
    -- elseif value < self.sliderValue then
    --     self.sliderValue = self.sliderValue - self.sliderInterval
    -- end
    -- self.sliderValue = math.max(self.sliderValue, 0)
    -- self.sliderValue = math.min(self.sliderValue, 1)
    -- self.view.txtTimeSet.text = math.ceil(self.minHour + (self.maxHour - self.minHour) * self.sliderValue)
    -- self.view.slider.value = self.sliderValue
end

function PnlDrawSet:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnYes)
    CS.UIEventHandler.Clear(view.btnNo)
    view.slider.onValueChanged:RemoveAllListeners()
end

function PnlDrawSet:onDestroy()
    local view = self.view
end

function PnlDrawSet:onBtnYes()
    local curCfg = cfg.item[self.args.item.cfgId]
    local hour = math.ceil(curCfg.minComposeTime / 60 / 60)
    ItemData.C2S_Player_ItemCompose(self.args.item.id, math.ceil(self.view.slider.value))
    self:close()
end

function PnlDrawSet:onBtnNo()
    self:close()
end

return PnlDrawSet