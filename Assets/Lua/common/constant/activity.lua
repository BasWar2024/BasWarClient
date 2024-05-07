
constant.ACTIVITY_REWARD_HERO = 1
constant.ACTIVITY_REWARD_RES = 2
constant.ACTIVITY_REWARD_ITEM = 3
constant.ACTIVITY_WARSHIP = 4
constant.ACTIVITY_BUILD = 5
-- constant.ACTIVITY_CARD = 5
constant.ACTIVITY_OTHER = 20

-- reward""：
-- {rewardType = constant.ACTIVITY_REWARD_HERO, cfgId = , quality = , level = }
-- {rewardType = constant.ACTIVITY_REWARD_RES,resId = , count = }
-- {rewardType = constant.ACTIVITY_REWARD_ITEM, cfgId = ,count = }
-- {rewardType = constant.ACTIVITY_WARSHIP, cfgId = effCfg.value[1], quality = effCfg.value[2], level = effCfg.value[3],}
-- {rewardType = constant.ACTIVITY_OTHER, icon = , quality = , count = ,}

-----------activities ""
constant.OPEN_PVP = 1                           --""pvp
constant.OPEN_UNION_REWARD = 13001

constant.OPEN_UNION = 2                         --""
constant.OPEN_UNION_REWARD = 13002

constant.FIRST_GET_GRID = 3                     --""
constant.FIRST_GET_GRID_REWARD = 13003


---------giftActivities ""

constant.CUMULATIVE_FUNDS = 1001                --""

constant.FIRST_CHARGE = 1003                --6""
constant.RECHARGE = 1004                --66""
constant.MOON_CARD = 1006                --""
constant.DAILY_CHECK = 1007                --""
constant.DAILY_GIFT = 1008                 -- ""
constant.LIMIT_TIME_SHOP = 1009                 -- ""
constant.NEW_PLAYER_LOGIN = 1010                 -- ""

---------""
constant.GIFT_EFFECT_WARSHIP = 101 -- ""
constant.GIFT_EFFECT_HERO = 201  -- ""
constant.GIFT_EFFECT_BUILD = 301  -- ""
constant.GIFT_EFFECT_CARD = 601  -- ""
constant.GIFT_EFFECT_RES = 701 -- ""

constant.GIFT_BUILDER_QUE_TIME = 901 -- ""


constant.ACTIVITY_TIMES_INFO = {
    [constant.CUMULATIVE_FUNDS] = {
        id = constant.CUMULATIVE_FUNDS,
        event = "onFirstGetGridRankChange"
    }
}
