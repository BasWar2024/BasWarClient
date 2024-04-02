PnlPay = class("PnlPay", ggclass.UIBase)

function PnlPay:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.information
    self.events = {"onClosePnlPay"}
end

function PnlPay:onAwake()
    self.view = ggclass.PnlPayView.new(self.pnlTransform)

    -- self.viewOptionBtnBox = ViewOptionBtnBox.new(self.view.fullViewOptionBtnBox)
end

function PnlPay:onShow()
    self:bindEvent()
    local productId = self.args.productId
    local productCfg = ShopUtil.getProduct(productId)
    self.view.txtName.text = Utils.getText(productCfg.name)
    self.view.txtCost.text = string.format("$%s", productCfg.price)
    local iconName = gg.getSpriteAtlasName("ShopIcon_Atlas", productCfg.icon)
    gg.setSpriteAsync(self.view.iconItem, iconName)

    self:loadBoxPia()
    -- self.payChannelInfo = PlayerData.payChannelInfo
    -- table.sort(self.payChannelInfo)
    -- local datas = {}

    -- for k, v in pairs(self.payChannelInfo) do
    --     local data = {
    --         name = v.name,
    --         callback = gg.bind(self.refresh, self, k)
    --     }

    --     table.insert(datas, data)
    -- end

    -- self.viewOptionBtnBox:setBtnDataList(datas, 1)

end

function PnlPay:loadBoxPia()
    self:releaseBoxPia()
    self.payChannelInfo = {}
    for k, v in pairs(PlayerData.payChannelInfo) do
        v.key = k
        if k == "pay_xsolla" then
            v.sort = 10
        elseif k == "pay_internation" then
            v.sort = 9
        elseif k == "pay_local" then
            v.sort = 1
        else
            v.sort = 2
        end
        table.insert(self.payChannelInfo, v)
    end
    QuickSort.quickSort(self.payChannelInfo, "sort", 1, #self.payChannelInfo)
    local maxCound = #self.payChannelInfo
    local num = 0
    self.boxPiaList = {}
    for k, v in pairs(self.payChannelInfo) do
        ResMgr:LoadGameObjectAsync("BoxPia", function(go)
            go.transform:SetParent(self.view.pia, false)
            go.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = v.name
            go.transform:Find("ImgSel").gameObject:SetActiveEx(false)

            self.boxPiaList[k] = go
            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:refresh(k)
            end)
            num = num + 1
            if num == maxCound then
                self:refresh(1)
            end
            return true
        end, true)
    end

end

function PnlPay:releaseBoxPia()
    if self.boxPiaList then
        for k, v in pairs(self.boxPiaList) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.boxPiaList = nil
    end
end

function PnlPay:refresh(key)
    for k, v in pairs(self.boxPiaList) do
        if key== k then
            v.transform:Find("ImgSel").gameObject:SetActiveEx(true)
        else
            v.transform:Find("ImgSel").gameObject:SetActiveEx(false)
        end
    end
    self:releasePayToggle()

    self.key = self.payChannelInfo[key].key
    self.currencyKey = nil
    self.payTypeKey = nil
    local currency = {}
    local payType = self.payChannelInfo[key].payType

    for k, v in pairs(self.payChannelInfo[key].currency) do
        local data = {
            key = k,
            data = v
        }
        if k == "USD" then
            table.insert(currency, 1, data)
        else
            table.insert(currency, data)
        end
    end

    table.sort(payType)


    self.currencyPayToggleList = {}
    self.payTypePayToggleList = {}
    local isFirstCurrency = true
    local index = 0
    local max = #currency
    self.view.currency.gameObject:SetActiveEx(false)
    for k, v in pairs(currency) do
        local temp = index
        index = index + 1
        ResMgr:LoadGameObjectAsync("PayToggle", function(go)
            go.transform:SetParent(self.view.currency, false)
            local x = temp * 109 + 70
            go.transform.localPosition = Vector3(x, -9, 0)
            local toggle = go.transform:Find("PayToggle"):GetComponent(UNITYENGINE_UI_TOGGLE)
            if isFirstCurrency then
                isFirstCurrency = false
                toggle.isOn = true
                self.currencyKey = v.key
            else
                toggle.isOn = false
            end
            go.transform:GetComponent(UNITYENGINE_UI_TEXT).text = v.key

            CS.UIEventHandler.Get(toggle.gameObject):SetOnClick(function()
                self:onBtnPayToggle(v.key, 1)
            end)
            self.currencyPayToggleList[v.key] = go

            if index == max then
                self.view.currency.gameObject:SetActiveEx(true)
            end
            return true
        end, true)
    end
    local isFirstPayType = true
    for k, v in pairs(payType) do
        ResMgr:LoadGameObjectAsync("PayToggle", function(go)
            go.transform:SetParent(self.view.PayType, false)
            local toggle = go.transform:Find("PayToggle"):GetComponent(UNITYENGINE_UI_TOGGLE)
            if isFirstPayType then
                isFirstPayType = false
                toggle.isOn = true
                self.payTypeKey = k
            else
                toggle.isOn = false
            end

            go.transform:GetComponent(UNITYENGINE_UI_TEXT).text = k

            CS.UIEventHandler.Get(toggle.gameObject):SetOnClick(function()
                self:onBtnPayToggle(k, 2)
            end)

            self.payTypePayToggleList[k] = go
            return true
        end, true)
    end

end

function PnlPay:releasePayToggle()
    if self.currencyPayToggleList then
        for k, v in pairs(self.currencyPayToggleList) do
            v.transform:Find("PayToggle"):GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
            v.transform:GetComponent(UNITYENGINE_UI_TEXT).text = ""
            CS.UIEventHandler.Clear(v.transform:Find("PayToggle").gameObject)
            ResMgr:ReleaseAsset(v)
        end
        self.currencyPayToggleList = nil
    end

    if self.payTypePayToggleList then
        for k, v in pairs(self.payTypePayToggleList) do
            v.transform:Find("PayToggle"):GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
            v.transform:GetComponent(UNITYENGINE_UI_TEXT).text = ""
            CS.UIEventHandler.Clear(v.transform:Find("PayToggle").gameObject)
            ResMgr:ReleaseAsset(v)
        end
        self.payTypePayToggleList = nil
    end

end

function PnlPay:onHide()
    self:releaseEvent()

    self.payChannelInfo = nil
end

function PnlPay:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnCommit):SetOnClick(function()
        self:onBtnCommit()
    end)
end

function PnlPay:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnCommit)

    self:releasePayToggle()
    self:releaseBoxPia()
end

function PnlPay:onDestroy()
    local view = self.view

    -- self.viewOptionBtnBox:release()

end

function PnlPay:onBtnClose()
    self:close()
end

function PnlPay:onBtnCommit()
    local account = gg.playerMgr.localPlayer:getAccount()
    local pId = gg.playerMgr.localPlayer:getPid()
    local productId = self.args.productId

    -- print("key:", self.key, "currencyKey:", self.currencyKey, "payTypeKey:", self.payTypeKey, "account:", account,
    --     "pId:", pId, "productId:", productId)

    gg.client.loginServer:payReady(self.key, self.currencyKey, self.payTypeKey, account, pId, productId)
end

function PnlPay:onBtnPayToggle(key, type)
    local list = self.currencyPayToggleList
    if type == 2 then
        list = self.payTypePayToggleList
    end
    if list then
        for k, v in pairs(list) do
            v.transform:Find("PayToggle"):GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        end
        list[key].transform:Find("PayToggle"):GetComponent(UNITYENGINE_UI_TOGGLE).isOn = true
        if type == 1 then
            self.currencyKey = key
        else
            self.payTypeKey = key
        end
    end
end

function PnlPay:onClosePnlPay()
    self:close()
end

return PnlPay
