ActivityData = ActivityData or {}

ActivityData.activityOpenMap = {}

ActivityData.CumulativeFundsData = {}
ActivityData.DoubelRecharge = {}
ActivityData.RechargeData = {}
ActivityData.dailyCheckData = {}
ActivityData.dailyGift = {}
ActivityData.ShoppingMallData = {}
ActivityData.loginActivityInfo = {}

ActivityData.isAlreadyShowDailyCheckin = false

function ActivityData.clear()
    ActivityData.activityOpenMap = {}
    ActivityData.CumulativeFundsData = {}
    ActivityData.RechargeData = {}
    ActivityData.dailyCheckData = {}
    ActivityData.isAlreadyShowDailyCheckin = false
    ActivityData.loginActivityInfo = {}
end

-- ""
function ActivityData.C2S_Player_GetCumulativeFunds(cfgId)
    gg.client.gameServer:send("C2S_Player_GetCumulativeFunds", {
        cfgId = cfgId,
    })
end

function ActivityData.S2C_Player_CumulativeFunds(args)
    ActivityData.CumulativeFundsData = args

    ActivityData.CumulativeFundsData.infoMap = {}
    for index, value in ipairs(ActivityData.CumulativeFundsData.info) do
        ActivityData.CumulativeFundsData.infoMap[value.cfgId] = value
    end
    
    gg.event:dispatchEvent("onFirstGetGridRankChange")
    gg.event:dispatchEvent("onGiftActivitiesChange")
end

-- "" ""

function ActivityData.C2S_Player_GetRechargeReward(giftCfgId)
    gg.client.gameServer:send("C2S_Player_GetRechargeReward", {
        giftCfgId = giftCfgId,
    })
end

function ActivityData.S2C_Player_Recharge(args)
    args.rechargeVal = args.rechargeVal / 1000

    ActivityData.RechargeData = args
    gg.event:dispatchEvent("onRechargeChange")
    gg.event:dispatchEvent("onGiftActivitiesChange")
end

function ActivityData.S2C_Player_DoubelRecharge(args)
    local data = args.data

    ActivityData.DoubelRecharge = {}
    for k, v in pairs(data) do
        ActivityData.DoubelRecharge[v.productId] = v
    end

    gg.event:dispatchEvent("onRefreshTessractBuy")
end

--moonCard

function ActivityData.S2C_Player_MoonCard(args)
    ActivityData.MoonCard = args
    -- gg.printData(args)
    gg.event:dispatchEvent("onMoonCardChange")
end

-- ""

function ActivityData.C2S_Player_GetDailyReward(weekDay)
    gg.client.gameServer:send("C2S_Player_GetDailyReward", {
        weekDay = weekDay,
    })
end

function ActivityData.S2C_Player_DailyCheck(args) 
    -- args.flushTimeEnd = args.flushTimeEnd or 0
    args.flushTimeEnd = args.flushTime + os.time()
    ActivityData.dailyCheckData = args
    gg.event:dispatchEvent("onDailyChange")
end

function ActivityData.checkDailyCheckNeedOpen()
    if ActivityData.isAlreadyShowDailyCheckin or not ActivityData.dailyCheckData  then
        return
    end


    for key, value in pairs(ActivityData.dailyCheckData.data) do
        if value.isFirst == 1 and not gg.guideManager:isHardGuiding() then
            gg.uiManager:openWindow("PnlDailyCheck")
            ActivityData.isAlreadyShowDailyCheckin = true
            break
        end
    end
end

function ActivityData.S2C_Player_DailyGift(args)
    ActivityData.dailyGift = {}
    for i, v in ipairs(args.data) do
        if v.num > 0 then
            table.insert(ActivityData.dailyGift, v)
        end
    end

    gg.event:dispatchEvent("onRefreshActivityGiftBox")
end

-- ""

function ActivityData.S2C_Player_ShoppingMall(args)
    ActivityData.ShoppingMallData = args
    gg.event:dispatchEvent("onShoppingMailChange")
end

-- ""
function ActivityData.C2S_Player_BuyGoods(index)
    gg.client.gameServer:send("C2S_Player_BuyGoods", {
        index = index,
    })
end

--""
function ActivityData.C2S_Player_FreshShoppingMall()
    gg.client.gameServer:send("C2S_Player_FreshShoppingMall", {})
end


--""
-- message LoginReward {
--     int32 day = 1;   // cfgId
--     int32 baseStatus = 2;   // -1"" 0"" 1""
--     int32 advStatus = 3;  //   -2"", -1"",  0"" 1""
-- }

function ActivityData.S2C_Player_LoginActivityInfo(args)
    -- args.endTime = Utils.getServerSec() + 10

    ActivityData.loginActivityInfo = args
    ActivityData.activityOpenMap[constant.NEW_PLAYER_LOGIN] = ActivityUtil.checkGiftActivitiesOpen(cfgId)
    gg.event:dispatchEvent("onLoginActivityInfoChange")
end

function ActivityData.C2S_Player_GetLoginActReward(day)
    gg.client.gameServer:send("C2S_Player_GetLoginActReward", {
        day = day
    })
end

----------------

--""
function ActivityData.C2S_Player_UnlockLoginAdv(day)
    gg.client.gameServer:send("C2S_Player_UnlockLoginAdv", {
        day = day,
    })
end

