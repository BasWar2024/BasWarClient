ShopUtil = ShopUtil or {}

function ShopUtil.getProduct(productId)
    local productCfg = nil

    for key, value in pairs(cfg.product) do
        if value.productId == productId then
            productCfg = value
        end
    end
    return productCfg
end

function ShopUtil.buyProduct(productId)
    -- gg.client.loginServer:payReady(constant.PAYCHANNEL_LOCAL, PlayerData.enterGameInfo.account, PlayerData.myInfo.pid, productId, "ext")
    if CS.Appconst.platform ~= constant.PLATFORM_4 and CS.Appconst.platform ~= constant.PLATFORM_5 then
        local args = {
            productId = productId
        }
        gg.uiManager:openWindow("PnlPay", args)
    else
        local account = gg.playerMgr.localPlayer:getAccount()
        local pId = gg.playerMgr.localPlayer:getPid()
        if CS.Appconst.platform == constant.PLATFORM_4 then
            gg.client.loginServer:payReady(constant.PAYCHANNEL_GOOGLEPLAY, "USD", "googleplay", account, pId, productId)
        elseif CS.Appconst.platform == constant.PLATFORM_5 then
            gg.client.loginServer:payReady(constant.PAYCHANNEL_APPSTORE, "USD", "appstore", account, pId, productId)
        end
    end
end

function ShopUtil.parseProductReward(productId)
    local productCfg = ShopUtil.getProduct(productId)

    if not productCfg then
        return {}
    end

    local rewardList = {}

    if productCfg.value > 0 then
        table.insert(rewardList, {
            rewardType = constant.ACTIVITY_REWARD_RES,
            resId = constant.RES_TESSERACT,
            count = productCfg.value
        })
    end

    if productCfg.itemCfgId and productCfg.itemCfgId > 0 then
        local itemRewardList = ShopUtil.parseItemEffect(productCfg.itemCfgId)
        for index, value in ipairs(itemRewardList) do
            table.insert(rewardList, value)
        end
    end

    return rewardList
end

function ShopUtil.parseItemEffect(itemCfgId)
    local rewardList = {}
    local itemCfg = cfg.item[itemCfgId]

    for key, value in pairs(itemCfg.effect) do
        local effCfg = cfg.itemEffect[value]

        if effCfg.effectType == constant.GIFT_EFFECT_RES then
            table.insert(rewardList, {
                rewardType = constant.ACTIVITY_REWARD_RES,
                resId = effCfg.value[1],
                count = effCfg.value[2]
            })

        elseif effCfg.effectType == constant.GIFT_EFFECT_HERO then
            table.insert(rewardList, {
                rewardType = constant.ACTIVITY_REWARD_HERO,
                cfgId = effCfg.value[1],
                quality = effCfg.value[2],
                level = effCfg.value[3],
                count = 1,
            })

        elseif effCfg.effectType == constant.GIFT_EFFECT_WARSHIP then
            table.insert(rewardList, {
                rewardType = constant.ACTIVITY_WARSHIP,
                cfgId = effCfg.value[1],
                quality = effCfg.value[2],
                level = effCfg.value[3],
                count = 1
            })

        elseif effCfg.effectType == constant.GIFT_EFFECT_CARD then
            table.insert(rewardList, {
                rewardType = constant.ACTIVITY_REWARD_ITEM,
                cfgId = effCfg.value[1],
                count = effCfg.value[2]
            })
        elseif effCfg.effectType == constant.GIFT_EFFECT_BUILD then
            table.insert(rewardList, {
                rewardType = constant.ACTIVITY_BUILD,
                cfgId = effCfg.value[1],
                quality = effCfg.value[2],
                level = effCfg.value[3],
                count = 1,
            })
        end
    end

    return rewardList
end

function ShopUtil.parseReward(reward)
    local icon
    local count = reward.count or 1
    local name = ""
    local quality = 0

    if reward.rewardType == constant.ACTIVITY_REWARD_RES then
        icon = constant.RES_2_CFG_KEY[reward.resId].icon
        count = Utils.getShowRes(count)

        local resInfo = constant.RES_2_CFG_KEY[reward.resId]
        name = Utils.getText(resInfo.languageKey)

    elseif reward.rewardType == constant.ACTIVITY_REWARD_HERO then

        local heroCfg = HeroUtil.getHeroCfg(reward.cfgId, reward.level, reward.quality)
        icon = string.format("Hero_A_Atlas[%s_A]", heroCfg.icon)

        name = Utils.getText(heroCfg.languageNameID)

        quality = heroCfg.quality

    elseif reward.rewardType == constant.ACTIVITY_WARSHIP then
        local warshipCfg = WarshipUtil.getWarshipCfg(reward.cfgId, reward.quality, reward.level)
        icon = string.format("Warship_A_Atlas[%s_A]", warshipCfg.icon)
        name = Utils.getText(warshipCfg.languageNameID)
        quality = warshipCfg.quality

    elseif reward.rewardType == constant.ACTIVITY_REWARD_ITEM then
        local itemCfg = cfg.item[reward.cfgId]

        icon = ItemUtil.getItemIcon(reward.cfgId)
        -- if itemCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES then
        --     icon = string.format("Skill_A1_Atlas[%s_A1]", itemCfg.icon)
        -- else
        --     icon = string.format("Item_Atlas[%s]", itemCfg.icon)
        -- end
        name = Utils.getText(itemCfg.languageNameID)
        quality = itemCfg.quality

    elseif reward.rewardType == constant.ACTIVITY_BUILD then
        local buildCfg = BuildUtil.getCurBuildCfg(reward.cfgId, reward.level, reward.quality)
        icon = string.format("Build_A_Atlas[%s_A]", buildCfg.icon)
        name = Utils.getText(buildCfg.languageNameID)
        quality = buildCfg.quality
    end

    return icon, count, name, quality
end
