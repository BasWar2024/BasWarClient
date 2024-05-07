InAppPurchaseManager = class("InAppPurchaseManager")

-- "":payReady->onPayReady""->""order""->paySettle->onPaySettle""order""
local cjson = require "cjson"

function InAppPurchaseManager:ctor()
    if CS.Appconst.platform == constant.PLATFORM_4 or CS.Appconst.platform == constant.PLATFORM_5 then
        local products = {}
        for key, value in pairs(cfg.product) do
            local data = {
                id = value.productId,
                productType = 0
            }
            table.insert(products, data)
        end

        self.purchaseManager = global:AddComponent(typeof(CS.PurchaseManager))

        self.purchaseManager.PurchaseComplete = function(product)
            self:onPurchaseComplete(product)
        end

        self.purchaseManager.PurchaseFailed = function(product, purchaseFailureReason)
            self:onPurchaseFailed(product, purchaseFailureReason)
        end

        self.purchaseManager:StartInitPurchase(products, 123456)

        gg.event:addListener("onPurchaseClicked", self)
        gg.event:addListener("onIapPaySettle", self)
        gg.event:addListener("onReIapPaySettle", self)
        -- CS.UnityEngine.PlayerPrefs.SetString(InAppPurchaseManager.DATAKEY, "")
        self.isReIap = true
    end
end

function InAppPurchaseManager:paySettle(orderId, productId, payload, playerId)
    if playerId == self.playerId and payload then
        if CS.Appconst.platform == constant.PLATFORM_4 then
            local payloadData = cjson.decode(payload)
            print("aaaaa11111", table.dump(payloadData))
            print("aaaaa22222", table.dump(payloadData.json))
            print("aaaaa33333", table.dump(payloadData.signature))
            gg.client.loginServer:paySettle(orderId, PlayerData.enterGameInfo.account, productId, nil, payloadData.json,
                payloadData.signature)
            return true
        elseif CS.Appconst.platform == constant.PLATFORM_5 then
            gg.client.loginServer:paySettle(orderId, PlayerData.enterGameInfo.account, productId, payload, nil, nil)
            return true
        else
            return false
        end
    end
    return false
end

function InAppPurchaseManager:onPurchaseClicked(args, order)
    print("aaaaonPurchaseClicked")
    self:savePurchaseData(true, order.orderId, order.productId)
    self.purchaseManager:OnPurchaseClicked(order.productId, order.orderId)
end

function InAppPurchaseManager:onPurchaseComplete(product)
    print("aaaaonPurchaseComplete")
    gg.uiManager:onClosePnlLink("LoginServer_payReady")
    -- product.receipt:{"Payload":"{}","Store":"","TransactionID":""}
    local productId = product.definition.id
    local datas = self:getPurchaseDatas()
    local newTime = 0
    local key = nil
    if datas then
        for k, v in pairs(datas) do
            if v.productId == productId and v.playerId == self.playerId and not v.payload and v.time > newTime then
                newTime = v.time
                key = k
            end
        end
        if key and datas[key] then
            local order = datas[key]
            local receipt = cjson.decode(product.receipt)
            self:savePurchaseData(true, order.orderId, productId, receipt.Payload)
            self:paySettle(order.orderId, productId, receipt.Payload, self.playerId)
        end
    end
end

function InAppPurchaseManager:onPurchaseFailed(product, purchaseFailureReason)
    print("aaaaonPurchaseFailed")
    gg.uiManager:onClosePnlLink("LoginServer_payReady")

    local productId = product.definition.id
    local order = nil
    local datas = self:getPurchaseDatas()
    if datas then
        for k, v in pairs(datas) do
            if v.productId == productId and v.playerId == self.playerId then
                order = v
                break
            end
        end
    end
    if order then
        self:savePurchaseData(false, order.orderId)
    end
end

function InAppPurchaseManager:onIapPaySettle(args, orderId)
    print("aaaaonIapPaySettle")
    self:savePurchaseData(false, orderId)

    self:restartIapPaySettle()
end

function InAppPurchaseManager:onReIapPaySettle()
    self.playerId = gg.playerMgr.localPlayer:getPid()
    -- print("aaaa", self.playerId)
    if self.isReIap then
        self:clearInvalidPurchaseDatas()
        self:restartIapPaySettle()
    end

    self.isReIap = false
end

function InAppPurchaseManager:restartIapPaySettle()
    local datas = self:getPurchaseDatas()
    print("restartIapPaySettle", table.dump(datas))
    if datas then
        for key, value in pairs(datas) do
            if self:paySettle(value.orderId, value.productId, value.payload, value.playerId) then
                break
            end
        end
    end
end

InAppPurchaseManager.DATAKEY = "InAppPurchaseDataKey"

function InAppPurchaseManager:savePurchaseData(isSave, orderId, productId, payload)
    print("aaaaasavePurchaseData", isSave, orderId)
    local datas = self:getPurchaseDatas()

    if not datas then
        datas = {}
    end

    if isSave then
        datas[orderId] = {
            orderId = orderId,
            productId = productId,
            payload = payload,
            playerId = self.playerId,
            time = Utils.getServerSec()
        }
    else
        datas[orderId] = nil
    end

    local saveData = cjson.encode(datas)
    -- print("aaaaadatas", table.dump(datas))
    print("aaaaasaveData", saveData)
    CS.UnityEngine.PlayerPrefs.SetString(InAppPurchaseManager.DATAKEY, saveData)
    CS.UnityEngine.PlayerPrefs.Save()
end

function InAppPurchaseManager:getPurchaseDatas()
    if CS.UnityEngine.PlayerPrefs.HasKey(InAppPurchaseManager.DATAKEY) then
        local json = CS.UnityEngine.PlayerPrefs.GetString(InAppPurchaseManager.DATAKEY)
        if not json or json == "" then
            return nil
        end
        local datas = cjson.decode(json)
        return datas
    else
        return nil
    end
end

function InAppPurchaseManager:clearInvalidPurchaseDatas()
    local datas = self:getPurchaseDatas()
    -- print("aaaaclearInvalidPurchaseDatas1111", table.dump(datas))
    if not datas then
        local orderIds = {}
        for key, value in pairs(datas) do
            if not value.time or Utils.getServerSec() - value.time >= 259200 then
                table.insert(orderIds, value.orderId)
            end
        end
        if #orderIds > 0 then
            for key, value in pairs(orderIds) do
                datas[value] = nil
            end
            -- print("aaaaclearInvalidPurchaseDatas2222", table.dump(datas))
            local saveData = cjson.encode(datas)
            CS.UnityEngine.PlayerPrefs.SetString(InAppPurchaseManager.DATAKEY, saveData)
            CS.UnityEngine.PlayerPrefs.Save()
        end
    end
end
