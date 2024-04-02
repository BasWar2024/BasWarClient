PnlShop = class("PnlShop", ggclass.UIBase)
PnlShop.infomationType = ggclass.UIBase.INFOMATION_HIDE

function PnlShop:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onRefreshResTxt", "onExchangeRateChange", "onPaySettle", "onRefreshTessractBuy"}
end

function PnlShop:onAwake()

    self.view = ggclass.PnlShopView.new(self.pnlTransform)

    self.commonResBox2 = CommonResBox2.new(self.view.commonResBox2)

    self.viewOptionBtnBox = ViewOptionBtnBox.new(self.view.fullViewOptionBtnBox)

    self.commonAddCountBox = CommonAddCountBox.new(self.view.commonAddCountBox)
    self.commonAddCountBox:setChangeCallback(gg.bind(self.onCountChange, self))

    self.shopTessractItemList = {}
    self.tessractScrollView = UIScrollView.new(self.view.tessractScrollView, "ShopTessractItem",
        self.shopTessractItemList)
    self.tessractScrollView:setRenderHandler(gg.bind(self.onRenderShopTessractItem, self))
    self.moonCardBox = MoonCardBox.new(self.view.moonCardBox)

    self.buildQueueBox = BuildQueueBox.new(self.view.buildQueueBox)

    self.auditMoonCardBox = AuditMoonCardBox.new(self.view.auditMoonCardBox)

    self.viewInfo = {
        [PnlShop.TYPE_MONTH_CARD] = {
            layout = self.view.layoutMoonCard,
            func = gg.bind(self.refreshMoonCard, self),
            closeFunc = gg.bind(self.closeMoonCard, self)
        },

        [PnlShop.TYPE_TESSRACT_BUY] = {
            layout = self.view.layoutBuyTessract,
            func = gg.bind(self.refreshTessractBuy, self)
        },

        [PnlShop.TYPE_EXCHANGE_TESSRACT] = {
            layout = self.view.layoutExchange,
            func = gg.bind(self.refreshExchange, self, constant.RES_CARBOXYL)
        },

        [PnlShop.TYPE_EXCHANGE_RES] = {
            layout = self.view.layoutExchange,
            func = gg.bind(self.refreshExchange, self, constant.RES_TESSERACT)
        },

        [PnlShop.TYPE_BUILD_QUENE] = {
            layout = self.view.layoutBuildQueue,
            func = gg.bind(self.openBuildQuene, self),
            closeFunc = gg.bind(self.closeBuildQuene, self)
        },
        [PnlShop.TYPE_AUDIT_MONTH_CARD] = {
            layout = self.view.layoutAuditMoonCard,
            func = gg.bind(self.openAuditMoonCard, self),
            closeFunc = gg.bind(self.closeAuditMoonCard, self)
        },
    }
end

PnlShop.TYPE_MONTH_CARD = 1
PnlShop.TYPE_TESSRACT_BUY = 2
PnlShop.TYPE_EXCHANGE_TESSRACT = 3
PnlShop.TYPE_EXCHANGE_RES = 4
PnlShop.TYPE_BUILD_QUENE = 5
PnlShop.TYPE_AUDIT_MONTH_CARD = 6

function PnlShop:onShow()
    self:bindEvent()
    PlayerData.C2S_Player_PayChannelInfo()
    self.isFirstOpenLayoutExchange = true
    local type = 1
    if self.args then
        type = self.args.shopType or 1
    end

    self.viewOptionBtnBox:setBtnDataList({
    --     {
    --     nemeKey = "shop_Left_MonthCard",
    --     callback = gg.bind(self.refresh, self, PnlShop.TYPE_MONTH_CARD)
    -- }, 

    {
        nemeKey = "shop_Left_StarCoin",
        callback = gg.bind(self.refresh, self, PnlShop.TYPE_AUDIT_MONTH_CARD)
    },
    
    {
        nemeKey = "shop_Left_TessSupply",
        callback = gg.bind(self.refresh, self, PnlShop.TYPE_TESSRACT_BUY)
    }, {
        nemeKey = "shop_Left_TessExchange",
        callback = gg.bind(self.refresh, self, PnlShop.TYPE_EXCHANGE_TESSRACT)
    }, {
        nemeKey = "shop_Left_DailyExchange",
        callback = gg.bind(self.refresh, self, PnlShop.TYPE_EXCHANGE_RES)
    }, {
        nemeKey = "shop_Left_QueuePurchase",
        callback = gg.bind(self.refresh, self, PnlShop.TYPE_BUILD_QUENE)
    }}, type)

    self:refreshAudit()

    self.commonResBox2:open()
end

function PnlShop:refresh(showType)
    self.showType = showType

    for key, value in pairs(self.viewInfo) do
        local viewInfo = self.viewInfo[showType]
        value.layout:SetActiveEx(false)

        if key ~= showType then
            if viewInfo.closeFunc then
                viewInfo.closeFunc()
            end
        end
    end

    local showingViewInfo = self.viewInfo[showType]
    showingViewInfo.layout:SetActiveEx(true)
    showingViewInfo.func()

    -- self.viewInfo[showType].layout:SetActiveEx(true)

end

function PnlShop:refreshAudit()
    local view = self.view
    if IsAuditVersion() then

        self.viewOptionBtnBox:setBtnDataList(
            {
                -- {
                --     nemeKey = "shop_Left_MonthCard",
                --     callback = gg.bind(self.refresh, self, PnlShop.TYPE_MONTH_CARD)
                -- },
                {
                    nemeKey = "shop_Left_TessSupply",
                    callback = gg.bind(self.refresh, self, PnlShop.TYPE_TESSRACT_BUY)
                },
                {
                    nemeKey = "shop_Left_StarCoin",
                    callback = gg.bind(self.refresh, self, PnlShop.TYPE_AUDIT_MONTH_CARD)
                },
            }, 1)
    end
end

-- TYPE_MONTH_CARD
function PnlShop:refreshMoonCard()
    self.commonResBox2:showResList({constant.RES_GAS, constant.RES_TITANIUM, constant.RES_STARCOIN, constant.RES_ICE,
                                    constant.RES_TESSERACT})
    self.moonCardBox:open()
end

function PnlShop:closeMoonCard()
    self.moonCardBox:close()
end

function PnlShop:onRefreshTessractBuy()
    if self.showType == PnlShop.TYPE_TESSRACT_BUY then
        self:refreshTessractBuy()
    end
end

PnlShop.NAME_2_SORT_WEIGHT = {
    ["starPack_MonthCard"] = 1,
    ["res_Tesseract"] = 2,
}

-- TYPE_TESSRACT_BUY
function PnlShop:refreshTessractBuy()
    self.commonResBox2:showResList({constant.RES_TESSERACT})

    -- local platform = CS.Appconst.platform -- "local"
    self.tessractDataList = {}
    for key, value in pairs(cfg.product) do
        -- if value.platform == platform then
        --     table.insert(self.tessractDataList, value)
        -- end

        -- "gb.tesseract.9999"
        local isPassAuditVersion = not IsAuditVersion() or (value.productId ~= "gb.tesseract.99")

        if value.name == "res_Tesseract" and isPassAuditVersion then
            table.insert(self.tessractDataList, value)
        end

        -- if value.name == "starPack_MonthCard" and IsAuditVersion() then
        --     table.insert(self.tessractDataList, value)
        -- end
    end

    table.sort(self.tessractDataList, function(a, b)
        if PnlShop.NAME_2_SORT_WEIGHT[a.name] ~= PnlShop.NAME_2_SORT_WEIGHT[b.name] then
            return PnlShop.NAME_2_SORT_WEIGHT[a.name] < PnlShop.NAME_2_SORT_WEIGHT[b.name]
        end
        return a.value < b.value
    end)
    self.tessractScrollView:setItemCount(#self.tessractDataList)
end

function PnlShop:onRenderShopTessractItem(obj, index)
    local item = ShopTessractItem:getItem(obj, self.shopTessractItemList)
    item:setData(self.tessractDataList[index])
end

-- TYPE_EXCHANGE
function PnlShop:refreshExchange(exchangeFrom)
    ResData.C2S_Player_Exchange_Rate()

    if exchangeFrom == constant.RES_TESSERACT then
        self.view.layoutExchangeBtns:SetActiveEx(true)
        self.view.imgLine:SetActiveEx(true)
        -- self:onBtnRes(constant.RES_STARCOIN)
        self.targetRes = constant.RES_STARCOIN
        if self.isFirstOpenLayoutExchange then
            if self.args then
                self.targetRes = self.args.resId
            end
            self.isFirstOpenLayoutExchange = false
        end
        self.commonResBox2:showResList({constant.RES_TESSERACT, constant.RES_GAS, constant.RES_TITANIUM,
                                        constant.RES_ICE, constant.RES_STARCOIN})
    else
        self.view.layoutExchangeBtns:SetActiveEx(false)
        self.view.imgLine:SetActiveEx(false)
        -- self:onBtnRes(constant.RES_TESSERACT)
        self.targetRes = constant.RES_TESSERACT
        self.commonResBox2:showResList({constant.RES_TESSERACT, constant.RES_CARBOXYL})
    end

    self.view.layoutExchange:SetActiveEx(false)
end

function PnlShop:onCountChange(count)
    count = self.view.slider.value + count -- * 1000
    self.view.slider.value = count
end

function PnlShop:onInputGetEndEdit(text)
    local view = self.view

    local num = tonumber(text)
    if not num then
        num = 0
    end

    num = math.floor(num / self.ratio)

    num = math.max(num, 0)
    num = math.min(num, view.slider.maxValue)

    view.slider:SetValueWithoutNotify(num)
    self:onSliderChange(view.slider.value)
end

function PnlShop:onInputCostEndEdit(text)
    local view = self.view

    local num = tonumber(text)
    if not num then
        num = 0
    end

    num = math.max(num, 0)
    num = math.min(num, view.slider.maxValue)

    view.slider:SetValueWithoutNotify(num)
    self:onSliderChange(view.slider.value)
end

-- 

function PnlShop:onBtnRes(resId)
    local view = self.view
    for key, value in pairs(view.resMap) do
        if key == resId then
            value.imgChoose.gameObject:SetActiveEx(true)
            value.imgNotChoose.gameObject:SetActiveEx(false)
        else
            value.imgChoose.gameObject:SetActiveEx(false)
            value.imgNotChoose.gameObject:SetActiveEx(true)
        end
    end

    self:setExchangeInfo(resId)
end

function PnlShop:setExchangeInfo(targetRes)
    local view = self.view

    local resInfo = constant.RES_2_CFG_KEY[targetRes]

    local fromRes = resInfo.exchangeFrom
    self.targetRes = targetRes
    self.fromRes = fromRes

    gg.setSpriteAsync(self.view.imgBefore, constant.RES_2_CFG_KEY[fromRes].iconNameHead .. "Many")
    gg.setSpriteAsync(self.view.imgAfter, constant.RES_2_CFG_KEY[targetRes].iconNameHead .. "Many")

    self.view.textCostTitle.text = Utils.getText("shop_SpendSomething") ..
                                       Utils.getText(constant.RES_2_CFG_KEY[fromRes].languageKey)
    self.view.textGetTitle.text = Utils.getText("shop_GetSomething") ..
                                      Utils.getText(constant.RES_2_CFG_KEY[targetRes].languageKey)

    local exchangeInfo = ResData.exchangeData[fromRes]
    self.ratio = exchangeInfo[resInfo.exchangeKey]
    view.txtRate.text = "1:" .. self.ratio
    self:onRefreshResTxt()
    self:onSliderChange(self.view.slider.value)
end

function PnlShop:onExchangeRateChange()
    if self.showType == PnlShop.TYPE_EXCHANGE_TESSRACT or self.showType == PnlShop.TYPE_EXCHANGE_RES then
        self.view.layoutExchange:SetActiveEx(true)
        self:onBtnRes(self.targetRes)
    end
end

function PnlShop:onRefreshResTxt()
    local view = self.view
    view.slider.minValue = 0
    view.slider.maxValue = math.min(2000000, math.min(ResData.getRes(self.fromRes) / 1000))
    view.slider.value = view.slider.minValue
end

function PnlShop:onSliderChange(value)
    local val = math.floor(value)

    self.view.inputCost.text = val

    local getCount = math.floor(val * self.ratio)
    self.view.inputGet.text = getCount
end

function PnlShop:onBtnExchange()
    gg.uiManager:openWindow("PnlExchangeAlert", {
        res = self.targetRes,
        val = math.floor(self.view.slider.value) * 1000
    })

    -- ResData.C2S_Player_Exchange_Res(self.fromRes, math.floor(self.view.slider.value) * 1000, self.targetRes)
end

-----TYPE_BUILD_QUENE

function PnlShop:openBuildQuene()
    self.commonResBox2:showResList({constant.RES_TESSERACT})
    self.buildQueueBox:open()
end

function PnlShop:closeBuildQuene()
    self.buildQueueBox:close()
end

--------------TYPE_AUDIT_MONTH_CARD----------------------------
function PnlShop:openAuditMoonCard()
    self.commonResBox2:showResList({constant.RES_STARCOIN})
    self.auditMoonCardBox:open()
end

function PnlShop:closeAuditMoonCard()
    self.auditMoonCardBox:close()
end

------------------------------------------

function PnlShop:onHide()
    self:releaseEvent()
    self.commonResBox2:close()
end

function PnlShop:onPaySettle(event, isShow)
    -- self.view.layoutWait:SetActiveEx(isShow)
end

function PnlShop:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    for key, value in pairs(view.resMap) do
        self:setOnClick(value.btn, gg.bind(self.onBtnRes, self, key))
    end

    self:setOnClick(view.btnExchange, gg.bind(self.onBtnExchange, self))
    view.slider.onValueChanged:AddListener(gg.bind(self.onSliderChange, self))

    view.inputGet.onEndEdit:AddListener(gg.bind(self.onInputGetEndEdit, self))
    view.inputCost.onEndEdit:AddListener(gg.bind(self.onInputCostEndEdit, self))
end

function PnlShop:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    view.slider.onValueChanged:RemoveAllListeners()
    view.inputGet.onEndEdit:RemoveAllListeners()
    view.inputCost.onEndEdit:RemoveAllListeners()
end

function PnlShop:onDestroy()
    local view = self.view
    self.commonResBox2:release()
    self.viewOptionBtnBox:release()
    self.commonAddCountBox:release()

    self.tessractScrollView:release()
    self.moonCardBox:release()
    self.buildQueueBox:release()
    self.auditMoonCardBox:release()
end

function PnlShop:onBtnClose()
    self:close()
end

return PnlShop
