

PnlBuyCount = class("PnlBuyCount", ggclass.UIBase)

function PnlBuyCount:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlBuyCount:onAwake()
    self.view = ggclass.PnlBuyCountView.new(self.pnlTransform)

    self.view.slider.onValueChanged:AddListener(gg.bind(self.onSliderValueChanged, self))

    self.commonAddCountBox = CommonAddCountBox.new(self.view.commonAddCountBox)
    self.commonAddCountBox:setChangeCallback(gg.bind(self.onCountChange, self))
end

-- args = {minCount, maxCount, startCount, resId, yesCallback, changeCallback, title, title2}
function PnlBuyCount:onShow()
    self:bindEvent()
    self.count = self.args.startCount
    self.view.txtBuyCount.text = string.format("<color=#FED71C>%s</color>/%s", self.count,  self.args.maxCount)
    self.view.txtCost.text = self.args.changeCallback(self.count) / 1000
    self.view.txtTitle.text = self.args.title
    self.view.txtTitle2.text = self.args.title2

    self.view.slider.value = 0

    self.view.slider.minValue = self.args.minCount
    self.view.slider.maxValue = self.args.maxCount

    if self.args.minCount == self.args.maxCount then
        self.commonAddCountBox:setActive(false)
        self.view.slider.transform:SetActiveEx(false)
    else
        self.commonAddCountBox:setActive(true)
        self.view.slider.transform:SetActiveEx(true)
    end

    gg.setSpriteAsync(self.view.iconCost, constant.RES_2_CFG_KEY[self.args.resId].icon)
end

function PnlBuyCount:onHide()
    self:releaseEvent()

end

function PnlBuyCount:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
    self:setOnClick(view.btnNo, gg.bind(self.onBtnNo, self))
end

function PnlBuyCount:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnYes)
end

function PnlBuyCount:onDestroy()
    local view = self.view
    self.commonAddCountBox:release()
end

function PnlBuyCount:onBtnYes()
    self.args.yesCallback(self.count)
    self:close()
end

function PnlBuyCount:onBtnNo()
    self:close()
end

function PnlBuyCount:onCountChange(count)
    self.count = self.count + count

    if self.count > self.args.maxCount then
        self.count = self.args.maxCount
    end

    if self.count < self.args.minCount then
        self.count = self.args.minCount
    end

    self.view.slider:SetValueWithoutNotify(self.count)
    
    self:refreshShowCount()
end

function PnlBuyCount:onSliderValueChanged(val)
    self.count = math.floor(val)
    self:refreshShowCount()
end

function PnlBuyCount:refreshShowCount()
    self.view.txtBuyCount.text = string.format("<color=#FED71C>%s</color>/%s", self.count,  self.args.maxCount)
    self.view.txtCost.text = Utils.getShowRes(self.args.changeCallback(self.count))
end

return PnlBuyCount