
PnlQuickExchange = class("PnlQuickExchange", ggclass.UIBase)
PnlQuickExchange.layer = UILayer.information
function PnlQuickExchange:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.events = {"onExchangeRateChange" }
    self.resItemList = {}
    self.needBlurBG = true
end

function PnlQuickExchange:onAwake()
    self.view = ggclass.PnlQuickExchangeView.new(self.pnlTransform)
    self.commonUpgradePart = CommonUpgradePart.new(self.view.commonUpgradePart)
    self.commonUpgradePart:setSliderData(false)
    self.commonUpgradePart:setInstanceCostActive(false)
    self.commonUpgradePart:setClickCallback(gg.bind(self.onBtnExchange, self))
end
-- extraExchangeCost
-- args = {needResList = {{resId = , needCount =}, exchangeCallback = , exchangeInfo = {extraExchangeCost = ， text = }}
function PnlQuickExchange:onShow()
    self:bindEvent()

    ResData.C2S_Player_Exchange_Rate(ResData.TIP_TYPE_QUICK_EXCHANGE)
    self.view.root:SetActiveEx(false)
    -- self:refresh()
end

function PnlQuickExchange:onExchangeRateChange()
    self:refresh()
end

function PnlQuickExchange:refresh()
    local view = self.view
    self.view.root:SetActiveEx(true)

    local tesseractTotalCost = 0
    local hydTotalCost = 0

    self.exchangeResList = {}

    local needResList = self.args.needResList or {}
    for index, value in ipairs(view.resItemList) do
        local data = needResList[index]
        if data then
            value.gameObject:SetActiveEx(true)

            local resInfo = constant.RES_2_CFG_KEY[data.resId]
            gg.setSpriteAsync(value.icon, resInfo.icon)
            local exchangeRatio = ResData.exchangeData[resInfo.exchangeFrom][resInfo.exchangeKey]

            local fromCount = math.ceil(data.needCount / exchangeRatio)
            value.text.text = Utils.getShowRes(math.floor(fromCount * exchangeRatio))

            if resInfo.exchangeFrom == constant.RES_TESSERACT then
                tesseractTotalCost = tesseractTotalCost + fromCount
            elseif resInfo.exchangeFrom == constant.RES_CARBOXYL then
                hydTotalCost = hydTotalCost + fromCount
            end

            table.insert(self.exchangeResList, {to = data.resId, fromCount = fromCount, from = resInfo.exchangeFrom})
        else
            value.gameObject:SetActiveEx(false)
        end
    end

    local totalCost = tesseractTotalCost

    view.txtDesc.text = Utils.getText("universal_Ask_ExchangeRes")

    --"" "" ""
    if hydTotalCost <= 0 then
        if self.args.exchangeInfo then
            if self.args.exchangeInfo.extraExchangeCost then
                totalCost = totalCost + self.args.exchangeInfo.extraExchangeCost
            end
    
            if self.args.exchangeInfo.text then
                view.txtDesc.text = self.args.exchangeInfo.text
            end
        end
    end

    self.hydTotalCost = hydTotalCost
    self.tesseractTotalCost = tesseractTotalCost

    local btnData = {}

    if totalCost > 0 then
        local color
        if totalCost > ResData.getTesseract() then
            color = constant.COLOR_RED
        else
            color = constant.COLOR_WHITE
        end
        table.insert(btnData, {icon = constant.RES_2_CFG_KEY[constant.RES_TESSERACT].icon, cost = totalCost, color = color, resId = constant.RES_TESSERACT})
    end

    if hydTotalCost > 0 then
        local color
        if hydTotalCost > ResData.getCarboxyl() then
            color = constant.COLOR_RED
        else
            color = constant.COLOR_WHITE
        end
        table.insert(btnData, {icon = constant.RES_2_CFG_KEY[constant.RES_CARBOXYL].icon, cost = hydTotalCost, color = color, resId = constant.RES_CARBOXYL})
    end

    -- {{icon = "", cost = , color = , resId = }}

    self.commonUpgradePart:setBtnData(btnData)
end

function PnlQuickExchange:onHide()
    self:releaseEvent()
end

function PnlQuickExchange:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlQuickExchange:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlQuickExchange:onDestroy()
    local view = self.view
    self.commonUpgradePart:release()
end

function PnlQuickExchange:onBtnClose()
    self:close()
end

function PnlQuickExchange:onBtnExchange()
    if self.hydTotalCost > 0 then
        for key, value in pairs(self.exchangeResList) do
            ResData.C2S_Player_Exchange_Res(value.from, value.fromCount, value.to)
        end
        self:close()
        return
    end

    if self.args.exchangeCallback then
        self.args.exchangeCallback(self.tesseractTotalCost)
    else
        for key, value in pairs(self.exchangeResList) do
            ResData.C2S_Player_Exchange_Res(value.from, value.fromCount, value.to)
        end
    end
    self:close()
end

return PnlQuickExchange