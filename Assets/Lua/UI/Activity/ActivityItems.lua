
ActivityRewardItem = ActivityRewardItem or class("ActivityRewardItem", ggclass.UIBaseItem)

function ActivityRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ActivityRewardItem:onInit()
    self.commonNormalItem = CommonNormalItem.new(self:Find("CommonNormalItem"))
end

function ActivityRewardItem:setData(reward)
    if reward.rewardType == constant.ACTIVITY_REWARD_HERO then
        local heroCfg = HeroUtil.getHeroCfg(reward.cfgId, reward.level, reward.quality)
        self.commonNormalItem:setQuality(reward.quality)
        self.commonNormalItem:setIcon(string.format("Hero_A_Atlas[%s_A]", heroCfg.icon))

    elseif reward.rewardType == constant.ACTIVITY_REWARD_RES then

        self.commonNormalItem:setQuality(0)
        self.commonNormalItem:setIcon(constant.RES_2_CFG_KEY[reward.resId].icon)

    elseif reward.rewardType == constant.ACTIVITY_REWARD_ITEM then
        local itemCfg = cfg.item[reward.cfgId]
        self.commonNormalItem:setQuality(itemCfg.quality)
        self.commonNormalItem:setIcon()

        local icon = ItemUtil.getItemIcon(reward.cfgId)
        self.commonNormalItem:setIcon(icon)
    elseif reward.rewardType == constant.ACTIVITY_BUILD then
        local buildCfg = BuildUtil.getCurBuildCfg(reward.cfgId, reward.level, reward.quality)
        self.commonNormalItem:setQuality(buildCfg.quality)
        self.commonNormalItem:setIcon(string.format("Build_A_Atlas[%s_A]", buildCfg.icon))

    elseif reward.rewardType == constant.ACTIVITY_OTHER then
        self.commonNormalItem:setQuality(reward.quality)
        self.commonNormalItem:setIcon(reward.icon)
    end
end

function ActivityRewardItem:setItemCfgId(itemCfgId)
    local itemCfg = cfg.item[itemCfgId]

    local icon = ItemUtil.getItemIcon(itemCfgId)

    self.commonNormalItem:setQuality(itemCfg.quality)
    self.commonNormalItem:setIcon(icon)
end

function ActivityRewardItem:onRelease()
    self.commonNormalItem:release()
end