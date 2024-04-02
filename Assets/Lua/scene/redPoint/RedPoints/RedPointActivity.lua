RedPointActivity = class("RedPointActivity", ggclass.RedPointBase)

function RedPointActivity:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointActivity:onCheck()
    return false
end

---------------------------------------------

RedPointDailyCheckIn = class("RedPointDailyCheckIn", ggclass.RedPointBase)

function RedPointDailyCheckIn:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointActivity}, {"onDailyChange"})
end

function RedPointDailyCheckIn:onCheck()
    for key, value in pairs(ActivityData.dailyCheckData.data) do
        if value.status == 1 then
            return true
        end
    end

    return false
end

---------------------------------------------

RedPointAccruingTes = class("RedPointAccruingTes", ggclass.RedPointBase)

function RedPointAccruingTes:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointActivity}, {})
end

function RedPointAccruingTes:onCheck()
    -- if not ActivityUtil.checkGiftActivitiesOpen(constant.CUMULATIVE_FUNDS) then
    --     return false
    -- end

    -- local isBuy100 = ActivityData.CumulativeFundsData.funds100 == 1
    -- local isBuy300 =  ActivityData.CumulativeFundsData.funds300 == 1

    -- local baseLevel = gg.buildingManager:getBaseLevel()


    -- for key, value in pairs(cfg.cumulativeFunds) do

    --     local subData = ActivityData.CumulativeFundsData.infoMap[value.cfgId] or {cfgId = value.cfgId, status = 0}

    --     if value.baseLevel <= baseLevel then

    --         local isCanFetch = subData.status == 0 and (value.cost == 100 and isBuy100 or value.cost == 300 and isBuy300)

    --         if isCanFetch then
    --             return true
    --         end
    --     end
    -- end

    return false
end

-------------------------------------------------------

RedPointAccruing3Times = class("RedPointAccruing3Times", ggclass.RedPointBase)

function RedPointAccruing3Times:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointAccruingTes}, {"onGiftActivitiesChange", "onBaseChange"})
end

function RedPointAccruing3Times:onCheck()
    if not ActivityUtil.checkGiftActivitiesOpen(constant.CUMULATIVE_FUNDS) then
        return false
    end

    local isBuy100 = ActivityData.CumulativeFundsData.funds100 == 1

    local baseLevel = gg.buildingManager:getBaseLevel()

    for key, value in pairs(cfg.cumulativeFunds) do

        local subData = ActivityData.CumulativeFundsData.infoMap[value.cfgId] or {cfgId = value.cfgId, status = 0}
        if value.baseLevel <= baseLevel then
            local isCanFetch = subData.status == 0 and value.cost == 100 and isBuy100
            if isCanFetch then
                return true
            end
        end
    end
    return false
end

------------------------------------------------------------------------------------

RedPointAccruing5Times = class("RedPointAccruing5Times", ggclass.RedPointBase)

function RedPointAccruing5Times:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointAccruingTes}, {"onGiftActivitiesChange", "onBaseChange"})
end

function RedPointAccruing5Times:onCheck()
    if not ActivityUtil.checkGiftActivitiesOpen(constant.CUMULATIVE_FUNDS) then
        return false
    end

    local isBuy300 =  ActivityData.CumulativeFundsData.funds300 == 1

    local baseLevel = gg.buildingManager:getBaseLevel()

    for key, value in pairs(cfg.cumulativeFunds) do

        local subData = ActivityData.CumulativeFundsData.infoMap[value.cfgId] or {cfgId = value.cfgId, status = 0}
        if value.baseLevel <= baseLevel then
            local isCanFetch = subData.status == 0 and  value.cost == 300 and isBuy300
            if isCanFetch then
                return true
            end
        end
    end

    return false
end

------------------------------------------------------------------------------------

RedPointActFirstCharge = class("RedPointActFirstCharge", ggclass.RedPointBase)

function RedPointActFirstCharge:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointActivity}, {"onGiftActivitiesChange"})
end

function RedPointActFirstCharge:onCheck()
    if not ActivityUtil.checkGiftActivitiesOpen(constant.FIRST_CHARGE) then
        return false
    end

    return ActivityData.RechargeData.firstRec == 0 and ActivityData.RechargeData.rechargeVal >= cfg.global.FirstRecharge.floatValue
end

------------------------------------------------------------------------------------

RedPointActRecharge = class("RedPointActRecharge", ggclass.RedPointBase)

function RedPointActRecharge:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointActivity}, {"onRechargeChange"})
end

function RedPointActRecharge:onCheck()
    if not ActivityUtil.checkGiftActivitiesOpen(constant.RECHARGE) then
        return false
    end
    return ActivityData.RechargeData.rechargeStat == 0 and ActivityData.RechargeData.rechargeVal >= cfg.global.Recharge.floatValue
end