

PnlExchange = class("PnlExchange", ggclass.UIBase)

function PnlExchange:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.rate = 0
    self.events = {"onRefreshResTxt", }
end

function PnlExchange:onAwake()
    self.view = ggclass.PnlExchangeView.new(self.transform)
end

--args = ResData.S2C_Player_Exchange_Rate
function PnlExchange:onShow()
    self:bindEvent()
    self:refreshRes()
    self:onBtnRes(102)
end

function PnlExchange:onRefreshResTxt()
    self:refreshRes()
end

function PnlExchange:refreshRes()
    local view = self.view
    view.slider.minValue = 0
    view.slider.maxValue = ResData.getMit()
    self.view.slider.value = view.slider.minValue

    -- for key, value in pairs(view.resMap) do
    --     value.txt.text = ResData.getRes(key)
    -- end
    -- view.txtMit.text = ResData.getMit()
end

function PnlExchange:onHide()
    self:releaseEvent()
end

function PnlExchange:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnSub):SetOnClick(function()
        self:onBtnSub()
    end)
    CS.UIEventHandler.Get(view.btnAdd):SetOnClick(function()
        self:onBtnAdd()
    end)
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)

    for key, value in pairs(view.resMap) do
        self:setOnClick(value.btn, gg.bind(self.onBtnRes, self, key))
    end

    view.slider.onValueChanged:AddListener(gg.bind(self.onSliderChange, self))
end

function PnlExchange:onSliderChange(value)
    local val = math.floor(value)
    self.view.txtCost.text = val
    local getCount = math.floor(val * self.rate)
    self.view.txtGet.text = getCount

    if self.choosingResId then
        self.isFull = gg.buildingManager.resMax[constant.RES_2_CFG_KEY[self.choosingResId].storeKey] <
            ResData.getRes(self.choosingResId) + getCount
        self.view.txtFull.transform:SetActiveEx(self.isFull)
    end
end

function PnlExchange:onBtnRes(resId)
    self.choosingResId = resId

    local view = self.view
    self.view.slider.value = view.slider.minValue
    self:onSliderChange(self.view.slider.value)

    view.txtRate.text = self.args.mit .. ":" .. self.args[constant.RES_2_CFG_KEY[resId].exchangeKey]
    self.rate = self.args[constant.RES_2_CFG_KEY[resId].exchangeKey] / self.args.mit

    gg.setSpriteAsync(view.imgAfter, constant.RES_2_CFG_KEY[resId].icon)
    for key, value in pairs(view.resMap) do
        if key == resId then
            gg.setSpriteAsync(value.img, "button_select_green")
        else
            gg.setSpriteAsync(value.img, "button_select_gray")
        end
    end
end

function PnlExchange:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSub)
    CS.UIEventHandler.Clear(view.btnAdd)
    CS.UIEventHandler.Clear(view.btnYes)
    view.slider.onValueChanged:RemoveAllListeners()
end

function PnlExchange:onDestroy()
    local view = self.view
end

function PnlExchange:onBtnSub()
    self.view.slider.value = self.view.slider.value - 1
end

function PnlExchange:onBtnAdd()
    self.view.slider.value = self.view.slider.value + 1
end

function PnlExchange:onBtnYes()
    -- if self.isFull then
    --     gg.uiManager:showTip("")
    --     return
    -- end

    if self.view.slider.value <= 0 then
        return
    end

    local view = self.view

    local callbackYes = function ()
        ResData.C2S_Player_Exchange_Res(math.ceil(self.view.slider.value) , self.choosingResId)
    end
    local txt = string.format("Are you sure use %s %s exchange %s %s",
        view.txtCost.text,
        constant.RES_2_CFG_KEY[constant.RES_MIT].exchangeKey,
        view.txtGet.text,
        constant.RES_2_CFG_KEY[self.choosingResId].exchangeKey)
    gg.uiManager:openWindow("PnlAlert", {callbackYes = callbackYes, txt = txt})
end

return PnlExchange