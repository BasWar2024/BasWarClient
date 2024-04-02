local ResBoat = class("ResBoat")

function ResBoat:ctor(boatData)
    self.boatObj = nil
    self.boatAnim = nil
    self.boatData = {}
    self.boatIds = {}
    self.boatRes = {}
    self:setBoatData(boatData)
    self:loadBoat()
end

function ResBoat:setBoatData(boatData)
    self.boatData = {}
    self.boatIds = {}
    self.boatRes = {}
    self.boatData = boatData
    for k, v in pairs(self.boatData) do
        table.insert(self.boatIds, v.boatId)
    end
    self.boatRes = self:lookBoatRes(boatData)
end

function ResBoat:lookBoatRes(boatData)
    local boatRes = {}
    for i, data in pairs(boatData) do
        local items = data.items
        for j, item in pairs(items) do
            local count = 0
            if boatRes[constant.RES_ITEM] then
                count = boatRes[constant.RES_ITEM].count
            end
            count = count + 1
            local data = {
                key = constant.RES_ITEM,
                count = count
            }
            boatRes[constant.RES_ITEM] = data
        end
        local currencies = data.currencies
        for k, currencie in pairs(currencies) do
            local resCfgId = currencie.resCfgId
            local count = 0
            if boatRes[resCfgId] then
                count = boatRes[resCfgId].count
            end
            count = count + currencie.count
            local data = {
                key = resCfgId,
                count = count
            }
            boatRes[resCfgId] = data
        end
    end
    return boatRes
end

function ResBoat:loadBoat()
    ResMgr:LoadGameObjectAsync("ResBoat", function(obj)
        self.boatObj = obj
        if gg.buildingManager.ownBase then
            obj.transform:SetParent(gg.buildingManager.ownBase.transform)
        end
        self.boatAnim = self.boatObj.transform:GetComponent("Animator")
        self:onShow()
        return true
    end, true)
end

function ResBoat:onLoadOwnBase()
    if self.boatObj then
        self.boatObj.transform:SetParent(gg.buildingManager.ownBase.transform)
    end
end

function ResBoat:unLoadBoat()
    self:stopUpdataTimer()
    self:releaseEvent()
    ResMgr:ReleaseAsset(self.boatObj)
    self.boatObj = nil
    self.boatAnim = nil
    self.boatData = {}
    self.boatIds = {}
    self.boatRes = {}
end

function ResBoat:onShow()
    -- self.boatAnim:SetTrigger("come")
    gg.event:dispatchEvent("onShowBoatRes", self.boatObj.transform:Find("OperPoint").gameObject)
    self:bindEvent()
    -- self:startUpdataTimer()
end

function ResBoat:stopUpdataTimer()
    if self.updateTimer then
        gg.timer:stopTimer(self.updateTimer)
        self.updateTimer = nil
    end
end

function ResBoat:startUpdataTimer()
    self:stopUpdataTimer()
    self.updateTimer = gg.timer:startLoopTimer(0, 0.03, -1, function()
        gg.event:dispatchEvent("onUpdataMove")
    end)
end

function ResBoat:bindEvent()
    CS.UIEventHandler.Get(self.boatObj):SetOnClick(function()
        self:onClickBoat()
    end)

    gg.event:addListener("onLoadOwnBase", self)
    gg.event:addListener("onClickBoat", self)
    gg.event:addListener("onCollectSuccessful", self)
    -- gg.event:addListener("onDestroyResBoat", self)
end

function ResBoat:releaseEvent()
    CS.UIEventHandler.Clear(self.boatObj)

    gg.event:removeListener("onClickBoat", self)
    gg.event:removeListener("onCollectSuccessful", self)
    gg.event:removeListener("onLoadOwnBase", self)
    -- gg.event:removeListener("onDestroyResBoat", self)
end

function ResBoat:onClickBoat()
    if next(self.boatRes) then
        if self:getCurAnim("boatStay") and self:lookResStore() then
            ResPlanetData.C2S_Player_PickBoatRes(self.boatIds)
        else
            self:collectFalse()
            gg.uiManager:openWindow("PnlBoard")
        end
    else
        gg.uiManager:openWindow("PnlBoard")
    end
end

function ResBoat:lookResStore()
    local bool = false
    if ResData.getStarCoin() < gg.buildingManager.resMax[constant.RES_STARCOIN] then
        if self.boatRes[constant.RES_STARCOIN] then
            bool = true
        end
    end
    if ResData.getIce() < gg.buildingManager.resMax[constant.RES_ICE] then
        if self.boatRes[constant.RES_ICE] then
            bool = true
        end
    end
    if ResData.getCarboxyl() < gg.buildingManager.resMax[constant.RES_CARBOXYL] then
        if self.boatRes[constant.RES_CARBOXYL] then
            bool = true
        end
    end
    if ResData.getTitanium() < gg.buildingManager.resMax[constant.RES_TITANIUM] then
        if self.boatRes[constant.RES_TITANIUM] then
            bool = true
        end
    end
    if ResData.getGas() < gg.buildingManager.resMax[constant.RES_GAS] then
        if self.boatRes[constant.RES_GAS] then
            bool = true
        end
    end
    local maxSpace = ItemData.maxSpace + ItemData.expandSpace
    local num = 0
    for k, v in pairs(ItemData.itemBagData) do
        num = num + 1
    end
    if num < maxSpace then
        if self.boatRes[constant.RES_ITEM] then
            bool = true
        end
    end

    return bool
end

function ResBoat:onCollectSuccessful(args, boats)
    local bool = true
    local boatRes = self:lookBoatRes(boats)
    for k, v in pairs(self.boatRes) do
        if not boatRes[v.key] then
            bool = false
            break
        end
        local dif = v.count - boatRes[v.key].count
        if dif > 0 then
            bool = false
            break
        end
    end

    if bool then
        gg.event:dispatchEvent("onCollectBoatResSuccessful")
        -- self.boatAnim:SetTrigger("leave")
        self:startReleaseTimer()
    else
        self:collectFalse()
    end
end

function ResBoat:collectFalse()
    gg.uiManager:showTip("Resources is full, please upgrade the warehouse.")
    gg.event:dispatchEvent("onSetCanNotCollectBoat")
end

function ResBoat:getCurAnim(animName)
    return self.boatAnim:GetCurrentAnimatorStateInfo(0):IsName(animName)
end

function ResBoat:startReleaseTimer()
    self:stopReleaseTimer()
    self.releaseTimer = gg.timer:startLoopTimer(0, 0.1, -1, function()
        if self:getCurAnim("boatOut") then
            self:unLoadBoat()
            self:stopReleaseTimer()
        end
    end)
end

function ResBoat:stopReleaseTimer()
    if self.releaseTimer then
        gg.timer:stopTimer(self.releaseTimer)
        self.releaseTimer = nil
    end
end

function ResBoat:onDestroyResBoat()
    self:stopReleaseTimer()
    self:unLoadBoat()
end

return ResBoat
