

PnlRewardSmall = class("PnlRewardSmall", ggclass.UIBase)

PnlRewardSmall.closeType = ggclass.UIBase.CLOSE_TYPE_BG

function PnlRewardSmall:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlRewardSmall:onAwake()
    self.view = ggclass.PnlRewardSmallView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "RewardSmallItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function PnlRewardSmall:onRenderItem(obj, index)
    local item = RewardSmallItem:getItem(obj, self.itemList)
    local data = self.dataList[index]

    if data.rewardType == constant.ACTIVITY_REWARD_HERO then
        local heroCfg = HeroUtil.getHeroCfg(data.cfgId, data.level, data.quality)
        item:setData(string.format("Hero_A_Atlas[%s_A]", heroCfg.icon), data.quality, data.count)

    elseif data.rewardType == constant.ACTIVITY_REWARD_RES then
        item:setData(constant.RES_2_CFG_KEY[data.resId].icon, 0, Utils.getShowRes(data.count))

    elseif data.rewardType == constant.ACTIVITY_REWARD_ITEM then
        local itemCfg = cfg.item[data.cfgId]
        item:setData(string.format("Item_Atlas[%s]", itemCfg.icon), itemCfg.quality, data.count)
    end
end

-- args = {
--     rewardList = {
--         {rewardType = constant.ACTIVITY_REWARD_HERO,cfgId = ,quality = ,level = ,},
--         {rewardType = constant.ACTIVITY_REWARD_RES,resId = , count = ,},
--         {rewardType = constant.ACTIVITY_REWARD_ITEM,cfgId = ,count = ,},
--     },
--     yesCallback = ,
-- }

function PnlRewardSmall:onShow()
    self:bindEvent()

    self.dataList = self.args.rewardList
    self.scrollView:setItemCount(#self.dataList)
end

function PnlRewardSmall:onHide()
    self:releaseEvent()

end

function PnlRewardSmall:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(view.btnYes, gg.bind(self.onBtnYes, self))
end

function PnlRewardSmall:onBtnYes()
    if self.args.yesCallback then
        self.args.yesCallback()
    end

    self:close()
end

function PnlRewardSmall:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlRewardSmall:onDestroy()
    local view = self.view
    self.scrollView:release()
end

function PnlRewardSmall:onBtnClose()

end

---------------------------------

RewardSmallItem = RewardSmallItem or class("RewardSmallItem", ggclass.UIBaseItem)

function RewardSmallItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RewardSmallItem:onInit()
    self.commonNormalItem = CommonNormalItem.new(self:Find("CommonNormalItem"))
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
end

function RewardSmallItem:setData(icon, quality, count)
    self.commonNormalItem:setIcon(icon)
    self.commonNormalItem:setQuality(quality)

    if count then
        self.txtCount.text = "X" .. count
    else
        self.txtCount.text = "X1"
    end
end

return PnlRewardSmall