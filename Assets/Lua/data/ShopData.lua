ShopData = {}

ShopData.starPackMap = {}

ShopData.moreBuilderData = nil

-- ""
function ShopData.C2S_Player_BuyMoreBuilder(cfgId)
    gg.client.gameServer:send("C2S_Player_BuyMoreBuilder", {
        cfgId = cfgId,
    })
end

--""
function ShopData.S2C_Player_MoreBuilder(args)
    ShopData.moreBuilderData = args

    gg.event:dispatchEvent("onMoreBuilderChange")
end

--""
function ShopData.S2C_Player_TipNote(args)
    local rewardList = {}

    for key, value in pairs(args.resInfo) do
        table.insert(rewardList, {rewardType = constant.ACTIVITY_REWARD_RES, resId = value.resCfgId, count = value.count})
    end

    for key, value in pairs(args.items) do
        table.insert(rewardList, {rewardType = constant.ACTIVITY_REWARD_ITEM, cfgId = value.cfgId, count = value.num})
    end

    if args.tipType == 1 then
        gg.uiManager:openWindow("PnlTaskReward", {reward = rewardList})
    elseif args.tipType == 2 then
        gg.uiManager:openWindow("PnlReward", {rewards = rewardList})
    end
    gg.event:dispatchEvent("onRecycleRefreshData")
    -- ShopData.moreBuilderData = args
    -- gg.event:dispatchEvent("onMoreBuilderChange")
end

--""
function ShopData.S2C_Player_StarPack(args)
    ShopData.starPackMap = {}
    for key, value in pairs(args.data) do
        ShopData.starPackMap[value.cfgId] = value
    end
    gg.event:dispatchEvent("onStarPackChange")
end

